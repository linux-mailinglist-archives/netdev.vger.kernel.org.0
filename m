Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 036995571E
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732937AbfFYSXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:23:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19916 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732933AbfFYSXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 14:23:20 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5PI425N009315
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 11:23:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=lKbl06bvlMWqo/+mnDQ62Ep/fWZPZ9o1+oEgsQFvJf0=;
 b=Ox9xgiHeAwjdO8j508nM+2R767tXdZ/NfCeja1EuXhWsV/sXv1pUW53N98JPniNBeMFt
 v4VwTbDwZ31EWS4bJwkkIb5R5kFBJAzAG97kHsFkX202y/QEzsJwOJmISh4VxgAlIzVI
 OM5U4JKH1SXSsyQd8HpOE/h0nqqry+FgXk8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tbhb89txs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 11:23:19 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 25 Jun 2019 11:23:18 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 5136F62E1DB8; Tue, 25 Jun 2019 11:23:15 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 4/4] bpftool: use libbpf_[get|put]_bpf_permission()
Date:   Tue, 25 Jun 2019 11:23:03 -0700
Message-ID: <20190625182303.874270-5-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190625182303.874270-1-songliubraving@fb.com>
References: <20190625182303.874270-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=669 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250137
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch calls libbpf_[get|put]_bpf_permission() from bpftool. This
allows users with access to /dev/bpf to perform operations like root.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/bpf/bpftool/feature.c | 2 +-
 tools/bpf/bpftool/main.c    | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index d672d9086fff..f7f43b91ce96 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -583,7 +583,7 @@ static int do_probe(int argc, char **argv)
 	/* Detection assumes user has sufficient privileges (CAP_SYS_ADMIN).
 	 * Let's approximate, and restrict usage to root user only.
 	 */
-	if (geteuid()) {
+	if (!libbpf_get_bpf_permission()) {
 		p_err("please run this command as root user");
 		return -1;
 	}
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 4879f6395c7e..f9146d7d8fc5 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -390,6 +390,10 @@ int main(int argc, char **argv)
 	if (argc < 0)
 		usage();
 
+	if (!libbpf_get_bpf_permission()) {
+		p_err("cannot get permission to access bpf() syscall");
+		usage();
+	}
 	ret = cmd_select(cmds, argc, argv, do_help);
 
 	if (json_output)
@@ -400,5 +404,6 @@ int main(int argc, char **argv)
 		delete_pinned_obj_table(&map_table);
 	}
 
+	libbpf_put_bpf_permission();
 	return ret;
 }
-- 
2.17.1

