Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8206B165787
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 07:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbgBTGXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 01:23:15 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37172 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbgBTGXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 01:23:14 -0500
Received: by mail-pj1-f65.google.com with SMTP id m13so434092pjb.2
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 22:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BVbUzx4OtLJL33n3gcVzeyzzu3sZRJkzVIJtmTNV+t8=;
        b=JKxOV9AmdvytuXIbHOqsVPLiEQIr2s/zJTnOGnJ0C9/B4mRzi71p9CyGQLE0WiyZG1
         uCoBI9KY7JgQEXDxAxLhJ78/rqt7frpx3WhF7xrFGNEN/+3jrK/vKvgeYkdw9Tuf/+qv
         SIP2lN2ClGaLU7i6KOgMBvHHUFhTWKwQ6Xy5Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BVbUzx4OtLJL33n3gcVzeyzzu3sZRJkzVIJtmTNV+t8=;
        b=i8LaYb2xYVzwPs6qeQk+UXhBRFn2Btrl/dPyPfCMVusVAPuPcfZUQ1EuOaZ2FRVauR
         2iBEDPQVqyGg+I8GSh3A5696syPlR4lwVYo+feS5jFH6iH81vVBo3j/SV1lachSP/2aD
         4ttU9c4Km3hdWeecFaL7Hp+TakW5VwOqoBOWfPjKlJEMzTzdIW3enI8lBK63QN6QRQjU
         w6ufOG7dr1lIGMWBFqgsjf1KoSPy6P0/uVQU6MYBLdATH3ssFNFJqnXfh1N6yoT5ZoOJ
         oPRCzEHQYvts3C//nayTncbl06eKcHs4OZLnGBEoO5DMMOoMfVA1+Yr/0haEp6CLRwRK
         NGSg==
X-Gm-Message-State: APjAAAXgWSaWXFa1trlf0hyhr1kMYSG6EQQi3jUkCDf9TZ3SacD+Cylv
        55OFhbfLtHo2UVsRurmkRLD3Qw==
X-Google-Smtp-Source: APXvYqzXN0ax5Db2wRJdkMHnt8sHgkOkIWDQT9FiYaQD9pDs6MV//rTXASYUMAmxULw00aCV9LuFzA==
X-Received: by 2002:a17:90a:6c26:: with SMTP id x35mr1732741pjj.126.1582179792813;
        Wed, 19 Feb 2020 22:23:12 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x21sm1755020pfq.76.2020.02.19.22.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 22:23:11 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Pravin B Shelar <pshelar@ovn.org>
Cc:     Alexander Potapenko <glider@google.com>,
        Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: [PATCH] openvswitch: Distribute switch variables for initialization
Date:   Wed, 19 Feb 2020 22:23:09 -0800
Message-Id: <20200220062309.69077-1-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variables declared in a switch statement before any case statements
cannot be automatically initialized with compiler instrumentation (as
they are not part of any execution flow). With GCC's proposed automatic
stack variable initialization feature, this triggers a warning (and they
don't get initialized). Clang's automatic stack variable initialization
(via CONFIG_INIT_STACK_ALL=y) doesn't throw a warning, but it also
doesn't initialize such variables[1]. Note that these warnings (or silent
skipping) happen before the dead-store elimination optimization phase,
so even when the automatic initializations are later elided in favor of
direct initializations, the warnings remain.

To avoid these problems, move such variables into the "case" where
they're used or lift them up into the main function body.

net/openvswitch/flow_netlink.c: In function ‘validate_set’:
net/openvswitch/flow_netlink.c:2711:29: warning: statement will never be executed [-Wswitch-unreachable]
 2711 |  const struct ovs_key_ipv4 *ipv4_key;
      |                             ^~~~~~~~

[1] https://bugs.llvm.org/show_bug.cgi?id=44916

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/openvswitch/flow_netlink.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 7da4230627f5..288122eec7c8 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2708,10 +2708,6 @@ static int validate_set(const struct nlattr *a,
 		return -EINVAL;
 
 	switch (key_type) {
-	const struct ovs_key_ipv4 *ipv4_key;
-	const struct ovs_key_ipv6 *ipv6_key;
-	int err;
-
 	case OVS_KEY_ATTR_PRIORITY:
 	case OVS_KEY_ATTR_SKB_MARK:
 	case OVS_KEY_ATTR_CT_MARK:
@@ -2723,7 +2719,9 @@ static int validate_set(const struct nlattr *a,
 			return -EINVAL;
 		break;
 
-	case OVS_KEY_ATTR_TUNNEL:
+	case OVS_KEY_ATTR_TUNNEL: {
+		int err;
+
 		if (masked)
 			return -EINVAL; /* Masked tunnel set not supported. */
 
@@ -2732,8 +2730,10 @@ static int validate_set(const struct nlattr *a,
 		if (err)
 			return err;
 		break;
+	}
+	case OVS_KEY_ATTR_IPV4: {
+		const struct ovs_key_ipv4 *ipv4_key;
 
-	case OVS_KEY_ATTR_IPV4:
 		if (eth_type != htons(ETH_P_IP))
 			return -EINVAL;
 
@@ -2753,8 +2753,10 @@ static int validate_set(const struct nlattr *a,
 				return -EINVAL;
 		}
 		break;
+	}
+	case OVS_KEY_ATTR_IPV6: {
+		const struct ovs_key_ipv6 *ipv6_key;
 
-	case OVS_KEY_ATTR_IPV6:
 		if (eth_type != htons(ETH_P_IPV6))
 			return -EINVAL;
 
@@ -2781,7 +2783,7 @@ static int validate_set(const struct nlattr *a,
 			return -EINVAL;
 
 		break;
-
+	}
 	case OVS_KEY_ATTR_TCP:
 		if ((eth_type != htons(ETH_P_IP) &&
 		     eth_type != htons(ETH_P_IPV6)) ||
-- 
2.20.1


