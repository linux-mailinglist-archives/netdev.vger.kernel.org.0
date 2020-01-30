Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0756A14E610
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 00:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgA3XOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 18:14:02 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55634 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726514AbgA3XOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 18:14:01 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00UNCc0j020952
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 15:14:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=M2ou81ydmmoTZgHSTTmafq1nYY9oLuj23NWIe0+21PE=;
 b=MLMKeorxegIW/tvdOH56pw/WFhsqqgbsy39zC7gPFQEraE1lh8DABZd3yhIFyr9hKwGP
 7qdDI4BkBw0PI7+m/IkTR/bToMLsE3ouxy6Da7WURjvnC0+MTm1J+yCggf7fxCxxi1Zk
 KxMDU9kVcXX9sFxc4fPaEN3vF4I4fMDXdNI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2xv76urddh-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 15:14:00 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 30 Jan 2020 15:13:59 -0800
Received: by devvm4065.prn2.facebook.com (Postfix, from userid 125878)
        id 0FD18436553EC; Thu, 30 Jan 2020 15:13:57 -0800 (PST)
Smtp-Origin-Hostprefix: devvm
From:   Yulia Kartseva <hex@fb.com>
Smtp-Origin-Hostname: devvm4065.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <hex@fb.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>
CC:     <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf] runqslower: fix Makefile
Date:   Thu, 30 Jan 2020 15:13:10 -0800
Message-ID: <908498f794661c44dca54da9e09dc0c382df6fcb.1580425879.git.hex@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-30_09:2020-01-30,2020-01-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001300155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix undefined reference linker errors when building runqslower with
gcc 7.4.0 on Ubuntu 18.04.
The issue is with misplaced -lelf, -lz options in Makefile:
$(Q)$(CC) $(CFLAGS) -lelf -lz $^ -o $@

-lelf, -lz options should follow the list of target dependencies:
$(Q)$(CC) $(CFLAGS) $^ -lelf -lz -o $@
or after substitution
cc -g -Wall runqslower.o libbpf.a -lelf -lz -o runqslower

The current order of gcc params causes failure in libelf symbols resolution,
e.g. undefined reference to `elf_memory'

Fixes: 9c01546d26d2 ("tools/bpf: Add runqslower tool to tools/bpf")
Signed-off-by: Julia Kartseva <hex@fb.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/runqslower/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
index 0c021352b..87eae5be9 100644
--- a/tools/bpf/runqslower/Makefile
+++ b/tools/bpf/runqslower/Makefile
@@ -41,7 +41,7 @@ clean:
 
 $(OUTPUT)/runqslower: $(OUTPUT)/runqslower.o $(BPFOBJ)
 	$(call msg,BINARY,$@)
-	$(Q)$(CC) $(CFLAGS) -lelf -lz $^ -o $@
+	$(Q)$(CC) $(CFLAGS) $^ -lelf -lz -o $@
 
 $(OUTPUT)/runqslower.o: runqslower.h $(OUTPUT)/runqslower.skel.h	      \
 			$(OUTPUT)/runqslower.bpf.o
-- 
2.17.1

