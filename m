Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81DC579431
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 09:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235532AbiGSHcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 03:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235329AbiGSHbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 03:31:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC19432DAD
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 00:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658215907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0VUAKi0AK+5AcrSjkScRpH6h5k7kiV67FGBAWTuKheo=;
        b=ahpT4DtiuvxF+LlCKn93E7xL69MQQ56SHf0pHjiuFgkkUKZIG0liiXcN8kvnoTDkCTEl01
        f19vbhtkcTyPvaAhGameHNSeDMTvauDXySlPTYARSgBg/lhar1gZa4VVCs7wLcOUri2h0R
        qKdqfriXfsT56zllCEJI1STrd7AvV30=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-vLqbpvuTOWa1a-zp1Ue94A-1; Tue, 19 Jul 2022 03:31:39 -0400
X-MC-Unique: vLqbpvuTOWa1a-zp1Ue94A-1
Received: by mail-lf1-f71.google.com with SMTP id w8-20020a197b08000000b00489e72a3025so5096298lfc.4
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 00:31:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0VUAKi0AK+5AcrSjkScRpH6h5k7kiV67FGBAWTuKheo=;
        b=xEsfeUjQKhqOEoqoblkByKkhcPj9DBCLjGZPtfT1XMvNGVyZOOgCLQU3Gf8seWguJo
         PG5s+5RgkpGsUYXiLVeHi74dYFxo25Ljexm7N6wABMyrunbQ80W9BTBThZCiB8Oha7Z1
         HeyhnwFMbqTG9Mw1UYeisV52PQbSpeG8YNxB/zmG2gYXQwX2bRRfdMxpT0zLTGGFCD0U
         AXW4hJCK9uEdM3YUW92Q5K9ylE4k8gFpHuUXL4xpiIuThSsifXdVE94hmKMQath/lZGy
         o34/A71PJD6YVMq1A39sxkFR5DiKgQ0C/+dQoR05wPjs5+a+d/2nEZahRknKFIzgOX6c
         4I8Q==
X-Gm-Message-State: AJIora8DHsbwAlo8HkR1Zvmum8Vp1hgdummAePB0jn4eSG3McKyIVPAp
        zkFt2cu4sfBirZz06njKu87s/ptbt54Ybxa7QtIJ1TOBQODXUr95C1L0dniSq1aipr8jQleaH9a
        tvw1yw/2YkhYEvKpz9tskKu4+dihX7fFC
X-Received: by 2002:a05:6512:3f0f:b0:47f:6f89:326 with SMTP id y15-20020a0565123f0f00b0047f6f890326mr15957123lfa.124.1658215897995;
        Tue, 19 Jul 2022 00:31:37 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s3EQ0ouaIktZwhoT1p/wtLsON+Md/qCm2eGf48E4F+YhcWdB0mzakBuwAr2skYmdzLAjwfFGhhqCMeNUnmKMU=
X-Received: by 2002:a05:6512:3f0f:b0:47f:6f89:326 with SMTP id
 y15-20020a0565123f0f00b0047f6f890326mr15957110lfa.124.1658215897794; Tue, 19
 Jul 2022 00:31:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
 <d6423ae9-aa8b-7213-17c9-6027e9096143@redhat.com> <CAJs=3_CQmOYsz5N0=tX-BKyAuiFge3pfzx9aR46hMzkcP7E4MQ@mail.gmail.com>
 <CACGkMEt-37P-Qc7_1hnEN91LRuP4-uQTMwk7E0kGp64MjsqUUg@mail.gmail.com> <CAJs=3_DghKfyFMNzxLkmM9g-yPkoWF2s5Y36g920J9=9j_LvmQ@mail.gmail.com>
In-Reply-To: <CAJs=3_DghKfyFMNzxLkmM9g-yPkoWF2s5Y36g920J9=9j_LvmQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 19 Jul 2022 15:31:26 +0800
Message-ID: <CACGkMEsRqA8FvqotVYvWX_N_+1cvF3Oeiwk-nXQe41RTmT5Sxg@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing support
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 3:19 PM Alvaro Karsz <alvaro.karsz@solid-run.com> wrote:
>
> > Yes but this "issue" exists before VIRTIO_NET_F_NOTF_COAL. It might be
> > better to have an independent patch to fix.
>
>
> Maybe I'm wrong, but I don't think that you could receive
> tx_coalesce_usecs/rx_coalesce_usecs without this patch, since the
> ethtool_ops struct without this patch is:
>
> static const struct ethtool_ops virtnet_ethtool_ops = {
> .supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
>         .......
>
> And with this patch is:
> static const struct ethtool_ops virtnet_ethtool_ops = {
> .supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES |
> ETHTOOL_COALESCE_USECS,
>

You're right.

So:

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

