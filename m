Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A212AD5B1F
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 08:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbfJNGPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 02:15:24 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34102 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfJNGPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 02:15:23 -0400
Received: by mail-pf1-f193.google.com with SMTP id b128so9791994pfa.1;
        Sun, 13 Oct 2019 23:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=mwAHr1oFlcsS1hpG7CrZRy6Yk35ew3XwGC81T1iGfT8=;
        b=MP1d1nIYbNV6ecHjUtxl4E9A3Iq4LhlvoSptDlt7Zg0mZx46ecZUOe5VZ8wOWO/VY5
         vQpktTjeSDCdCiFa7XqNqE2YkkulYOjmulxKAdgDtkqHvZ35PLAqsoON0eVWYe5xwHNn
         +KJb/taETtnZtzQyS6RajeYvgXN9nqOC9qnK2y5buKgKNoUSVR3J8OnMfIBLP0f08iFu
         DocTSx9r7VLnBCRyDIR1VszSMLTZO1H7F3ksNGPN8wMeajd+taSO+6OD1ZJKSmLczfdb
         pjvZMflTEq+GubFw69eHbQ64FVaCyWa04yuDRjXelgWlnscbmAPzmFihMvHT4BL964y6
         HDBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=mwAHr1oFlcsS1hpG7CrZRy6Yk35ew3XwGC81T1iGfT8=;
        b=EgP/baj4JZhD06nw+QSLK2ePBmnewfYS4wOSEuwJ7ESAT+Vv2SKBqouhDCY2ZzTmE3
         iwaLKwyi/BHvsE5PsjaggzSNvNVKjniKwjM3RsKsnCqs/ZsTz753sgcNHPwhGUuhp653
         iDCl8Ylpcocbe/S2QUh5Mwe0G4N8inMOOxrrfmj/k6k0NTtMKjQrJw6rgtkC2r5WSaTm
         ju6pAK/K9NHmoWIXMcCvZfM0oW9h5iWr4zEDGiMQvRzk3BqGnQQTsxVANqQBu9veVfel
         mqS87plO9b00qNk0D3QnHddqS4hqmoCrEv5dXcvMRq16s6+hsdeELrMKErKvo3T5wARh
         mMwg==
X-Gm-Message-State: APjAAAW9EeyI8+DHSuys9Vy05Jo14gc11n/X9m1yoLbIM4/0AdQynnC5
        DLV4ZlccXMF65YCi13yX0A/uYCqj
X-Google-Smtp-Source: APXvYqzkYhBzrPLiHJryXOLdO/+IAkgpUEceT/sVPtlYe4xVkTGQxFXb9G8pZ2cCq+OrQddqnFddyw==
X-Received: by 2002:a65:62d2:: with SMTP id m18mr30942106pgv.117.1571033722422;
        Sun, 13 Oct 2019 23:15:22 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i74sm16969514pfe.28.2019.10.13.23.15.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Oct 2019 23:15:21 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        David Laight <david.laight@aculab.com>
Subject: [PATCHv3 net-next 3/5] sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
Date:   Mon, 14 Oct 2019 14:14:46 +0800
Message-Id: <eedcaeabec9253902de381b75ffc00c007fcd2b6.1571033544.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <f4c99c3d918c0d82f5d5c60abd6abcf381292f1f.1571033544.git.lucien.xin@gmail.com>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
 <f4c99c3d918c0d82f5d5c60abd6abcf381292f1f.1571033544.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1571033544.git.lucien.xin@gmail.com>
References: <cover.1571033544.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a sockopt defined in section 7.3 of rfc7829: "Exposing
the Potentially Failed Path State", by which users can change
pf_expose per sock and asoc.

v1->v2:
  - no change.
v2->v3:
  - return -EINVAL if params.assoc_value > SCTP_PF_EXPOSE_MAX.
  - define SCTP_EXPOSE_PF_STATE SCTP_EXPOSE_POTENTIALLY_FAILED_STATE.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |  2 ++
 net/sctp/socket.c         | 79 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index d99b428..a190e4a 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -137,6 +137,8 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_ASCONF_SUPPORTED	128
 #define SCTP_AUTH_SUPPORTED	129
 #define SCTP_ECN_SUPPORTED	130
+#define SCTP_EXPOSE_POTENTIALLY_FAILED_STATE	131
+#define SCTP_EXPOSE_PF_STATE	SCTP_EXPOSE_POTENTIALLY_FAILED_STATE
 
 /* PR-SCTP policies */
 #define SCTP_PR_SCTP_NONE	0x0000
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 669e02e..eccd689 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4589,6 +4589,40 @@ static int sctp_setsockopt_ecn_supported(struct sock *sk,
 	return retval;
 }
 
+static int sctp_setsockopt_pf_expose(struct sock *sk,
+				     char __user *optval,
+				     unsigned int optlen)
+{
+	struct sctp_assoc_value params;
+	struct sctp_association *asoc;
+	int retval = -EINVAL;
+
+	if (optlen != sizeof(params))
+		goto out;
+
+	if (copy_from_user(&params, optval, optlen)) {
+		retval = -EFAULT;
+		goto out;
+	}
+
+	if (params.assoc_value > SCTP_PF_EXPOSE_MAX)
+		goto out;
+
+	asoc = sctp_id2assoc(sk, params.assoc_id);
+	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		goto out;
+
+	if (asoc)
+		asoc->pf_expose = params.assoc_value;
+	else
+		sctp_sk(sk)->pf_expose = params.assoc_value;
+	retval = 0;
+
+out:
+	return retval;
+}
+
 /* API 6.2 setsockopt(), getsockopt()
  *
  * Applications use setsockopt() and getsockopt() to set or retrieve
@@ -4798,6 +4832,9 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	case SCTP_ECN_SUPPORTED:
 		retval = sctp_setsockopt_ecn_supported(sk, optval, optlen);
 		break;
+	case SCTP_EXPOSE_POTENTIALLY_FAILED_STATE:
+		retval = sctp_setsockopt_pf_expose(sk, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -7909,6 +7946,45 @@ static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
 	return retval;
 }
 
+static int sctp_getsockopt_pf_expose(struct sock *sk, int len,
+				     char __user *optval,
+				     int __user *optlen)
+{
+	struct sctp_assoc_value params;
+	struct sctp_association *asoc;
+	int retval = -EFAULT;
+
+	if (len < sizeof(params)) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	len = sizeof(params);
+	if (copy_from_user(&params, optval, len))
+		goto out;
+
+	asoc = sctp_id2assoc(sk, params.assoc_id);
+	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP)) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	params.assoc_value = asoc ? asoc->pf_expose
+				  : sctp_sk(sk)->pf_expose;
+
+	if (put_user(len, optlen))
+		goto out;
+
+	if (copy_to_user(optval, &params, len))
+		goto out;
+
+	retval = 0;
+
+out:
+	return retval;
+}
+
 static int sctp_getsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, int __user *optlen)
 {
@@ -8121,6 +8197,9 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 	case SCTP_ECN_SUPPORTED:
 		retval = sctp_getsockopt_ecn_supported(sk, len, optval, optlen);
 		break;
+	case SCTP_EXPOSE_POTENTIALLY_FAILED_STATE:
+		retval = sctp_getsockopt_pf_expose(sk, len, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
-- 
2.1.0

