Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B259134EA5
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgAHVOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:14:18 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:34851 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgAHVOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:14:18 -0500
Received: by mail-il1-f196.google.com with SMTP id g12so3913657ild.2;
        Wed, 08 Jan 2020 13:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=nMRe4g2ztcBCA+0caE9RNqwQ4Lc8GtMpZaK2DzSrUsM=;
        b=BbAFJbMe9TZRthB6a4MS8rtfV1zJ7RrRj8Rh56+c8yRuvntm+9zyVC6kxcHZuwtk+y
         ryC7FE6d9lE/KmfeJqD42JHlHVTv+po3gESX3VGJXoWa1b1j+Shwi51d9EHtczwatZnl
         wdsViO/z465L7nPG10c/qQXpvSZSxjHzLP8uxti+mBzOuHPoAm6FbdMFWkz7xD/cO2oQ
         kgtWoT+YchGPyjPWHDprLPflQ+hoiK+GTw1ChblILVssvg9XRrMsRcsxpEfpKQVe8gTR
         FP/XVK+bgLxEL0w1bjer9FfW0jN3KK1LTwmu8hlyHL/pfDOOlPl02Om9z/UGysegCmMy
         Z0Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nMRe4g2ztcBCA+0caE9RNqwQ4Lc8GtMpZaK2DzSrUsM=;
        b=T4QO/u08FVgH1065UicaL1u8AJ4HOvOZC0wzLfY6JJHhf1mtkep3Hne0lVYfnjwdno
         IrlgztJwOaC8RHPgPQHMaEVlDLuddaWU8+jmq3WWiwBhSJRETjRMAOb6uBdWdJU7Qztq
         gEiDTLyFf377VLS5170g7BmWrcyEfeCkvi/n8aAkEKgcOihyXdj3j77rM2XXTXuOUZtU
         1w8FW8NzsdlG4gLFiWbKsaSG9tbVEnH5Yla6SK11r2UFQ3/Q7/Fcgoov0m5wSEaAGfPk
         zEh3o7JwfdWgDbjzUPEcGZkzWTbKC+Mp38oko+6G7SGMlYAuOeH0BpC3XVjxdAwo+a+T
         qRRw==
X-Gm-Message-State: APjAAAVGe+FXXQMv8XpC/pj3TFszxNzJoM6Oj98YMEh8ihGFaeaM1nZ5
        jc36DnWwldCkSDpjKzbNzgZpn/Ak
X-Google-Smtp-Source: APXvYqw41PT2AvWhZaH6mUG/T1dIDe6mvXYfmBktVueNgJFlJ80hkWzsw58KLQ1pAvGc7YcLN7c8rg==
X-Received: by 2002:a92:4448:: with SMTP id a8mr5802073ilm.256.1578518057406;
        Wed, 08 Jan 2020 13:14:17 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w16sm1319972ilq.5.2020.01.08.13.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 13:14:17 -0800 (PST)
Subject: [bpf PATCH 1/9] bpf: sockmap/tls,
 during free we may call tcp_bpf_unhash() in loop
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Date:   Wed, 08 Jan 2020 21:14:07 +0000
Message-ID: <157851804766.1732.2480524840189309989.stgit@ubuntu3-kvm2>
In-Reply-To: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a sockmap is free'd and a socket in the map is enabled with tls
we tear down the bpf context on the socket, the psock struct and state,
and then call tcp_update_ulp(). The tcp_update_ulp() call is to inform
the tls stack it needs to update its saved sock ops so that when the tls
socket is later destroyed it doesn't try to call the now destroyed psock
hooks.

This is about keeping stacked ULPs in good shape so they always have
the right set of stacked ops.

However, recently unhash() hook was removed from TLS side. But, the
sockmap/bpf side is not doing any extra work to update the unhash op
when is torn down instead expecting TLS side to manage it. So both
TLS and sockmap believe the other side is managing the op and instead
no one updates the hook so it continues to point at tcp_bpf_unhash().
When unhash hook is called we call tcp_bpf_unhash() which detects the
psock has already been destroyed and calls sk->sk_prot_unhash() which
calls tcp_bpf_unhash() yet again and so on looping and hanging the core.

To fix have sockmap tear down logic fixup the stale pointer.

Fixes: 5d92e631b8be ("net/tls: partially revert fix transition through disconnect with close")
Reported-by: syzbot+83979935eb6304f8cd46@syzkaller.appspotmail.com
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/skmsg.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index ef7031f8a304..b6afe01f8592 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -358,6 +358,7 @@ static inline void sk_psock_update_proto(struct sock *sk,
 static inline void sk_psock_restore_proto(struct sock *sk,
 					  struct sk_psock *psock)
 {
+	sk->sk_prot->unhash = psock->saved_unhash;
 	sk->sk_write_space = psock->saved_write_space;
 
 	if (psock->sk_proto) {

