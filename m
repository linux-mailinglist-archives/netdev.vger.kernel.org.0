Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3D2F3FB4
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 06:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730231AbfKHFVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 00:21:04 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:35519 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730193AbfKHFVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 00:21:04 -0500
Received: by mail-pf1-f170.google.com with SMTP id d13so3898350pfq.2;
        Thu, 07 Nov 2019 21:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=/mQQB4W3TqBl2ffoZEa9D2KE2awAYRMQqt3o4RLi5fQ=;
        b=hddid7TV+wrH11NHmd/PHp7V2X1sF9sTkRX0OBAI8F9gVgfqb+lLaPTMpXpWJNyIwI
         8UD9EYaPyzq5/zEJraxbWd+IYtsjp/Mu39bo75w8qufkyAnDA9lmCsSxs1tyNoj+cksa
         T1Yna9yxydH13hd4bZUF1gKU8KNvqB5uojVq0jo8SmyERKfYr+x8UeEl+cr4Srzx19d/
         IdQB/M6OYZXd2lbvqLNV0mBytecsRV2D+thOejTiNBiKHUlJU95MikJhF9cqtdtSsjwJ
         +HP55/7ueg28V1v2KEY73jHwXilfxJe57OWGK9z8ln8mOQcMP3ECP0AbJgKUkBoSlQhF
         sfgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=/mQQB4W3TqBl2ffoZEa9D2KE2awAYRMQqt3o4RLi5fQ=;
        b=FKYZoIWxsgwIxoI5g4kurHEK2JqKK6Mw36VdRPpoabWiZvxz2WAAni8jNWuYWw3MdG
         5iKKtnyZ/o3fCq/KJY1T64uxQzemcP/XJHAqeFZJUvW7eTwVaYx09ZBFsDj028QjqS0S
         bd+Z1592LGdaIS+tCu+yVLE0BXQ7roQ2RHvv2nxePyVVX5F4t6ta5Z6obljic1DT0dCv
         8AcwTR9THkGfqUUq2RjjSC+O1dJZCUjlU6GHzGSgnk8S9wN8nTl+QJ1tLyEsSS5YHawa
         /qD1joHQX5k89Z/osM1mjG5/sRqonPcM7Qt3vlgfskNTeSMIsXMvCDOxOxZGm/ET7XCb
         lyXA==
X-Gm-Message-State: APjAAAU26/h1cw5C6aqxyGv5abr6cvzgpzmCmoYCK0TJ9wkUaEL8LyN8
        jpf06DLUKRb7op+yqVwUh6vNXSsV
X-Google-Smtp-Source: APXvYqyQRLsjU8IPf2yLXD+EpXFH0Fk8W4QNFcee9Qfy/ZIR0zjU3d1r+wskLrf49deo92GfFliKOg==
X-Received: by 2002:aa7:8815:: with SMTP id c21mr9309052pfo.66.1573190462848;
        Thu, 07 Nov 2019 21:21:02 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 3sm4206415pfh.45.2019.11.07.21.21.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 21:21:01 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        David Laight <david.laight@aculab.com>
Subject: [PATCHv4 net-next 2/5] sctp: add SCTP_ADDR_POTENTIALLY_FAILED notification
Date:   Fri,  8 Nov 2019 13:20:33 +0800
Message-Id: <7fa091e035b70859acbfd74ea06fcb3064c4bef7.1573190212.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <d008eb59f963118ae264e0151da79c382f16a69b.1573190212.git.lucien.xin@gmail.com>
References: <cover.1573190212.git.lucien.xin@gmail.com>
 <d008eb59f963118ae264e0151da79c382f16a69b.1573190212.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1573190212.git.lucien.xin@gmail.com>
References: <cover.1573190212.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SCTP Quick failover draft section 5.1, point 5 has been removed
from rfc7829. Instead, "the sender SHOULD (i) notify the Upper
Layer Protocol (ULP) about this state transition", as said in
section 3.2, point 8.

So this patch is to add SCTP_ADDR_POTENTIALLY_FAILED, defined
in section 7.1, "which is reported if the affected address
becomes PF". Also remove transport cwnd's update when moving
from PF back to ACTIVE , which is no longer in rfc7829 either.

Note that ulp_notify will be set to false if asoc->expose is
not 'enabled', according to last patch.

v2->v3:
  - define SCTP_ADDR_PF SCTP_ADDR_POTENTIALLY_FAILED.
v3->v4:
  - initialize spc_state with SCTP_ADDR_AVAILABLE, as Marcelo suggested.
  - check asoc->pf_expose in sctp_assoc_control_transport(), as Marcelo
    suggested.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 include/uapi/linux/sctp.h |  2 ++
 net/sctp/associola.c      | 32 ++++++++++++++------------------
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 765f41a..d99b428 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -410,6 +410,8 @@ enum sctp_spc_state {
 	SCTP_ADDR_ADDED,
 	SCTP_ADDR_MADE_PRIM,
 	SCTP_ADDR_CONFIRMED,
+	SCTP_ADDR_POTENTIALLY_FAILED,
+#define SCTP_ADDR_PF	SCTP_ADDR_POTENTIALLY_FAILED
 };
 
 
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 4cadff5..c183d0e 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -787,8 +787,8 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 				  enum sctp_transport_cmd command,
 				  sctp_sn_error_t error)
 {
+	int spc_state = SCTP_ADDR_AVAILABLE;
 	bool ulp_notify = true;
-	int spc_state = 0;
 
 	/* Record the transition on the transport.  */
 	switch (command) {
@@ -797,19 +797,13 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 		 * to heartbeat success, report the SCTP_ADDR_CONFIRMED
 		 * state to the user, otherwise report SCTP_ADDR_AVAILABLE.
 		 */
-		if (SCTP_UNCONFIRMED == transport->state &&
-		    SCTP_HEARTBEAT_SUCCESS == error)
-			spc_state = SCTP_ADDR_CONFIRMED;
-		else
-			spc_state = SCTP_ADDR_AVAILABLE;
-		/* Don't inform ULP about transition from PF to
-		 * active state and set cwnd to 1 MTU, see SCTP
-		 * Quick failover draft section 5.1, point 5
-		 */
-		if (transport->state == SCTP_PF) {
+		if (transport->state == SCTP_PF &&
+		    asoc->pf_expose != SCTP_PF_EXPOSE_ENABLE)
 			ulp_notify = false;
-			transport->cwnd = asoc->pathmtu;
-		}
+		else if (transport->state == SCTP_UNCONFIRMED &&
+			 error == SCTP_HEARTBEAT_SUCCESS)
+			spc_state = SCTP_ADDR_CONFIRMED;
+
 		transport->state = SCTP_ACTIVE;
 		break;
 
@@ -818,19 +812,21 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 		 * to inactive state.  Also, release the cached route since
 		 * there may be a better route next time.
 		 */
-		if (transport->state != SCTP_UNCONFIRMED)
+		if (transport->state != SCTP_UNCONFIRMED) {
 			transport->state = SCTP_INACTIVE;
-		else {
+			spc_state = SCTP_ADDR_UNREACHABLE;
+		} else {
 			sctp_transport_dst_release(transport);
 			ulp_notify = false;
 		}
-
-		spc_state = SCTP_ADDR_UNREACHABLE;
 		break;
 
 	case SCTP_TRANSPORT_PF:
 		transport->state = SCTP_PF;
-		ulp_notify = false;
+		if (asoc->pf_expose != SCTP_PF_EXPOSE_ENABLE)
+			ulp_notify = false;
+		else
+			spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
 		break;
 
 	default:
-- 
2.1.0

