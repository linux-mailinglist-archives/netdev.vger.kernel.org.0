Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3400317F77F
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 13:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgCJMdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 08:33:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15464 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726269AbgCJMdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 08:33:52 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ACLSs0080518
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 08:33:51 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ynraxm763-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 08:33:51 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <svens@linux.ibm.com>;
        Tue, 10 Mar 2020 12:33:49 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 10 Mar 2020 12:33:44 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02ACXh9i29753594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 12:33:43 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C05504204F;
        Tue, 10 Mar 2020 12:33:43 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B58D24204C;
        Tue, 10 Mar 2020 12:33:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 10 Mar 2020 12:33:43 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55390)
        id 289ABE19C3; Tue, 10 Mar 2020 13:33:43 +0100 (CET)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] seccomp: add compat_ioctl for seccomp notify
Date:   Tue, 10 Mar 2020 13:33:32 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20031012-0020-0000-0000-000003B24E93
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031012-0021-0000-0000-0000220A9A2B
Message-Id: <20200310123332.42255-1-svens@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_06:2020-03-10,2020-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 mlxscore=0
 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1011
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003100083
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

executing the seccomp_bpf testsuite with 32 bit userland (both s390 and x86)
doesn't work because there's no compat_ioctl handler defined. Is that something
that is supposed to work? Disclaimer: I don't know enough about seccomp to judge
whether there would be some adjustments required in the compat ioctl handler.
Just setting it to seccomp_notify_ioctl() makes the testsuite pass, but i'm not
sure whether that's correct.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
---
 kernel/seccomp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index b6ea3dcb57bf..683c81e4861e 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1221,6 +1221,7 @@ static const struct file_operations seccomp_notify_ops = {
 	.poll = seccomp_notify_poll,
 	.release = seccomp_notify_release,
 	.unlocked_ioctl = seccomp_notify_ioctl,
+	.compat_ioctl = seccomp_notify_ioctl,
 };
 
 static struct file *init_listener(struct seccomp_filter *filter)
-- 
2.17.1

