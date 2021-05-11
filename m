Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1339237A86E
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 16:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhEKOHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 10:07:08 -0400
Received: from m12-14.163.com ([220.181.12.14]:55369 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231489AbhEKOHH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 10:07:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=8DEIr7JHMWWcTKNdor
        0P0+DA4ax1L12j+Rr59qjm03M=; b=YPvxBtNaHTVC1S9nSMfdlTZ+BBpD7kqRVd
        h1YSaIMhDgmwYh59IZctCD06huiXicyGWPTA3o9JKhseJS3a+prKU1BUfSHvLrRC
        54X6uWnBxUlcRvp1hmTATpP+v0zoa3/I+eAAYxoKBw9cymRfLF7+53YcqKdwPSMU
        Wa1HWqcFk=
Received: from localhost.localdomain (unknown [117.139.248.194])
        by smtp10 (Coremail) with SMTP id DsCowADXj20Lj5pgIgswIQ--.31375S2;
        Tue, 11 May 2021 22:05:00 +0800 (CST)
From:   Hailong Liu <liuhailongg6@163.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Yonghong Song <yhs@fb.com>, Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hailong Liu <liu.hailong6@zte.com.cn>
Subject: [PATCH] samples, bpf: suppress compiler warning
Date:   Tue, 11 May 2021 22:04:29 +0800
Message-Id: <20210511140429.89426-1-liuhailongg6@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: DsCowADXj20Lj5pgIgswIQ--.31375S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zr1xZF47AFykur1rAr1DZFb_yoW8XFW8pa
        1kt347KFZayF1Y9ry3Xr9rK34Fv34kGFyUGFZ7Jry3J3Waq3ykWayYyFZ8Wr45Gr95KF4S
        vw1Sgry8G3WUCaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jnID7UUUUU=
X-Originating-IP: [117.139.248.194]
X-CM-SenderInfo: xolxxtxlor0wjjw6il2tof0z/xtbBChePYF3l-XpMDQAAsM
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hailong Liu <liu.hailong6@zte.com.cn>

While cross compiling on ARM32 , the casting from pointer to __u64 will
cause warnings:

samples/bpf/task_fd_query_user.c: In function 'main':
samples/bpf/task_fd_query_user.c:399:23: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
399 | uprobe_file_offset = (__u64)main - (__u64)&__executable_start;
| ^
samples/bpf/task_fd_query_user.c:399:37: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
399 | uprobe_file_offset = (__u64)main - (__u64)&__executable_start;

Workaround this by using "unsigned long" to adapt to different ARCHs.

Signed-off-by: Hailong Liu <liu.hailong6@zte.com.cn>
---
 samples/bpf/task_fd_query_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/task_fd_query_user.c b/samples/bpf/task_fd_query_user.c
index a78025b0026b..c9a0ca8351fd 100644
--- a/samples/bpf/task_fd_query_user.c
+++ b/samples/bpf/task_fd_query_user.c
@@ -396,7 +396,7 @@ int main(int argc, char **argv)
 	 * on different systems with different compilers. The right way is
 	 * to parse the ELF file. We took a shortcut here.
 	 */
-	uprobe_file_offset = (__u64)main - (__u64)&__executable_start;
+	uprobe_file_offset = (unsigned long)main - (unsigned long)&__executable_start;
 	CHECK_AND_RET(test_nondebug_fs_probe("uprobe", (char *)argv[0],
 					     uprobe_file_offset, 0x0, false,
 					     BPF_FD_TYPE_UPROBE,
-- 
2.25.1

