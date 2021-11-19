Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8235457630
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 19:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbhKSSRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 13:17:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234354AbhKSSRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 13:17:43 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C826C06173E;
        Fri, 19 Nov 2021 10:14:42 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id l19so11123509ilk.0;
        Fri, 19 Nov 2021 10:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U6ujbHSUA7iqsP/WPWf3tB4mwhXSTwP4Qqpjr1mTOi8=;
        b=KHHe6InfXX7AJPt4Z0K8/CN9MqwYed3cKjVlnqrs9k+MaDZv8a0Ou976qmAR4HDJtl
         emxG1LiIMt5N+Ug2t9VYuh5JhK2tp63Sh653196y1SUEyP9QPkank26Qouh9GU2LkHXJ
         9xE99HB7AOaVoVPVT+ZIL97G5QAgBaKXd1moF3HDMGfSjlwwQlFCQb0KEZwtXbWdnLnX
         GKc5FXSn3PkbYNuHSKPHS6bw/tsFXF6M1V27SuZovmv9XExJSBI7Y2kH5SKj88rO8fd6
         utQmC6IvFxn2JwJhqlxM0q3kW0NX7FHz0knIit1iwm1UA+NuROeZDV2zxTPfpwRopiKm
         IzRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U6ujbHSUA7iqsP/WPWf3tB4mwhXSTwP4Qqpjr1mTOi8=;
        b=z3JhFlBO9zs2Z2s63niJqb6WBayAfn4ikXt13yXN5+FZw99FkjDIvKu+sPWp8jaaxW
         8VPWk1yTAvSke/UY0LMMygHIo0W44Rw7qRABV2KmbfmbBF82UZ4rYssRGbYyPb9lAnqE
         A3o3EcYZDW+s3E5uakZ7EBnI2VIyo5QZ+r/UkI9lEY3wqZGgELLtPyMEZ+7i2z6UUc7n
         iBTXNloq3C+GCKXgBkRKlUPZ+Fg91GvNY6Ti4gBmdjft5ZiDMhLfQydBowKuWKgL+Vy/
         Pr4NqIrvXCoH+byqXPO4KVLFFZr1jKPH6VjawpcIDuyMi9AEJsqN+KViru407+ae/NVV
         qW+w==
X-Gm-Message-State: AOAM533+KPwkLfvg1Lvn27f0wF6yy3DFCVo8Nc2/6q5CyE9UjtRgo7zH
        r083wjuGTdRL6cFeB/tta4fEOsZwAck=
X-Google-Smtp-Source: ABdhPJyKP7oiTZlgfq1O16kizefKkrXHmtRx9iN+cao2szApMnUK1GLyoCy5YM3GvwI98E8qrExfNw==
X-Received: by 2002:a05:6e02:15c1:: with SMTP id q1mr6473463ilu.21.1637345681548;
        Fri, 19 Nov 2021 10:14:41 -0800 (PST)
Received: from john.lan ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id d2sm374505ilg.77.2021.11.19.10.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 10:14:41 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf 1/2] bpf, sockmap: Attach map progs to psock early for feature probes
Date:   Fri, 19 Nov 2021 10:14:17 -0800
Message-Id: <20211119181418.353932-2-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211119181418.353932-1-john.fastabend@gmail.com>
References: <20211119181418.353932-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a TCP socket is added to a sock map we look at the programs attached
to the map to determine what proto op hooks need to be changed. Before
the patch in the 'fixes' tag there were only two categories -- the empty
set of programs or a TX policy. In any case the base set handled the
receive case.

After the fix we have an optimized program for receive that closes a
small, but possible, race on receive. This program is loaded only
when the map the psock is being added to includes a RX policy.
Otherwise, the race is not possible so we don't need to handle the
race condition.

In order for the call to sk_psock_init() to correctly evaluate the
above conditions all progs need to be set in the psock before the
call. However, in the current code this is not the case. We end
up evaluating the requirements on the old prog state. If your psock
is attached to multiple maps -- for example a tx map and rx map --
then the second update would pull in the correct maps. But, the
other pattern with a single rx enabled map the correct receive
hooks are not used. The result is the race fixed by the patch in
the fixes tag below may still be seen in this case.

To fix we simply set all psock->progs before doing the call into
sock_map_init((). With this the init() call gets the full list
of programs and chooses the correct proto ops on the first
iteration instead of requiring the second update to pull them
in. This fixes the race case when only a single map is used.

Fixes: c5d2177a72a16 ("bpf, sockmap: Fix race in ingress receive verdict with redirect to self")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/sock_map.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index f39ef79ced67..9b528c644fb7 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -282,6 +282,12 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 
 	if (msg_parser)
 		psock_set_prog(&psock->progs.msg_parser, msg_parser);
+	if (stream_parser)
+		psock_set_prog(&psock->progs.stream_parser, stream_parser);
+	if (stream_verdict)
+		psock_set_prog(&psock->progs.stream_verdict, stream_verdict);
+	if (skb_verdict)
+		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
 
 	ret = sock_map_init_proto(sk, psock);
 	if (ret < 0)
@@ -292,14 +298,10 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 		ret = sk_psock_init_strp(sk, psock);
 		if (ret)
 			goto out_unlock_drop;
-		psock_set_prog(&psock->progs.stream_verdict, stream_verdict);
-		psock_set_prog(&psock->progs.stream_parser, stream_parser);
 		sk_psock_start_strp(sk, psock);
 	} else if (!stream_parser && stream_verdict && !psock->saved_data_ready) {
-		psock_set_prog(&psock->progs.stream_verdict, stream_verdict);
 		sk_psock_start_verdict(sk,psock);
 	} else if (!stream_verdict && skb_verdict && !psock->saved_data_ready) {
-		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
 		sk_psock_start_verdict(sk, psock);
 	}
 	write_unlock_bh(&sk->sk_callback_lock);
-- 
2.33.0

