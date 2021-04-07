Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B112635608B
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 03:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347655AbhDGBH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 21:07:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37284 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233073AbhDGBH4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 21:07:56 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTwfY-00FE5I-0a; Wed, 07 Apr 2021 03:07:44 +0200
Date:   Wed, 7 Apr 2021 03:07:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        liuwe@microsoft.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <YG0F4HkslqZHtBya@lunn.ch>
References: <20210406232321.12104-1-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406232321.12104-1-decui@microsoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int gdma_query_max_resources(struct pci_dev *pdev)
> +{
> +	struct gdma_context *gc = pci_get_drvdata(pdev);
> +	struct gdma_general_req req = { 0 };
> +	struct gdma_query_max_resources_resp resp = { 0 };
> +	int err;

Network drivers need to use reverse christmas tree. I spotted a number
of functions getting this wrong. Please review the whole driver.


> +
> +	gdma_init_req_hdr(&req.hdr, GDMA_QUERY_MAX_RESOURCES,
> +			  sizeof(req), sizeof(resp));
> +
> +	err = gdma_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
> +	if (err || resp.hdr.status) {
> +		pr_err("%s, line %d: err=%d, err=0x%x\n", __func__, __LINE__,
> +		       err, resp.hdr.status);

I expect checkpatch complained about this. Don't use pr_err(), use
dev_err(pdev->dev, ...  of netdev_err(ndev, ... You should always have
access to dev or ndev, so please change all pr_ calls.

> +static unsigned int num_queues = ANA_DEFAULT_NUM_QUEUE;
> +module_param(num_queues, uint, 0444);

No module parameters please.

   Andrew
