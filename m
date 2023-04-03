Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DB66D44E6
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 14:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbjDCMws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 08:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjDCMwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 08:52:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D55DC;
        Mon,  3 Apr 2023 05:52:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFEF8B819ED;
        Mon,  3 Apr 2023 12:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72D4C4339B;
        Mon,  3 Apr 2023 12:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680526363;
        bh=I1U8a0CpEbn1WglTzJbuJSWzo+Oe4sN1VaS9yf+8xSU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L+5pqbG9ruhm88XVe/eA9FPu3JmXE9oL3nixjMsXOvIBRnz9Pi3Dgvv+1rsB7U98S
         26J0PCa/eZqYWTY2hbsEY4n5Kww7Y/PqzDZIQUS8Ch3sJk13FIYZyPuGhEJS7NLSyn
         n4SbzQwZsB8CRH4Tj2wRlm/+QgBRE5/1isFV/vB5sEXAqVm8b5vp/V+cdS4t3wXf0/
         nTHXTwRpCF2VV8BBCQNE6si/vW53sseo5V6ex2wUmjUfH1gB0lwTDmdzT7t7FS43yb
         ymIry9M597CCJGpoRZGpWm0KYhMxVhyDl8aRKAmJ10uaEv5QdqbFoQ2TbpEsjEQrCh
         pQTnIQ5td31iA==
Date:   Mon, 3 Apr 2023 14:52:38 +0200
From:   Simon Horman <horms@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: use be32 type to store be32
 values
Message-ID: <ZCrMFtTxZSjqjdTZ@kernel.org>
References: <20230401-mtk_eth_soc-sparse-v1-1-84e9fc7b8eab@kernel.org>
 <c7684349-535c-45a4-9a74-d47479a50020@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7684349-535c-45a4-9a74-d47479a50020@lunn.ch>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 01, 2023 at 05:55:35PM +0200, Andrew Lunn wrote:
> On Sat, Apr 01, 2023 at 08:43:44AM +0200, Simon Horman wrote:
> > Perhaps there is a nicer way to handle this but the code
> > calls for converting an array of host byte order 32bit values
> > to big endian 32bit values: an ipv6 address to be pretty printed.
> 
> Hi Simon
> 
> Maybe make a generic helper? I could be used in other places, e.g:
> 
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c#L6773

Hi Andrew,

do you mean something like this?

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 7332296eca44..cff6c1177502 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -935,6 +935,11 @@ static inline void iph_to_flow_copy_v6addrs(struct flow_keys *flow,
 	flow->control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 }
 
+static inline void ipv6_addr_cpu_to_be32(__be32 *dst, const u32 *src)
+{
+	cpu_to_be32_array(dst, src, 4);
+}
+
 #if IS_ENABLED(CONFIG_IPV6)
 
 static inline bool ipv6_can_nonlocal_bind(struct net *net,
