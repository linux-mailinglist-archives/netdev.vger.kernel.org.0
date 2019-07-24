Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E464474108
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfGXVsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:48:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64132 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726870AbfGXVsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 17:48:36 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6OLmGsI024535
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 14:48:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=vIYOJ8GFUHIG0Z6RRTPyodtUTdV1z6zUK00ElCW6/EE=;
 b=eLFTHQoVgkta5/hakWnl739UtWnjnqnOH8Bo6CAFbdYW/ULG1wCM61IDp70bMh6Lds3i
 MPLPiNJNf0MIWQxvIhtgPW53YINznUfAVbRIdK1I4jr5JegKltvPpuYRa8gbOX5+zSg4
 gK5IrcT/b7wb6hAd5/AHVgVug3mblS745Q8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2txs429seu-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 14:48:35 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 24 Jul 2019 14:48:33 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id C8F228615C6; Wed, 24 Jul 2019 14:48:32 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf] libbpf: silence GCC8 warning about string truncation
Date:   Wed, 24 Jul 2019 14:47:53 -0700
Message-ID: <20190724214753.1816451-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907240232
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Despite a proper NULL-termination after strncpy(..., ..., IFNAMSIZ - 1),
GCC8 still complains about *expected* string truncation:

  xsk.c:330:2: error: 'strncpy' output may be truncated copying 15 bytes
  from a string of length 15 [-Werror=stringop-truncation]
    strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);

This patch gets rid of the issue altogether by using memcpy instead.
There is no performance regression, as strncpy will still copy and fill
all of the bytes anyway.

v1->v2:
- rebase against bpf tree.

Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 tools/lib/bpf/xsk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index e02025bbe36d..680e63066cf3 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -326,7 +326,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 		return -errno;
 
 	ifr.ifr_data = (void *)&channels;
-	strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
+	memcpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
 	ifr.ifr_name[IFNAMSIZ - 1] = '\0';
 	err = ioctl(fd, SIOCETHTOOL, &ifr);
 	if (err && errno != EOPNOTSUPP) {
@@ -516,7 +516,7 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 		err = -errno;
 		goto out_socket;
 	}
-	strncpy(xsk->ifname, ifname, IFNAMSIZ - 1);
+	memcpy(xsk->ifname, ifname, IFNAMSIZ - 1);
 	xsk->ifname[IFNAMSIZ - 1] = '\0';
 
 	err = xsk_set_xdp_socket_config(&xsk->config, usr_config);
-- 
2.17.1

