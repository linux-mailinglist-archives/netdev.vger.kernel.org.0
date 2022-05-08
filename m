Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA0851ECDF
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 12:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiEHK0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 06:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiEHK0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 06:26:09 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DB7DF7A
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 03:22:20 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id x18so11397914plg.6
        for <netdev@vger.kernel.org>; Sun, 08 May 2022 03:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A1LXfmZVplL0ynSQarhX7NF52k9l9PvkB8nF4SlH0Ts=;
        b=Ti2I/7r0sShki4FPdLbemb4rVkvsMf3044SFMiwLfpBZXkNTI+gon8hjqEKCmWbMsl
         AvQucsEEDObapro5fqujH+hvQE67/IXrf1pM0rhA4Xoug893OhnSiC6uTOmacz+k/hkc
         OOIxgDNsx0NK1rvkUV6Cnl5LM1UhCtDsfSAq8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A1LXfmZVplL0ynSQarhX7NF52k9l9PvkB8nF4SlH0Ts=;
        b=DZbRoafvnmsDCQOWT/2EP+xZO/Gsx0PHKPXZEhO4lWhxZt5GJTIzV8zsoqfVNnkeS7
         Anu0XNxTqzEyc6yCyOj4WXKUUnSaghi1jeF/TGOTBHViJ9ucZHgok0ZzCTXAUn6DvYsB
         xFBdGAltRMkejCxtOmWiAjQ1TEnu1x3Ai5AbWcLK5Nz28Sni/V0lqyWDWzIbWXPg0nGd
         rMBAR4Rq0PujCriI8JGD2wnEtgflt/S33Sh0TGI7vaf9zspukwiGUB09Vl+AHHJVY1G5
         HZMbaaylwZn7Vtqn6NbloHKw68FgyqjI5l/tByG5XtnWYozRF830Tup0UXg2o+d6hOMu
         LL1Q==
X-Gm-Message-State: AOAM5302XCZoJ4IRlN2rADnvS9Y0KliDKVHl2qDMQKYl6Z0Oji0+M+TY
        Jz2UGtewytLils3ncm2XNEzuBQ==
X-Google-Smtp-Source: ABdhPJydL5LFKKyQZ4zH73vJdPVqKHx1a+AUAS5gSA44u/ZBd/ZLnmh0GTF2ZCxk0Sh6FDb9XBk1SA==
X-Received: by 2002:a17:90a:f3cb:b0:1d9:62d4:25db with SMTP id ha11-20020a17090af3cb00b001d962d425dbmr12868109pjb.222.1652005339955;
        Sun, 08 May 2022 03:22:19 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 24-20020a630e58000000b003c18e0768e3sm6282253pgo.78.2022.05.08.03.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 03:22:19 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Kees Cook <keescook@chromium.org>,
        kernel test robot <lkp@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Bill Wendling <morbo@google.com>,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] decnet: Use container_of() for struct dn_neigh casts
Date:   Sun,  8 May 2022 03:22:17 -0700
Message-Id: <20220508102217.2647184-1-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3446; h=from:subject; bh=+l+yjvSlQG66hH93c6GLUCBvIJkg4CiTdFELRDIUpus=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBid5nY2cRLINCQ2bxt6khjCjuNWu+eOO2gv5Cl0wzw th3zU8CJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYneZ2AAKCRCJcvTf3G3AJgA+D/ 99aMbeAf2ZnQJxiBaIcRp9TVABSr4pX4tbVz/S4fIM7Ctp23atFcCOQq2PeFiTPe+cWUySseRxk5q1 /DK1g91/2vHBE4MJwjTaZis9Kx1U/CMHkaNWuVD4c78p5Cdkxm7OKXMOpJU02nlKfgVjlJn+86gkdK opQyBNrR6NRGOT7lHKfbTzdV8FTKmpHYUT93tOrIOAkJj0lrEbucbcf5zZ5irLP7XGlmYyMY52E2k4 /noPIO9vAhG7qn0rJKurfHG1VpkCs65B45dWhwQah8D2CK9/t6PBVmv26t8PWGAeg4ZkvqtKrNA3u9 aDHq/yKpCNastOvqs9Ll6SZez3z78N6Ym0vbcynIklLdQsZJAuovTtDug+vnjU0JpPd98Wh5fpjNvd pxEecRYGRCxtlQUdvjzfi7oHZmr9kLrHfln8j0N977N9eIc70FK3xBvG91+72uFL22XQcnnhjPzDSh lMLMOhQ+EUj0oQTmrFvc1n9a9zGSNRm5ho6qu5CueRiEHKTA2Lh4GTf/M5gZR/dA9Pjh6ELQgAK2jP BN1XDqsthpCiNyygRkBW0//44TgSouu5dE8blVHNbIVs+9Z9k932kn1Vc9w9tKWTUeqN9s99s2VEZJ KKaiLgqNjckzMzHC19Zugc36Wc0Cpv8tQnzyZ7+ZB8lv7LzBlDJKw8sZiM1w==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang's structure layout randomization feature gets upset when it sees
struct neighbor (which is randomized) cast to struct dn_neigh:

