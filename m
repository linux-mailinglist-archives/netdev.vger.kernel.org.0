Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6664B2D5750
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 10:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732130AbgLJJgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 04:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727449AbgLJJgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 04:36:10 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CA0C0613CF;
        Thu, 10 Dec 2020 01:35:30 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id s2so2476699plr.9;
        Thu, 10 Dec 2020 01:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=84iy7jpyBbCHZV2z4RbwkHJnShbb27+5JYU+4nc4KLQ=;
        b=LOIP8A8sJuuur5dPKx3m3jgDmuRDTYLoyP7Odl5rrpEnLE/n3lZ9TRir1yG5BNSQO6
         Nkd1jSp/F8nootAXAKsDdEAigHdyTQtjAEjd2JCVmFhbSquYBCqRAztZWA9QMi9d0PzJ
         LBDhWD9ytk1VhcZnyhAGLb4oiK0ynemXFXHjhjGhuRUPp5XAeHj4J1JL2eQHG4Nacser
         yw2Io+bLoo62bG1u/JD8RiQoScW5NsjhDzRq7kcjSlIzK71dlq8/1DNMnFoWWMJcrzHz
         lWGWxjNJU3Ye/0Exxr6NWww/ujs0XJ1rmUoaRq9tAmfFsRSQ2S1uYV5SuO3hvC1YytKN
         Ln+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=84iy7jpyBbCHZV2z4RbwkHJnShbb27+5JYU+4nc4KLQ=;
        b=mxXha7GrveyOZAvzjZQotodr+ipgZ194qeQE7JJ7AZY5C9acCCMo91KinHycDdOyIm
         OjeZqdlqaq2NTLRlH1svTQeQ1n++YxLjC1IcJNBR3Ufj7+OaIKcbLuH0RTCW2U50O0rv
         VZBC1ZFzXjg4ETm+eO+dXEKRc1/IP9ogi98RhKlZwJJnJfH8mwuXne/eg3iYiq+idPWk
         1SULBhXHPDTpGw4SDfBeHT1IBgnd/lyVWUBkrB4I5tAuUoytvqRmfCZJAE6Ej7yLBlzD
         xxSiWQcDSRUR9btzE4iTTPle6sszX5fInAr5pdL+n1QX/uTYMGJkuArCZoYyBS4Bqr1/
         Skqw==
X-Gm-Message-State: AOAM532RX0PQmQORJuq7nK03+sNEwr8jjOsBszroOmuWr9Fz62fRmNaX
        ktKubdUMIn8Hz1UVSr2sma0=
X-Google-Smtp-Source: ABdhPJzg1pv3b/b6IqlVmd5UI86wzSLJcOqLbdMw0d1TxEmOUqTJWn0cUiyxsSp2oYtqeDEtvA08Vg==
X-Received: by 2002:a17:902:c383:b029:db:c725:e325 with SMTP id g3-20020a170902c383b02900dbc725e325mr5853465plg.21.1607592929990;
        Thu, 10 Dec 2020 01:35:29 -0800 (PST)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id mj5sm5590001pjb.20.2020.12.10.01.35.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Dec 2020 01:35:29 -0800 (PST)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andriin@fb.com, daniel@iogearbox.net, edumazet@google.com,
        ap420073@gmail.com, bjorn.topel@intel.com,
        xiyou.wangcong@gmail.com, jiri@mellanox.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yejune.deng@gmail.com
Subject: [PATCH] net: core: fix msleep() is not accurate
Date:   Thu, 10 Dec 2020 17:35:18 +0800
Message-Id: <1607592918-14356-1-git-send-email-yejune.deng@gmail.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

See Documentation/timers/timers-howto.rst, msleep() is not
for (1ms - 20ms), There is a more advanced API is used.

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 net/core/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d33099f..6e83ee03 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6726,9 +6726,9 @@ void napi_disable(struct napi_struct *n)
 	set_bit(NAPI_STATE_DISABLE, &n->state);
 
 	while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
-		msleep(1);
+		fsleep(1000);
 	while (test_and_set_bit(NAPI_STATE_NPSVC, &n->state))
-		msleep(1);
+		fsleep(1000);
 
 	hrtimer_cancel(&n->timer);
 
-- 
1.9.1

