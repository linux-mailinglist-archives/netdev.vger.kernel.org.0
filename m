Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF638FCD3
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 09:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfHPHyf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 16 Aug 2019 03:54:35 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:40218 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfHPHye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 03:54:34 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7G7sNNx016892, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7G7sNNx016892
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 16 Aug 2019 15:54:24 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Fri, 16 Aug
 2019 15:54:23 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Jian-Hong Pan <jian-hong@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>
Subject: RE: [PATCH] rtw88: pci: Move a mass of jobs in hw IRQ to soft IRQ
Thread-Topic: [PATCH] rtw88: pci: Move a mass of jobs in hw IRQ to soft IRQ
Thread-Index: AQHVU/x2Dr02g4Mib0ipy5Mk0nEf5ab9Zdpg
Date:   Fri, 16 Aug 2019 07:54:22 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D18929BF@RTITMBSVM04.realtek.com.tw>
References: <20190816063109.4699-1-jian-hong@endlessm.com>
In-Reply-To: <20190816063109.4699-1-jian-hong@endlessm.com>
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

> From: Jian-Hong Pan [mailto:jian-hong@endlessm.com]
> 
> There is a mass of jobs between spin lock and unlock in the hardware
> IRQ which will occupy much time originally. To make system work more
> efficiently, this patch moves the jobs to the soft IRQ (bottom half) to
> reduce the time in hardware IRQ.
> 
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> ---
>  drivers/net/wireless/realtek/rtw88/pci.c | 36 +++++++++++++++++++-----
>  1 file changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c
> b/drivers/net/wireless/realtek/rtw88/pci.c
> index 00ef229552d5..355606b167c6 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -866,12 +866,29 @@ static irqreturn_t rtw_pci_interrupt_handler(int irq,
> void *dev)
>  {
>  	struct rtw_dev *rtwdev = dev;
>  	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> -	u32 irq_status[4];
> +	unsigned long flags;
> 
> -	spin_lock(&rtwpci->irq_lock);
> +	spin_lock_irqsave(&rtwpci->irq_lock, flags);
>  	if (!rtwpci->irq_enabled)
>  		goto out;
> 
> +	/* disable RTW PCI interrupt to avoid more interrupts before the end of
> +	 * thread function
> +	 */
> +	rtw_pci_disable_interrupt(rtwdev, rtwpci);
> +out:
> +	spin_unlock_irqrestore(&rtwpci->irq_lock, flags);
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
>  	rtw_pci_irq_recognized(rtwdev, rtwpci, irq_status);
> 
>  	if (irq_status[0] & IMR_MGNTDOK)
> @@ -891,8 +908,11 @@ static irqreturn_t rtw_pci_interrupt_handler(int irq,
> void *dev)
>  	if (irq_status[0] & IMR_ROK)
>  		rtw_pci_rx_isr(rtwdev, rtwpci, RTW_RX_QUEUE_MPDU);
> 
> -out:
> -	spin_unlock(&rtwpci->irq_lock);
> +	/* all of the jobs for this interrupt have been done */
> +	spin_lock_irqsave(&rtwpci->irq_lock, flags);

Shouldn't we protect the ISRs above?

This patch could actually reduce the time of IRQ.
But I think I need to further test it with PCI MSI interrupt.
https://patchwork.kernel.org/patch/11081539/

Maybe we could drop the "rtw_pci_[enable/disable]_interrupt" when MSI
Is enabled with this patch.

> +	if (rtw_flag_check(rtwdev, RTW_FLAG_RUNNING))
> +		rtw_pci_enable_interrupt(rtwdev, rtwpci);
> +	spin_unlock_irqrestore(&rtwpci->irq_lock, flags);
> 
>  	return IRQ_HANDLED;
>  }
> @@ -1152,8 +1172,10 @@ static int rtw_pci_probe(struct pci_dev *pdev,
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
> @@ -1192,7 +1214,7 @@ static void rtw_pci_remove(struct pci_dev *pdev)
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

Yan-Hsuan
