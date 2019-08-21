Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFAB9747E
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 10:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfHUIQO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 21 Aug 2019 04:16:14 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:53908 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfHUIQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 04:16:14 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7L8G2T6024847, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7L8G2T6024847
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 21 Aug 2019 16:16:03 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Wed, 21 Aug
 2019 16:16:02 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Jian-Hong Pan <jian-hong@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>
Subject: RE: [PATCH v3] rtw88: pci: Move a mass of jobs in hw IRQ to soft IRQ
Thread-Topic: [PATCH v3] rtw88: pci: Move a mass of jobs in hw IRQ to soft
 IRQ
Thread-Index: AQHVVxV4a9vXb/ZjY0yHJCWFwbLdyKcFQKNg
Date:   Wed, 21 Aug 2019 08:16:01 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D18A5786@RTITMBSVM04.realtek.com.tw>
References: <CAPpJ_edU68X-Ki+J61qfws+1-=zv54bcak9tzkMX=CkDS5mOMA@mail.gmail.com>
 <20190820045934.24841-1-jian-hong@endlessm.com>
In-Reply-To: <20190820045934.24841-1-jian-hong@endlessm.com>
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

Hi,

> From: Jian-Hong Pan [mailto:jian-hong@endlessm.com]
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
>  drivers/net/wireless/realtek/rtw88/pci.c | 33 +++++++++++++++++++-----
>  1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c
> b/drivers/net/wireless/realtek/rtw88/pci.c
> index 00ef229552d5..a8c17a01f318 100644
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
> @@ -891,8 +908,10 @@ static irqreturn_t rtw_pci_interrupt_handler(int irq,
> void *dev)
>  	if (irq_status[0] & IMR_ROK)
>  		rtw_pci_rx_isr(rtwdev, rtwpci, RTW_RX_QUEUE_MPDU);
> 
> -out:
> -	spin_unlock(&rtwpci->irq_lock);
> +	/* all of the jobs for this interrupt have been done */
> +	if (rtw_flag_check(rtwdev, RTW_FLAG_RUNNING))
> +		rtw_pci_enable_interrupt(rtwdev, rtwpci);

I've applied this patch and tested it.
But I failed to connect to AP, it seems that the
scan_result is empty. And when I failed to connect
to the AP, I found that the IMR is not enabled.
I guess the check bypass the interrupt enable function.

And I also found that *without MSI*, the driver is
able to connect to the AP. Could you please verify
this patch again with MSI interrupt enabled and
send a v4?

You can find my MSI patch on
https://patchwork.kernel.org/patch/11081539/


> +	spin_unlock_irqrestore(&rtwpci->irq_lock, flags);
> 
>  	return IRQ_HANDLED;
>  }
> @@ -1152,8 +1171,10 @@ static int rtw_pci_probe(struct pci_dev *pdev,
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
> @@ -1192,7 +1213,7 @@ static void rtw_pci_remove(struct pci_dev *pdev)
>  	rtw_pci_disable_interrupt(rtwdev, rtwpci);
>  	rtw_pci_destroy(rtwdev, pdev);
>  	rtw_pci_declaim(rtwdev, pdev);
> -	free_irq(rtwpci->pdev->irq, rtwdev);
> +	devm_free_irq(rtwdev->dev, rtwpci->pdev->irq, rtwdev);
>  	rtw_core_deinit(rtwdev);
>  	ieee80211_free_hw(hw);
>  }
> --


NACK
Need to verify it with MSI https://patchwork.kernel.org/patch/11081539/
And hope v4 could fix it.

Yan-Hsuan

