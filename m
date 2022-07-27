Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2278A581FE5
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiG0GJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbiG0GJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:09:50 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AB5402C1
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:09:49 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QND0Bu004975
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:09:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=oBzZsS9YU5IlPp/uz4kK4qHUrMDYMlhpxpusLRYRTog=;
 b=JJWW+THEpRMbB2koL8w5JrY3Evu0esVMDTiSY+uGg8u4/Rl60+EefbIVVh9PyWQRAaxt
 ibYk9ZMmsbshiykcgC7RAXmgMJ1qFWHJnkV6WHs8jbt79aBL/X4Kwz3QrCA3xC0DvDNW
 v5i49nThodhAsm/VzBIP1lzUatJ2Q3sQEQ4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hjhxaw34f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:09:49 -0700
Received: from twshared14818.18.frc3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 23:09:48 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id AC832757CCF3; Tue, 26 Jul 2022 23:09:40 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH bpf-next 07/14] bpf: Embed kernel CONFIG check into the if statement in bpf_setsockopt
Date:   Tue, 26 Jul 2022 23:09:40 -0700
Message-ID: <20220727060940.2376067-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220727060856.2370358-1-kafai@fb.com>
References: <20220727060856.2370358-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 96E2EmI0n1dS-nsQzrxV5AksitTbjokM
X-Proofpoint-GUID: 96E2EmI0n1dS-nsQzrxV5AksitTbjokM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves the "#ifdef CONFIG_XXX" check into the "if/else"
statement itself.  The change is done for the bpf_setsockopt()
function only.  It will make the latter patches easier to follow
without the surrounding ifdef macro.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/core/filter.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 5669248aff25..01cb4a01b1c1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5113,8 +5113,7 @@ static int __bpf_setsockopt(struct sock *sk, int le=
vel, int optname,
 		default:
 			ret =3D -EINVAL;
 		}
-#ifdef CONFIG_INET
-	} else if (level =3D=3D SOL_IP) {
+	} else if (IS_ENABLED(CONFIG_INET) && level =3D=3D SOL_IP) {
 		if (optlen !=3D sizeof(int) || sk->sk_family !=3D AF_INET)
 			return -EINVAL;
=20
@@ -5135,8 +5134,7 @@ static int __bpf_setsockopt(struct sock *sk, int le=
vel, int optname,
 		default:
 			ret =3D -EINVAL;
 		}
-#if IS_ENABLED(CONFIG_IPV6)
-	} else if (level =3D=3D SOL_IPV6) {
+	} else if (IS_ENABLED(CONFIG_IPV6) && level =3D=3D SOL_IPV6) {
 		if (optlen !=3D sizeof(int) || sk->sk_family !=3D AF_INET6)
 			return -EINVAL;
=20
@@ -5157,8 +5155,7 @@ static int __bpf_setsockopt(struct sock *sk, int le=
vel, int optname,
 		default:
 			ret =3D -EINVAL;
 		}
-#endif
-	} else if (level =3D=3D SOL_TCP &&
+	} else if (IS_ENABLED(CONFIG_INET) && level =3D=3D SOL_TCP &&
 		   sk->sk_prot->setsockopt =3D=3D tcp_setsockopt) {
 		if (optname =3D=3D TCP_CONGESTION) {
 			char name[TCP_CA_NAME_MAX];
@@ -5250,7 +5247,6 @@ static int __bpf_setsockopt(struct sock *sk, int le=
vel, int optname,
 				ret =3D -EINVAL;
 			}
 		}
-#endif
 	} else {
 		ret =3D -EINVAL;
 	}
--=20
2.30.2

