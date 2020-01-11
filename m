Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE57137BC3
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 07:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgAKGMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 01:12:33 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:39232 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgAKGMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 01:12:33 -0500
Received: by mail-io1-f67.google.com with SMTP id c16so4411132ioh.6;
        Fri, 10 Jan 2020 22:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k/uOUC4WZrxLQy7Z1uiXWhhGNWt+EgxTQhQgxc/WTeQ=;
        b=glSJbUPkGbA/zZ77sxSrpphY5koT0ODVZa2PWUS9kxFltmKHRODxtGXD7276Z/zXpz
         U7OQSf52AapQY4pk2Guvyuo0Np1TNEud5Da/GOuPVCw1bkRT/YrN29SE4oL78YwcKcV7
         w/TDm/uxpFIxneS/+MDe5w+4GBLTS8dphBpCYoiDrEtqozYdMFxZZaaRC6ANroAS9i+w
         mwWnK9bdpNq2PHAKOTTdjfql9h9iI7aFEwnHdQVhe/xo70x91bMp+0404sNZaaepDrT5
         f/6Ho1qSJ9FCratYeXyjj5WJZF5wtVqPg1l/n7zcALorGwPhRHcPxc392dcJ/ZbWxfel
         Hmcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k/uOUC4WZrxLQy7Z1uiXWhhGNWt+EgxTQhQgxc/WTeQ=;
        b=EeaWa8tF72zsQ1w+ZutJYgL3jk5I+eRZ2rvpUnUoTK7Mc7y3289Hqh09u/Nb7NtVAx
         yqX5RQhLBNTwHNJjzkBiMzt/cqrQEVYtIhLUHbfiKT7XZyC8/bNThxxQXYhAp1BT66nR
         FIS4CBDYuNicJ53ldOS3mHFvRZpsL6vRj/MNpHn2MOKBLYBm9HwE+bTHj5h0NiQN99YL
         Pn7e/sA6HGXt7EaNyZj8HdzQ1lK63HeeLGQiRdNtZe7qpJ+VcjdcOgtAmaFHnhx2lYCx
         ieWiBjc7vl3NRLnFv1q6gqYBSbnBW9YFwJ+0Pi179KhKjWQVxixp6aOMifBosmlpwfZ0
         +fJA==
X-Gm-Message-State: APjAAAX1jaz6RdVMlsenVtfto7TnRTLzbSovHU3xKQ+lEr0bKFfY3BvR
        eM9hF6/xFF25gMQyWbjQYKMkYhud
X-Google-Smtp-Source: APXvYqzogvFDa66OvKD/9iILKwwbyTtZo6bxlJax41rKJ3OLTlrA2CZG02NidGW3cnXBGgIsGmoDCg==
X-Received: by 2002:a5e:8813:: with SMTP id l19mr5711114ioj.261.1578723152076;
        Fri, 10 Jan 2020 22:12:32 -0800 (PST)
Received: from localhost.localdomain ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 141sm1417784ile.44.2020.01.10.22.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 22:12:31 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        john.fastabend@gmail.com, song@kernel.org, jonathan.lemon@gmail.com
Subject: [bpf PATCH v2 1/8] bpf: sockmap/tls, during free we may call tcp_bpf_unhash() in loop
Date:   Sat, 11 Jan 2020 06:11:59 +0000
Message-Id: <20200111061206.8028-2-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200111061206.8028-1-john.fastabend@gmail.com>
References: <20200111061206.8028-1-john.fastabend@gmail.com>
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
Cc: stable@vger.kernel.org
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/skmsg.h | 1 +
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
-- 
2.17.1

