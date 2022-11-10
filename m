Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E612C624CD5
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 22:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbiKJVWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 16:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiKJVWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 16:22:18 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F01931DFD
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 13:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cfqbLsjTXIklgUmkkjoKLX8BggWtVbPLmwMoI1aXoyk=; b=dZhXm+IpFFEJsfqN3xQJYJPbqD
        NY4f7k4zhNV2Dnq3yc+YxC14yeK7ijVX4FUijlgKLXf15B6kC9l9R7/8e+NPbPjrjs9Hve15xc0Io
        3zHnou/5lPpVCcC5zOasJdNMIYVuctKwSsb/icjbrmR7VzvmdQDKruWRvQTQMiUuGkCQ=;
Received: from p200300daa72ee10c199752172ce6dd7a.dip0.t-ipconnect.de ([2003:da:a72e:e10c:1997:5217:2ce6:dd7a] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1otF03-0011Om-6K; Thu, 10 Nov 2022 22:22:15 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next v3 0/4] mtk_eth_soc rx vlan offload improvement + dsa hardware untag support
Date:   Thu, 10 Nov 2022 22:22:07 +0100
Message-Id: <20221110212212.96825-1-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series improves rx vlan offloading on mtk_eth_soc and extends it to
support hardware DSA untagging where possible.
This improves performance by avoiding calls into the DSA tag driver receive
function, including mangling of skb->data.

This is split out of a previous series, which added other fixes and
multiqueue support

Changes in v3:
 - fix netdev features sync
 - fix dsa_default_offload_fwd_mark call in dsa patch

Felix Fietkau (4):
  net: dsa: add support for DSA rx offloading via metadata dst
  net: ethernet: mtk_eth_soc: pass correct VLAN protocol ID to the
    network stack
  net: ethernet: mtk_eth_soc: add support for configuring vlan rx
    offload
  net: ethernet: mtk_eth_soc: enable hardware DSA untagging

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 93 ++++++++++++++++++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  8 ++
 net/core/flow_dissector.c                   |  4 +-
 net/dsa/dsa.c                               | 19 ++++-
 4 files changed, 109 insertions(+), 15 deletions(-)

-- 
2.38.1

