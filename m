Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E0B3EA2E9
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 12:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbhHLKTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 06:19:13 -0400
Received: from mail-ej1-f50.google.com ([209.85.218.50]:42820 "EHLO
        mail-ej1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbhHLKTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 06:19:10 -0400
Received: by mail-ej1-f50.google.com with SMTP id b10so2025170eju.9;
        Thu, 12 Aug 2021 03:18:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=jlLf7LVJcFztLZ92Y0qUp+62Jebh0x2mMopBOsuvZCM=;
        b=VfvxhBKVDrD0+pv4ziVjMQ6fYdbRuJeczW/qSt9X8SNiO4g2uqrAd4jFdCR6KltZAh
         nV6agx/TZazDj0fJX0Ch15jc4BgQGTJuoQTdAndXI9mODQoKpaupEgJQZpSvmvA9VcWZ
         w2t1GZQ11CjEG//yALKLEKtiKKC0p39hLD2CU6qnMSH8n09Ozw+XjPvvAItHIui8lQmU
         FZjo64aatDaFOX7meI8iKk93zw6dZGAXN/89tirsZBXFgBF6p139hPPaEcLlAoba8ruB
         H9+fXo0rzFZicJLCjabOe6ObZi+fIFU1yz/llyJSqGONeVyq/gp1+96jnWNFmbG+MRnx
         wixw==
X-Gm-Message-State: AOAM533k0ZYdLqlLskb+hrTzXY6EwaklYLPJZbwUFsUNFgoPySCONSmT
        +seidejfhZf8N2z3dPAMgZg=
X-Google-Smtp-Source: ABdhPJxrojONErshEKQ2stXf5CAL+MErvhdOhsoNga4qy9qKlhoYnj3TD0k5G0P/u2bfvRsreyJNMQ==
X-Received: by 2002:a17:906:6d85:: with SMTP id h5mr2905829ejt.305.1628763523696;
        Thu, 12 Aug 2021 03:18:43 -0700 (PDT)
Received: from localhost (host-87-19-134-225.retail.telecomitalia.it. [87.19.134.225])
        by smtp.gmail.com with ESMTPSA id a60sm912472edf.59.2021.08.12.03.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 03:18:43 -0700 (PDT)
Date:   Thu, 12 Aug 2021 12:18:35 +0200
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     Thierry Reding <thierry.reding@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Drew Fustini <drew@beagleboard.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jon Hunter <jonathanh@nvidia.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH net-next] stmmac: align RX buffers
Message-ID: <20210812121835.405d2e37@linux.microsoft.com>
In-Reply-To: <fe5f99c8-5655-7fbb-a64e-b5f067c3273c@gmail.com>
References: <20210614022504.24458-1-mcroce@linux.microsoft.com>
        <871r71azjw.wl-maz@kernel.org>
        <YROmOQ+4Kqukgd6z@orome.fritz.box>
        <202417ef-f8ae-895d-4d07-1f9f3d89b4a4@gmail.com>
        <87o8a49idp.wl-maz@kernel.org>
        <fe5f99c8-5655-7fbb-a64e-b5f067c3273c@gmail.com>
Organization: Microsoft
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Aug 2021 10:48:03 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> 
> 
> On 8/11/21 4:16 PM, Marc Zyngier wrote:
> > On Wed, 11 Aug 2021 13:53:59 +0100,
> > Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> >> Are you sure you do not need to adjust stmmac_set_bfsize(), 
> >> stmmac_rx_buf1_len() and stmmac_rx_buf2_len() ?
> >>
> >> Presumably DEFAULT_BUFSIZE also want to be increased by NET_SKB_PAD
> >>
> >> Patch for stmmac_rx_buf1_len() :
> >>
> >> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> >> b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c index
> >> 7b8404a21544cf29668e8a14240c3971e6bce0c3..041a74e7efca3436bfe3e17f972dd156173957a9
> >> 100644 --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c +++
> >> b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c @@ -4508,12
> >> +4508,12 @@ static unsigned int stmmac_rx_buf1_len(struct
> >> stmmac_priv *priv, /* First descriptor, not last descriptor and
> >> not split header */ if (status & rx_not_ls)
> >> -               return priv->dma_buf_sz;
> >> +               return priv->dma_buf_sz - NET_SKB_PAD -
> >> NET_IP_ALIGN; 
> >>         plen = stmmac_get_rx_frame_len(priv, p, coe);
> >>  
> >>         /* First descriptor and last descriptor and not split
> >> header */
> >> -       return min_t(unsigned int, priv->dma_buf_sz, plen);
> >> +       return min_t(unsigned int, priv->dma_buf_sz - NET_SKB_PAD
> >> - NET_IP_ALIGN, plen); }
> >>  
> >>  static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
> > 
> > Feels like a major deficiency of the original patch. Happy to test a
> > more complete patch if/when you have one.
> 
> I wont have time in the immediate future.
> 
> Matteo, if you do not work on a fix, I suggest we revert
>  a955318fe67ec0d962760b5ee58e74bffaf649b8 stmmac: align RX buffers
> 
> before a more polished version can be submitted.
> 

Better to use stmmac_rx_offset() so to have the correct length when
using XDP. Also, when XDP is enabled, the offset was
XDP_PACKET_HEADROOM (i.e. 256 bytes) even before the change, so it
could be already broken. Mark, can you try on the Jetson TX2 by
attaching an XDP program and see if it works without my change?

A possible fix, which takes in account also the XDP headroom for
stmmac_rx_buf1_len() only could be (only compile tested, I don't have
the hardware now):

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 7b8404a21544..b205f43f849a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -93,7 +93,7 @@ static int tc = TC_DEFAULT;
 module_param(tc, int, 0644);
 MODULE_PARM_DESC(tc, "DMA threshold control value");
 
-#define	DEFAULT_BUFSIZE	1536
+#define	DEFAULT_BUFSIZE	1536 + XDP_PACKET_HEADROOM + NET_IP_ALIGN
 static int buf_sz = DEFAULT_BUFSIZE;
 module_param(buf_sz, int, 0644);
 MODULE_PARM_DESC(buf_sz, "DMA buffer size");
@@ -4508,12 +4508,12 @@ static unsigned int stmmac_rx_buf1_len(struct stmmac_priv *priv,
 
 	/* First descriptor, not last descriptor and not split header */
 	if (status & rx_not_ls)
-		return priv->dma_buf_sz;
+		return priv->dma_buf_sz - stmmac_rx_offset(priv);
 
 	plen = stmmac_get_rx_frame_len(priv, p, coe);
 
 	/* First descriptor and last descriptor and not split header */
-	return min_t(unsigned int, priv->dma_buf_sz, plen);
+	return min_t(unsigned int, priv->dma_buf_sz - stmmac_rx_offset(priv), plen);
 }
 
 static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,


-- 
per aspera ad upstream
