Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1529D2A5B36
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 01:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgKDAwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 19:52:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:57556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbgKDAwR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 19:52:17 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11F76223C7;
        Wed,  4 Nov 2020 00:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604451137;
        bh=6zAov1EfuE4zOg6yRhjhy3VcbO2dr/0vmkSQumXy2wQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ekyxu07XEgtGJYXnnBrlpWtChl5OgtxSVoJ/YZSojhaoIV0Qp1d47DK84w61vK7xr
         UHCBAaMKDY8dURxBQbpbSPbDQ955eu4lbAexFWISNlecW/h6A7Dxw7ZEyo6p8BHbS2
         4BhBpxgOjTuH0cpquFG5gV5eUiOKFGgj21M1HTkU=
Message-ID: <14fd3b8357d650c76f00c399bcf08d654524e632.camel@kernel.org>
Subject: Re: [PATCH net-next v2 04/15] net/smc: Add link counters for IB
 device ports
From:   Saeed Mahameed <saeed@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Date:   Tue, 03 Nov 2020 16:52:16 -0800
In-Reply-To: <20201103102531.91710-5-kgraul@linux.ibm.com>
References: <20201103102531.91710-1-kgraul@linux.ibm.com>
         <20201103102531.91710-5-kgraul@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-11-03 at 11:25 +0100, Karsten Graul wrote:
> From: Guvenc Gulce <guvenc@linux.ibm.com>
> 
> Add link counters to the structure of the smc ib device, one counter
> per
> ib port. Increase/decrease the counters as needed in the
> corresponding
> routines.
> 
> Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
> ---
>  net/smc/smc_core.c | 3 +++
>  net/smc/smc_ib.h   | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 6e2077161267..da94725deb09 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -316,6 +316,7 @@ int smcr_link_init(struct smc_link_group *lgr,
> struct smc_link *lnk,
>  	lnk->link_idx = link_idx;
>  	lnk->smcibdev = ini->ib_dev;
>  	lnk->ibport = ini->ib_port;
> +	atomic_inc(&ini->ib_dev->lnk_cnt_by_port[ini->ib_port - 1]);
>  	lnk->path_mtu = ini->ib_dev->pattr[ini->ib_port -
> 1].active_mtu;
>  	atomic_set(&lnk->conn_cnt, 0);
>  	smc_llc_link_set_uid(lnk);
> @@ -360,6 +361,7 @@ int smcr_link_init(struct smc_link_group *lgr,
> struct smc_link *lnk,
>  	smc_llc_link_clear(lnk, false);
>  out:
>  	put_device(&ini->ib_dev->ibdev->dev);
> +	atomic_dec(&ini->ib_dev->lnk_cnt_by_port[ini->ib_port - 1]);
>  	memset(lnk, 0, sizeof(struct smc_link));
>  	lnk->state = SMC_LNK_UNUSED;
>  	if (!atomic_dec_return(&ini->ib_dev->lnk_cnt))
> @@ -750,6 +752,7 @@ void smcr_link_clear(struct smc_link *lnk, bool
> log)
>  	smc_ib_dealloc_protection_domain(lnk);
>  	smc_wr_free_link_mem(lnk);
>  	put_device(&lnk->smcibdev->ibdev->dev);
> +	atomic_dec(&lnk->smcibdev->lnk_cnt_by_port[lnk->ibport - 1]);

this repeats 3 times at least in this patch and hard to read, can you
make a macro or static function to hide the details

Maybe: 
SMC_IBDEV_CNT_{INC/DEC}(lnk->smcibdev);

>  	smcibdev = lnk->smcibdev;
>  	memset(lnk, 0, sizeof(struct smc_link));
>  	lnk->state = SMC_LNK_UNUSED;
> diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
> index 2ce481187dd0..3e6bfeddd53b 100644
> --- a/net/smc/smc_ib.h
> +++ b/net/smc/smc_ib.h
> @@ -53,6 +53,7 @@ struct smc_ib_device {				
> /* ib-device infos for smc */
>  	atomic_t		lnk_cnt;	/* number of links on ibdev
> */
>  	wait_queue_head_t	lnks_deleted;	/* wait 4 removal of all
> links*/
>  	struct mutex		mutex;		/* protect dev
> setup+cleanup */
> +	atomic_t		lnk_cnt_by_port[SMC_MAX_PORTS];/*#lnk per
> port*/

missing spaces around comment text.


> 

