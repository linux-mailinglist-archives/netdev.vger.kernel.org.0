Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93C0758B84
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 22:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfF0UTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 16:19:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59008 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726616AbfF0UTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 16:19:45 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RKHUsN018049
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 13:19:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=XKJ6Yj46urGmUPHQW0EEETjfYj0CehU24b6YzaBJaxE=;
 b=c4k6/Tjg8hir1cvNokmg2jy/rOrbxZ12b8MtXtBLW00qhUB0FEF+WSlPtWcMju9gdiTY
 7aCtOd0sTJzZdLl4GH7saoeDIShblCPt2ngfwTfumpo5MeA7EHWjm2Sk09DW8wWNwIQR
 E5gKdDFECsG4F4aj3O11jGS1Ht5K6hljVVk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2td03ws8v0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 13:19:44 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 27 Jun 2019 13:19:43 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 6CED162E2BE1; Thu, 27 Jun 2019 13:19:40 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <lmb@cloudflare.com>, <jannh@google.com>,
        <gregkh@linuxfoundation.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 4/4] bpftool: use libbpf_[enable|disable]_sys_bpf()
Date:   Thu, 27 Jun 2019 13:19:23 -0700
Message-ID: <20190627201923.2589391-5-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627201923.2589391-1-songliubraving@fb.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=472 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270233
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch calls libbpf_[enable|disable]_sys_bpf() from bpftool. This
allows users with access to /dev/bpf to perform operations like root.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/bpf/bpftool/feature.c | 2 +-
 tools/bpf/bpftool/main.c    | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index d672d9086fff..772c9f445d34 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -583,7 +583,7 @@ static int do_probe(int argc, char **argv)
 	/* Detection assumes user has sufficient privileges (CAP_SYS_ADMIN).
 	 * Let's approximate, and restrict usage to root user only.
 	 */
-	if (geteuid()) {
+	if (!libbpf_enable_sys_bpf()) {
 		p_err("please run this command as root user");
 		return -1;
 	}
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 4879f6395c7e..56959c5ac552 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -390,6 +390,10 @@ int main(int argc, char **argv)
 	if (argc < 0)
 		usage();
 
+	if (!libbpf_enable_sys_bpf()) {
+		p_err("cannot enable access to sys_bpf()");
+		usage();
+	}
 	ret = cmd_select(cmds, argc, argv, do_help);
 
 	if (json_output)
@@ -400,5 +404,6 @@ int main(int argc, char **argv)
 		delete_pinned_obj_table(&map_table);
 	}
 
+	libbpf_disable_sys_bpf();
 	return ret;
 }
-- 
2.17.1

