Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E595B62EE
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 23:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiILVo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 17:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiILVoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 17:44:54 -0400
Received: from mail-ua1-x949.google.com (mail-ua1-x949.google.com [IPv6:2607:f8b0:4864:20::949])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3528C10FCD
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 14:44:53 -0700 (PDT)
Received: by mail-ua1-x949.google.com with SMTP id z44-20020a9f372f000000b00390af225beaso3087012uad.12
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 14:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=ZdDMxu/ZwxZ1kfijbUS9jX+Fr0880+xk0f4yDMu0NZI=;
        b=TzmR12Pg0ciwHsSRilryLck3zq7AvCYzYIn5LknBVwADhQJbYBuVJhFfiRJzhoJGNl
         qx+w7EWJwj4oOMa5VXVaHsMB6Bpz2AMxgzkvBwjQhY1yqpB7EbixMDE+n6ZtBm2G9SmZ
         Mr4tW2dmGQE9SwT6bML7O7dwMaZp5Pc8e6SFkOMNyCA+JpuW+nktWMLc4CXT2hX8H3fL
         uFSIWAGmRrgsJUUYvPq0MsC2zASQ713KJJzIJcx+vVE/1yzaAEpW6/J1YUY5D8lnhE5h
         PE3/YgqQ9FxdoPMmnP97lybNvrzJXq4Odz6bFs6ajafdslKdNnJ5hpZ/iedjIuj4ykM7
         OBsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=ZdDMxu/ZwxZ1kfijbUS9jX+Fr0880+xk0f4yDMu0NZI=;
        b=Q4tpB2J7sPlXJyzoaIkUokm6x8wgr9DCwiZD6e28hvS+ki9hoNMhL7/Xfunh5ljD44
         WDnOS8XWHC/IRhdUuXMMIUFmxizdcfAfzNG7XKai9otMsKmrXexYXeo0cqyG6Yp1nSid
         78F01VY3srBRX/lZhIRbUI/sN2/so8GGxNbddLWc46Cyl2b61BkH4yiC8IBIsXh6KPuD
         MgLRc85rzRYne61eeyRRUwFoYrkZs6seGfIf7pE3jHNBrsu9ebAv1CAICve1GIAn65vM
         6kDI+N9QW30cuIiuD+lGWEhEC2LEyv8hQS5bNPfKg7VGGbBgjG1Zq9y6CYf6tP/KSBaD
         DFLw==
X-Gm-Message-State: ACgBeo1fJkX8/nPEC0+bwZyhhsGohmRIWw8RGgXQJ8If8AGIR8a3R9jm
        Dgakne/gD3cdhC8ybivImX5yLCrO+A==
X-Google-Smtp-Source: AA6agR6zF9XNyhGeFJB3NgH+4XzRWF08FblJtq30Iirz1/CziA6jHADZJImizAICLxZzt9PWN/yccy8XUg==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a1f:6082:0:b0:3a2:1b57:795f with SMTP id
 u124-20020a1f6082000000b003a21b57795fmr3256154vkb.8.1663019092342; Mon, 12
 Sep 2022 14:44:52 -0700 (PDT)
Date:   Mon, 12 Sep 2022 14:44:29 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220912214432.928989-1-nhuck@google.com>
Subject: [PATCH] net: sparx5: Fix return type of sparx5_port_xmit_impl
From:   Nathan Huckleberry <nhuck@google.com>
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Casper Andersson <casper.casan@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ndo_start_xmit field in net_device_ops is expected to be of type
netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of sparx5_port_xmit_impl should be changed from int to
netdev_tx_t.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index 21844beba72d..83c16ca5b30f 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -222,13 +222,13 @@ static int sparx5_inject(struct sparx5 *sparx5,
 	return NETDEV_TX_OK;
 }
 
-int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
+netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
 {
 	struct net_device_stats *stats = &dev->stats;
 	struct sparx5_port *port = netdev_priv(dev);
 	struct sparx5 *sparx5 = port->sparx5;
 	u32 ifh[IFH_LEN];
-	int ret;
+	netdev_tx_t ret;
 
 	memset(ifh, 0, IFH_LEN * 4);
 	sparx5_set_port_ifh(ifh, port->portno);
-- 
2.37.2.789.g6183377224-goog

