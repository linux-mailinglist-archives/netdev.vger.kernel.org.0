Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9846F55DBC0
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238212AbiF0TZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 15:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238100AbiF0TZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 15:25:02 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359B36465
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:25:02 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id n15so16265014qvh.12
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k0OcfV46wpHLQ08ekNzG6WKCwDZBS6KZcxpI/Ed/P6c=;
        b=TsGyXNaCbyd32Z5w3PHvIS3LPKNbJBsJZBoOZ4JL8tV82isOQPZdAlQuD/T3OhBA18
         ZI4ONZsLvMv6tDH5w+hcRkr/lJqcVvyCCpNk91QsIZiXXRj5I/mO/MBMFLedCFfWJZai
         zxuyYMLVtXmgBLfyLBiDne/aykLFcuxd3J6zfgrNW9RUTMghxvREHM2ifOkakLjNkcgr
         A/FbWzh+RN5jEbEcnUZfbPxCo8uosuh6/fVp1qRnm0+LvtAXS6IFKHIJuRQTqDfo+rGE
         9YLg2suygczNC8mj7ZdvzS9h7IA5un7ibo8giQAUhEEqbRzmkVtUEfhTviazE66DNITy
         yYjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k0OcfV46wpHLQ08ekNzG6WKCwDZBS6KZcxpI/Ed/P6c=;
        b=VPI5+NHHNUwYcMDLqfbaosvwKfyxVrHazaT3hUhasBt0Td3jkPaIg9HmTcCyb2Beul
         mK3ibd6pk88I4TIZGT3hNsU8isrT+AQa+zid7+3IDVJigqb8SlC7owbi2wgtD9nLnPeF
         s8+QgPk+ODcD5SCzOFHLdTjjV0pcthRCg/lzQb3XCZE0PdSi+jbWz6eoCY2Q+z+P7mxS
         zjBiAOsQWrJrnb1LYWkqet3vLbDufYO2hhMS5w77/LckAd+UGgAxmWlN6zZVOwuZZ2P5
         2WV20mZNdYlIK1HR2iPtVDZcofwFtjTBAJqd9gJOA7FFjMZSaQTVaQElEmT4C2vGzeKb
         jgsg==
X-Gm-Message-State: AJIora+PK8C/k6FsfHa7JQXbVO9zmO7IAIE3GrQApv/kmJtEpd2X3wel
        H56da0ypc8flzXjAQjOsXXQ5P7IGwOc=
X-Google-Smtp-Source: AGRyM1tB4TEeGy5P7o+BUVgsZ5wFbOzFDKxL+CwkKMJqXjLUNBKO+Jyx+1XpppZ4CIYLIREYYUd2zQ==
X-Received: by 2002:ac8:5dd3:0:b0:31b:daf5:2a5d with SMTP id e19-20020ac85dd3000000b0031bdaf52a5dmr1743205qtx.650.1656357901288;
        Mon, 27 Jun 2022 12:25:01 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:a41f:1e43:3539:7330])
        by smtp.gmail.com with ESMTPSA id z16-20020ac84550000000b003052599371fsm7672370qtn.12.2022.06.27.12.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 12:25:00 -0700 (PDT)
Date:   Mon, 27 Jun 2022 12:24:59 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, quic_jzenner@quicinc.com,
        Cong Wang <cong.wang@bytedance.com>, qitao.xu@bytedance.com,
        Sean Tranchetti <quic_stranche@quicinc.com>
Subject: Re: [PATCH net-next] net: Print real skb addresses for all net events
Message-ID: <YroEC3NV3d1yTnqi@pop-os.localdomain>
References: <1656050956-9762-1-git-send-email-quic_subashab@quicinc.com>
 <CANn89iJ_HBEkiU3ToAjcv_KHz3f77DJpycKcU=74X3rNst-V6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJ_HBEkiU3ToAjcv_KHz3f77DJpycKcU=74X3rNst-V6g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 08:27:34AM +0200, Eric Dumazet wrote:
> On Fri, Jun 24, 2022 at 8:09 AM Subash Abhinov Kasiviswanathan
> <quic_subashab@quicinc.com> wrote:
> >
> > Commit 65875073eddd ("net: use %px to print skb address in trace_netif_receive_skb")
> > added support for printing the real addresses for the events using
> > net_dev_template.
> >
> 
> It is not clear why the 'real address' is needed in trace events.

Because hashed address is _further_ from being unique, we could even
observe same hashed addresses with a few manually injected packets.

Real address is much better. Although definitely it can't guarantee
uniqueness, it is already the cheapest way to identify the packets in
tracing. (Surely you can add an ID generator or something similiar, but
nothing is cheaper than just using the real address.)

> 
> I would rather do the opposite.
>

Strongly disagree. I will sent a revert.

Thanks.
