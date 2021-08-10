Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047623E51E8
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 06:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237523AbhHJESS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237239AbhHJER4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 00:17:56 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A092CC0617A2;
        Mon,  9 Aug 2021 21:17:28 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id nt11so8077384pjb.2;
        Mon, 09 Aug 2021 21:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UwpAuyr31gkKRzWsz22ieldVxq1Gat0ivFQ8uoQ/1c0=;
        b=lq2jd3xIHLY37an7XRk+QppmVqTj4iNl7/RA67QNjQEKC+/uBuVqX14eOxEI5zEPFa
         R2zink3dMmRn6ybKqDCTzCt04j3i7lChM0tXIj2vqUKf5ZdmHPgyRdwpwHJvfWgRcvLL
         ctg9uozZPXx9+7DBQFZs6Iuog3Szc4d6wMYZnLBKO0C2Av1eMz3TJ2bXa1RJAr12/mrf
         5nTgz0rrDIhELW4X2T4Xjtu6hmhnzqRT4CFE0dNMtL75rGicYwDW3yNkNOr3WIgh6rvh
         eAA0FBfdGJwyLrRJtEyD6WtrXCzEiEJ8bLFG1Y7IkyuurbXSuD8p7dEcD372IOg10VOd
         0L3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UwpAuyr31gkKRzWsz22ieldVxq1Gat0ivFQ8uoQ/1c0=;
        b=UBZVuwuQnbLOi144eFXUFWcyoNu6+SrE+8EI6NFWoGzGqWVR3E4wH+/such6TAsp0L
         LNhUQW82xb+zJL0Z88gsZkJRu6JLaIEcDk7FUWHOE2VCLeMH9kA3UHs3R96rFphL5ey4
         7syD/IAfaWNIe8NjBKcTJ+1qK1vQUtq2pQP46pVFvkjMGkDOWE4eLF9T6S/IrPMElvlG
         YNabCfs1K/QOXILCe17OhTYm9SB4Z7kOH6ZODANW99TXdWugxE60VxcZiDGGJKqDO/TM
         5eE24otIDBz+c84t8gyKTWLqEeDJ0tZOpoPS5+eEf725drtYr7KQK/vU6UDW/YXhT2fa
         FmJg==
X-Gm-Message-State: AOAM533YRdyM4Ggibl4IDZGnuLt545LOGfnWKZxdkA9AHm552XKQNBQD
        tap/POYUaju5Lth+puWT1Rg=
X-Google-Smtp-Source: ABdhPJwfVFJuhXJPcZXKtGefX5s0S/tksX1yVjiMp1lHAxU9y1q4ypqE+xB6yKezuwfNPblMowqt5w==
X-Received: by 2002:a17:90b:3653:: with SMTP id nh19mr2695305pjb.169.1628569048241;
        Mon, 09 Aug 2021 21:17:28 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id b8sm20132478pjo.51.2021.08.09.21.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 21:17:27 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, sudipm.mukherjee@gmail.com
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v6 5/6] Bluetooth: switch to lock_sock in RFCOMM
Date:   Tue, 10 Aug 2021 12:14:09 +0800
Message-Id: <20210810041410.142035-6-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810041410.142035-1-desmondcheongzx@gmail.com>
References: <20210810041410.142035-1-desmondcheongzx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Other than rfcomm_sk_state_change and rfcomm_connect_ind, functions in
RFCOMM use lock_sock to lock the socket.

Since bh_lock_sock and spin_lock_bh do not provide synchronization
with lock_sock, these calls should be changed to lock_sock.

This is now safe to do because packet processing is now done in a
workqueue instead of a tasklet, so bh_lock_sock/spin_lock_bh are no
longer necessary to synchronise between user contexts and SOFTIRQ
processing.

Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
---
 net/bluetooth/rfcomm/sock.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index ae6f80730561..2c95bb58f901 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -70,7 +70,7 @@ static void rfcomm_sk_state_change(struct rfcomm_dlc *d, int err)
 
 	BT_DBG("dlc %p state %ld err %d", d, d->state, err);
 
-	spin_lock_bh(&sk->sk_lock.slock);
+	lock_sock(sk);
 
 	if (err)
 		sk->sk_err = err;
@@ -91,7 +91,7 @@ static void rfcomm_sk_state_change(struct rfcomm_dlc *d, int err)
 		sk->sk_state_change(sk);
 	}
 
-	spin_unlock_bh(&sk->sk_lock.slock);
+	release_sock(sk);
 
 	if (parent && sock_flag(sk, SOCK_ZAPPED)) {
 		/* We have to drop DLC lock here, otherwise
@@ -974,7 +974,7 @@ int rfcomm_connect_ind(struct rfcomm_session *s, u8 channel, struct rfcomm_dlc *
 	if (!parent)
 		return 0;
 
-	bh_lock_sock(parent);
+	lock_sock(parent);
 
 	/* Check for backlog size */
 	if (sk_acceptq_is_full(parent)) {
@@ -1001,7 +1001,7 @@ int rfcomm_connect_ind(struct rfcomm_session *s, u8 channel, struct rfcomm_dlc *
 	result = 1;
 
 done:
-	bh_unlock_sock(parent);
+	release_sock(parent);
 
 	if (test_bit(BT_SK_DEFER_SETUP, &bt_sk(parent)->flags))
 		parent->sk_state_change(parent);
-- 
2.25.1

