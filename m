Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46F853CDEB
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 19:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344309AbiFCRN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 13:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344297AbiFCRN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 13:13:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 66F1635A97
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 10:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654276436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qZiiAYxaxMVVhxFITrMzwfTeeESt5JIMhKGAkJ8Xd4w=;
        b=M7P6DwZd3u8xjiHet1Z57pnlkK/v1yTZ0cPtmVcFbGb292rDGLpwQSkiEyoi3mXpixm8/z
        vuDtzMqQWunsi4mi5TkjpigAtEZ0J2q/h1BxakRYcssC+UaQwFHbwNVeZxYFKMFCxSSAaO
        DbpSa3x/rkHKLo8VKhr78GCB+z5VKjA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-MqhGurQ4PRiAWQKcTMM7gw-1; Fri, 03 Jun 2022 13:13:54 -0400
X-MC-Unique: MqhGurQ4PRiAWQKcTMM7gw-1
Received: by mail-qk1-f199.google.com with SMTP id az40-20020a05620a172800b006a5faff65c8so6395284qkb.7
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 10:13:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=qZiiAYxaxMVVhxFITrMzwfTeeESt5JIMhKGAkJ8Xd4w=;
        b=krSiv53X2oi7tDV9tqPu+Z8f6vfPuwS94AlqH2UTli7eUjwTQn7b3PZ+LxJJV61uXF
         PUwJqZ/yidIlmw7CuINMn/u2qzBi5vKQ6H4J5cjw26ZK9uMKN+DC09c0ViMl6HdPAZYh
         L7Hh54fmZ+saMi3g8wsRDJOSaWZ777A+BWqce4rIBsnHk8t+Celh4j6yFz/f7oFfxJw1
         U+Dbu1U2R7FxEtL3+Kb1epdAaWBZs4W+LcxgFET0OCWnJ5CGEj/BkziTsNEkIaScoM9g
         48KQggnis5r3MOR8d8V86Smw0ypCZ0KjYPR0noWP15fsKPMoFfbmQMn5paM9+4Av9wgN
         acuQ==
X-Gm-Message-State: AOAM532MDJvvZRhX9Mij8gniIUbQg9h7f4JCuf28A8knoI0BJdp+IPwY
        mgFFigbw9SZoQinR7yl3fmDQa9/TWYMOkfdvGPfv3y8y+mCZrnNl2JLHbpOW91qfB4hyTAQjUqc
        yPfBCR57HYNoF1b6M
X-Received: by 2002:ad4:43e9:0:b0:462:6062:82ba with SMTP id f9-20020ad443e9000000b00462606282bamr41958235qvu.70.1654276433699;
        Fri, 03 Jun 2022 10:13:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwQG+tJHvXZScmjdVhwkEzp2abOgy7MnyCRyloUjacCm7hjuvm+xhwbSEMj9rhHw2p6suppA==
X-Received: by 2002:ad4:43e9:0:b0:462:6062:82ba with SMTP id f9-20020ad443e9000000b00462606282bamr41958206qvu.70.1654276433378;
        Fri, 03 Jun 2022 10:13:53 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id s6-20020a05622a018600b002fcdfed2453sm5659974qtw.64.2022.06.03.10.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 10:13:52 -0700 (PDT)
Message-ID: <33ceb9b576c98cf0fae1d37a3a95f534975410a6.camel@redhat.com>
Subject: Re: [PATCH v2] ipv6/addrconf: fix timing bug in tempaddr regen
From:   Paolo Abeni <pabeni@redhat.com>
To:     Sam Edwards <cfsworks@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>
Date:   Fri, 03 Jun 2022 19:13:49 +0200
In-Reply-To: <CAH5Ym4iS=d+dUAg+85wmRJv+jV=Cet=UtN1pNWejMV5fdPVprA@mail.gmail.com>
References: <20220528004820.5916-1-CFSworks@gmail.com>
         <c1c7a1207986d4ad9e80a301fe5e1415631949a9.camel@redhat.com>
         <CAH5Ym4iS=d+dUAg+85wmRJv+jV=Cet=UtN1pNWejMV5fdPVprA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-06-02 at 23:02 -0600, Sam Edwards wrote:
> Since this is a periodic routine, it receives coverage as the system
> runs normally. If we're concerned about protecting this change from
> regressions and/or through the merge process, some kind of automated
> test might be in order, but right now the way to test it is to leave
> the system up, with tempaddrs enabled, on a IPv6 SLAAC network, for
> several multiples of the temp_prefered_lft.

It does not look easy, but you could use kunit to create e.g. a
temporary address on the loopback device with the critical expiration
time setting and check that it's deleted in due time - possibly after
tuning the defaults to a reasonably short period.

The above will additionally open-up opportunities for more autoconf
tests.

Up to your good will ;)

Thanks

Paolo

