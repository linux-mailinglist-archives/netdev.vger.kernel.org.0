Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4541444D649
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 13:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbhKKMGO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Nov 2021 07:06:14 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:25172 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233171AbhKKMGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 07:06:13 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-oGZos0vmPoeAHj50eNnyiA-1; Thu, 11 Nov 2021 07:03:06 -0500
X-MC-Unique: oGZos0vmPoeAHj50eNnyiA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50404E757;
        Thu, 11 Nov 2021 12:03:05 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7712E1017CE3;
        Thu, 11 Nov 2021 12:03:04 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [RFC PATCH ipsec-next 3/6] xfrm: add extack to verify_policy_dir
Date:   Thu, 11 Nov 2021 13:02:44 +0100
Message-Id: <0510c45767df504df68921a9b4508dcb185bf8e9.1636450303.git.sd@queasysnail.net>
In-Reply-To: <cover.1636450303.git.sd@queasysnail.net>
References: <cover.1636450303.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/xfrm/xfrm_user.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 9d7f6de53238..e8d790967ff3 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1466,7 +1466,7 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
-static int verify_policy_dir(u8 dir)
+static int verify_policy_dir(u8 dir, struct netlink_ext_ack *extack)
 {
 	switch (dir) {
 	case XFRM_POLICY_IN:
@@ -1475,6 +1475,7 @@ static int verify_policy_dir(u8 dir)
 		break;
 
 	default:
+		NL_SET_ERR_MSG(extack, "Invalid policy direction");
 		return -EINVAL;
 	}
 
@@ -1551,7 +1552,7 @@ static int verify_newpolicy_info(struct xfrm_userpolicy_info *p,
 		return -EINVAL;
 	}
 
-	ret = verify_policy_dir(p->dir);
+	ret = verify_policy_dir(p->dir, extack);
 	if (ret)
 		return ret;
 	if (p->index && (xfrm_policy_id2dir(p->index) != p->dir)) {
@@ -2051,7 +2052,7 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err)
 		return err;
 
-	err = verify_policy_dir(p->dir);
+	err = verify_policy_dir(p->dir, extack);
 	if (err)
 		return err;
 
@@ -2356,7 +2357,7 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err)
 		return err;
 
-	err = verify_policy_dir(p->dir);
+	err = verify_policy_dir(p->dir, extack);
 	if (err)
 		return err;
 
-- 
2.33.1

