Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A8151B596
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 04:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbiEECEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 22:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbiEECEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 22:04:06 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [202.36.163.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B2D140F1
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 19:00:27 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id BBCCA2C03CF;
        Thu,  5 May 2022 02:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1651716023;
        bh=MXQGLE3PMSE+ZlDALFAVLjIjqtR06nI/TcFrL6QpaP0=;
        h=From:To:Cc:Subject:Date:From;
        b=h/60BWpJbbPgH89KKXaocO/QFQKeXk9t5ZPn3Bk6ioe8ooHKylfQhzHW/k+xJsWjp
         jIOZUkBUyVnzrnGr+HwmfKDQM6RZ6tO433JoENDYkFkEEiCsM/s0Ug5VM0L+HVDkL6
         BsvhKZhWXvndJpOQkDJoMDXCg5wSsGeE0tnPPedLiLdAhoa5a09kDVBkPtYWuf2jKd
         EN173NDcTsCRqCGlQZDD6iu0hE4dFJ6j0j+nXs2gkAY5eGQhAvj8tNGXFyaCe+uyvF
         9w/KV0VDLalBXEzl53MwLXfMCh6l80rUjaWIMDn5El3T85BkOpOz7pjp463Rwu5Zn9
         iwR6xjJhLg/HA==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B62732fb70000>; Thu, 05 May 2022 14:00:23 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by pat.atlnz.lc (Postfix) with ESMTP id 8C54E13EE37;
        Thu,  5 May 2022 14:00:23 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 87AED2A0475; Thu,  5 May 2022 14:00:23 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        tgraf@suug.ch, lokesh.dhoundiyal@alliedtelesis.co.nz
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [net PATCH] ipv4: drop dst in multicast routing path
Date:   Thu,  5 May 2022 14:00:17 +1200
Message-Id: <20220505020017.3111846-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=C7GXNjH+ c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=oZkIemNP1mAA:10 a=trTq1hty2DfEG8aEAKMA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lokesh Dhoundiyal <lokesh.dhoundiyal@alliedtelesis.co.nz>

kmemleak reports the following when routing multicast traffic over an
ipsec tunnel.

Kmemleak output:
unreferenced object 0x8000000044bebb00 (size 256):
  comm "softirq", pid 0, jiffies 4294985356 (age 126.810s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 80 00 00 00 05 13 74 80  ..............t.
    80 00 00 00 04 9b bf f9 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000f83947e0>] __kmalloc+0x1e8/0x300
    [<00000000b7ed8dca>] metadata_dst_alloc+0x24/0x58
    [<0000000081d32c20>] __ipgre_rcv+0x100/0x2b8
    [<00000000824f6cf1>] gre_rcv+0x178/0x540
    [<00000000ccd4e162>] gre_rcv+0x7c/0xd8
    [<00000000c024b148>] ip_protocol_deliver_rcu+0x124/0x350
    [<000000006a483377>] ip_local_deliver_finish+0x54/0x68
    [<00000000d9271b3a>] ip_local_deliver+0x128/0x168
    [<00000000bd4968ae>] xfrm_trans_reinject+0xb8/0xf8
    [<0000000071672a19>] tasklet_action_common.isra.16+0xc4/0x1b0
    [<0000000062e9c336>] __do_softirq+0x1fc/0x3e0
    [<00000000013d7914>] irq_exit+0xc4/0xe0
    [<00000000a4d73e90>] plat_irq_dispatch+0x7c/0x108
    [<000000000751eb8e>] handle_int+0x16c/0x178
    [<000000001668023b>] _raw_spin_unlock_irqrestore+0x1c/0x28

The metadata dst is leaked when ip_route_input_mc() updates the dst for
the skb. Commit f38a9eb1f77b ("dst: Metadata destinations") correctly
handled dropping the dst in ip_route_input_slow() but missed the
multicast case which is handled by ip_route_input_mc(). Drop the dst in
ip_route_input_mc() avoiding the leak.

Fixes: f38a9eb1f77b ("dst: Metadata destinations")
Signed-off-by: Lokesh Dhoundiyal <lokesh.dhoundiyal@alliedtelesis.co.nz>
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---

Notes:
    We started seeing this leak in our scenario after commit c0d59da79534
    ("ip_gre: Make none-tun-dst gre tunnel store tunnel info as metadat_d=
st
    in recv") but there may be other paths that hit the leak so I've set =
the
    fixes tag as f38a9eb1f77b ("dst: Metadata destinations").

 net/ipv4/route.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 98c6f3429593..57abd27e842c 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1753,6 +1753,7 @@ static int ip_route_input_mc(struct sk_buff *skb, _=
_be32 daddr, __be32 saddr,
 #endif
 	RT_CACHE_STAT_INC(in_slow_mc);
=20
+	skb_dst_drop(skb);
 	skb_dst_set(skb, &rth->dst);
 	return 0;
 }
--=20
2.36.0

