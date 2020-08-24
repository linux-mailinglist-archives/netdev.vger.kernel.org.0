Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6DC24FCEE
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 13:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgHXLqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 07:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgHXLqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 07:46:33 -0400
Received: from sym2.noone.org (sym2.noone.org [IPv6:2a01:4f8:120:4161::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CF7C061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 04:46:27 -0700 (PDT)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4BZr1V3gjfzvjc1; Mon, 24 Aug 2020 13:46:22 +0200 (CEST)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: [PATCH net] ipv6: ndisc: adjust ndisc_ifinfo_sysctl_change prototype
Date:   Mon, 24 Aug 2020 13:46:22 +0200
Message-Id: <20200824114622.26400-1-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
changed ndisc_ifinfo_sysctl_change to take a kernel pointer. Adjust its
prototype in net/ndisc.h as well to fix the following sparse warning:

net/ipv6/ndisc.c:1838:5: error: symbol 'ndisc_ifinfo_sysctl_change' redeclared with different type (incompatible argument 3 (different address spaces)):
net/ipv6/ndisc.c:1838:5:    int extern [addressable] [signed] [toplevel] ndisc_ifinfo_sysctl_change( ... )
net/ipv6/ndisc.c: note: in included file (through include/net/ipv6.h):
./include/net/ndisc.h:496:5: note: previously declared as:
./include/net/ndisc.h:496:5:    int extern [addressable] [signed] [toplevel] ndisc_ifinfo_sysctl_change( ... )
net/ipv6/ndisc.c: note: in included file (through include/net/ip6_route.h):

Fixes: 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 include/net/ndisc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 9205a76d967a..38e4094960ce 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -494,7 +494,7 @@ int igmp6_event_report(struct sk_buff *skb);
 
 #ifdef CONFIG_SYSCTL
 int ndisc_ifinfo_sysctl_change(struct ctl_table *ctl, int write,
-			       void __user *buffer, size_t *lenp, loff_t *ppos);
+			       void *buffer, size_t *lenp, loff_t *ppos);
 int ndisc_ifinfo_sysctl_strategy(struct ctl_table *ctl,
 				 void __user *oldval, size_t __user *oldlenp,
 				 void __user *newval, size_t newlen);
-- 
2.27.0

