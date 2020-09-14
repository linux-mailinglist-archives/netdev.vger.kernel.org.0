Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0442698DB
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 00:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgINWcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 18:32:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53308 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbgINWcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 18:32:14 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08EMV2YB032691
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 15:32:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=tFitJi4poWiSEOOAer/auv9njZ9vWyOJOInyNIPTcNs=;
 b=A4KFVT2PAMczwezMVW+RGx3rq5bIyD/85aPklUPETAuuv+lJmWKaocw9tDeLVOHHzGZV
 6sNRICID7u78cZtqxcPIcoNhiLmP6lV2XeDTwk4gtwaz0ryffI1bIlZZfwJfXB+OTz6p
 SeECVKxmJl8atfnpqge4wwuh+yDaKgtg//I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33guummfte-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 15:32:13 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Sep 2020 15:32:11 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 714FA37059D9; Mon, 14 Sep 2020 15:32:10 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: [PATCH bpf-next] libbpf: fix a compilation error with xsk.c for ubuntu 16.04
Date:   Mon, 14 Sep 2020 15:32:10 -0700
Message-ID: <20200914223210.1831262-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_09:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=951 phishscore=0 adultscore=0
 suspectscore=8 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009140170
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When syncing latest libbpf repo to bcc, ubuntu 16.04 (4.4.0 LTS kernel)
failed compilation for xsk.c:
  In file included from /tmp/debuild.0jkauG/bcc/src/cc/libbpf/src/xsk.c:2=
3:0:
  /tmp/debuild.0jkauG/bcc/src/cc/libbpf/src/xsk.c: In function =E2=80=98x=
sk_get_ctx=E2=80=99:
  /tmp/debuild.0jkauG/bcc/src/cc/libbpf/include/linux/list.h:81:9: warnin=
g: implicit
  declaration of function =E2=80=98container_of=E2=80=99 [-Wimplicit-func=
tion-declaration]
           container_of(ptr, type, member)
           ^
  /tmp/debuild.0jkauG/bcc/src/cc/libbpf/include/linux/list.h:83:9: note: =
in expansion
  of macro =E2=80=98list_entry=E2=80=99
           list_entry((ptr)->next, type, member)
  ...
  src/cc/CMakeFiles/bpf-static.dir/build.make:209: recipe for target
  'src/cc/CMakeFiles/bpf-static.dir/libbpf/src/xsk.c.o' failed

Commit 2f6324a3937f ("libbpf: Support shared umems between queues and dev=
ices")
added include file <linux/list.h>, which uses macro "container_of".
xsk.c file also includes <linux/ethtool.h> before <linux/list.h>.

In a more recent distro kernel, <linux/ethtool.h> includes <linux/kernel.=
h>
which contains the macro definition for "container_of". So compilation is=
 all fine.
But in ubuntu 16.04 kernel, <linux/ethtool.h> does not contain <linux/ker=
nel.h>
which caused the above compilation error.

Let explicitly add <linux/kernel.h> in xsk.c to avoid compilation error
in old distro's.

Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and dev=
ices")
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/lib/bpf/xsk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 49c324594792..30b4ca5d2ac7 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -20,6 +20,7 @@
 #include <linux/if_ether.h>
 #include <linux/if_packet.h>
 #include <linux/if_xdp.h>
+#include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/sockios.h>
 #include <net/if.h>
--=20
2.24.1

