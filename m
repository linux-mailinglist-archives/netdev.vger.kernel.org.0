Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042332990A8
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 16:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783254AbgJZPJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 11:09:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34020 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1783225AbgJZPJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 11:09:41 -0400
Received: by mail-wm1-f67.google.com with SMTP id k21so5920085wmi.1;
        Mon, 26 Oct 2020 08:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jGncrBzeSrdZmyOiKkMYe800E1r8xGJD44x4nOUxG2s=;
        b=UL0CF+D3uiKHsos40I0KWKysJ6LD5+XNTODWaR/a5zr5tSV2YsjL3n2TFtRDveuNAE
         Y/Mxfv8TTKEVt2X3/Ra8izmjVYTBO3sgxg2OTgIvUsbiUcaN9bjPNaMRNLKZUL+jdVCf
         iEZatnKIe/IAJP09OUVJMHsrJPV4DZgooyaPsFFSPQXqvKnuUuJvgITbd3Pe5pIkY1l7
         r5mDvRFy0v1hG5/p+N80/L17k9ngRFXpR8OyfASxeVe7YSAkUd+Av4vvpi6LCERblLF/
         zVfeEzMS20HQ5KOysHy2bGA6oigcemG6Wo8lTAKjDMEkU1Ixa2Lrufmi/74Rp0WHVWRU
         z8Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jGncrBzeSrdZmyOiKkMYe800E1r8xGJD44x4nOUxG2s=;
        b=mH87fKYcGHVFBkVuqgyeCrp0ZXsTK7pLRL7Pc8KO89ENlhKZs4IyShYU4qC/CSPvP1
         ofF3Xd8+eVU29Sn+EPibxJwZ+AmvzGNTKH1jxHz1eKf1P2xuVlYBSg99YO3Gcw+8mpR0
         3c6tmZFZFXqlsbA2+CSvAmlCpPwd9nZHlsCQD3Sgz09AVr3fIck1ssrR4WAOQhsSDKlP
         k1yBYVU9KWN64ET7+esZ0LlonDGouxhyFU8FI/AX+dLaImCU2J5/jcv2QGIh57ppFgyJ
         hR67bR1xDlmq/AtIsCkzZFb99oBci1u8xPYqbZOgpZ9qgafwApyNWOzjw3z7YgMWOtvm
         fTSQ==
X-Gm-Message-State: AOAM530SxTqPT3MBBKSN4p0fa/pvYy2RzS7cSq81DaKak4uT9IQwE9i4
        ZNZ25cDNfs47J24MUBGtcXBvE9ZhxBXjaTRoawM=
X-Google-Smtp-Source: ABdhPJx254j9rng1d26VwrYDPLdAk5fayxDDtSTxwWAD6kZqGCrog1IU52MJygYgMeuZLWt+BoWP2A==
X-Received: by 2002:a7b:cc89:: with SMTP id p9mr17094670wma.4.1603724978723;
        Mon, 26 Oct 2020 08:09:38 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id 24sm20043967wmf.44.2020.10.26.08.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 08:09:38 -0700 (PDT)
From:   Aleksandr Nogikh <aleksandrnogikh@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>
Subject: [PATCH v3 1/3] kernel: make kcov_common_handle consider the current context
Date:   Mon, 26 Oct 2020 15:08:49 +0000
Message-Id: <20201026150851.528148-2-aleksandrnogikh@gmail.com>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
In-Reply-To: <20201026150851.528148-1-aleksandrnogikh@gmail.com>
References: <20201026150851.528148-1-aleksandrnogikh@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Nogikh <nogikh@google.com>

kcov_common_handle is a method that is used to obtain a "default" KCOV
remote handle of the current process. The handle can later be passed
to kcov_remote_start in order to collect coverage for the processing
that is initiated by one process, but done in another. For details see
Documentation/dev-tools/kcov.rst and comments in kernel/kcov.c.

Presently, if kcov_common_handle is called in an IRQ context, it will
return a handle for the interrupted process. This may lead to
unreliable and incorrect coverage collection.

Adjust the behavior of kcov_common_handle in the following way. If it
is called in a task context, return the common handle for the
currently running task. Otherwise, return 0.

Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
---
 kernel/kcov.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/kcov.c b/kernel/kcov.c
index 6b8368be89c8..80bfe71bbe13 100644
--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -1023,6 +1023,8 @@ EXPORT_SYMBOL(kcov_remote_stop);
 /* See the comment before kcov_remote_start() for usage details. */
 u64 kcov_common_handle(void)
 {
+	if (!in_task())
+		return 0;
 	return current->kcov_handle;
 }
 EXPORT_SYMBOL(kcov_common_handle);
-- 
2.29.0.rc1.297.gfa9743e501-goog

