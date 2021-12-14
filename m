Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D1E473B6E
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 04:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhLNDTh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 Dec 2021 22:19:37 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:42277 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhLNDTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 22:19:37 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1BE3J2FF0006721, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1BE3J2FF0006721
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Dec 2021 11:19:02 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 14 Dec 2021 11:19:02 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 14 Dec 2021 11:19:01 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01]) by
 RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01%5]) with mapi id
 15.01.2308.020; Tue, 14 Dec 2021 11:19:01 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>
CC:     "jian-hong@endlessm.com" <jian-hong@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        "Bernie Huang" <phhuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
Thread-Topic: [PATCH] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
Thread-Index: AQHX8JVLUfFN0UZZTE6WbUrtyoUPn6wxT+Og
Date:   Tue, 14 Dec 2021 03:19:01 +0000
Message-ID: <cdf57476e4a544e09859029bf05142c0@realtek.com>
References: <20211214024901.223603-1-kai.heng.feng@canonical.com>
In-Reply-To: <20211214024901.223603-1-kai.heng.feng@canonical.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/12/14_=3F=3F_01:13:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Sent: Tuesday, December 14, 2021 10:49 AM
> To: tony0620emma@gmail.com; Pkshih <pkshih@realtek.com>
> Cc: jian-hong@endlessm.com; Kai-Heng Feng <kai.heng.feng@canonical.com>; Kalle Valo
> <kvalo@codeaurora.org>; David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Brian
> Norris <briannorris@chromium.org>; Bernie Huang <phhuang@realtek.com>; linux-wireless@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
> 
> Many Intel based platforms face system random freeze after commit
> 9e2fd29864c5 ("rtw88: add napi support").
> 
> The commit itself shouldn't be the culprit. My guess is that the 8821CE
> only leaves ASPM L1 for a short period when IRQ is raised. Since IRQ is
> masked during NAPI polling, the PCIe link stays at L1 and makes RX DMA
> extremely slow. Eventually the RX ring becomes messed up:
> [ 1133.194697] rtw_8821ce 0000:02:00.0: pci bus timeout, check dma status
> 
> Since the 8821CE hardware may fail to leave ASPM L1, manually do it in
> the driver to resolve the issue.
> 
> Fixes: 9e2fd29864c5 ("rtw88: add napi support")
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215131
> BugLink: https://bugs.launchpad.net/bugs/1927808
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/net/wireless/realtek/rtw88/pci.c | 74 ++++++++----------------
>  drivers/net/wireless/realtek/rtw88/pci.h |  1 +
>  2 files changed, 24 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> index 3b367c9085eba..f09eb5e2437a9 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -2,7 +2,6 @@
>  /* Copyright(c) 2018-2019  Realtek Corporation
>   */
> 
> -#include <linux/dmi.h>
>  #include <linux/module.h>
>  #include <linux/pci.h>
>  #include "main.h"
> @@ -16,10 +15,13 @@
> 
>  static bool rtw_disable_msi;
>  static bool rtw_pci_disable_aspm;
> +static int rtw_rx_aspm;

With your parameter description, rtw_rx_aspm = -1 by default.

>  module_param_named(disable_msi, rtw_disable_msi, bool, 0644);
>  module_param_named(disable_aspm, rtw_pci_disable_aspm, bool, 0644);
> +module_param_named(rx_aspm, rtw_rx_aspm, int, 0444);
>  MODULE_PARM_DESC(disable_msi, "Set Y to disable MSI interrupt support");
>  MODULE_PARM_DESC(disable_aspm, "Set Y to disable PCI ASPM support");
> +MODULE_PARM_DESC(rx_aspm, "Use PCIe ASPM for RX (0=disable, 1=enable, -1=default)");


[...]

--
Ping-Ke

