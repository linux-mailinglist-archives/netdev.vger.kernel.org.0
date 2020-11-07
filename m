Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9382AA4AD
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 12:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgKGLcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 06:32:51 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:41417 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbgKGLct (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 06:32:49 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604748769; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=J5hlXp8ODgBGWRCIR8UQ6KIXJevlP1gpseMXY6FOGNQ=;
 b=Yzp3nnPR9sX915K9ZxasdDR/6AkAxZQ01TlM55oW1ni/aChXlCZZ3Z986WFi/HXr60ntB7DA
 JMP1Vu4ElkM+jgJj0JI81hWpKXPJ8QlVoONv8e1GHLPPXKgj+bvXq2QTz1kp9y6j7JHfW9cr
 pozF/CJgeXnpwhKgP6QKzR/Bp3s=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5fa685e061a7f890a695a76f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 11:32:48
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A4EBEC433FE; Sat,  7 Nov 2020 11:32:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 24BC6C433C8;
        Sat,  7 Nov 2020 11:32:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 24BC6C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: Fix TX EAPOL packet handling against iwlwifi AP
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201015111616.429220-1-marex@denx.de>
References: <20201015111616.429220-1-marex@denx.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Kepplinger <martink@posteo.de>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201107113248.A4EBEC433FE@smtp.codeaurora.org>
Date:   Sat,  7 Nov 2020 11:32:48 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marek Vasut <marex@denx.de> wrote:

> In case RSI9116 SDIO WiFi operates in STA mode against Intel 9260 in AP mode,
> the association fails. The former is using wpa_supplicant during association,
> the later is set up using hostapd:
> 
> iwl$ cat hostapd.conf
> interface=wlp1s0
> ssid=test
> country_code=DE
> hw_mode=g
> channel=1
> wpa=2
> wpa_passphrase=test
> wpa_key_mgmt=WPA-PSK
> iwl$ hostapd -d hostapd.conf
> 
> rsi$ wpa_supplicant -i wlan0 -c <(wpa_passphrase test test)
> 
> The problem is that the TX EAPOL data descriptor RSI_DESC_REQUIRE_CFM_TO_HOST
> flag and extended descriptor EAPOL4_CONFIRM frame type are not set in case the
> AP is iwlwifi, because in that case the TX EAPOL packet is 2 bytes shorter.
> 
> The downstream vendor driver has this change in place already [1], however
> there is no explanation for it, neither is there any commit history from which
> such explanation could be obtained.
> 
> [1] https://github.com/SiliconLabs/RS911X-nLink-OSD/blob/master/rsi/rsi_91x_hal.c#L238
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Angus Ainslie <angus@akkea.ca>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Martin Kepplinger <martink@posteo.de>
> Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
> Cc: Siva Rebbagondla <siva8118@gmail.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org

Patch applied to wireless-drivers-next.git, thanks.

65277100caa2 rsi: Fix TX EAPOL packet handling against iwlwifi AP

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201015111616.429220-1-marex@denx.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

