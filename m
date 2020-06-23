Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA302051EB
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 14:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732678AbgFWMKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 08:10:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51536 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732659AbgFWMKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 08:10:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NC7k6W165344;
        Tue, 23 Jun 2020 12:09:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=U/MyKEjjQ1gJn14dZA24EpgO4l+oS9LvjkoZUD9Bgxk=;
 b=q7z/Z9/No401poC2lOClx5e9E/UNi/J3v7D/8YPFdU4aJ8oPOlvG8s93lsYwXRexbNc+
 PCYzMGhKuh4A0RE5iFzP1MswqYO9j511cEUsGpbSy9R7VI/igm0JkGZiuntMZHBU/Dbj
 Igkc0xHAuOokBgykcF39kDMYjLaCch6HjEYPniOM2HswTdb4KOGMTnii5HLlKav2bL70
 s/5EohAiWPbAc4wfybOXQxjmfK/H7cTgtGmH28l5J0HOExjvWa2+avDtTGhABuTLohZv
 yUBWPyRjy6udkoV1A+XSoPzrYVgYei74+VKwF6ERC1nHsv+eoa63D8nE5qPQPvGvn0hJ hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31sebbmtu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 12:09:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NC80BY143699;
        Tue, 23 Jun 2020 12:09:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31svc4103m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 12:09:25 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05NC9NDt018722;
        Tue, 23 Jun 2020 12:09:23 GMT
Received: from localhost.uk.oracle.com (/10.175.166.3)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 12:09:23 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, andriin@fb.com,
        arnaldo.melo@gmail.com
Cc:     kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux@rasmusvillemoes.dk, joe@perches.com,
        pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, andriy.shevchenko@linux.intel.com,
        corbet@lwn.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v3 bpf-next 5/8] printk: initialize vmlinux BTF outside of printk in late_initcall()
Date:   Tue, 23 Jun 2020 13:07:08 +0100
Message-Id: <1592914031-31049-6-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
References: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 adultscore=0 impostorscore=0 cotscore=-2147483648 mlxscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006230097
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vmlinux BTF initialization can take time so it's best to do that
outside of printk context; otherwise the first printk() using %pT
will trigger BTF initialization.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 lib/vsprintf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index c0d209d..8ac136a 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -3628,3 +3628,15 @@ int sscanf(const char *buf, const char *fmt, ...)
 	return i;
 }
 EXPORT_SYMBOL(sscanf);
+
+/*
+ * Initialize vmlinux BTF as it may be used by printk()s and it's better
+ * to incur the cost of initialization outside of printk context.
+ */
+static int __init init_btf_vmlinux(void)
+{
+	(void) bpf_get_btf_vmlinux();
+
+	return 0;
+}
+late_initcall(init_btf_vmlinux);
-- 
1.8.3.1

