Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C150342F57
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfFLSvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:51:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54206 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725497AbfFLSvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:51:54 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CIlrA3176787
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 14:51:52 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t33v9r1um-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 14:51:52 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <naveen.n.rao@linux.vnet.ibm.com>;
        Wed, 12 Jun 2019 19:51:50 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 12 Jun 2019 19:51:47 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5CIpkEo57475216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 18:51:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E529911C04A;
        Wed, 12 Jun 2019 18:51:45 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9138C11C050;
        Wed, 12 Jun 2019 18:51:43 +0000 (GMT)
Received: from naverao1-tp.ibmuc.com (unknown [9.199.37.223])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jun 2019 18:51:43 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH 0/2] powerpc/bpf: DIV64 instruction fix
Date:   Thu, 13 Jun 2019 00:21:38 +0530
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19061218-4275-0000-0000-00000341C5F3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061218-4276-0000-0000-00003851DD44
Message-Id: <cover.1560364574.git.naveen.n.rao@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=509 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120127
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch updates DIV64 overflow tests to properly detect error 
conditions. The second patch fixes powerpc64 JIT to generate the proper 
unsigned division instruction for BPF_ALU64.

- Naveen

Naveen N. Rao (2):
  bpf: fix div64 overflow tests to properly detect errors
  powerpc/bpf: use unsigned division instruction for 64-bit operations

 arch/powerpc/include/asm/ppc-opcode.h              |  1 +
 arch/powerpc/net/bpf_jit.h                         |  2 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |  8 ++++----
 .../testing/selftests/bpf/verifier/div_overflow.c  | 14 ++++++++++----
 4 files changed, 16 insertions(+), 9 deletions(-)

-- 
2.21.0

