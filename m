Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF1524E07D
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 21:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgHUTK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 15:10:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62298 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725801AbgHUTK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 15:10:59 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LJANEu016046
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 12:10:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=Gq6f+lHMjtdNJCXmbSgtDeDyS8XPtUo3QKsyyjIC4yI=;
 b=guONKRU2TI1UMJ7kG4hW+qFq8PTLU4Ivo8HjECw1Hk4wxblRKxO8HU4SL/MrGSeNFHdm
 Uu2SqgjuqQ6dl3aiozq11+TeikG1eemnoxHxqbhQ9+mpjY+3MoW4D6wb84KoNllwxGN2
 VNpIv/O1/tK/kC5/ewT8OnaSBDoiDBmXmHY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 332ehft23x-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 12:10:58 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 21 Aug 2020 12:10:56 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id A5F683704F89; Fri, 21 Aug 2020 12:10:54 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: fix a buffer out-of-bound access when filling raw_tp link_info
Date:   Fri, 21 Aug 2020 12:10:54 -0700
Message-ID: <20200821191054.714731-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_09:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 suspectscore=8 mlxlogscore=932
 phishscore=0 malwarescore=0 impostorscore=0 clxscore=1015 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210179
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit f2e10bff16a0 ("bpf: Add support for BPF_OBJ_GET_INFO_BY_FD for bpf=
_link")
added link query for raw_tp. One of fields in link_info is to
fill a user buffer with tp_name. The Scurrent checking only
declares "ulen && !ubuf" as invalid. So "!ulen && ubuf" will be
valid. Later on, we do "copy_to_user(ubuf, tp_name, ulen - 1)" which
may overwrite user memory incorrectly.

This patch fixed the problem by disallowing "!ulen && ubuf" case as well.

Fixes: f2e10bff16a0 ("bpf: Add support for BPF_OBJ_GET_INFO_BY_FD for bpf=
_link")
Cc: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 86299a292214..ac6c784c0576 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2634,7 +2634,7 @@ static int bpf_raw_tp_link_fill_link_info(const str=
uct bpf_link *link,
 	u32 ulen =3D info->raw_tracepoint.tp_name_len;
 	size_t tp_len =3D strlen(tp_name);
=20
-	if (ulen && !ubuf)
+	if (!ulen ^ !ubuf)
 		return -EINVAL;
=20
 	info->raw_tracepoint.tp_name_len =3D tp_len + 1;
--=20
2.24.1

