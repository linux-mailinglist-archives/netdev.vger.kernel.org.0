Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BA6217CC3
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 03:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbgGHBpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 21:45:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30734 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728067AbgGHBpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 21:45:02 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0681j0ox012295
        for <netdev@vger.kernel.org>; Tue, 7 Jul 2020 18:45:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=mFxmISDPWi+NvyOIdYxOxKnK/b+85WYaUVZLtDhtE+I=;
 b=NTXXSbRpe+QC/Ihiad3nEbhE4skFPtQYaGFUI5ZcXCd61CC1UI/8utGGaZJJIIdkLeDN
 z2roBiU5ciXwWg43rL5mQ4q4yzp5zS0UP7IEec2Fbza2+HTSDa5QAlPM4U/isr+uSFMK
 EDaX6k9H53nhczzb/jRcfdAWzFiV4o82mDg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3239rs4wms-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 18:45:01 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 7 Jul 2020 18:44:31 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 5A6EE294591E; Tue,  7 Jul 2020 18:44:26 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, James Chapman <jchapman@katalix.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 2/2] bpf: net: Avoid incorrect bpf_sk_reuseport_detach call
Date:   Tue, 7 Jul 2020 18:44:26 -0700
Message-ID: <20200708014426.1991187-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200708014413.1990641-1-kafai@fb.com>
References: <20200708014413.1990641-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_15:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=670
 mlxscore=0 suspectscore=3 clxscore=1015 impostorscore=0 adultscore=0
 malwarescore=0 cotscore=-2147483648 lowpriorityscore=0 phishscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007080009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_sk_reuseport_detach is currently called when sk->sk_user_data
is not NULL.  It is incorrect because sk->sk_user_data may not be
managed by the bpf's reuseport_array.  It has been report in [1] that,
the bpf_sk_reuseport_detach() which is called from udp_lib_unhash() has
corrupted the sk_user_data managed by l2tp.

This patch solves it by using another bit (defined as SK_USER_DATA_BPF)
of the sk_user_data pointer value.  It marks that a sk_user_data is
managed/owned by BPF.

The patch depends on a PTRMASK introduced in
commit f1ff5ce2cd5e ("net, sk_msg: Clear sk_user_data pointer on clone if=
 tagged").

[ Note: sk->sk_user_data is used by bpf's reuseport_array only when a sk =
is
  added to the bpf's reuseport_array.
  i.e. doing setsockopt(SO_REUSEPORT) and having "sk->sk_reuseport =3D=3D=
 1"
  alone will not stop sk->sk_user_data being used by other means. ]

[1]: https://lore.kernel.org/netdev/20200706121259.GA20199@katalix.com/

Reported-by: James Chapman <jchapman@katalix.com>
Cc: James Chapman <jchapman@katalix.com>
Fixes: 5dc4c4b7d4e8 ("bpf: Introduce BPF_MAP_TYPE_REUSEPORT_SOCKARRAY")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/sock.h           | 3 ++-
 kernel/bpf/reuseport_array.c | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 3428619faae4..9fe42c890706 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -533,7 +533,8 @@ enum sk_pacing {
  * be copied.
  */
 #define SK_USER_DATA_NOCOPY	1UL
-#define SK_USER_DATA_PTRMASK	~(SK_USER_DATA_NOCOPY)
+#define SK_USER_DATA_BPF	2UL	/* Managed by BPF */
+#define SK_USER_DATA_PTRMASK	~3UL
=20
 /**
  * sk_user_data_is_nocopy - Test if sk_user_data pointer must not be cop=
ied
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index a95bc8d7e812..cae9d505e04a 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -24,7 +24,7 @@ void bpf_sk_reuseport_detach(struct sock *sk)
=20
 	write_lock_bh(&sk->sk_callback_lock);
 	sk_user_data =3D (uintptr_t)sk->sk_user_data;
-	if (sk_user_data) {
+	if (sk_user_data & SK_USER_DATA_BPF) {
 		struct sock __rcu **socks;
=20
 		socks =3D (void *)(sk_user_data & SK_USER_DATA_PTRMASK);
@@ -309,7 +309,8 @@ int bpf_fd_reuseport_array_update_elem(struct bpf_map=
 *map, void *key,
 	if (err)
 		goto put_file_unlock;
=20
-	sk_user_data =3D (uintptr_t)&array->ptrs[index] | SK_USER_DATA_NOCOPY;
+	sk_user_data =3D (uintptr_t)&array->ptrs[index] | SK_USER_DATA_NOCOPY |
+		SK_USER_DATA_BPF;
 	WRITE_ONCE(nsk->sk_user_data, (void *)sk_user_data);
 	rcu_assign_pointer(array->ptrs[index], nsk);
 	free_osk =3D osk;
--=20
2.24.1

