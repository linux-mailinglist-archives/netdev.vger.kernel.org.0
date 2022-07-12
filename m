Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31C857158C
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 11:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbiGLJSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 05:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbiGLJSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 05:18:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44711B7F6
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 02:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657617526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nqE/jzjwP7jwk2FmoVCVvujtcooqMUAch43GDeT3Y2M=;
        b=cKuAf4h+KmmcW/P6ynReyfMpC/v9up0o1KFw0kW7OWHMXI3aUwtcDVXHN8ATwSwGm1lags
        QeQQjiPS/Kjn3meRiJJvL4RPZOPkn88bRGPSzHnURu8Wci7bfqV9GV9/y1hYMZmBgVz5Ba
        AvUYYstI4uMCo0HKpEKDtBiRxjCD0mY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-Pz3Oc9RzMpWrKjLWmQqIOw-1; Tue, 12 Jul 2022 05:18:36 -0400
X-MC-Unique: Pz3Oc9RzMpWrKjLWmQqIOw-1
Received: by mail-wm1-f72.google.com with SMTP id bg6-20020a05600c3c8600b003a03d5d19e4so3528283wmb.1
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 02:18:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nqE/jzjwP7jwk2FmoVCVvujtcooqMUAch43GDeT3Y2M=;
        b=1ouV0sBsFHptFTF3mEIHtkHzIiSlBBEwZo16X7tsrBZUZFBQbMz0K6S0G0V8X7gF9h
         0TGwxfVN2Ylo/oEWNRJxe6fEw5ntnNiolkkf5P4i+46Pz/xM2tRsJKFoQCpZN8zUSEx4
         jQsdagn3gt6oJ8yOsTZ6BQQKc5jcAqYmLknQfc9JI+YvQAsU9MQ+6153UA9deW/BcGDf
         9U+TJwUQwovXWiX2+VyHWsziZpHBSflTjf+hMnahxbtwNgTdPOxhLf9GSR3GuIewR6AD
         tvEXTrSFA06p6tqbzRM0MDjhDUClQDWSsalTe2rx9SKC9MaRxcxRIT272CDphE/IJ+Ro
         ToEA==
X-Gm-Message-State: AJIora/Y3Bh/pnWMnsvLyK3w44/D9mx/Ye6jOi5oCFywL5+1TRDZsUWN
        5S7kzNkcbbchgrM38D8SOU+ez5KYnZzN3psbSBxo88dZUZSbh2IkgmBMe2CJf8PNwHNUFZGtuRs
        B4BGFMRHonZ3ZJxCz
X-Received: by 2002:a05:600c:1906:b0:3a0:d983:cc2b with SMTP id j6-20020a05600c190600b003a0d983cc2bmr2788747wmq.81.1657617515503;
        Tue, 12 Jul 2022 02:18:35 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sz3uW2QDGN5byP2NMgZglyEfzIAOr/VYaEK5vUKbK9DZJUDKq8PvoHa62nVWhM6Z1dZyOfCw==
X-Received: by 2002:a05:600c:1906:b0:3a0:d983:cc2b with SMTP id j6-20020a05600c190600b003a0d983cc2bmr2788721wmq.81.1657617515297;
        Tue, 12 Jul 2022 02:18:35 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-238.dyn.eolo.it. [146.241.97.238])
        by smtp.gmail.com with ESMTPSA id n35-20020a05600c502300b003a2d0f0ccaesm12906153wmr.34.2022.07.12.02.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 02:18:34 -0700 (PDT)
Message-ID: <88f9133542d0a4bf2100e0a521f6e6a19eb2feb1.camel@redhat.com>
Subject: Re: [PATCH for-next 0/3] io_uring: multishot recvmsg
From:   Paolo Abeni <pabeni@redhat.com>
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, io-uring@vger.kernel.org
Cc:     netdev@vger.kernel.org, Kernel-team@fb.com
Date:   Tue, 12 Jul 2022 11:18:33 +0200
In-Reply-To: <20220708184358.1624275-1-dylany@fb.com>
References: <20220708184358.1624275-1-dylany@fb.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-07-08 at 11:43 -0700, Dylan Yudaken wrote:
> This series adds multishot support to recvmsg in io_uring.
> 
> The idea is that you submit a single multishot recvmsg and then receive
> completions as and when data arrives. For recvmsg each completion also has
> control data, and this is necessarily included in the same buffer as the
> payload.
> 
> In order to do this a new structure is used: io_uring_recvmsg_out. This
> specifies the length written of the name, control and payload. As well as
> including the flags.
> The layout of the buffer is <header><name><control><payload> where the
> lengths are those specified in the original msghdr used to issue the recvmsg.
> 
> I suspect this API will be the most contentious part of this series and would
> appreciate any comments on it.
> 
> For completeness I considered having the original struct msghdr as the header,
> but size wise it is much bigger (72 bytes including an iovec vs 16 bytes here).
> Testing also showed a 1% slowdown in terms of QPS.
> 
> Using a mini network tester [1] shows 14% QPS improvment using this API, however
> this is likely to go down to ~8% with the latest allocation cache added by Jens.
> 
> I have based this on this other patch series [2].
> 
> [1]: https://github.com/DylanZA/netbench/tree/main
> [2]: https://lore.kernel.org/io-uring/20220708181838.1495428-1-dylany@fb.com/
> 
> Dylan Yudaken (3):
>   net: copy from user before calling __copy_msghdr
>   net: copy from user before calling __get_compat_msghdr
>   io_uring: support multishot in recvmsg
> 
>  include/linux/socket.h        |   7 +-
>  include/net/compat.h          |   5 +-
>  include/uapi/linux/io_uring.h |   7 ++
>  io_uring/net.c                | 195 ++++++++++++++++++++++++++++------
>  io_uring/net.h                |   5 +
>  net/compat.c                  |  39 +++----
>  net/socket.c                  |  37 +++----
>  7 files changed, 215 insertions(+), 80 deletions(-)
> 
> 
> base-commit: 9802dee74e7f30ab52dc5f346373185cd860afab

I read the above as this series is targeting Jens's tree. It looks like
it should be conflicts-free vs net-next.

For the network bits:

Acked-by: Paolo Abeni <pabeni@redhat.com>

Cheers,

Paolo

