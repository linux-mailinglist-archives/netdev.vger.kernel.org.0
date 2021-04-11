Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5595535B38A
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 13:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbhDKL2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 07:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbhDKL2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 07:28:46 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA463C06138B
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 04:28:28 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id w4so6245886wrt.5
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 04:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J9dAOL1/x9OGCX8jNZyofTJTCoeUqrYdNX5IfEdOr5Y=;
        b=CQ4aIESEHZLbrgLq3W2zlZMjm8FtTnlX1/lQxNBN2ovPDduyLwufYGK4tfR/U7Pb1R
         GfR7p549duUStI4y5oqwDm51z1EFa3Jfi+EGKfRtVSWxKSXssjyLU+QwfbdslT7PttC9
         wZ0NoN8Pd5NDfvQdVTZ/msGzep/A5SMx3JwMkB2g5Tmnbnb63OzYOZghILRA0TiXz9bm
         C8X0oh5sGP4KG+RN0GfzwqXrlbmhCEeh3rHLQ4vRY/dd8Jkpf9t3tagYF2Hioeu2/vjj
         VEZn7h63jGbw/7wElwSvxJu3SEg3MG57GKF5O2EcO5sf0izDe/Chl1daatWfjsT67Aod
         v+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J9dAOL1/x9OGCX8jNZyofTJTCoeUqrYdNX5IfEdOr5Y=;
        b=Ma8Ztz9M9fsc3RPUt7kWLkjHU2jCh+SzQzqavvbA3sLPbxxcN22c6FnR+iI/tB3u4q
         THNIpRgb6truKqZ+dW0phqk95xnjhKHUmJgxf504RcJ2V9GErQb/lcgfaG6zCxzOFkgO
         sZPT5z8VNhpIjQCpqFlv8gtdxktPEsDB7XvTD09wSG3kSeXp6XJ3HaA4GcWZozq8Ozhe
         MAOufj7VYTApCgk2s6xssWoaCSyaeo3ARpy1oKMxGfSI0EV+YeYINngfv+m11xgdq4jE
         96zMqPr0Ls7UkriBM5Qp0b8X38G6NY/aPSWiMfhZKJPYYPJSqS9nF8zRfu7qypHbRzgA
         fQjQ==
X-Gm-Message-State: AOAM533lnjQAUeJNVQesL0ZDr5be966KTERj8uYIOb3fZaNfxyIeF9tM
        J3Zw0wLoYZU40B2QshoFzTlvKw==
X-Google-Smtp-Source: ABdhPJyijjrOlqRPTN5U9E2fOoqETSfRD6bEhlO7HreNF0LJ0tac6hFn4glfny66/s1Eg1hJALpjMg==
X-Received: by 2002:a5d:4802:: with SMTP id l2mr26241365wrq.418.1618140507363;
        Sun, 11 Apr 2021 04:28:27 -0700 (PDT)
Received: from localhost.localdomain (2.0.5.1.1.6.3.8.5.c.c.3.f.b.d.3.0.0.0.0.6.1.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:df16:0:3dbf:3cc5:8361:1502])
        by smtp.gmail.com with ESMTPSA id c12sm13209097wro.6.2021.04.11.04.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 04:28:26 -0700 (PDT)
From:   Phillip Potter <phil@philpotter.co.uk>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, edumazet@google.com
Subject: [PATCH] net: geneve: check skb is large enough for IPv4/IPv6 header
Date:   Sun, 11 Apr 2021 12:28:24 +0100
Message-Id: <20210411112824.1149-1-phil@philpotter.co.uk>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check within geneve_xmit_skb/geneve6_xmit_skb that sk_buff structure
is large enough to include IPv4 or IPv6 header, and reject if not. The
geneve_xmit_skb portion and overall idea was contributed by Eric Dumazet.
Fixes a KMSAN-found uninit-value bug reported by syzbot at:
https://syzkaller.appspot.com/bug?id=abe95dc3e3e9667fc23b8d81f29ecad95c6f106f

Suggested-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+2e406a9ac75bb71d4b7a@syzkaller.appspotmail.com
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
---
 drivers/net/geneve.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 5523f069b9a5..adfceb60f7f8 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -891,6 +891,9 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
+	if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
+		return -EINVAL;
+
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
 			      geneve->cfg.info.key.tp_dst, sport);
@@ -977,6 +980,9 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
+	if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
+		return -EINVAL;
+
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	dst = geneve_get_v6_dst(skb, dev, gs6, &fl6, info,
 				geneve->cfg.info.key.tp_dst, sport);
-- 
2.30.2

