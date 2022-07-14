Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C5E574B64
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 13:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238573AbiGNLDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 07:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238002AbiGNLDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 07:03:13 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C6F57205
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 04:03:11 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E6x6Sm010068
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 04:03:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=U9SRcZE4yufVxMG2uTQVaSIqlEvTuj1i2uWDAr9BhmI=;
 b=JaRQf2QPNBm0w143M89RevhFfz145pWEqxoBkUIBhfVUPUyhy/G/eRjw6PEY/cINASH9
 XNiyinMcF1MMo6AI34tnvLNJzhsDnSIpImv4EFn49hl7+7i6dWEeiy9gVhog26U1/YPa
 4Nl3bWH0Vk3RdyfKT2bWViB3KxJuq41J1D8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h9h5fj9g9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 04:03:11 -0700
Received: from twshared25107.07.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 14 Jul 2022 04:03:10 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id D8F032FCA618; Thu, 14 Jul 2022 04:03:02 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <io-uring@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v3 for-next 2/3] net: copy from user before calling __get_compat_msghdr
Date:   Thu, 14 Jul 2022 04:02:57 -0700
Message-ID: <20220714110258.1336200-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220714110258.1336200-1-dylany@fb.com>
References: <20220714110258.1336200-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ACK7bxiroEeTv07qU-z5B9w24Sixd3Tc
X-Proofpoint-ORIG-GUID: ACK7bxiroEeTv07qU-z5B9w24Sixd3Tc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_08,2022-07-14_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this is in preparation for multishot receive from io_uring, where it need=
s
to have access to the original struct user_msghdr.

functionally this should be a no-op.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 include/net/compat.h |  5 ++---
 io_uring/net.c       | 17 +++++++++--------
 net/compat.c         | 39 +++++++++++++++++----------------------
 3 files changed, 28 insertions(+), 33 deletions(-)

diff --git a/include/net/compat.h b/include/net/compat.h
index 595fee069b82..84c163f40f38 100644
--- a/include/net/compat.h
+++ b/include/net/compat.h
@@ -46,9 +46,8 @@ struct compat_rtentry {
 	unsigned short  rt_irtt;        /* Initial RTT                  */
 };
=20
-int __get_compat_msghdr(struct msghdr *kmsg, struct compat_msghdr __user=
 *umsg,
-			struct sockaddr __user **save_addr, compat_uptr_t *ptr,
-			compat_size_t *len);
+int __get_compat_msghdr(struct msghdr *kmsg, struct compat_msghdr *msg,
+			struct sockaddr __user **save_addr);
 int get_compat_msghdr(struct msghdr *, struct compat_msghdr __user *,
 		      struct sockaddr __user **, struct iovec **);
 int put_cmsg_compat(struct msghdr*, int, int, int, void *);
