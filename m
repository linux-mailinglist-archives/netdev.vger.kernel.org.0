Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727784FADCD
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 14:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238942AbiDJMXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 08:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiDJMXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 08:23:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7E82316B;
        Sun, 10 Apr 2022 05:20:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF726B80CD2;
        Sun, 10 Apr 2022 12:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494CAC385A1;
        Sun, 10 Apr 2022 12:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649593256;
        bh=8rVvQ/v6AjeqJYkFyCfN7dWBOUV0l+hLO2xQXIYjDcc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=tFPTVAAgnK7a3Osfp9ru7ZfsUu1keh/JibHhJTL1ih/C/YGkKzP5h7n6Oi1kJKwVJ
         zh7NabaURoQlqjmmJ/+aAmaGBOFrzdaIZAODx4KYfqzmLcFOAEBP7qiYzi6j9LWwVy
         Syvk8TlUDQYFtRNaN/g8LasyagKWIwGLUurN7yUFFG+harpCNFOrHvY/QXPPb36njT
         m4ldqk+qW9YeAv76N+f5kcCGUHf/ue8cgVqflPJKv93mNkhdQuBBzplEjzAVhuFrjT
         nACKCRoiYASnUHiURAHjLJCIUYaBY0OPx5bR+uFEknKLjoPI3JAXepmxAWm09Lq7Dr
         nrKCKzTJSo6eA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH 06/11] brcmfmac: sdio: Fix undefined behavior due
 to
 shift overflowing the constant
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <Ykx0iRlvtBnKqtbG@zn.tnic>
References: <Ykx0iRlvtBnKqtbG@zn.tnic>
To:     Borislav Petkov <bp@alien8.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164959325197.9942.3706539176103286377.kvalo@kernel.org>
Date:   Sun, 10 Apr 2022 12:20:54 +0000 (UTC)
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

> Fix:
> 
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c: In function ‘brcmf_sdio_drivestrengthinit’:
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:3798:2: error: case label does not reduce to an integer constant
>     case SDIOD_DRVSTR_KEY(BRCM_CC_43143_CHIP_ID, 17):
>     ^~~~
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:3809:2: error: case label does not reduce to an integer constant
>     case SDIOD_DRVSTR_KEY(BRCM_CC_43362_CHIP_ID, 13):
>     ^~~~
> 
> See https://lore.kernel.org/r/YkwQ6%2BtIH8GQpuct@zn.tnic for the gory
> details as to why it triggers with older gccs only.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Arend van Spriel <aspriel@gmail.com>
> Cc: Franky Lin <franky.lin@broadcom.com>
> Cc: Hante Meuleman <hante.meuleman@broadcom.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: brcm80211-dev-list.pdl@broadcom.com
> Cc: netdev@vger.kernel.org
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless.git, thanks.

6fb3a5868b21 brcmfmac: sdio: Fix undefined behavior due to shift overflowing the constant

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/Ykx0iRlvtBnKqtbG@zn.tnic/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

