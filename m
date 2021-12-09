Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCEE46E47D
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 09:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbhLIIrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 03:47:52 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:60897 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232764AbhLIIrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 03:47:52 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=chengshuyi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0V-2Ajof_1639039456;
Received: from 30.225.28.45(mailfrom:chengshuyi@linux.alibaba.com fp:SMTPD_---0V-2Ajof_1639039456)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Dec 2021 16:44:17 +0800
Message-ID: <9eb3216b-a785-9024-0f1d-e5a14dfb025b@linux.alibaba.com>
Date:   Thu, 9 Dec 2021 16:44:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
From:   Shuyi Cheng <chengshuyi@linux.alibaba.com>
Subject: [PATCH bpf-next] libbpf: Skip the pinning of global data map for old
 kernels.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fix error: "failed to pin map: Bad file descriptor, path:
/sys/fs/bpf/_rodata_str1_1."

In the old kernel, the global data map will not be created, see [0]. So
we should skip the pinning of the global data map to avoid 
bpf_object__pin_maps returning error.

[0]: https://lore.kernel.org/bpf/20211123200105.387855-1-andrii@kernel.org

Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
---
  tools/lib/bpf/libbpf.c | 4 ++++
  1 file changed, 4 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6db0b5e8540e..d96cf49cebab 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7884,6 +7884,10 @@ int bpf_object__pin_maps(struct bpf_object *obj, 
const char *path)
  		char *pin_path = NULL;
  		char buf[PATH_MAX];

+		if (bpf_map__is_internal(map) &&
+		    !kernel_supports(obj, FEAT_GLOBAL_DATA))
+			continue;
+
  		if (path) {
  			int len;

-- 
2.19.1.6.gb485710b
