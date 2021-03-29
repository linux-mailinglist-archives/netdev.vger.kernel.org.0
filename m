Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F2234D6FF
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 20:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbhC2SZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 14:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbhC2SYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 14:24:54 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4021C061756
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 11:24:53 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id j4so5420809wru.20
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 11:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=3A2HnuqDWt0hrB7HFwLWTRBVAD8LSqlp0bvnWL8yz+0=;
        b=cMewxXvoD8vVRO5FJwiSXf98qU9wJxxkCjjjuRDLLAhPJIR5U0k++ZkuluBA6bjM+T
         GnPGerIXfCSD8z3149hbhjGmtOA6hWmFz05yrCUrVFyNyD2nu5Syu7yKMRjAFzA3GnIX
         0zYgC1c4sD2TKVaCSHreifwtmJTTIBKGrKXvqAvfCCFoKR7MBY5XWIWWoB1dwlR7EZ5o
         FOAWEc71zx51Dwg6i5jZgKpXE3fa44ouchuLD+AM7ZEqA/cZzYWoqMLNBAbSqaf7gr8e
         wnvxl+WNF+wCZyfYTZcr/vk6le/lzgC4EOW9aL9o/nPwXungC7d0qkfG3IcGlI+kVuTw
         eYcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=3A2HnuqDWt0hrB7HFwLWTRBVAD8LSqlp0bvnWL8yz+0=;
        b=LImL2eKhZllyOw2Mhb20l4DklL0kAgbE3eXl+SWf4ZG+XBcLhwcD3nC0bIlU80A0af
         YLeo+JvGEGA/TrtRcAZ6LykS4x1fhMHXcweTLVj3bRLemm4cFHvjKRAUEPpvmUTJkv9E
         5Y7FOIYcwQGHDgjgiVe6k3Xzu1n88g2NE8TksBcZo2CBZkEBe97Tj8MwRDt+fcwERa36
         bsb5dyMCWDiwU2CW2h+R+dvfQH2+5mASbwaGdf8/bBb3AETWJ32Q25YlDzQr/oDE2Mj/
         Vl3gcaqXFCo9QN/aYgqHY/0BgZOfZQ/KQw1VFC5Zac/Eq1qC54UEvY8QLPT+bbu6HO4l
         ApAw==
X-Gm-Message-State: AOAM533TLPVc0TxJCLhSi89M/zIOEnoPMUnWnArHaztdYaraPDs7s4Eh
        mOIoV53E/5V8nsMavvLmYOfkzXcI1Ou0dg==
X-Google-Smtp-Source: ABdhPJxz4Z/L8D0g7pP+18CTmmEPETBH+DQrPIxvCzREEY6g+OeK5V0uc6jDB5nx3m7FlF1gSc/gjeiuMpE/vw==
X-Received: from dbrazdil.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:7f9b])
 (user=dbrazdil job=sendgmr) by 2002:adf:a519:: with SMTP id
 i25mr29852666wrb.250.1617042291844; Mon, 29 Mar 2021 11:24:51 -0700 (PDT)
Date:   Mon, 29 Mar 2021 18:24:43 +0000
Message-Id: <20210329182443.1960963-1-dbrazdil@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH pre-5.10] selinux: vsock: Set SID for socket returned by accept()
From:   David Brazdil <dbrazdil@google.com>
To:     stable@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <jamorris@linux.microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        David Brazdil <dbrazdil@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Backport of commit 1f935e8e72ec28dddb2dc0650b3b6626a293d94b to all
stable branches from 4.4 to 5.4, inclusive]

For AF_VSOCK, accept() currently returns sockets that are unlabelled.
Other socket families derive the child's SID from the SID of the parent
and the SID of the incoming packet. This is typically done as the
connected socket is placed in the queue that accept() removes from.

Reuse the existing 'security_sk_clone' hook to copy the SID from the
parent (server) socket to the child. There is no packet SID in this
case.

Cc: stable@vger.kernel.org
Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/vmw_vsock/af_vsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 5d323574d04f..c82e7b52ab1f 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -620,6 +620,7 @@ struct sock *__vsock_create(struct net *net,
 		vsk->trusted = psk->trusted;
 		vsk->owner = get_cred(psk->owner);
 		vsk->connect_timeout = psk->connect_timeout;
+		security_sk_clone(parent, sk);
 	} else {
 		vsk->trusted = ns_capable_noaudit(&init_user_ns, CAP_NET_ADMIN);
 		vsk->owner = get_current_cred();
-- 
2.31.0.291.g576ba9dcdaf-goog

