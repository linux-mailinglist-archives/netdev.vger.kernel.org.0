Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C351270BE
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 23:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfLSWe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 17:34:59 -0500
Received: from mga04.intel.com ([192.55.52.120]:29335 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726911AbfLSWe7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 17:34:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 14:34:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,333,1571727600"; 
   d="scan'208";a="248484457"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.1.107])
  by fmsmga002.fm.intel.com with ESMTP; 19 Dec 2019 14:34:57 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v5 01/11] net: Make sock protocol value checks more specific
Date:   Thu, 19 Dec 2019 14:34:24 -0800
Message-Id: <20191219223434.19722-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com>
References: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com>
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
index 87d54ef57f00..81dc811aad2e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -458,7 +458,6 @@ struct sock {
 				sk_userlocks : 4,
 				sk_protocol  : 8,
 				sk_type      : 16;
-#define SK_PROTOCOL_MAX U8_MAX
 	u16			sk_gso_max_segs;
 	u8			sk_pacing_shift;
 	unsigned long	        sk_lingertime;
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 324306d6fde0..ff57ea89c27e 100644
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
index e19a92a62e14..0a46ea3bddd5 100644
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
2.24.1

