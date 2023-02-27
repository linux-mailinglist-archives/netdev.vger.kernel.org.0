Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBB46A4577
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 16:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjB0PAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 10:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjB0PAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 10:00:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC501F90B;
        Mon, 27 Feb 2023 07:00:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B8F18CE1054;
        Mon, 27 Feb 2023 15:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074B5C4339C;
        Mon, 27 Feb 2023 15:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677510035;
        bh=aGqo+beX4rpf9C772G4rfI3PDzyyWU40qI/tZHMx4Ec=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=N6gG8tXrOotmZtHYGZOFW82yXA0CP7fXiPBkZJLeJ9epC+6R3ku5FXR2K2uSrDeU/
         BTfmo7cpA2VoWJX1mzhAKgPigic2O2cA5HBmnmOoOUsSM6+GbEwt3GgMdDyzno+vSk
         olIGKotwFdm4MdL0MCE2XJIrvd9x7GdUQXIVnp56ovu8y+nAf5VIAE+Oym+tjWD/dA
         rLrQf6qV5c55YoxDmznT9bIUJp2pAfBrnc85E6sL8DYP+WaFa8+a7wsEp1n1rNlGO0
         3Az1YA5wznPw3spCWTsfrYAsK2iUr/eVBaiBaL6G5OGgka/jXSmwz1FBFAg/2WWkdp
         KFr/mhTLVEPvA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [01/10] wifi: brcmfmac: chip: Only disable D11 cores;
 handle an arbitrary number
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230214092423.15175-1-marcan@marcan.st>
References: <20230214092423.15175-1-marcan@marcan.st>
To:     Hector Martin <marcan@marcan.st>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Linus Walleij <linus.walleij@linaro.org>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167751002773.20016.17380164269465295465.kvalo@kernel.org>
Date:   Mon, 27 Feb 2023 15:00:31 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hector Martin <marcan@marcan.st> wrote:

> At least on BCM4387, the D11 cores are held in reset on cold startup and
> firmware expects to release reset itself. Just assert reset here and let
> firmware deassert it. Premature deassertion results in the firmware
> failing to initialize properly some of the time, with strange AXI bus
> errors.
> 
> Also, BCM4387 has 3 cores, up from 2. The logic for handling that is in
> brcmf_chip_ai_resetcore(), but since we aren't using that any more, just
> handle it here.
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hector Martin <marcan@marcan.st>

10 patches applied to wireless-next.git, thanks.

3c7c07ca7ab1 wifi: brcmfmac: chip: Only disable D11 cores; handle an arbitrary number
098e0b105ce1 wifi: brcmfmac: chip: Handle 1024-unit sizes for TCM blocks
398ce273d6b1 wifi: brcmfmac: cfg80211: Add support for scan params v2
d75ef1f81e42 wifi: brcmfmac: feature: Add support for setting feats based on WLC version
a96202acaea4 wifi: brcmfmac: cfg80211: Add support for PMKID_V3 operations
89b89e52153f wifi: brcmfmac: cfg80211: Pass the PMK in binary instead of hex
117ace4014cc wifi: brcmfmac: pcie: Add IDs/properties for BCM4387
dd7e55401fec wifi: brcmfmac: common: Add support for downloading TxCap blobs
75102b7543ed wifi: brcmfmac: pcie: Load and provide TxCap blobs
5b3ee9987f58 wifi: brcmfmac: common: Add support for external calibration blobs

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230214092423.15175-1-marcan@marcan.st/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

