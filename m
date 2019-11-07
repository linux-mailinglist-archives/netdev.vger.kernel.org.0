Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52FCFF2505
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 03:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733057AbfKGCJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 21:09:50 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22542 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732931AbfKGCJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 21:09:50 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA729WDt000395
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 18:09:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Pm4OBjXtr+4JHtqOnewijsLfG459kEE7plr3DtyYGjA=;
 b=B90J/NdcHWgl29Pjzxwf6AZji+PqRchVZXuXLmvPHsoPHQQmdxpJDcNVLD+iJ/33cL0a
 AqVXRW6oIFNO7PZUWQSlkyqOxc9+OHa4A8xSnKmr6vHdR8dIIr3fBM1fPt3GnT9jTIWh
 DyLTLnFxum/7c52j6skdbsc/CcCWz+Wb9bU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u0jk1g-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 18:09:49 -0800
Received: from 2401:db00:2050:5076:face:0:1f:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 Nov 2019 18:09:48 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 3277D2EC17EE; Wed,  6 Nov 2019 18:09:31 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 5/5] libbpf: improve handling of corrupted ELF during map initialization
Date:   Wed, 6 Nov 2019 18:08:55 -0800
Message-ID: <20191107020855.3834758-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107020855.3834758-1-andriin@fb.com>
References: <20191107020855.3834758-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=8 bulkscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0 mlxlogscore=746
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070021
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we get ELF file with "maps" section, but no symbols pointing to it, we'll
end up with division by zero. Add check against this situation and exit early
with error. Found by Coverity scan against Github libbpf sources.

Fixes: bf82927125dd ("libbpf: refactor map initialization")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3ef73a214592..fde6cb3e5d41 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -956,13 +956,13 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
 	pr_debug("maps in %s: %d maps in %zd bytes\n",
 		 obj->path, nr_maps, data->d_size);
 
-	map_def_sz = data->d_size / nr_maps;
-	if (!data->d_size || (data->d_size % nr_maps) != 0) {
+	if (!data->d_size || nr_maps == 0 || (data->d_size % nr_maps) != 0) {
 		pr_warn("unable to determine map definition size "
 			"section %s, %d maps in %zd bytes\n",
 			obj->path, nr_maps, data->d_size);
 		return -EINVAL;
 	}
+	map_def_sz = data->d_size / nr_maps;
 
 	/* Fill obj->maps using data in "maps" section.  */
 	for (i = 0; i < nr_syms; i++) {
-- 
2.17.1

