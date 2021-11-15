Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9514450368
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 12:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhKOLal convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 15 Nov 2021 06:30:41 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:26313 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbhKOLac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 06:30:32 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Ht6HP5lJQzbhtW
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 19:22:41 +0800 (CST)
Received: from kwepeml100004.china.huawei.com (7.221.188.19) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 15 Nov 2021 19:27:35 +0800
Received: from dggpemm500020.china.huawei.com (7.185.36.49) by
 kwepeml100004.china.huawei.com (7.221.188.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 15 Nov 2021 19:27:35 +0800
Received: from dggpemm500020.china.huawei.com ([7.185.36.49]) by
 dggpemm500020.china.huawei.com ([7.185.36.49]) with mapi id 15.01.2308.020;
 Mon, 15 Nov 2021 19:27:34 +0800
From:   "jiangheng (H)" <jiangheng12@huawei.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Chenxiang (EulerOS)" <rose.chen@huawei.com>
Subject: [PATCH iproute2] lnstat:fix buffer overflow in lnstat lnstat
 segfaults when called the following command: $ lnstat -w 1
Thread-Topic: [PATCH iproute2] lnstat:fix buffer overflow in lnstat lnstat
 segfaults when called the following command: $ lnstat -w 1
Thread-Index: AdfaETTzfhhle7agS76ni9yTVXCCVw==
Date:   Mon, 15 Nov 2021 11:27:34 +0000
Message-ID: <6cc4b6c9c31e49508c07df7334831a73@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.117.195]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From d797c268003919f6e83c1bbdccebf62805dc2581 Mon Sep 17 00:00:00 2001
From: jiangheng <jiangheng12@huawei.com>
Date: Thu, 11 Nov 2021 18:20:26 +0800
Subject: [PATCH iproute2] lnstat:fix buffer overflow in lnstat lnstat
segfaults when called the following command: $ lnstat -w 1

[root@pm-104 conf.d]# lnstat -w 1
Segmentation fault (core dumped)

The maximum  value of th.num_lines is HDR_LINES(10),  h should not be equal to th.num_lines, array th.hdr may be out of bounds.

Signed-off-by jiangheng <jiangheng12@huawei.com>
---
misc/lnstat.c | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/lnstat.c b/misc/lnstat.c
index 89cb0e7e..26be852d 100644
--- a/misc/lnstat.c
+++ b/misc/lnstat.c
@@ -211,7 +211,7 @@ static struct table_hdr *build_hdr_string(struct lnstat_file *lnstat_files,
 		ofs += width+1;
 	}
 	/* fill in spaces */
-	for (h = 1; h <= th.num_lines; h++) {
+	for (h = 1; h < th.num_lines; h++) {
 		for (i = 0; i < ofs; i++) {
 			if (th.hdr[h][i] == '\0')
 				th.hdr[h][i] = ' ';
--
2.27.0
