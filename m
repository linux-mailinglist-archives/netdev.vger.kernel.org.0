Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50359653103
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 13:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiLUMpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 07:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLUMo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 07:44:59 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13FA422BCB
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 04:44:58 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id 65so10587348pfx.9
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 04:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=87voKorkYhypVq01JjwM4w1ZUjFR2Vq5AJTk3xYnW4M=;
        b=aXWghNEfHt5qgm+LwHg4CjtcdfHnPyh7E1ET7j19TH452iazmQEnoC6MyN43uJpnaV
         Bs8djyw3mI6q03FYPa2JN/sYnD0weqSk5R1Fw0TN42ohXqEKynUfp0ohp3+DGlGNvjvi
         qJfD3wxUuajIBNGA4wHflHqourg3q+ix6blvA4fr6+NjeR+LtzBn7G3UvX+AW9Opm9yO
         17r5y+r6v6TtRrGi5lMH31Ru3SsrWrcIIt3heRyDjUl6GBoviQ6lfaDpVTVh9LBawZoC
         W3ObK+2uTLdm0akPUcXGITfOQE3p93s65jGmOd7yOzTQCnJfGddcURHtqAZ+cWB6LY1h
         J92g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=87voKorkYhypVq01JjwM4w1ZUjFR2Vq5AJTk3xYnW4M=;
        b=A89ekXdj1oDQbpfNILkiccb8DXSWZrW4lzw1mHWHE7YYpF9CjbLiNnT+1YU4d5Ci1j
         95Wgkt2I8lDA6XNIpqEkprMnox2xpbnX6/FSehwNd+jkiDFM3CDG+f18ju/HCFD3zvJG
         MWJVb50pJdfLdW7QXWdA1aUBptaSnVvouFcc0BnCZPftiWocYMH1LqGvkBob2cX2PdZ6
         1DSoN/2qHKAzKaTP/zlxbVNOIt7mqW57yfj3vY9kfSkHAIip7CCQxgHsGus0nCRKoHTA
         uDcbyXKC/A87lxCj4KOsiMa7HzB4lnUBtpkD6lpG9wgMuJ77LGvAY8Q4rtkQTmbQm2jl
         tacA==
X-Gm-Message-State: AFqh2koiI+GEcYa47kXkp36eDFDF0u1o/1qVUwbrZi5Smp0Rf5eyRWDI
        9FGjuAa/GHLVKsguc3Fi6ecPVGsrUbmFRfRu8Oc4/g==
X-Google-Smtp-Source: AMrXdXt40PUOzzRkKPCAkXe6IfTye8YwOcziGNnm5ARbI2MeEsAGACZCnMHtldIPXSAAJMzOpNTjulqIN4necTCBwps=
X-Received: by 2002:aa7:9418:0:b0:577:8bad:4f9e with SMTP id
 x24-20020aa79418000000b005778bad4f9emr116308pfo.77.1671626697532; Wed, 21 Dec
 2022 04:44:57 -0800 (PST)
MIME-Version: 1.0
References: <20221221120618.652074-1-alvaro.karsz@solid-run.com> <20221221073256-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221221073256-mutt-send-email-mst@kernel.org>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Wed, 21 Dec 2022 14:44:21 +0200
Message-ID: <CAJs=3_CVUydOpH=a-RJLWUQ0_1EbkwKtGD2F3Xvw=dR5QFXP5g@mail.gmail.com>
Subject: Re: [PATCH] virtio_net: send notification coalescing command only if
 value changed
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Why do we bother? Resending needs more code and helps
> reliability ...

It just seems unnecessary.
If a user changes just one parameter:
$ ethtool -C <iface> tx-usecs 30
It will trigger 2 commands, including
VIRTIO_NET_CTRL_NOTF_COAL_RX_SET, even though no rx parameter changed.

If we'll add more ethtool coalescing parameters, changing one of the
new parameter will trigger meaningless
VIRTIO_NET_CTRL_NOTF_COAL_RX_SET and VIRTIO_NET_CTRL_NOTF_COAL_TX_SET
commands.

Alvaro
