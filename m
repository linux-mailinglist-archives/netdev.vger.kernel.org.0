Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30F0292740
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbgJSM0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgJSM0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:26:46 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27BAC0613CE;
        Mon, 19 Oct 2020 05:26:44 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gv6so5618475pjb.4;
        Mon, 19 Oct 2020 05:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=chT+1o8Xi621C2FvgvkILiU4uVhJ0TT4r54HGt7i2kM=;
        b=nj8W4RspfBpzQ1vCEEUOo4/d2zwdyms1ncUaR6YDjdQqFjucyPubIO8MVddEhmiDXi
         9RvBXgiep+i9woRc1DDi4H6m3uCcqPYiiSmMa/sH8Gn+Nc0U5vB95ZFA7fSMiKE8zxvD
         3qDSyAphFOpva6XznRwqvSGXfmHg5yiCSbZ6EhWIihFZcqw++Hnmp/PbK6fxgycBjvA/
         PBuoi+FBChYbUMX9jEb9sPDvcbXhFiQpyqHpXQ1YWR/m1M3b8HeHdOuy6FgocqmKDX2Y
         bIHIdSVsslqUWp0/WywUpIMGKor/IZCZP1XxzeUiQwbWU+IpjYbWCchmItKo4+38RMwn
         PN6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=chT+1o8Xi621C2FvgvkILiU4uVhJ0TT4r54HGt7i2kM=;
        b=RxiX1Bdbo9sXqV1HzYntf+IfYjWUHlFFDb5gJbeUsAjbCXwABlD7gOZDsL0a/B5mZ+
         FnkzEPNYL4pILB7V+QYv/L1QZD+mQJwFIeTSsjDD/1uS4gvb+bzTm701ZAW8xHDN2T63
         4yHEIwvr8VH+GPfiCxkibynXsmbQHbJCiptbQCSOeEvVdSNW3sGTNYm4/IT+uI+Wa2y4
         u1t2LBRio1tq8/p6Bz6LgtrvdsgC7ttI+OOIXV1vV/6qGjnDH1s9MZ2IqTcfD9PSJgJS
         KDcDUCKAxVN68peLl6G2KfKVexuYky4JBHFxfbJJzUiJRh2FKqSmBOPOzRKvKOqENd2w
         RgBA==
X-Gm-Message-State: AOAM531wZ2Wfm15JhjQMdv4QQAtEUsY6/fAvHJK8a3l0rKkDBgVshpRS
        8ohYHBnmaXiAUN/b9Fx5yLIxRgIVHgc=
X-Google-Smtp-Source: ABdhPJyzZm3DeEhOSaCeOCP67WT4GPhPbL+aa624VrwRaBwNOnhVf/R0UYhoEz0jyPAm3LILfuHfdQ==
X-Received: by 2002:a17:90a:5b05:: with SMTP id o5mr16908779pji.139.1603110404245;
        Mon, 19 Oct 2020 05:26:44 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n3sm11011432pgf.11.2020.10.19.05.26.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 05:26:43 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv4 net-next 08/16] sctp: add SCTP_REMOTE_UDP_ENCAPS_PORT sockopt
Date:   Mon, 19 Oct 2020 20:25:25 +0800
Message-Id: <25013493737f5b488ce48c38667a077ca6573dd5.1603110316.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <d55a0eaefa4b8a671e54535a1899ea4c00bc2de8.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
 <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
 <5f06ac649f4b63fc5a254812a963cada3183f136.1603110316.git.lucien.xin@gmail.com>
 <e99845af51be8fdaa53a2575e8967b8c3c8d423a.1603110316.git.lucien.xin@gmail.com>
 <7a2f5792c1a428c16962fff08b7bcfedc21bd5e2.1603110316.git.lucien.xin@gmail.com>
 <7cfd72e42b8b1cde268ad4062c96c08a56c4b14f.1603110316.git.lucien.xin@gmail.com>
 <d55a0eaefa4b8a671e54535a1899ea4c00bc2de8.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to implement:

  rfc6951#section-6.1: Get or Set the Remote UDP Encapsulation Port Number

with the param of the struct:

  struct sctp_udpencaps {
    sctp_assoc_t sue_assoc_id;
    struct sockaddr_storage sue_address;
    uint16_t sue_port;
  };

the encap_port of sock, assoc or transport can be changed by users,
which also means it allows the different transports of the same asoc
to have different encap_port value.

v1->v2:
  - no change.
v2->v3:
  - fix the endian warning when setting values between encap_port and
    sue_port.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |   7 +++
 net/sctp/socket.c         | 114 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 28ad40d..cb78e7a 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -140,6 +140,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_ECN_SUPPORTED	130
 #define SCTP_EXPOSE_POTENTIALLY_FAILED_STATE	131
 #define SCTP_EXPOSE_PF_STATE	SCTP_EXPOSE_POTENTIALLY_FAILED_STATE
+#define SCTP_REMOTE_UDP_ENCAPS_PORT	132
 
 /* PR-SCTP policies */
 #define SCTP_PR_SCTP_NONE	0x0000
