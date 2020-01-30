Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5875114D7D6
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 09:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgA3IjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 03:39:04 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46422 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726757AbgA3IjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 03:39:04 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00U8cI2Z012487
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 00:39:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=khsLizDS52/2mfrYczdH1CWnwlOHZD4qPjW+pbJ46BY=;
 b=hhXvAZMqwlxQCagPSlyJ23CL9Eecz9ZnPlIjohbj1nvckMJ2XUrtcNj+ssHB7dsS0qhc
 9gK1CBDq2rQO9NveEPiJOQKa8nuK189cqhb0opgyBxjWu5cDN6SHx9CUxbip97xQ02vn
 yZBedY9D0TpAQb+LKtfNDSuBsiVyRmqGZG8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xufrv2w2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 00:39:03 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 30 Jan 2020 00:39:03 -0800
Received: by devvm4065.prn2.facebook.com (Postfix, from userid 125878)
        id 141E3435B9032; Thu, 30 Jan 2020 00:38:52 -0800 (PST)
Smtp-Origin-Hostprefix: devvm
From:   Yulia Kartseva <hex@fb.com>
Smtp-Origin-Hostname: devvm4065.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <hex@fb.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>
CC:     <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf] runqslower: fix Makefile
Date:   Thu, 30 Jan 2020 00:38:32 -0800
Message-ID: <da8c16011df5628cfc9ddfeaeca2aa5d90be920b.1580373028.git.hex@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-30_02:2020-01-28,2020-01-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 suspectscore=0 mlxscore=0 adultscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001300061
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julia Kartseva <hex@fb.com>

Fixes: 9c01546d26d2 ("tools/bpf: Add runqslower tool to tools/bpf")
Signed-off-by: Julia Kartseva <hex@fb.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>

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

