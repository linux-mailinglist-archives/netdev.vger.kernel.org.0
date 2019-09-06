Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B65CCABEC1
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 19:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391513AbfIFR35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 13:29:57 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45140 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732789AbfIFR35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 13:29:57 -0400
Received: by mail-ed1-f67.google.com with SMTP id f19so6932082eds.12
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 10:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=O5LwNZ9la5GOUpffauHa1KxgGHQK+Got6jAX+r7lY9Q=;
        b=g0l6UMyRYG1667F1JD+G+6Uozl2Azx2tHWR3+o7qIAJGkk3G4pertntvT7bGwvzhMb
         GBOlC3W/JbdjU7gQKfOeBdcimkWmfxWbU6Avy2tUl+P+tYgtMj+G906fh4WXMKvfqMmA
         TJlmN63VCks4a4JwHis/8JjBK/0Fml+KG3awqGU8uwcYGyOmFxCem7s2afT0E6rxZzFR
         RNbo0Uv5tLCvZEX/n7gpz2TmIrOuiZUD4c0gtRO+b3ToGsmi+u8ADKrLnnknvsUp6jcg
         lxjVA12ybkphH6+ly1UgjauG+hsSdeAViQCpOlrJGjgabvP8Wc0tOmQWzimDq5Z/Iqbn
         BVWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=O5LwNZ9la5GOUpffauHa1KxgGHQK+Got6jAX+r7lY9Q=;
        b=oG8QO8prSK8vPaaeDUIXSdPLUbM6kFPW/ZeI5WOKKPNUCWfom48y18J52QMsjsiIZT
         CgwbdDuM4ZL5gbvJKx3LOagKo8DpLoZ2SsQe5hm5mDLy2NCBukAPVPvQbWq0AKjpuAhJ
         FnAVOcq2Om9+xY8DQaSSer22Ym4x1wMigKBcqwC7Hb6bs+o+DXcshbpGQZEYWBHxpu16
         m2vkU0t5E+TMtOjE8aI653JOvVk6JQvxdzlZGgnTx76rYt6RVSsxvwTcc+y4QDIjIOB4
         sRh0BNL7+WAp/HQjYTM/VKhOjDSLyBDq5lU7OMzWJCUCOPwRbRiR+xNPbQXGAI9K4lHj
         9OOA==
X-Gm-Message-State: APjAAAUsuploWA2dqJ7qGv9FqE3hTAfyCrVmmmFXC3s4MdIXBKhdfj+x
        uPdwxeCCvv77G6YUvI+hLjhsA0TA7SE=
X-Google-Smtp-Source: APXvYqwsNJkxi2nxqTRzy7KakP+rVvjWwh5qRk2qS9GaLNiqcvGh9bJ9V02chLUB8KjJe/XC9+K2mg==
X-Received: by 2002:a50:e005:: with SMTP id e5mr10798581edl.279.1567790995006;
        Fri, 06 Sep 2019 10:29:55 -0700 (PDT)
Received: from reginn.horms.nl ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id c1sm1041945edd.21.2019.09.06.10.29.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 10:29:53 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Fred Lotter <frederik.lotter@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net] nfp: flower: cmsg rtnl locks can timeout reify messages
Date:   Fri,  6 Sep 2019 19:29:41 +0200
Message-Id: <20190906172941.25136-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fred Lotter <frederik.lotter@netronome.com>

Flower control message replies are handled in different locations. The truly
high priority replies are handled in the BH (tasklet) context, while the
remaining replies are handled in a predefined Linux work queue. The work
queue handler orders replies into high and low priority groups, and always
start servicing the high priority replies within the received batch first.

Reply Type:			Rtnl Lock:	Handler:

