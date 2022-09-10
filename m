Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29A65B4734
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 17:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiIJPHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 11:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiIJPHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 11:07:37 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA35A4CA0E
        for <netdev@vger.kernel.org>; Sat, 10 Sep 2022 08:07:35 -0700 (PDT)
Received: from fsav114.sakura.ne.jp (fsav114.sakura.ne.jp [27.133.134.241])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 28AF7Ywt061618;
        Sun, 11 Sep 2022 00:07:34 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav114.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav114.sakura.ne.jp);
 Sun, 11 Sep 2022 00:07:34 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav114.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 28AF7BGs061571
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 11 Sep 2022 00:07:11 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <e2e4cc0e-9d36-4ca1-9bfa-ce23e6f8310b@I-love.SAKURA.ne.jp>
Date:   Sun, 11 Sep 2022 00:07:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: [PATCH] bpf: add missing percpu_counter_destroy() in htab_map_alloc()
Content-Language: en-US
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
References: <0000000000005ed86405e846585a@google.com>
Cc:     syzbot <syzbot+5d1da78b375c3b5e6c2b@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <0000000000005ed86405e846585a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is reporting ODEBUG bug in htab_map_alloc() [1], for
commit 86fe28f7692d96d2 ("bpf: Optimize element count in non-preallocated
hash map.") added percpu_counter_init() to htab_map_alloc() but forgot to
add percpu_counter_destroy() to the error path.

Link: https://syzkaller.appspot.com/bug?extid=5d1da78b375c3b5e6c2b [1]
Reported-by: syzbot <syzbot+5d1da78b375c3b5e6c2b@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 86fe28f7692d96d2 ("bpf: Optimize element count in non-preallocated hash map.")
---
 kernel/bpf/hashtab.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 0fe3f136cbbe..86aec20c22d0 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -622,6 +622,8 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 free_prealloc:
 	prealloc_destroy(htab);
 free_map_locked:
+	if (htab->use_percpu_counter)
+		percpu_counter_destroy(&htab->pcount);
 	for (i = 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
 		free_percpu(htab->map_locked[i]);
 	bpf_map_area_free(htab->buckets);
-- 
2.18.4

