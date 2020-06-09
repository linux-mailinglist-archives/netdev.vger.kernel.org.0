Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C941F47D1
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 22:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389423AbgFIUMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 16:12:00 -0400
Received: from mail-ej1-f65.google.com ([209.85.218.65]:46320 "EHLO
        mail-ej1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731802AbgFIUL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 16:11:59 -0400
Received: by mail-ej1-f65.google.com with SMTP id p20so3824429ejd.13;
        Tue, 09 Jun 2020 13:11:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NZeC2/l48nupjKZvZ1jifZHSazauyXFgX8W5icrG39c=;
        b=WFD+kzLC7vZYvEvcVOTSduh0I/AVXp+ElxAv6c+YKFBPcXwIpSwPCHYFxTYEstRC6q
         vzK1yJJHPtzIIyTqMG9B6r4tpjWFfxNtFb5N+6SQUV5hbKNEPYsV1ijAnKQzGdZHgUZN
         MMTIiQJwrkV+lD39KkZ5fatEMeaKEEhgRI1EZNo7t6J4XDPxfHrZViqqJXWHGrRXBb2T
         unc7Q7/dCHbFGYWo+fEvJ6rnorw9ug2qNYanWtE2SvU22bzG3MCsGxgws+JOGB6bSBHV
         Ia+BJqnXfbL3sDirZtM+0LIR3DF+sbSPoMMgg4xspqa+iU9hiIfmD12f14uKlyHogQ0Z
         vd9A==
X-Gm-Message-State: AOAM532O9KD0L7QwQP+drL56G7O66whCILkXiNDByjxNWZ/3BpZeDcT1
        2w7DNjkE1WbSm1FyYRH4466wPwe2K+A=
X-Google-Smtp-Source: ABdhPJy0NfuVDiXVRnjQpUi9hQ6AmIz+GXIvUdT1uGBxPl7lZWBPr8IReYBdQOGiZTvXO0ixLFteCg==
X-Received: by 2002:a17:906:aec5:: with SMTP id me5mr134331ejb.54.1591733517055;
        Tue, 09 Jun 2020 13:11:57 -0700 (PDT)
Received: from zenbook-val.localdomain (bbcs-65-74.pub.wingo.ch. [144.2.65.74])
        by smtp.gmail.com with ESMTPSA id t5sm15503995eds.81.2020.06.09.13.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 13:11:56 -0700 (PDT)
From:   Valentin Longchamp <valentin@longchamp.me>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, Valentin Longchamp <valentin@longchamp.me>,
        stable@vger.kernel.org
Subject: [PATCH v3] net: sched: export __netdev_watchdog_up()
Date:   Tue,  9 Jun 2020 22:11:54 +0200
Message-Id: <20200609201154.22022-1-valentin@longchamp.me>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the quiesce/activate rework, __netdev_watchdog_up() is directly
called in the ucc_geth driver.

Unfortunately, this function is not available for modules and thus
ucc_geth cannot be built as a module anymore. Fix it by exporting
__netdev_watchdog_up().

Since the commit introducing the regression was backported to stable
branches, this one should ideally be as well.

Fixes: 79dde73cf9bc ("net/ethernet/freescale: rework quiesce/activate for ucc_geth")
Cc: <stable@vger.kernel.org>
Signed-off-by: Valentin Longchamp <valentin@longchamp.me>
---
 net/sched/sch_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index b19a0021a0bd..265a61d011df 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -464,6 +464,7 @@ void __netdev_watchdog_up(struct net_device *dev)
 			dev_hold(dev);
 	}
 }
+EXPORT_SYMBOL_GPL(__netdev_watchdog_up);
 
 static void dev_watchdog_up(struct net_device *dev)
 {
-- 
2.25.1

