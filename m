Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0F31ADB52
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 12:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgDQKnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 06:43:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50038 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728868AbgDQKnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 06:43:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HAfpfA009360;
        Fri, 17 Apr 2020 10:42:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=YIWoAje0qyhjK/2S/YVkAhxEbVPEDjaDZZ11p5pY6GU=;
 b=HkFdGJH+/AZVhHlv/JLptPFLKdNcdq6cte+H53h/7Ha2m0W8BoZIKGy3BA2QIoVtORaY
 TWVgyo0PznY3lu4dYyhznj0YDn3LOkaTwaB5ziXWjh/NRLFjHwXXAwp/hg+CH6O6gbfJ
 TvULyc/4ISDCV7QpnuktZaYeinkixQPTFlLeDw1YXsWjGft5Yh82j92SRCEe2D1T9XRU
 K0yPrh0v8EojQiU78xxLQVn4LEDCYGlLXq3ZR+uTa2iwbAnxcqqmzHIh/Q1b3j6l9YhB
 vr+KvGKB36kf9QxSZxo1OWTGy12o17gFy3be6sYBKEGn8036FRaZboMJn/fwbXlnVj4e Nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30e0aaby11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 10:42:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HAc4Wp018976;
        Fri, 17 Apr 2020 10:42:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30dyp28b89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 10:42:58 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03HAgu6a015831;
        Fri, 17 Apr 2020 10:42:57 GMT
Received: from localhost.uk.oracle.com (/10.175.205.33)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 03:42:56 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com
Cc:     kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC PATCH bpf-next 2/6] bpf: btf->resolved_[ids,sizes] should not be used for vmlinux BTF
Date:   Fri, 17 Apr 2020 11:42:36 +0100
Message-Id: <1587120160-3030-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
References: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170084
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011
 impostorscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170084
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When testing support for print data structures using patches
later in this series, I hit NULL pointer dereference bugs when
printing "struct sk_buff". The problem seems to revolve around
that structure's use of a zero-length array in the middle of
the data structure - headers_start[0].

We see in btf_type_id_size() we consult btf->resolved_ids and
btf->resolved_sizes; both of which are not used in kernel
vmlinux BTF so should not be used when handling vmlinux
BTF data.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 kernel/bpf/btf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 50080ad..a474839 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1170,7 +1170,7 @@ const struct btf_type *btf_type_id_size(const struct btf *btf,
 
 	if (btf_type_has_size(size_type)) {
 		size = size_type->size;
-	} else if (btf_type_is_array(size_type)) {
+	} else if (btf_type_is_array(size_type) && btf->resolved_sizes) {
 		size = btf->resolved_sizes[size_type_id];
 	} else if (btf_type_is_ptr(size_type)) {
 		size = sizeof(void *);
@@ -1179,6 +1179,9 @@ const struct btf_type *btf_type_id_size(const struct btf *btf,
 				 !btf_type_is_var(size_type)))
 			return NULL;
 
+		if (!btf->resolved_ids)
+			return NULL;
+
 		size_type_id = btf->resolved_ids[size_type_id];
 		size_type = btf_type_by_id(btf, size_type_id);
 		if (btf_type_nosize_or_null(size_type))
-- 
1.8.3.1

