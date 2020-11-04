Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5282A5B7C
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbgKDBGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:06:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:43840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730119AbgKDBGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 20:06:41 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4199F2065E;
        Wed,  4 Nov 2020 01:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604452000;
        bh=FDDkkgdnhBjRszaoMpH9rsaeXy2VQAL+pnhjxBHCZhk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=w70rvpRIgNal+YBm7mPMMgO1iCKoy3IazgBv/lO6loSqq2d9Q6nXQeoFZIT1GN4qG
         UT6945Wv3crrS2F1X5mVuUGWS+PmHS16A5vKd7rQE6Wsh8ApO8+3dwlPnB99ngU1wx
         JVWNVE7s3JxOAQkpUzDkBhsbzdAAankZeUZaQuXs=
Message-ID: <f734400e8fbf53d3c8a4db97887bd55f6f80f10b.camel@kernel.org>
Subject: Re: [PATCH net-next v2 06/15] net/smc: Add diagnostic information
 to link structure
From:   Saeed Mahameed <saeed@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Date:   Tue, 03 Nov 2020 17:06:39 -0800
In-Reply-To: <20201103102531.91710-7-kgraul@linux.ibm.com>
References: <20201103102531.91710-1-kgraul@linux.ibm.com>
         <20201103102531.91710-7-kgraul@linux.ibm.com>
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
> During link creation add network and ib-device name to
> link structure. This is needed for diagnostic purposes.
> 
> When diagnostic information is gathered, we need to traverse
> device, linkgroup and link structures, to be able to do that
> we need to hold a spinlock for the linkgroup list, without this
> diagnostic information in link structure, another device list
> mutex holding would be necessary to dereference the device
> pointer in the link structure which would be impossible when
> holding a spinlock already.
> 
> Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
> ---
>  net/smc/smc_core.c | 10 ++++++++++
>  net/smc/smc_core.h |  3 +++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index da94725deb09..28fc583d9033 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -303,6 +303,15 @@ static u8 smcr_next_link_id(struct
> smc_link_group *lgr)
>  	return link_id;
>  }
>  
> +static inline void smcr_copy_dev_info_to_link(struct smc_link *link)
> +{
> +	struct smc_ib_device *smcibdev = link->smcibdev;
> +
> +	memcpy(link->ibname, smcibdev->ibdev->name, sizeof(link-
> >ibname));
> +	memcpy(link->ndevname, smcibdev->netdev[link->ibport - 1],
> +	       sizeof(link->ndevname));

snprintf() 

> +}
> +
>  int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
>  		   u8 link_idx, struct smc_init_info *ini)
>  {
> @@ -317,6 +326,7 @@ int smcr_link_init(struct smc_link_group *lgr,
> struct smc_link *lnk,
>  	lnk->smcibdev = ini->ib_dev;
>  	lnk->ibport = ini->ib_port;
>  	atomic_inc(&ini->ib_dev->lnk_cnt_by_port[ini->ib_port - 1]);
> +	smcr_copy_dev_info_to_link(lnk);
>  	lnk->path_mtu = ini->ib_dev->pattr[ini->ib_port -
> 1].active_mtu;
>  	atomic_set(&lnk->conn_cnt, 0);
>  	smc_llc_link_set_uid(lnk);
> diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
> index 83a88a4635db..bd16d63c5222 100644
> --- a/net/smc/smc_core.h
> +++ b/net/smc/smc_core.h
> @@ -124,6 +124,9 @@ struct smc_link {
>  	u8			link_is_asym;	/* is link
> asymmetric? */
>  	struct smc_link_group	*lgr;		/* parent link group
> */
>  	struct work_struct	link_down_wrk;	/* wrk to bring link
> down */
> +	/* Diagnostic relevant link information */
> +	u8			ibname[IB_DEVICE_NAME_MAX];/* ib
> device name */
> +	u8			ndevname[IFNAMSIZ];/* network device
> name */
> 

IMHO, Comments are redundant.  and you could define name buffers as
char array for more natural string manipulation down the road.


