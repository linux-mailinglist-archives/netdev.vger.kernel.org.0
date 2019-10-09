Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F5ED097E
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbfJIIUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:20:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52680 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfJIIUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 04:20:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 150BC602F2; Wed,  9 Oct 2019 08:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609243;
        bh=won6aQFfRzI6wDg9O8Y3PJvAuhPwmALIXjuPviDx9LE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=OP10dNe+oHNpvEGq6bw1RIHPVA8t8XPwNUAU4aQdpiUOC+iZRF8ZNl4IZUkeKYVDj
         Vbmt3jvlHTTFJv45UBb4/+PxMujwfaEdbuf9isuLPyjGUA80Yi/mgELpRcsP37fABl
         epcc6fkHiLG5MDgjgp/8KmyLKyVvxbmXDNVbOCDQ=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AF446602F2;
        Wed,  9 Oct 2019 08:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609241;
        bh=won6aQFfRzI6wDg9O8Y3PJvAuhPwmALIXjuPviDx9LE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=nx46CuoiHm7zhPfsb4z/gse3vvadalnS81V6iDQ0D8tSHY5cKAFxJwgcBkPz/MHBX
         wQH1AuXRJyUcqsRa8SFtRqQv/7H2bF48KT/DcmhBdncfyjYkj8OWPdol05zgCE5YBN
         im0++dtwCm8/75hNMba8Uc8fpzrFT376e88nFjs0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AF446602F2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v8] rtl8xxxu: Improve TX performance of RTL8723BU on
 rtl8xxxu driver
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191002121808.59376-1-chiu@endlessm.com>
References: <20191002121808.59376-1-chiu@endlessm.com>
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Daniel Drake <drake@endlessm.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191009082043.150BC602F2@smtp.codeaurora.org>
Date:   Wed,  9 Oct 2019 08:20:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chiu@endlessm.com> wrote:

> We have 3 laptops which connect the wifi by the same RTL8723BU.
> The PCI VID/PID of the wifi chip is 10EC:B720 which is supported.
> They have the same problem with the in-kernel rtl8xxxu driver, the
> iperf (as a client to an ethernet-connected server) gets ~1Mbps.
> Nevertheless, the signal strength is reported as around -40dBm,
> which is quite good. From the wireshark capture, the tx rate for each
> data and qos data packet is only 1Mbps. Compare to the Realtek driver
> at https://github.com/lwfinger/rtl8723bu, the same iperf test gets
> ~12Mbps or better. The signal strength is reported similarly around
> -40dBm. That's why we want to improve.
> 
> After reading the source code of the rtl8xxxu driver and Realtek's, the
> major difference is that Realtek's driver has a watchdog which will keep
> monitoring the signal quality and updating the rate mask just like the
> rtl8xxxu_gen2_update_rate_mask() does if signal quality changes.
> And this kind of watchdog also exists in rtlwifi driver of some specific
> chips, ex rtl8192ee, rtl8188ee, rtl8723ae, rtl8821ae...etc. They have
> the same member function named dm_watchdog and will invoke the
> corresponding dm_refresh_rate_adaptive_mask to adjust the tx rate
> mask.
> 
> With this commit, the tx rate of each data and qos data packet will
> be 39Mbps (MCS4) with the 0xF00000 as the tx rate mask. The 20th bit
> to 23th bit means MCS4 to MCS7. It means that the firmware still picks
> the lowest rate from the rate mask and explains why the tx rate of
> data and qos data is always lowest 1Mbps because the default rate mask
> passed is always 0xFFFFFFF ranges from the basic CCK rate, OFDM rate,
> and MCS rate. However, with Realtek's driver, the tx rate observed from
> wireshark under the same condition is almost 65Mbps or 72Mbps, which
> indicating that rtl8xxxu could still be further improved.
> 
> Signed-off-by: Chris Chiu <chiu@endlessm.com>
> Reviewed-by: Daniel Drake <drake@endlessm.com>
> Acked-by: Jes Sorensen <Jes.Sorensen@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

a9bb0b515778 rtl8xxxu: Improve TX performance of RTL8723BU on rtl8xxxu driver

-- 
https://patchwork.kernel.org/patch/11170977/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

