Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFADE3E04C7
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239471AbhHDPtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239515AbhHDPtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 11:49:07 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204BDC06179A;
        Wed,  4 Aug 2021 08:48:54 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so6125309pji.5;
        Wed, 04 Aug 2021 08:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UwpAuyr31gkKRzWsz22ieldVxq1Gat0ivFQ8uoQ/1c0=;
        b=tEUlbrGx7uWgTk+Yiuzx3PF5upDZnEKvMC7rC8etWlR9ez5J/YDtuPhjqo4v2GebzO
         VLI3xt14nJAIKyLSCDqvNQwd1FYMjV2tlv/6PW3aqrIe5f4gpFIHZGZkDQuZkJZ8puKl
         XoMFqpLQy2XENACDC1UY0nf3A70oZt4JwbhUCdMhejjpwDX7FqcLe/o262ewwjaUVxsC
         iQHBMWJ0UQh7ocqbt5sOKd/Q5rcrB6jOD+XqZueye8QZ8wLWSRWtVdV1Exxq3KHn0ge1
         bcagkhmas9zQxiHT7DBSeIyrmlATtbdAcWEl+pemT6dJLiWmDz054ehJ6fsKYF/ShCdX
         wdeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UwpAuyr31gkKRzWsz22ieldVxq1Gat0ivFQ8uoQ/1c0=;
        b=ar5VUxhuaUT8eiziKerwsp0gNwnAiaNGB8YCr/vJksKibrk4LAOT/hcQlF9HL2wttr
         nZmEn7DgmQmxdgokpU1lWweGo07RQ6efkUl88+ZPrPCT7qHaIigS8H1/0UA6N0EtBAA5
         CUraff9PmwFOM4Va0VupnNqcK76o7U4No527+y16sN4Et2vJnIICAdohhXwuZinBMhdB
         5Bf6A35ZfwFSp5JaiOaFTNdrwmPRgxoKmGYneQTxCwdlBqaFxuKR4LSYdc/S39knPPd+
         lfVOLrScM6bpB5IyMkHIcr4tzan28Ny5ahjrt9w0Uv3wVvs5y9wRzJ2ukydaTyQ8mAsQ
         YC7Q==
X-Gm-Message-State: AOAM533cMSkL+qDztBtG8eRt3/LmjACpXzwaM2ABUAZP5TgZ3YvgN51z
        W446ScNjcpoXoawGveLxOBc=
X-Google-Smtp-Source: ABdhPJy53E2/k6DHqfUA8ASbwd2KosGoA+p9Idp0D8kBhX/RdBw3l0POikQNvzDaf8W3swv+zT9rwQ==
X-Received: by 2002:a63:950a:: with SMTP id p10mr76260pgd.362.1628092133695;
        Wed, 04 Aug 2021 08:48:53 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id b15sm4007274pgj.60.2021.08.04.08.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 08:48:53 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, sudipm.mukherjee@gmail.com
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [RESEND PATCH v5 5/6] Bluetooth: switch to lock_sock in RFCOMM
Date:   Wed,  4 Aug 2021 23:47:11 +0800
Message-Id: <20210804154712.929986-6-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804154712.929986-1-desmondcheongzx@gmail.com>
References: <20210804154712.929986-1-desmondcheongzx@gmail.com>
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

