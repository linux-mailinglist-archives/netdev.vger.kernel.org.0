Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C3750B057
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 08:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444277AbiDVGRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 02:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442942AbiDVGRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 02:17:41 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF2750072;
        Thu, 21 Apr 2022 23:14:48 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1650608086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DjdOTui0POHi92i5Qf8axlO2tlre4sLJsGmaIO2yyyo=;
        b=afLqpNepCA2qZ7NooyGZHehv1zWlhdfT5NU5maBIeanvB41X38R4km33gc0ch41vZd6KsK
        ObUUWK+H1aCxj+0hhsc23IA1C+/1vmZjQ0QO36gQ+0DY6QyIZSm5ltORLtydd9cm2Vsdyr
        wCryWK5pCihyGPjiVqfGoeK1CECqXy8=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] arp: fix unused variable warnning when CONFIG_PROC_FS=n
Date:   Fri, 22 Apr 2022 14:14:31 +0800
Message-Id: <20220422061431.1905579-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/ipv4/arp.c:1412:36: warning: unused variable 'arp_seq_ops' [-Wunused-const-variable]

Add #ifdef CONFIG_PROC_FS for 'arp_seq_ops'.

Fixes: e968b1b3e9b8 ("arp: Remove #ifdef CONFIG_PROC_FS")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/ipv4/arp.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 2d0c05ca9c6f..ab4a5601c82a 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1304,9 +1304,9 @@ static struct packet_type arp_packet_type __read_mostly = {
 	.func =	arp_rcv,
 };
 
+#ifdef CONFIG_PROC_FS
 #if IS_ENABLED(CONFIG_AX25)
 
-/* ------------------------------------------------------------------------ */
 /*
  *	ax25 -> ASCII conversion
  */
@@ -1412,16 +1412,13 @@ static void *arp_seq_start(struct seq_file *seq, loff_t *pos)
 	return neigh_seq_start(seq, pos, &arp_tbl, NEIGH_SEQ_SKIP_NOARP);
 }
 
-/* ------------------------------------------------------------------------ */
-
 static const struct seq_operations arp_seq_ops = {
 	.start	= arp_seq_start,
 	.next	= neigh_seq_next,
 	.stop	= neigh_seq_stop,
 	.show	= arp_seq_show,
 };
-
-/* ------------------------------------------------------------------------ */
+#endif /* CONFIG_PROC_FS */
 
 static int __net_init arp_net_init(struct net *net)
 {
-- 
2.25.1

