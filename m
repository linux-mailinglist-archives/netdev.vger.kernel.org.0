Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB59E2A5B6A
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgKDBAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:00:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728157AbgKDBAX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 20:00:23 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D948223C7;
        Wed,  4 Nov 2020 01:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604451621;
        bh=NEkzAawhlu5u7Jz22+mg1Ti5YfUqUAE51H5qG1Scbsg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qNYFU0FTse0ETcuHLBhodIWsTtGjEHjTfPxgEOISCOBBRis9GhmEGCNlGy+EXiE5N
         hTkV/25MClNsa8vi25c/LyTqBRn161QGwu8hAyrb0F8PdgUHPzICD35CEqohERtdzT
         1NhqdEROW3ditD9mwXcBWasf+JmVRiR745CYS0ro=
Message-ID: <fdf78f7621a8cff42ccf84cf3deb8d108f03cb3f.camel@kernel.org>
Subject: Re: [PATCH net-next v2 05/15] net/smc: Add diagnostic information
 to smc ib-device
From:   Saeed Mahameed <saeed@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Date:   Tue, 03 Nov 2020 17:00:20 -0800
In-Reply-To: <20201103102531.91710-6-kgraul@linux.ibm.com>
References: <20201103102531.91710-1-kgraul@linux.ibm.com>
         <20201103102531.91710-6-kgraul@linux.ibm.com>
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
> During smc ib-device creation, add network device name to smc
> ib-device structure. Register for netdevice name changes and
> update ib-device accordingly. This is needed for diagnostic purposes.
> 
> Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
> ---
>  net/smc/smc_ib.c   | 47
> ++++++++++++++++++++++++++++++++++++++++++++++
>  net/smc/smc_ib.h   |  2 ++
>  net/smc/smc_pnet.c |  3 +++
>  3 files changed, 52 insertions(+)
> 
> diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
> index 1c314dbdc7fa..c4a04e868bf0 100644
> --- a/net/smc/smc_ib.c
> +++ b/net/smc/smc_ib.c
> @@ -557,6 +557,52 @@ static void smc_ib_cleanup_per_ibdev(struct
> smc_ib_device *smcibdev)
>  
>  static struct ib_client smc_ib_client;
>  
> +static void smc_copy_netdev_name(struct smc_ib_device *smcibdev, int
> port)
> +{
> +	struct ib_device *ibdev = smcibdev->ibdev;
> +	struct net_device *ndev;
> +
> +	if (ibdev->ops.get_netdev) {

early return to avoid multiple indentation to the right .. 

> +		ndev = ibdev->ops.get_netdev(ibdev, port + 1);
> +		if (ndev) {
> +			snprintf((char *)&smcibdev->netdev[port],
> +				 sizeof(smcibdev->netdev[port]),
> +				 "%s", ndev->name);

Why do you need typecasting to char* just declare the netdev as char
array ??

> +			dev_put(ndev);
> +		}
> +	}
> +}
> +
> +void smc_ib_ndev_name_change(struct net_device *ndev)
> +{
> +	struct smc_ib_device *smcibdev;
> +	struct ib_device *libdev;
> +	struct net_device *lndev;
> +	u8 port_cnt;
> +	int i;
> +
> +	mutex_lock(&smc_ib_devices.mutex);
> +	list_for_each_entry(smcibdev, &smc_ib_devices.list, list) {
> +		port_cnt = smcibdev->ibdev->phys_port_cnt;
> +		for (i = 0;
> +		     i < min_t(size_t, port_cnt, SMC_MAX_PORTS);
> +		     i++) {

Unnecessary ugly line breaks.

> +			libdev = smcibdev->ibdev;
> +			if (libdev->ops.get_netdev) {

early continue 

if (!libdev->ops.get_netdev)
     continue;

do stuff

> +				lndev = libdev->ops.get_netdev(libdev,
> i + 1);
> +				if (lndev)
> +					dev_put(lndev);
> +				if (lndev == ndev) {

Same 

if (!lndev || lndev != ndev)
     continue;

> +					snprintf((char *)&smcibdev-
> >netdev[i],
> +						 sizeof(smcibdev-
> >netdev[i]),
> +						 "%s", ndev->name);
> +				}
> +			}
> +		}
> +	}
> +	mutex_unlock(&smc_ib_devices.mutex);
> +}
> +
>  /* callback function for ib_register_client() */
>  static int smc_ib_add_dev(struct ib_device *ibdev)
>  {
> @@ -596,6 +642,7 @@ static int smc_ib_add_dev(struct ib_device
> *ibdev)
>  		if (smc_pnetid_by_dev_port(ibdev->dev.parent, i,
>  					   smcibdev->pnetid[i]))
>  			smc_pnetid_by_table_ib(smcibdev, i + 1);
> +		smc_copy_netdev_name(smcibdev, i);
>  		pr_warn_ratelimited("smc:    ib device %s port %d has
> pnetid "
>  				    "%.16s%s\n",
>  				    smcibdev->ibdev->name, i + 1,
> diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
> index 3e6bfeddd53b..b0868146b46b 100644
> --- a/net/smc/smc_ib.h
> +++ b/net/smc/smc_ib.h
> @@ -54,11 +54,13 @@ struct smc_ib_device {				
> /* ib-device infos for smc */
>  	wait_queue_head_t	lnks_deleted;	/* wait 4 removal of all
> links*/
>  	struct mutex		mutex;		/* protect dev
> setup+cleanup */
>  	atomic_t		lnk_cnt_by_port[SMC_MAX_PORTS];/*#lnk per
> port*/
> +	u8			netdev[SMC_MAX_PORTS][IFNAMSIZ];/*
> ndev names */
>  };
>  
>  struct smc_buf_desc;
>  struct smc_link;
>  
> +void smc_ib_ndev_name_change(struct net_device *ndev);
>  int smc_ib_register_client(void) __init;
>  void smc_ib_unregister_client(void);
>  bool smc_ib_port_active(struct smc_ib_device *smcibdev, u8 ibport);
> diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
> index f3c18b991d35..b0f40d73afd6 100644
> --- a/net/smc/smc_pnet.c
> +++ b/net/smc/smc_pnet.c
> @@ -828,6 +828,9 @@ static int smc_pnet_netdev_event(struct
> notifier_block *this,
>  	case NETDEV_UNREGISTER:
>  		smc_pnet_remove_by_ndev(event_dev);
>  		return NOTIFY_OK;
> +	case NETDEV_CHANGENAME:
> +		smc_ib_ndev_name_change(event_dev);
> +		return NOTIFY_OK;
>  	case NETDEV_REGISTER:
>  		smc_pnet_add_by_ndev(event_dev);
>  		return NOTIFY_OK;

