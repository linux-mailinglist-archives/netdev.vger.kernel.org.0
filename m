Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18AB2581FDA
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiG0GJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiG0GJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:09:18 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DF73FA16
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:09:17 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QND7wm008762
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:09:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=wZoCpmLJMa9fJowR/gtOH34UaLy3DGaHUp0wCMfo4F0=;
 b=MSnE6+nA+gsvnh4sfdWisJHGZ5YnJ4hSzjIkMPuu3sUnEfK6jKiFGM0Mv2BJPoF1I4Wf
 pPs0/J+w0uku5kjMnKm803qplLz5to3WyRWo2UHup+ooWvvPHpy6Ok8dTyZfWehn0HPf
 WGWILGKDtEZe7N0edt7f1yWm227JIoq6F1A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hjdvtphnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:09:17 -0700
Received: from twshared5413.23.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 23:09:16 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id 3243A757CB72; Tue, 26 Jul 2022 23:09:09 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH bpf-next 02/14] bpf: net: Avoid sock_setsockopt() taking sk lock when called from bpf
Date:   Tue, 26 Jul 2022 23:09:09 -0700
Message-ID: <20220727060909.2371812-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220727060856.2370358-1-kafai@fb.com>
References: <20220727060856.2370358-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: FF-G2sck-zSCNaBwqju3UoX9CoeZknlM
X-Proofpoint-ORIG-GUID: FF-G2sck-zSCNaBwqju3UoX9CoeZknlM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of the codes in bpf_setsockopt(SOL_SOCKET) are duplicated from
the sock_setsockopt().  The number of supported options are
increasing ever and so as the duplicated codes.

One issue in reusing sock_setsockopt() is that the bpf prog
has already acquired the sk lock.  sockptr_t is useful to handle this.
sockptr_t already has a bit 'is_kernel' to handle the kernel-or-user
memory copy.  This patch adds a 'is_bpf' bit to tell if sk locking
has already been ensured by the bpf prog.

{lock,release}_sock_sockopt() helpers are added for the
sock_setsockopt() to use.  These helpers will handle the new
'is_bpf' bit.

Note on the change in sock_setbindtodevice().  lock_sock_sockopt()
is done in sock_setbindtodevice() instead of doing the lock_sock
in sock_bindtoindex(..., lock_sk =3D true).

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/sockptr.h |  8 +++++++-
 include/net/sock.h      | 12 ++++++++++++
 net/core/sock.c         |  8 +++++---
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
index d45902fb4cad..787d0be08fb7 100644
--- a/include/linux/sockptr.h
+++ b/include/linux/sockptr.h
@@ -16,7 +16,8 @@ typedef struct {
 		void		*kernel;
 		void __user	*user;
 	};
-	bool		is_kernel : 1;
+	bool		is_kernel : 1,
+			is_bpf : 1;
 } sockptr_t;
=20
 static inline bool sockptr_is_kernel(sockptr_t sockptr)
@@ -24,6 +25,11 @@ static inline bool sockptr_is_kernel(sockptr_t sockptr=
)
 	return sockptr.is_kernel;
 }
=20
+static inline sockptr_t KERNEL_SOCKPTR_BPF(void *p)
+{
+	return (sockptr_t) { .kernel =3D p, .is_kernel =3D true, .is_bpf =3D tr=
ue };
+}
+
 static inline sockptr_t KERNEL_SOCKPTR(void *p)
 {
 	return (sockptr_t) { .kernel =3D p, .is_kernel =3D true };
diff --git a/include/net/sock.h b/include/net/sock.h
index 9e2539dcc293..2f913bdf0035 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1721,6 +1721,18 @@ static inline void unlock_sock_fast(struct sock *s=
k, bool slow)
 	}
 }
=20
+static inline void lock_sock_sockopt(struct sock *sk, sockptr_t optval)
+{
+	if (!optval.is_bpf)
+		lock_sock(sk);
+}
+
+static inline void release_sock_sockopt(struct sock *sk, sockptr_t optva=
l)
+{
+	if (!optval.is_bpf)
+		release_sock(sk);
+}
+
 /* Used by processes to "lock" a socket state, so that
  * interrupts and bottom half handlers won't change it
  * from under us. It essentially blocks any incoming
diff --git a/net/core/sock.c b/net/core/sock.c
index 18bb4f269cf1..61d927a5f6cb 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -703,7 +703,9 @@ static int sock_setbindtodevice(struct sock *sk, sock=
ptr_t optval, int optlen)
 			goto out;
 	}
=20
-	return sock_bindtoindex(sk, index, true);
+	lock_sock_sockopt(sk, optval);
+	ret =3D sock_bindtoindex_locked(sk, index);
+	release_sock_sockopt(sk, optval);
 out:
 #endif
=20
@@ -1067,7 +1069,7 @@ int sock_setsockopt(struct sock *sk, int level, int=
 optname,
=20
 	valbool =3D val ? 1 : 0;
=20
-	lock_sock(sk);
+	lock_sock_sockopt(sk, optval);
=20
 	switch (optname) {
 	case SO_DEBUG:
@@ -1496,7 +1498,7 @@ int sock_setsockopt(struct sock *sk, int level, int=
 optname,
 		ret =3D -ENOPROTOOPT;
 		break;
 	}
-	release_sock(sk);
+	release_sock_sockopt(sk, optval);
 	return ret;
 }
 EXPORT_SYMBOL(sock_setsockopt);
--=20
2.30.2

