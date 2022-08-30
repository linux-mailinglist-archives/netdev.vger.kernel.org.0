Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6185A662E
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 16:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiH3OXs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Aug 2022 10:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbiH3OXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 10:23:43 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADEADB7EC
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 07:23:43 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-AcPKJvUVM-iDZwXrQ1B6ig-1; Tue, 30 Aug 2022 10:23:39 -0400
X-MC-Unique: AcPKJvUVM-iDZwXrQ1B6ig-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB8533C0D197;
        Tue, 30 Aug 2022 14:23:38 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D20904010FA6;
        Tue, 30 Aug 2022 14:23:37 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 3/6] xfrm: add extack to verify_policy_dir
Date:   Tue, 30 Aug 2022 16:23:09 +0200
Message-Id: <4aa27e6cab09880238814a816a5bfbe837a0d0e9.1661162395.git.sd@queasysnail.net>
In-Reply-To: <cover.1661162395.git.sd@queasysnail.net>
References: <cover.1661162395.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/xfrm/xfrm_user.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index fa6024b2c88b..0042b77337bd 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1481,7 +1481,7 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
-static int verify_policy_dir(u8 dir)
+static int verify_policy_dir(u8 dir, struct netlink_ext_ack *extack)
 {
 	switch (dir) {
 	case XFRM_POLICY_IN:
@@ -1490,6 +1490,7 @@ static int verify_policy_dir(u8 dir)
 		break;
 
 	default:
+		NL_SET_ERR_MSG(extack, "Invalid policy direction");
 		return -EINVAL;
 	}
 
@@ -1566,7 +1567,7 @@ static int verify_newpolicy_info(struct xfrm_userpolicy_info *p,
 		return -EINVAL;
 	}
 
-	ret = verify_policy_dir(p->dir);
+	ret = verify_policy_dir(p->dir, extack);
 	if (ret)
 		return ret;
 	if (p->index && (xfrm_policy_id2dir(p->index) != p->dir)) {
@@ -2102,7 +2103,7 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err)
 		return err;
 
-	err = verify_policy_dir(p->dir);
+	err = verify_policy_dir(p->dir, extack);
 	if (err)
 		return err;
 
@@ -2407,7 +2408,7 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err)
 		return err;
 
-	err = verify_policy_dir(p->dir);
+	err = verify_policy_dir(p->dir, extack);
 	if (err)
 		return err;
 
-- 
2.37.2

