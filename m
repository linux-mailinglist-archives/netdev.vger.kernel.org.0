Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6DA333286
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 01:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhCJAiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 19:38:55 -0500
Received: from www62.your-server.de ([213.133.104.62]:43790 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhCJAia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 19:38:30 -0500
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lJmrt-0008uc-Ck; Wed, 10 Mar 2021 01:38:29 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        willemb@google.com, edumazet@google.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH net 2/2] net, bpf: Fix ip6ip6 crash with collect_md populated skbs
Date:   Wed, 10 Mar 2021 01:38:10 +0100
Message-Id: <4e8b5320b081e8c7b9444b26a6af446d9a0a737e.1615331093.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1615331093.git.daniel@iogearbox.net>
References: <cover.1615331093.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26103/Tue Mar  9 13:03:37 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I ran into a crash where setting up a ip6ip6 tunnel device which was /not/
set to collect_md mode was receiving collect_md populated skbs for xmit.

The BPF prog was populating the skb via bpf_skb_set_tunnel_key() which is
assigning special metadata dst entry and then redirecting the skb to the
device, taking ip6_tnl_start_xmit() -> ipxip6_tnl_xmit() -> ip6_tnl_xmit()
and in the latter it performs a neigh lookup based on skb_dst(skb) where
we trigger a NULL pointer dereference on dst->ops->neigh_lookup() since
the md_dst_ops do not populate neigh_lookup callback with a fake handler.

Transform the md_dst_ops into generic dst_blackhole_ops that can also be
reused elsewhere when needed, and use them for the metadata dst entries as
callback ops.

Also, remove the dst_md_discard{,_out}() ops and rely on dst_discard{,_out}()
from dst_init() which free the skb the same way modulo the splat. Given we
will be able to recover just fine from there, avoid any potential splats
iff this gets ever triggered in future (or worse, panic on warns when set).

Fixes: f38a9eb1f77b ("dst: Metadata destinations")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 net/core/dst.c | 31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff --git a/net/core/dst.c b/net/core/dst.c
index 5f6315601776..fb3bcba87744 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -275,37 +275,24 @@ unsigned int dst_blackhole_mtu(const struct dst_entry *dst)
 }
 EXPORT_SYMBOL_GPL(dst_blackhole_mtu);
 
-static struct dst_ops md_dst_ops = {
-	.family =		AF_UNSPEC,
+static struct dst_ops dst_blackhole_ops = {
+	.family		= AF_UNSPEC,
+	.neigh_lookup	= dst_blackhole_neigh_lookup,
+	.check		= dst_blackhole_check,
+	.cow_metrics	= dst_blackhole_cow_metrics,
+	.update_pmtu	= dst_blackhole_update_pmtu,
+	.redirect	= dst_blackhole_redirect,
+	.mtu		= dst_blackhole_mtu,
 };
 
-static int dst_md_discard_out(struct net *net, struct sock *sk, struct sk_buff *skb)
-{
-	WARN_ONCE(1, "Attempting to call output on metadata dst\n");
-	kfree_skb(skb);
-	return 0;
-}
-
-static int dst_md_discard(struct sk_buff *skb)
-{
-	WARN_ONCE(1, "Attempting to call input on metadata dst\n");
-	kfree_skb(skb);
-	return 0;
-}
-
 static void __metadata_dst_init(struct metadata_dst *md_dst,
 				enum metadata_type type, u8 optslen)
-
 {
 	struct dst_entry *dst;
 
 	dst = &md_dst->dst;
-	dst_init(dst, &md_dst_ops, NULL, 1, DST_OBSOLETE_NONE,
+	dst_init(dst, &dst_blackhole_ops, NULL, 1, DST_OBSOLETE_NONE,
 		 DST_METADATA | DST_NOCOUNT);
-
-	dst->input = dst_md_discard;
-	dst->output = dst_md_discard_out;
-
 	memset(dst + 1, 0, sizeof(*md_dst) + optslen - sizeof(*dst));
 	md_dst->type = type;
 }
-- 
2.21.0

