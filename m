Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1889663873
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 17:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfGIPSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 11:18:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20066 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726197AbfGIPSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 11:18:23 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69FEkRG001194
        for <netdev@vger.kernel.org>; Tue, 9 Jul 2019 11:18:22 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tmurvw5bf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 11:18:22 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Tue, 9 Jul 2019 16:18:20 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 9 Jul 2019 16:18:17 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x69FIGQB30474346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jul 2019 15:18:16 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6ABBD42045;
        Tue,  9 Jul 2019 15:18:16 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C1A242041;
        Tue,  9 Jul 2019 15:18:16 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.145.146.163])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Jul 2019 15:18:16 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     sdf@fomichev.me, ys114321@gmail.com, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v3 bpf-next 0/4] selftests/bpf: fix compiling loop{1,2,3}.c on s390
Date:   Tue,  9 Jul 2019 17:18:05 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19070915-0028-0000-0000-0000038257DC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070915-0029-0000-0000-0000244264E1
Message-Id: <20190709151809.37539-1-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=661 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907090180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use PT_REGS_RC(ctx) instead of ctx->rax, which is not present on s390.

This patch series consists of three preparatory commits, which make it
possible to use PT_REGS_RC in BPF selftests, followed by the actual fix.

Since the last time, I've tested it with x86_64-linux-gnu-,
aarch64-linux-gnu-, arm-linux-gnueabihf-, mips64el-linux-gnuabi64-,
powerpc64le-linux-gnu-, s390x-linux-gnu- and sparc64-linux-gnu-
compilers, and found that I also need to add arm64 support.

Like s390, arm64 exports user_pt_regs instead of struct pt_regs to
userspace.

I've also made fixes for a few unrelated build problems, which I will
post separately.

v1->v2: Split into multiple patches.
v2->v3: Added arm64 support.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>


