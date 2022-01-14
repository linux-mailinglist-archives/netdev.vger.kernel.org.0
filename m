Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406F148E3CF
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 06:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbiANFih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 00:38:37 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:53938 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S234763AbiANFig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 00:38:36 -0500
X-UUID: 3abcf59a8c2d45249804e5ded4671120-20220114
X-UUID: 3abcf59a8c2d45249804e5ded4671120-20220114
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1136806152; Fri, 14 Jan 2022 13:38:27 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 14 Jan 2022 13:38:25 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Jan 2022 13:38:24 +0800
Message-ID: <14636842a61bb7631584315901bcc06ccbdb0f90.camel@mediatek.com>
Subject: Re: [PATCH net-next v10 6/6] net: dt-bindings: dwmac: add support
 for mt8195
From:   Biao Huang <biao.huang@mediatek.com>
To:     Rob Herring <robh@kernel.org>
CC:     srv_heupstream <srv_heupstream@mediatek.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        David Miller <davem@davemloft.net>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        netdev <netdev@vger.kernel.org>, <dkirjanov@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <devicetree@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>
Date:   Fri, 14 Jan 2022 13:38:24 +0800
In-Reply-To: <CAL_JsqLo7z-KWtwFx+Kng2aQuCpQwJaO6mHnyBzmCKCJDK5n+Q@mail.gmail.com>
References: <20211216055328.15953-1-biao.huang@mediatek.com>
         <20211216055328.15953-7-biao.huang@mediatek.com>
         <1639662782.987227.4004875.nullmailer@robh.at.kernel.org>
         <be023f9d2fb2a8f947bd0075e8732ba07cfd7b89.camel@mediatek.com>
         <CAL_JsqLo7z-KWtwFx+Kng2aQuCpQwJaO6mHnyBzmCKCJDK5n+Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-01-11 at 17:36 -0600, Rob Herring wrote:
> On Thu, Dec 16, 2021 at 8:06 PM Biao Huang <biao.huang@mediatek.com>
> wrote:
> > 
> > Dear Rob,
> >   Thanks for your comments~
> > 
> >   For mt8195, the eth device node will look like:
> >   eth: ethernet@11021000 {
> >     compatible = "mediatek,mt8195-gmac", "snps,dwmac-5.10a";
> >     ...
> >     clock-names = "axi",
> >                   "apb",
> >                   "mac_cg",
> >                   "mac_main",
> >                   "ptp_ref",
> >                   "rmii_internal";
> >     clocks = <&pericfg_ao CLK_PERI_AO_ETHERNET>,
> >              <&pericfg_ao CLK_PERI_AO_ETHERNET_BUS>,
> >              <&pericfg_ao CLK_PERI_AO_ETHERNET_MAC>,
> >              <&topckgen CLK_TOP_SNPS_ETH_250M>,
> >              <&topckgen CLK_TOP_SNPS_ETH_62P4M_PTP>,
> >              <&topckgen CLK_TOP_SNPS_ETH_50M_RMII>;
> >     ...
> >   }
> > 
> > 1. "rmii_internal" is a special clock only required for
> >    RMII phy interface, dwmac-mediatek.c will enable clocks
> >    invoking clk_bulk_prepare_enable(xx, 6) for RMII,
> >    and clk_bulk_prepare_enable(xx, 5) for other phy interfaces.
> >    so, mt2712/mt8195 all put "rmii_internal" clock to the
> >    end of clock list to simplify clock handling.
> > 
> >    If I put mac_cg as described above, a if condition is required
> > for clocks description in dt-binding, just like what I do in v7
> > send:
> >   - if:
> >       properties:
> >         compatible:
> >           contains:
> >             enum:
> >               - mediatek,mt2712-gmac
> > 
> >     then:
> >       properties:
> >         clocks:
> >           minItems: 5
> >           items:
> >             - description: AXI clock
> >             - description: APB clock
> >             - description: MAC Main clock
> >             - description: PTP clock
> >             - description: RMII reference clock provided by MAC
> > 
> >         clock-names:
> >           minItems: 5
> >           items:
> >             - const: axi
> >             - const: apb
> >             - const: mac_main
> >             - const: ptp_ref
> >             - const: rmii_internal
> > 
> >   - if:
> >       properties:
> >         compatible:
> >           contains:
> >             enum:
> >               - mediatek,mt8195-gmac
> > 
> >     then:
> >       properties:
> >         clocks:
> >           minItems: 6
> >           items:
> >             - description: AXI clock
> >             - description: APB clock
> >             - description: MAC clock gate
> >             - description: MAC Main clock
> >             - description: PTP clock
> >             - description: RMII reference clock provided by MAC
> > 
> >    This introduces some duplicated description.
> > 
> > 2. If I put "mac_cg" to the end of clock list,
> >    the dt-binding file can be simple just like
> >    what we do in this v10 patch(need fix warnings reported by "make
> > DT_CHECKER_FLAGS=-m dt_binding_check").
> > 
> >    But for mt8195:
> >      the eth node in dts should be modified,
> 
> I hope you are defining the binding before you use it... That's not
> good practice and not a valid argument.
> 
> >      and eth driver clock handling will be complex;
> 
> How so?
> 
> Rob
OK, I'll add a driver patch to make clock setting more reasonable,
and modify this patch as previous comments.

Thanks for your comments~

