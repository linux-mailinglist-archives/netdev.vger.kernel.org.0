Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C3EAD44B
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 09:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbfIIH5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 03:57:08 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40706 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfIIH5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 03:57:08 -0400
Received: by mail-pf1-f193.google.com with SMTP id x127so8634257pfb.7;
        Mon, 09 Sep 2019 00:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=AB1k581sdOY84l1zHfQqHfAjO9h11FT8EGrtEeXje6o=;
        b=G9uddwHDDhbCVbWeAWDo2r94iJT2fq6KMqBKhb1HxfBZ+8EO5HZks3YKbO1dXYQghK
         H3i3w9J7rXJuZtPl1z4BlKPhxkTnf6Wc5qsCCz7p3VyM1gm8O5sOKNYyWDA4Tufs324C
         /C/0CV6BAQhyouWAk+0eE/6gAIUopt5CMIAovsiE3aQO3qRJfUc5RlwBxkH3eM2l3i8w
         LXbKvzeXXM86vrkd6Rucy1cjBlnDV4eS/On6WbqjB2XIDks8H+ZSrhnmyPxsGqDQC7DA
         NGZMQlEK55yZg1bkVGAg5ru4yba8SQ45CihiBysyIozjVfPFYvukhr3WXGb4Ygb837Kc
         7yDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=AB1k581sdOY84l1zHfQqHfAjO9h11FT8EGrtEeXje6o=;
        b=L1WYUl72vCeMkn99MRVq4qa1CxMvjo13id45+Oi36CzzeUpNeH1YjxCNI4vFcftU0i
         hymziom0zRjMNVvPZ6VCKknObP7Ts8xaROv/vxPMnB4i+1WtW8EPWL1uZzwo2WeORujA
         IeX/ymCf9Zq18pxwVzd06QFkVA0eVTKf7ub6OZixO8PwRdGaAHYj9o1PJZ1Y4CIlnjAU
         u8kMtppjc/6EaRW9Y6IGb2DKUnuycGSOkbSNGahbWj51tFL6FzdHWbtm2fIFn+NFp1Ri
         +d5irt8DAEB/Z/l+SOgdptpIHcyLn32cZ7c8hZpiDhrxJo2pDkRHu/1HARUre2FXV4r+
         s9uA==
X-Gm-Message-State: APjAAAXTRwBSjJGXspLAlzEI4b4vKLeD3MaWTW/VmXwaYyBqhkMiCIuk
        cZk4aD2qVPvJNybqR5DAfiYZAcohSW4=
X-Google-Smtp-Source: APXvYqytx11GD4VKIgE0UViQzMp30vuyxK9KFuGs61RgRwNVkePaj8yxmfynJy5k7K4DAvJHmHCJrw==
X-Received: by 2002:a63:40a:: with SMTP id 10mr20776507pge.317.1568015827490;
        Mon, 09 Sep 2019 00:57:07 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q22sm12705652pgh.49.2019.09.09.00.57.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 00:57:06 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 1/5] sctp: add SCTP_ADDR_POTENTIALLY_FAILED notification
Date:   Mon,  9 Sep 2019 15:56:47 +0800
Message-Id: <b486e6b5e434f8fd2462addc81916d83b5a31707.1568015756.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1568015756.git.lucien.xin@gmail.com>
References: <cover.1568015756.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1568015756.git.lucien.xin@gmail.com>
References: <cover.1568015756.git.lucien.xin@gmail.com>
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

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |  1 +
 net/sctp/associola.c      | 17 ++++-------------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 6d5b164..45a85d7 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -410,6 +410,7 @@ enum sctp_spc_state {
 	SCTP_ADDR_ADDED,
 	SCTP_ADDR_MADE_PRIM,
 	SCTP_ADDR_CONFIRMED,
+	SCTP_ADDR_POTENTIALLY_FAILED,
 };
 
 
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index d2ffc9a..7278b7e 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -798,14 +798,6 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 			spc_state = SCTP_ADDR_CONFIRMED;
 		else
 			spc_state = SCTP_ADDR_AVAILABLE;
-		/* Don't inform ULP about transition from PF to
-		 * active state and set cwnd to 1 MTU, see SCTP
-		 * Quick failover draft section 5.1, point 5
-		 */
-		if (transport->state == SCTP_PF) {
-			ulp_notify = false;
-			transport->cwnd = asoc->pathmtu;
-		}
 		transport->state = SCTP_ACTIVE;
 		break;
 
@@ -814,19 +806,18 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
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
+		spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
 		break;
 
 	default:
-- 
2.1.0

