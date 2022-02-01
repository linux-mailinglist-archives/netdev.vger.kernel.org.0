Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33D44A642B
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 19:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbiBASqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 13:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbiBASqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 13:46:45 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4DFC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 10:46:45 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id c9so16090337plg.11
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 10:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T4v4iG6BPiAhaeyhDlT8GX3QWqH0ZKOSsu4txlsdYEc=;
        b=KKZFBOSQ3yHf4ey1DKAuoYNwprBkEv6UtjNt1I9PtY574KY3kabxyG9wT3ER0JnIH4
         8tGCj4lx4gygUKehEeM6QA+KuuuY4D5sgSfnlShKkqTDpq6WvAkU/It9aZaCRDgmUEeU
         e3BqMek4+BY/Cfss7tYINdGw8EK5lRk3sxyITd3AlQRkvoBBIkYx+20b2qpXsOhhgw7h
         QtsppnlHbxJw7qdzcJiB46LUQIBImlo9KxUdhz4vjla1Co3+enjtmSHk29jqWkEURVS/
         538tDIHVO3WugTqv6jOCsLiO0tRkJXPUSS44DcopoUYIUOvKj1ZvrqeuIXxOyzVPt1eB
         Szqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T4v4iG6BPiAhaeyhDlT8GX3QWqH0ZKOSsu4txlsdYEc=;
        b=SEntiS07en5hZ2bRTy5EXoK6LGeG6sdoJixFk64Nzj4unHXQt25n+ThK9LkPzsgrTK
         8Zu5e12SvrVfRGwAz2/etxGqs/Y5OMoJSyjQRz9lx52My/l1QPmtCjSohkErf+ruUJFu
         qB0THxAS5ToX4M8oLEbyON4ImxsJ/dlR+bff6jfNwoAjPr6o0i0WGXvoXsP1IQ99zuFP
         9iol5fYnldhL05eioEfmkjFliKdLSHKHjk6qGti5pJ1F05nLmTz4FnJWWY4Yo7EfiJNP
         CmES21GrxseNKacjK3gw1qfc2FTsYAyINXsGPPd4TlkoO91v486eg6mWnK9UPHuI/Nt6
         mA0w==
X-Gm-Message-State: AOAM532MXEqdLs85P1gAlq2k90Uks1uKh8Bf53s5zoFCKJUz7oPdg4YL
        S5n1kdtFMH2EH++x3rF/wCQ=
X-Google-Smtp-Source: ABdhPJzerzpkoxB0UIQAupGTftZ8PmPYEqHABT5vPHCyA5M2wvtcHvff5TPHyZKl5xA2IMXjrxX9BA==
X-Received: by 2002:a17:902:d641:: with SMTP id y1mr6038623plh.64.1643741205054;
        Tue, 01 Feb 2022 10:46:45 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:13fc:305f:6f9b:9f4d])
        by smtp.gmail.com with ESMTPSA id d4sm23349019pgw.30.2022.02.01.10.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 10:46:44 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Talal Ahmad <talalahmad@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] tcp: add missing tcp_skb_can_collapse() test in tcp_shift_skb_data()
Date:   Tue,  1 Feb 2022 10:46:40 -0800
Message-Id: <20220201184640.756716-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

tcp_shift_skb_data() might collapse three packets into a larger one.

P_A, P_B, P_C  -> P_ABC

Historically, it used a single tcp_skb_can_collapse_to(P_A) call,
because it was enough.

In commit 85712484110d ("tcp: coalesce/collapse must respect MPTCP extensions"),
this call was replaced by a call to tcp_skb_can_collapse(P_A, P_B)

But the now needed test over P_C has been missed.

This probably broke MPTCP.

Then later, commit 9b65b17db723 ("net: avoid double accounting for pure zerocopy skbs")
added an extra condition to tcp_skb_can_collapse(), but the missing call
from tcp_shift_skb_data() is also breaking TCP zerocopy, because P_A and P_C
might have different skb_zcopy_pure() status.

Fixes: 85712484110d ("tcp: coalesce/collapse must respect MPTCP extensions")
Fixes: 9b65b17db723 ("net: avoid double accounting for pure zerocopy skbs")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: Talal Ahmad <talalahmad@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 net/ipv4/tcp_input.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index dc49a3d551eb919baf5ad812ef21698c5c7b9679..bfe4112e000c09ba9d7d8b64392f52337b9053e9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1660,6 +1660,8 @@ static struct sk_buff *tcp_shift_skb_data(struct sock *sk, struct sk_buff *skb,
 	    (mss != tcp_skb_seglen(skb)))
 		goto out;
 
+	if (!tcp_skb_can_collapse(prev, skb))
+		goto out;
 	len = skb->len;
 	pcount = tcp_skb_pcount(skb);
 	if (tcp_skb_shift(prev, skb, pcount, len))
-- 
2.35.0.rc2.247.g8bbb082509-goog

