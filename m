Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF9F1DE550
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 13:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729480AbgEVLZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 07:25:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48006 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728281AbgEVLZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 07:25:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MBI0U7108599;
        Fri, 22 May 2020 11:24:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=Dp/WCIWRjQgCLBrcUEQBV8a2eOIJeoHqdBAAyFlUI0k=;
 b=NkCtSpuIbkE4MJlDL6xPc5RWPFDIjUIBxszsArdjhVsGff1t0Og2BkC30W46/zR7uEha
 U1zbX5dEyPEGyYiL6AUNH6XKSZ+aRuUgg5Q85OACbSbpik317baGcECCCEyQX0y1yQWG
 0WV1xqHCikAEWlthG/+0/sQuC4LuCY4ryXIWqcYhu0UiVbRtWHCKFDVgwBkBR+UgG+Sy
 +zAiTmu/dQZxSu1LeUN2ErYABcZWSa9UqHpk7R/46wm606hrb2fUvTpztZKBL4hHPiUG
 hxkc3n4oh3GnKWCkn+p7MNgIe5/LujhVa1UqHi2ZRgrMECHWGqFoFsIyoTm8zfbvXAbM IA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31284md81f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 11:24:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MBNHTT127015;
        Fri, 22 May 2020 11:24:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 312t3e9563-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 11:24:55 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04MBOpRB020735;
        Fri, 22 May 2020 11:24:52 GMT
Received: from localhost.uk.oracle.com (/10.175.194.37)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 04:24:51 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com
Cc:     kafai@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        shuah@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH] selftests/bpf: add general instructions for test execution
Date:   Fri, 22 May 2020 12:24:34 +0100
Message-Id: <1590146674-25485-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005220093
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Getting a clean BPF selftests run involves ensuring latest trunk LLVM/clang
are used, pahole is recent (>=1.16) and config matches the specified
config file as closely as possible.  Add to bpf_devel_QA.rst and point
tools/testing/selftests/bpf/README.rst to it.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 Documentation/bpf/bpf_devel_QA.rst     | 15 +++++++++++++++
 tools/testing/selftests/bpf/README.rst |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
index 38c15c6..0b3db91 100644
--- a/Documentation/bpf/bpf_devel_QA.rst
+++ b/Documentation/bpf/bpf_devel_QA.rst
@@ -437,6 +437,21 @@ needed::
 See the kernels selftest `Documentation/dev-tools/kselftest.rst`_
 document for further documentation.
 
+To maximize the number of tests passing, the .config of the kernel
+under test should match the config file fragment in
+tools/testing/selftests/bpf as closely as possible.
+
+Finally to ensure support for latest BPF Type Format features -
+discussed in `Documentation/bpf/btf.rst`_ - pahole version 1.16
+is required for kernels built with CONFIG_DEBUG_INFO_BTF=y.
+pahole is delivered in the dwarves package or can be built
+from source at
+
+https://github.com/acmel/dwarves
+
+Some distros have pahole version 1.16 packaged already, e.g.
+Fedora, Gentoo.
+
 Q: Which BPF kernel selftests version should I run my kernel against?
 ---------------------------------------------------------------------
 A: If you run a kernel ``xyz``, then always run the BPF kernel selftests
diff --git a/tools/testing/selftests/bpf/README.rst b/tools/testing/selftests/bpf/README.rst
index 0f67f1b..e885d35 100644
--- a/tools/testing/selftests/bpf/README.rst
+++ b/tools/testing/selftests/bpf/README.rst
@@ -1,6 +1,8 @@
 ==================
 BPF Selftest Notes
 ==================
+General instructions on running selftests can be found in
+`Documentation/bpf/bpf_devel_QA.rst`_.
 
 Additional information about selftest failures are
 documented here.
-- 
1.8.3.1

