Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F421B48BDE5
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 05:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349281AbiALEdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 23:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiALEdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 23:33:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56E3C06173F;
        Tue, 11 Jan 2022 20:33:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A25BB81DCA;
        Wed, 12 Jan 2022 04:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DD5C36AE5;
        Wed, 12 Jan 2022 04:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641962015;
        bh=7NrSKZ8PtbnKJG51c0SYHsrsFfDrjACpv6k5pXnZx3M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JTFhIvstI57YbIol9tDSGX0d9S9d/XWtAhjl1QpcRlKHqSXvMeboUJvvBB9UK2PBr
         U8Fy/MshQkyUnqOd/BwfJInhrsvK6NLQrdCjgRD+//eQ0iGHbgZL1yNT29Eu/A7ynf
         aAdh6E28aYEXvQ2j4CC0s4u8P6JuqQS3hOXz6At5vwsWZe2rdK5qCv0mSJ0gGxoYZI
         gWYQFSMRpIofe/2u6f/Ja5S7GSV/r4s9aOA8R3h6VH9aqqFfg8fj5znm5KqN+Deq4g
         Sy8tZ1OU82TpWynTQYX3BEAfq5jBiTtaDOYEtrmKMob4xtfHyO9Pn0JLiSDvWkhY6b
         8yLkwqKvHj2jA==
Date:   Tue, 11 Jan 2022 20:33:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Yang Shen <shenyang39@huawei.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Matthias Brugger <mbrugger@suse.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hns: Fix missing put_device() call in
 hns_mac_register_phy
Message-ID: <20220111203333.507ec4f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220110064031.3431-1-linmq006@gmail.com>
References: <20220110064031.3431-1-linmq006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jan 2022 06:40:29 +0000 Miaoqian Lin wrote:
> We need to drop the reference taken by hns_dsaf_find_platform_device
> Missing put_device() may cause refcount leak.
> 
> Fixes: 804ffe5c6197 ("net: hns: support deferred probe when no mdio")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
>  drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
> index 7edf8569514c..7364e05487c7 100644
> --- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
> +++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
> @@ -764,6 +764,7 @@ static int hns_mac_register_phy(struct hns_mac_cb *mac_cb)
>  		dev_err(mac_cb->dev,
>  			"mac%d mdio is NULL, dsaf will probe again later\n",
>  			mac_cb->mac_id);
> +		put_device(&pdev->dev);
>  		return -EPROBE_DEFER;
>  	}
>  

With more context:

@@ -755,24 +755,25 @@ static int hns_mac_register_phy(struct hns_mac_cb *mac_cb)
        pdev = hns_dsaf_find_platform_device(args.fwnode);
        if (!pdev) {
                dev_err(mac_cb->dev, "mac%d mdio pdev is NULL\n",
                        mac_cb->mac_id);
                return  -EINVAL;
        }
 
        mii_bus = platform_get_drvdata(pdev);
        if (!mii_bus) {
                dev_err(mac_cb->dev,
                        "mac%d mdio is NULL, dsaf will probe again later\n",
                        mac_cb->mac_id);
+               put_device(&pdev->dev);
                return -EPROBE_DEFER;
        }
 
        rc = hns_mac_register_phydev(mii_bus, mac_cb, addr);
        if (!rc)
                dev_dbg(mac_cb->dev, "mac%d register phy addr:%d\n",
                        mac_cb->mac_id, addr);
 
        return rc;
 }

Looks like if put_device() is missing it will also be missing in case
hns_mac_register_phydev() returns an error.
