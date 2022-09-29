Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECACB5EEB71
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbiI2CJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbiI2CJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:09:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A813C13D41
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 19:09:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38FF661AD2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB72BC433C1;
        Thu, 29 Sep 2022 02:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664417381;
        bh=8U2R8U8IuBgofNLvI4s6FImBhCH5B70PhnDWBOIJ6Ws=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VjR6M0rCxNlAN5h/ia3DBElBR9LAbWDGeI9LfyAY26Z96u3TXCoR7FYOVtxrnmlll
         XbAXnUk7KAT1yPQvMxE9FmQhwuB6ij8sk9EsYZKnxwWWn19t02nC+p+QhevCD15F7c
         NQxEadwkv1pDhzd32P4MnyYzg4OrN/X4ZSnYV7A3riMIY1Xkc934RP05/mUuTR5QS7
         yqgwD4EmvAMaJs9k+GhU6L09KiPfa2VqqH3An+4KAe+jWCKSU8Kd092o2Q1R51yFke
         8B3kai250natQze16KhxDPnP4yt/wz1cd1M4pc7nPJFvynC+DyuDK9/Uf4HA4dg7oL
         EcxL6oaKjz45A==
Date:   Wed, 28 Sep 2022 19:09:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sujuan Chen <sujuan.chen@mediatek.com>,
        Bo Jiao <Bo.Jiao@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chen Minqiang <ptpt52@gmail.com>,
        Thomas =?UTF-8?B?SMO8aG4=?= <thomas.huehn@hs-nordhausen.de>
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: fix state in
 __mtk_foe_entry_clear
Message-ID: <20220928190939.3c43516f@kernel.org>
In-Reply-To: <YzOie0dkiQ43EPnu@makrotopia.org>
References: <YzOie0dkiQ43EPnu@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 02:25:15 +0100 Daniel Golle wrote:
> Setting ib1 state to MTK_FOE_STATE_UNBIND in __mtk_foe_entry_clear
> routine as done by commit 0e80707d94e4c8 ("net: ethernet: mtk_eth_soc:
> fix typo in __mtk_foe_entry_clear") breaks flow offloading, at least
> on older MTK_NETSYS_V1 SoCs; OpenWrt users have confirmed the bug on
> MT7622 and MT7621 systems.
> Felix Fietkau suggested to use MTK_FOE_STATE_INVALID instead which
> works well on both, MTK_NETSYS_V1 and MTK_NETSYS_V2.
> 
> Tested on MT7622 (Linksys E8450) and MT7986 (BananaPi BPI-R3).
> 
> Suggested-by: Felix Fietkau <nbd@nbd.name>
> Fixes: 0e80707d94e4c8 ("net: ethernet: mtk_eth_soc: fix typo in __mtk_foe_entry_clear")
> Fixes: 33fc42de33278 ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Looks like this patch is generated on top of net-next while it fixes 
a bug in net (judging by mention of 0e80707d94e4c8).
Please rebase on top of net and resent, we'll deal with the conflict.
