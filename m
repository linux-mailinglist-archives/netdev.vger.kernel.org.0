Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D485D44EE3
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 00:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbfFMWAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 18:00:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38086 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728239AbfFMWAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 18:00:10 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5DLr3tj027992
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 15:00:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=qF7wr7fn8ecnJrPgRkVnLhKJZ0Gg5ZmjntxN72yU170=;
 b=hiVFbaxK7tq1evPSBFK6bSLtjnA3mVsFn8rI2agbx8lpJPafhsrfkfTIn4cREU89RP1P
 iYr5OOl34ElS4WICAF+h7TOvuXGCVOZiSfsbzkYrqJoPvn2OcOpn7Frv+hRxVMOTPQgz
 0EWElwexxpa5UZ64cNkmSl/Lhg++amZvAAQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t3uh08qgq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 15:00:09 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 13 Jun 2019 15:00:08 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 4AE532943408; Thu, 13 Jun 2019 15:00:01 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Craig Gallek <kraig@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 1/3] bpf: net: Add SO_DETACH_REUSEPORT_BPF
Date:   Thu, 13 Jun 2019 15:00:01 -0700
Message-ID: <20190613220001.3095497-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190613215959.3095374-1-kafai@fb.com>
References: <20190613215959.3095374-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=25 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=810 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is SO_ATTACH_REUSEPORT_[CE]BPF but there is no DETACH.
This patch adds SO_DETACH_REUSEPORT_BPF sockopt.  The same
sockopt can be used to undo both SO_ATTACH_REUSEPORT_[CE]BPF.

reseport_detach_prog() is added and it is mostly a mirror
of the existing reuseport_attach_prog().  The differences are,
it does not call reuseport_alloc() and returns -ENOENT when
there is no old prog.

Cc: Craig Gallek <kraig@google.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 arch/alpha/include/uapi/asm/socket.h  |  2 ++
 arch/mips/include/uapi/asm/socket.h   |  2 ++
 arch/parisc/include/uapi/asm/socket.h |  2 ++
 arch/sparc/include/uapi/asm/socket.h  |  2 ++
 include/net/sock_reuseport.h          |  2 ++
 include/uapi/asm-generic/socket.h     |  2 ++
 net/core/sock.c                       |  4 ++++
 net/core/sock_reuseport.c             | 24 ++++++++++++++++++++++++
 8 files changed, 40 insertions(+)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index 976e89b116e5..de6c4df61082 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -122,6 +122,8 @@
 #define SO_RCVTIMEO_NEW         66
 #define SO_SNDTIMEO_NEW         67
 
+#define SO_DETACH_REUSEPORT_BPF 68
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index d41765cfbc6e..d0a9ed2ca2d6 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -133,6 +133,8 @@
 #define SO_RCVTIMEO_NEW         66
 #define SO_SNDTIMEO_NEW         67
 
+#define SO_DETACH_REUSEPORT_BPF 68
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index 66c5dd245ac7..10173c32195e 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -114,6 +114,8 @@
 #define SO_RCVTIMEO_NEW         0x4040
 #define SO_SNDTIMEO_NEW         0x4041
 
+#define SO_DETACH_REUSEPORT_BPF 0x4042
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index 9265a9eece15..8029b681fc7c 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -115,6 +115,8 @@
 #define SO_RCVTIMEO_NEW          0x0044
 #define SO_SNDTIMEO_NEW          0x0045
 
+#define SO_DETACH_REUSEPORT_BPF  0x0047
+
 #if !defined(__KERNEL__)
 
 
diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index 8a5f70c7cdf2..d9112de85261 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -35,6 +35,8 @@ extern struct sock *reuseport_select_sock(struct sock *sk,
 					  struct sk_buff *skb,
 					  int hdr_len);
 extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
+extern int reuseport_detach_prog(struct sock *sk);
+
 int reuseport_get_id(struct sock_reuseport *reuse);
 
 #endif  /* _SOCK_REUSEPORT_H */
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 8c1391c89171..77f7c1638eb1 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -117,6 +117,8 @@
 #define SO_RCVTIMEO_NEW         66
 #define SO_SNDTIMEO_NEW         67
 
+#define SO_DETACH_REUSEPORT_BPF 68
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/net/core/sock.c b/net/core/sock.c
index 75b1c950b49f..06be30737b69 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1045,6 +1045,10 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		}
 		break;
 
+	case SO_DETACH_REUSEPORT_BPF:
+		ret = reuseport_detach_prog(sk);
+		break;
+
 	case SO_DETACH_FILTER:
 		ret = sk_detach_filter(sk);
 		break;
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index dc4aefdf2a08..9408f9264d05 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -332,3 +332,27 @@ int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog)
 	return 0;
 }
 EXPORT_SYMBOL(reuseport_attach_prog);
+
+int reuseport_detach_prog(struct sock *sk)
+{
+	struct sock_reuseport *reuse;
+	struct bpf_prog *old_prog;
+
+	if (!rcu_access_pointer(sk->sk_reuseport_cb))
+		return sk->sk_reuseport ? -ENOENT : -EINVAL;
+
+	old_prog = NULL;
+	spin_lock_bh(&reuseport_lock);
+	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
+					  lockdep_is_held(&reuseport_lock));
+	rcu_swap_protected(reuse->prog, old_prog,
+			   lockdep_is_held(&reuseport_lock));
+	spin_unlock_bh(&reuseport_lock);
+
+	if (!old_prog)
+		return -ENOENT;
+
+	sk_reuseport_prog_free(old_prog);
+	return 0;
+}
+EXPORT_SYMBOL(reuseport_detach_prog);
-- 
2.17.1

