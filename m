Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D7F4885F4
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 21:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbiAHUrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 15:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbiAHUq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 15:46:58 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B99FC06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 12:46:58 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id e19so1963915plc.10
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 12:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xTv36HrfT2tq5353RQdFWy6gDnAyVsc62fD0UKUaPu8=;
        b=BoC0HHUn+/pOlRxW+frAvIB5lYXHWs64d+a1wyOsrIV8jKqukqGKZ9x8kd5hVKi1Ay
         RVf7GH6l9FjUaNNLsXrl+atcJ+G695V/8Kroa5iK701DBg0UZs89cmjd4y3vy3wbSL9B
         vOfPtPHfpyaImU6nxhN9kY2vxoiBohxya4jXUZMNN+gPWZ90GVsaEwGTcEczooAse4At
         2TP1u363lSMaoDrDCX8efYZUTnIpGY0dPdJEDR9ozXk2pc8XTrwnoUa4RD1Jgy1SfKZG
         WcBamR3bCUHwTyA1DjEE0WMA0X1hToVIDgixLEV2D2LvLhM6IVrWHdaFxDErUR87li05
         149g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xTv36HrfT2tq5353RQdFWy6gDnAyVsc62fD0UKUaPu8=;
        b=Pc5jBvszyeuFP73EkK85GD64wLQL7BKkMt3iZse9spWgQM5a3voYAYLVTq20Hq/kUf
         dudw2svY6B9lobgNeQNSTNg9HYyqC0De/dDekQvthXB+voVorONXQxEyHojlsKzpBdZN
         Z70WWntB2u0RE/uYBUtiXi1LSSt11HKtB4uLiE0obKCD0D4Shy7xM8MWVjf85n6an0KQ
         ECtczG6pbVxp3o6uh04a0ZqYx1PAE/L38EgwuzSZbJ3UsTCQF+roSqgab0eMtpbVzQlj
         XhSC4pSphSrwsTbVc7lj3vmIkZ1j2QgfuY6xS9QPb+7Ly76cvcnkxIud4cRd6YvuEr8E
         sEfQ==
X-Gm-Message-State: AOAM531mStVaYcvk2d9IgLppusSxZDMTeOcrk4PpUT+cwMc495De8t4N
        nSlGB6CmN67UqY/eIHwe0M2aSNgqTDGz1w==
X-Google-Smtp-Source: ABdhPJwBaOZILn1j5PtmDTvi+6paC3qIKQvYzqu9lUAOFnzDXaCT2uVnc6ef+zh1h1jEKygkEoKAmA==
X-Received: by 2002:a17:90b:17cd:: with SMTP id me13mr22169861pjb.79.1641674817423;
        Sat, 08 Jan 2022 12:46:57 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u71sm2129393pgd.68.2022.01.08.12.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 12:46:57 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>, idosch@nvidia.com
Subject: [PATCH iproute2-next 06/11] nexthop: fix clang warning about timer check
Date:   Sat,  8 Jan 2022 12:46:45 -0800
Message-Id: <20220108204650.36185-7-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220108204650.36185-1-sthemmin@microsoft.com>
References: <20220108204650.36185-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang correctly flags that ipnexthop is comparing timer
with a value that it can never have.

On 64 bit platform ~0UL / 100  = 184467440737095516
and timer is u32 so max is 4294967295.

Fixes: 91676718228b ("nexthop: Add support for resilient nexthop groups")
Cc: idosch@nvidia.com
Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
 ip/ipnexthop.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 83a5540e771c..2c65df294587 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -31,6 +31,8 @@ enum {
 	IPNH_FLUSH,
 };
 
+#define TIMER_MAX   (~(__u32)0 / 100)
+
 #define RTM_NHA(h)  ((struct rtattr *)(((char *)(h)) + \
 			NLMSG_ALIGN(sizeof(struct nhmsg))))
 
@@ -839,8 +841,8 @@ static void parse_nh_group_type_res(struct nlmsghdr *n, int maxlen, int *argcp,
 			__u32 idle_timer;
 
 			NEXT_ARG();
-			if (get_unsigned(&idle_timer, *argv, 0) ||
-			    idle_timer >= ~0UL / 100)
+			if (get_u32(&idle_timer, *argv, 0) ||
+			    idle_timer >= TIMER_MAX)
 				invarg("invalid idle timer value", *argv);
 
 			addattr32(n, maxlen, NHA_RES_GROUP_IDLE_TIMER,
@@ -849,8 +851,8 @@ static void parse_nh_group_type_res(struct nlmsghdr *n, int maxlen, int *argcp,
 			__u32 unbalanced_timer;
 
 			NEXT_ARG();
-			if (get_unsigned(&unbalanced_timer, *argv, 0) ||
-			    unbalanced_timer >= ~0UL / 100)
+			if (get_u32(&unbalanced_timer, *argv, 0) ||
+			    unbalanced_timer >= TIMER_MAX)
 				invarg("invalid unbalanced timer value", *argv);
 
 			addattr32(n, maxlen, NHA_RES_GROUP_UNBALANCED_TIMER,
-- 
2.30.2

