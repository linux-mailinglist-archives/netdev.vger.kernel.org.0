Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FD9473CD6
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 06:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhLNF7c convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 14 Dec 2021 00:59:32 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:57966 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhLNF7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 00:59:31 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1BE5x6gyD004824, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1BE5x6gyD004824
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Dec 2021 13:59:06 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 13:59:06 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 13:59:06 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01]) by
 RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01%5]) with mapi id
 15.01.2308.020; Tue, 14 Dec 2021 13:59:06 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>
CC:     "jian-hong@endlessm.com" <jian-hong@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Bernie Huang <phhuang@realtek.com>,
        Brian Norris <briannorris@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
Thread-Topic: [PATCH v2] rtw88: Disable PCIe ASPM while doing NAPI poll on
 8821CE
Thread-Index: AQHX8KxEGsnToIDXSUCJmFSUmWAcOawxeDaA
Date:   Tue, 14 Dec 2021 05:59:06 +0000
Message-ID: <4aaf5dd030004285a56bc55cc6b2731b@realtek.com>
References: <20211214053302.242222-1-kai.heng.feng@canonical.com>
In-Reply-To: <20211214053302.242222-1-kai.heng.feng@canonical.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/12/14_=3F=3F_02:07:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Sent: Tuesday, December 14, 2021 1:33 PM
> To: tony0620emma@gmail.com; Pkshih <pkshih@realtek.com>
> Cc: jian-hong@endlessm.com; Kai-Heng Feng <kai.heng.feng@canonical.com>; Kalle Valo
> <kvalo@codeaurora.org>; David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Bernie
> Huang <phhuang@realtek.com>; Brian Norris <briannorris@chromium.org>; linux-wireless@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH v2] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
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
> v2:
>  - Add default value for module parameter.
> 
>  drivers/net/wireless/realtek/rtw88/pci.c | 74 ++++++++----------------
>  drivers/net/wireless/realtek/rtw88/pci.h |  1 +
>  2 files changed, 24 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> index 3b367c9085eba..4ab75ac2500e9 100644
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
> +static int rtw_rx_aspm = -1;
>  module_param_named(disable_msi, rtw_disable_msi, bool, 0644);
>  module_param_named(disable_aspm, rtw_pci_disable_aspm, bool, 0644);
> +module_param_named(rx_aspm, rtw_rx_aspm, int, 0444);
>  MODULE_PARM_DESC(disable_msi, "Set Y to disable MSI interrupt support");
>  MODULE_PARM_DESC(disable_aspm, "Set Y to disable PCI ASPM support");
> +MODULE_PARM_DESC(rx_aspm, "Use PCIe ASPM for RX (0=disable, 1=enable, -1=default)");
> 
>  static u32 rtw_pci_tx_queue_idx_addr[] = {
>  	[RTW_TX_QUEUE_BK]	= RTK_PCI_TXBD_IDX_BKQ,
> @@ -1409,7 +1411,11 @@ static void rtw_pci_link_ps(struct rtw_dev *rtwdev, bool enter)
>  	 * throughput. This is probably because the ASPM behavior slightly
>  	 * varies from different SOC.
>  	 */
> -	if (rtwpci->link_ctrl & PCI_EXP_LNKCTL_ASPM_L1)
> +	if (!(rtwpci->link_ctrl & PCI_EXP_LNKCTL_ASPM_L1))
> +		return;
> +
> +	if ((enter && atomic_dec_return(&rtwpci->link_usage) == 0) ||
> +	    (!enter && atomic_inc_return(&rtwpci->link_usage) == 1))
>  		rtw_pci_aspm_set(rtwdev, enter);
>  }
> 

I found calling pci_link_ps isn't always symmetric, so we need to reset
ref_cnt at pci_start() like below, or we can't enter rtw_pci_aspm_set()
anymore. The negative flow I face is 
ifup -> connect AP -> ifdown -> ifup (ref_cnt isn't expected now).


@@ -582,6 +582,8 @@ static int rtw_pci_start(struct rtw_dev *rtwdev)
        rtw_pci_napi_start(rtwdev);

        spin_lock_bh(&rtwpci->irq_lock);
+       atomic_set(&rtwpci->link_usage, 1);
        rtwpci->running = true;
        rtw_pci_enable_interrupt(rtwdev, rtwpci, false);
        spin_unlock_bh(&rtwpci->irq_lock);

--
Ping-Ke


