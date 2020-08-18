Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3749A248561
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 14:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgHRMww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 08:52:52 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:26212 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgHRMwl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 08:52:41 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597755161; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=AJEe/qRZ45RZeh5yzMAs+NsXlJGYmx+mOLYSkXXDB/A=;
 b=G8g1tzOJL9vMaDa39UPjV6LzJ1hqbsorVexAHj29PHY3N/zexm6Kf0OzTjbdR4NYFBhoMKuW
 r7iZ3egI2N+xeCy1LYnwoo93vjtLmNOhMFrJNW5cAko3kPYbvaOrXmHHW8jPW7R50xJRd9NA
 WiCqa7a46pB3Id4gLO5LyQN6K0s=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f3bcf0c2889723bf8b92ddd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 18 Aug 2020 12:52:28
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4CFD3C433AF; Tue, 18 Aug 2020 12:52:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A4268C433C6;
        Tue, 18 Aug 2020 12:52:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A4268C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: Do not use GFP_KERNEL in atomic context
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200809092906.744621-1-christophe.jaillet@wanadoo.fr>
References: <20200809092906.744621-1-christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     amitkarwar@gmail.com, ganapathi.bhat@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, kuba@kernel.org,
        yogeshp@marvell.com, bzhao@marvell.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200818125228.4CFD3C433AF@smtp.codeaurora.org>
Date:   Tue, 18 Aug 2020 12:52:28 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> A possible call chain is as follow:
>   mwifiex_sdio_interrupt                            (sdio.c)
>     --> mwifiex_main_process                        (main.c)
>       --> mwifiex_process_cmdresp                   (cmdevt.c)
>         --> mwifiex_process_sta_cmdresp             (sta_cmdresp.c)
>           --> mwifiex_ret_802_11_scan               (scan.c)
>             --> mwifiex_parse_single_response_buf   (scan.c)
> 
> 'mwifiex_sdio_interrupt()' is an interrupt function.
> 
> Also note that 'mwifiex_ret_802_11_scan()' already uses GFP_ATOMIC.
> 
> So use GFP_ATOMIC instead of GFP_KERNEL when memory is allocated in
> 'mwifiex_parse_single_response_buf()'.
> 
> Fixes: 7c6fa2a843c5 ("mwifiex: use cfg80211 dynamic scan table and cfg80211_get_bss API")
> or
> Fixes: 601216e12c65e ("mwifiex: process RX packets in SDIO IRQ thread directly")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Patch applied to wireless-drivers-next.git, thanks.

d2ab7f00f432 mwifiex: Do not use GFP_KERNEL in atomic context

-- 
https://patchwork.kernel.org/patch/11706587/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

