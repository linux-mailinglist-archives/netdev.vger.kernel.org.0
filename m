Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6A23EE0A7
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 02:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbhHQACg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 20:02:36 -0400
Received: from mail-ej1-f42.google.com ([209.85.218.42]:34518 "EHLO
        mail-ej1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234958AbhHQACg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 20:02:36 -0400
Received: by mail-ej1-f42.google.com with SMTP id u3so35039826ejz.1;
        Mon, 16 Aug 2021 17:02:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=K5wMGZQ9prIRh71CsiF4fL+ypemm9zRUN8YLcm2qyP4=;
        b=qMvaRCWkcOXithaJVmLXpwuaKAr/0zJSb46S7r+49cY9fGNID9/n5F6XMCaLLZ3x3f
         ChcWxa8rQiDxsXPNmPV8Iq1QYG9xA7gMHvuKYciWCHYiAmjL2GaW1UKI47/ruJL+og/i
         tD4Ve7cNaZL70kOKuJER9LgQkAwfZez7N5g60xvmZofdaDGBwtmm4Y1vMXXaajniafHT
         ZuZfBRaWkZfsXHAkZwQWgDaiYLDqKB15aV88y/3+TVjjZ45HJUTplKK1L7uDwXhHgdIM
         vYutof6dvYiMQ5moX7xd7dbRKgK9k4oAgAEsb1pDUBPvwafK+ecvSatT7CJqQssKzWBh
         sCkA==
X-Gm-Message-State: AOAM5326P889nssQIYFq58gB2nYoNAJFCFPGoN67VkhyKi414kvnx8V1
        VJDCyKNfbq6IiGb6a+Ef/8o=
X-Google-Smtp-Source: ABdhPJwbIAStQIsvY6nYd2xafGE+WztwQNp3Byq8JJLV82ISdOqBErzCmeSfzD0xXPsR/3+lGtA1aQ==
X-Received: by 2002:a17:906:7095:: with SMTP id b21mr705327ejk.131.1629158522789;
        Mon, 16 Aug 2021 17:02:02 -0700 (PDT)
Received: from localhost (host-87-16-116-124.retail.telecomitalia.it. [87.16.116.124])
        by smtp.gmail.com with ESMTPSA id gh23sm83504ejb.27.2021.08.16.17.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 17:02:02 -0700 (PDT)
Date:   Tue, 17 Aug 2021 02:01:57 +0200
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Drew Fustini <drew@beagleboard.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jon Hunter <jonathanh@nvidia.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH net-next] stmmac: align RX buffers
Message-ID: <20210817020157.3b9d015e@linux.microsoft.com>
In-Reply-To: <20210816081208.522ac47c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210614022504.24458-1-mcroce@linux.microsoft.com>
        <871r71azjw.wl-maz@kernel.org>
        <YROmOQ+4Kqukgd6z@orome.fritz.box>
        <202417ef-f8ae-895d-4d07-1f9f3d89b4a4@gmail.com>
        <87o8a49idp.wl-maz@kernel.org>
        <fe5f99c8-5655-7fbb-a64e-b5f067c3273c@gmail.com>
        <20210812121835.405d2e37@linux.microsoft.com>
        <874kbuapod.wl-maz@kernel.org>
        <20210816081208.522ac47c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Organization: Microsoft
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Aug 2021 08:12:08 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Thu, 12 Aug 2021 12:05:38 +0100 Marc Zyngier wrote:
> > > A possible fix, which takes in account also the XDP headroom for
> > > stmmac_rx_buf1_len() only could be (only compile tested, I don't
> > > have the hardware now):  
> > 
> > However, this doesn't fix my issue. I still get all sort of
> > corruption. Probably stmmac_rx_buf2_len() also need adjusting (it
> > has a similar logic as its buf1 counterpart...)
> > 
> > Unless you can fix it very quickly, and given that we're towards the
> > end of the cycle, I'd be more comfortable if we reverted this patch.
> 
> Any luck investigating this one? The rc6 announcement sounds like
> there may not be that many more rc releases for 5.14.

Hi Jackub.

Unfortunately I have only a device with stmmac, and it works fine with
the patch. It seems that not all hardware suffers from this issue.

Also, using NET_IP_ALIGN on RX is a common pattern, I think that any
ethernet device is doing the same to align the IPv4 header.

Anyway, I asked for two tests on the affected device:
1. Change NET_IP_ALIGN with 8, to see if the DMA has problems in
   receiving to a non word aligned address
2. load a nop XDP program (I provided one), to see if the problem is
   already there when XDP is used

I doubt that changing also stmmac_rx_buf2_len would help,
but it's worth a try, here is a patch:

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 7b8404a21544..73d1f0ec66ff 100644
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
@@ -4529,12 +4529,12 @@ static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
 
 	/* Not last descriptor */
 	if (status & rx_not_ls)
-		return priv->dma_buf_sz;
+		return priv->dma_buf_sz - stmmac_rx_offset(priv);
 
 	plen = stmmac_get_rx_frame_len(priv, p, coe);
 
 	/* Last descriptor */
-	return plen - len;
+	return plen - len - stmmac_rx_offset(priv);
 }
 
 static int stmmac_xdp_xmit_xdpf(struct stmmac_priv *priv, int queue,


Regards,
-- 
per aspera ad upstream
