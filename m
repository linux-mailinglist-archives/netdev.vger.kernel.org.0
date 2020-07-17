Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B579B22353F
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 09:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgGQHNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 03:13:43 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:40618 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726101AbgGQHNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 03:13:43 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 08372C15F50A8CB3C10F;
        Fri, 17 Jul 2020 15:13:41 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.81) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Fri, 17 Jul 2020
 15:13:37 +0800
Subject: Re: [PATCH] net: cxgb3: add missed destroy_workqueue in
 nci_register_device
To:     <davem@davemloft.net>, <kuba@kernel.org>, <sameo@linux.intel.com>,
        <cuissard@marvell.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200717061854.7765-1-wanghai38@huawei.com>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <61a6ea2c-035d-555e-4af8-5415390eff0e@huawei.com>
Date:   Fri, 17 Jul 2020 15:13:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200717061854.7765-1-wanghai38@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.81]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

subject msg was wrong. "net: cxgb3:" should be "nfc: nci:".  v2 patch 
has been sent.

("[PATCH v2] nfc: nci: add missed destroy_workqueue in nci_register_device")

在 2020/7/17 14:18, Wang Hai 写道:
> When nfc_register_device fails in nci_register_device,
> destroy_workqueue() shouled be called to destroy ndev->tx_wq.
>
> Fixes: 3c1c0f5dc80b ("NFC: NCI: Fix nci_register_device init sequence")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>   net/nfc/nci/core.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
> index 7cd524884304..78ea8c94dcba 100644
> --- a/net/nfc/nci/core.c
> +++ b/net/nfc/nci/core.c
> @@ -1228,10 +1228,13 @@ int nci_register_device(struct nci_dev *ndev)
>   
>   	rc = nfc_register_device(ndev->nfc_dev);
>   	if (rc)
> -		goto destroy_rx_wq_exit;
> +		goto destroy_tx_wq_exit;
>   
>   	goto exit;
>   
> +destroy_tx_wq_exit:
> +	destroy_workqueue(ndev->tx_wq);
> +
>   destroy_rx_wq_exit:
>   	destroy_workqueue(ndev->rx_wq);
>   

