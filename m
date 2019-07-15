Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E286769A34
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 19:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731875AbfGORu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 13:50:28 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38178 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730854AbfGORu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 13:50:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A402D60F38; Mon, 15 Jul 2019 17:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563213026;
        bh=/lSgWV0qhJBU7teaaZADnvZgryqOT8WpHGuFgc/JXVQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jXDMok2K0t9j+FlF3jnOeaP1fESmlr0cBRbMfnXnsU8WoMRWxB0VCRfQwGRZ/TFVw
         KVUmvyfz4Og86dYOdWaibruYtL8PH2cg2tUkzKvcTLbLcLGkYu6fesXLRHowZlmiBR
         b7CbYfm0uhPvyrTwdV3BunAd2D0Sz6DgLYuOmbsI=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B26A5608A5;
        Mon, 15 Jul 2019 17:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563213025;
        bh=/lSgWV0qhJBU7teaaZADnvZgryqOT8WpHGuFgc/JXVQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=lQDeg8i8+7KaebBVO5vlolqOWC/e6DJZQJeQ2VK6nIvHJS241jAtPcofIAPAoNxHM
         k+8JDMZO1AWKJ9PC1a4ZkPR/eyxcacglwnti9ekAOEbE4y3OLHtI9jrTJtoZvXMFnt
         m8umusvEmFMemKsA1gdIh0bOeNI1OaFXU8rTrn1I=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B26A5608A5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: work around uninitialized vht_pfr variable
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190708125050.3689133-1-arnd@arndb.de>
References: <20190708125050.3689133-1-arnd@arndb.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Miaoqing Pan <miaoqing@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Balaji Pothunoori <bpothuno@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>,
        Pradeep kumar Chitrapu <pradeepc@codeaurora.org>,
        Sriram R <srirrama@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190715175026.A402D60F38@smtp.codeaurora.org>
Date:   Mon, 15 Jul 2019 17:50:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> As clang points out, the vht_pfr is assigned to a struct member
> without being initialized in one case:
> 
> drivers/net/wireless/ath/ath10k/mac.c:7528:7: error: variable 'vht_pfr' is used uninitialized whenever 'if' condition
>       is false [-Werror,-Wsometimes-uninitialized]
>                 if (!ath10k_mac_can_set_bitrate_mask(ar, band, mask,
>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ath/ath10k/mac.c:7551:20: note: uninitialized use occurs here
>                 arvif->vht_pfr = vht_pfr;
>                                  ^~~~~~~
> drivers/net/wireless/ath/ath10k/mac.c:7528:3: note: remove the 'if' if its condition is always true
>                 if (!ath10k_mac_can_set_bitrate_mask(ar, band, mask,
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ath/ath10k/mac.c:7483:12: note: initialize the variable 'vht_pfr' to silence this warning
>         u8 vht_pfr;
> 
> Add an explicit but probably incorrect initialization here.
> I suspect we want a better fix here, but chose this approach to
> illustrate the issue.
> 
> Fixes: 8b97b055dc9d ("ath10k: fix failure to set multiple fixed rate")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

Patch applied to wireless-drivers.git, thanks.

ff414f31ce37 ath10k: work around uninitialized vht_pfr variable

-- 
https://patchwork.kernel.org/patch/11034993/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

