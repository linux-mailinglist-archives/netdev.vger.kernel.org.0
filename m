Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3175A7B9C
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 08:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbfIDGW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 02:22:57 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39002 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfIDGW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 02:22:56 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6B4F06118D; Wed,  4 Sep 2019 06:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567578175;
        bh=sX4wUU1Z+EEjkXnAJJUynkW//cqIx3NgupRk/80G09w=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=G45S1fHkYwllVuR3KethfCkAwzXil4F4rMD/EHJjXtBGY8/LCPrluAIwymDb/SZhP
         1KyrpJRPIMCsrdr+JqxdueO5dvKsEB9ND6/C91n0NK3S+yxjhH19T57BNH4LEjR5GD
         N/zT2JcyFiQLrRD+og4/WvPtSZJ3c59zFM5gTCBo=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D386E602A7;
        Wed,  4 Sep 2019 06:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567578173;
        bh=sX4wUU1Z+EEjkXnAJJUynkW//cqIx3NgupRk/80G09w=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Zowoyk2tg2cYp+DpKyZPclWGn9Oo4wP7VmY1rAqnaSjr+F9M6Q3DtFj12XUdGk/9v
         K8RQrB9lQo04lQke59kFiJl7jW01iarvhcCl1kvra1a1tRlBM2d5OeTMt2VvZfTpoH
         42EvUX077QvnHvkKI6IjN7Zov8P5LCPodCUdbNTc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D386E602A7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wcn36xx: use dynamic allocation for large variables
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190722145910.1156473-1-arnd@arndb.de>
References: <20190722145910.1156473-1-arnd@arndb.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190904062255.6B4F06118D@smtp.codeaurora.org>
Date:   Wed,  4 Sep 2019 06:22:54 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> clang triggers a warning about oversized stack frames that gcc does not
> notice because of slightly different inlining decisions:
> 
> ath/wcn36xx/smd.c:1409:5: error: stack frame size of 1040 bytes in function 'wcn36xx_smd_config_bss' [-Werror,-Wframe-larger-than=]
> ath/wcn36xx/smd.c:640:5: error: stack frame size of 1032 bytes in function 'wcn36xx_smd_start_hw_scan' [-Werror,-Wframe-larger-than=]
> 
> Basically the wcn36xx_hal_start_scan_offload_req_msg,
> wcn36xx_hal_config_bss_req_msg_v1, and wcn36xx_hal_config_bss_req_msg
> structures are too large to be put on the kernel stack, but small
> enough that gcc does not warn about them.
> 
> Use kzalloc() to allocate them all. There are similar structures in other
> parts of this driver, but they are all smaller, with the next largest
> stack frame at 480 bytes for wcn36xx_smd_send_beacon.
> 
> Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

355cf3191201 wcn36xx: use dynamic allocation for large variables

-- 
https://patchwork.kernel.org/patch/11052589/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

