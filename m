Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C76B24DF47
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 20:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgHUSSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 14:18:02 -0400
Received: from mga05.intel.com ([192.55.52.43]:18326 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgHUSSC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 14:18:02 -0400
IronPort-SDR: aD82iQbtYwx99ZsuLJbGq0EjMO9fRFeZZTGTSFFEPhzZq/EkMCkIMhiF3ohfE7hhvrqYKPJSd4
 1l6D6qdwhzgg==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="240430475"
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="240430475"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 11:18:02 -0700
IronPort-SDR: wBw3XeBwvHQzaudncojCBfacgAW1JLN+BoS3GeEGLzxUvK14b6Y3NklAz6GZdGA0xkCNq+xj6a
 0xx6mUXWJeGA==
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="498056540"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.38.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 11:18:01 -0700
Date:   Fri, 21 Aug 2020 11:18:00 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH v6 net-next 02/10] qed/qede: make devlink survive
 recovery
Message-ID: <20200821111800.00004fb1@intel.com>
In-Reply-To: <20200820185204.652-3-irusskikh@marvell.com>
References: <20200820185204.652-1-irusskikh@marvell.com>
        <20200820185204.652-3-irusskikh@marvell.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Igor Russkikh wrote:

> Devlink instance lifecycle was linked to qed_dev object,
> that caused devlink to be recreated on each recovery.
> 
> Changing it by making higher level driver (qede) responsible for its
> life. This way devlink now survives recoveries.
> 
> qede now stores devlink structure pointer as a part of its device
> object, devlink private data contains a linkage structure,
> qed_devlink.
> 
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>

<snip>

> diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
> index 140a392a81bb..93071d41afe4 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede_main.c
> +++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
> @@ -1170,10 +1170,23 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
>  			rc = -ENOMEM;
>  			goto err2;
>  		}
> +
> +		edev->devlink = qed_ops->common->devlink_register(cdev);
> +		if (IS_ERR(edev->devlink)) {
> +			DP_NOTICE(edev, "Cannot register devlink\n");
> +			edev->devlink = NULL;
> +			/* Go on, we can live without devlink */
> +		}
>  	} else {
>  		struct net_device *ndev = pci_get_drvdata(pdev);
>  
>  		edev = netdev_priv(ndev);
> +
> +		if (edev && edev->devlink) {
> +			struct qed_devlink *qdl = devlink_priv(edev->devlink);
> +
> +			qdl->cdev = cdev;
> +		}
>  		edev->cdev = cdev;
>  		memset(&edev->stats, 0, sizeof(edev->stats));
>  		memcpy(&edev->dev_info, &dev_info, sizeof(dev_info));

same comment as against old version:

cppcheck notes that the edev check here before the && is either
unnecessary, or the original code had a possible null pointer
dereference.  I figure the code should just be
		if (edev->devlink) {

And I recommend that you try to run cppcheck --enable=all on your code,
it finds several style violations and a few other null pointer checks
that can be fixed up.
