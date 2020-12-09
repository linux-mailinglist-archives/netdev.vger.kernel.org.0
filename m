Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C802D3943
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 04:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgLIDeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 22:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgLIDeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 22:34:06 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBFDC06179C
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 19:33:26 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id w16so305791pga.9
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 19:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mSyiexCoK0qeNd+qWX+95VwS3r48yPv3kHmU8G8mLEY=;
        b=Dn3dVUAVrAbFyiLd2qR0VO+gLn07AMdkKMC1sfuKeWlip3M1EYaEXXAYV4b9Te/ib+
         Jwy3a29LXzLOK8q1Ul1o3PlmTVWpCOZMs0FCfs0VsZOkXKWXnaJPEYvs0uvFd9S7pt2D
         Wi00iyMzpAtxKUB/TZlQtPNAm3WVGYSOJdy0dAWBsX5YAqVmBauSTPfdpZJeZRrRBLuq
         btbjHyLEgCoxy3bWdPGbmzC6wJVUetWhZs4KDuRhW7HdnUoGg+LylYhf85iZ/aGB6pH7
         1Egnm2jooXX/TuPMiRwOgUjSJyGNvegQyXEBO65LyD6sD9F4S20OvijS2ghn09ralw+a
         anxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mSyiexCoK0qeNd+qWX+95VwS3r48yPv3kHmU8G8mLEY=;
        b=YL1ox6FOsgObH/Me51c1mZg7R9+yOxeajJ8o5Ag2Bfw0eYRVAfUJRwZgU3b0Ybxo35
         h6wdvbXxu/RXwNYwL4zpuKJdyO8de3oxVUE8g2VpiMsiopaWEXb4bqqOIYSizBg4UG8l
         MZK87/S5XAfk7jlt8rivYlunq9O2ZBIeqC2Qhy895IpLtv3rQdXylkHQEkWtC3x2B/Se
         9AzZ+1D9NDjUQQQY1MQup0pK+o3yiOj0d0WuN68VOLZyI2SgsCTg+Og6lfX/JaR4ZNMd
         0CWhSy/EqrXunWbC176zKKeoFI29Rc/NfWOamKrxVIzx1b4zGpZABi2buM3qBdGq2hlx
         WgGA==
X-Gm-Message-State: AOAM532Qy9+/eUgxe45fFBQHT0UDIy+B5kXPsuhLvXn3mpB9aQ0GYYPP
        RNpEBdggBfTSQCcC2VZEzzQUt2BvNdw=
X-Google-Smtp-Source: ABdhPJy267nxShcUT7hwHRX753oYpWnfKmcmtEW/tdfkGKDG0YWtClorHHHaWTiia66TLCwr9zJHFg==
X-Received: by 2002:a05:6a00:7cc:b029:19e:30b0:6eae with SMTP id n12-20020a056a0007ccb029019e30b06eaemr506671pfu.5.1607484806046;
        Tue, 08 Dec 2020 19:33:26 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([115.164.76.159])
        by smtp.gmail.com with ESMTPSA id p8sm259103pjf.11.2020.12.08.19.33.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 08 Dec 2020 19:33:25 -0800 (PST)
Date:   Wed, 9 Dec 2020 11:33:14 +0800
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        liew.s.piaw@gmail.com
Subject: Re: [PATCH net-next] bcm63xx_enet: batch process rx path
Message-ID: <20201209033314.GA38@DESKTOP-8REGVGF.localdomain>
References: <20201204054616.26876-1-liew.s.piaw@gmail.com>
 <3caedd41-669e-94be-9214-e93eed5ae073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3caedd41-669e-94be-9214-e93eed5ae073@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 10:50:45AM +0100, Eric Dumazet wrote:
> 
> 
> On 12/4/20 6:46 AM, Sieng Piaw Liew wrote:
> > Use netif_receive_skb_list to batch process rx skb.
> > Tested on BCM6328 320 MHz using iperf3 -M 512, increasing performance
> > by 12.5%.
> > 
> 
> 
> 
> Well, the real question is why you do not simply use GRO,
> to get 100% performance gain or more for TCP flows.
> 
> 
> netif_receive_skb_list() is no longer needed,
> GRO layer already uses batching for non TCP packets.
> 
> We probably should mark is deprecated.
> 
> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> index 916824cca3fda194c42fefec7f514ced1a060043..6fdbe231b7c1b27f523889bda8a20ab7eaab65a6 100644
> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> @@ -391,7 +391,7 @@ static int bcm_enet_receive_queue(struct net_device *dev, int budget)
>                 skb->protocol = eth_type_trans(skb, dev);
>                 dev->stats.rx_packets++;
>                 dev->stats.rx_bytes += len;
> -               netif_receive_skb(skb);
> +               napi_gro_receive_skb(&priv->napi, skb);
>  
>         } while (--budget > 0);
>  

The bcm63xx router SoC does not have enough CPU power nor hardware
accelerator to process checksum validation fast enough for GRO/GSO.

I have tested napi_gro_receive() on LAN-WAN setup. The resulting
bandwidth dropped from 95Mbps wire speed down to 80Mbps. And it's
inconsistent, with spikes and drops of >5Mbps.

The ag71xx driver for ath79 router SoC reverted its use for the same
reason.
http://lists.infradead.org/pipermail/lede-commits/2017-October/004864.html
