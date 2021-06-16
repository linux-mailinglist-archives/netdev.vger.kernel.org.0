Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C53A3AA3F6
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhFPTLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbhFPTLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 15:11:32 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786CCC061574;
        Wed, 16 Jun 2021 12:09:25 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id q20so6070905lfo.2;
        Wed, 16 Jun 2021 12:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9WqEGt61k6A3IwzqwlBQ0hdHIKhxg1G/G83ZdCJ8kmg=;
        b=kVm93IpS2H/1KIVfmEBsz6Ad1Pazer249USI8YMama4UGaP11erHtVE3EDyJwRV7qG
         g1V5zTN/ZPaZ9idMBb0KamL2nrhsyeZzyiwvjx3wVaHP6xYPbHVl1mgvb/kynNYZ932r
         aFuv4cSOBpM7Op6ogT0hdHR8aiojkuC+MOtTfufpio1e1qazb7T333mKeiM/6Jn2CJQl
         QVM8Q2ePJowEkWg1WxrBwQMYMso4pyQHLegCiiRwqbZvhjPCGgSRQurt3NWry1XyCUJQ
         UpaCuZGrFpyERib0h7fReS7ZvY92sK/GoH4a/tj5ghtwWmQSi7wo6ixXptpvPzozbAGn
         jBHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9WqEGt61k6A3IwzqwlBQ0hdHIKhxg1G/G83ZdCJ8kmg=;
        b=TGYpBHXSILa6FX96PZRqgKwwSD0mYQENaWGO923rF62OedT3UnKNaNMWQoI4Swty+r
         /u51F2O/QwlRU+0js1Gjq46t7sxD8FkqAwEXzdNYJ+Ta6rwge9URuK8NNmv/ZEac19WR
         cLyxfnBtLkYrA16Zhgnu0iIeGkPWX5MiumXlDFKYI+CzZGecs5IPjUFHS9fSPLKoL8mL
         s66T4PvjZb9+qEIILWy+rPlHSToz/+1pDVQGOYomcjm6k9dBPEhbabH9IYuQYEjDvVf1
         XYY01l1k4fHELivJummOzG2xIFDxjNRpHSm5bUU4mE93ZbcSBGKAHGIjKq2j1tAZZ0W3
         2ayg==
X-Gm-Message-State: AOAM532KBIwFB8NTgP7SdSg2fJjANvTgt++F9S8Bxw85e+5kUBhg0AP9
        KvuiJTZKs2HACPuh9zDPVaE=
X-Google-Smtp-Source: ABdhPJwK/mlgoTvdRXW48rAEDmAXhBty+Iq5Jsj943l4J8tgWUL8RfLOj+ojeNxWMIGS7i9jgJmaKw==
X-Received: by 2002:a05:6512:2105:: with SMTP id q5mr830203lfr.649.1623870563731;
        Wed, 16 Jun 2021 12:09:23 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id p16sm331753lfu.16.2021.06.16.12.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 12:09:23 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH] net: hamradio: fix memory leak in mkiss_close
Date:   Wed, 16 Jun 2021 22:09:06 +0300
Message-Id: <20210616190906.12394-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My local syzbot instance hit memory leak in
mkiss_open()[1]. The problem was in missing
free_netdev() in mkiss_close().

In mkiss_open() netdevice is allocated and then
registered, but in mkiss_close() netdevice was
only unregistered, but not freed.

Fail log:

