Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2996E5E71
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 12:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbjDRKR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 06:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjDRKR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 06:17:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2474535B8
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 03:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681813025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ApoV6tQ/8bWNgsumqAtwyvPE2nYx/deLF6XAnhG6Ezo=;
        b=J500t3ugDcjqOXzX4KnVWssN9Cq4khliDIXF+rf37G7j/s0Q+sloVZeSAqc9KSb9fsZ7af
        wBAI4HzjXe/M5gW/SxWmYwZiyBejbdk1wgqZ2Ayxx73c+OgxlRgIetILOlcQz8NrRLT8oU
        NmwdKjNxOcPbvZ/pp7CXwU0hK4Ng/GQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-cOioXf9bNoWoYLvzotRp5Q-1; Tue, 18 Apr 2023 06:17:01 -0400
X-MC-Unique: cOioXf9bNoWoYLvzotRp5Q-1
Received: by mail-ed1-f69.google.com with SMTP id r1-20020a50d681000000b0050504eaf919so9666388edi.8
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 03:17:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681813020; x=1684405020;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ApoV6tQ/8bWNgsumqAtwyvPE2nYx/deLF6XAnhG6Ezo=;
        b=bqvd/xvkxprj2EnTsSQHoPhcl/9d7wuzE0iFaEevImGDGesi/DyA2IMMbDmj6lvo0k
         x1LbR/P6DuJKYUtLu6i4o7+1FVvnWho9nysMfHumx7+vr1ZeZFJbWRNs40rgxyRZu6kH
         TO9Lk6vX/rp6rzG0yGKdSJKTbtuX6TotQi55ZgMrn5g0jfh91jkQ8vd1H+Zr2y6LaQVO
         tSvNvyH47HZ/7sBl+TPuhC9e+4dTl/VBOg16piZfducGW0H1EqBrt1eOLu4qxNMcl0Xq
         ypSn+nJTxrmotpqpHbiE3kTxLzb9ftos7/bSVH3ePsEMcmyxEtjAGtWr8fA5Kc4h9mw9
         eVsQ==
X-Gm-Message-State: AAQBX9cePiJJfWh0CrWw8jT6H2FVpPBPXTg9t8v63hlEI3GfPoZUy84a
        SdnMo7IN4CZihtPvsCB1bG92b2GUlFzSIp6cNWL6Mg6l5hnTKLcieAIchadFVLxYMZLogYGCPr8
        U7F47yzHzboIsyTxQ
X-Received: by 2002:a17:907:838d:b0:947:4828:4399 with SMTP id mv13-20020a170907838d00b0094748284399mr7869350ejc.12.1681813020428;
        Tue, 18 Apr 2023 03:17:00 -0700 (PDT)
X-Google-Smtp-Source: AKy350a+9FUztTLaTcXx8PE3l5G/TqPZEC561sVQryR4LTqFxkdQ1s67cLIsu1//A4fVbtZjLVD1Og==
X-Received: by 2002:a17:907:838d:b0:947:4828:4399 with SMTP id mv13-20020a170907838d00b0094748284399mr7869332ejc.12.1681813020026;
        Tue, 18 Apr 2023 03:17:00 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z17-20020a170906715100b0093f822321fesm7835354ejj.137.2023.04.18.03.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 03:16:59 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 99F12AA85EB; Tue, 18 Apr 2023 12:16:58 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kal Cutter Conley <kal.conley@dectris.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?utf-8?B?QmrDtnJu?= =?utf-8?B?IFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
In-Reply-To: <CAHApi-=ODe-WtJ=m6bycQhKoQxb+kk2Yk9Fx5SgBsWUuWT_u-A@mail.gmail.com>
References: <20230406130205.49996-1-kal.conley@dectris.com>
 <20230406130205.49996-2-kal.conley@dectris.com> <87sfdckgaa.fsf@toke.dk>
 <ZDBEng1KEEG5lOA6@boxer>
 <CAHApi-nuD7iSY7fGPeMYiNf8YX3dG27tJx1=n8b_i=ZQdZGZbw@mail.gmail.com>
 <875ya12phx.fsf@toke.dk>
 <CAHApi-=rMHt7uR8Sw1Vw+MHDrtkyt=jSvTvwz8XKV7SEb01CmQ@mail.gmail.com>
 <87ile011kz.fsf@toke.dk>
 <CAHApi-=ODe-WtJ=m6bycQhKoQxb+kk2Yk9Fx5SgBsWUuWT_u-A@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 18 Apr 2023 12:16:58 +0200
Message-ID: <874jpdwl45.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kal Cutter Conley <kal.conley@dectris.com> writes:

>> In addition, presumably when using this mode, the other XDP actions
>> (XDP_PASS, XDP_REDIRECT to other targets) would stop working unless we
>> add special handling for that in the kernel? We'll definitely need to
>> handle that somehow...
>
> I am not familiar with all the details here. Do you know a reason why
> these cases would stop working / why special handling would be needed?
> For example, if I have a UMEM that uses hugepages and XDP_PASS is
> returned, then the data is just copied into an SKB right? SKBs can
> also be created directly from hugepages AFAIK. So I don't understand
> what the issue would be. Can someone explain this concern?

Well, I was asking :) It may well be that the SKB path just works; did
you test this? Pretty sure XDP_REDIRECT to another device won't, though?

-Toke

