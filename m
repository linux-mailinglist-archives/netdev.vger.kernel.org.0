Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C5D28C94A
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 09:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390210AbgJMH2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 03:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390091AbgJMH2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 03:28:53 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1DBC0613D0;
        Tue, 13 Oct 2020 00:28:53 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id az3so1606082pjb.4;
        Tue, 13 Oct 2020 00:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=wwbKI6c2NhmZswtibscSDsBNiITsh3tYCdze/In9x0Q=;
        b=GyZtOc5Dnkr4/j76CWXU42TPYkJ0TrxdILPv1y2wOWdHVf47ZQeuOr/Fc1tOUNx57O
         YB7eERo2Ogg7DGkWPnW5Mi+HUqPZSi+NwqMwrYQRrkVL1N+L/Xurdtbw4GE7L263C5R/
         Upgq5HtWZjVSBPRSxVp7iraWsZjS8gLt7PbitEGGmCMUkInfAadxX+Rr4QwR/euVR60k
         TfGwRrjBMvpoA6TktlwwEdny8SiwxmDu9wf7vS02w14NJtoqYKVmpnNqxA72TiKT2ctE
         OR2EMqURNGwG3wmumv7Ccjx+Y6FQlLBat40ilmDbOxLahIsQ1wIcyvcVytcGZD8orGWU
         CtCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=wwbKI6c2NhmZswtibscSDsBNiITsh3tYCdze/In9x0Q=;
        b=CFxGOhnT8eLrIHvIRwmRpFsJmc30DQ7Y79Am1x8Avx4mLBSSYDI/qPITDD13UJAfNW
         LPV/ySNsylUvWD2UZEmrr4cGrc8QSc529lpEETruIf6SvA5ADXtxGMJOFoU/lSHg7WKU
         wrnaSx9QgP5yP4GNXIG7BQGaN/hLiEYl0F9ofMH27WtMYic4CHlYgGZ72aLK1bc/NlBp
         PqXI+mRls5EkB8yu6cYFQ6pqrha4eCqC+Q1bb1c+F4Wr8XgmmqR2rCWwawyHV5Lvi8F7
         R2BaZ6S4BpYNIRHsg4gGer2FwGhPi6URvZmUmThRaR0x00s7GkuyzQ70sKgSOxku/WBu
         /vzg==
X-Gm-Message-State: AOAM531doMt9f96f360hLIZEiqOgHzu2kQPKISmYndnGVPNhQxDQyFYJ
        qJ53jtIDSBH4wz1uF4RHZAdcDo7ZCW4=
X-Google-Smtp-Source: ABdhPJy+vcKB4cpuKkzzjSMeSDeQ7eWCdWNQTarBMN2XeI9WjIVVUuD5D4rNw1nELsC3Nx8rs8zK/g==
X-Received: by 2002:a17:90b:3314:: with SMTP id kf20mr24653234pjb.19.1602574132222;
        Tue, 13 Oct 2020 00:28:52 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id fa12sm17854277pjb.25.2020.10.13.00.28.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 00:28:51 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv3 net-next 08/16] sctp: add SCTP_REMOTE_UDP_ENCAPS_PORT sockopt
Date:   Tue, 13 Oct 2020 15:27:33 +0800
Message-Id: <08854ecf72eee34d3e98e30def6940d94f97fdef.1602574012.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <37e9f70ffb9dea1572025b8e1c4b1f1c6e6b3da5.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
 <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
 <dbad21ff524e119f83ae4444d1ae393ab165fa7c.1602574012.git.lucien.xin@gmail.com>
 <7159fb58f44f9ff00ca5b3b8a26ee3aa2fd1bf8a.1602574012.git.lucien.xin@gmail.com>
 <b9f0bfa27c5be3bbf27a7325c73f16205286df38.1602574012.git.lucien.xin@gmail.com>
 <c9c1d019287792f71863c89758d179b133fe1200.1602574012.git.lucien.xin@gmail.com>
 <37e9f70ffb9dea1572025b8e1c4b1f1c6e6b3da5.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
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
index 09b94cd..26e464b 100644
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
+	/* If changes are for association, also apply encap to each
+	 * transport.
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

