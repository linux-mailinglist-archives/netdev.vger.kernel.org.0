Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3023A726D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 01:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhFNXXS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Jun 2021 19:23:18 -0400
Received: from mail-ej1-f41.google.com ([209.85.218.41]:46692 "EHLO
        mail-ej1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhFNXXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 19:23:17 -0400
Received: by mail-ej1-f41.google.com with SMTP id he7so19070052ejc.13;
        Mon, 14 Jun 2021 16:21:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Mjn4ljykZJX6wf5SsiiT1XVgNk3B8Z6jPKynaaT/71I=;
        b=VIRgXpsuhqtsUgP4Sc+c3rNb+XHO2ePoTdBRKWtxphcYidm2V1zAcV2fycMQIl9DG0
         0L20E/YrQTTyYeWEQNq1B6jNp3rl3XEuiyLb1Q5L9eTzbOQd/xmdUN7qFA/kxibsSUvJ
         SUDGuo9pSEGmeOp2YfV7G+goM12HqwWZ6tR6Ihz1IttsQ3EoXMW9IGakeGohwciiRJc5
         l/449PYEl5uxlCJR2aiikNXGvuCRR1422823PZsWsGyWSuRimIbELrSZFSBk+G86yhql
         EVH7/2eC4dW122VcWLge53JCfKhePwERAqUTpMPNkplRc9VaO1Ioi9eeKLd9vesq6Qy6
         dquw==
X-Gm-Message-State: AOAM5331AwnfK1JyOwBz6vjIyiIcOJCySRLOpqQXQyV9hsPv3/ITZzTI
        lFtRu8uo8ZgGrRo9D86+2II=
X-Google-Smtp-Source: ABdhPJyUmP/3hRcpGOQzPA/32Bp362+ANYKYRrh35FuBJdG3GgsfIbntCk0vm3fVrykLXRJM5SpXEg==
X-Received: by 2002:a17:906:26db:: with SMTP id u27mr17664140ejc.532.1623712873308;
        Mon, 14 Jun 2021 16:21:13 -0700 (PDT)
Received: from localhost (net-37-119-128-179.cust.vodafonedsl.it. [37.119.128.179])
        by smtp.gmail.com with ESMTPSA id y20sm4862456ejm.44.2021.06.14.16.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 16:21:12 -0700 (PDT)
Date:   Tue, 15 Jun 2021 01:21:07 +0200
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, kuba@kernel.org, palmer@dabbelt.com,
        paul.walmsley@sifive.com, drew@beagleboard.org, kernel@esmil.dk
Subject: Re: [PATCH net-next] stmmac: align RX buffers
Message-ID: <20210615012107.577ead86@linux.microsoft.com>
In-Reply-To: <20210614.125111.1519954686951337716.davem@davemloft.net>
References: <20210614022504.24458-1-mcroce@linux.microsoft.com>
        <20210614.125111.1519954686951337716.davem@davemloft.net>
Organization: Microsoft
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Jun 2021 12:51:11 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> 
> But thois means the ethernet header will be misaliugned and this will
> kill performance on some cpus as misaligned accessed are resolved
> wioth a trap handler.
> 
> Even on cpus that don't trap, the access will be slower.
> 
> Thanks.

Isn't the IP header which should be aligned to avoid expensive traps?
From include/linux/skbuff.h:

 * Since an ethernet header is 14 bytes network drivers often end up with
 * the IP header at an unaligned offset. The IP header can be aligned by
 * shifting the start of the packet by 2 bytes. Drivers should do this
 * with:
 *
 * skb_reserve(skb, NET_IP_ALIGN);

But the problem here really is not the header alignment, the problem is
that the rx buffer is copied into an skb, and the two buffers have
different alignments.
If I add this print, I get this for every packet:

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5460,6 +5460,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
+               printk("skb->data alignment: %lu\n", (uintptr_t)skb->data & 7);
+               printk("xdp.data alignment: %lu\n" , (uintptr_t)xdp.data & 7);
                skb_copy_to_linear_data(skb, xdp.data, buf1_len);

[ 1060.967768] skb->data alignment: 2
[ 1060.971174] xdp.data alignment: 0
[ 1061.967589] skb->data alignment: 2
[ 1061.970994] xdp.data alignment: 0

And many architectures do an optimized memcpy when the low order bits of the
two pointers match, to name a few:

arch/alpha/lib/memcpy.c:
	/* If both source and dest are word aligned copy words */
	if (!((unsigned int)dest_w & 3) && !((unsigned int)src_w & 3)) {

arch/xtensa/lib/memcopy.S:
	/*
	 * Destination and source are word-aligned, use word copy.
	 */
	# copy 16 bytes per iteration for word-aligned dst and word-aligned src

arch/openrisc/lib/memcpy.c:
	/* If both source and dest are word aligned copy words */
	if (!((unsigned int)dest_w & 3) && !((unsigned int)src_w & 3)) {

And so on. With my patch I (mis)align the two buffer at an offset 2
(NET_IP_ALIGN) so the data can be copied faster:

[   16.648485] skb->data alignment: 2
[   16.651894] xdp.data alignment: 2
[   16.714260] skb->data alignment: 2
[   16.717688] xdp.data alignment: 2

Does this make sense?

Regards,
-- 
per aspera ad upstream
