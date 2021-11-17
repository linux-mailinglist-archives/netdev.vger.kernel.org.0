Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980EA454DB1
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 20:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240382AbhKQTO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 14:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239360AbhKQTOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 14:14:25 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38DAC061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 11:11:26 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id f18so13495862lfv.6
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 11:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=t4KdzWqRZvguZku+DSabljz+eRf14D3dKHCVcvgDtsc=;
        b=EqBV2qR1ypuwvsPQz3k6DWYCQJa5062g0xgQwzKnx3HDM+0KIT3sOpNmzK9PJTFZtQ
         XzSfC1MOornLtkL3t4MzBTP0YrHycRSUB3MISiPt+fl9WNy/Klb5x/cPOEWKRIPdyiJQ
         PB8FTlmOQOd859Ul8/6GdHA6phdhuixvBZ6PWwbnN5BETqvaeNPRYw7Pxl0UhYV3TrnS
         CgB5Nr2RZwvBJowxaoRdnsty532kHgWS2ws6DdQRG4CvCF2GTJJwTEpGS8bK7uXPWjRp
         2Ke8h+aXV0aG7BruH6HDXULAIeNnQbJWjVZTpoj7rr42RmMlCmMcDqR2MBMD5BHoWhpl
         G/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=t4KdzWqRZvguZku+DSabljz+eRf14D3dKHCVcvgDtsc=;
        b=JvvHOGirKlkJk1EBhEDHUKczKm+9/LS3w3AB6/EFBtgECra1OoXD+AIUdeUnxVu7CM
         L3owAydRmEqiCGcptYxmKiYBpEFVKJzE9Aw3pw3+DszQcnzPeV3gPPO6RoiW/1gdS0S5
         HnqRVVcVyBT2lGsQ58nWRjQXdePNiX9CeaAkL2FbXGnPKgsSpnpI7EPg6oNYJ+9vyGCf
         lCagmnZ1BKsGHDoknyuZ+Hv30kBechYi9qcdD0KlyhYa4IAsAXfPoeM90IF+8LLQD8kk
         x2ZPQuMxtznnfL9ErPPChGQEkFH1gGtHCRu9iQnAVUXBXPHrLOE8t4QVht1WjlfnJZJu
         tZ7Q==
X-Gm-Message-State: AOAM5329WGw1ehTrm/Ai7N6bmzOl8gYFr5Y3BJTFWatzueooqAymqV2V
        YyUEvqjlW/ixcBmgicLCS9iKweLNmUh9ig==
X-Google-Smtp-Source: ABdhPJyAaraQWvT5aky8nLgUko4E+Ck9UXnc3JGC+gwrw+d5U+34zhU+gH+YrXpaDPE8L+PWA0oknw==
X-Received: by 2002:ac2:4347:: with SMTP id o7mr17152680lfl.139.1637176285025;
        Wed, 17 Nov 2021 11:11:25 -0800 (PST)
Received: from [192.168.88.200] ([178.71.193.198])
        by smtp.gmail.com with ESMTPSA id x6sm62929lff.125.2021.11.17.11.11.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 11:11:24 -0800 (PST)
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Miller <davem@davemloft.net>, mmrmaximuzz@gmail.com
From:   Maxim Petrov <mmrmaximuzz@gmail.com>
Subject: [PATCH iproute2] ip/ipnexthop: fix unsigned overflow in
 parse_nh_group_type_res()
Message-ID: <91362fa6-46df-c134-63b1-cc2b0d2832ee@gmail.com>
Date:   Wed, 17 Nov 2021 22:11:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

0UL has type 'unsigned long' which is likely to be 64bit on modern machines. At
the same time, the '{idle,unbalanced}_timer' variables are declared as u32, so
these variables cannot be greater than '~0UL / 100' when 'unsigned long' is 64
bits. In such condition it is still possible to pass the check but get the
overflow later when the timers are multiplied by 100 in 'addattr32'.

Fix the possible overflow by changing '~0UL' to 'UINT32_MAX'.

Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>
---
 ip/ipnexthop.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 83a5540e..2f448449 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/nexthop.h>
+#include <stdint.h>
 #include <stdio.h>
 #include <string.h>
 #include <rt_names.h>
@@ -840,7 +841,7 @@ static void parse_nh_group_type_res(struct nlmsghdr *n, int maxlen, int *argcp,
 
 			NEXT_ARG();
 			if (get_unsigned(&idle_timer, *argv, 0) ||
-			    idle_timer >= ~0UL / 100)
+			    idle_timer >= UINT32_MAX / 100)
 				invarg("invalid idle timer value", *argv);
 
 			addattr32(n, maxlen, NHA_RES_GROUP_IDLE_TIMER,
@@ -850,7 +851,7 @@ static void parse_nh_group_type_res(struct nlmsghdr *n, int maxlen, int *argcp,
 
 			NEXT_ARG();
 			if (get_unsigned(&unbalanced_timer, *argv, 0) ||
-			    unbalanced_timer >= ~0UL / 100)
+			    unbalanced_timer >= UINT32_MAX / 100)
 				invarg("invalid unbalanced timer value", *argv);
 
 			addattr32(n, maxlen, NHA_RES_GROUP_UNBALANCED_TIMER,
-- 
2.25.1
