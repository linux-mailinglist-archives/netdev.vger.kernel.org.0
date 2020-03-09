Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB4DB17DA2F
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 09:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgCIIEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 04:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbgCIIEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 04:04:45 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E930520728;
        Mon,  9 Mar 2020 08:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583741084;
        bh=tzvQUC46xoDI45wBhSfB1RJ1Bxin/b6pFZjKVMf4d5Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xlOscqSOrA0RwAdBvfAHoW2tIuDl3DgQvcky525g7NO14EPt562/aknLdji474CAA
         CRVKER3Qc3Sw4OtkA/89oc9sNFprgb2b5vdfoBhrg2S/IULB86bRzsWsjwH/OS6G1J
         9UpckB7JCtI10misclNl85Fsk4vweuJlBVYoPZBs=
Date:   Mon, 9 Mar 2020 10:04:39 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com,
        raspl@linux.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net] net/smc: cancel event worker during device removal
Message-ID: <20200309080439.GJ11496@unreal>
References: <20200306134518.84416-1-kgraul@linux.ibm.com>
 <20200308150107.GC11496@unreal>
 <0b5d992d-2447-1606-f8ce-73801643160a@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b5d992d-2447-1606-f8ce-73801643160a@linux.ibm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 08, 2020 at 08:59:33PM +0100, Karsten Graul wrote:
> On 08/03/2020 16:01, Leon Romanovsky wrote:
> > On Fri, Mar 06, 2020 at 02:45:18PM +0100, Karsten Graul wrote:
> >> During IB device removal, cancel the event worker before the device
> >> structure is freed. In the worker, check if the device is being
> >> terminated and do not proceed with the event work in that case.
> >>
> >> Fixes: a4cf0443c414 ("smc: introduce SMC as an IB-client")
> >> Reported-by: syzbot+b297c6825752e7a07272@syzkaller.appspotmail.com
> >> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
> >> Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
> >> ---
> >>  net/smc/smc_ib.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
> >> index d6ba186f67e2..5e4e64a9aa4b 100644
> >> --- a/net/smc/smc_ib.c
> >> +++ b/net/smc/smc_ib.c
> >> @@ -240,6 +240,9 @@ static void smc_ib_port_event_work(struct work_struct *work)
> >>  		work, struct smc_ib_device, port_event_work);
> >>  	u8 port_idx;
> >>
> >> +	if (list_empty(&smcibdev->list))
> >> +		return;
> >> +
> >
> > How can it be true if you are not holding "smc_ib_devices.lock" during
> > execution of smc_ib_port_event_work()?
> >
>
> It is true when smc_ib_remove_dev() runs before the work actually started.
> Other than that its only a shortcut to return earlier, when the item is
> removed from the list after the check then the processing just takes a
> little bit longer...its still save.

The check itself maybe safe, but it can't fix syzkaller bug reported above.
As you said, the smc_ib_remove_dev() can be called immediately after
your list_empty() check and we return to original behavior.

The correct design will be to ensure that smc_ib_port_event_work() is
executed only smcibdev->list is not empty.

Thanks

>
> >>  	for_each_set_bit(port_idx, &smcibdev->port_event_mask, SMC_MAX_PORTS) {
> >>  		smc_ib_remember_port_attr(smcibdev, port_idx + 1);
> >>  		clear_bit(port_idx, &smcibdev->port_event_mask);
> >> @@ -582,6 +585,7 @@ static void smc_ib_remove_dev(struct ib_device *ibdev, void *client_data)
> >>  	smc_smcr_terminate_all(smcibdev);
> >>  	smc_ib_cleanup_per_ibdev(smcibdev);
> >>  	ib_unregister_event_handler(&smcibdev->event_handler);
> >> +	cancel_work_sync(&smcibdev->port_event_work);
> >>  	kfree(smcibdev);
> >>  }
> >>
> >> --
> >> 2.17.1
> >>
>
> --
> Karsten
>
> (I'm a dude)
>
