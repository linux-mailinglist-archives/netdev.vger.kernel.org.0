Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2BD4A4739
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 13:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377679AbiAaMeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 07:34:37 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:59410 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbiAaMeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 07:34:37 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643632475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9t0l66X+9+rOkZ0CpBJw8Upffgz+ZzqJoLeQyVHWW5g=;
        b=obux4keDpJq+njhJHJRgeO/GrKtUnbH3Ymq8SlsxTOHyetBB1sXOBGThc+7g84EQTNeyMg
        Q2Bxplobgr+pAdpuM2CBPHjsSqrycwCQ6b+jlfAtjM95vIfLKK7K0MbWYSxEWI5MF2YlAS
        nAHiV8sR1xr3e9fWWRdEPjjUXZbgM6D0CyAK9uJDL2I5o/KPY9heigp1yExL7w1h1DFpDe
        3+FvFmI/FVHSI0SvEP3BinCQJIWKo6i7sI8n8/Moxyf3mK6kuJbPrSYtuoGL1XhMBH4Euw
        uPCGndsGH4lITQQVMDahzrm6julaTBuSWxKyZhcLYGu5gK/fHOKZ8AtHfOb1zg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643632475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9t0l66X+9+rOkZ0CpBJw8Upffgz+ZzqJoLeQyVHWW5g=;
        b=IBw/srGY3rzYIpvWDICG/4UlhGAOGaNaVFhhnyWsQENyUqbX5K0weOOSICPjdQGbbkEFc3
        QOcFD+eFNpeh6rCw==
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
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: [PATCH v2 1/7] genirq: Provide generic_handle_irq_safe().
Date:   Mon, 31 Jan 2022 13:33:58 +0100
Message-Id: <20220131123404.175438-2-bigeasy@linutronix.de>
In-Reply-To: <20220131123404.175438-1-bigeasy@linutronix.de>
References: <20220131123404.175438-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide generic_handle_irq_safe() which can used from any context.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Oleksandr Natalenko <oleksandr@natalenko.name>
---
 include/linux/irqdesc.h |  1 +
 kernel/irq/irqdesc.c    | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

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
index 2267e6527db3c..4c58fa940a61c 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -662,6 +662,29 @@ int generic_handle_irq(unsigned int irq)
 }
 EXPORT_SYMBOL_GPL(generic_handle_irq);
=20
+/**
+ * generic_handle_irq_safe - Invoke the handler for a particular irq from =
any
+ *			     context.
+ * @irq:	The irq number to handle
+ *
+ * Returns:	0 on success, a negative value on error.
+ *
+ * This function can be called any context (IRQ or process context). It wi=
ll
+ * report an error if not invoked from IRQ context and the irq has been ma=
rked
+ * to enforce IRQ-contex only.
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

