Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1DB410E9E
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 05:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbhITDKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 23:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbhITDK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 23:10:29 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6A3C061574;
        Sun, 19 Sep 2021 20:09:03 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id k17so567843pff.8;
        Sun, 19 Sep 2021 20:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ctuhPxo2Y0iKSYUTimNWhqKlTDvqm7Ayr46jrPBJu6k=;
        b=KliJfSEbbKrQCdSX8TcUqC90YAPcOe/jEe/PPPHlGam6QbEnWakxepoqpIyCGFflT+
         cPlNgPMFjZ7a6EI7CWeiZYXOPRDigAroYqndIhdR+UOEvrXayjoAA05h8tO9DuG018jL
         UxgjZSWj4Vga0x7hMlmjeNX6QZMyyniKnFY9ibgykFzL9/WyeyfeSXiiJ7R0OsGE4Tah
         xg+Fuq9EODpFjfmtxKLrGcidlAW9vQrfb+kR/lU+NQlEnRO0SMbcL4OGGHSa56RKPcwY
         pFmcv+5Dv02aPjqf+0D4yMkVT7m8Hak14Yz/2KsOCg4z6lk41X2OzWMQu6ZGtf81RD2G
         Edhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ctuhPxo2Y0iKSYUTimNWhqKlTDvqm7Ayr46jrPBJu6k=;
        b=fOMRTLtMQEjssP9nTDyQSuj8yK0qLrhzXjEhWbbMiMv4SvLVtjaa1pF1bdmV6A6Zjk
         7mZ0ag0WO9hpFwGXoqNOFAGN//5PJkU6OrH8aFMaXNpofKqz//z3r8YkGreKttzbtfdM
         dBNAfYEsmd4Mrtb7fy+QsyZkH1r1tM1wEaxQggPYdbwnQCtoKySvxV2O62PKQ6mgZikv
         l+hn4Y0Ts2wIzmyFo8J2gorTfql56Z+5nN0qzmrYzqahCUcKmuIssM9P+/ef8YmOAJfz
         5wYA5girGvFkLbo6xNorzMralAkmilq5267ZBeNNDM5FqZwSVWQMYHrlla8Ooaj35zXO
         O2Wg==
X-Gm-Message-State: AOAM531HXChfYq2JRgRxeCCOQhOcYfJNtufe8iZyRILpob/9E+mnX+WP
        qmiJyTv9Z/0/HEurhHnCX5ern/vjri8Mumzo
X-Google-Smtp-Source: ABdhPJz5eNMjiIqtPtcMIFQqJ8fM4+8yM+jcjLGNLSj+c24mZc962gKniqMwwbCqPCcjdWekcoNbPg==
X-Received: by 2002:a63:7784:: with SMTP id s126mr7988038pgc.264.1632107343232;
        Sun, 19 Sep 2021 20:09:03 -0700 (PDT)
Received: from skynet-linux.local ([106.201.127.154])
        by smtp.googlemail.com with ESMTPSA id l11sm16295065pjg.22.2021.09.19.20.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 20:09:02 -0700 (PDT)
From:   Sireesh Kodali <sireeshkodali1@gmail.com>
To:     phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     Vladimir Lypak <vladimir.lypak@gmail.com>,
        Sireesh Kodali <sireeshkodali1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH 05/17] net: ipa: Check interrupts for availability
Date:   Mon, 20 Sep 2021 08:37:59 +0530
Message-Id: <20210920030811.57273-6-sireeshkodali1@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920030811.57273-1-sireeshkodali1@gmail.com>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Lypak <vladimir.lypak@gmail.com>

Make ipa_interrupt_add/ipa_interrupt_remove no-operation if requested
interrupt is not supported by IPA hardware.

Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
---
 drivers/net/ipa/ipa_interrupt.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index b35170a93b0f..94708a23a597 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -48,6 +48,25 @@ static bool ipa_interrupt_uc(struct ipa_interrupt *interrupt, u32 irq_id)
 	return irq_id == IPA_IRQ_UC_0 || irq_id == IPA_IRQ_UC_1;
 }
 
+static bool ipa_interrupt_check_fixup(enum ipa_irq_id *irq_id, enum ipa_version version)
+{
+	switch (*irq_id) {
+	case IPA_IRQ_EOT_COAL:
+		return version < IPA_VERSION_3_5;
+	case IPA_IRQ_DCMP:
+		return version < IPA_VERSION_4_5;
+	case IPA_IRQ_TLV_LEN_MIN_DSM:
+		return version >= IPA_VERSION_4_5;
+	default:
+		break;
+	}
+
+	if (*irq_id >= IPA_IRQ_DRBIP_PKT_EXCEED_MAX_SIZE_EN)
+		return version >= IPA_VERSION_4_9;
+
+	return true;
+}
+
 /* Process a particular interrupt type that has been received */
 static void ipa_interrupt_process(struct ipa_interrupt *interrupt, u32 irq_id)
 {
@@ -191,6 +210,9 @@ void ipa_interrupt_add(struct ipa_interrupt *interrupt,
 	struct ipa *ipa = interrupt->ipa;
 	u32 offset;
 
+	if (!ipa_interrupt_check_fixup(&ipa_irq, ipa->version))
+		return;
+
 	WARN_ON(ipa_irq >= IPA_IRQ_COUNT);
 
 	interrupt->handler[ipa_irq] = handler;
@@ -208,6 +230,9 @@ ipa_interrupt_remove(struct ipa_interrupt *interrupt, enum ipa_irq_id ipa_irq)
 	struct ipa *ipa = interrupt->ipa;
 	u32 offset;
 
+	if (!ipa_interrupt_check_fixup(&ipa_irq, ipa->version))
+		return;
+
 	WARN_ON(ipa_irq >= IPA_IRQ_COUNT);
 
 	/* Update the IPA interrupt mask to disable it */
-- 
2.33.0

