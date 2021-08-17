Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B294D3EEA72
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 12:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbhHQKCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 06:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236099AbhHQKCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 06:02:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36583C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 03:01:58 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1mFvum-0000we-5L; Tue, 17 Aug 2021 12:01:48 +0200
Subject: Re: [PATCH] brcmfmac: pcie: fix oops on failure to resume and reprobe
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc:     kernel@pengutronix.de, SHA-cyfmac-dev-list@infineon.com,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, rafal@milecki.pl
References: <20210817063521.22450-1-a.fatoum@pengutronix.de>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <263120bc-72be-2acd-35cb-4cbc3d543804@pengutronix.de>
Date:   Tue, 17 Aug 2021 12:01:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210817063521.22450-1-a.fatoum@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.08.21 08:35, Ahmad Fatoum wrote:
> When resuming from suspend, brcmf_pcie_pm_leave_D3 will first attempt a
> hot resume and then fall back to removing the PCI device and then
> reprobing. If this probe fails, the kernel will oops, because brcmf_err,
> which is called to report the failure will dereference the stale bus
> pointer. Open code and use the default bus-less brcmf_err to avoid this.

Should've included a Fixes tag:

Fixes: 8602e62441ab ("brcmfmac: pass bus to the __brcmf_err() in pcie.c")

Please let me know if I should resend with the tag added.

Cheers,
Ahmad
 
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> ---
> To: Arend van Spriel <aspriel@gmail.com>
> To: Franky Lin <franky.lin@broadcom.com>
> To: Hante Meuleman <hante.meuleman@broadcom.com>
> To: Chi-hsien Lin <chi-hsien.lin@infineon.com>
> To: Wright Feng <wright.feng@infineon.com>
> To: Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
> Cc: SHA-cyfmac-dev-list@infineon.com
> Cc: brcm80211-dev-list.pdl@broadcom.com
> Cc: netdev@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 9ef94d7a7ca7..d824bea4b79d 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -2209,7 +2209,7 @@ static int brcmf_pcie_pm_leave_D3(struct device *dev)
>  
>  	err = brcmf_pcie_probe(pdev, NULL);
>  	if (err)
> -		brcmf_err(bus, "probe after resume failed, err=%d\n", err);
> +		__brcmf_err(NULL, __func__, "probe after resume failed, err=%d\n", err);
>  
>  	return err;
>  }
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
