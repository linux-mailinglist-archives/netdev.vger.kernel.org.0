Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D4B6E0C14
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 13:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjDMLJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 07:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjDMLJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 07:09:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0DD5BB1
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 04:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681384128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ons+PEhg040VlXg4ZxDtxYCBN3ktVKjiFeoBkktxpTo=;
        b=PLvsX63EtfHdh6Uo0rQIaDMwV2Gd70q/9/nu7PKmHRRIZCPa4Ngyz+CRNw65jQJ1vvlciE
        0A7WBuIY7tAckkexyixR7i+nL7fmM3w+miCDjNi+CP3OFKwsMjyxKJAtkJkx61nemEmYEc
        wg+RXZ1lwTMEaN7u1YZLNO69a1fEnIM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-HDSyUmVxONy3Fd2vxyRP_Q-1; Thu, 13 Apr 2023 07:08:47 -0400
X-MC-Unique: HDSyUmVxONy3Fd2vxyRP_Q-1
Received: by mail-ej1-f72.google.com with SMTP id tq24-20020a170907c51800b0093138c6f2f8so5363008ejc.22
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 04:08:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681384126; x=1683976126;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ons+PEhg040VlXg4ZxDtxYCBN3ktVKjiFeoBkktxpTo=;
        b=GlVUu7QXCEwGeKuSF/ZJu7FcLTiit2XbhWb8Jtz/RYPPnnXkJykJBXlDArkOaoSBxX
         zO3yJ4xPgNuMS6SGQvrKMZ+jFnBe5sl0riOnQYJbCiV82AfBp0dfSQUzbvIN/vsw+HNF
         Whz7GSBSACEcIbSi7TYKI+h0QLuL2dXagB9n8a5l1GspptzoYOZxJuL4pR6KRceZgyzA
         yhabHt87C+rNHzqj+J5Xu+IGJspHQMP498t6/5UQxpn6alyvci/etoEGx/L1fbXaD9kt
         ik5mazMSM8c3M4baWzmwAhRvYEjLZb62cyHT/szV9gzRXKZMK96O4X6JJEhZXoqXqCOk
         Jxog==
X-Gm-Message-State: AAQBX9ebzho0J52a+M0Uhra1BpfUH3VZW+9b95VLdW5MaDoMW918EQ+k
        v1ly93//WLZcvtxSmXOS0gvEzPHLX4FbgAftDLSI2UJtYYQdR3Lvlw+qXGemRzzbPX0QybDXaOq
        SlQyTgEqEsu41U3gB
X-Received: by 2002:a17:906:3888:b0:94a:8a82:9cab with SMTP id q8-20020a170906388800b0094a8a829cabmr2301559ejd.42.1681384126118;
        Thu, 13 Apr 2023 04:08:46 -0700 (PDT)
X-Google-Smtp-Source: AKy350YRUH859V0juwSOoolH8r33NhgxjjZn9BxXeqS19QTUiJdr16jkspnL6tc/NvqKxhfjEPQfuw==
X-Received: by 2002:a17:906:3888:b0:94a:8a82:9cab with SMTP id q8-20020a170906388800b0094a8a829cabmr2301525ejd.42.1681384125710;
        Thu, 13 Apr 2023 04:08:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id m5-20020a1709062ac500b0094a84462e5fsm827249eje.37.2023.04.13.04.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 04:08:45 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 95816AA7AF0; Thu, 13 Apr 2023 13:08:44 +0200 (CEST)
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
In-Reply-To: <CAHApi-=rMHt7uR8Sw1Vw+MHDrtkyt=jSvTvwz8XKV7SEb01CmQ@mail.gmail.com>
References: <20230406130205.49996-1-kal.conley@dectris.com>
 <20230406130205.49996-2-kal.conley@dectris.com> <87sfdckgaa.fsf@toke.dk>
 <ZDBEng1KEEG5lOA6@boxer>
 <CAHApi-nuD7iSY7fGPeMYiNf8YX3dG27tJx1=n8b_i=ZQdZGZbw@mail.gmail.com>
 <875ya12phx.fsf@toke.dk>
 <CAHApi-=rMHt7uR8Sw1Vw+MHDrtkyt=jSvTvwz8XKV7SEb01CmQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 13 Apr 2023 13:08:44 +0200
Message-ID: <87ile011kz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kal Cutter Conley <kal.conley@dectris.com> writes:

>>
>> Well, I'm mostly concerned with having two different operation and
>> configuration modes for the same thing. We'll probably need to support
>> multibuf for AF_XDP anyway for the non-ZC path, which means we'll need
>> to create a UAPI for that in any case. And having two APIs is just going
>> to be more complexity to handle at both the documentation and
>> maintenance level.
>
> I don't know if I would call this another "API". This patchset doesn't
> change the semantics of anything. It only lifts the chunk size
> restriction when hugepages are used. Furthermore, the changes here are
> quite small and easy to understand. The four sentences added to the
> documentation shouldn't be too concerning either. :-)

Well, you mentioned yourself that:

> The disadvantage of this patchset is requiring the user to allocate
> HugeTLB pages which is an extra complication.

In addition, presumably when using this mode, the other XDP actions
(XDP_PASS, XDP_REDIRECT to other targets) would stop working unless we
add special handling for that in the kernel? We'll definitely need to
handle that somehow...

> In 30 years when everyone finally migrates to page sizes >= 64K the
> maintenance burden will drop to zero. Knock wood. :-)

Haha, right, but let's make sure we have something that is consistent in
the intervening decades, shall we? ;)

>> It *might* be worth it to do this if the performance benefit is really
>> compelling, but, well, you'd need to implement both and compare directly
>> to know that for sure :)
>
> What about use-cases that require incoming packet data to be
> contiguous? Without larger chunk sizes, the user is forced to allocate
> extra space per packet and copy the data. This defeats the purpose of
> ZC.

What use cases would that be, exactly? Presumably this is also a
performance issue? Which goes back to me asking for benchmarks :)

-Toke

