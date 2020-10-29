Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C714429E44C
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbgJ2HhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbgJ2HYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:55 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A219C08EA72;
        Thu, 29 Oct 2020 00:06:23 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id w11so853388pll.8;
        Thu, 29 Oct 2020 00:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=chT+1o8Xi621C2FvgvkILiU4uVhJ0TT4r54HGt7i2kM=;
        b=NEbdQv/4K/Ihpx/PxvC12DbWOztigVablA1hOGxMR3laVbNFGdWwqKVFoebghkDFfp
         GoVDFHNxmxyYZV0oRhX5fnMixBPsY/vIesCuEOudtfntewWRKvZyO+D3WHixxvXQ/GG1
         QWxfFMbt1yo+aSEgk8vMfWjK4LTJe7vu4yNShZY/5yr4VYyW6alR2TJ/65j8vOG1MbCk
         rJr5MgTz+sKOjx5DNzY5cIbX9WR8tPqfLUsgr1yxtw2nSb9fTGRsyJFQqWEHXzmy6cmk
         a5aNQ8LJEeZVVZLl6nfruZlfzx03LpJl0aGO+50zLHSOwgOGTNPTZhkKNxn+p15kpkVV
         Whpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=chT+1o8Xi621C2FvgvkILiU4uVhJ0TT4r54HGt7i2kM=;
        b=EOrJkCKVAJ1KwHsK/yFtjt6uQII+q6/WMs/iICRknhK42XiIpCNeum39TUsNgbremq
         nJ/CvUzxtjVdjwkQOWBkUnhi6Zb9rsPr+CzOnn/tdcJ6JmqJrPmrGjrnn/rbDiRE7VZi
         ydzZLE3QljZfX8URce5AYXsdYnFlwILpxDVGfmMTVK2q9v/uo4l58uR+idXykMiQvRFj
         4SQ2HcB2D2wgw/ORD1KSvSFsmaU2A+DFh3JrmmtSSlSo7NWHUGUkEKp8CSkRr30Tq3Yy
         6DXjph0SlncnkSAu1oIZQo02aKjnZdsshnVsx5xzBbJRIB+VPP1JrQpohZSAkCWYcJGw
         y6vQ==
X-Gm-Message-State: AOAM531wdJ2Qk+WP7NJdk6p05pOrs5Xn0dQm6gXKbdV78kgdFwM/8cHA
        K+D5KlOtN5VpXb3bOK56iC7W5Gf2yBg=
X-Google-Smtp-Source: ABdhPJzc2jqPbNnfk4uK/sXPKq5NvkFus70RrO2pu7F4MODne1+vLVokXvajyN/NeDGMCd0+PM0kQQ==
X-Received: by 2002:a17:902:a5c5:b029:d5:dc92:49e7 with SMTP id t5-20020a170902a5c5b02900d5dc9249e7mr2699413plq.25.1603955182600;
        Thu, 29 Oct 2020 00:06:22 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h184sm1719239pfe.161.2020.10.29.00.06.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Oct 2020 00:06:21 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com
Subject: [PATCHv5 net-next 08/16] sctp: add SCTP_REMOTE_UDP_ENCAPS_PORT sockopt
Date:   Thu, 29 Oct 2020 15:05:02 +0800
Message-Id: <e72ab91d56df2ced82efb0c9d26d29f47d0747f7.1603955040.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <066bbdcf83188bbc62b6c458f2a0fd8f06f41640.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
 <48053c3bf48a46899bc0130dc43adca1e6925581.1603955040.git.lucien.xin@gmail.com>
 <4f439ed717442a649ba78dc0efc6f121208a9995.1603955040.git.lucien.xin@gmail.com>
 <e7575f9fea2b867bf0c7c3e8541e8a6101610055.1603955040.git.lucien.xin@gmail.com>
 <1cfd9ca0154d35389b25f68457ea2943a19e7da2.1603955040.git.lucien.xin@gmail.com>
 <3c26801d36575d0e9c9bd260e6c1f1b67e4b721e.1603955040.git.lucien.xin@gmail.com>
 <279d266bc34ebc439114f39da983dc08845ea37a.1603955040.git.lucien.xin@gmail.com>
 <066bbdcf83188bbc62b6c458f2a0fd8f06f41640.1603955040.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
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

