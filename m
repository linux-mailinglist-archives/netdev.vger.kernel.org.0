Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE4F4C0DD8
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 08:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238969AbiBWH5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 02:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238946AbiBWH5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 02:57:06 -0500
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69685647C
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 23:56:31 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed40:c0fe:4675:4cef:99a5])
        by michel.telenet-ops.be with bizsmtp
        id yXwQ260054Plfy306XwQx4; Wed, 23 Feb 2022 08:56:29 +0100
Received: from geert (helo=localhost)
        by ramsan.of.borg with local-esmtp (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1nMmVb-001ceO-NS; Wed, 23 Feb 2022 08:56:23 +0100
Date:   Wed, 23 Feb 2022 08:56:23 +0100 (CET)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
X-X-Sender: geert@ramsan.of.borg
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc:     Marek Szyprowski <m.szyprowski@samsung.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-15?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        =?ISO-8859-15?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH net-next] net: Correct wrong BH disable in
 hard-interrupt.
In-Reply-To: <Yg05duINKBqvnxUc@linutronix.de>
Message-ID: <alpine.DEB.2.22.394.2202230853240.386844@ramsan.of.borg>
References: <Yg05duINKBqvnxUc@linutronix.de>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 	Hi Sebastian,

On Wed, 16 Feb 2022, Sebastian Andrzej Siewior wrote:
> I missed the obvious case where netif_ix() is invoked from hard-IRQ
> context.
>
> Disabling bottom halves is only needed in process context. This ensures
> that the code remains on the current CPU and that the soft-interrupts
> are processed at local_bh_enable() time.
> In hard- and soft-interrupt context this is already the case and the
> soft-interrupts will be processed once the context is left (at irq-exit
> time).
>
> Disable bottom halves if neither hard-interrupts nor soft-interrupts are
> disabled. Update the kernel-doc, mention that interrupts must be enabled
> if invoked from process context.
>
> Fixes: baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any context.")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Thanks, this fixes the issue on rbtx4927[1].

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

[1] https://lore.kernel.org/all/alpine.DEB.2.22.394.2202221622570.372449@ramsan.of.borg/

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
