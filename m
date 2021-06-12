Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DFB3A4F63
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 16:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbhFLOyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 10:54:33 -0400
Received: from mail-lj1-f181.google.com ([209.85.208.181]:46741 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhFLOyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 10:54:33 -0400
Received: by mail-lj1-f181.google.com with SMTP id e11so13559942ljn.13;
        Sat, 12 Jun 2021 07:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IfSODAyyxeJC2Hg3fkcy946+rmEpB2MnnxIzir05N7c=;
        b=POfhabJR9QRaNfEorSQoVmu4P1PNeqtUgkGKOpgVCXENQ+U2q25ZmuiWTDlnr+jD6+
         DzTNMpm3srVfSYnF1ikKMLi97cj+iluC2Ah15XP6Iza14QA3n/pptxZcAwQrlYks3RMv
         RK96CVd3ny/heuzeVJmbIpGEdCynP/kNopSN5LrRb8taz7Ih3NNhCv545ojOS4Htfxnz
         taMdSIzfeALGF3vnFVC5WOHN42TXaNW+Zct4vcPZPtHZnHsaJvUQ5GLgyfO/wXh5302k
         3VfMj3Wry4zubvcidH19OBakNWEG2PYJuQkIkNC0BTmqskmPmjOU3rYX+xYbF7LJ+S7V
         lsjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IfSODAyyxeJC2Hg3fkcy946+rmEpB2MnnxIzir05N7c=;
        b=r/HNezKqjWIugi/McU51+uc7znBSMg6OsaCSmBcUVqFFJ95uyPgLb2BJUdC5s4sWie
         KDqm0EBX3I2gCyFYBFjvilA1IDmCYGJM7hQT6srY6NXsgsqZBVFUHNgZ2Z3P8oWf2MaA
         XuRYbTXEe3CzahAY97PXxhEBKfltnvXwZqWHn4yx8ltSB3EhgjHzBW1lGLvzmoV97a9k
         7491vyaQ118FHx3RGdIlHpHMPubThTQ5NBJqImLQVh5JOZi5x4w6HZxdt1mMi/gOrtbZ
         KOZaFY6x/AjWAF5qb8XJMdR/UcV+i1WOZp2j/fsrA5iL6cv/+ocGjw3WivxuubMaZxC6
         vGVA==
X-Gm-Message-State: AOAM531ZFNQPXbFTFT/H40BNW1qs5pzC2CXieC2EUkztJ81Z68ytYWoD
        Hn18/SCKraAqBa2JghCPoT8=
X-Google-Smtp-Source: ABdhPJwB2T70k2VgztQlcmTak9ni2Tyk6NcXl+akzNGLNjBAmiWDk5Tlqbs9I/os5nTO9F/BV8JRGA==
X-Received: by 2002:a2e:3c06:: with SMTP id j6mr6884614lja.495.1623509492712;
        Sat, 12 Jun 2021 07:51:32 -0700 (PDT)
Received: from localhost.localdomain ([185.215.60.70])
        by smtp.gmail.com with ESMTPSA id g28sm911286lfv.142.2021.06.12.07.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Jun 2021 07:51:32 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+f303e045423e617d2cad@syzkaller.appspotmail.com
Subject: [PATCH] net: caif: fix memory leak in ldisc_open
Date:   Sat, 12 Jun 2021 17:51:22 +0300
Message-Id: <20210612145122.9354-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported memory leak in tty_init_dev().
The problem was in unputted tty in ldisc_open()

static int ldisc_open(struct tty_struct *tty)
{
...
	ser->tty = tty_kref_get(tty);
...
	result = register_netdevice(dev);
	if (result) {
		rtnl_unlock();
		free_netdev(dev);
		return -ENODEV;
	}
...
}

Ser pointer is netdev private_data, so after free_netdev()
this pointer goes away with unputted tty reference. So, fix
it by adding tty_kref_put() before freeing netdev.

Reported-and-tested-by: syzbot+f303e045423e617d2cad@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/caif/caif_serial.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index d17482395a4d..4ffbfd534f18 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -350,6 +350,7 @@ static int ldisc_open(struct tty_struct *tty)
 	rtnl_lock();
 	result = register_netdevice(dev);
 	if (result) {
+		tty_kref_put(tty);
 		rtnl_unlock();
 		free_netdev(dev);
 		return -ENODEV;
-- 
2.32.0