BUG: memory leak
unreferenced object 0xffff8880281ba000 (size 4096):
  comm "syz-executor.1", pid 11443, jiffies 4295046091 (age 17.660s)
  hex dump (first 32 bytes):
    61 78 30 00 00 00 00 00 00 00 00 00 00 00 00 00  ax0.............
    00 27 fa 2a 80 88 ff ff 00 00 00 00 00 00 00 00  .'.*............
  backtrace:
    [<ffffffff81a27201>] kvmalloc_node+0x61/0xf0
    [<ffffffff8706e7e8>] alloc_netdev_mqs+0x98/0xe80
    [<ffffffff84e64192>] mkiss_open+0xb2/0x6f0 [1]
    [<ffffffff842355db>] tty_ldisc_open+0x9b/0x110
    [<ffffffff84236488>] tty_set_ldisc+0x2e8/0x670
    [<ffffffff8421f7f3>] tty_ioctl+0xda3/0x1440
    [<ffffffff81c9f273>] __x64_sys_ioctl+0x193/0x200
    [<ffffffff8911263a>] do_syscall_64+0x3a/0xb0
    [<ffffffff89200068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff8880141a9a00 (size 96):
  comm "syz-executor.1", pid 11443, jiffies 4295046091 (age 17.660s)
  hex dump (first 32 bytes):
    e8 a2 1b 28 80 88 ff ff e8 a2 1b 28 80 88 ff ff  ...(.......(....
    98 92 9c aa b0 40 02 00 00 00 00 00 00 00 00 00  .....@..........
  backtrace:
    [<ffffffff8709f68b>] __hw_addr_create_ex+0x5b/0x310
    [<ffffffff8709fb38>] __hw_addr_add_ex+0x1f8/0x2b0
    [<ffffffff870a0c7b>] dev_addr_init+0x10b/0x1f0
    [<ffffffff8706e88b>] alloc_netdev_mqs+0x13b/0xe80
    [<ffffffff84e64192>] mkiss_open+0xb2/0x6f0 [1]
    [<ffffffff842355db>] tty_ldisc_open+0x9b/0x110
    [<ffffffff84236488>] tty_set_ldisc+0x2e8/0x670
    [<ffffffff8421f7f3>] tty_ioctl+0xda3/0x1440
    [<ffffffff81c9f273>] __x64_sys_ioctl+0x193/0x200
    [<ffffffff8911263a>] do_syscall_64+0x3a/0xb0
    [<ffffffff89200068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff8880219bfc00 (size 512):
  comm "syz-executor.1", pid 11443, jiffies 4295046091 (age 17.660s)
  hex dump (first 32 bytes):
    00 a0 1b 28 80 88 ff ff 80 8f b1 8d ff ff ff ff  ...(............
    80 8f b1 8d ff ff ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81a27201>] kvmalloc_node+0x61/0xf0
    [<ffffffff8706eec7>] alloc_netdev_mqs+0x777/0xe80
    [<ffffffff84e64192>] mkiss_open+0xb2/0x6f0 [1]
    [<ffffffff842355db>] tty_ldisc_open+0x9b/0x110
    [<ffffffff84236488>] tty_set_ldisc+0x2e8/0x670
    [<ffffffff8421f7f3>] tty_ioctl+0xda3/0x1440
    [<ffffffff81c9f273>] __x64_sys_ioctl+0x193/0x200
    [<ffffffff8911263a>] do_syscall_64+0x3a/0xb0
    [<ffffffff89200068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888029b2b200 (size 256):
  comm "syz-executor.1", pid 11443, jiffies 4295046091 (age 17.660s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81a27201>] kvmalloc_node+0x61/0xf0
    [<ffffffff8706f062>] alloc_netdev_mqs+0x912/0xe80
    [<ffffffff84e64192>] mkiss_open+0xb2/0x6f0 [1]
    [<ffffffff842355db>] tty_ldisc_open+0x9b/0x110
    [<ffffffff84236488>] tty_set_ldisc+0x2e8/0x670
    [<ffffffff8421f7f3>] tty_ioctl+0xda3/0x1440
    [<ffffffff81c9f273>] __x64_sys_ioctl+0x193/0x200
    [<ffffffff8911263a>] do_syscall_64+0x3a/0xb0
    [<ffffffff89200068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 815f62bf7427 ("[PATCH] SMP rewrite of mkiss")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/hamradio/mkiss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 65154224d5b8..7685a1721597 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -799,6 +799,7 @@ static void mkiss_close(struct tty_struct *tty)
 	ax->tty = NULL;
 
 	unregister_netdev(ax->dev);
+	free_netdev(ax->dev);
 }
 
 /* Perform I/O control on an active ax25 channel. */
-- 
2.32.0

