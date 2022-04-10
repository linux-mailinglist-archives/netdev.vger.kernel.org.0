Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87CB4FADCA
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 14:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238849AbiDJMWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 08:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiDJMWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 08:22:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FCFE62;
        Sun, 10 Apr 2022 05:20:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D05460FBD;
        Sun, 10 Apr 2022 12:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12370C385A1;
        Sun, 10 Apr 2022 12:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649593207;
        bh=LxtG54NBHoX/6nt80j3RmlvDuYO+dOaF8JAOsZkzfzU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=fJQAD7FnfAbIyus7qY+FDeCJMCpT6Tvt0PgmqpAN6tIPLs3s0+tFVmoR8Oqz0nVdI
         dLauRSt83d4j0isphw/yDSiMnGubLea+s4MWJDOzzghdpyecRa+avVsNXACKgcTEyj
         +EpTJxKCQmfzIsHaBes8w4n3KGaMtyCqz4S9TJKxAIEMIFI1HvEvcJNtvJFmdVF5ll
         RWoN7xAkGOXk1jvhFj9RC3BuUv/NNb5kzxE+gpaUlwu2KWKiaQnd1U+KXwgZNqaLKu
         tjIV8zMsUW4CpgUxFVztU1wGw/kI54d9a8xOzDB4Olnp5ebLF9XhVttvWVlWihkODO
         BdEYG1Q+t9Ypw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 08/11] mt76: Fix undefined behavior due to shift
 overflowing
 the constant
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220405151517.29753-9-bp@alien8.de>
References: <20220405151517.29753-9-bp@alien8.de>
To:     Borislav Petkov <bp@alien8.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164959319325.9942.16889014735798939787.kvalo@kernel.org>
Date:   Sun, 10 Apr 2022 12:20:04 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Borislav Petkov <bp@alien8.de> wrote:

> From: Borislav Petkov <bp@suse.de>
> 
> Fix:
> 
>   drivers/net/wireless/mediatek/mt76/mt76x2/pci.c: In function ‘mt76x2e_probe’:
>   ././include/linux/compiler_types.h:352:38: error: call to ‘__compiletime_assert_946’ \
> 	declared with attribute error: FIELD_PREP: mask is not constant
>     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> 
> See https://lore.kernel.org/r/YkwQ6%2BtIH8GQpuct@zn.tnic for the gory
> details as to why it triggers with older gccs only.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Felix Fietkau <nbd@nbd.name>
> Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> Cc: Ryder Lee <ryder.lee@mediatek.com>
> Cc: Shayne Chen <shayne.chen@mediatek.com>
> Cc: Sean Wang <sean.wang@mediatek.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org

Patch applied to wireless.git, thanks.

dbc2b1764734 mt76: Fix undefined behavior due to shift overflowing the constant

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220405151517.29753-9-bp@alien8.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

