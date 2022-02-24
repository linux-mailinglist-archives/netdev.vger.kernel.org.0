Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E12F4C337F
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 18:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbiBXRWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 12:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiBXRWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 12:22:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F076190B5C
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 09:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645723328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jkmUZIekJ1fYPf2/HgjluquRw8TsLiMzA6hAe+2h9H4=;
        b=ZvrwI6dAt+d5bidy5WnexHbZzRyB75TFhM4SDThPJnBjdPB5/FhUUpHwn43LegIHy3NI+D
        kKOiY1G7zsJLqVJXaWRdN++7M39Gujnqguwwb28amuru+gg4KpDcDGXOZwYaSZSjtEblvt
        pyVD+RqHoSMyQ7o2us3E2u0U56tZnl8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-TvJ-vqqBNLCSjYnn9D9V3A-1; Thu, 24 Feb 2022 12:22:07 -0500
X-MC-Unique: TvJ-vqqBNLCSjYnn9D9V3A-1
Received: by mail-wm1-f69.google.com with SMTP id n31-20020a05600c3b9f00b003812242973aso115384wms.4
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 09:22:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=jkmUZIekJ1fYPf2/HgjluquRw8TsLiMzA6hAe+2h9H4=;
        b=jtnliosMU4F51vEhjqPMEj8AnqJuKXSTEyZFttgRo2kixLzFEMRd8/zhX98e/jSlV7
         y5+f99WT/WSVz2CCZ03Uh+BJT2dg0a6DbxCp3RRKj2+DjzUeZXyhT7wpdAlurQ1Flq0R
         /vPTkVijbEfmczO/6Jt+Vt7hRH8e0hyZ4AazTfAV1OILzVq+j2+RUwrk/Yf55IcBmrFj
         n1gF9BofikdIEypGf9hc2s8Hihzl4s7C786intwlJT4rfaBxFVM2Z8Xxe5Uitk6C3qQm
         IOfW7rT7u9w1BE9IgLB/QIcguwUspsaydn9J2wOuxfX5N5tArrnDecYcrTISb6yahikM
         G81g==
X-Gm-Message-State: AOAM533rcnJKN9PtYMZnEQk35vPiv06i+XoxzPWRF1ypG68goukZFIDH
        CdjTx0URSj4DSCzGUCL0gp8957Ev+WruhrsVYcwhnBghZK6eflKrw8kdclL0dzm81kV1LvBQN7I
        R1gwVz9kgjqOvuUsR
X-Received: by 2002:a5d:47ae:0:b0:1e8:e479:fa8e with SMTP id 14-20020a5d47ae000000b001e8e479fa8emr3025552wrb.169.1645723325691;
        Thu, 24 Feb 2022 09:22:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw4V+MHeIax3bYGiBqitMUg6wi4T/4JtYj3TQcKtk6C9Qbc9SPId3U/Fo4UJYI4rbxrDp7jHw==
X-Received: by 2002:a5d:47ae:0:b0:1e8:e479:fa8e with SMTP id 14-20020a5d47ae000000b001e8e479fa8emr3025536wrb.169.1645723325472;
        Thu, 24 Feb 2022 09:22:05 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-108-216.dyn.eolo.it. [146.241.108.216])
        by smtp.gmail.com with ESMTPSA id y12sm4174551wrt.72.2022.02.24.09.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 09:22:05 -0800 (PST)
Message-ID: <1de9e991f6c109d5986c857bc176e03d5e167944.camel@redhat.com>
Subject: Re: [PATCH] tun: support NAPI to accelerate packet processing
From:   Paolo Abeni <pabeni@redhat.com>
To:     Harold Huang <baymaxhuang@gmail.com>, netdev@vger.kernel.org
Cc:     jasowang@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Thu, 24 Feb 2022 18:22:04 +0100
In-Reply-To: <20220224103852.311369-1-baymaxhuang@gmail.com>
References: <20220224103852.311369-1-baymaxhuang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, 2022-02-24 at 18:38 +0800, Harold Huang wrote:
> In tun, NAPI is supported and we can also use NAPI in the path of
> batched XDP buffs to accelerate packet processing. What is more, after
> we use NPAI, GRO is also supported. The iperf shows that the throughput

Very minor nit: typo above NPAI -> NAPI

> could be improved from 4.5Gbsp to 9.2Gbps per stream.
> 
> Reported-at: https://lore.kernel.org/netdev/CAHJXk3Y9_Fh04sakMMbcAkef7kOTEc-kf84Ne3DtWD7EAp13cg@mail.gmail.com/T/#t
> Signed-off-by: Harold Huang <baymaxhuang@gmail.com>

Additionally, please specify explicitly the target tree into the patch
subject.

Cheers,

Paolo