net/decnet/dn_route.c:1123:15: error: casting from randomized structure pointer type 'struct neighbour *' to 'struct dn_neigh *'
			gateway = ((struct dn_neigh *)neigh)->addr;
				   ^

Update all the open-coded casts to use container_of() to do the conversion
instead of depending on strict member ordering.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/202205041247.WKBEHGS5-lkp@intel.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Yajun Deng <yajun.deng@linux.dev>
Cc: Zheng Yongjun <zhengyongjun3@huawei.com>
Cc: Bill Wendling <morbo@google.com>
Cc: linux-decnet-user@lists.sourceforge.net
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/decnet/dn_dev.c   | 4 ++--
 net/decnet/dn_neigh.c | 3 ++-
 net/decnet/dn_route.c | 4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index 0ee7d4c0c955..a09ba642b5e7 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -854,7 +854,7 @@ static void dn_send_endnode_hello(struct net_device *dev, struct dn_ifaddr *ifa)
 	memcpy(msg->neighbor, dn_hiord, ETH_ALEN);
 
 	if (dn_db->router) {
-		struct dn_neigh *dn = (struct dn_neigh *)dn_db->router;
+		struct dn_neigh *dn = container_of(dn_db->router, struct dn_neigh, n);
 		dn_dn2eth(msg->neighbor, dn->addr);
 	}
 
@@ -902,7 +902,7 @@ static void dn_send_router_hello(struct net_device *dev, struct dn_ifaddr *ifa)
 {
 	int n;
 	struct dn_dev *dn_db = rcu_dereference_raw(dev->dn_ptr);
-	struct dn_neigh *dn = (struct dn_neigh *)dn_db->router;
+	struct dn_neigh *dn = container_of(dn_db->router, struct dn_neigh, n);
 	struct sk_buff *skb;
 	size_t size;
 	unsigned char *ptr;
diff --git a/net/decnet/dn_neigh.c b/net/decnet/dn_neigh.c
index 94b306f6d551..fbd98ac853ea 100644
--- a/net/decnet/dn_neigh.c
+++ b/net/decnet/dn_neigh.c
@@ -426,7 +426,8 @@ int dn_neigh_router_hello(struct net *net, struct sock *sk, struct sk_buff *skb)
 			if (!dn_db->router) {
 				dn_db->router = neigh_clone(neigh);
 			} else {
-				if (msg->priority > ((struct dn_neigh *)dn_db->router)->priority)
+				if (msg->priority > container_of(dn_db->router,
+								 struct dn_neigh, n)->priority)
 					neigh_release(xchg(&dn_db->router, neigh_clone(neigh)));
 			}
 		}
diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index 7e85f2a1ae25..d1d78a463a06 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -1120,7 +1120,7 @@ static int dn_route_output_slow(struct dst_entry **pprt, const struct flowidn *o
 		/* Ok then, we assume its directly connected and move on */
 select_source:
 		if (neigh)
-			gateway = ((struct dn_neigh *)neigh)->addr;
+			gateway = container_of(neigh, struct dn_neigh, n)->addr;
 		if (gateway == 0)
 			gateway = fld.daddr;
 		if (fld.saddr == 0) {
@@ -1429,7 +1429,7 @@ static int dn_route_input_slow(struct sk_buff *skb)
 		/* Use the default router if there is one */
 		neigh = neigh_clone(dn_db->router);
 		if (neigh) {
-			gateway = ((struct dn_neigh *)neigh)->addr;
+			gateway = container_of(neigh, struct dn_neigh, n)->addr;
 			goto make_route;
 		}
 
-- 
2.32.0

