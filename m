Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2966F011B
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 08:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242942AbjD0G4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 02:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242702AbjD0G4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 02:56:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D81344B0
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 23:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682578563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fRH+mkm7wTLmUFms37x8ndQ9a+fMCIyXg2Z2DM7enPw=;
        b=Y2eMyJvmv+UKXgMkzG6z6U1aCUNRicJ1CjZ3qNG6DXbaS6+tpmZ6HISl8j03EvmV+UFAzQ
        php96D4GpeZUr4O1lJT0wJlJjC4uN+uFX19qoE2hDaFb1CttcF2R47nohuXnXoZbG92OPJ
        AXxyo0w77EkVcuKxoPxDog4U9it3pvQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-nizsMZG_Mtu_2jBvd1jx7A-1; Thu, 27 Apr 2023 02:56:00 -0400
X-MC-Unique: nizsMZG_Mtu_2jBvd1jx7A-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-3edbe09ba35so12425531cf.1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 23:56:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682578560; x=1685170560;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fRH+mkm7wTLmUFms37x8ndQ9a+fMCIyXg2Z2DM7enPw=;
        b=dngp6BPHRUR/1xMf4QK9TZxX6Xvu2y8fO0tkR4TGo9oZ6zq9lZGwFbf8w/VHC3CqmB
         LvOzwvrZWYiTK644KUNKWAe7VIw0rSLG1ZziysVde6mgo+pWX0eN33C2WyXO6OIWcMvI
         VBlD6WVSqNB4+mV6Ywr0FphzmbtigitLU6U7P0qeQvWBnLAMhyxi/Cqhv8yD/fYdxX1j
         AfhhVffE+6Tpz7u95vyIISR9qWEHAmLqVr5g/EFbqkURJQ0viO0oaYN1KUxuMhbJVbo7
         uOt1R/0xqB0Cv3WPmQ2kmU/lEWvnJDJmRqe12SFez4ZaMIo8+IUA4KCTXIQQfMTx7tC0
         bXCw==
X-Gm-Message-State: AC+VfDwRTEZgl9TKtIxsykWov45hnIBP1ooTJsIkCFgHIFgXsLy0CPiG
        vNWpCotG/poVt2eJUDeU+1wmxqKWXSgroeV68f8/2rvo1zLBHU5squvxhB+4rqGngLck92SJvTP
        ho/Te28aL6DOhfcYN
X-Received: by 2002:ac8:5dcf:0:b0:3ef:59e8:511f with SMTP id e15-20020ac85dcf000000b003ef59e8511fmr785044qtx.0.1682578560116;
        Wed, 26 Apr 2023 23:56:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6IY3ISX9/AZqFDTs3717bAYMzWirNzdAR5uENXzS1qvlBOt1T2Rd78y8VkeDq5U7JJzU09gw==
X-Received: by 2002:ac8:5dcf:0:b0:3ef:59e8:511f with SMTP id e15-20020ac85dcf000000b003ef59e8511fmr785030qtx.0.1682578559886;
        Wed, 26 Apr 2023 23:55:59 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-243-21.dyn.eolo.it. [146.241.243.21])
        by smtp.gmail.com with ESMTPSA id pr1-20020a05620a86c100b0074ced3e0004sm5723165qkn.63.2023.04.26.23.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 23:55:59 -0700 (PDT)
Message-ID: <b3eebbb01a6ba370458e17cc9fa1cb80693b0f34.camel@redhat.com>
Subject: Re: [PATCH net-next v4 00/15] virtio_net: refactor xdp codes
From:   Paolo Abeni <pabeni@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Date:   Thu, 27 Apr 2023 08:55:55 +0200
In-Reply-To: <20230427030534.115066-1-xuanzhuo@linux.alibaba.com>
References: <20230427030534.115066-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-04-27 at 11:05 +0800, Xuan Zhuo wrote:
> Due to historical reasons, the implementation of XDP in virtio-net is rel=
atively
> chaotic. For example, the processing of XDP actions has two copies of sim=
ilar
> code. Such as page, xdp_page processing, etc.
>=20
> The purpose of this patch set is to refactor these code. Reduce the diffi=
culty
> of subsequent maintenance. Subsequent developers will not introduce new b=
ugs
> because of some complex logical relationships.
>=20
> In addition, the supporting to AF_XDP that I want to submit later will al=
so need
> to reuse the logic of XDP, such as the processing of actions, I don't wan=
t to
> introduce a new similar code. In this way, I can reuse these codes in the
> future.

## Form letter - net-next-closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after May 8th.

RFC patches sent for review only are obviously welcome at any time.
--=20
pw-bot: defer

