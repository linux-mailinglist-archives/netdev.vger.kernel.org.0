Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD0906CF95
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 16:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbfGROUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 10:20:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24238 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726715AbfGROUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 10:20:52 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6IEI51M039544
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 10:20:50 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ttsg32ym6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 10:20:50 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Thu, 18 Jul 2019 15:20:49 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 18 Jul 2019 15:20:46 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6IEKVW037224742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jul 2019 14:20:31 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D697FA4060;
        Thu, 18 Jul 2019 14:20:44 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A07BFA4054;
        Thu, 18 Jul 2019 14:20:44 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.99.77])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Jul 2019 14:20:44 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, lmb@cloudflare.com
Cc:     gor@linux.ibm.com, heiko.carstens@de.ibm.com,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH bpf] tools/bpf: fix bpftool build with OUTPUT set
Date:   Thu, 18 Jul 2019 16:20:41 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <CACAyw9-CWRHVH3TJ=Tke2x8YiLsH47sLCijdp=V+5M836R9aAA@mail.gmail.com>
References: <CACAyw9-CWRHVH3TJ=Tke2x8YiLsH47sLCijdp=V+5M836R9aAA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071814-0008-0000-0000-000002FEB310
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071814-0009-0000-0000-0000226C31C1
Message-Id: <20190718142041.83342-1-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-18_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907180149
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenz,

I've been using the following patch for quite some time now.
Please let me know if it works for you.

Best regards,
Ilya

---

When OUTPUT is set, bpftool and libbpf put their objects into the same
directory, and since some of them have the same names, the collision
happens.

Fix by invoking libbpf build in a manner similar to $(call descend) -
descend itself cannot be used, since libbpf is a sibling, and not a
child, of bpftool.

Also, don't link bpftool with libbpf.a twice.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 tools/bpf/bpftool/Makefile | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index a7afea4dec47..2cbc3c166f44 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -15,23 +15,18 @@ else
 endif
 
 BPF_DIR = $(srctree)/tools/lib/bpf/
-
-ifneq ($(OUTPUT),)
-  BPF_PATH = $(OUTPUT)
-else
-  BPF_PATH = $(BPF_DIR)
-endif
-
-LIBBPF = $(BPF_PATH)libbpf.a
+BPF_PATH = $(objtree)/tools/lib/bpf
+LIBBPF = $(BPF_PATH)/libbpf.a
 
 BPFTOOL_VERSION := $(shell make --no-print-directory -sC ../../.. kernelversion)
 
 $(LIBBPF): FORCE
-	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(OUTPUT) $(OUTPUT)libbpf.a
+	$(Q)mkdir -p $(BPF_PATH)
+	$(Q)$(MAKE) $(COMMAND_O) subdir=tools/lib/bpf -C $(BPF_DIR) $(LIBBPF)
 
 $(LIBBPF)-clean:
 	$(call QUIET_CLEAN, libbpf)
-	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(OUTPUT) clean >/dev/null
+	$(Q)$(MAKE) $(COMMAND_O) subdir=tools/lib/bpf -C $(BPF_DIR) clean >/dev/null
 
 prefix ?= /usr/local
 bash_compdir ?= /usr/share/bash-completion/completions
@@ -112,7 +107,7 @@ $(OUTPUT)disasm.o: $(srctree)/kernel/bpf/disasm.c
 	$(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<
 
 $(OUTPUT)bpftool: $(OBJS) $(LIBBPF)
-	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)
+	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)
 
 $(OUTPUT)%.o: %.c
 	$(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<
-- 
2.21.0

