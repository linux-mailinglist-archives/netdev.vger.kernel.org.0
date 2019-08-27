Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61FDB9E3D7
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 11:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbfH0JUo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Aug 2019 05:20:44 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:45767 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfH0JUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 05:20:43 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7R9KWis027676, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7R9KWis027676
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Aug 2019 17:20:33 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Tue, 27 Aug
 2019 17:20:32 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Jian-Hong Pan <jian-hong@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>
Subject: RE: [PATCH v4] rtw88: pci: Move a mass of jobs in hw IRQ to soft IRQ
Thread-Topic: [PATCH v4] rtw88: pci: Move a mass of jobs in hw IRQ to soft
 IRQ
Thread-Index: AQHVW93/L3LBm1nnhUKTmpJa6tAmKKcOtzHQ
Date:   Tue, 27 Aug 2019 09:20:32 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D18AE2DA@RTITMBSVM04.realtek.com.tw>
References: <F7CD281DE3E379468C6D07993EA72F84D18A5786@RTITMBSVM04.realtek.com.tw>
 <20190826070827.1436-1-jian-hong@endlessm.com>
In-Reply-To: <20190826070827.1436-1-jian-hong@endlessm.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.183]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jian-Hong Pan 
> Subject: [PATCH v4] rtw88: pci: Move a mass of jobs in hw IRQ to soft IRQ
> 
> There is a mass of jobs between spin lock and unlock in the hardware
> IRQ which will occupy much time originally. To make system work more
> efficiently, this patch moves the jobs to the soft IRQ (bottom half) to
> reduce the time in hardware IRQ.
> 
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> ---
> v2:
>  Change the spin_lock_irqsave/unlock_irqrestore to spin_lock/unlock in
>  rtw_pci_interrupt_handler. Because the interrupts are already disabled
>  in the hardware interrupt handler.
> 
> v3:
>  Extend the spin lock protecting area for the TX path in
>  rtw_pci_interrupt_threadfn by Realtek's suggestion
> 
> v4:
>  Remove the WiFi running check in rtw_pci_interrupt_threadfn to avoid AP
>  connection failed by Realtek's suggestion.
> 
>  drivers/net/wireless/realtek/rtw88/pci.c | 32 +++++++++++++++++++-----
>  1 file changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c
> b/drivers/net/wireless/realtek/rtw88/pci.c
> index 00ef229552d5..955dd6c6fb57 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -866,12 +866,29 @@ static irqreturn_t rtw_pci_interrupt_handler(int irq,
> void *dev)
>  {
>  	struct rtw_dev *rtwdev = dev;
>  	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> -	u32 irq_status[4];
> 
>  	spin_lock(&rtwpci->irq_lock);
>  	if (!rtwpci->irq_enabled)
>  		goto out;
> 
> +	/* disable RTW PCI interrupt to avoid more interrupts before the end of
> +	 * thread function
> +	 */
> +	rtw_pci_disable_interrupt(rtwdev, rtwpci);
> +out:
> +	spin_unlock(&rtwpci->irq_lock);
> +
> +	return IRQ_WAKE_THREAD;
> +}
> +
> +static irqreturn_t rtw_pci_interrupt_threadfn(int irq, void *dev)
> +{
> +	struct rtw_dev *rtwdev = dev;
> +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> +	unsigned long flags;
> +	u32 irq_status[4];
> +
> +	spin_lock_irqsave(&rtwpci->irq_lock, flags);
>  	rtw_pci_irq_recognized(rtwdev, rtwpci, irq_status);
> 
>  	if (irq_status[0] & IMR_MGNTDOK)
> @@ -891,8 +908,9 @@ static irqreturn_t rtw_pci_interrupt_handler(int irq,
> void *dev)
>  	if (irq_status[0] & IMR_ROK)
>  		rtw_pci_rx_isr(rtwdev, rtwpci, RTW_RX_QUEUE_MPDU);
> 
> -out:
> -	spin_unlock(&rtwpci->irq_lock);
> +	/* all of the jobs for this interrupt have been done */
> +	rtw_pci_enable_interrupt(rtwdev, rtwpci);
> +	spin_unlock_irqrestore(&rtwpci->irq_lock, flags);
> 
>  	return IRQ_HANDLED;
>  }
> @@ -1152,8 +1170,10 @@ static int rtw_pci_probe(struct pci_dev *pdev,
>  		goto err_destroy_pci;
>  	}
> 
> -	ret = request_irq(pdev->irq, &rtw_pci_interrupt_handler,
> -			  IRQF_SHARED, KBUILD_MODNAME, rtwdev);
> +	ret = devm_request_threaded_irq(rtwdev->dev, pdev->irq,
> +					rtw_pci_interrupt_handler,
> +					rtw_pci_interrupt_threadfn,
> +					IRQF_SHARED, KBUILD_MODNAME, rtwdev);
>  	if (ret) {
>  		ieee80211_unregister_hw(hw);
>  		goto err_destroy_pci;
> @@ -1192,7 +1212,7 @@ static void rtw_pci_remove(struct pci_dev *pdev)
>  	rtw_pci_disable_interrupt(rtwdev, rtwpci);
>  	rtw_pci_destroy(rtwdev, pdev);
>  	rtw_pci_declaim(rtwdev, pdev);
> -	free_irq(rtwpci->pdev->irq, rtwdev);
> +	devm_free_irq(rtwdev->dev, rtwpci->pdev->irq, rtwdev);
>  	rtw_core_deinit(rtwdev);
>  	ieee80211_free_hw(hw);
>  }
> --
> 2.20.1


Now it works fine with MSI interrupt enabled.

But this patch is conflicting with MSI interrupt patch.
Is there a better way we can make Kalle apply them more smoothly?
I can rebase them and submit both if you're OK.

Yan-Hsuan
