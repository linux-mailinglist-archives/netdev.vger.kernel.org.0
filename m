Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B13A6ADA13
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjCGJSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjCGJSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:18:32 -0500
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5F372018;
        Tue,  7 Mar 2023 01:18:31 -0800 (PST)
Received: from pride-PowerEdge-R740.. ([172.16.0.254])
        (user=dzm91@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 32795l0Y024133-32795l0b024133
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 7 Mar 2023 17:05:51 +0800
From:   Dongliang Mu <dzm91@hust.edu.cn>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>,
        syzbot+bd85b31816913a32e473@syzkaller.appspotmail.com,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: ieee802154: fix a null pointer in nl802154_trigger_scan
Date:   Tue,  7 Mar 2023 17:05:46 +0800
Message-Id: <20230307090546.994258-1-dzm91@hust.edu.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: dzm91@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a null pointer dereference if NL802154_ATTR_SCAN_TYPE is
not set by the user.

Fix this by adding a null pointer check.

Reported-and-tested-by: syzbot+bd85b31816913a32e473@syzkaller.appspotmail.com
Fixes: a0b6106672b5 ("ieee802154: Convert scan error messages to extack")
Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
---
v1->v2: add fixes tag
 net/ieee802154/nl802154.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 2215f576ee37..1cf00cffd63f 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1412,7 +1412,8 @@ static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 	}
 
-	if (!nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE])) {
+	if (!info->attrs[NL802154_ATTR_SCAN_TYPE] ||
+	    !nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE])) {
 		NL_SET_ERR_MSG(info->extack, "Malformed request, missing scan type");
 		return -EINVAL;
 	}
-- 
2.34.1

