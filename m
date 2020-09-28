Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D1127ACF0
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 13:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgI1Lf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 07:35:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49450 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgI1Lf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 07:35:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SBXSpX171185;
        Mon, 28 Sep 2020 11:35:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=AjlZDL8h1zo8RoZGrUHwybadvFLgcaBO8E/XUp46Sq4=;
 b=sDw24zHQuwHitXc9D5y47i1vhbmD5+L8klLWsfWCMN7shrEsB21wXj2NE0JKGlI5pmSS
 zjvyklc/fQnD8X3tqdngy4LZkAO0xUEl9qdip7DzcKPYrcjver+ePj0LHiydc1egGX5Q
 Qv0C/U9qxI5jKczLbrkxyqm8msYNER7Tc/OX/0o+x0Ado7URDKxHmvl2a/Kub3b9/kum
 50+l7uTNuAU+K5WDWm9Wml0ae5tc4VSLqgO/Lc34Tt+UkM76k8hcDvW1Q30cxcif0SkJ
 iPhcsK7YEPpsx6Kj/wHoy3kOZoxJslItvaZPb2tQhrlPhqdKOs1X7olQSfUFxf0koMdB cA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33swkkmf1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 11:35:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SBUSRO058204;
        Mon, 28 Sep 2020 11:33:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33tfhw57st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 11:33:10 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08SBX9UU019107;
        Mon, 28 Sep 2020 11:33:09 GMT
Received: from localhost.uk.oracle.com (/10.175.167.231)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 04:33:07 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com
Cc:     linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, acme@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v7 bpf-next 5/8] bpf: bump iter seq size to support BTF representation of large data structures
Date:   Mon, 28 Sep 2020 12:31:07 +0100
Message-Id: <1601292670-1616-6-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601292670-1616-1-git-send-email-alan.maguire@oracle.com>
References: <1601292670-1616-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF iter size is limited to PAGE_SIZE; if we wish to display BTF-based
representations of larger kernel data structures such as task_struct,
this will be insufficient.

Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 kernel/bpf/bpf_iter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 30833bb..8f10e30 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -88,8 +88,8 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
 	mutex_lock(&seq->lock);
 
 	if (!seq->buf) {
-		seq->size = PAGE_SIZE;
-		seq->buf = kmalloc(seq->size, GFP_KERNEL);
+		seq->size = PAGE_SIZE << 3;
+		seq->buf = kvmalloc(seq->size, GFP_KERNEL);
 		if (!seq->buf) {
 			err = -ENOMEM;
 			goto done;
-- 
1.8.3.1