@@ -1197,6 +1198,12 @@ struct sctp_event {
 	uint8_t se_on;
 };
 
+struct sctp_udpencaps {
+	sctp_assoc_t sue_assoc_id;
+	struct sockaddr_storage sue_address;
+	uint16_t sue_port;
+};
+
 /* SCTP Stream schedulers */
 enum sctp_sched_type {
 	SCTP_SS_FCFS,
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 09b94cd..2a9ee9b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4417,6 +4417,55 @@ static int sctp_setsockopt_pf_expose(struct sock *sk,
 	return retval;
 }
 
+static int sctp_setsockopt_encap_port(struct sock *sk,
+				      struct sctp_udpencaps *encap,
+				      unsigned int optlen)
+{
+	struct sctp_association *asoc;
+	struct sctp_transport *t;
+	__be16 encap_port;
+
+	if (optlen != sizeof(*encap))
+		return -EINVAL;
+
+	/* If an address other than INADDR_ANY is specified, and
+	 * no transport is found, then the request is invalid.
+	 */
+	encap_port = (__force __be16)encap->sue_port;
+	if (!sctp_is_any(sk, (union sctp_addr *)&encap->sue_address)) {
+		t = sctp_addr_id2transport(sk, &encap->sue_address,
+					   encap->sue_assoc_id);
+		if (!t)
+			return -EINVAL;
+
+		t->encap_port = encap_port;
+		return 0;
+	}
+
+	/* Get association, if assoc_id != SCTP_FUTURE_ASSOC and the
+	 * socket is a one to many style socket, and an association
+	 * was not found, then the id was invalid.
+	 */
+	asoc = sctp_id2assoc(sk, encap->sue_assoc_id);
+	if (!asoc && encap->sue_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
+
+	/* If changes are for association, also apply encap_port to
+	 * each transport.
+	 */
+	if (asoc) {
+		list_for_each_entry(t, &asoc->peer.transport_addr_list,
+				    transports)
+			t->encap_port = encap_port;
+
+		return 0;
+	}
+
+	sctp_sk(sk)->encap_port = encap_port;
+	return 0;
+}
+
 /* API 6.2 setsockopt(), getsockopt()
  *
  * Applications use setsockopt() and getsockopt() to set or retrieve
@@ -4636,6 +4685,9 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	case SCTP_EXPOSE_POTENTIALLY_FAILED_STATE:
 		retval = sctp_setsockopt_pf_expose(sk, kopt, optlen);
 		break;
+	case SCTP_REMOTE_UDP_ENCAPS_PORT:
+		retval = sctp_setsockopt_encap_port(sk, kopt, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -7791,6 +7843,65 @@ static int sctp_getsockopt_pf_expose(struct sock *sk, int len,
 	return retval;
 }
 
+static int sctp_getsockopt_encap_port(struct sock *sk, int len,
+				      char __user *optval, int __user *optlen)
+{
+	struct sctp_association *asoc;
+	struct sctp_udpencaps encap;
+	struct sctp_transport *t;
+	__be16 encap_port;
+
+	if (len < sizeof(encap))
+		return -EINVAL;
+
+	len = sizeof(encap);
+	if (copy_from_user(&encap, optval, len))
+		return -EFAULT;
+
+	/* If an address other than INADDR_ANY is specified, and
+	 * no transport is found, then the request is invalid.
+	 */
+	if (!sctp_is_any(sk, (union sctp_addr *)&encap.sue_address)) {
+		t = sctp_addr_id2transport(sk, &encap.sue_address,
+					   encap.sue_assoc_id);
+		if (!t) {
+			pr_debug("%s: failed no transport\n", __func__);
+			return -EINVAL;
+		}
+
+		encap_port = t->encap_port;
+		goto out;
+	}
+
+	/* Get association, if assoc_id != SCTP_FUTURE_ASSOC and the
+	 * socket is a one to many style socket, and an association
+	 * was not found, then the id was invalid.
+	 */
+	asoc = sctp_id2assoc(sk, encap.sue_assoc_id);
+	if (!asoc && encap.sue_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP)) {
+		pr_debug("%s: failed no association\n", __func__);
+		return -EINVAL;
+	}
+
+	if (asoc) {
+		encap_port = asoc->encap_port;
+		goto out;
+	}
+
+	encap_port = sctp_sk(sk)->encap_port;
+
+out:
+	encap.sue_port = (__force uint16_t)encap_port;
+	if (copy_to_user(optval, &encap, len))
+		return -EFAULT;
+
+	if (put_user(len, optlen))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int sctp_getsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, int __user *optlen)
 {
@@ -8011,6 +8122,9 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 	case SCTP_EXPOSE_POTENTIALLY_FAILED_STATE:
 		retval = sctp_getsockopt_pf_expose(sk, len, optval, optlen);
 		break;
+	case SCTP_REMOTE_UDP_ENCAPS_PORT:
+		retval = sctp_getsockopt_encap_port(sk, len, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
-- 
2.1.0

