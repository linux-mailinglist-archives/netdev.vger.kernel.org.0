Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B701D5E519
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 15:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfGCNQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 09:16:13 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32858 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCNQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 09:16:13 -0400
Received: by mail-pg1-f195.google.com with SMTP id m4so1255443pgk.0;
        Wed, 03 Jul 2019 06:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZZJ725SJQ3Q3TZNlUJIq5rg6J+HJ5p8b2CfV9MpemRs=;
        b=mvcy2oCaC5PCFcl3qzbutQX4KkVLxZ8XAA6vY6vw6qcSfij4GD7R8LFCMQfTSmbsyd
         Re08Jhs3O5/SZekZr5kTNzzvakdCtdNYNSjoX2u+YnXot5FmUmHWTkoCl4gNjgehltht
         1rBKoy6b4/SEFWXqsvY39bkftjEPRg1a7GnZjZ6TUSO5xpxp8sDJDxkzLmczv9nz2+x6
         NvYEld1Ha8CLaewMhzg9vKFemBn5goJ8KklM6RXAnaem/EDarV9CdI+kT/vvcc2xc2S0
         874+c+0oPZfLOsVGGjSa2fB/oPkcSTofoEU3axyy7ynYJGB5020KD7p9oKdYRnN2xsYt
         C/4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZZJ725SJQ3Q3TZNlUJIq5rg6J+HJ5p8b2CfV9MpemRs=;
        b=oKEqvgoFTvjxZgfnFlB+mGS+XeKKtR4Qqzl80gluSLGdDHYyql68wHYBJH+5tPzqnx
         oU2rtZbFAOT02BNVQFFm7pZ/1vLHw/yqtzLPmmlJ4SLngmbBS37QRUAHlnJ4UAbDQn+E
         HUPYZuuo5i39JxNcU9TcgH5PvNoTAf+fWudoWpFRcavAXl8vnDs6C8FO+qqFHq0kuiTC
         W1MEcglXdm6z6J1+8Zz8VKFITR8xxOcR9ArpqmijHMiyuD927g/BzCyVNxX2CUtldx0v
         G0t5P+XJohdqYyLr0FvQon8EWQ/zAVWVX5BZPTSALgU3hH2ofBB4q7v/JI3hRudXq+E3
         KUoA==
X-Gm-Message-State: APjAAAWTjlNFcX/w1Yaoj2LIHI3sLWxauAdnQsDDZPILwE2WwM3c7Nh8
        kvn780Izcwx0FrQDJOw5AB4=
X-Google-Smtp-Source: APXvYqysgaBY/zmVBPQeKWMenAaVOG0ThxABo6K3tWsQy1iQXvr2xrbNgfB4YIJFytOW+d3kPNcErA==
X-Received: by 2002:a17:90a:2190:: with SMTP id q16mr12404504pjc.23.1562159772929;
        Wed, 03 Jul 2019 06:16:12 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id y16sm6680122pff.89.2019.07.03.06.16.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 06:16:12 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, "David S . Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 15/30] net/wimax: Use kmemdup rather than duplicating its implementation
Date:   Wed,  3 Jul 2019 21:16:03 +0800
Message-Id: <20190703131603.25362-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemdup is introduced to duplicate a region of memory in a neat way.
Rather than kmalloc/kzalloc + memset, which the programmer needs to
write the size twice (sometimes lead to mistakes), kmemdup improves
readability, leads to smaller code and also reduce the chances of mistakes.
Suggestion to use kmemdup rather than using kmalloc/kzalloc + memset.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/wimax/i2400m/usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wimax/i2400m/usb.c b/drivers/net/wimax/i2400m/usb.c
index 2075e7b1fff6..cdce6c47c444 100644
--- a/drivers/net/wimax/i2400m/usb.c
+++ b/drivers/net/wimax/i2400m/usb.c
@@ -155,12 +155,11 @@ int __i2400mu_send_barker(struct i2400mu *i2400mu,
 		do_autopm = 0;
 	}
 	ret = -ENOMEM;
-	buffer = kmalloc(barker_size, GFP_KERNEL);
+	buffer = kmemdup(barker, barker_size, GFP_KERNEL);
 	if (buffer == NULL)
 		goto error_kzalloc;
 	epd = usb_get_epd(i2400mu->usb_iface, endpoint);
 	pipe = usb_sndbulkpipe(i2400mu->usb_dev, epd->bEndpointAddress);
-	memcpy(buffer, barker, barker_size);
 retry:
 	ret = usb_bulk_msg(i2400mu->usb_dev, pipe, buffer, barker_size,
 			   &actual_len, 200);
-- 
2.11.0

