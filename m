Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715A149E104
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240469AbiA0LdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:33:17 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35652 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240431AbiA0LdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:33:15 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643283194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i7B20wzlMtToieI5G7tCnCKu5TFMOwHYL5yYAy+C5s0=;
        b=JBkP8NyESqVS1Hlzz9WJk5NOcg243nCN04rH587WjPfrsgbMd+GF/cLL/KbCXARSBGy1te
        hnCMEdp37RY02ygC9IbYA60OWJRD5q7sv+jMgvDu1eUKskhYRm8bG1FdR30mutei0b5Wi4
        0k2g6OoFCBnXNs6C8CXFmSE+P3tuS6qhvlOyeWawldEug7w4y5qGsgUCe8Ca2Q1TguzFAY
        VtqdCdIlbp3ysKNH7OdDI0WzDdkrdnrKM/ELtMGf8lwFX15SItsdZSArQhIdQB4OHefEDF
        pAiL+soouMZwsuDsrY0hfyAN42JEj2I+goxptLQyo3+9vr4MAWvXSJMxVycebA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643283194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i7B20wzlMtToieI5G7tCnCKu5TFMOwHYL5yYAy+C5s0=;
        b=rx72YmxkZxACjESl0FCo5J02aVqivX+TAKPihjEbioTCo9OxW5XT5J4ODTO61qpGacEqwu
        WPl6X2GShe2I5oAw==
To:     greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/7] genirq: Provide generic_handle_irq_safe().
Date:   Thu, 27 Jan 2022 12:32:57 +0100
Message-Id: <20220127113303.3012207-2-bigeasy@linutronix.de>
In-Reply-To: <20220127113303.3012207-1-bigeasy@linutronix.de>
References: <20220127113303.3012207-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide generic_handle_irq_safe() which can be used can used from any
context.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/irqdesc.h |  1 +
 kernel/irq/irqdesc.c    | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 93d270ca0c567..a77584593f7d1 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -160,6 +160,7 @@ static inline void generic_handle_irq_desc(struct irq_d=
esc *desc)
=20
 int handle_irq_desc(struct irq_desc *desc);
 int generic_handle_irq(unsigned int irq);
+int generic_handle_irq_safe(unsigned int irq);
=20
 #ifdef CONFIG_IRQ_DOMAIN
 /*
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 2267e6527db3c..97223df2f460e 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -662,6 +662,27 @@ int generic_handle_irq(unsigned int irq)
 }
 EXPORT_SYMBOL_GPL(generic_handle_irq);
=20
+/**
+ * generic_handle_irq_safe - Invoke the handler for a particular irq
+ * @irq:	The irq number to handle
+ *
+ * Returns:	0 on success, or -EINVAL if conversion has failed
+ *
+ * This function must be called either from an IRQ context with irq regs
+ * initialized or with care from any context.
+ */
+int generic_handle_irq_safe(unsigned int irq)
+{
+	unsigned long flags;
+	int ret;
+
+	local_irq_save(flags);
+	ret =3D handle_irq_desc(irq_to_desc(irq));
+	local_irq_restore(flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(generic_handle_irq_safe);
+
 #ifdef CONFIG_IRQ_DOMAIN
 /**
  * generic_handle_domain_irq - Invoke the handler for a HW irq belonging
--=20
2.34.1

