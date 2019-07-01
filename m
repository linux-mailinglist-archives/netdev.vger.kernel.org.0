Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 718AC5C5FB
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 01:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfGAXtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 19:49:51 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37072 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfGAXtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 19:49:51 -0400
Received: by mail-pg1-f195.google.com with SMTP id g15so4847047pgi.4
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 16:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HUtQgswb3xQ3WOlcNU5RSVl6qVgTLnoNUqQDufVCLK8=;
        b=cTOcMnfbwPu+d9AFojXbx5XQqonbLmyM68qZ/LRWbWMyQGI970Fsbokkr0Nr8ADLq/
         4LBb/kbpN7YxavOhch1ZB2vom9DNtwAANgEOxU8lq142dEnHwtkPz6lSna0gYK9JcTkp
         Ywa51xSnjIpUZ6ui3J0kOyPtN5YgKWMDeDRyw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HUtQgswb3xQ3WOlcNU5RSVl6qVgTLnoNUqQDufVCLK8=;
        b=D4+WjfeMd1F+K96oOU1IRNSmnyjMtvJ3C/IvhzY2wUJu50Qb/NOVKcsLMrVcxsZ2ee
         os4IXSZnrB8JSuzOKK4qL5NCXfbOegxVqXq/VT8PZBFYn5AH84uAw1qeGu1B3klw302K
         yp9pmPtTeu0mfyo46SvkEuxLNnGAdu2dQhagGvGxgpO7Y1jvTCauBM3Ebt6DRIwGoh5m
         MzN5UQbxHkAxui5MWN6hAFPQnQnJ8p/XyxLzbFHBohsm3Gw5CIYyYN0+wwtYS/6buVdm
         jGgi/SDuyg62z5BaTIg1rRF747KE7/FqJzjSPrzqKRn3q7+N2BP3PIixb8twhcGRY1Mz
         F+4Q==
X-Gm-Message-State: APjAAAXa7UHYFsSWv1M4216HZ9HVlfOYeU2VBDVOjx9jNqqYZwvKp+2B
        Pl6WxX4uzsFhfGyEiOZYan8Xpwom8PhO/CY=
X-Google-Smtp-Source: APXvYqy82MTCSBml1S7C/RmvcskOUTSKKrfHmTZsFpaXFzgDlvLpoVqfggRFxg0NTXA5MFMDUfIpNg==
X-Received: by 2002:a65:534c:: with SMTP id w12mr15105808pgr.51.1562024990982;
        Mon, 01 Jul 2019 16:49:50 -0700 (PDT)
Received: from debian9-jae.jaalam.net (64-46-6-129.dyn.novuscom.net. [64.46.6.129])
        by smtp.gmail.com with ESMTPSA id v138sm13583761pfc.15.2019.07.01.16.49.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 16:49:50 -0700 (PDT)
From:   Josh Elsasser <jelsasser@appneta.com>
To:     stable@vger.kernel.org
Cc:     Josh Elsasser <jelsasser@appneta.com>, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Edward Cree <ecree@solarflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Matteo Croce <mcroce@redhat.com>
Subject: [PATCH 4.4.y] net: check before dereferencing netdev_ops during busy poll
Date:   Mon,  1 Jul 2019 16:48:47 -0700
Message-Id: <20190701234847.73385-1-jelsasser@appneta.com>
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

Fixes: 8b80cda536ea ("net: rename include/net/ll_poll.h to include/net/busy_poll.h") # 4.4.y
Signed-off-by: Josh Elsasser <jelsasser@appneta.com>
---

This is a straightforward backport of the 4.9.y fix[1] for this crash, which doesn't
apply to the older LTS releases. Only build-tested on 4.4.y, as I don't have access
to wireless hardware and firmware that runs on older LTS kernels.

[1]: https://lore.kernel.org/stable/20190701234143.72631-1-jelsasser@appneta.com/T/#u

 include/net/busy_poll.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 1d67fb6b23a0..6d238506d49b 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -93,7 +93,7 @@ static inline bool sk_busy_loop(struct sock *sk, int nonblock)
 		goto out;
 
 	ops = napi->dev->netdev_ops;
-	if (!ops->ndo_busy_poll)
+	if (!ops || !ops->ndo_busy_poll)
 		goto out;
 
 	do {
-- 
2.20.1

