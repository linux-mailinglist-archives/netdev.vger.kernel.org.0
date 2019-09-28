Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDE72C1260
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 01:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbfI1XDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 19:03:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39524 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728742AbfI1XDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 19:03:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so6936244wrj.6
        for <netdev@vger.kernel.org>; Sat, 28 Sep 2019 16:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6dHcDT2SIw5ybFJoG+CcWNNVV51W8PP3Go+sW72Mox0=;
        b=Fzjvt4yFA/IYOG5uBD7tpUBMZ6TJ2tFk7oGGEBdqyPbN7Tah/S8ydi7u93fSVwjku/
         R52mSjtGkgwYji4Jh/8/Yva5GmrtB8YGnqVtrAR2nvfQbMWBK1uNRBACNVaCWwQGDm32
         y6e3r9Y5qjssXIjM8ma2Lm1/HJ6YHjKsUu5VkN0rgto86+d3lO3v5cvZJdv2ySCOzg0D
         pFCe1HNnT4MZdWp/OA/ykIgmcbFsmCIxFdG2sGy4CqTlFWKm50gzxeZb+zCjnns5gD8R
         yRbISlAsGue2Q8LQHB5SUTQsqJut85KsZab81GquNf2CJEBgCmT7sNTTn6jJ2UAuGc8t
         kNHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6dHcDT2SIw5ybFJoG+CcWNNVV51W8PP3Go+sW72Mox0=;
        b=teuoyAgXFTsJnHv1e4mZuhDTZSb0nnD6dZU9XaMNp6DRnoDwdhN/5PGEY4uTqr8jbs
         KKqEX8JEQKwAkeRFVECeVgl4Fp3iKxvoJ5XbeT94pcoMAHCJ0OSBz3Yju9Nt3dLVRPpg
         iSp9I+CdexPsJ/nnIrfXa8jNa6ErjrwDbGb1keOwdT1DmStFOwGtlo5pw/pn//Ot9hic
         cQEfhWwYJwLk33m06F4M+la4hLdze0kIEDpB+fwnsuO1O/3KoHEC2YAMZZk9sRXeGjU/
         LHFqTVQBKy/SZNKm/3vssB+tY5rgXYtxYXmoL2Jd+Ozu3nfm1S7+KfXSQnPi+9di5KiM
         5cxA==
X-Gm-Message-State: APjAAAVf2PmjVSKUWsmvhri98ZBqp1C/iBfoMpVKBAcP9/8KuNTA0SdZ
        fAVXic7+g24H65KP6WqBUgU=
X-Google-Smtp-Source: APXvYqzxRgyHkr2LnI2lPJiCVBbChHFOlKSAeFiVH7UnSI8zuLANAp3uNUhdUFXcrW1mst83jKtatA==
X-Received: by 2002:adf:de03:: with SMTP id b3mr7458780wrm.14.1569711779044;
        Sat, 28 Sep 2019 16:02:59 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id x6sm18361416wmf.38.2019.09.28.16.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 16:02:57 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, vinicius.gomes@intel.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net] net: sched: taprio: Fix potential integer overflow in taprio_set_picos_per_byte
Date:   Sun, 29 Sep 2019 02:01:39 +0300
Message-Id: <20190928230139.4027-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The speed divisor is used in a context expecting an s64, but it is
evaluated using 32-bit arithmetic.

To avoid that happening, instead of multiplying by 1,000,000 in the
first place, simplify the fraction and do a standard 32 bit division
instead.

Fixes: f04b514c0ce2 ("taprio: Set default link speed to 10 Mbps in taprio_set_picos_per_byte")
Reported-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/sched/sch_taprio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 2f7b34205c82..2aab46ada94f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1048,8 +1048,7 @@ static void taprio_set_picos_per_byte(struct net_device *dev,
 		speed = ecmd.base.speed;
 
 skip:
-	picos_per_byte = div64_s64(NSEC_PER_SEC * 1000LL * 8,
-				   speed * 1000 * 1000);
+	picos_per_byte = (USEC_PER_SEC * 8) / speed;
 
 	atomic64_set(&q->picos_per_byte, picos_per_byte);
 	netdev_dbg(dev, "taprio: set %s's picos_per_byte to: %lld, linkspeed: %d\n",
-- 
2.17.1

