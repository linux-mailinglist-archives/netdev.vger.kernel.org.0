Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A42881749FB
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 00:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbgB2XL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 18:11:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28854 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727508AbgB2XL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 18:11:27 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01TN6BmG029990
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 15:11:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=3qHvc/GTY8saMSHNu4RopweqTiFYNaC1ry7FeqNCADM=;
 b=QbKhVn71jExjXPN/EDwHq/hRGIDo4KCgbCSLN5g/4gkovCTJ8Gef+YsNk7y7RJ+Sgqwd
 Wp8PoRa0EQGsUwna/Gwku57lWAncCiH/KQWEEPAZ65x6zXd3CjtKCNGZWmvcl9R6ZWKo
 BsYk+EOJHfncUBio4VbhiR8rnNgryT4mJGw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yfmvgt5qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 15:11:26 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sat, 29 Feb 2020 15:11:25 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 157182EC2C66; Sat, 29 Feb 2020 15:11:19 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/4] libbpf: fix use of PT_REGS_PARM macros with vmlinux.h
Date:   Sat, 29 Feb 2020 15:11:10 -0800
Message-ID: <20200229231112.1240137-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200229231112.1240137-1-andriin@fb.com>
References: <20200229231112.1240137-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-29_09:2020-02-28,2020-02-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0 adultscore=0
 clxscore=1015 phishscore=0 malwarescore=0 mlxlogscore=588 suspectscore=8
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002290180
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add detection of vmlinux.h to bpf_tracing.h header for PT_REGS macro.
Currently, BPF applications have to define __KERNEL__ symbol to use correct
definition of struct pt_regs on x86 arch. This is due to different field names
under internal kernel vs UAPI conditions. To make this more transparent for
users, detect vmlinux.h by checking __VMLINUX_H__ symbol.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf_tracing.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index b0dafe8b4ebc..8376f22b0e36 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -49,7 +49,7 @@
 
 #if defined(bpf_target_x86)
 
-#ifdef __KERNEL__
+#if defined(__KERNEL__) || defined(__VMLINUX_H__)
 #define PT_REGS_PARM1(x) ((x)->di)
 #define PT_REGS_PARM2(x) ((x)->si)
 #define PT_REGS_PARM3(x) ((x)->dx)
-- 
2.17.1

