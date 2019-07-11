Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28E49658F8
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 16:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbfGKO3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 10:29:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45720 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728714AbfGKO3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 10:29:52 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6BETJtU002046
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 10:29:51 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tp49t6x75-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 10:29:51 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Thu, 11 Jul 2019 15:29:49 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 11 Jul 2019 15:29:46 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6BETjNj40960220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:29:45 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1344742047;
        Thu, 11 Jul 2019 14:29:45 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD8B642042;
        Thu, 11 Jul 2019 14:29:44 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.97.237])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Jul 2019 14:29:44 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     ys114321@gmail.com, daniel@iogearbox.net, sdf@fomichev.me,
        davem@davemloft.net, ast@kernel.org,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v4 bpf-next 0/4] selftests/bpf: fix compiling loop{1,2,3}.c on s390
Date:   Thu, 11 Jul 2019 16:29:26 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071114-0012-0000-0000-00000331D695
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071114-0013-0000-0000-0000216B43B7
Message-Id: <20190711142930.68809-1-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=619 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110163
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use PT_REGS_RC(ctx) instead of ctx->rax, which is not present on s390.

This patch series consists of three preparatory commits, which make it
possible to use PT_REGS_RC in BPF selftests, followed by the actual fix.

> > Will this also work for 32-bit x86?
> Thanks, this is a good catch: this builds, but makes 64-bit accesses, as
> if it used the 64-bit variant of pt_regs. I will fix this.
I found four problems in this area:

1. Selftest tracing progs are built with -target bpf, leading to struct
   pt_regs and friends being interpreted incorrectly.
2. When the Makefile is adjusted to build them without -target bpf, it
   still lacks -m32/-m64, leading to a similar issue.
3. There is no __i386__ define, leading to incorrect userspace struct
   pt_regs variant being chosen for x86.
4. Finally, there is an issue in my patch: when 1-3 are fixed, it fails
   to build, since i386 defines yet another set of field names.

I will send fixes for problems 1-3 separately, I believe for this patch
series to be correct, it's enough to fix #4 (which I did by adding
another #ifdef).

I've also changed ARCH to SRCARCH in patch #1, since while ARCH can be
e.g. "i386", SRCARCH always corresponds to directory names under arch/.

v1->v2: Split into multiple patches.
v2->v3: Added arm64 support.
v3->v4: Added i386 support, use SRCARCH instead of ARCH.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>


