Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3DBE511056
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 06:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357749AbiD0FAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 01:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238018AbiD0E77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 00:59:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE3619036;
        Tue, 26 Apr 2022 21:56:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49F7F612CC;
        Wed, 27 Apr 2022 04:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6114C385A7;
        Wed, 27 Apr 2022 04:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651035407;
        bh=MSFzUcRNg3RCAc6GuNvEe9PTcE9/ik3gOrUQlBnl3Oc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hDBgYSpOPGO1mvQEty7EQ6hDFRPKePqy5hTQwmBE79HBmebBxT+qsgG/SI9sNK66G
         U57BkaZWVMTByMSWob7ynnUuY5iTx/sU/VmVH/iFInXNe9Xv9eBPgB3pcleUNM+iLk
         xiKdTXVlM4hVyxJijKlKuFfpeLC78tRKX8tyIX+neKe6EX7m3Z+UFeLm3xCFGTIgHc
         D7XIpXBlKCHfurXuOBtGnB7KLYUsc6yTt2ZKqJr+K6NELlauUSt6GQFEPDapxR6Z0T
         BTLq41j4g5Kevui6Wz6LmDuoo0Dg27jTZxd/HagpWKqohaJMqwgdTHGEQw5kzozBmP
         yuVfIM2oi2oAw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/2] mwifiex: Select firmware based on strapping
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220422090313.125857-2-andrejs.cainikovs@toradex.com>
References: <20220422090313.125857-2-andrejs.cainikovs@toradex.com>
To:     Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
Cc:     linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Andrejs Cainikovs <andrejs.cainikovs@toradex.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        =?utf-8?q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>,
        =?utf-8?q?Alvin_=C5=A0ipra?= =?utf-8?q?ga?= 
        <alsi@bang-olufsen.dk>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165103540307.18987.14473216112376027379.kvalo@kernel.org>
Date:   Wed, 27 Apr 2022 04:56:44 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrejs Cainikovs <andrejs.cainikovs@toradex.com> wrote:

> Some WiFi/Bluetooth modules might have different host connection
> options, allowing to either use SDIO for both WiFi and Bluetooth,
> or SDIO for WiFi and UART for Bluetooth. It is possible to detect
> whether a module has SDIO-SDIO or SDIO-UART connection by reading
> its host strap register.
> 
> This change introduces a way to automatically select appropriate
> firmware depending of the connection method, and removes a need
> of symlinking or overwriting the original firmware file with a
> required one.
> 
> Host strap register used in this commit comes from the NXP driver [1]
> hosted at Code Aurora.
> 
> [1] https://source.codeaurora.org/external/imx/linux-imx/tree/drivers/net/wireless/nxp/mxm_wifiex/wlan_src/mlinux/moal_sdio_mmc.c?h=rel_imx_5.4.70_2.3.2&id=688b67b2c7220b01521ffe560da7eee33042c7bd#n1274
> 
> Signed-off-by: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>

2 patches applied to wireless-next.git, thanks.

255ca28a659d mwifiex: Select firmware based on strapping
562354ab9f0a mwifiex: Add SD8997 SDIO-UART firmware

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220422090313.125857-2-andrejs.cainikovs@toradex.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

