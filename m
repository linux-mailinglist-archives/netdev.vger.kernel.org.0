Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2BD762922
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403830AbfGHTPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:15:13 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:36077 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728827AbfGHTPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:15:13 -0400
Received: by mail-io1-f65.google.com with SMTP id o9so22218058iom.3;
        Mon, 08 Jul 2019 12:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=lV8etYsEZTqwvPfp5XBIG2UlKxfnHXO0yLVdtiun7Hk=;
        b=Yutek5f2mygHV6NeordcHOHStjSVRsVYT3PxfDEE/7T4Xc7j4Vkyib7w3V9C4vN2SA
         VmBxBpEeB9Tvwg90kyxQS9QCql8AWCjD7VANvJ3ZrU67zRPqqXv9ihQDcZ0nSrkVcj0y
         8IVhMLDlrHWx/bs6+DhxHqX1DFbeH1QYCNMSad+7223lqq5NvwdxR1cjHELL2TOaJLN7
         RNBaIrjNj7kXQkLTrA4mBwIxOFfWW/nmKdsEqWBP6sX6UJyhj2qUYQvnYpzz/365RvaQ
         wEmzKJdf10Z0xlGfxWyl6wKPBxG3gvo+lWmieIzcCKo+/0evMhWhOR6rcG0mN/GjOABM
         Rwkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=lV8etYsEZTqwvPfp5XBIG2UlKxfnHXO0yLVdtiun7Hk=;
        b=sOWEiUsBss4sQoi4EJxOEgLvl6MetRqjFw8WorRTTEpEIshg/BDYjJbmPSTy69URAE
         FRoW1VMM/ULMAKPfTP3t2ky8w3QQmXsDQrMD9Pboi9Duiw9k/g19t+CqUtif5Klx5iPt
         fUCiPHJ1vmaTN3tLmGMuU6zOkMwn+HBN6YAuHeGJK/JUrLe19flJI07y6PccUCfpfkp9
         qiC7B4WFhPBii5WvpeCqI+30VhtHeIFXJvbqgAernKQfgKqUV4x8x4BxVNUM1o8xGiur
         UPwxZydU122n4f9DC/gXoCaMykGd6BLrRA9c1K63hiLGfmVpGKcxbpMTtMO9UUrgPL1O
         /yiA==
X-Gm-Message-State: APjAAAVngyyLLSbX8Uv+VONaR+RT9VFOjBTvY30Z+4NvDDuEdbq+To+j
        SIz4V5YsBQO+1rDvCt+ufsw=
X-Google-Smtp-Source: APXvYqz8J9EN6QDIuDm8wthUnw8EGfCb9XqvgK4uf7rm4DSx3A2kso8fPfVR2gPuq3ZjkVUP4GifWg==
X-Received: by 2002:a6b:8b8b:: with SMTP id n133mr1367677iod.183.1562613312685;
        Mon, 08 Jul 2019 12:15:12 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v10sm20828239iob.43.2019.07.08.12.15.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 12:15:12 -0700 (PDT)
Subject: [bpf PATCH v2 5/6] bpf: sockmap,
 only create entry if ulp is not already enabled
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Date:   Mon, 08 Jul 2019 19:15:01 +0000
Message-ID: <156261330105.31108.1927837989210591684.stgit@ubuntu3-kvm1>
In-Reply-To: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
References: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sockmap does not currently support adding sockets after TLS has been
enabled. There never was a real use case for this so it was never
added. But, we lost the test for ULP at some point so add it here
and fail the socket insert if TLS is enabled. Future work could
make sockmap support this use case but fixup the bug here.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/sock_map.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 56bcabe7c2f2..1330a7442e5b 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -334,6 +334,7 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 				  struct sock *sk, u64 flags)
 {
 	struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct sk_psock_link *link;
 	struct sk_psock *psock;
 	struct sock *osk;
@@ -344,6 +345,8 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 		return -EINVAL;
 	if (unlikely(idx >= map->max_entries))
 		return -E2BIG;
+	if (unlikely(icsk->icsk_ulp_data))
+		return -EINVAL;
 
 	link = sk_psock_init_link();
 	if (!link)

