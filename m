Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF5C215F7B
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgGFTit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFTit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 15:38:49 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E905C061755;
        Mon,  6 Jul 2020 12:38:49 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id s21so18791597ilk.5;
        Mon, 06 Jul 2020 12:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=hKNxlxldh+F+xaZ2usbTb+99q46WsftYguaIHRbtEX8=;
        b=LRaRgHEQ7k/576jONcNwX4sIvdnkLVVw7Kt/oPrPNm9Xpu7ZbTvOVikeMrRfpcYZBb
         60JiuM205HMfpoqbD3tJ6lyqLspL+GsU+/5v56DImLo8heXpDCloYDPAR992bb2W+iUp
         ke9HEepqXP/TilccGvVpRhoPzetoAY7eBGXy0PJl/sKc3OhRiAZmdzeUdjgxcY6qpSyp
         v4SAgwkS7ieMpscbrObMl+LyyhKQL50FBlg4ELqJ5d4Lx+F6ZUh9ImrAjiR0Y4Vpxxar
         EKYkK4JpfRA34QBWEwUKUSSVEjBtKgYu0YflSihm8yO7vLZyHB6AV2yDMj4XAqgTXS6e
         fhfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=hKNxlxldh+F+xaZ2usbTb+99q46WsftYguaIHRbtEX8=;
        b=VRXWWT+aA+UMKg8Jlke5N2Xrj9Z1Xf8IL6veQGDBmvC0JfTNno/F+5J58hFkrXAfuu
         27c2SXoB4JTnITYiUXqQ7U2IdkEZ7rnkrSBD/7HRFrwjuseIxct+cvp2LsBQmJH1yh8K
         Gkk8+adjFJvCQdrEz3zN4g6JDZcW1c7vRWjHp9yBF3Ek2NvtsQ6L1HRAoEf6y2XIj5p9
         5GkcSk4B3EiWxtWGFmFwCvrNdplYp68t0z3m4po+1KESbea7p3uvtF06cUtgHM0woc43
         40eUb06UAXJyPl+2SNysqdDU9s+rj3nGJ/amZ6zocLgFK7S7luRq8Y+bmiCEDoTVpr9D
         4deg==
X-Gm-Message-State: AOAM532C7LB47k6RTmWpVSm1+6V6SDsolKhzQLfAzcIVFWrbsZNXNTx+
        O1pVnuGWtXR8THD1f2PuThdDutCIiNR/yAlGVc0=
X-Google-Smtp-Source: ABdhPJyduHD40taa02nhXGKLF/jllpgAJ+pwTUcy374D69o1l7oRFpQ1nnRpiOiN+migM4RZ/3N8EIhB129NucH+uRE=
X-Received: by 2002:a92:40cf:: with SMTP id d76mr32490294ill.198.1594064328283;
 Mon, 06 Jul 2020 12:38:48 -0700 (PDT)
MIME-Version: 1.0
From:   Chris Healy <cphealy@gmail.com>
Date:   Mon, 6 Jul 2020 12:38:37 -0700
Message-ID: <CAFXsbZp5A7FHoXPA6Rg8XqZPD9NXmSeZZb-RsEGXnktbo04GOw@mail.gmail.com>
Subject: [PATCH] net: sfp: Unique GPIO interrupt names
To:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dynamically generate a unique GPIO interrupt name, based on the
device name and the GPIO name.  For example:

103:          0   sx1503q  12 Edge      sff2-los
104:          0   sx1503q  13 Edge      sff3-los

The sffX indicates the SFP the loss of signal GPIO is associated with.

Signed-off-by: Chris Healy <cphealy@gmail.com>
---
 drivers/net/phy/sfp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 73c2969f11a4..9b03c7229320 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -220,6 +220,7 @@ struct sfp {
     struct phy_device *mod_phy;
     const struct sff_data *type;
     u32 max_power_mW;
+    char sfp_irq_name[32];

     unsigned int (*get_state)(struct sfp *);
     void (*set_state)(struct sfp *, unsigned int);
@@ -2349,12 +2350,15 @@ static int sfp_probe(struct platform_device *pdev)
             continue;
         }

+        snprintf(sfp->sfp_irq_name, sizeof(sfp->sfp_irq_name),
+             "%s-%s", dev_name(sfp->dev), gpio_of_names[i]);
+
         err = devm_request_threaded_irq(sfp->dev, sfp->gpio_irq[i],
                         NULL, sfp_irq,
                         IRQF_ONESHOT |
                         IRQF_TRIGGER_RISING |
                         IRQF_TRIGGER_FALLING,
-                        dev_name(sfp->dev), sfp);
+                        sfp->sfp_irq_name, sfp);
         if (err) {
             sfp->gpio_irq[i] = 0;
             sfp->need_poll = true;
-- 
2.21.3
