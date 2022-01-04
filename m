Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D14484A39
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 22:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbiADVqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 16:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiADVqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 16:46:47 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10548C061761;
        Tue,  4 Jan 2022 13:46:47 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id s15so544885plg.12;
        Tue, 04 Jan 2022 13:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y+mvb6PsAYfG3vY3b5S2athlXNHe5uxOG6wIxbUuVww=;
        b=c1WAhrnxO6Kg0rBv8mAzRlBCYcuuxnd6jNDhw3BQT2PdPhZSAq42c70V2x9+flGjq0
         cQN+At6tfaE3FoqubL3xeHSfWrOcKvRzLZqp/BqUlQz8U+SHoqzhkYH8DE2eUtBhHkzf
         PA8xeoc/W1jS73NYhoDK2qXanpLQ1ca/cTgYW8L7uC1OeYvfbimzEoXZ4iIdsEDk3MuS
         NJ8HMNHDXtW2Tjli0+eUZrJ2Zpk9AzxKA0kB51Us6LNQCYSSs/JaWi1HwFWPxl+KmCPy
         ZoOMovM9D91DVojjlwFVhIFPnYJN7WGcxjZ8ncTpxSOPcmMIlRt4eY5spCf/SKCxzJQQ
         3Pcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y+mvb6PsAYfG3vY3b5S2athlXNHe5uxOG6wIxbUuVww=;
        b=7lX/UEIapTVFI4WLCRgtu9CSiBoCDN6rfkAA2flnXXGZJ+JfuK5vGGoucfOu15QBmV
         uox9el4pF3NATN2hNgIkF+0u8o6t5w6XvjaOUJyE5j8Obw2uxjP4zBH861K9B4ie9aC6
         RV1tDp9GRH3Lkjl/8psY0RWkNyL+3OIvSp5sCykY7+LmDHl/xr5O/4fwb9JyAa/ZJrFQ
         yjglNbxdUMMiQOruDyCqp7ESVdH6F/HZcUUh5LArNdUanVfYdP4yc73ZEMDF6Dw8RVqf
         NuEas/hu6i8i2Cx1xDW9xSc1MopMsYuclh+ebNIbUYOqSKTk5NaTThZyHqXr9X6WygcK
         gp/w==
X-Gm-Message-State: AOAM533LS4a6oCMqGtiHGd7Alx4MkEqcsJYx047UCpGiB7kPXpFt2oBj
        vgiQWd7TH57WL05pXa+ifLo=
X-Google-Smtp-Source: ABdhPJxelS5mc5UYyDs6LzptXFf9u32HuROeQSqCZARQH0QBE7+iigpzfLVIRQKnCchgx5EXyw02dw==
X-Received: by 2002:a17:902:cec4:b0:149:346b:cb8b with SMTP id d4-20020a170902cec400b00149346bcb8bmr51428893plg.87.1641332806605;
        Tue, 04 Jan 2022 13:46:46 -0800 (PST)
Received: from localhost.localdomain ([71.236.223.183])
        by smtp.gmail.com with ESMTPSA id n13sm33241080pfa.197.2022.01.04.13.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 13:46:46 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, joamaki@gmail.com,
        john.fastabend@gmail.com
Subject: [PATCH bpf-next] bpf, sockmap: fix double bpf_prog_put on error case in map_link
Date:   Tue,  4 Jan 2022 13:46:45 -0800
Message-Id: <20220104214645.290900-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock_map_link() is called to update a sockmap entry with a sk. But, if the
sock_map_init_proto() call fails then we return an error to the map_update
op against the sockmap. In the error path though we need to cleanup psock
and dec the refcnt on any programs associated with the map, because we
refcnt them early in the update process to ensure they are pinned for the
psock. (This avoids a race where user deletes programs while also updating
the map with new socks.)

In current code we do the prog refcnt dec explicitely by calling
bpf_prog_put() when the program was found in the map. But, after commit
'38207a5e81230' in this error path we've already done the prog to psock
assignment so the programs have a reference from the psock as well. This
then causes the psock tear down logic, invoked by sk_psock_put() in the
error path, to similarly call bpf_prog_put on the programs there.

To be explicit this logic does the prog->psock assignemnt

  if (msg_*)
    psock_set_prog(...)

Then the error path under the out_progs label does a similar check and dec
with,

  if (msg_*)
     bpf_prog_put(...)

And the teardown logic sk_psock_put() does,

  psock_set_prog(msg_*, NULL)

triggering another bpf_prog_put(...). Then KASAN gives us this splat, found
by syzbot because we've created an inbalance between bpf_prog_inc and
bpf_prog_put calling put twice on the program.

BUG: KASAN: vmalloc-out-of-bounds in __bpf_prog_put kernel/bpf/syscall.c:1812 [inline]
BUG: KASAN: vmalloc-out-of-bounds in __bpf_prog_put kernel/bpf/syscall.c:1812 [inline] kernel/bpf/syscall.c:1829
BUG: KASAN: vmalloc-out-of-bounds in bpf_prog_put+0x8c/0x4f0 kernel/bpf/syscall.c:1829 kernel/bpf/syscall.c:1829
Read of size 8 at addr ffffc90000e76038 by task syz-executor020/3641

To fix clean up error path so it doesn't try to do the bpf_prog_put in the
error path once progs are assigned then it relies on the normal psock
tear down logic to do complete cleanup.

For completness we also cover the case whereh sk_psock_init_strp() fails,
but this is not expected because it indicates an incorrect socket type
and should be caught earlier.

Reported-by: syzbot+bb73e71cf4b8fd376a4f@syzkaller.appspotmail.com
Fixes: 38207a5e8123 ("bpf, sockmap: Attach map progs to psock early for feature probes")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---

Applies against both bpf and bpf-next but labeled for bpf-next given
we are in rc8 now.

 net/core/sock_map.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 9618ab6d7cc9..1827669eedd6 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -292,15 +292,23 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 	if (skb_verdict)
 		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
 
+	/* msg_* and stream_* programs references tracked in psock after this
+	 * point. Reference dec and cleanup will occur through psock destructor
+	 */
 	ret = sock_map_init_proto(sk, psock);
-	if (ret < 0)
-		goto out_drop;
+	if (ret < 0) {
+		sk_psock_put(sk, psock);
+		goto out;
+	}
 
 	write_lock_bh(&sk->sk_callback_lock);
 	if (stream_parser && stream_verdict && !psock->saved_data_ready) {
 		ret = sk_psock_init_strp(sk, psock);
-		if (ret)
-			goto out_unlock_drop;
+		if (ret) {
+			write_unlock_bh(&sk->sk_callback_lock);
+			sk_psock_put(sk, psock);
+			goto out;
+		}
 		sk_psock_start_strp(sk, psock);
 	} else if (!stream_parser && stream_verdict && !psock->saved_data_ready) {
 		sk_psock_start_verdict(sk,psock);
@@ -309,10 +317,6 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 	}
 	write_unlock_bh(&sk->sk_callback_lock);
 	return 0;
-out_unlock_drop:
-	write_unlock_bh(&sk->sk_callback_lock);
-out_drop:
-	sk_psock_put(sk, psock);
 out_progs:
 	if (skb_verdict)
 		bpf_prog_put(skb_verdict);
@@ -325,6 +329,7 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 out_put_stream_verdict:
 	if (stream_verdict)
 		bpf_prog_put(stream_verdict);
+out:
 	return ret;
 }
 
-- 
2.33.0

