Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A88E3DFFDD
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 13:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237890AbhHDLEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 07:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237858AbhHDLEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 07:04:34 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A39CC061798;
        Wed,  4 Aug 2021 04:04:21 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id q2so2559683plr.11;
        Wed, 04 Aug 2021 04:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UwpAuyr31gkKRzWsz22ieldVxq1Gat0ivFQ8uoQ/1c0=;
        b=IM7eV7s8h8oFYEZBdNbbFFs+g+dar5PebK/L8YnXDu3Z5PGgxd77mFB8JWljt0SZnl
         2MLFfuX8mwFlVtwZaehF9jl1g/PHF+WPqcycPWDVhYIgrb/bQX12xkS9sqAaV3rBe3da
         ZdPsjSkjCGoyihie7JzyM8bkgiFjEReMtY0m1kZfbwInoqveOX7pNkT28JxaKz3gpbTd
         9pzmWSmVTSQsw+E/UbbCrrNdHt2s9RsXlVtpIAnDlhp9lucv8DMoK2pN6XmzXXvjrowm
         XH0rRW4hVlGbxyPPP8sVo7LD4fts7oL9rSteKEIbE+iAml+pyQtfskdTsxbc+IwYkKJh
         LXPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UwpAuyr31gkKRzWsz22ieldVxq1Gat0ivFQ8uoQ/1c0=;
        b=qvzC51QS0PjB7aP1lrq5Bm2RNkJKms6sP3uILZwggJI7DNagKjm8yzEeFzxxD2QSf0
         Cxv6VlRyukaSVRnB3cRgsvpjvhHM6c8zgLaLH8nuVLTNgSaGAKKwQg6yv1WFjtTSZu6n
         Jm9tiOK0WVskuq081whszyygWqq8oemHn1YzRUgonCCoZ5kXtj+g9Cy/T23NqZsHguzt
         WVfi1XfuEsj1vvSYB5WMsO+NexsQmZriudMXaRO9zYWaXw5d50/q24GF7QZYYgOc1jrQ
         SyYR8JoDQ2rjRMvnUj803aVezfurCBvpZxXnSFcMoQytplzNK/qMt3E/kFvwv2UgV26l
         VzWg==
X-Gm-Message-State: AOAM533ZBsjRbnhON9C9R9ldaGMZ/+CiwJXGKI5+EtYtd7OyuVxMBKTV
        ep1kWxYOLA3eopBd06UZI44=
X-Google-Smtp-Source: ABdhPJyGnCZuFwDmG+LmB5XddxwPsrpPy+oRZJaIgcMNVyhKK2wnXpX3hpbc+tN6NIbFhc9hHe0Aow==
X-Received: by 2002:a17:90a:c003:: with SMTP id p3mr27366487pjt.14.1628075061236;
        Wed, 04 Aug 2021 04:04:21 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id k4sm2206147pjs.55.2021.08.04.04.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 04:04:20 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, sudipm.mukherjee@gmail.com
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v5 5/6] Bluetooth: switch to lock_sock in RFCOMM
Date:   Wed,  4 Aug 2021 19:03:07 +0800
Message-Id: <20210804110308.910744-6-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804110308.910744-1-desmondcheongzx@gmail.com>
References: <20210804110308.910744-1-desmondcheongzx@gmail.com>
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

