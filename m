Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD2C5E7499
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 09:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiIWHMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 03:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiIWHMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 03:12:02 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1F712386A
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 00:12:00 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id a3so18347531lfk.9
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 00:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Q9XLgjH24Eqjg6RRtYVvfWduJ61UcgsEusT0WAtU5E8=;
        b=hzeeuLSH4lw7vzdJ93tAxggaRfrX4k3h+rzmlZJLjzINbxknhshkYu3oCP7+31RfjJ
         VimAgUp4uDylHufMWezg76DnXXXzlz42gFLHTrt4Qt+iJ+GMwXHzWzawWeYId63gsluG
         05Nd3tenY+qHIynBjcMp4cb2ZtWLyWthQGpwXC8PQFme5swtbcuk6e4JN581Ys0DAJAO
         nFggqgYNZwqD+IHBkvjmWC/uZySF8ODpOgQu7qdpRcOSJ+9aFB1FFj2Nwzg8WZEHqcuu
         DwP7jIE1B/sTaaiDXaDcbk/ICUIyFRDIfZJDga03qBmS5qeRqn3azPty7NrnaTw0Y/+8
         Ov1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Q9XLgjH24Eqjg6RRtYVvfWduJ61UcgsEusT0WAtU5E8=;
        b=cQuu2q446hYSwC7NNznzJZiOBamhbkkn80P/iYJWI5C+RrXhHS6Zq6cPfo9p0Ksk3e
         DAiX5NzqDoVbbr9+ULYkGPR0sYuh75cOhO+DsPDveZBF8/gQHfjkVt49NI0rZ2itxfzc
         Wt+xqekpomjKTLr2dhzhpLhB1EDPEn2pd+lXZ5kD6J63mrFoKbIg82vkduSMTsD9cWK2
         C3yvXA44uXDtIqHhOSaxLuhIF4qTrkfwN0vodSDWDhCOpcTyoTSFG4uCtX8ehalodLvg
         aMuEmuztpwWldaj9Q8CCVPdfboj3vkuZArviF6rqIqbdOYiwgc7mejIJleYw6bmP+hMw
         goWA==
X-Gm-Message-State: ACrzQf3WFIusKmVSBdgRmMXnZ++GeaKENzANX3h9sMMpZfxj7Lv/9KFw
        AhtmElACQVik31Ne8iyhWnAgLRoNyocr2yl7SSCu/w==
X-Google-Smtp-Source: AMsMyM7SUot99+odrVUx4EhthB5Xit8k7KgoNVBPCDxRXJJyq79wc67K8GDgmk2mZKzsDqgQboxM4OEk5XnEGcfBeFM=
X-Received: by 2002:a05:6512:685:b0:49f:4929:4c6e with SMTP id
 t5-20020a056512068500b0049f49294c6emr2890888lfe.642.1663917119095; Fri, 23
 Sep 2022 00:11:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220922203240.108623-1-marex@denx.de>
In-Reply-To: <20220922203240.108623-1-marex@denx.de>
From:   "Fuzzey, Martin" <martin.fuzzey@flowbird.group>
Date:   Fri, 23 Sep 2022 09:11:48 +0200
Message-ID: <CANh8QzxfznS3jB8OgwRAp68wGcTDctzvBSeaXQH2bPicOSyyYA@mail.gmail.com>
Subject: Re: [PATCH] wifi: rsi: Fix handling of 802.3 EAPOL frames sent via
 control port
To:     Marek Vasut <marex@denx.de>
Cc:     linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Thu, 22 Sept 2022 at 22:33, Marek Vasut <marex@denx.de> wrote:
>
> When using wpa_supplicant v2.10, this driver is no longer able to
> associate with any AP and fails in the EAPOL 4-way handshake while
> sending the 2/4 message to the AP. The problem is not present in
> wpa_supplicant v2.9 or older. The problem stems from HostAP commit
> 144314eaa ("wpa_supplicant: Send EAPOL frames over nl80211 where available")
> which changes the way EAPOL frames are sent, from them being send
> at L2 frames to them being sent via nl80211 control port.
...
> Therefore, to fix this problem, inspect the ETH_P_802_3 frames in
> the rsi_91x driver, check the ethertype of the encapsulated frame,
> and in case it is ETH_P_PAE, transmit the frame via high-priority
> queue just like other ETH_P_PAE frames.
>

> diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
> index 0f3a80f66b61c..d76c9dc99cafa 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_core.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_core.c
> +
>                 if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
> +                       tx_eapol = true;
> +               } else if (skb->protocol == cpu_to_be16(ETH_P_802_3)) {
> +                       hdr_len = ieee80211_get_hdrlen_from_skb(skb) +
> +                                 sizeof(rfc1042_header) - ETH_HLEN + 2;
> +                       eth_hdr = (struct ethhdr *)(skb->data + hdr_len);
> +                       if (eth_hdr->h_proto == cpu_to_be16(ETH_P_PAE))
> +                               tx_eapol = true;
> +               }
> +
> diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
> index c61f83a7333b6..d43754fff287d 100644
> @@ -168,6 +171,16 @@ int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
> +       if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
> +               tx_eapol = true;
> +       } else if (skb->protocol == cpu_to_be16(ETH_P_802_3)) {
> +               hdr_len = ieee80211_get_hdrlen_from_skb(skb) +
> +                         sizeof(rfc1042_header) - ETH_HLEN + 2;
> +               eth_hdr = (struct ethhdr *)(skb->data + hdr_len);
> +               if (eth_hdr->h_proto == cpu_to_be16(ETH_P_PAE))
> +                       tx_eapol = true;
> +       }
> +

It looks like the same logic is being duplicated twice. Maybe create a
helper function for it, something like bool rsi_is_eapol(struct
sk_buff *skb) ?

Also I think it would be good to tag this for stable.

Martin
