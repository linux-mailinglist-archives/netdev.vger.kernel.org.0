Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 309E7F2733
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfKGFli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:41:38 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36210 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725938AbfKGFli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:41:38 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA75cUO2028645
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 21:41:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=xT9c5WXsY/u7B/iMMKsPZxGpGWSoy/2SqAGfSKxlDAs=;
 b=PrTSVxaojH1LZ2XLo56vGf0g4xFvhBIuzIbn8PkSL1BjBnwN/byTZmWwx2lXdWi/1v6y
 zOaX5o4dPify0oNZketFHylKYV8davXuBUhuVcGVGC0MHoRnfpAqCgs+cVoK7JR5bHRA
 ZFOcppsUAnGCuJtWt715UGbfAQNZlHWemkM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41w6ue3h-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 21:41:38 -0800
Received: from 2401:db00:2050:5076:face:0:1f:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 6 Nov 2019 21:41:10 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 53D122EC1967; Wed,  6 Nov 2019 21:41:08 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <jonathan.lemon@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: fix negative FD close() in xsk_setup_xdp_prog()
Date:   Wed, 6 Nov 2019 21:40:59 -0800
Message-ID: <20191107054059.313884-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 phishscore=0 mlxscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 adultscore=0 priorityscore=1501 suspectscore=8 spamscore=0 mlxlogscore=697
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070058
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix issue reported by static analysis (Coverity). If bpf_prog_get_fd_by_id()
fails, xsk_lookup_bpf_maps() will fail as well and clean-up code will attempt
close() with fd=-1. Fix by checking bpf_prog_get_fd_by_id() return result and
exiting early.

Fixes: 10a13bb40e54 ("libbpf: remove qidconf and better support external bpf programs.")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/xsk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 74d84f36a5b2..86c1b61017f6 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -553,6 +553,8 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
 		}
 	} else {
 		xsk->prog_fd = bpf_prog_get_fd_by_id(prog_id);
+		if (xsk->prog_fd < 0)
+			return -errno;
 		err = xsk_lookup_bpf_maps(xsk);
 		if (err) {
 			close(xsk->prog_fd);
-- 
2.17.1

