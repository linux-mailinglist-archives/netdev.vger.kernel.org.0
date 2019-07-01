Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7608E5C5F7
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 01:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfGAXms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 19:42:48 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41640 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfGAXmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 19:42:47 -0400
Received: by mail-pl1-f194.google.com with SMTP id m7so8084421pls.8
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 16:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/1gFnr0TRR2O3FrkKYtrpBMih30lPMQm08/0jo878LU=;
        b=RbaR1CGorAnHwg8FKM9bcyODEuwoYJP/M0w052lY2ZCB+nEFaFR9tGs0jADg2uSoJJ
         1HDAEnAbsPVf5ue4PWcnvhegWZWUmmaTGqru+XueNMNBC7F3h/HO0ajjFRsLL+/cxNpJ
         AJKYhJuiSaevSWnZsr0ivrbQNZqyRAKMD0plo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/1gFnr0TRR2O3FrkKYtrpBMih30lPMQm08/0jo878LU=;
        b=uecmMdx/ogL2/6d/k1WZV84cCws49JJNTSiCc9S3v0I6CM0WULzTfqKOnhMbYjRr2c
         S7Vhhskh3Q1O8V9ZuE/GOtXQr74gvFXpt/EdzXBCia60vxDSwg9G9JkA3tA9VO9rp9vo
         wZMBb2OhtTLl9FHtwqzF4G9bi+HAuzloWqYo6hCXh24GkcP01TxTDf/tTRepuUxlXpA0
         cgFMEvWBQsmnvJ4ORj9lRBg7qvmdM3fNJvZjgp7u36+WLfNnlNTZ2Z0e4e81vlf0bGLn
         sFNEwPcnqYRDjHBW9suNElhuyQOcNnWlSULoYsb2UmGCQnykkVU0B/wLIicPmh85RH+R
         jg8g==
X-Gm-Message-State: APjAAAUms5NTUMdHIUkd41bdUUzcoyATJqeei1rkUd1ifBC7/39BX+vy
        dcFLOyPCiz2vhW4M4JQ/kz7F
X-Google-Smtp-Source: APXvYqyNSKz1gT/iRKaIQQquDe8Q0lrmObw5tu5nQIPPoUqKGuIs+8sMxeLq0U0tzq6Zz5/11Fu7/A==
X-Received: by 2002:a17:902:b093:: with SMTP id p19mr30781404plr.141.1562024567104;
        Mon, 01 Jul 2019 16:42:47 -0700 (PDT)
Received: from debian9-jae.jaalam.net (64-46-6-129.dyn.novuscom.net. [64.46.6.129])
        by smtp.gmail.com with ESMTPSA id b36sm609336pjc.16.2019.07.01.16.42.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 16:42:46 -0700 (PDT)
From:   Josh Elsasser <jelsasser@appneta.com>
To:     stable@vger.kernel.org
Cc:     Josh Elsasser <jelsasser@appneta.com>, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Matteo Croce <mcroce@redhat.com>
Subject: [PATCH RESEND 4.9.y] net: check before dereferencing netdev_ops during busy poll
Date:   Mon,  1 Jul 2019 16:41:43 -0700
Message-Id: <20190701234143.72631-1-jelsasser@appneta.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

init_dummy_netdev() leaves its netdev_ops pointer zeroed. This leads
to a NULL pointer dereference when sk_busy_loop fires against an iwlwifi
wireless adapter and checks napi->dev->netdev_ops->ndo_busy_poll.

Avoid this by ensuring napi->dev->netdev_ops is valid before following
the pointer, avoiding the following panic when busy polling on a dummy
netdev:

  BUG: unable to handle kernel NULL pointer dereference at 00000000000000c8
  IP: [<ffffffff817b4b72>] sk_busy_loop+0x92/0x2f0
  Call Trace:
   [<ffffffff815a3134>] ? uart_write_room+0x74/0xf0
   [<ffffffff817964a9>] sock_poll+0x99/0xa0
   [<ffffffff81223142>] do_sys_poll+0x2e2/0x520
   [<ffffffff8118d3fc>] ? get_page_from_freelist+0x3bc/0xa30
   [<ffffffff810ada22>] ? update_curr+0x62/0x140
   [<ffffffff811ea671>] ? __slab_free+0xa1/0x2a0
   [<ffffffff811ea671>] ? __slab_free+0xa1/0x2a0
   [<ffffffff8179dbb1>] ? skb_free_head+0x21/0x30
   [<ffffffff81221bd0>] ? poll_initwait+0x50/0x50
   [<ffffffff811eaa36>] ? kmem_cache_free+0x1c6/0x1e0
   [<ffffffff815a4884>] ? uart_write+0x124/0x1d0
   [<ffffffff810bd1cd>] ? remove_wait_queue+0x4d/0x60
   [<ffffffff810bd224>] ? __wake_up+0x44/0x50
   [<ffffffff81582731>] ? tty_write_unlock+0x31/0x40
   [<ffffffff8158c5c6>] ? tty_ldisc_deref+0x16/0x20
   [<ffffffff81584820>] ? tty_write+0x1e0/0x2f0
   [<ffffffff81587e50>] ? process_echoes+0x80/0x80
   [<ffffffff8120c17b>] ? __vfs_write+0x2b/0x130
   [<ffffffff8120d09a>] ? vfs_write+0x15a/0x1a0
   [<ffffffff81223455>] SyS_poll+0x75/0x100
   [<ffffffff819a6524>] entry_SYSCALL_64_fastpath+0x24/0xcf

Commit 79e7fff47b7b ("net: remove support for per driver ndo_busy_poll()")
indirectly fixed this upstream in linux-4.11 by removing the offending
pointer usage. No other users of napi->dev touch its netdev_ops.

Fixes: ce6aea93f751 ("net: network drivers no longer need to implement ndo_busy_poll()") # 4.9.y
Signed-off-by: Josh Elsasser <jelsasser@appneta.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Tested-by: Matteo Croce <mcroce@redhat.com>
---

No changes since V2[1], resent as per discussiond on -stable[2]. I hope
this is the correct way to send net fixes for older LTS releases, I'm
going off of the latest netdev FAQ:

   For earlier stable releases, each stable branch maintainer is supposed
   to take care of them. If you find any patch is missing from an earlier
   stable branch, please notify stable@vger.kernel.org with either a commit
   ID or a formal patch backported, and CC Dave and other relevant networking
   developers.

[1]: https://patchwork.ozlabs.org/patch/884986/
[2]: https://lore.kernel.org/stable/CAGnkfhx3ykbEsW+=FtpMFWU=_Vnie7RpPYWpWqa1S1HPMXj9kw@mail.gmail.com/


 net/core/dev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/net/core/dev.c b/net/core/dev.c
index 4e10bae5e3da..f693afe608d7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5083,7 +5083,10 @@ bool sk_busy_loop(struct sock *sk, int nonblock)
 		goto out;
 
 	/* Note: ndo_busy_poll method is optional in linux-4.5 */
-	busy_poll = napi->dev->netdev_ops->ndo_busy_poll;
+	if (napi->dev->netdev_ops)
+		busy_poll = napi->dev->netdev_ops->ndo_busy_poll;
+	else
+		busy_poll = NULL;
 
 	do {
 		rc = 0;
-- 
2.20.1

