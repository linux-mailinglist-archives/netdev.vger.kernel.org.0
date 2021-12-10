Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549A4470BF9
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 21:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344201AbhLJUpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 15:45:01 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1700 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243037AbhLJUpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 15:45:00 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BAKJGcb028161
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 12:41:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=41ikyzXEnOUBvYI154qWctfYbbM85qZ88S7TEH2eCO8=;
 b=lgNQclwg7GJ1+eryPs42WlDv5tZ8ZiXyFkbFZnyt/hrBEoFZ5W8h8RupJH/O3WI+doii
 ugbLarzJIkj5WC25Ag9y3K0Oyy2elxH+r6hkSfXBBZIgJaJ0EdH2xkl1ZOFkroJO5J8R
 6gONJFubT751aj4+XjUZBRCQLgE1Re+t4Ow= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cvcus8na5-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 12:41:24 -0800
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 12:41:23 -0800
Received: by devbig612.frc2.facebook.com (Postfix, from userid 115148)
        id EDDD85E6ED6F; Fri, 10 Dec 2021 12:41:19 -0800 (PST)
From:   Joanne Koong <joannekoong@fb.com>
To:     <netdev@vger.kernel.org>
CC:     <ebiederm@xmission.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <Kernel-team@fb.com>, <kafai@fb.com>,
        Joanne Koong <joannekoong@fb.com>
Subject: [PATCH net-next v2] net: Enable max_dgram_qlen unix sysctl to be configurable by non-init user namespaces
Date:   Fri, 10 Dec 2021 12:40:23 -0800
Message-ID: <20211210204023.2595573-1-joannekoong@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: So9QSUKnMHbTEgAuSFossEvuO58U5IkO
X-Proofpoint-ORIG-GUID: So9QSUKnMHbTEgAuSFossEvuO58U5IkO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_08,2021-12-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 adultscore=0
 mlxscore=0 mlxlogscore=631 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100112
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables the "/proc/sys/net/unix/max_dgram_qlen" sysctl to be
exposed to non-init user namespaces. max_dgram_qlen is used as the defaul=
t
"sk_max_ack_backlog" value for when a unix socket is created.

Currently, when a networking namespace is initialized, its unix sysctls
are exposed only if the user namespace that "owns" it is the init user
namespace. If there is an non-init user namespace that "owns" a networkin=
g
namespace (for example, in the case after we call clone() with both
CLONE_NEWUSER and CLONE_NEWNET set), the sysctls are hidden from view
and not configurable.

Exposing the unix sysctl is safe because any changes made to it will be
limited in scope to the networking namespace the non-init user namespace
"owns" and has privileges over (changes won't affect any other net
namespace). There is also no possibility of a non-privileged user namespa=
ce
messing up the net namespace sysctls it shares with its parent user names=
pace.
When a new user namespace is created without unsharing the network namesp=
ace
(eg calling clone()  with CLONE_NEWUSER), the new user namespace shares i=
ts
parent's network namespace. Write access is protected by the mode set
in the sysctl's ctl_table (and enforced by procfs). Here in the case of
"max_dgram_qlen", 0644 is set; only the user owner has write access.

v1 -> v2:
* Add more detail to commit message, specify the
"/proc/sys/net/unix/max_dgram_qlen" sysctl in commit message.

Signed-off-by: Joanne Koong <joannekoong@fb.com>
---
 net/unix/sysctl_net_unix.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
index c09bea89151b..01d44e2598e2 100644
--- a/net/unix/sysctl_net_unix.c
+++ b/net/unix/sysctl_net_unix.c
@@ -30,10 +30,6 @@ int __net_init unix_sysctl_register(struct net *net)
 	if (table =3D=3D NULL)
 		goto err_alloc;
=20
-	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns !=3D &init_user_ns)
-		table[0].procname =3D NULL;
-
 	table[0].data =3D &net->unx.sysctl_max_dgram_qlen;
 	net->unx.ctl =3D register_net_sysctl(net, "net/unix", table);
 	if (net->unx.ctl =3D=3D NULL)
--=20
2.30.2

