Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427949C58C
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 20:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbfHYScV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 14:32:21 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36577 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728818AbfHYScV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 14:32:21 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so13724971wme.1
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 11:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oZOnUnIyGaNuUoHr2Bi1L/ITN5tvgAtjXraJPK/g5dY=;
        b=veXy1zOZrQL92GfO9WkpuhY19AYhxBrVYiHDCvAGXRlVffJd0VpeshjcaCTfKmoJ/r
         RsliCYQhhVK82eyy6NFJqVacU5/H0OSv/nLWrKmGyc4PCDGD+Fd6PmIlwtOScyWmtvxY
         e37qLXLHqS/0+vUMVZNShjF/p1pIUUoN2ckZ901BuoRHFLZAB7BsFYa6stfjGJn3boMY
         GDoYpJOJ/gfvVMWniAXtYrYt5AUjCKUZF/weoMz66AL9W/0IJYwNp42rTqaE3tWTSSvl
         ZqtQiZUo7ItTW9LpDcxwi1NdoqrdPyJUBQT8y4JaBhyegekBuT8t8V1KXTp5eeaDlLuv
         2q/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oZOnUnIyGaNuUoHr2Bi1L/ITN5tvgAtjXraJPK/g5dY=;
        b=p4BAfVD4JGKCZxzb5OCas9UU3jjmlVAs96fbm/xQX51mL4TGUlHhvvN3kU+r0htVzX
         Y78k11EwEfFl0hUEXlo6/Xdwpf8qpWrU1HxJ0gmpUXht7w8kcvqyKIR+sZ3OTo7qwz6E
         VIEOdgXTJrvJqOUu5KTwWiqboSLc4r/aj0QBVg3CSG/+6wd9JSPctXO9Ew7LIHcGPCnL
         wTPS0sWCUwniFbAWfFzZQfO/T/IiMXHGEoSD8IF3zDdp8MzZP9SFDvPh4s3YaMsAVSdW
         laARL6On2Id7JIrZlgR1XmFCI8dbEOCDnaIn+IiaTQxGAjtqzp0cWvmBwen8YQPDlEVg
         tsCA==
X-Gm-Message-State: APjAAAUQOjDXerhIdW7Po4R8v5gJx92QOzwcRaR07GO+x37wo+ky9AFE
        dLP5NLg5+TNzj+K9lxXv/2Y=
X-Google-Smtp-Source: APXvYqz0lF9sro1mEO136pLGWXM1ZeLEzKLoiobQlDhz+qLRlVKgl6q4o50FtnvcV7VD4qiAL/HS/Q==
X-Received: by 2002:a1c:a481:: with SMTP id n123mr16155015wme.123.1566757938904;
        Sun, 25 Aug 2019 11:32:18 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id t19sm8952842wmi.29.2019.08.25.11.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 11:32:18 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] net: dsa: tag_8021q: Future-proof the reserved fields in the custom VID
Date:   Sun, 25 Aug 2019 21:32:12 +0300
Message-Id: <20190825183212.11426-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After witnessing the discussion in https://lkml.org/lkml/2019/8/14/151
w.r.t. ioctl extensibility, it became clear that such an issue might
prevent that the 3 RSV bits inside the DSA 802.1Q tag might also suffer
the same fate and be useless for further extension.

So clearly specify that the reserved bits should currently be
transmitted as zero and ignored on receive. The DSA tagger already does
this (and has always did), and is the only known user so far (no
Wireshark dissection plugin, etc). So there should be no incompatibility
to speak of.

Fixes: 0471dd429cea ("net: dsa: tag_8021q: Create a stable binary format")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/tag_8021q.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 6ebbd799c4eb..67a1bc635a7b 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -28,6 +28,7 @@
  *
  * RSV - VID[9]:
  *	To be used for further expansion of SWITCH_ID or for other purposes.
+ *	Must be transmitted as zero and ignored on receive.
  *
  * SWITCH_ID - VID[8:6]:
  *	Index of switch within DSA tree. Must be between 0 and
@@ -35,6 +36,7 @@
  *
  * RSV - VID[5:4]:
  *	To be used for further expansion of PORT or for other purposes.
+ *	Must be transmitted as zero and ignored on receive.
  *
  * PORT - VID[3:0]:
  *	Index of switch port. Must be between 0 and DSA_MAX_PORTS - 1.
-- 
2.17.1

