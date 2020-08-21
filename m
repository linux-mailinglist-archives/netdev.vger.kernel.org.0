Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD7924DE45
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 19:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbgHUR2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 13:28:21 -0400
Received: from mga05.intel.com ([192.55.52.43]:14690 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728862AbgHUR2T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 13:28:19 -0400
IronPort-SDR: EDafFZY+/abpa74raSbmHa5PESSGr4rfEXsmO93/okfwju5UvHRcBp0M1y/q7GWgigix+KKsIl
 W3e3PxMYZDiw==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="240417817"
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="240417817"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 10:28:16 -0700
IronPort-SDR: VYTrW7qwbN299WiLHhxvhm52BTUUiYLtejRA7I99DUBSdigNfbKn6xijprMvybh7wAA+VDx1vG
 u4nzVGETyzjQ==
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="298009432"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.38.54])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 10:28:15 -0700
Date:   Fri, 21 Aug 2020 10:28:14 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH net-next 02/11] qed/qede: make devlink survive recovery
Message-ID: <20200821102814.00003002@intel.com>
In-Reply-To: <20200727184310.462-3-irusskikh@marvell.com>
References: <20200727184310.462-1-irusskikh@marvell.com>
        <20200727184310.462-3-irusskikh@marvell.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Igor Russkikh wrote:

> Before that, devlink instance lifecycle was linked to qed_dev object,
> that causes devlink to be recreated on each recovery.
> 
> Changing it by making higher level driver (qede) responsible for its
> life. This way devlink will survive recoveries.
> 
> qede will store devlink structure pointer as a part of its device
> object, devlink private data contains a linkage structure, it'll
> contain extra devlink related content in following patches.
> 
> The same lifecycle should be applied to storage drivers (qedf/qedi) later.
> 
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>

<snip>

> diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
> index 1aaae3203f5a..7c2d948b2035 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede_main.c
> +++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
> @@ -1172,10 +1172,23 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
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

cppcheck notes that the edev check here before the && is either
unnecessary, or the original code had a possible null pointer
dereference.  I figure the code should just be
		if (edev->devlink) {

And I recommend that you try to run cppcheck --enable=all on your code,
it finds several style violations and a few other null pointer checks
that can be fixed up.

> +			struct qed_devlink *qdl = devlink_priv(edev->devlink);
> +
> +			qdl->cdev = cdev;
> +		}
>  		edev->cdev = cdev;
>  		memset(&edev->stats, 0, sizeof(edev->stats));
>  		memcpy(&edev->dev_info, &dev_info, sizeof(dev_info));
