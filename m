Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81641C349C
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgEDIhm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 4 May 2020 04:37:42 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:43812 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbgEDIhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:37:41 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 0448bFKL1005156, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 0448bFKL1005156
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 4 May 2020 16:37:15 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 4 May 2020 16:37:15 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 4 May 2020 16:37:15 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::8001:f5f5:a41e:f8d4]) by
 RTEXMB04.realtek.com.tw ([fe80::8001:f5f5:a41e:f8d4%3]) with mapi id
 15.01.1779.005; Mon, 4 May 2020 16:37:15 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Dejin Zheng <zhengdejin5@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Andy Shevchenko" <andy.shevchenko@gmail.com>
Subject: RE: [PATCH net v1] net: rtw88: fix an issue about leak system resources
Thread-Topic: [PATCH net v1] net: rtw88: fix an issue about leak system
 resources
Thread-Index: AQHWIe7inKq7KGzTFUK74b0Sl3+N96iXmmBw
Date:   Mon, 4 May 2020 08:37:15 +0000
Message-ID: <88e6cc654a73472f9591fb0c6b74f768@realtek.com>
References: <20200504083442.3033-1-zhengdejin5@gmail.com>
In-Reply-To: <20200504083442.3033-1-zhengdejin5@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.175]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH net v1] net: rtw88: fix an issue about leak system resources
> 
> the related system resources were not released when pci_iomap() return
> error in the rtw_pci_io_mapping() function. add pci_release_regions() to
> fix it.
> 
> Fixes: e3037485c68ec1a ("rtw88: new Realtek 802.11ac driver")
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
Acked-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---
>  drivers/net/wireless/realtek/rtw88/pci.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c
> b/drivers/net/wireless/realtek/rtw88/pci.c
> index 695c2c0d64b0..a9752c34c9d8 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -1102,6 +1102,7 @@ static int rtw_pci_io_mapping(struct rtw_dev
> *rtwdev,
>  	len = pci_resource_len(pdev, bar_id);
>  	rtwpci->mmap = pci_iomap(pdev, bar_id, len);
>  	if (!rtwpci->mmap) {
> +		pci_release_regions(pdev);
>  		rtw_err(rtwdev, "failed to map pci memory\n");
>  		return -ENOMEM;
>  	}
> --
> 2.25.0

