Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87605B8DCE
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 19:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiINRE7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Sep 2022 13:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiINREz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 13:04:55 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AA2BE38
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 10:04:49 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-OWMlqWBjPY6x7EpmqOp2pg-1; Wed, 14 Sep 2022 13:04:44 -0400
X-MC-Unique: OWMlqWBjPY6x7EpmqOp2pg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3062F811E81;
        Wed, 14 Sep 2022 17:04:44 +0000 (UTC)
Received: from hog.localdomain (unknown [10.40.195.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C1BF1121314;
        Wed, 14 Sep 2022 17:04:42 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 2/7] xfrm: add extack to verify_replay
Date:   Wed, 14 Sep 2022 19:04:01 +0200
Message-Id: <d30c6858175638a9a8b8bdc50a3cb795734b7643.1663103634.git.sd@queasysnail.net>
In-Reply-To: <cover.1663103634.git.sd@queasysnail.net>
References: <cover.1663103634.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
 net/xfrm/xfrm_user.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 4167c189d35b..048c1e150b4e 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -121,29 +121,43 @@ static inline int verify_sec_ctx_len(struct nlattr **attrs, struct netlink_ext_a
 }
 
 static inline int verify_replay(struct xfrm_usersa_info *p,
-				struct nlattr **attrs)
+				struct nlattr **attrs,
+				struct netlink_ext_ack *extack)
 {
 	struct nlattr *rt = attrs[XFRMA_REPLAY_ESN_VAL];
 	struct xfrm_replay_state_esn *rs;
 
-	if (!rt)
-		return (p->flags & XFRM_STATE_ESN) ? -EINVAL : 0;
+	if (!rt) {
+		if (p->flags & XFRM_STATE_ESN) {
+			NL_SET_ERR_MSG(extack, "Missing required attribute for ESN");
+			return -EINVAL;
+		}
+		return 0;
+	}
 
 	rs = nla_data(rt);
 
-	if (rs->bmp_len > XFRMA_REPLAY_ESN_MAX / sizeof(rs->bmp[0]) / 8)
+	if (rs->bmp_len > XFRMA_REPLAY_ESN_MAX / sizeof(rs->bmp[0]) / 8) {
+		NL_SET_ERR_MSG(extack, "ESN bitmap length must be <= 128");
 		return -EINVAL;
+	}
 
 	if (nla_len(rt) < (int)xfrm_replay_state_esn_len(rs) &&
-	    nla_len(rt) != sizeof(*rs))
+	    nla_len(rt) != sizeof(*rs)) {
+		NL_SET_ERR_MSG(extack, "ESN attribute is too short to fit the full bitmap length");
 		return -EINVAL;
+	}
 
 	/* As only ESP and AH support ESN feature. */
-	if ((p->id.proto != IPPROTO_ESP) && (p->id.proto != IPPROTO_AH))
+	if ((p->id.proto != IPPROTO_ESP) && (p->id.proto != IPPROTO_AH)) {
+		NL_SET_ERR_MSG(extack, "ESN only supported for ESP and AH");
 		return -EINVAL;
+	}
 
-	if (p->replay_window != 0)
+	if (p->replay_window != 0) {
+		NL_SET_ERR_MSG(extack, "ESN not compatible with legacy replay_window");
 		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -311,7 +325,7 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		goto out;
 	if ((err = verify_sec_ctx_len(attrs, extack)))
 		goto out;
-	if ((err = verify_replay(p, attrs)))
+	if ((err = verify_replay(p, attrs, extack)))
 		goto out;
 
 	err = -EINVAL;
-- 
2.37.3