diff --git a/io_uring/net.c b/io_uring/net.c
index da7667ed3610..5bc3440a8290 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -369,24 +369,25 @@ static int __io_compat_recvmsg_copy_hdr(struct io_k=
iocb *req,
 					struct io_async_msghdr *iomsg)
 {
 	struct io_sr_msg *sr =3D io_kiocb_to_cmd(req);
+	struct compat_msghdr msg;
 	struct compat_iovec __user *uiov;
-	compat_uptr_t ptr;
-	compat_size_t len;
 	int ret;
=20
-	ret =3D __get_compat_msghdr(&iomsg->msg, sr->umsg_compat, &iomsg->uaddr=
,
-				  &ptr, &len);
+	if (copy_from_user(&msg, sr->umsg_compat, sizeof(msg)))
+		return -EFAULT;
+
+	ret =3D __get_compat_msghdr(&iomsg->msg, sr->umsg_compat, &iomsg->uaddr=
);
 	if (ret)
 		return ret;
=20
-	uiov =3D compat_ptr(ptr);
+	uiov =3D compat_ptr(msg.msg_iov);
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		compat_ssize_t clen;
=20
-		if (len =3D=3D 0) {
+		if (msg.msg_iovlen =3D=3D 0) {
 			sr->len =3D 0;
 			iomsg->free_iov =3D NULL;
-		} else if (len > 1) {
+		} else if (msg.msg_iovlen > 1) {
 			return -EINVAL;
 		} else {
 			if (!access_ok(uiov, sizeof(*uiov)))
@@ -400,7 +401,7 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kio=
cb *req,
 		}
 	} else {
 		iomsg->free_iov =3D iomsg->fast_iov;
-		ret =3D __import_iovec(READ, (struct iovec __user *)uiov, len,
+		ret =3D __import_iovec(READ, (struct iovec __user *)uiov, msg.msg_iovl=
en,
 				   UIO_FASTIOV, &iomsg->free_iov,
 				   &iomsg->msg.msg_iter, true);
 		if (ret < 0)
diff --git a/net/compat.c b/net/compat.c
index 210fc3b4d0d8..513aa9a3fc64 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -34,20 +34,15 @@
 #include <net/compat.h>
=20
 int __get_compat_msghdr(struct msghdr *kmsg,
-			struct compat_msghdr __user *umsg,
-			struct sockaddr __user **save_addr,
-			compat_uptr_t *ptr, compat_size_t *len)
+			struct compat_msghdr *msg,
+			struct sockaddr __user **save_addr)
 {
-	struct compat_msghdr msg;
 	ssize_t err;
=20
-	if (copy_from_user(&msg, umsg, sizeof(*umsg)))
-		return -EFAULT;
-
-	kmsg->msg_flags =3D msg.msg_flags;
-	kmsg->msg_namelen =3D msg.msg_namelen;
+	kmsg->msg_flags =3D msg->msg_flags;
+	kmsg->msg_namelen =3D msg->msg_namelen;
=20
-	if (!msg.msg_name)
+	if (!msg->msg_name)
 		kmsg->msg_namelen =3D 0;
=20
 	if (kmsg->msg_namelen < 0)
@@ -57,15 +52,15 @@ int __get_compat_msghdr(struct msghdr *kmsg,
 		kmsg->msg_namelen =3D sizeof(struct sockaddr_storage);
=20
 	kmsg->msg_control_is_user =3D true;
-	kmsg->msg_control_user =3D compat_ptr(msg.msg_control);
-	kmsg->msg_controllen =3D msg.msg_controllen;
+	kmsg->msg_control_user =3D compat_ptr(msg->msg_control);
+	kmsg->msg_controllen =3D msg->msg_controllen;
=20
 	if (save_addr)
-		*save_addr =3D compat_ptr(msg.msg_name);
+		*save_addr =3D compat_ptr(msg->msg_name);
=20
-	if (msg.msg_name && kmsg->msg_namelen) {
+	if (msg->msg_name && kmsg->msg_namelen) {
 		if (!save_addr) {
-			err =3D move_addr_to_kernel(compat_ptr(msg.msg_name),
+			err =3D move_addr_to_kernel(compat_ptr(msg->msg_name),
 						  kmsg->msg_namelen,
 						  kmsg->msg_name);
 			if (err < 0)
@@ -76,12 +71,10 @@ int __get_compat_msghdr(struct msghdr *kmsg,
 		kmsg->msg_namelen =3D 0;
 	}
=20
-	if (msg.msg_iovlen > UIO_MAXIOV)
+	if (msg->msg_iovlen > UIO_MAXIOV)
 		return -EMSGSIZE;
=20
 	kmsg->msg_iocb =3D NULL;
-	*ptr =3D msg.msg_iov;
-	*len =3D msg.msg_iovlen;
 	return 0;
 }
=20
@@ -90,15 +83,17 @@ int get_compat_msghdr(struct msghdr *kmsg,
 		      struct sockaddr __user **save_addr,
 		      struct iovec **iov)
 {
-	compat_uptr_t ptr;
-	compat_size_t len;
+	struct compat_msghdr msg;
 	ssize_t err;
=20
-	err =3D __get_compat_msghdr(kmsg, umsg, save_addr, &ptr, &len);
+	if (copy_from_user(&msg, umsg, sizeof(*umsg)))
+		return -EFAULT;
+
+	err =3D __get_compat_msghdr(kmsg, umsg, save_addr);
 	if (err)
 		return err;
=20
-	err =3D import_iovec(save_addr ? READ : WRITE, compat_ptr(ptr), len,
+	err =3D import_iovec(save_addr ? READ : WRITE, compat_ptr(msg.msg_iov),=
 msg.msg_iovlen,
 			   UIO_FASTIOV, iov, &kmsg->msg_iter);
 	return err < 0 ? err : 0;
 }
--=20
2.30.2

