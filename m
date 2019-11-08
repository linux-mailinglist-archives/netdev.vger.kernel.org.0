Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA4FF3FB8
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 06:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbfKHFVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 00:21:14 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34806 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbfKHFVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 00:21:13 -0500
Received: by mail-pf1-f194.google.com with SMTP id n13so3912205pff.1;
        Thu, 07 Nov 2019 21:21:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=mwQ+SJNKxBfvJ+6pAWzpERZnLoFCvCVSB6GvO3x3n+g=;
        b=H74D/DqVBEp7zuQsnsl5g38yhsgVx6gE9+XepXAdx+2GyfSdsLDVID7wq0xIAGvKG4
         FeNLlDnQhALY/7ik2lcQz61qocQ/rgo/KKxarKqlHaNLOyqPajEbEycDNT9TzGii/BJh
         tUumzGXYLKit0hSme46Ei+sMApoxxCU3WHh7fMVm4GnX0+TEpyj/CEvG5X0p+gENYFpp
         PiV/1iJJf5ffZDiVcYqZAIgFawGjmdhL4upnyqUQYH9v0h8PL+jAy95qn43R2mkPx+J8
         4A8Siy7Vaedn+3ilzY4HFxizd2i/rEmwCtgNSBwh10Mey3/NgCmcMpFjC0TXn3XfKAVr
         5RvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=mwQ+SJNKxBfvJ+6pAWzpERZnLoFCvCVSB6GvO3x3n+g=;
        b=JS/BsxEvv/lC7kzT2eHCB7BTOoVLMyROx9S2LjyF8Gnvyi+iAERNIw2PVdXApUwOK/
         aj3DocDcxghbmdECLUwB/3M0tgSLP5ZRnC8EsIZea3IIjnvG1JkW5RmuQr2H0TvGHz8R
         rnRO0sPBb5x4AvuZ9EQyz2W/TpYjsgVGWkZjN2ekET3gE60LAh+UadYVHzVha23+1nYr
         5BJ1iOp8Beabla23Mkdhn1kk/IAs7sGN05U1LnDQfUYhz5ALK+vkFXA6rNJ/93V29WZx
         q9NL/qOHX5AKzZeuhtRpLH0pMXQKWhkPFZKpVArw4GIYAOB2pL4qZunQpmds/FhHS1fn
         hNWQ==
X-Gm-Message-State: APjAAAX4UDnhhb0MzEvFZEAA9fZSbz7Qt5f/r9ZiZWnQjh6QoHMfOWAO
        lMJi7e3bVgfBHx+YN4g2swOCxNWb
X-Google-Smtp-Source: APXvYqxoJ7abfhb+LjMDM4y2Dw7XSpU5B4j8xDKzHntWnpBX9lgU5lbQV1c/Jsll1YtndWBYt6GIdw==
X-Received: by 2002:a63:b644:: with SMTP id v4mr9391083pgt.249.1573190471525;
        Thu, 07 Nov 2019 21:21:11 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h6sm3566546pji.21.2019.11.07.21.21.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 21:21:10 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        David Laight <david.laight@aculab.com>
Subject: [PATCHv4 net-next 3/5] sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
Date:   Fri,  8 Nov 2019 13:20:34 +0800
Message-Id: <45e03c4050ed2f122b6a4e19ebd6a532087088d3.1573190212.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <7fa091e035b70859acbfd74ea06fcb3064c4bef7.1573190212.git.lucien.xin@gmail.com>
References: <cover.1573190212.git.lucien.xin@gmail.com>
 <d008eb59f963118ae264e0151da79c382f16a69b.1573190212.git.lucien.xin@gmail.com>
 <7fa091e035b70859acbfd74ea06fcb3064c4bef7.1573190212.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1573190212.git.lucien.xin@gmail.com>
References: <cover.1573190212.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a sockopt defined in section 7.3 of rfc7829: "Exposing
the Potentially Failed Path State", by which users can change
pf_expose per sock and asoc.

The new sockopt SCTP_EXPOSE_POTENTIALLY_FAILED_STATE is also
known as SCTP_EXPOSE_PF_STATE for short.

v2->v3:
  - return -EINVAL if params.assoc_value > SCTP_PF_EXPOSE_MAX.
  - define SCTP_EXPOSE_PF_STATE SCTP_EXPOSE_POTENTIALLY_FAILED_STATE.
v3->v4:
  - improve changelog.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
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

