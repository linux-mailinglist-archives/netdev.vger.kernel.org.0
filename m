Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4773593C2
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 07:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfF1FxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 01:53:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45444 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726711AbfF1FxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 01:53:17 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5S5i7oH003002
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 22:53:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=hDdVY7FbzX3PwnmllXW9OKt6NpciXVZNiITPU3cOP5c=;
 b=B6jhk03JOBQOCODsZDui81QTOMfuyBJ5ImSG5K9ntFrroU6Ufhgfg5HWrPDSBe60wVF3
 vtkUBEto+wSwV/eC49ZJHR9RxAxK0AxFdcMI6WeWZwDK9MTNum6e+3TlwwistgCxWMSy
 99rLEvn0d/ZQMasyRXfwibAjGC9aembwuR0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2td37dsvht-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 22:53:16 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 27 Jun 2019 22:53:12 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 862A3861468; Thu, 27 Jun 2019 22:53:11 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <sdf@fomichev.me>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 1/9] libbpf: make libbpf_strerror_r agnostic to sign of error
Date:   Thu, 27 Jun 2019 22:52:55 -0700
Message-ID: <20190628055303.1249758-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628055303.1249758-1-andriin@fb.com>
References: <20190628055303.1249758-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=747 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280065
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's often inconvenient to switch sign of error when passing it into
libbpf_strerror_r. It's better for it to handle that automatically.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
---
 tools/lib/bpf/str_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/str_error.c b/tools/lib/bpf/str_error.c
index 00e48ac5b806..b8064eedc177 100644
--- a/tools/lib/bpf/str_error.c
+++ b/tools/lib/bpf/str_error.c
@@ -11,7 +11,7 @@
  */
 char *libbpf_strerror_r(int err, char *dst, int len)
 {
-	int ret = strerror_r(err, dst, len);
+	int ret = strerror_r(err < 0 ? -err : err, dst, len);
 	if (ret)
 		snprintf(dst, len, "ERROR: strerror_r(%d)=%d", err, ret);
 	return dst;
-- 
2.17.1

