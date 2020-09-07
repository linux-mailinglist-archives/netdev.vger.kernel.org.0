Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F81925F870
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgIGKdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728957AbgIGKcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 06:32:09 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33123C061573;
        Mon,  7 Sep 2020 03:32:09 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id jw11so397194pjb.0;
        Mon, 07 Sep 2020 03:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Pw4vLVHMwoDygQJlXIN5N68/oqhIVb2RvXzyPohle44=;
        b=VRCH3XSpQ4u3zMgFGj8rAyOSSpcxroG/aE0ExPffuF8OobI+9Vv/tw5WTx5K9jcVwk
         PReTQyiwY6bCG+ZXKS0FMlq6CeJ/HcKjKDtvOVszirsFLI5NDOPCG2ikw0uDPYZiviph
         1fhEVdhrb0g0gEL82T2x3NjqRDS1kk1p3B4khGXVxOGXrXa1vRxaXA2l3wirPmVMvyRI
         JWn6/joUY0uf382x77OfdkIwZwefIIZh91siMj2zMRwVwLu5ujUMs7+dr2b3lRZ1Vsrg
         VKwtfuejEIcdpeQFu93VoU3ADC2X6s5HX9hR4zGaaG0EsqSXKZeqF0mIgG0d/UgzdL7x
         OVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Pw4vLVHMwoDygQJlXIN5N68/oqhIVb2RvXzyPohle44=;
        b=SQ48jUqeiI972dtbqVNI/4UbsMkqb2+FSgJj4Ubf7ENt/jQeFSf24bf9RTdKGc/Z6m
         5KFVpeqzcGjWfSseannJKF1/bza0HwHjXf7a9nWq7A4CTQa0k0z2z+ekoHMBHM5EgoIp
         ljjqJZuD7DNqOV31/4p7SdDLZAuUeorGZpX8Z1dRvp+Pt398SsAUbVLMiUiJYfzs0Wc2
         34VDvzz1k2eL+EvxW5HP3VNAz/4b2N9frsEs13VndZTXw69F7+LDHTC7RrTVB4ut0U48
         FebAn0gUAg1uupYQp/iVg9Yi1IybGLRGU44KrwiYJZ8kTnPxgopT5rKubBfwqfYl9pY/
         J6oA==
X-Gm-Message-State: AOAM533ZVY52B1fbKyvp5v6tTP/2b5CqOpLww/cs6yhb0rMS+0Nym8m5
        1ffbo5SpMh+tICAMQ9DhXfg=
X-Google-Smtp-Source: ABdhPJwgbmWuoKHYtI1E1MEPW4FTXssqzr5yMPDoSQ/DwmASfRL784uXblIQO/GlF+f/t/9NgW3Uww==
X-Received: by 2002:a17:90b:138a:: with SMTP id hr10mr20256288pjb.8.1599474728764;
        Mon, 07 Sep 2020 03:32:08 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id w203sm10524204pff.0.2020.09.07.03.32.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Sep 2020 03:32:07 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net 1/2] mptcp: fix subflow's local_id issues
Date:   Mon,  7 Sep 2020 18:29:53 +0800
Message-Id: <f24ee917e4043d2befe2a0f96cd57aa74d2a4b26.1599474422.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mptcp_pm_nl_get_local_id, skc_local is the same as msk_local, so it
always return 0. Thus every subflow's local_id is 0. It's incorrect.

This patch fixed this issue.

Also, we need to ignore the zero address here, like 0.0.0.0 in IPv4. When
we use the zero address as a local address, it means that we can use any
one of the local addresses. The zero address is not a new address, we don't
need to add it to PM, so this patch added a new function address_zero to
check whether an address is the zero address, if it is, we ignore this
address.

Reviewed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/pm_netlink.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 2c208d2e65cd..dc2c57860d2d 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -66,6 +66,19 @@ static bool addresses_equal(const struct mptcp_addr_info *a,
 	return a->port == b->port;
 }
 
+static bool address_zero(const struct mptcp_addr_info *addr)
+{
+	struct mptcp_addr_info zero;
+
+	memset(&zero, 0, sizeof(zero));
+	zero.family = addr->family;
+
+	if (addresses_equal(addr, &zero, false))
+		return true;
+
+	return false;
+}
+
 static void local_address(const struct sock_common *skc,
 			  struct mptcp_addr_info *addr)
 {
@@ -323,10 +336,13 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 	 * addr
 	 */
 	local_address((struct sock_common *)msk, &msk_local);
-	local_address((struct sock_common *)msk, &skc_local);
+	local_address((struct sock_common *)skc, &skc_local);
 	if (addresses_equal(&msk_local, &skc_local, false))
 		return 0;
 
+	if (address_zero(&skc_local))
+		return 0;
+
 	pernet = net_generic(sock_net((struct sock *)msk), pm_nl_pernet_id);
 
 	rcu_read_lock();
-- 
2.17.1

