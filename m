Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7454CF811
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730593AbfJHLZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:25:42 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36531 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729876AbfJHLZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:25:42 -0400
Received: by mail-pl1-f194.google.com with SMTP id j11so8346929plk.3;
        Tue, 08 Oct 2019 04:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=twG1cyvK47iKEufudzRjuhbJCcXhWSL3b3KdfTojLCA=;
        b=c3b7ngGFY0obsBf3NhVgq3o+1JukYVn5D5oAilYj8ydsUDpfZArRTJ258u6cRwcbI+
         lmlRVrTndmGuLxnyR3TRQTXOdzoQudshY8+X6AihlSEl8szbBtYKMUGlkvkOHew26EdN
         GpU9c13r02TUX4mA7pmV/vJ07k249BYpy9en3ebpzhN6W4u0eZb/pw9/4iYMGbi7RNNv
         Z7P6pei+2VNCJoEREOPdc1E7OuTGzXkoSUR/lNIPelGKcQ1GKHerrwm6jmMh9QSM9kzx
         bJ+IUWBmMgC1Elq1dJFAoqnPRXuSDMNufV95NMGt4U8sUKOUTMwVH4wQNPvF9qZpflWc
         3/hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=twG1cyvK47iKEufudzRjuhbJCcXhWSL3b3KdfTojLCA=;
        b=rjECRJpN0QXXt3IgDqFlnEzKeCJq7Ym9/V/ozGLFMGVsTpJRDZQQ0ZL+zUBm4VSmGH
         TEZaHwrqAOCLiG96o5U2pmQhmgXy1aTBFRou3Di+f7eFO1R46RZ8oh+ArtLMTNlgoSZK
         hTx6MnvUHVdeblqnZ6ZKSSYIf8L18u/tImKBMGIO+93XJtIeYdMKOqWkCAm4TP/TTcJk
         0gfIItfagEKYiH2EvxwiLer4aIXWjRF7zgHEJfh4hDYqHIh7SI/XBsc1+2D61JFnLPY8
         1vdKUi24kDZpk/bbIil3/Cz3ylQctxPME+pAMhmtWVBosJ4KqYaVdPks6YRgpiIfH9NF
         YDnw==
X-Gm-Message-State: APjAAAW7CS9Zg24Z1ZlGqxFgei1yLD3Y5UT3MIIQww0glzL81tvxG9BD
        yeiW43IWKSl9NbgT741DewHTuOd/
X-Google-Smtp-Source: APXvYqwyFWpIFFI9bKESggQhReGT/OwkNalqXhXAKyEabQUmam4s2R2klb/GxlikUs0m2HqyLUqxBQ==
X-Received: by 2002:a17:902:b7ca:: with SMTP id v10mr33002394plz.54.1570533940870;
        Tue, 08 Oct 2019 04:25:40 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e9sm14494650pgs.86.2019.10.08.04.25.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:25:40 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCHv2 net-next 3/5] sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
Date:   Tue,  8 Oct 2019 19:25:05 +0800
Message-Id: <066605f2269d5d92bc3fefebf33c6943579d8764.1570533716.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <8fcf707443f7218d3fb131b827c679f423c5ecaf.1570533716.git.lucien.xin@gmail.com>
References: <cover.1570533716.git.lucien.xin@gmail.com>
 <bca4cbf1bee8ad2379b2fe9536b3404fc0935579.1570533716.git.lucien.xin@gmail.com>
 <8fcf707443f7218d3fb131b827c679f423c5ecaf.1570533716.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1570533716.git.lucien.xin@gmail.com>
References: <cover.1570533716.git.lucien.xin@gmail.com>
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
index 8d27434..82faf78 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4589,6 +4589,37 @@ static int sctp_setsockopt_ecn_supported(struct sock *sk,
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
@@ -4798,6 +4829,9 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	case SCTP_ECN_SUPPORTED:
 		retval = sctp_setsockopt_ecn_supported(sk, optval, optlen);
 		break;
+	case SCTP_EXPOSE_POTENTIALLY_FAILED_STATE:
+		retval = sctp_setsockopt_pf_expose(sk, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -7908,6 +7942,45 @@ static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
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
@@ -8120,6 +8193,9 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
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

