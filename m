Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B363E14010A
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 01:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbgAQAlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 19:41:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22638 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726925AbgAQAlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 19:41:09 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00H0ekX5013285
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 16:41:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=OIK0nGQttnwsrA0P1KDa219DcaSHxTSwYYVHr6JOWbc=;
 b=HRI0pKnzvX6oryfGLMR042zlUtyaUHP9DLi1fjIQ6bKAhk+qHVM0BJ0iv0QQCCF0zJAn
 +X7rWyRRHvVn6FAQzzUS1bi2kvEQxS0APsY658Zjbca6y5UZ/fPwkhhARaJvTrW0/ecx
 aY/UlL5iP3/Kluh0UBYP3WYdA/DSrsFSyUM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xk0sxgdn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 16:41:08 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 16 Jan 2020 16:41:08 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7D5012EC18D7; Thu, 16 Jan 2020 16:41:04 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: revert bpf_helper_defs.h inclusion regression
Date:   Thu, 16 Jan 2020 16:41:02 -0800
Message-ID: <20200117004103.148068-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_06:2020-01-16,2020-01-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 mlxlogscore=781 priorityscore=1501 phishscore=0 mlxscore=0 malwarescore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001170004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Revert bpf_helpers.h's change to include auto-generated bpf_helper_defs.h
through <> instead of "", which causes it to be searched in include path.=
 This
can break existing applications that don't have their include path pointi=
ng
directly to where libbpf installs its headers.

There is ongoing work to make all (not just bpf_helper_defs.h) includes m=
ore
consistent across libbpf and its consumers, but this unbreaks user code a=
s is
right now without any regressions. Selftests still behave sub-optimally
(taking bpf_helper_defs.h from libbpf's source directory, if it's present
there), which will be fixed in subsequent patches.

Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are taken f=
rom selftests dir")
Reported-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf_helpers.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 050bb7bf5be6..f69cc208778a 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -2,7 +2,7 @@
 #ifndef __BPF_HELPERS__
 #define __BPF_HELPERS__
=20
-#include <bpf_helper_defs.h>
+#include "bpf_helper_defs.h"
=20
 #define __uint(name, val) int (*name)[val]
 #define __type(name, val) typeof(val) *name
--=20
2.17.1

