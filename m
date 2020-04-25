Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B3B1B837C
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 05:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgDYDk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 23:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726040AbgDYDk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 23:40:57 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB3CC09B049;
        Fri, 24 Apr 2020 20:40:57 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a31so2819636pje.1;
        Fri, 24 Apr 2020 20:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gCcVH5/Hux51e5ZSE0ZORMI0y0lsJ9xoQDGyU7wszng=;
        b=ja+XnjTe6I4Lxn5InchvNZxgfI+GlwoZdcDBB02rXCrU0cv1D/vzc8QMMiSBNaFmUv
         1bbqUN+D8HoBJ71WcZK12HEunTDITWvQi9cDH+cqJB1dxb/jccB2qD/CY/IA1uds1Kei
         2PNS5En2dviHTLVag9elDQfu8LG9naxOwbzHUYPB8vyUyb2I4pvq4hZbOfHdp87RDice
         hRdApggAvTm9FdQB3Edgww5ix3PBpFChAGQVyNEbp+TDXnJ1QceJlCjJFqJB2lio6fpu
         AjqVj4FdyI1UWfCToihTR2h3SicG6Gfw4sK9EWFLVu9V2/x+gQryOSCzqlNVSzJ8RP5W
         PGtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gCcVH5/Hux51e5ZSE0ZORMI0y0lsJ9xoQDGyU7wszng=;
        b=Uwy32jewjS5SsYIFKrUCNEX05hvfDqlMtPNxDzgOuXGbE0VDQB74TlkZQSkdSBDwKh
         5pbC72wFMjGQJy3BxwnrAFdOXwzZva4nhU4OhwhR/2wX+ZwGC+7BN0FEqLSCy65gLj0l
         WqtYJpnmb/OAoyrzxgtC8BPrU7somUru5464um37VCjFygiP9eP0h4FrtYKNJpq0zR2P
         ld+jE5jm26tO2M0rMKCMzOCPlt7JKSUL5uT6RBWccCjC/JI1qe3LZ4YyBxUwDpH0xTdz
         SBZCyfGLP1ZAOc0hSNto139MCb9e9kjRzfh+MxFP0VuiWU2/SdbMGeLI5N/RoSZjyBU7
         bGSA==
X-Gm-Message-State: AGi0PuZz86JlgS0yHtWsWqFh/1RS5Px8N7RRwwcpvofSyZQTdOdCPFD+
        t1Im6hMfox1XWwcJgKjPCpeWf6yG
X-Google-Smtp-Source: APiQypI50Hfnd9bueBR4Xb48mVHTJUV+OwcoGfTFJMfaIOXvKO9su7aToMvXUmNYMSXzc/uHy0JvUQ==
X-Received: by 2002:a17:90a:bf86:: with SMTP id d6mr9605583pjs.180.1587786056727;
        Fri, 24 Apr 2020 20:40:56 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.142.146.4])
        by smtp.gmail.com with ESMTPSA id g9sm6096353pgj.89.2020.04.24.20.40.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 20:40:56 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     eric.dumazet@gmail.com, geert@linux-m68k.org, pshelar@ovn.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH 1/2] net: openvswitch: suitable access to the dp_meters
Date:   Sat, 25 Apr 2020 11:39:47 +0800
Message-Id: <1587785988-23517-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

To fix the following sparse warning:
| net/openvswitch/meter.c:109:38: sparse: sparse: incorrect type
| in assignment (different address spaces) ...
| net/openvswitch/meter.c:720:45: sparse: sparse: incorrect type
| in argument 1 (different address spaces) ...

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/meter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 915f31123f23..612ad5586ce9 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -107,8 +107,8 @@ dp_meter_instance_realloc(struct dp_meter_table *tbl, u32 size)
 		return -ENOMEM;
 
 	for (i = 0; i < n_meters; i++)
-		new_ti->dp_meters[i] =
-			rcu_dereference_ovsl(ti->dp_meters[i]);
+		if (rcu_dereference_ovsl(ti->dp_meters[i]))
+			new_ti->dp_meters[i] = ti->dp_meters[i];
 
 	rcu_assign_pointer(tbl->ti, new_ti);
 	call_rcu(&ti->rcu, dp_meter_instance_free_rcu);
@@ -752,7 +752,7 @@ void ovs_meters_exit(struct datapath *dp)
 	int i;
 
 	for (i = 0; i < ti->n_meters; i++)
-		ovs_meter_free(ti->dp_meters[i]);
+		ovs_meter_free(rcu_dereference_raw(ti->dp_meters[i]));
 
 	dp_meter_instance_free(ti);
 }
-- 
2.23.0

