Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B52779002A
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 12:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfHPKoz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 16 Aug 2019 06:44:55 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:50081 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbfHPKoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 06:44:55 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7GAiiEL013279, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7GAiiEL013279
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 16 Aug 2019 18:44:44 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Fri, 16 Aug
 2019 18:44:43 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Jian-Hong Pan <jian-hong@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>
Subject: RE: [PATCH v2] rtw88: pci: Move a mass of jobs in hw IRQ to soft IRQ
Thread-Topic: [PATCH v2] rtw88: pci: Move a mass of jobs in hw IRQ to soft
 IRQ
Thread-Index: AQHVVBrblzqZYqIEtECYjaK+MuuQN6b9lGGg
Date:   Fri, 16 Aug 2019 10:44:42 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D18932B7@RTITMBSVM04.realtek.com.tw>
References: <CAPpJ_edibR0bxO0Pg=NAaRU8fGYheyN8NTv-gVyTDCJhE-iG5Q@mail.gmail.com>
 <20190816100903.7549-1-jian-hong@endlessm.com>
In-Reply-To: <20190816100903.7549-1-jian-hong@endlessm.com>
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
>  drivers/net/wireless/realtek/rtw88/pci.c | 33 +++++++++++++++++++-----
>  1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c
> b/drivers/net/wireless/realtek/rtw88/pci.c
> index 00ef229552d5..0740140d7e46 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -866,12 +866,28 @@ static irqreturn_t rtw_pci_interrupt_handler(int irq,
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

So basically it's to prevent back-to-back interrupts.

Nothing wrong about it, I just wondering why we don't like
back-to-back interrupts. Does it means that those interrupts
fired between irq_handler and threadfin would increase
much more time to consume them.

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
>  	rtw_pci_irq_recognized(rtwdev, rtwpci, irq_status);
> 
>  	if (irq_status[0] & IMR_MGNTDOK)
> @@ -891,8 +907,11 @@ static irqreturn_t rtw_pci_interrupt_handler(int irq,
> void *dev)
>  	if (irq_status[0] & IMR_ROK)
>  		rtw_pci_rx_isr(rtwdev, rtwpci, RTW_RX_QUEUE_MPDU);
> 
> -out:
> -	spin_unlock(&rtwpci->irq_lock);
> +	/* all of the jobs for this interrupt have been done */
> +	spin_lock_irqsave(&rtwpci->irq_lock, flags);

I suggest to protect the ISRs. Because next patches will require
to check if the TX DMA path is empty. This means I will also add
this rtwpci->irq_lock to the TX path, and check if the skb_queue
does not have any pending SKBs not DMAed successfully.

> +	if (rtw_flag_check(rtwdev, RTW_FLAG_RUNNING))

Why check the flag here? Is there any racing or something?
Otherwise it looks to break the symmetry.

> +		rtw_pci_enable_interrupt(rtwdev, rtwpci);
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
> 2.20.1

Yan-Hsuan

