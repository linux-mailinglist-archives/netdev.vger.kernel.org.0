Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DBC29716D
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 16:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750667AbgJWOiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 10:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750608AbgJWOiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 10:38:04 -0400
Received: from mail-ej1-x649.google.com (mail-ej1-x649.google.com [IPv6:2a00:1450:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82ECDC0613D2
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 07:38:04 -0700 (PDT)
Received: by mail-ej1-x649.google.com with SMTP id t1so671084ejb.21
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 07:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=lkEB5UgnL0/uPcgIYsa2/tgtKu7y0Eqzyava6I7oLiI=;
        b=c7XREw+qDm952frBEd1Y9tIboC4bfaP4Zgp7XLkn0yoy4EkmBwBjwP2z/9DdYzkwT3
         zHtkNpQUd+hmLIetiomEJd7WV/bp7Ji16StKNtTp55rgmhb2terYQFgi9fZUUBQ1cwTo
         spM7VCPZ8MUYQ4L4LvHG2kMYdfhcGdbkaqYIhXiEUuQxW2kjgyVtJ9OV+17z8DHadKDj
         or4txTajI+dWJp+AxaifAPlVXhP/0LSKoY0E5lHDcSZ54q+ToYC2cMeutanF4hi3cguj
         J1inMrFMJniOIDSpgOiBDMmylpYGYsFjG+TQpuphDPcqk9adr75UtP88tU9DkvhZSxOj
         Z8Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=lkEB5UgnL0/uPcgIYsa2/tgtKu7y0Eqzyava6I7oLiI=;
        b=entnWnv1VbFmqfNGfv55EZraCeMWlu6eZ8uYo2PatFqjGqklRjvViC0wgtP1xxI0hB
         zlCprFPU3MX5+zMepI5O3PMrjOQCVETaIHsIBx25OYSWxhCWgkMSFx4NGcorKJFg7av2
         MxLbiEuPlKdHJmRBjf8/TVwpXcoM9plw6teOZ1Hy8Wv/RksvlccAnbB1oNBteMe3kZPv
         lUgT/a74uygCWppJ1hiTqvTXTZkpgMEja5vhaA3xdEcEnMdDKs7SmJOBBGDcHj2Yu9MC
         Agqh19MGrIU7UmveZ/TK4VBG0VCeRiXAT2hpf1Eu5w8e7s/dEEQ2wLOrezW9levLABek
         /mrw==
X-Gm-Message-State: AOAM533x6aPCbMRKjzpyLWNnQ1NXBg9Gowfct2D8GcbrKHKGmN/ODqP+
        0/L99W61l2F0vWkvop27NkrfsAYC8g==
X-Google-Smtp-Source: ABdhPJxi7fxPgwdq8S9rEeUOz5dR2CdJ3XjVEKldqIhMVLe36M+aTiYHGWQq18i6VY1NPQK5+trkypnA5Q==
Sender: "jeffv via sendgmr" <jeffv@jeffv-p920.zrh.corp.google.com>
X-Received: from jeffv-p920.zrh.corp.google.com ([2a00:79e0:61:100:f693:9fff:fef4:a4e3])
 (user=jeffv job=sendgmr) by 2002:a17:906:5488:: with SMTP id
 r8mr2181106ejo.483.1603463881866; Fri, 23 Oct 2020 07:38:01 -0700 (PDT)
Date:   Fri, 23 Oct 2020 16:37:57 +0200
Message-Id: <20201023143757.377574-1-jeffv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
Subject: [PATCH] vsock: use ns_capable_noaudit() on socket create
From:   Jeff Vander Stoep <jeffv@google.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-security-module@vger.kernel.org,
        Jeff Vander Stoep <jeffv@google.com>,
        Roman Kiryanov <rkir@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During __vsock_create() CAP_NET_ADMIN is used to determine if the
vsock_sock->trusted should be set to true. This value is used later
for determing if a remote connection should be allowed to connect
to a restricted VM. Unfortunately, if the caller doesn't have
CAP_NET_ADMIN, an audit message such as an selinux denial is
generated even if the caller does not want a trusted socket.

Logging errors on success is confusing. To avoid this, switch the
capable(CAP_NET_ADMIN) check to the noaudit version.

Reported-by: Roman Kiryanov <rkir@google.com>
https://android-review.googlesource.com/c/device/generic/goldfish/+/1468545/
Signed-off-by: Jeff Vander Stoep <jeffv@google.com>
---
 net/vmw_vsock/af_vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 9e93bc201cc0..b4d7b8aba003 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -739,7 +739,7 @@ static struct sock *__vsock_create(struct net *net,
 		vsk->buffer_min_size = psk->buffer_min_size;
 		vsk->buffer_max_size = psk->buffer_max_size;
 	} else {
-		vsk->trusted = capable(CAP_NET_ADMIN);
+		vsk->trusted = ns_capable_noaudit(&init_user_ns, CAP_NET_ADMIN);
 		vsk->owner = get_current_cred();
 		vsk->connect_timeout = VSOCK_DEFAULT_CONNECT_TIMEOUT;
 		vsk->buffer_size = VSOCK_DEFAULT_BUFFER_SIZE;
-- 
2.29.0.rc2.309.g374f81d7ae-goog

