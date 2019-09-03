Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24980A7495
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 22:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfICUZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 16:25:05 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:32793 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfICUZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 16:25:03 -0400
Received: by mail-io1-f66.google.com with SMTP id m11so7070194ioo.0
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 13:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=Fv8PJ8fir2xnvGC1POtiy3M/j8q+YPjSYLavW811w7U=;
        b=qnaeJJLWLR7380HlTdDUdTzil+uyvqdhB73kLZJyAyUZXsTSU8wLDsoOM6SFJsN/l/
         DDNi2ZF0CaKWMew2e6NntD6XVCKhKpMugH049rnbMVOTI4U0JO2lleq1eQGLIldAbdoz
         koY1TtLBzT02fgjpElfBHg6HZUc/pQdjk3l80UxBJSjMud3cdVlv5sNtgXqwdFB+Ncuu
         N5Afh83Jd1TEHA2dWMNplC3rkb1uFZcJMZBlTbeRR9Df9sdr3KpjY4QJCJuXq6/Xnv4k
         Xdk+hTXXeZQEFEhrt9C/3BY4D8jMcuWVBqeJPc3GqfBAb+0mOrFigrFVSGraQzbPdFci
         GPEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=Fv8PJ8fir2xnvGC1POtiy3M/j8q+YPjSYLavW811w7U=;
        b=iT4SlvWIZpw+bdVv+nPsFHaHFEjDRz0FOIQdE1jx/ispIfEMzM0sTA2uZ+cP2et15S
         4gXy1mXC62ePWPRMg5tUs2Jq5MU+MHAicxGWU8r8l68zb7Vb9K5CRALJ2GaHRrCXAHMC
         Ibi1ZHd6r9Z5qzWJEDPEEDzBW9zxpA//pVpG3dRxALkOH21PHQ3EFtdjSqyohWIeqXGI
         X73DbWiJe7f4/OkCurB07VTV/UKNJ59iQVyKfCJD6Kbkl+jnDcUUEH4LaGK1wBQW08fI
         WTV3fn8aJ2xvXaADj6yvk1o5Xbc8SCyaFD45+vCtFVayod6Bi0xcXkw4bLAGL4LH+GRx
         9Mlg==
X-Gm-Message-State: APjAAAUe1fOtSOcCOq4xIVfBa+63vhCaY+pxz3I2oyBb6rhMIErWImlf
        rtCu+1dFaqN4UeT0UGHEu+dnQet3
X-Google-Smtp-Source: APXvYqwLl3OknIrJklt4EXRsKeraHjtbvJis/rkXa2fSK70wAh4iKurBoid38gif2TnRnL+8caVABA==
X-Received: by 2002:a5d:89cd:: with SMTP id a13mr3675997iot.272.1567542302773;
        Tue, 03 Sep 2019 13:25:02 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 80sm27047498iou.13.2019.09.03.13.24.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 13:25:02 -0700 (PDT)
Subject: [net PATCH] net: sock_map, fix missing ulp check in sock hash case
From:   John Fastabend <john.fastabend@gmail.com>
To:     hdanton@sina.com, jakub.kicinski@netronome.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com
Date:   Tue, 03 Sep 2019 13:24:50 -0700
Message-ID: <156754228993.21629.4076822768659778848.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock_map and ULP only work together when ULP is loaded after the sock
map is loaded. In the sock_map case we added a check for this to fail
the load if ULP is already set. However, we missed the check on the
sock_hash side.

Add a ULP check to the sock_hash update path.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Reported-by: syzbot+7a6ee4d0078eac6bf782@syzkaller.appspotmail.com
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/sock_map.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 1330a74..50916f9 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -656,6 +656,7 @@ static int sock_hash_update_common(struct bpf_map *map, void *key,
 				   struct sock *sk, u64 flags)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	u32 key_size = map->key_size, hash;
 	struct bpf_htab_elem *elem, *elem_new;
 	struct bpf_htab_bucket *bucket;
@@ -666,6 +667,8 @@ static int sock_hash_update_common(struct bpf_map *map, void *key,
 	WARN_ON_ONCE(!rcu_read_lock_held());
 	if (unlikely(flags > BPF_EXIST))
 		return -EINVAL;
+	if (unlikely(icsk->icsk_ulp_data))
+		return -EINVAL;
 
 	link = sk_psock_init_link();
 	if (!link)

