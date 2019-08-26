Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A053D9CB8F
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 10:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbfHZIaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 04:30:39 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34197 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730584AbfHZIai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 04:30:38 -0400
Received: by mail-pl1-f194.google.com with SMTP id d3so9685809plr.1;
        Mon, 26 Aug 2019 01:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=JRsVxBw/DVio/9HSo900YqBc9DY+dT+2pQwP96+BTuc=;
        b=FbKOlqFAbVQ5+KTj1oWFGglUbf3XhmLhyge0xGGcP1Sik4SoeXBQvHbyKI8Wb5o5gV
         cW+KjhG9NyBF4//YEEhQtp7CVJ5UNwvsRd5INiTYXGMsM7hGdMTOiBbKKvcjNGPHfMkD
         Sx3Am90MJHvrTOsrZ/3rU9Oa8Cklf8u+eVnkPRYZTRmnhufh22EOE6X9lv6+gWPzDBgP
         fr0c7MBr9BhxnOBxUfvb4oCVoM+4ezdh9739p2+7P8YP4HRkR/0JEMkDdisWGx95RLW7
         tPXGXBAngQcfErQy92dWX1B/nE8LV7bbqIJu9guc5mtkrpMwe35UC5LiIbxgeLcG93rB
         W4dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=JRsVxBw/DVio/9HSo900YqBc9DY+dT+2pQwP96+BTuc=;
        b=edFyTamwxnphwwZuCDZD+bAS2Jrq9vOKEIwW5mBHAWy88It/1MYVefRkzQIjPILYhu
         QMMTd5DNKFbseCQuu2jIpWy9sz9A8AwGWi2qLnqkibVzYaFJniBP21XwlfDAvv9avWoh
         aR9bIkqQS4QyZagsLjgzM/Fs0UaZeQYRR36NctISPhWPiAB+jds4iZd57DjYMStbIBTS
         el9fa4hqQHpuTkXUMlfsBkVB+EHhx/0Iatugj7/NYbPswXkQQNAnHSj/Mno6mghKv5uO
         yh9QS5m1VdkHP60gA75buGl83o6LyHiNGDYMUxOc2k9BA/D/gI8dKzoZdSalBI3ulaSQ
         GOCw==
X-Gm-Message-State: APjAAAXj85VTAnOdWOPOYUoMH5GiwsCW4eNKN4zfMZrg9sqsKfe8rlzy
        Kc18Cou4BIMpOr5ekD2Hrz1ayvnkrRU=
X-Google-Smtp-Source: APXvYqwQkQX3Fce2+IalIS14AaW9QGashF81JOlsX6ESJRJ6lp8zMs/rZDMNBvneDgX1BqXZy4qkew==
X-Received: by 2002:a17:902:b082:: with SMTP id p2mr8035972plr.275.1566808237990;
        Mon, 26 Aug 2019 01:30:37 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r23sm12586015pfg.10.2019.08.26.01.30.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 01:30:37 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 3/3] sctp: allow users to set ep ecn flag by sockopt
Date:   Mon, 26 Aug 2019 16:30:04 +0800
Message-Id: <58415590c2640149d56ae2db35f6d6ffd126aed3.1566807985.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <fdbf487b2e1b255b1bbf457b3112979c33b53066.1566807985.git.lucien.xin@gmail.com>
References: <cover.1566807985.git.lucien.xin@gmail.com>
 <fc26e1e3bd1579a944320dc54d5cdbdec46ac61d.1566807985.git.lucien.xin@gmail.com>
 <fdbf487b2e1b255b1bbf457b3112979c33b53066.1566807985.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1566807985.git.lucien.xin@gmail.com>
References: <cover.1566807985.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SCTP_ECN_SUPPORTED sockopt will be added to allow users to change
ep ecn flag, and it's similar with other feature flags.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |  1 +
 net/sctp/socket.c         | 73 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 62527ac..6d5b164 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -136,6 +136,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_EVENT	127
 #define SCTP_ASCONF_SUPPORTED	128
 #define SCTP_AUTH_SUPPORTED	129
+#define SCTP_ECN_SUPPORTED	130
 
 /* PR-SCTP policies */
 #define SCTP_PR_SCTP_NONE	0x0000
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 82bc252..3e50a97 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4560,6 +4560,34 @@ static int sctp_setsockopt_auth_supported(struct sock *sk,
 	return retval;
 }
 
+static int sctp_setsockopt_ecn_supported(struct sock *sk,
+					 char __user *optval,
+					 unsigned int optlen)
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
+	sctp_sk(sk)->ep->ecn_enable = !!params.assoc_value;
+	retval = 0;
+
+out:
+	return retval;
+}
+
 /* API 6.2 setsockopt(), getsockopt()
  *
  * Applications use setsockopt() and getsockopt() to set or retrieve
@@ -4766,6 +4794,9 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	case SCTP_AUTH_SUPPORTED:
 		retval = sctp_setsockopt_auth_supported(sk, optval, optlen);
 		break;
+	case SCTP_ECN_SUPPORTED:
+		retval = sctp_setsockopt_ecn_supported(sk, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -7828,6 +7859,45 @@ static int sctp_getsockopt_auth_supported(struct sock *sk, int len,
 	return retval;
 }
 
+static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
+					 char __user *optval,
+					 int __user *optlen)
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
+	params.assoc_value = asoc ? asoc->peer.ecn_capable
+				  : sctp_sk(sk)->ep->ecn_enable;
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
@@ -8037,6 +8107,9 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_getsockopt_auth_supported(sk, len, optval,
 							optlen);
 		break;
+	case SCTP_ECN_SUPPORTED:
+		retval = sctp_getsockopt_ecn_supported(sk, len, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
-- 
2.1.0

