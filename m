Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2EB2233A8
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgGQGYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgGQGYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:24:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9F7C08C5C0;
        Thu, 16 Jul 2020 23:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=milvAVOJM4QLrRIHrecFW2GQRin+zd5F1vYyEysY7aY=; b=cLAkMx61vS6bwmd5Zd6uLyOfjO
        FgVzMLW/0vRlJLKn+atJQKqBiPdF+U5ARr5iGTBorAQzgeqPKzY3EOx2DDiJuc7ouc222OqWynkYB
        nlUfxQqT+4SONem/13J3C/tjq+V1QbpfmaLCfbOge+hsPTsTNjjZ2uiesF3elNxm9AeTZUBLIT4Oy
        HHHI4r01Su6AMPqsIEs9/fhoWHJnuCf7dAw6AhPjjRuT+wkFL12TSZF8rp40ZzOkKwQCwPbC3q8zv
        FoAxxR8D1oGS0Cmdx+S2JiPfNyC4SIkkWqK3Zotj8YceIpSQN/r2Vt2xbXJhixo8cW2/PSLlivkw9
        LJyzhv2g==;
Received: from [2001:4bb8:105:4a81:3772:912d:640:e6c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jwJn4-000545-1S; Fri, 17 Jul 2020 06:24:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chas Williams <3chas3@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-wpan@vger.kernel.org, mptcp@lists.01.org
Subject: [PATCH 12/22] netfilter: remove the compat argument to xt_copy_counters_from_user
Date:   Fri, 17 Jul 2020 08:23:21 +0200
Message-Id: <20200717062331.691152-13-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200717062331.691152-1-hch@lst.de>
References: <20200717062331.691152-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lift the in_compat_syscall() from the callers instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/netfilter/x_tables.h | 2 +-
 net/ipv4/netfilter/arp_tables.c    | 3 +--
 net/ipv4/netfilter/ip_tables.c     | 3 +--
 net/ipv6/netfilter/ip6_tables.c    | 3 +--
 net/netfilter/x_tables.c           | 9 ++++-----
 5 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 5da88451853b28..b8b943ee7b8b66 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -302,7 +302,7 @@ int xt_data_to_user(void __user *dst, const void *src,
 		    int usersize, int size, int aligned_size);
 
 void *xt_copy_counters_from_user(const void __user *user, unsigned int len,
-				 struct xt_counters_info *info, bool compat);
+				 struct xt_counters_info *info);
 struct xt_counters *xt_counters_alloc(unsigned int counters);
 
 struct xt_table *xt_register_table(struct net *net,
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 15807fb4a65f3e..2c8a4dad39d748 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1008,8 +1008,7 @@ static int do_add_counters(struct net *net, const void __user *user,
 	struct arpt_entry *iter;
 	unsigned int addend;
 
-	paddc = xt_copy_counters_from_user(user, len, &tmp,
-					   in_compat_syscall());
+	paddc = xt_copy_counters_from_user(user, len, &tmp);
 	if (IS_ERR(paddc))
 		return PTR_ERR(paddc);
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index fbfad38f397949..161901dd1cae7f 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1163,8 +1163,7 @@ do_add_counters(struct net *net, const void __user *user,
 	struct ipt_entry *iter;
 	unsigned int addend;
 
-	paddc = xt_copy_counters_from_user(user, len, &tmp,
-					   in_compat_syscall());
+	paddc = xt_copy_counters_from_user(user, len, &tmp);
 	if (IS_ERR(paddc))
 		return PTR_ERR(paddc);
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 96c48e91e6c7f7..fd1f8f93123188 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1179,8 +1179,7 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len)
 	struct ip6t_entry *iter;
 	unsigned int addend;
 
-	paddc = xt_copy_counters_from_user(user, len, &tmp,
-					   in_compat_syscall());
+	paddc = xt_copy_counters_from_user(user, len, &tmp);
 	if (IS_ERR(paddc))
 		return PTR_ERR(paddc);
 	t = xt_find_table_lock(net, AF_INET6, tmp.name);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 99a468be4a59fb..32bab45af7e415 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1033,15 +1033,14 @@ EXPORT_SYMBOL_GPL(xt_check_target);
  * @user: src pointer to userspace memory
  * @len: alleged size of userspace memory
  * @info: where to store the xt_counters_info metadata
- * @compat: true if we setsockopt call is done by 32bit task on 64bit kernel
  *
  * Copies counter meta data from @user and stores it in @info.
  *
  * vmallocs memory to hold the counters, then copies the counter data
  * from @user to the new memory and returns a pointer to it.
  *
- * If @compat is true, @info gets converted automatically to the 64bit
- * representation.
+ * If called from a compat syscall, @info gets converted automatically to the
+ * 64bit representation.
  *
  * The metadata associated with the counters is stored in @info.
  *
@@ -1049,13 +1048,13 @@ EXPORT_SYMBOL_GPL(xt_check_target);
  * If IS_ERR is false, caller has to vfree the pointer.
  */
 void *xt_copy_counters_from_user(const void __user *user, unsigned int len,
-				 struct xt_counters_info *info, bool compat)
+				 struct xt_counters_info *info)
 {
 	void *mem;
 	u64 size;
 
 #ifdef CONFIG_COMPAT
-	if (compat) {
+	if (in_compat_syscall()) {
 		/* structures only differ in size due to alignment */
 		struct compat_xt_counters_info compat_tmp;
 
-- 
2.27.0

