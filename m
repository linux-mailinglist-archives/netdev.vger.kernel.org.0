Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2745C35EF3C
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 10:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349893AbhDNILL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 04:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349933AbhDNIJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 04:09:10 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF68C061756
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 01:08:49 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id x2so19765720oiv.2
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 01:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3835wDb43BRmqXpMb7dlPJQglpbtbXdC422uijyrwSQ=;
        b=BhXTymvcDSiR4rbue+Tt7wFfk4hEXeCPI0R/OlxqAq5z3axIj/qImVpGkjoUVv8m3z
         Ku7pytGyyTmUGKwVxAh5enryu4OgDGJjqmXGZIjXAz1pSsEjaSC50vKTyLuURuyq90iT
         ZNr4K14ZmZlzaM7KKO2tGNL7CE+KFgLAdCXJYk/jSh65J2LFMPscO0EkDtUD7yIk3AZq
         uyPMh3RP/xsroQlwg+ofFJQ4tbxlMkoPDblz/81A2qXqAuqatlE79e7bgT4tF8WwDD5s
         fk8Or48+FPKCQFnNlmtf55Br+JfStUp0zNdZQe23fpyp1aZFShzRVJ7OFsfkcWbsXABF
         Lb2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3835wDb43BRmqXpMb7dlPJQglpbtbXdC422uijyrwSQ=;
        b=foofZZaOwsfLXCEGj5R2z6NPU+pm+twYWjwkoqj1bnB+kpwQVCl6zJfD1ZEFsFQbJm
         CvsPW+kb3R28KCI6dtZ5fw68VXeOrbr4fsN8qUeZOqDoBFsl7QJ1H9Pi6QXLOYH/kznA
         10XHVe5Bzhyv1oZlHrxvX1b7rRrnKaKN9/BCs6sJPgoSUtE2thg66BhZPR3r8OMRyRCk
         hLlqSLzhHDVGtQLJWxVQb11pk72EvKf49AML4Ic4k7XveiphVLRoTNaGMjcQ0c8+PKvM
         wMuocFftpu6aUrYgncCfGhZT3G346/K2nb8va9fIAqG6ZV/YVFMsQdvx6aYWmwp82cII
         R9XA==
X-Gm-Message-State: AOAM531jVDJp+KLwXz5OoTFjkA/p82wxiLNlJ8ksU3GhJ6TYVcEP1HKw
        /KTd4NI3djuZVjFdaJfPzz5V+7KENWiZxg==
X-Google-Smtp-Source: ABdhPJwmU693WkgRxK4ENMPj/eJplgxgsTHcyNJRAlCBt05nqqfirfDCdAicsggTMuL9ImJfMB9JsA==
X-Received: by 2002:aca:f515:: with SMTP id t21mr1517923oih.72.1618387728569;
        Wed, 14 Apr 2021 01:08:48 -0700 (PDT)
Received: from pear.attlocal.net ([2600:1700:271:1a80:7124:9f6b:8552:7fdf])
        by smtp.gmail.com with ESMTPSA id y6sm2190691otk.42.2021.04.14.01.08.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Apr 2021 01:08:48 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net v2] net: core: make napi_disable more robust
Date:   Wed, 14 Apr 2021 03:08:45 -0500
Message-Id: <20210414080845.11426-1-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are chances that napi_disable can be called twice by NIC driver.
This could generate deadlock. For example,
the first napi_disable will spin until NAPI_STATE_SCHED is cleared
by napi_complete_done, then set it again.
When napi_disable is called the second time, it will loop infinitely
because no dev->poll will be running to clear NAPI_STATE_SCHED.

Though it is driver writer's responsibility to make sure it being
called only once, making napi_disable more robust does not hurt, not
to say it can prevent a buggy driver from crashing a system.
So, we check the napi state bit to make sure that if napi is already
disabled, we exit the call early enough to avoid spinning infinitely.

Fixes: bea3348eef27 ("[NET]: Make NAPI polling independent of struct net_device objects.")
Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
v2: justify that this patch makes napi_disable more robust.

 net/core/dev.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1f79b9aa9a3f..fa0aa212b7bb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6830,6 +6830,24 @@ EXPORT_SYMBOL(netif_napi_add);
 void napi_disable(struct napi_struct *n)
 {
 	might_sleep();
+
+	/* make sure napi_disable() runs only once,
+	 * When napi is disabled, the state bits are like:
+	 * NAPI_STATE_SCHED (set by previous napi_disable)
+	 * NAPI_STATE_NPSVC (set by previous napi_disable)
+	 * NAPI_STATE_DISABLE (cleared by previous napi_disable)
+	 * NAPI_STATE_PREFER_BUSY_POLL (cleared by previous napi_complete_done)
+	 * NAPI_STATE_MISSED (cleared by previous napi_complete_done)
+	 */
+
+	if (napi_disable_pending(n))
+		return;
+	if (test_bit(NAPI_STATE_SCHED, &n->state) &&
+	    test_bit(NAPI_STATE_NPSVC, &n->state) &&
+	    !test_bit(NAPI_STATE_MISSED, &n->state) &&
+	    !test_bit(NAPI_STATE_PREFER_BUSY_POLL, &n->state))
+		return;
+
 	set_bit(NAPI_STATE_DISABLE, &n->state);
 
 	while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
-- 
2.23.0

