Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092C31F004C
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 21:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgFETLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 15:11:48 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37773 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgFETLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 15:11:48 -0400
Received: by mail-lj1-f194.google.com with SMTP id e4so13104353ljn.4;
        Fri, 05 Jun 2020 12:11:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=itfl8twhNK2a01fSikoJ1WeP6OOUKm4LjLdSnPiLkNY=;
        b=iPGdLlR9Z6FpdFTWicTyOsa9xj0CEmNhN0o77X4rFfSmNcUWW4kQ8lhRRqYyhbAOTn
         ll1sPPHcYhaiXYgUOYFMiJQyH4k65nwiSEPVkXlfMajbB0N6y1zYFv/Evd93HLOsJMON
         6ZKzJ5bCnyQq2YuUDdLZstL/y4P21JUYPRPfWHh8RvPXhhtjysxZaI6nbbndQqGBt9hM
         GYY0EaMrqddRXu7ofuCOhANYlNqJcutYs27eF951sjNupCBbWEGojpq00BZgA9povy8B
         CMxUBKcoXDfMDwzd5mtIA5SfToQCV8NZnd69bvRZkhtMo9QsBCiwAePSyVn3n5mlCinT
         AY5w==
X-Gm-Message-State: AOAM533b2fMI2a1fhSCpLPfBv6CH6jttO81vmiRW/X/6nBxduGgAzgo1
        uRBxQyKPj9xsIyiBH4g/XCQ=
X-Google-Smtp-Source: ABdhPJyt999fMsfqRpqBx+qUDcuiZY/tELpIV88AIrheu8EY5jh0/Pq0DSrZkPA2rm6c+jthAplkNA==
X-Received: by 2002:a2e:b5bc:: with SMTP id f28mr4926246ljn.451.1591384305399;
        Fri, 05 Jun 2020 12:11:45 -0700 (PDT)
Received: from localhost.localdomain (broadband-37-110-38-130.ip.moscow.rt.ru. [37.110.38.130])
        by smtp.googlemail.com with ESMTPSA id 1sm1288171lft.95.2020.06.05.12.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 12:11:44 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Denis Efremov <efremov@linux.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cxgb4: Use kfree() instead kvfree() where appropriate
Date:   Fri,  5 Jun 2020 22:11:44 +0300
Message-Id: <20200605191144.78083-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kfree(buf) in blocked_fl_read() because the memory is allocated with
kzalloc(). Use kfree(t) in blocked_fl_write() because the memory is
allocated with kcalloc().

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 41315712deb8..828499256004 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -3357,7 +3357,7 @@ static ssize_t blocked_fl_read(struct file *filp, char __user *ubuf,
 		       adap->sge.egr_sz, adap->sge.blocked_fl);
 	len += sprintf(buf + len, "\n");
 	size = simple_read_from_buffer(ubuf, count, ppos, buf, len);
-	kvfree(buf);
+	kfree(buf);
 	return size;
 }
 
@@ -3374,12 +3374,12 @@ static ssize_t blocked_fl_write(struct file *filp, const char __user *ubuf,
 
 	err = bitmap_parse_user(ubuf, count, t, adap->sge.egr_sz);
 	if (err) {
-		kvfree(t);
+		kfree(t);
 		return err;
 	}
 
 	bitmap_copy(adap->sge.blocked_fl, t, adap->sge.egr_sz);
-	kvfree(t);
+	kfree(t);
 	return count;
 }
 
-- 
2.26.2

