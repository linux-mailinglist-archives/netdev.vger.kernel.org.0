Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB8519E1CB
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 02:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgDDAKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 20:10:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30034 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbgDDAKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 20:10:10 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03406V90004865
        for <netdev@vger.kernel.org>; Fri, 3 Apr 2020 17:10:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=xKbcFjlOJM015WchGJLjfIA/1sUOIcHuIr9KzVgwgVk=;
 b=PGnhqVOKBMt8ghLoHcMHNdjOICZawdqYgzWEfg2DkLTran41fDLLbCVdVYta/2GaT+md
 PR99P3Z0top6/gnH+CdHnIMggiF6sWpQBtOv13wf7vjy3bPDPwrAQH9NwSkC+h7uVCGm
 tkbAuwhH82hJiwWqabDOd68EcYcy9ttaOzQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3067152kgq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 17:10:09 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 3 Apr 2020 17:10:09 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B50B22EC2885; Fri,  3 Apr 2020 17:10:07 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 4/8] bpf: support GET_FD_BY_ID and GET_NEXT_ID for bpf_link
Date:   Fri, 3 Apr 2020 17:09:43 -0700
Message-ID: <20200404000948.3980903-5-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200404000948.3980903-1-andriin@fb.com>
References: <20200404000948.3980903-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_19:2020-04-03,2020-04-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 clxscore=1015 phishscore=0 mlxscore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=8 malwarescore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004030183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to look up bpf_link by ID and iterate over all existing bpf_l=
inks
in the system. GET_FD_BY_ID code handles not-yet-ready bpf_link by checki=
ng
that its ID hasn't been set to non-zero value yet. Setting bpf_link's ID =
is
done as the very last step in finalizing bpf_link, together with installi=
ng
FD. This approach allows users of bpf_link in kernel code to not worry ab=
out
races between user-space and kernel code that hasn't finished attaching a=
nd
initializing bpf_link.

Further, it's critical that BPF_LINK_GET_FD_BY_ID only ever allows to cre=
ate
bpf_link FD that's O_RDONLY. This is to protect processes owning bpf_link=
 and
thus allowed to perform modifications on them (like LINK_UPDATE), from ot=
her
processes that got bpf_link ID from GET_NEXT_ID API. In the latter case, =
only
querying bpf_link information (implemented later in the series) will be
allowed.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/uapi/linux/bpf.h |  2 ++
 kernel/bpf/syscall.c     | 56 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index eccfd1dea951..407c086bc9e4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -113,6 +113,8 @@ enum bpf_cmd {
 	BPF_MAP_DELETE_BATCH,
 	BPF_LINK_CREATE,
 	BPF_LINK_UPDATE,
+	BPF_LINK_GET_FD_BY_ID,
+	BPF_LINK_GET_NEXT_ID,
 };
=20
 enum bpf_map_type {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8b3a7d5814ae..527ec16702be 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3719,6 +3719,55 @@ static int link_update(union bpf_attr *attr)
 	return ret;
 }
=20
+static int bpf_link_inc_not_zero(struct bpf_link *link)
+{
+	return atomic64_fetch_add_unless(&link->refcnt, 1, 0) ? 0 : -ENOENT;
+}
+
+#define BPF_LINK_GET_FD_BY_ID_LAST_FIELD open_flags
+
+static int bpf_link_get_fd_by_id(const union bpf_attr *attr)
+{
+	struct bpf_link *link;
+	u32 id =3D attr->link_id;
+	int f_flags;
+	int fd, err;
+
+	if (CHECK_ATTR(BPF_LINK_GET_FD_BY_ID) ||
+	    /* links are not allowed to be open by ID as writable */
+	    attr->open_flags & ~BPF_F_RDONLY)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	f_flags =3D bpf_get_file_flag(attr->open_flags);
+	if (f_flags < 0)
+		return f_flags;
+
+	spin_lock_bh(&link_idr_lock);
+	link =3D idr_find(&link_idr, id);
+	/* before link is "settled", ID is 0, pretend it doesn't exist yet */
+	if (link) {
+		if (link->id)
+			err =3D bpf_link_inc_not_zero(link);
+		else
+			err =3D -EAGAIN;
+	} else {
+		err =3D -ENOENT;
+	}
+	spin_unlock_bh(&link_idr_lock);
+
+	if (err)
+		return err;
+
+	fd =3D bpf_link_new_fd(link, f_flags);
+	if (fd < 0)
+		bpf_link_put(link);
+
+	return fd;
+}
+
 SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned =
int, size)
 {
 	union bpf_attr attr;
@@ -3836,6 +3885,13 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __us=
er *, uattr, unsigned int, siz
 	case BPF_LINK_UPDATE:
 		err =3D link_update(&attr);
 		break;
+	case BPF_LINK_GET_FD_BY_ID:
+		err =3D bpf_link_get_fd_by_id(&attr);
+		break;
+	case BPF_LINK_GET_NEXT_ID:
+		err =3D bpf_obj_get_next_id(&attr, uattr,
+					  &link_idr, &link_idr_lock);
+		break;
 	default:
 		err =3D -EINVAL;
 		break;
--=20
2.24.1

