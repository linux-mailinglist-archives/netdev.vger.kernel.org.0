Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE4D311F62
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 19:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhBFShg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 13:37:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229539AbhBFShf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 13:37:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95A8A64E05;
        Sat,  6 Feb 2021 18:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612636615;
        bh=VwMBFnaleoEdu4BUgRLRFEjRik4GKTcenmwemSXUW2k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VdPGGQlkNOYxcr4D6UoaCQ3y9Hpx/wedX36rfAJPgxhlVbUU2pAiCrrlU5oIcebYq
         Qn3+ykQPlJ/HXG01rAui+aaaFkQgAewAWPRcjVeOCRNHrxv1hd3puM1G8HgmzPc+/2
         Ez/GJYQDbD4QVRgTSE4yz5LvZqaaZgs7HEHdC8E4l9YnoCWjWupImK+uPIQguwSuB9
         gdzfvA8yWbvJTyIANInxNm4BHcoIqOHnRWiVv/b2IngiSu3p2t6jN3BR+dhG8RsXuq
         C4KA9f2N5sw2EkwywzTxpuVZpmOaiMpIxeQsUUIOoNygVAQlVYDbuUuas9SXoQw5m0
         MLEz0QNj0Kjcw==
Date:   Sat, 6 Feb 2021 10:36:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, cforno12@linux.ibm.com
Subject: Re: [PATCH 1/1] ibmvnic: Clear failover_pending if unable to
 schedule
Message-ID: <20210206103653.33671590@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203050802.680772-1-sukadev@linux.ibm.com>
References: <20210203050802.680772-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Feb 2021 21:08:02 -0800 Sukadev Bhattiprolu wrote:
> Normally we clear the failover_pending flag when processing the reset.
> But if we are unable to schedule a failover reset we must clear the
> flag ourselves. We could fail to schedule the reset if we are in PROBING
> state (eg: when booting via kexec) or because we could not allocate memory.
> 
> Thanks to Cris Forno for helping isolate the problem and for testing.
> 
> Fixes: 1d8504937478 ("powerpc/vnic: Extend "failover pending" window")
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> Tested-by: Cristobal Forno <cforno12@linux.ibm.com>

Applied, thanks.

> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index df1b4884b4e8..58108e1a1d2e 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -4907,7 +4907,23 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
>  				complete(&adapter->init_done);
>  				adapter->init_done_rc = -EIO;
>  			}
> -			ibmvnic_reset(adapter, VNIC_RESET_FAILOVER);
> +			rc = ibmvnic_reset(adapter, VNIC_RESET_FAILOVER);
> +			if (rc && rc != -EBUSY) {
> +				/**

I fixed this comment up for you - /** (double star) is reserved for
kdoc comments, normal comments should start with /*. And in networking
the first line of the multi-line comment is not empty.

> +				 * We were unable to schedule the failover
