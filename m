Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443FD4955D0
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 22:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377767AbiATVL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 16:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbiATVL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 16:11:58 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CACC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:11:58 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id c3so6286258pls.5
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UUg0KVM1F2nGgkcMTYO5rXPQ677Wz5yHiXolPtOt8ts=;
        b=5txWYmihYWFt7nTWIt9AR8fhw9ZFpd0V41a7Kbl0rY0X01NzLNV7v0IOnFNAcpUCE4
         SrTI0pkubN9TFvu8e9jfibESaNeXqXXk/SkLYjhrpi52DAtSsfEjIFVNtbH9zKupoMJ/
         9HBeHbEAqjnIUl6h6S0uW6LMh+sL22AyFk8IZomnkUias0xhYkmhanDRQCGywJGU4JIW
         NRS9dAzjcNLDplNK6UnG6pzzoRKYwToL9j6cftt3bjPLxhFGvT1MR2jodIEPBeo8ZuGK
         P/QGNdPnt0MtCH+KOUYq+uJlrnEr6BCvVtDBdbOr1DsXuDJebCeMouJ5m3e+io6nNLVN
         Retg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UUg0KVM1F2nGgkcMTYO5rXPQ677Wz5yHiXolPtOt8ts=;
        b=28+p7mmJoh8P+ND6oxjHmDNjXgjtzrFqLQlIwsq1uOjewgIWnKOh4hUULJFxLWd1z+
         wGwLuJ91w4GWaZAZXSd+PVqJSlZFf6RDCj5NThdTVH5DT0WqoCb31beu/7eBlvsytCtK
         SqkYZGWq27h/3cNHGMeGFeCrE29q+OISpGy2tM5yQoV/uz6CpLswako7NVMJLDKP0y3T
         R7c3AfbyoCxy9azu0/VJNCnL4HwO0l3N3XcCRB8j1jgkQ/tJzhMwhesqLOkJ492nyegd
         DqdyULXW1RerbdwVuU+76gJjOz3doDiRXZyGKkk7AqpqRUsXD0lB7nzCSO8FUShBxgYp
         TYLg==
X-Gm-Message-State: AOAM530RRnGLPO3K8hmZTftlsMb/kbJW7FpU7R6PI+/172nP0NuszZ99
        pkkbBvpO3lQOusnY+MNqzYgY8kzuPp+uHA==
X-Google-Smtp-Source: ABdhPJyiYwH6HdAFh+1V+QcoAlyb0vKPL9cTMSg5ak5/PAWMKKPW/5r61SS5ZyL4z8Ny93itd3N2bw==
X-Received: by 2002:a17:90a:16c9:: with SMTP id y9mr11245965pje.220.1642713117596;
        Thu, 20 Jan 2022 13:11:57 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id rj9sm3357187pjb.49.2022.01.20.13.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 13:11:57 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v4 iproute2-next 01/11] tc: add format attribute to tc_print_rate
Date:   Thu, 20 Jan 2022 13:11:43 -0800
Message-Id: <20220120211153.189476-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120211153.189476-1-stephen@networkplumber.org>
References: <20220120211153.189476-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This catches future errors and silences warning from Clang.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/tc_util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 48065897cee7..6d5eb754831a 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -247,7 +247,8 @@ int get_percent_rate64(__u64 *rate, const char *str, const char *dev)
 	return get_rate64(rate, r_str);
 }
 
-void tc_print_rate(enum output_type t, const char *key, const char *fmt,
+void __attribute__((format(printf, 3, 0)))
+tc_print_rate(enum output_type t, const char *key, const char *fmt,
 		   unsigned long long rate)
 {
 	print_rate(use_iec, t, key, fmt, rate);
-- 
2.30.2

