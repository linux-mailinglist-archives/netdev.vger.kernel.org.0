Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B86E22FC8B
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgG0W6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:58:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50014 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726738AbgG0W6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:58:00 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RMu476016447
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:57:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=dxJ4+WitJF1AyWmc4hiQmpu517phDyAASL/xE5vblOk=;
 b=AUxBgi0B/oUDyjVw2doTCQZ1HKKiKq9N6ZPQvqaKFRAzwsHbYEfmd6U7uXd///Nkhdxb
 mPJFZc864AZLy4VNCYeYssYHr3Y2IHVzJ49IaGflBYHq+/ueQLV4VpMvxhdxSV3Upbos
 l98/6Ufzb1Aq/FDFvf6v5ksQjuh503SnkmM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32j13yj3te-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:57:59 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:57:58 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 3C05D2EC4B93; Mon, 27 Jul 2020 15:57:53 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpf: fix bpf_ringbuf_output() signature to return long
Date:   Mon, 27 Jul 2020 15:47:15 -0700
Message-ID: <20200727224715.652037-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 impostorscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007270155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to bpf tree fix merge, bpf_ringbuf_output() signature ended up with i=
nt as
a return type, while all other helpers got converted to returning long. S=
o fix
it in bpf-next now.

Fixes: b0659d8a950d ("bpf: Fix definition of bpf_ringbuf_output() helper =
in UAPI comments")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/uapi/linux/bpf.h       | 2 +-
 tools/include/uapi/linux/bpf.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index e1ba4ae6a916..eb5e0c38eb2c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3241,7 +3241,7 @@ union bpf_attr {
  *	Return
  *		The id is returned or 0 in case the id could not be retrieved.
  *
- * int bpf_ringbuf_output(void *ringbuf, void *data, u64 size, u64 flags=
)
+ * long bpf_ringbuf_output(void *ringbuf, void *data, u64 size, u64 flag=
s)
  * 	Description
  * 		Copy *size* bytes from *data* into a ring buffer *ringbuf*.
  * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index e1ba4ae6a916..eb5e0c38eb2c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3241,7 +3241,7 @@ union bpf_attr {
  *	Return
  *		The id is returned or 0 in case the id could not be retrieved.
  *
- * int bpf_ringbuf_output(void *ringbuf, void *data, u64 size, u64 flags=
)
+ * long bpf_ringbuf_output(void *ringbuf, void *data, u64 size, u64 flag=
s)
  * 	Description
  * 		Copy *size* bytes from *data* into a ring buffer *ringbuf*.
  * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
--=20
2.24.1

