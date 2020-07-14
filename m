Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D3421ED13
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 11:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgGNJmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 05:42:13 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:20247 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725816AbgGNJmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 05:42:11 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594719730; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=rwaiPjJK4tdDLIrGur1Wip379yC4QzqC1DFY1MsdhpI=; b=THVS4wYMdlnzmbgStf2hRRMfSUYWsuogSaGGY2PkZ+3wCuVpLrBxYbT3f9Urp1z6qjBrVufP
 Jvg3Xyf4wbKm2h6npx+Bc8iQSiLj8Vyxus3VuRGbTHizKf7p6qDNmS72a7w4guJWBHklsYzf
 XUT5fkjCxKEU/tBSokupYimljK8=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5f0d7de7ee6926bb4f054443 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 14 Jul 2020 09:41:59
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DC794C433A1; Tue, 14 Jul 2020 09:41:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6DEE0C433CB;
        Tue, 14 Jul 2020 09:41:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6DEE0C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Cc:     linux-kernel@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: set timeout value when configuring power save
References: <20200707155410.12123-1-nsaenzjulienne@suse.de>
Date:   Tue, 14 Jul 2020 12:41:52 +0300
In-Reply-To: <20200707155410.12123-1-nsaenzjulienne@suse.de> (Nicolas Saenz
        Julienne's message of "Tue, 7 Jul 2020 17:54:10 +0200")
Message-ID: <87blkicu1r.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nicolas Saenz Julienne <nsaenzjulienne@suse.de> writes:

> Set the timeout value as per cfg80211's set_power_mgmt() request. If the
> requested value value is left undefined we set it to 2 seconds, the
> maximum supported value.
>
> Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
> ---
>
> Note: I got the 2 seconds value from the Raspberry Pi downstream kernel.
>
>  .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index a757abd7a599..15578c6e87cd 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -84,6 +84,8 @@
>  
>  #define BRCMF_ND_INFO_TIMEOUT		msecs_to_jiffies(2000)
>  
> +#define BRCMF_PS_MAX_TIMEOUT_MS		2000
> +
>  #define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
>  	(sizeof(struct brcmf_assoc_params_le) - sizeof(u16))
>  
> @@ -2941,6 +2943,14 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
>  		else
>  			bphy_err(drvr, "error (%d)\n", err);
>  	}
> +
> +	if ((u32)timeout > BRCMF_PS_MAX_TIMEOUT_MS)
> +		timeout = BRCMF_PS_MAX_TIMEOUT_MS;

Wouldn't min_t() be better? Then you won't need the ugly cast either.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
