Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047414AEC8D
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241785AbiBIIeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:34:17 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241729AbiBIIeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:34:14 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA316C05CBB9;
        Wed,  9 Feb 2022 00:34:06 -0800 (PST)
Date:   Wed, 9 Feb 2022 09:33:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644395637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cEegwyHh3AOCLz3cTCj8v6K1zDxKD4yBWV+8sL6bFrc=;
        b=u/Mob7w/VimevoQAad7DDk4SKgNX8XCDpPf69TQ2lWT3az8CLyezqtq4ny/TGXZbqanHGI
        VSEC0Jylcd1DFjKAdrhsAtpxuL73f6zCyMioxlYTkQKCBjfoaHZMZUQ251GatAZcK84MJi
        gwIsFGHot8iYqtULewHoa3+ljzeaZMp7Ljc5FJTWH26EYcb/b3f0ZJDVTYIKifgw6q8Vfb
        FQrjdsTmmtHMT3fWNnbuMuWfB4CTh6SB+55DwAaqXDYsPJ7WR6DzozP21kZShNZW2IUkkx
        XqGXK93zv4S9IZiQ9NvbTRZB7LGTnDGfEUMCEuAptS8ZgXpPYXtY+rExB6RCOQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644395637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cEegwyHh3AOCLz3cTCj8v6K1zDxKD4yBWV+8sL6bFrc=;
        b=Qh++AmLLRNISAd6f1OEam+WBPL+y4VbfbjTC/YRzjJnVL0kOm0B+pA4QgdRkow7WJ+1bMq
        pOIppG4y96osryDw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Wolfram Sang <wsa@kernel.org>, greybus-dev@lists.linaro.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: [PATCH v3 1/7] genirq: Provide generic_handle_irq_safe().
Message-ID: <YgN8cx/t1JvATvxh@linutronix.de>
References: <20220131123404.175438-1-bigeasy@linutronix.de>
 <20220131123404.175438-2-bigeasy@linutronix.de>
 <YgArWgyvy9xF3V5Q@kunai>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YgArWgyvy9xF3V5Q@kunai>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide generic_handle_irq_safe() which can used from any context.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---

v2=E2=80=A6v3: Correct kernel doc for generic_handle_irq_safe() as per Wolf=
ram
       Sang.

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
index 2267e6527db3c..346d283d2da14 100644
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
+ * This function can be called from any context (IRQ or process context). =
It
+ * will report an error if not invoked from IRQ context and the irq has be=
en
+ * marked to enforce IRQ-context only.
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

