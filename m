Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7659846B064
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 03:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbhLGCEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 21:04:44 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9726 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230102AbhLGCEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 21:04:43 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B71E6w9000537
        for <netdev@vger.kernel.org>; Mon, 6 Dec 2021 18:01:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=rh5+I8LYYhvrEv+ZpzLP/D+AvzFKP0SX4QYCq6WvVnI=;
 b=b3TX0gLPrdCn3M3MoFl5GfgVAxzLuXKl/BwoDh6+RiJu0r4AitGJsVgeDLkveppOPVbT
 9L7HuRQgVGL5358NRD77HVjr/efp+2xKBBvjmfE54utRBEAaX3cRVQt7mHIRY+KpNHLS
 2dChw2bTGpjo0rlh2U41lpH9y7pTR662J1M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cswrj06yv-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 18:01:13 -0800
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 18:01:11 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 73BDB37EEE42; Mon,  6 Dec 2021 18:01:08 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [RFC PATCH net-next 2/2] net: Reset forwarded skb->tstamp before delivering to user space
Date:   Mon, 6 Dec 2021 18:01:08 -0800
Message-ID: <20211207020108.3691229-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211207020102.3690724-1-kafai@fb.com>
References: <20211207020102.3690724-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: OpRZgE8VesD-6yR-OzP9NXp6G8B0b0At
X-Proofpoint-ORIG-GUID: OpRZgE8VesD-6yR-OzP9NXp6G8B0b0At
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-06_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 clxscore=1015 phishscore=0
 spamscore=0 mlxlogscore=836 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112070012
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The skb->tstamp may be set by a local sk (as a sender in tcp) which then
forwarded and delivered to another sk (as a receiver).

An example:
    sender-sk =3D> veth@netns =3D=3D=3D=3D=3D> veth@host =3D> receiver-sk
                             ^^^
			__dev_forward_skb

The skb->tstamp is marked with a future TX time.  This future
skb->tstamp will confuse the receiver-sk.

This patch marks the skb if the skb->tstamp is forwarded.
Before using the skb->tstamp as a rx timestamp, it needs
to be re-stamped to avoid getting a future time.  It is
done in the RX timestamp reading helper skb_get_ktime().

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/skbuff.h | 14 +++++++++-----
 net/core/dev.c         |  4 +++-
 net/core/skbuff.c      |  6 +++++-
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b609bdc5398b..bc4ae34c4e22 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -867,6 +867,7 @@ struct sk_buff {
 	__u8			decrypted:1;
 #endif
 	__u8			slow_gro:1;
+	__u8			fwd_tstamp:1;
=20
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
@@ -3806,9 +3807,12 @@ static inline void skb_copy_to_linear_data_offset(=
struct sk_buff *skb,
 }
=20
 void skb_init(void);
+void net_timestamp_set(struct sk_buff *skb);
=20
-static inline ktime_t skb_get_ktime(const struct sk_buff *skb)
+static inline ktime_t skb_get_ktime(struct sk_buff *skb)
 {
+	if (unlikely(skb->fwd_tstamp))
+		net_timestamp_set(skb);
 	return ktime_mono_to_real_cond(skb->tstamp);
 }
=20
@@ -3821,13 +3825,13 @@ static inline ktime_t skb_get_ktime(const struct =
sk_buff *skb)
  *	This function converts the offset back to a struct timeval and stores
  *	it in stamp.
  */
-static inline void skb_get_timestamp(const struct sk_buff *skb,
+static inline void skb_get_timestamp(struct sk_buff *skb,
 				     struct __kernel_old_timeval *stamp)
 {
 	*stamp =3D ns_to_kernel_old_timeval(skb_get_ktime(skb));
 }
=20
-static inline void skb_get_new_timestamp(const struct sk_buff *skb,
+static inline void skb_get_new_timestamp(struct sk_buff *skb,
 					 struct __kernel_sock_timeval *stamp)
 {
 	struct timespec64 ts =3D ktime_to_timespec64(skb_get_ktime(skb));
@@ -3836,7 +3840,7 @@ static inline void skb_get_new_timestamp(const stru=
ct sk_buff *skb,
 	stamp->tv_usec =3D ts.tv_nsec / 1000;
 }
=20
-static inline void skb_get_timestampns(const struct sk_buff *skb,
+static inline void skb_get_timestampns(struct sk_buff *skb,
 				       struct __kernel_old_timespec *stamp)
 {
 	struct timespec64 ts =3D ktime_to_timespec64(skb_get_ktime(skb));
@@ -3845,7 +3849,7 @@ static inline void skb_get_timestampns(const struct=
 sk_buff *skb,
 	stamp->tv_nsec =3D ts.tv_nsec;
 }
=20
-static inline void skb_get_new_timestampns(const struct sk_buff *skb,
+static inline void skb_get_new_timestampns(struct sk_buff *skb,
 					   struct __kernel_timespec *stamp)
 {
 	struct timespec64 ts =3D ktime_to_timespec64(skb_get_ktime(skb));
diff --git a/net/core/dev.c b/net/core/dev.c
index 4420086f3aeb..96cd31d9a359 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2058,12 +2058,14 @@ void net_disable_timestamp(void)
 }
 EXPORT_SYMBOL(net_disable_timestamp);
=20
-static inline void net_timestamp_set(struct sk_buff *skb)
+void net_timestamp_set(struct sk_buff *skb)
 {
 	skb->tstamp =3D 0;
+	skb->fwd_tstamp =3D 0;
 	if (static_branch_unlikely(&netstamp_needed_key))
 		__net_timestamp(skb);
 }
+EXPORT_SYMBOL(net_timestamp_set);
=20
 #define net_timestamp_check(COND, SKB)				\
 	if (static_branch_unlikely(&netstamp_needed_key)) {	\
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f091c7807a9e..181ddc989ead 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5295,8 +5295,12 @@ void skb_scrub_tstamp(struct sk_buff *skb)
 {
 	struct sock *sk =3D skb->sk;
=20
-	if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME))
+	if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME)) {
 		skb->tstamp =3D 0;
+		skb->fwd_tstamp =3D 0;
+	} else if (skb->tstamp) {
+		skb->fwd_tstamp =3D 1;
+	}
 }
=20
 /**
--=20
2.30.2

