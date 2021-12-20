Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13B047A6A9
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 10:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhLTJOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 04:14:52 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15943 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbhLTJOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 04:14:52 -0500
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JHYk73C24zZdhn;
        Mon, 20 Dec 2021 17:11:43 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500020.china.huawei.com
 (7.185.36.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Mon, 20 Dec
 2021 17:14:49 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <mcgrof@kernel.org>, <akpm@linux-foundation.org>,
        <keescook@chromium.org>, <yzaikin@google.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <libaokun1@huawei.com>, <yukuai3@huawei.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH -next V2] sysctl: returns -EINVAL when a negative value is passed to proc_doulongvec_minmax
Date:   Mon, 20 Dec 2021 17:26:27 +0800
Message-ID: <20211220092627.3744624-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we pass a negative value to the proc_doulongvec_minmax() function,
the function returns 0, but the corresponding interface value does not
change.

we can easily reproduce this problem with the following commands:
    `cd /proc/sys/fs/epoll`
    `echo -1 > max_user_watches; echo $?; cat max_user_watches`

This function requires a non-negative number to be passed in, so when
a negative number is passed in, -EINVAL is returned.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
V1->V2:
	Modify the judgment position.

 kernel/sysctl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 7f07b058b180..4211e39a5fd3 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1147,10 +1147,11 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table,
 			err = proc_get_long(&p, &left, &val, &neg,
 					     proc_wspace_sep,
 					     sizeof(proc_wspace_sep), NULL);
-			if (err)
+			if (err || neg) {
+				err = -EINVAL;
 				break;
-			if (neg)
-				continue;
+			}
+
 			val = convmul * val / convdiv;
 			if ((min && val < *min) || (max && val > *max)) {
 				err = -EINVAL;
-- 
2.31.1

