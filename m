Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946A0343E3B
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 11:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhCVKpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 06:45:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230285AbhCVKoi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 06:44:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C6E561931;
        Mon, 22 Mar 2021 10:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616409878;
        bh=4DHr4ASfBHeq91iw3ENPpzdWKJXn5AZnZFrECFYNDQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cPqdnpIc76Sfc4S0WxhticZnlpY46xJtVyxtipkLrFREoyJDHLvaO/JOmmYxuBWn2
         Q0FCwxw6Vr4/fhlrJgzOVXrxEJh/QNygiAQyTlOcSVijlINs+eiK85+SosPEEv7Fxd
         8oBK07+cbrYR03jU9PREWW2n1R/sW1vihSey94bPNz1rEkiqTuQQvCbV/pphwWOsUR
         HTquMlF8zDU10yLDmixg4KhY+reClZyxOHPp9D85pRg/4e0TgeCXDdxEVTbUAbN/BL
         uUTzQafLyU5Im+LELXwwuizxaAm0DYAjBRKAjYTUp2h940q/MYbRnKEK0i5TyK9AY6
         bT5zKR5TkZb6g==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, dccp@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/5] dccp: avoid Wempty-body warning
Date:   Mon, 22 Mar 2021 11:43:32 +0100
Message-Id: <20210322104343.948660-2-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322104343.948660-1-arnd@kernel.org>
References: <20210322104343.948660-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

There are a couple of warnings in this driver when building with W=1:

net/dccp/output.c: In function 'dccp_xmit_packet':
net/dccp/output.c:283:71: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
  283 |                 dccp_pr_debug("transmit_skb() returned err=%d\n", err);
      |                                                                       ^
net/dccp/ackvec.c: In function 'dccp_ackvec_update_old':
net/dccp/ackvec.c:163:80: error: suggest braces around empty body in an 'else' statement [-Werror=empty-body]
  163 |                                               (unsigned long long)seqno, state);
      |                                                                                ^

Change the empty debug macros to no_printk(), which avoids the
warnings and adds useful format string checks.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/dccp/dccp.h  | 6 +++---
 net/dccp/proto.c | 2 --
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
index 9cc9d1ee6cdb..8a5163620bc3 100644
--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -41,9 +41,9 @@ extern bool dccp_debug;
 #define dccp_pr_debug_cat(format, a...)   DCCP_PRINTK(dccp_debug, format, ##a)
 #define dccp_debug(fmt, a...)		  dccp_pr_debug_cat(KERN_DEBUG fmt, ##a)
 #else
-#define dccp_pr_debug(format, a...)
-#define dccp_pr_debug_cat(format, a...)
-#define dccp_debug(format, a...)
+#define dccp_pr_debug(format, a...)	  no_printk(format, ##a)
+#define dccp_pr_debug_cat(format, a...)	  no_printk(format, ##a)
+#define dccp_debug(format, a...)	  no_printk(format, ##a)
 #endif
 
 extern struct inet_hashinfo dccp_hashinfo;
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 6d705d90c614..97a175eaf247 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -51,7 +51,6 @@ EXPORT_SYMBOL_GPL(dccp_hashinfo);
 /* the maximum queue length for tx in packets. 0 is no limit */
 int sysctl_dccp_tx_qlen __read_mostly = 5;
 
-#ifdef CONFIG_IP_DCCP_DEBUG
 static const char *dccp_state_name(const int state)
 {
 	static const char *const dccp_state_names[] = {
@@ -73,7 +72,6 @@ static const char *dccp_state_name(const int state)
 	else
 		return dccp_state_names[state];
 }
-#endif
 
 void dccp_set_state(struct sock *sk, const int state)
 {
-- 
2.29.2

