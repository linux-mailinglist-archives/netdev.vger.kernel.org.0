Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5862B616C14
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 19:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiKBSZo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Nov 2022 14:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiKBSZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 14:25:32 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EF521820
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 11:25:30 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2HnYfB016821
        for <netdev@vger.kernel.org>; Wed, 2 Nov 2022 11:25:29 -0700
Received: from maileast.thefacebook.com ([163.114.130.8])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kk78s40gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 11:25:29 -0700
Received: from twshared16837.02.prn6.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 11:25:27 -0700
Received: by devbig019.vll3.facebook.com (Postfix, from userid 137359)
        id E6A3420FC7435; Wed,  2 Nov 2022 11:25:19 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: [PATCH bpf 1/2] net/ipv4: fix linux/in.h header dependencies
Date:   Wed, 2 Nov 2022 11:25:16 -0700
Message-ID: <20221102182517.2675301-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: pZa7p5_f1ld_wQz-hdtbmykFNmtg2Nmz
X-Proofpoint-GUID: pZa7p5_f1ld_wQz-hdtbmykFNmtg2Nmz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_14,2022-11-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__DECLARE_FLEX_ARRAY is defined in include/uapi/linux/stddef.h but
doesn't seem to be explicitly included from include/uapi/linux/in.h,
which breaks BPF selftests builds (once we sync linux/stddef.h into
tools/include directory in the next patch). Fix this by explicitly
including linux/stddef.h.

Given this affects BPF CI and bpf tree, targeting this for bpf tree.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Fixes: 5854a09b4957 ("net/ipv4: Use __DECLARE_FLEX_ARRAY() helper")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 include/uapi/linux/in.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index f243ce665f74..07a4cb149305 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -20,6 +20,7 @@
 #define _UAPI_LINUX_IN_H
 
 #include <linux/types.h>
+#include <linux/stddef.h>
 #include <linux/libc-compat.h>
 #include <linux/socket.h>
 
-- 
2.30.2

