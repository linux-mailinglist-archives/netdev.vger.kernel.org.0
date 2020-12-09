Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5502D4F1C
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 00:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgLIXyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:54:44 -0500
Received: from mga06.intel.com ([134.134.136.31]:19330 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727901AbgLIXyn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:54:43 -0500
IronPort-SDR: Ub3L6pb7JyeFYdR3ThA9pL/k97S3cyJ/Ig95DlbZDxO+54oviuMrVJ8OO8gzuuLcEAwvYHgmnq
 NoRGzcwcH9NA==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="235763088"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="235763088"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:37 -0800
IronPort-SDR: xOLMialjtuaBmO1F5L+0AUaC424vDL/3LmYrMh2HHF0oLC4yrKvCV5+fNnRjCcpeNvb2Z5ur+p
 GxSBVNldNjUg==
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="318582180"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.111.12])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:37 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 01/11] mptcp: unify ADD_ADDR and echo suboptions writing
Date:   Wed,  9 Dec 2020 15:51:18 -0800
Message-Id: <20201209235128.175473-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
References: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

There are two differences between ADD_ADDR suboption and ADD_ADDR echo
suboption: The length of the former is 8 octets longer than the length
of the latter. The former's echo-flag is 0, and latter's echo-flag is 1.

This patch added two local variables, len and echo, to unify ADD_ADDR
and ADD_ADDR echo suboptions writing.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index b63f26bf348f..a061b2106cfe 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1076,15 +1076,16 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 
 mp_capable_done:
 	if (OPTION_MPTCP_ADD_ADDR & opts->suboptions) {
-		if (opts->ahmac)
-			*ptr++ = mptcp_option(MPTCPOPT_ADD_ADDR,
-					      TCPOLEN_MPTCP_ADD_ADDR, 0,
-					      opts->addr_id);
-		else
-			*ptr++ = mptcp_option(MPTCPOPT_ADD_ADDR,
-					      TCPOLEN_MPTCP_ADD_ADDR_BASE,
-					      MPTCP_ADDR_ECHO,
-					      opts->addr_id);
+		u8 len = TCPOLEN_MPTCP_ADD_ADDR_BASE;
+		u8 echo = MPTCP_ADDR_ECHO;
+
+		if (opts->ahmac) {
+			len += sizeof(opts->ahmac);
+			echo = 0;
+		}
+
+		*ptr++ = mptcp_option(MPTCPOPT_ADD_ADDR,
+				      len, echo, opts->addr_id);
 		memcpy((u8 *)ptr, (u8 *)&opts->addr.s_addr, 4);
 		ptr += 1;
 		if (opts->ahmac) {
@@ -1095,15 +1096,15 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	if (OPTION_MPTCP_ADD_ADDR6 & opts->suboptions) {
-		if (opts->ahmac)
-			*ptr++ = mptcp_option(MPTCPOPT_ADD_ADDR,
-					      TCPOLEN_MPTCP_ADD_ADDR6, 0,
-					      opts->addr_id);
-		else
-			*ptr++ = mptcp_option(MPTCPOPT_ADD_ADDR,
-					      TCPOLEN_MPTCP_ADD_ADDR6_BASE,
-					      MPTCP_ADDR_ECHO,
-					      opts->addr_id);
+		u8 len = TCPOLEN_MPTCP_ADD_ADDR6_BASE;
+		u8 echo = MPTCP_ADDR_ECHO;
+
+		if (opts->ahmac) {
+			len += sizeof(opts->ahmac);
+			echo = 0;
+		}
+		*ptr++ = mptcp_option(MPTCPOPT_ADD_ADDR,
+				      len, echo, opts->addr_id);
 		memcpy((u8 *)ptr, opts->addr6.s6_addr, 16);
 		ptr += 4;
 		if (opts->ahmac) {
-- 
2.29.2

