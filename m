Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D6D52BF6E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 18:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239828AbiERQIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 12:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239786AbiERQIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 12:08:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5713F19FF7E;
        Wed, 18 May 2022 09:08:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14A78B8217B;
        Wed, 18 May 2022 16:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F284C385A5;
        Wed, 18 May 2022 16:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652890112;
        bh=W7E9g3JMLtIZ3H/YFH9zLcuoF3SoQXamU8auRb68lfQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Py+Y7NnHtpyPAjWcqKmdCOBQXC+1lKKcHiecFav2N+Vn0Pqxx6smfPcEisOCboQ/t
         D4QCvYh9RyhFaQqW5X2wxjHSP/TMZP/Uy0dziQAtLhDIuT2SFXo4SyQNixa63eqXB3
         e41Lic6nLZj18Oh37YdAmsVs+8KyTIj8ulrQnZXr7Xkxo/4rGudIy0nXiJeolqdyfh
         1iAsacaOEXjI8IfIQTu0Ok9blVU4B06BQEr08/vdM1V1HlltTlMHPrpkdEzinr3cv2
         m/1wTQ3LTmf4eV3EkMtKsNaH1uK7CeA+ZVRfprc1Nyvu1rM4Nu8vkEf3G3hrUHqw7C
         aS5eZiuypTG5g==
Date:   Wed, 18 May 2022 09:08:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Sam.Shih@mediatek.com, linux-mediatek@lists.infradead.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next 12/15] net: ethernet: mtk_eth_soc: introduce
 MTK_NETSYS_V2 support
Message-ID: <20220518090830.59ab629f@kernel.org>
In-Reply-To: <4b3283c7-772f-9969-b3c6-d28b4c032326@nbd.name>
References: <cover.1652716741.git.lorenzo@kernel.org>
        <cc1bd411e3028e2d6b0365ed5d29f3cea66223f8.1652716741.git.lorenzo@kernel.org>
        <20220517184433.3cb2fd5a@kernel.org>
        <YoTCCAKpE5ijiom0@lore-desk>
        <20220518084740.7947b51b@kernel.org>
        <4b3283c7-772f-9969-b3c6-d28b4c032326@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 May 2022 17:50:12 +0200 Felix Fietkau wrote:
> On 18.05.22 17:47, Jakub Kicinski wrote:
> >> I used this approach just to be aligned with current codebase:
> >> https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/mediatek/mtk_eth_soc.c#L1006
> >> https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/mediatek/mtk_eth_soc.c#L1031
> >> 
> >> but I guess we can even convert the code to use barrier instead. Agree?  
> > 
> > Oh, I didn't realize. No preference on converting the old code
> > but it looks like a cargo cult to me so in the new code let's
> > not WRITE_ONCE() all descriptor writes unless there's a reason.  
> If I remember correctly, the existing places use WRITE_ONCE to prevent 
> write tearing to uncached memory.

Okay, makes sense then. 
