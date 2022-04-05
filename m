Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046BD4F34AB
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 15:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343918AbiDEJPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 05:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244683AbiDEIwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 04:52:33 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974E4D8F54
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 01:41:59 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B1234C0002;
        Tue,  5 Apr 2022 08:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649148117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Qq5PmJnvCj5Nk2WhiQUZfV7I/2ZPL4FelXVtrdlaQms=;
        b=UNOIM+vjtavR5XzIfMlS9AOeDr0N81rRnChFMnqCp03hpqA4XWteYlCocpmtKWMCQSAW6w
        rZ5//fUyzT1WEQTV6z01LeNkku7uBu4lNsxj3iXfMiCOMvIu9oUjY1vSu/6nTNhaBnaLpB
        5Kwu7NbFfGYO2JNcoIYl8A144YEIYDy+TcIw9LZXLd1PJZh03KxG7MKmnRGRIhSB+SIHtu
        BwdDy71wy7dg1fgFJeXe403KqxRxi278s8ROxsV7SpMKjw0l4MyeEagFsyRojjgbjYtHea
        L8cwPnyksIM9WjaAPIDAmf5xctaCp9mrB1lDY2HfYt1/uO6XJ5NTSegfbVH0kw==
Date:   Tue, 5 Apr 2022 10:40:28 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        Milan STEVANOVIC <milan.stevanovic@se.com>
Subject: RZ/N1  gmac support
Message-ID: <20220405104028.5b3b861d@fixe.home>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello STMMAC maintainers,

I'm currently working on adding RZ/N1 Ethernet support [1] in the
kernel. As a part of this, the GMAC is a dwmac IP and is supported by
the stmmac driver. Unfortunately, some revisions of this SoC suffer from
a hardware bug [2] that requires that only one CPU core writes registers
at a time for all the following peripherals:
- GMAC
- Switch
- R-In Engine (Accessory registers)

In practice, this translates to using a function that does a writel() in
a mutual exlusion section using a spinlock (When only the 2 Cortex-A7
CPUs are running Linux) or a hardware semaphore (if the M3 core also
accesses these registers).

Since the stmmac driver uses writel() functions at different places,
this would requires to modify all theses calls. I can see multiple
solutions (which might not be ideal though):

1) Adding a write_reg() callback in plat_stmmacenet_data and call it
instead of writel. This would also require to pass the stmmac_priv
struct to all callbacks that uses writel() in order to call the
write_reg callback.

Pros:
 - Per platform
Cons:
 - Large modifications needed
 - Could slow down driver by adding writel indirection

2) Use a global gmac_writel function that would either use writel() or a
specific global custom_writel() override function depending on a static
key usage. For instance:

static inline void stmmac_writel(u32 value, volatile void __iomem *addr)
{
	if (static_key_true(use_custom_writel))
		stmmac_custom_writel(value, addr);
	else
		writel(value, addr);
}

Pros:
 - Really small overhead
 - Few modifications in the driver
Cons:
 - Global

I think the first solution is cleaner but requires a lot of
changes to modify all the writel calls for a single . Moreover it would
add an indirection to call writel which might degrade performances. One
solution to mitigate this would be to use a static key and thus the
second solution could also be considered (since the static key would be
global).

Any advice or other solutions is welcomed !

Thanks for your help,

[1]
https://www.renesas.com/us/en/document/mah/rzn1d-group-rzn1s-group-rzn1l-gr=
oup-users-manual-r-engine-and-ethernet-peripherals
[2]
https://www.renesas.com/us/en/document/tcu/advanced-5port-switch-a5psw-func=
tion-issues-and-usage-notice

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
