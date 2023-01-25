Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31CB667BB26
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbjAYTwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235923AbjAYTvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:51:40 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A1A5A837
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:51:16 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id jr19so15744351qtb.7
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ynxqDD9dmXq6i1IlPGmfDyOtRRcCJcYPb2X1L7BZAaM=;
        b=eLwsDKz0+WaovfI57YTUL9TU5FHGu2Xz4gBVMLaxTAR9PkJbeU3Y75phvfmSdrABDQ
         9Bsf0BRYMR2wHG8O6my3RU34AQR2zLsvsTMj5sbMWWd6O+Q+f5u8WAlkxakH9nmJIo2f
         LWOBCe2jdH+d2dp5FLAqvrshi06C6rNox8Vb6i8atRKGOoVd/G3uStbqrBLlMK5kbVMr
         CcpCV0HWVlw6hJskgjysCeBgC61ZlhcCCBIJ7CLAvSoKiFmuv9A3TfHBudD22LhVLvTg
         i8p8DS9pAclhTLP7Q9EeNGg0k8U9XtBJmnDgHw6PGHwcd5a4x+7pqRpa9X/2cngyUo6m
         wGlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ynxqDD9dmXq6i1IlPGmfDyOtRRcCJcYPb2X1L7BZAaM=;
        b=gKtbIvKQWDlN6E/5SyA168ddx7L//zaLznxAi5lznIMU2XvkAYEI11dKYtZCz6LC+W
         cQaoTo212FVaDxW1qhV6EKlKSyboDuUmKh/GAS7G+wzYCRMfWA9vXu8VQo3V52Zrz9w7
         x67RCpyw2wxXZ7tWOaGcXaKAcn+xDljIEeF20eHBBTnECi6X1+jInQtww8o6FnB7INCz
         9U4Sjlq3zpST67uDmt68x/nxcQsoXeV0t+AQ4eRT31eSwSr5DoGmRUZyMeGlWq4ukrtZ
         PcY7/p+D/J5drSg3o4fXJoULoJcdTuD8dV3qjt5JkodSc2IeJOmcT5/a2AvzSUjOzXu4
         sn+g==
X-Gm-Message-State: AFqh2krYmNbOEuidKhoj9xTtK/KT/bZyjD5guGjDrsY9cGNrURoL//QF
        OHXDHhMVJvvhvXl1wrayOlM=
X-Google-Smtp-Source: AMrXdXubxGrQcSj8Hjv8s94ggO2CqcM+yMKLIWWt6/tmLfUkq/m3Dm3LnGIMk/A/bPXpKjHy0jUdtA==
X-Received: by 2002:ac8:7383:0:b0:3ac:c2b8:18 with SMTP id t3-20020ac87383000000b003acc2b80018mr47450952qtp.19.1674676275634;
        Wed, 25 Jan 2023 11:51:15 -0800 (PST)
Received: from r.. ([2601:18f:700:287c::1006])
        by smtp.gmail.com with ESMTPSA id 4-20020ac85604000000b003b637642405sm3897299qtr.5.2023.01.25.11.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 11:51:15 -0800 (PST)
From:   Brian Haley <haleyb.dev@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2] neighbor: fix proxy_delay usage when it is zero
Date:   Wed, 25 Jan 2023 14:51:14 -0500
Message-Id: <20230125195114.596295-1-haleyb.dev@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When set to zero, the neighbor sysctl proxy_delay value
does not cause an immediate reply for ARP/ND requests
as expected, it instead causes a random delay between
[0, U32_MAX]. Looking at this comment from
__get_random_u32_below() explains the reason:

/*
 * This function is technically undefined for ceil == 0, and in fact
 * for the non-underscored constant version in the header, we build bug
 * on that. But for the non-constant case, it's convenient to have that
 * evaluate to being a straight call to get_random_u32(), so that
 * get_random_u32_inclusive() can work over its whole range without
 * undefined behavior.
 */

Added helper function that does not call get_random_u32_below()
if proxy_delay is zero and just uses the current value of
jiffies instead, causing pneigh_enqueue() to respond
immediately.

Also added definition of proxy_delay to ip-sysctl.txt since
it was missing.

Signed-off-by: Brian Haley <haleyb.dev@gmail.com>
---
 Documentation/networking/ip-sysctl.rst |  8 ++++++++
 net/core/neighbour.c                   | 14 ++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 7fbd060d6047..58f74051e07b 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1589,6 +1589,14 @@ proxy_arp_pvlan - BOOLEAN
 	  Hewlett-Packard call it Source-Port filtering or port-isolation.
 	  Ericsson call it MAC-Forced Forwarding (RFC Draft).
 
+proxy_delay - INTEGER
+	Delay proxy response.
+
+	Delay response to a neighbor solicitation when proxy_arp
+	or proxy_ndp is enabled. A random value between [0, proxy_delay]
+	will be chosen, setting to zero means reply with no delay.
+	Value in jiffies. Defaults to 80.
+
 shared_media - BOOLEAN
 	Send(router) or accept(host) RFC1620 shared media redirects.
 	Overrides secure_redirects.
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index f00a79fc301b..57258110bccd 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1662,11 +1662,21 @@ static void neigh_proxy_process(struct timer_list *t)
 	spin_unlock(&tbl->proxy_queue.lock);
 }
 
+static unsigned long neigh_proxy_delay(struct neigh_parms *p)
+{
+	/* If proxy_delay is zero, do not call get_random_u32_below()
+	 * as it is undefined behavior.
+	 */
+	unsigned long proxy_delay = NEIGH_VAR(p, PROXY_DELAY);
+
+	return proxy_delay ?
+	       jiffies + get_random_u32_below(proxy_delay) : jiffies;
+}
+
 void pneigh_enqueue(struct neigh_table *tbl, struct neigh_parms *p,
 		    struct sk_buff *skb)
 {
-	unsigned long sched_next = jiffies +
-			get_random_u32_below(NEIGH_VAR(p, PROXY_DELAY));
+	unsigned long sched_next = neigh_proxy_delay(p);
 
 	if (p->qlen > NEIGH_VAR(p, PROXY_QLEN)) {
 		kfree_skb(skb);
-- 
2.34.1

