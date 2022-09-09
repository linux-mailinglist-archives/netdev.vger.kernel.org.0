Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A209B5B3F2E
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 21:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiIITAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 15:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiIITAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 15:00:51 -0400
X-Greylist: delayed 367 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 09 Sep 2022 12:00:46 PDT
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CC36CD17;
        Fri,  9 Sep 2022 12:00:46 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1oWj97-0000Gi-3A;
        Fri, 09 Sep 2022 20:54:34 +0200
Date:   Fri, 9 Sep 2022 19:54:27 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org
Subject: Re: [PATCH net-next 08/12] net: ethernet: mtk_eth_soc: add foe info
 in mtk_soc_data structure
Message-ID: <YxuL45OghfKVGTrM@makrotopia.org>
References: <cover.1662661555.git.lorenzo@kernel.org>
 <0d0bfa99e313c0b00bf75f943f58b6fe552ed004.1662661555.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d0bfa99e313c0b00bf75f943f58b6fe552ed004.1662661555.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 08, 2022 at 09:33:42PM +0200, Lorenzo Bianconi wrote:
> Introduce foe struct in mtk_soc_data as a container for foe table chip
> related definitions.
> This is a preliminary patch to enable mt7986 wed support.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  70 +++++++-
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h   |  27 ++-
>  drivers/net/ethernet/mediatek/mtk_ppe.c       | 161 ++++++++++--------
>  drivers/net/ethernet/mediatek/mtk_ppe.h       |  29 ++--
>  .../net/ethernet/mediatek/mtk_ppe_offload.c   |  34 ++--
>  5 files changed, 208 insertions(+), 113 deletions(-)
> 
> [...]
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
> index 6d4c91acd1a5..a364f45edf38 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe.h
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
> @@ -61,6 +61,8 @@ enum {
>  #define MTK_FOE_VLAN2_WINFO_WCID	GENMASK(13, 6)
>  #define MTK_FOE_VLAN2_WINFO_RING	GENMASK(15, 14)
>  
> +#define MTK_FIELD_PREP(mask, val)	(((typeof(mask))(val) << __bf_shf(mask)) & (mask))
> +#define MTK_FIELD_GET(mask, val)	((typeof(mask))(((val) & (mask)) >> __bf_shf(mask)))

This seems to trigger a compiler bug on ARMv7 (e.g. MT7623) builds:

  LD      .tmp_vmlinux.kallsyms1
arm-openwrt-linux-muslgnueabi-ld: drivers/net/ethernet/mediatek/mtk_ppe.o: in function `mtk_flow_entry_match':
/usr/src/lede/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-mediatek_mt7623/linux-5.15.67/drivers/net/ethernet/mediatek/mtk_ppe.c:406: undefined reference to `__ffsdi2'
arm-openwrt-linux-muslgnueabi-ld: drivers/net/ethernet/mediatek/mtk_ppe.o: in function `__mtk_foe_entry_commit':
/usr/src/lede/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-mediatek_mt7623/linux-5.15.67/drivers/net/ethernet/mediatek/mtk_ppe.c:533: undefined reference to `__ffsdi2'
arm-openwrt-linux-muslgnueabi-ld: drivers/net/ethernet/mediatek/mtk_ppe.o: in function `mtk_foe_entry_l2':
/usr/src/lede/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-mediatek_mt7623/linux-5.15.67/drivers/net/ethernet/mediatek/mtk_ppe.c:134: undefined reference to `__ffsdi2'
arm-openwrt-linux-muslgnueabi-ld: drivers/net/ethernet/mediatek/mtk_ppe.o: in function `mtk_foe_entry_commit_subflow':
/usr/src/lede/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-mediatek_mt7623/linux-5.15.67/drivers/net/ethernet/mediatek/mtk_ppe.c:611: undefined reference to `__ffsdi2'
arm-openwrt-linux-muslgnueabi-ld: drivers/net/ethernet/mediatek/mtk_ppe.o: in function `mtk_foe_entry_ib2':
/usr/src/lede/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-mediatek_mt7623/linux-5.15.67/drivers/net/ethernet/mediatek/mtk_ppe.c:148: undefined reference to `__ffsdi2'
arm-openwrt-linux-muslgnueabi-ld: drivers/net/ethernet/mediatek/mtk_ppe.o:/usr/src/lede/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-mediatek_mt7623/linux-5.15.67/drivers/net/ethernet/mediatek/mtk_ppe.c:169: more undefined references to `__ffsdi2' follow


>  enum {
>  	MTK_FOE_STATE_INVALID,
>  	MTK_FOE_STATE_UNBIND,
