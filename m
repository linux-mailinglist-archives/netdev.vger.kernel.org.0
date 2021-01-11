Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA142F1FB8
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390973AbhAKTqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390829AbhAKTqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 14:46:49 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3319C061786;
        Mon, 11 Jan 2021 11:46:08 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id o10so1200274lfl.13;
        Mon, 11 Jan 2021 11:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=JvMy3L9QNmsGKgVZKfbdC340c0gFWd8CrD1qVz5RsO4=;
        b=sPp3XDYEH6oYLgxmKSkpyAlA6ZweADfIMjvLfHv2wPzGaNNrhidJG0CWzoiedf/DOj
         aalvWRNwoE2RfbRjQr12LP947WQA5tR97OmRvinKdfsHp1dfbRSShYmiKemnr8omI28y
         U5nvi1coo6NgM8DVmD6/uOrDWjw6fCeNT4Ac0KpiknPkHmoujEdy4t8KilMxpN8Eirhn
         eDHSBAQCF0rQj1cNYXt5Qo4EjhTb1BJsj6yplzN4sNVsbQs8isk4JTFTjkMpRA8XE4kq
         MTYYMV9crfJumgupqYQLGcvPz+KYPxK4LgGnGUuKXNKQpGxXtwBk65amTkIYo5oIKpoC
         XALg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=JvMy3L9QNmsGKgVZKfbdC340c0gFWd8CrD1qVz5RsO4=;
        b=RCeIVsokHnJcJNbUxy7V8U+tudRJWzaPesBlivJHDP6VH7VaefWNwALEJhA0tL7G4K
         UfFj14SBp7uQoK/i742dhsxIZtuRGGs+z5Svd/1x3Gf5vxMmBn668yhj3UhrcpbQlj6R
         ye8OiFV6oWpgqRJFLAVLW2SfwxKxi2dRidenZxRZzalz5X3fvr9BL7uw61az3Nu7rEqJ
         E96ed0tAPaUHW+uZbMOmsOLOgmyzadTa85K2Y9ifoee2O7bMIFhO9wtEkxrWRbsplIXL
         lmqGrsetGG4kzR2OUVtsgW4+IdmfnUuLr/30BL6AU4W3LIg7Q3JyKz5uC6CbyDvU9WYL
         8kJQ==
X-Gm-Message-State: AOAM531ioBHIJgwtMFrG48v/nnPDNwG19SvBKgO1C/MFkTxbSG1C3kX5
        CnANu7k/gp/sgaJHU6LkVNWp1b6QZQH43BkB36MKec0kHUnKi0cR
X-Google-Smtp-Source: ABdhPJwpjPS1hMIFbau6K0ME+HxOaKt3xEuWr8Y8uOpmS7WWDQA67Y2V3JWRz6O4bbF6hIHn2GFGdsJketDy0VOP0SA=
X-Received: by 2002:ac2:4463:: with SMTP id y3mr496815lfl.94.1610394367183;
 Mon, 11 Jan 2021 11:46:07 -0800 (PST)
MIME-Version: 1.0
From:   Paul Thomas <pthomas8589@gmail.com>
Date:   Mon, 11 Jan 2021 14:45:54 -0500
Message-ID: <CAD56B7fYivPF33BhXWDPskYqNE5jRxd-sA=6+ushNXhyiCrwiQ@mail.gmail.com>
Subject: net: macb: can macb use __napi_schedule_irqoff() instead of __napi_schedule()
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, recently I was doing a lot of tracing/profiling to understand
an issue we were having. Anyway, during this I ran across
__napi_schedule_irqoff() where the comment in dev.c says "Variant of
__napi_schedule() assuming hard irqs are masked".

It looks like the queue_writel(queue, IDR, bp->rx_intr_mask); call
just before the __napi_schedule() call in macb_main.c is doing this
hard irq masking? So could it change to be like this?

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1616,7 +1623,7 @@ static irqreturn_t macb_interrupt(int irq, void *dev_id)

                        if (napi_schedule_prep(&queue->napi)) {
                                netdev_vdbg(bp->dev, "scheduling RX softirq\n");
-                               __napi_schedule(&queue->napi);
+                               __napi_schedule_irqoff(&queue->napi);
                        }
                }

-Paul
