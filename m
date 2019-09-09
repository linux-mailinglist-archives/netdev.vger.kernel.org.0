Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD1F5AD450
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 09:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388113AbfIIH5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 03:57:25 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43097 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfIIH5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 03:57:25 -0400
Received: by mail-pf1-f196.google.com with SMTP id d15so8621488pfo.10;
        Mon, 09 Sep 2019 00:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=VyLo37PMLM1qAhDgQKxiCr1O2Od/TJyN3y8hToD1KgA=;
        b=UZ0vrSfqQ32a7XxmxkvNPapMkETlrpIcrxQmIEjJ8NiFBwTCscn/DsiI0vKJFhmWHJ
         YlniAwkLNCl+bwl3pb0zXDzE+chC8Be9EZxH7r5VTnTgj0GRDFMTT7a9n/IJSTTH+iqa
         7RA3wjHX9SL2gbIUuNcoSqgAF5B81bXCqqQZ6M12Ws4jyq8jyZ/nvk2MkKasTDCwr4gV
         o5MsntCZxzxzfgHpa3banczRmxmBp17YBjUr4jT1ZU7ejllz3xoYIbMZIKmSgpLwRI0F
         BzmD3DC+WiIhW5XjGmEBtoHYh1bP/y1ZeyJjwbxnae1gF9gEHFsNneQO1be8mfzFqd7r
         xkpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=VyLo37PMLM1qAhDgQKxiCr1O2Od/TJyN3y8hToD1KgA=;
        b=QD8p9dZILbqeXb6QfzdwXvFVVk7tDu9eophAMoiK0dR8vXUV7p+J4u1MMothhJpceI
         gXR0WJagLHC5bKjQG9KJOeev9qYAJNnz6/C+MPPv6RZYMYYyCrGDyzVrRqJHwnx6Fi1I
         aU3FRHinBGyZYxuKrxNr8trNklK1bh2oNOdNiCOaQ5rJTugTlHAhcZ0Lm3yGKELlwJ3x
         0Rc0rd+Wa2xQJtFK3qb1U1crelshM3B3M/nAni2oAB+bpPNS+aQKvKb7P2X54062cv0z
         4Hgqq3KCy0jua4sDg0QFlEcXWM2GE6WRuun5N5bdGA7ZLW+ZxPbqW8DLd8ouJs050EY8
         ZbwQ==
X-Gm-Message-State: APjAAAWH52nxhkU3FNcwREBoKExa8woKEeO85WTrDWwUEJGSdOYQXSd3
        15hc5sK+zZHwutdWzWwNkiisWom4TP0=
X-Google-Smtp-Source: APXvYqxzayotPx7yaFqckMDGZXr2E2pz9dnXcg6N4bRpx1IuqpayBcrezue1Uj7Pt5k5/m5BJ1Bi9A==
X-Received: by 2002:a17:90a:3524:: with SMTP id q33mr23199612pjb.37.1568015844027;
        Mon, 09 Sep 2019 00:57:24 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a13sm20221596pfg.10.2019.09.09.00.57.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 00:57:23 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 3/5] sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
Date:   Mon,  9 Sep 2019 15:56:49 +0800
Message-Id: <4836d0d8bb96e807b63f46e6c59af78b9b3e286b.1568015756.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <00fb06e74d8eedeb033dad83de18380bf6261231.1568015756.git.lucien.xin@gmail.com>
References: <cover.1568015756.git.lucien.xin@gmail.com>
 <b486e6b5e434f8fd2462addc81916d83b5a31707.1568015756.git.lucien.xin@gmail.com>
 <00fb06e74d8eedeb033dad83de18380bf6261231.1568015756.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1568015756.git.lucien.xin@gmail.com>
References: <cover.1568015756.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a sockopt defined in section 7.3 of rfc7829: "Exposing
the Potentially Failed Path State", by which users can change
pf_expose per sock and asoc.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |  1 +
 net/sctp/socket.c         | 76 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index b6649d6..a15cc28 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -137,6 +137,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_ASCONF_SUPPORTED	128
 #define SCTP_AUTH_SUPPORTED	129
 #define SCTP_ECN_SUPPORTED	130
+#define SCTP_EXPOSE_POTENTIALLY_FAILED_STATE	131
 
 /* PR-SCTP policies */
 #define SCTP_PR_SCTP_NONE	0x0000
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 33b93bb..e3a8e25 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4588,6 +4588,37 @@ static int sctp_setsockopt_ecn_supported(struct sock *sk,
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
+	asoc = sctp_id2assoc(sk, params.assoc_id);
+	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		goto out;
+
+	if (asoc)
+		asoc->pf_expose = !!params.assoc_value;
+	else
+		sctp_sk(sk)->pf_expose = !!params.assoc_value;
+	retval = 0;
+
+out:
+	return retval;
+}
+
 /* API 6.2 setsockopt(), getsockopt()
  *
  * Applications use setsockopt() and getsockopt() to set or retrieve
@@ -4797,6 +4828,9 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	case SCTP_ECN_SUPPORTED:
 		retval = sctp_setsockopt_ecn_supported(sk, optval, optlen);
 		break;
+	case SCTP_EXPOSE_POTENTIALLY_FAILED_STATE:
+		retval = sctp_setsockopt_pf_expose(sk, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -7906,6 +7940,45 @@ static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
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
@@ -8118,6 +8191,9 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
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

