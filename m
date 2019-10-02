Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC92CC94E4
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbfJBXhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:22 -0400
Received: from mga04.intel.com ([192.55.52.120]:16447 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728405AbfJBXhU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862579"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:19 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 02/45] net: Make sock protocol value checks more specific
Date:   Wed,  2 Oct 2019 16:36:12 -0700
Message-Id: <20191002233655.24323-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SK_PROTOCOL_MAX is only used in two places, for DECNet and AX.25. The
limits have more to do with the those protocol definitions than they do
with the data type of sk_protocol, so remove SK_PROTOCOL_MAX and use
U8_MAX directly.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/sock.h     | 1 -
 net/ax25/af_ax25.c     | 2 +-
 net/decnet/af_decnet.c | 2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 2c53f1a1d905..c3fc62bd3e2f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -459,7 +459,6 @@ struct sock {
 				sk_userlocks : 4,
 				sk_protocol  : 8,
 				sk_type      : 16;
-#define SK_PROTOCOL_MAX U8_MAX
 	u16			sk_gso_max_segs;
 	u8			sk_pacing_shift;
 	unsigned long	        sk_lingertime;
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index bb222b882b67..be5772f43816 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -808,7 +808,7 @@ static int ax25_create(struct net *net, struct socket *sock, int protocol,
 	struct sock *sk;
 	ax25_cb *ax25;
 
-	if (protocol < 0 || protocol > SK_PROTOCOL_MAX)
+	if (protocol < 0 || protocol > U8_MAX)
 		return -EINVAL;
 
 	if (!net_eq(net, &init_net))
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 0ea75286abf4..7c0c769a8b26 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -670,7 +670,7 @@ static int dn_create(struct net *net, struct socket *sock, int protocol,
 {
 	struct sock *sk;
 
-	if (protocol < 0 || protocol > SK_PROTOCOL_MAX)
+	if (protocol < 0 || protocol > U8_MAX)
 		return -EINVAL;
 
 	if (!net_eq(net, &init_net))
-- 
2.23.0

