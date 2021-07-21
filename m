Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782DE3D0C2B
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 12:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237781AbhGUJTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 05:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237675AbhGUI6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 04:58:38 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2FDC061574;
        Wed, 21 Jul 2021 02:39:13 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id o201so1822482pfd.1;
        Wed, 21 Jul 2021 02:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PjuFR6HuAqzaOBzOINC7ROg0fkvdUGdT6kDWetuSLNA=;
        b=SSCMiLxpMlxDqbev6KyNKRINcMP3ATB1bD6BU81Vvu2ZLhmmYWvvW7tLTpTRsZwiok
         X/zYaEqz1uBEy4/emehHUpmEcxqHijdIe8NcOQW0Z6Zs7uDseVws5e11QoXA27pSP9Um
         QApdrIp4/agvt8Kapy9jJd0pSsQFh83oL+uBU02Y7gfv2KWuG398YZ7CpCO/TxfBrrhL
         bR6qKXCIc5MiM3fOWgCmmi88NuFSUv46ylmwA7Ozn8qBpzvK9FJ/u1zFsuS+HXJeGGGr
         mu5mj32xp/g019exxf4psjgpRD3lq8noTrPiyVCMZbhdF7nDJPIrIOWiZFgZlCnAsO1B
         BPZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PjuFR6HuAqzaOBzOINC7ROg0fkvdUGdT6kDWetuSLNA=;
        b=DY1jtTyM6JcojqYKo0k7cP+YhwedjIxFGM8kIgYL5HmFuQfE977rkVG0sxA1oC/81S
         OHw3VQALOYATL+pXIxRm9WDjbSG6fL7f6JKKthgZqbC3L1KGNOv3sCTD2wVxnVaoTZCK
         8pyVdXGIly/YovOkdIcF0B0z73Y12SGipGwdZI37m6AjQeJVtutLG1th6lfR3hsm47vW
         pU4AF/1TFDHQPLzwi1gFELiX7JBYzgSvOzf4SBNNrL+fhR32MczxMaApK/jdQEVt5dma
         X1eZEdZGLIwCEbGpm53rSftpjqGlJNxdK3m/5QFwIoxsX35Dvj0YR5snRLsuLHA+LbFa
         qDSQ==
X-Gm-Message-State: AOAM531X9CspJC1m3G1biwbnv8s7PYdOjVizqj5xIFUQF5G3y0sjqI6r
        InbNbmMd6PFd8t3rR31Ngu4=
X-Google-Smtp-Source: ABdhPJyLWYQsZQ+eLcP51gJqr+yNhWz6CITIUAHfjWRVt8BqikE1aEmB7DhdUoi1JBVeW317BZfy/A==
X-Received: by 2002:a63:e643:: with SMTP id p3mr34526522pgj.213.1626860353146;
        Wed, 21 Jul 2021 02:39:13 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id j129sm27311956pfb.132.2021.07.21.02.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 02:39:12 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        stefan@datenfreihafen.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v3 2/2] Bluetooth: fix inconsistent lock state in rfcomm_connect_ind
Date:   Wed, 21 Jul 2021 17:38:32 +0800
Message-Id: <20210721093832.78081-3-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210721093832.78081-1-desmondcheongzx@gmail.com>
References: <20210721093832.78081-1-desmondcheongzx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit fad003b6c8e3d ("Bluetooth: Fix inconsistent lock state with
RFCOMM") fixed a lockdep warning due to sk->sk_lock.slock being
acquired without disabling softirq while the lock is also used in
softirq context. This was done by disabling interrupts before calling
bh_lock_sock in rfcomm_sk_state_change.

Later, this was changed in commit e6da0edc24ee ("Bluetooth: Acquire
sk_lock.slock without disabling interrupts") to disable softirqs
only.

However, there is another instance of sk->sk_lock.slock being acquired
without disabling softirq in rfcomm_connect_ind. This patch fixes this
by disabling local bh before the call to bh_lock_sock.

Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
---
 net/bluetooth/rfcomm/sock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index ae6f80730561..d8734abb2df4 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -974,6 +974,7 @@ int rfcomm_connect_ind(struct rfcomm_session *s, u8 channel, struct rfcomm_dlc *
 	if (!parent)
 		return 0;
 
+	local_bh_disable();
 	bh_lock_sock(parent);
 
 	/* Check for backlog size */
@@ -1002,6 +1003,7 @@ int rfcomm_connect_ind(struct rfcomm_session *s, u8 channel, struct rfcomm_dlc *
 
 done:
 	bh_unlock_sock(parent);
+	local_bh_enable();
 
 	if (test_bit(BT_SK_DEFER_SETUP, &bt_sk(parent)->flags))
 		parent->sk_state_change(parent);
-- 
2.25.1

