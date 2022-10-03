Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F835F3174
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 15:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiJCNsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 09:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiJCNsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 09:48:07 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D2E2A973
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 06:48:05 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1ofLnR-0004nb-3A;
        Mon, 03 Oct 2022 15:47:50 +0200
Date:   Mon, 3 Oct 2022 14:47:42 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
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
        Thomas =?iso-8859-1?Q?H=FChn?= <thomas.huehn@hs-nordhausen.de>
Subject: Re: [PATCH v2] net: ethernet: mtk_eth_soc: fix state in
 __mtk_foe_entry_clear: manual merge
Message-ID: <Yzrn/ozGZn6v9oQ1@makrotopia.org>
References: <20220928190939.3c43516f@kernel.org>
 <YzY+1Yg0FBXcnrtc@makrotopia.org>
 <6cb6893b-4921-a068-4c30-1109795110bb@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cb6893b-4921-a068-4c30-1109795110bb@tessares.net>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 02:59:32PM +0200, Matthieu Baerts wrote:
> Hello,
> 
> On 30/09/2022 02:56, Daniel Golle wrote:
> > Setting ib1 state to MTK_FOE_STATE_UNBIND in __mtk_foe_entry_clear
> > routine as done by commit 0e80707d94e4c8 ("net: ethernet: mtk_eth_soc:
> > fix typo in __mtk_foe_entry_clear") breaks flow offloading, at least
> > on older MTK_NETSYS_V1 SoCs, OpenWrt users have confirmed the bug on
> > MT7622 and MT7621 systems.
> > Felix Fietkau suggested to use MTK_FOE_STATE_INVALID instead which
> > works well on both, MTK_NETSYS_V1 and MTK_NETSYS_V2.
> > 
> > Tested on MT7622 (Linksys E8450) and MT7986 (BananaPi BPI-R3).
> > 
> > Suggested-by: Felix Fietkau <nbd@nbd.name>
> > Fixes: 0e80707d94e4c8 ("net: ethernet: mtk_eth_soc: fix typo in __mtk_foe_entry_clear")
> > Fixes: 33fc42de33278b ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > ---
> > v2: rebased on top of netdev/net.git;main
> 
> FYI and as expected when reading this email thread, we got a small
> conflict when merging -net in net-next in the MPTCP tree due to this
> patch applied in -net:
> 
>   ae3ed15da588 ("net: ethernet: mtk_eth_soc: fix state in
> __mtk_foe_entry_clear")
> 
> and this one from net-next:
> 
>   9d8cb4c096ab ("net: ethernet: mtk_eth_soc: add foe_entry_size to
> mtk_eth_soc")
> 
> The conflict has been resolved on our side[1] inspired by Daniel's v1.
> The resolution we suggest is attached to this email.

conflict resolution: Acked-by: Daniel Golle <daniel@makrotopia.org>

> 
> Cheers,
> Matt
> 
> [1] https://github.com/multipath-tcp/mptcp_net-next/commit/7af5fac658ba
> -- 
> Tessares | Belgium | Hybrid Access Solutions
> www.tessares.net

> diff --cc drivers/net/ethernet/mediatek/mtk_ppe.c
> index 887f430734f7,148ea636ef97..ae00e572390d
> --- a/drivers/net/ethernet/mediatek/mtk_ppe.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
> @@@ -439,10 -410,9 +439,10 @@@ __mtk_foe_entry_clear(struct mtk_ppe *p
>   
>   	hlist_del_init(&entry->list);
>   	if (entry->hash != 0xffff) {
>  -		ppe->foe_table[entry->hash].ib1 &= ~MTK_FOE_IB1_STATE;
>  -		ppe->foe_table[entry->hash].ib1 |= FIELD_PREP(MTK_FOE_IB1_STATE,
>  -							      MTK_FOE_STATE_INVALID);
>  +		struct mtk_foe_entry *hwe = mtk_foe_get_entry(ppe, entry->hash);
>  +
>  +		hwe->ib1 &= ~MTK_FOE_IB1_STATE;
> - 		hwe->ib1 |= FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_UNBIND);
> ++		hwe->ib1 |= FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_INVALID);
>   		dma_wmb();
>   	}
>   	entry->hash = 0xffff;

