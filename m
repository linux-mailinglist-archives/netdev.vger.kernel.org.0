Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B507E302FFC
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732898AbhAYXTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:19:36 -0500
Received: from conuserg-07.nifty.com ([210.131.2.74]:45862 "EHLO
        conuserg-07.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732660AbhAYXTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 18:19:22 -0500
Received: from localhost.localdomain (softbank126026094251.bbtec.net [126.26.94.251]) (authenticated)
        by conuserg-07.nifty.com with ESMTP id 10PNHDrD029059;
        Tue, 26 Jan 2021 08:17:13 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-07.nifty.com 10PNHDrD029059
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1611616634;
        bh=xwIb0oqMknXVdymXEZ6iq/BFlhwRA9qFCQ7anGrVqGg=;
        h=From:To:Cc:Subject:Date:From;
        b=KzyJpXCJXKnGOOfVfP7oeCny6KI2hL5T3EDgyMyAb+lYn3rwWdPjwK9PvjZFtKYcU
         bA4VVOSCpV8WTjKjxQEu2XIxwqBVLoss4P8n1F5j5agQr+x3v8y6V9dU4MB2Cxoh2p
         GiSZ2TlgyFpVHkQCSPG8ooIziLm7DWLXMQHUJ6sqPpS2MstSTEjSjOVxoAx5LFvGf9
         DRJScYKPhBqD1DNmTfsn76fg83DAOIDo+bdUVK3+7miCW5jiWU4HDhXrouMRfzITBe
         NMDZXItfH4c7BkZSzAio/ps7SEx7YETugX0ZtUyQEs4FT8xlmsyT1R9U43ZW/WzFs2
         CAaZfTYhldI+w==
X-Nifty-SrcIP: [126.26.94.251]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] net: move CONFIG_NET guard to top Makefile
Date:   Tue, 26 Jan 2021 08:16:55 +0900
Message-Id: <20210125231659.106201-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_NET is disabled, nothing under the net/ directory is
compiled. Move the CONFIG_NET guard to the top Makefile so the net/
directory is entirely skipped.

When Kbuild visits net/Makefile, CONFIG_NET is obvioulsy 'y' because
CONFIG_NET is a bool option. Clean up net/Makefile.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 Makefile     |  3 ++-
 net/Makefile | 11 ++++-------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index b0e4767735dc..61357f7eb55f 100644
--- a/Makefile
+++ b/Makefile
@@ -649,7 +649,8 @@ ifeq ($(KBUILD_EXTMOD),)
 core-y		:= init/ usr/
 drivers-y	:= drivers/ sound/
 drivers-$(CONFIG_SAMPLES) += samples/
-drivers-y	+= net/ virt/
+drivers-$(CONFIG_NET) += net/
+drivers-y	+= virt/
 libs-y		:= lib/
 endif # KBUILD_EXTMOD
 
diff --git a/net/Makefile b/net/Makefile
index d96b0aa8f39f..6fa3b2e26cab 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -6,20 +6,19 @@
 # Rewritten to use lists instead of if-statements.
 #
 
-obj-$(CONFIG_NET)		:= devres.o socket.o core/
+obj-y				:= devres.o socket.o core/
 
-tmp-$(CONFIG_COMPAT) 		:= compat.o
-obj-$(CONFIG_NET)		+= $(tmp-y)
+obj-$(CONFIG_COMPAT)		+= compat.o
 
 # LLC has to be linked before the files in net/802/
 obj-$(CONFIG_LLC)		+= llc/
-obj-$(CONFIG_NET)		+= ethernet/ 802/ sched/ netlink/ bpf/ ethtool/
+obj-y				+= ethernet/ 802/ sched/ netlink/ bpf/ ethtool/
 obj-$(CONFIG_NETFILTER)		+= netfilter/
 obj-$(CONFIG_INET)		+= ipv4/
 obj-$(CONFIG_TLS)		+= tls/
 obj-$(CONFIG_XFRM)		+= xfrm/
 obj-$(CONFIG_UNIX_SCM)		+= unix/
-obj-$(CONFIG_NET)		+= ipv6/
+obj-y				+= ipv6/
 obj-$(CONFIG_BPFILTER)		+= bpfilter/
 obj-$(CONFIG_PACKET)		+= packet/
 obj-$(CONFIG_NET_KEY)		+= key/
@@ -63,9 +62,7 @@ obj-$(CONFIG_6LOWPAN)		+= 6lowpan/
 obj-$(CONFIG_IEEE802154)	+= ieee802154/
 obj-$(CONFIG_MAC802154)		+= mac802154/
 
-ifeq ($(CONFIG_NET),y)
 obj-$(CONFIG_SYSCTL)		+= sysctl_net.o
-endif
 obj-$(CONFIG_DNS_RESOLVER)	+= dns_resolver/
 obj-$(CONFIG_CEPH_LIB)		+= ceph/
 obj-$(CONFIG_BATMAN_ADV)	+= batman-adv/
-- 
2.27.0