CMSG_TYPE_PORT_MOD		no		BH tasklet (mtu)
CMSG_TYPE_TUN_NEIGH		no		BH tasklet
CMSG_TYPE_FLOW_STATS		no		BH tasklet
CMSG_TYPE_PORT_REIFY		no		WQ high
CMSG_TYPE_PORT_MOD		yes		WQ high (link/mtu)
CMSG_TYPE_MERGE_HINT		yes		WQ low
CMSG_TYPE_NO_NEIGH		no		WQ low
CMSG_TYPE_ACTIVE_TUNS		no		WQ low
CMSG_TYPE_QOS_STATS		no		WQ low
CMSG_TYPE_LAG_CONFIG		no		WQ low

A subset of control messages can block waiting for an rtnl lock (from both
work queue priority groups). The rtnl lock is heavily contended for by
external processes such as systemd-udevd, systemd-network and libvirtd,
especially during netdev creation, such as when flower VFs and representors
are instantiated.

Kernel netlink instrumentation shows that external processes (such as
systemd-udevd) often use successive rtnl_trylock() sequences, which can result
in an rtnl_lock() blocked control message to starve for longer periods of time
during rtnl lock contention, i.e. netdev creation.

In the current design a single blocked control message will block the entire
work queue (both priorities), and introduce a latency which is
nondeterministic and dependent on system wide rtnl lock usage.

In some extreme cases, one blocked control message at exactly the wrong time,
just before the maximum number of VFs are instantiated, can block the work
queue for long enough to prevent VF representor REIFY replies from getting
handled in time for the 40ms timeout.

The firmware will deliver the total maximum number of REIFY message replies in
around 300us.

Only REIFY and MTU update messages require replies within a timeout period (of
40ms). The MTU-only updates are already done directly in the BH (tasklet)
handler.

Move the REIFY handler down into the BH (tasklet) in order to resolve timeouts
caused by a blocked work queue waiting on rtnl locks.

Signed-off-by: Fred Lotter <frederik.lotter@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/cmsg.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

 Hi Dave,

 I am handling maintenance of the nfp diver in Jakub's absence while he is
 on vacation this week and next, and I am sending this patchset in that
 capacity.

diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.c b/drivers/net/ethernet/netronome/nfp/flower/cmsg.c
index d5bbe3d6048b..05981b54eaab 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.c
@@ -260,9 +260,6 @@ nfp_flower_cmsg_process_one_rx(struct nfp_app *app, struct sk_buff *skb)
 
 	type = cmsg_hdr->type;
 	switch (type) {
-	case NFP_FLOWER_CMSG_TYPE_PORT_REIFY:
-		nfp_flower_cmsg_portreify_rx(app, skb);
-		break;
 	case NFP_FLOWER_CMSG_TYPE_PORT_MOD:
 		nfp_flower_cmsg_portmod_rx(app, skb);
 		break;
@@ -328,8 +325,7 @@ nfp_flower_queue_ctl_msg(struct nfp_app *app, struct sk_buff *skb, int type)
 	struct nfp_flower_priv *priv = app->priv;
 	struct sk_buff_head *skb_head;
 
-	if (type == NFP_FLOWER_CMSG_TYPE_PORT_REIFY ||
-	    type == NFP_FLOWER_CMSG_TYPE_PORT_MOD)
+	if (type == NFP_FLOWER_CMSG_TYPE_PORT_MOD)
 		skb_head = &priv->cmsg_skbs_high;
 	else
 		skb_head = &priv->cmsg_skbs_low;
@@ -368,6 +364,10 @@ void nfp_flower_cmsg_rx(struct nfp_app *app, struct sk_buff *skb)
 	} else if (cmsg_hdr->type == NFP_FLOWER_CMSG_TYPE_TUN_NEIGH) {
 		/* Acks from the NFP that the route is added - ignore. */
 		dev_consume_skb_any(skb);
+	} else if (cmsg_hdr->type == NFP_FLOWER_CMSG_TYPE_PORT_REIFY) {
+		/* Handle REIFY acks outside wq to prevent RTNL conflict. */
+		nfp_flower_cmsg_portreify_rx(app, skb);
+		dev_consume_skb_any(skb);
 	} else {
 		nfp_flower_queue_ctl_msg(app, skb, cmsg_hdr->type);
 	}
-- 
2.11.0

