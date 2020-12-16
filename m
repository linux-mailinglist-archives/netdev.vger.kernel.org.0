Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8522C2DBBF2
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 08:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgLPH33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 02:29:29 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:39354 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPH32 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 02:29:28 -0500
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 0D39C44025F;
        Wed, 16 Dec 2020 09:28:39 +0200 (IST)
From:   Baruch Siach <baruch@tkos.co.il>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH net] net: af_packet: fix procfs header for 64-bit pointers
Date:   Wed, 16 Dec 2020 09:28:04 +0200
Message-Id: <54917251d8433735d9a24e935a6cb8eb88b4058a.1608103684.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 64-bit systems the packet procfs header field names following 'sk'
are not aligned correctly:

sk       RefCnt Type Proto  Iface R Rmem   User   Inode
00000000605d2c64 3      3    0003   7     1 450880 0      16643
00000000080e9b80 2      2    0000   0     0 0      0      17404
00000000b23b8a00 2      2    0000   0     0 0      0      17421
...

With this change field names are correctly aligned:

sk               RefCnt Type Proto  Iface R Rmem   User   Inode
000000005c3b1d97 3      3    0003   7     1 21568  0      16178
000000007be55bb7 3      3    fbce   8     1 0      0      16250
00000000be62127d 3      3    fbcd   8     1 0      0      16254
...

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 net/packet/af_packet.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 7a18ffff8551..99de3bbe437f 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4581,7 +4581,9 @@ static void packet_seq_stop(struct seq_file *seq, void *v)
 static int packet_seq_show(struct seq_file *seq, void *v)
 {
 	if (v == SEQ_START_TOKEN)
-		seq_puts(seq, "sk       RefCnt Type Proto  Iface R Rmem   User   Inode\n");
+		seq_printf(seq,
+			   "%*sRefCnt Type Proto  Iface R Rmem   User   Inode\n",
+			   IS_ENABLED(CONFIG_64BIT) ? -17 : -9, "sk");
 	else {
 		struct sock *s = sk_entry(v);
 		const struct packet_sock *po = pkt_sk(s);
-- 
2.29.2

