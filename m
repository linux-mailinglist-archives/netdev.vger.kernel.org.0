Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB2B20DC6
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 19:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfEPRRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 13:17:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38902 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726578AbfEPRRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 13:17:35 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4GH92XY015672
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 10:17:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=iDVF7nPvDmjgI1zFsB5sLrGh7+JT4O38A+kRr4BUbcg=;
 b=RKc3QlcoUgWNTbdv5zqJpC1ShcSPt0Cxa9/cedRedJ9jhnmVz2divUOc28k4r5TtFAuK
 MlFRscPbAxilKZbk3RbafW4NOULXjBq/335I5N4j2448xOhROeE3Es9BvjGhHX0ix+MF
 ruMfAD2uzwY2sU4S0vV1Ti6Dk3PjE+55xE8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2sha70gg1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 10:17:33 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 16 May 2019 10:17:32 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id E3C03370155A; Thu, 16 May 2019 10:17:31 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] tools/bpftool: move set_max_rlimit() before __bpf_object__open_xattr()
Date:   Thu, 16 May 2019 10:17:31 -0700
Message-ID: <20190516171731.2320976-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-16_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905160109
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For a host which has a lower rlimit for max locked memory (e.g., 64KB),
the following error occurs in one of our production systems:
  # /usr/sbin/bpftool prog load /paragon/pods/52877437/home/mark.o \
    /sys/fs/bpf/paragon_mark_21 type cgroup/skb \
    map idx 0 pinned /sys/fs/bpf/paragon_map_21
  libbpf: Error in bpf_object__probe_name():Operation not permitted(1).
    Couldn't load basic 'r0 = 0' BPF program.
  Error: failed to open object file

The reason is due to low locked memory during bpf_object__probe_name()
which probes whether program name is supported in kernel or not
during __bpf_object__open_xattr().

bpftool program load already tries to relax mlock rlimit before
bpf_object__load(). Let us move set_max_rlimit() before
__bpf_object__open_xattr(), which fixed the issue here.

Fixes: 47eff61777c7 ("bpf, libbpf: introduce bpf_object__probe_caps to test BPF capabilities")
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/bpf/bpftool/prog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index fc495b27f0fc..26336bad0442 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -879,6 +879,8 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 		}
 	}
 
+	set_max_rlimit();
+
 	obj = __bpf_object__open_xattr(&attr, bpf_flags);
 	if (IS_ERR_OR_NULL(obj)) {
 		p_err("failed to open object file");
@@ -958,8 +960,6 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 		goto err_close_obj;
 	}
 
-	set_max_rlimit();
-
 	err = bpf_object__load(obj);
 	if (err) {
 		p_err("failed to load object file");
-- 
2.17.1

