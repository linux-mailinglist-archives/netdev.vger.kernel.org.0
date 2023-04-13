Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCF56E161D
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 22:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjDMUtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 16:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjDMUtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 16:49:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E351B93
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 13:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681418949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iLaM67UvMzd8NeAnSp7Vx35R3ooH8nXVeMsYhQtDrpw=;
        b=X6ep247FBIIPmR7oVFpl3fYoqeQTKpEsXX5ov2VRlS/VUANaDke84qZgnWAhzVGdfAzXtd
        PwbK264YPgmw8qJt/As2C0LVlcQRFU5lKCU64Yh99km8CgGEBk/9k0HLsJJIV7655j0vt0
        K2VFvurIhTVrkKSLtHxciUPpWKgmJC0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-lVfGTu5oM_yaV60YQaf0yA-1; Thu, 13 Apr 2023 16:49:08 -0400
X-MC-Unique: lVfGTu5oM_yaV60YQaf0yA-1
Received: by mail-ed1-f69.google.com with SMTP id a26-20020a509b5a000000b004acbe232c03so8703522edj.9
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 13:49:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681418947; x=1684010947;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iLaM67UvMzd8NeAnSp7Vx35R3ooH8nXVeMsYhQtDrpw=;
        b=LB5ojSmPxNLv5qfZ+sgDGcYBIpzXYWDGsvSiJHAR2fwQa8FDM45jU/Yc2R4B094inI
         nFpmAIjIjA6U72GzlRKk7+/0UajQ/5EZlr2ih5CSF7kw/2DU1DHs1+KEpm/9ozOQO9BV
         xqOrkDsXAeQYyrHoF6pG9drT9GwxsSXZ8cSmXTZhZkblRBKv/nfARUoXQ69jfP7fWdt5
         oXZVvD/NplLK08nOu+NB+DNoRtREBAqYT3PCJjy3vfd7dAowMhRZRRgFNXXOAWkc7rNy
         Ek1+osDB0WU3gKiGDfnODLH/sPndLW2RrqzAlFPJw0UdoWaE5/+dNUJA1UXsOkqyxO8L
         75JQ==
X-Gm-Message-State: AAQBX9caMKzs98hjnIqKNqrOPJSNs3MGR/FaG743F5VGf4n6UmVWxxNC
        dbytL12Z1ZJDqhuH281HZIwWHcV6B2m/0lOoBKbRcaQ7FxVXh4TiL7P21dzgDY/yMvEpkq1urNh
        P8V442qS9keMib8id
X-Received: by 2002:a17:907:984c:b0:948:b988:8cc3 with SMTP id jj12-20020a170907984c00b00948b9888cc3mr4147782ejc.75.1681418945775;
        Thu, 13 Apr 2023 13:49:05 -0700 (PDT)
X-Google-Smtp-Source: AKy350bPGSR3gQ4upooNybI4H3M/HmIOXfKfoJqvk974LBdVJoWBT91lmcIroESBjv99VoMziDvCCg==
X-Received: by 2002:a17:907:984c:b0:948:b988:8cc3 with SMTP id jj12-20020a170907984c00b00948b9888cc3mr4147755ejc.75.1681418945065;
        Thu, 13 Apr 2023 13:49:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f21-20020a05640214d500b0050489201b81sm1255849edx.26.2023.04.13.13.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 13:49:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E9ECEAA7BA3; Thu, 13 Apr 2023 22:49:03 +0200 (CEST)
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
In-Reply-To: <CAHApi-m4gu8SX_1rBtUwrw+1-Q3ERFEX-HPMcwcCK1OceirwuA@mail.gmail.com>
References: <20230406130205.49996-1-kal.conley@dectris.com>
 <20230406130205.49996-2-kal.conley@dectris.com> <87sfdckgaa.fsf@toke.dk>
 <ZDBEng1KEEG5lOA6@boxer>
 <CAHApi-nuD7iSY7fGPeMYiNf8YX3dG27tJx1=n8b_i=ZQdZGZbw@mail.gmail.com>
 <875ya12phx.fsf@toke.dk>
 <CAHApi-=rMHt7uR8Sw1Vw+MHDrtkyt=jSvTvwz8XKV7SEb01CmQ@mail.gmail.com>
 <87ile011kz.fsf@toke.dk>
 <CAHApi-m4gu8SX_1rBtUwrw+1-Q3ERFEX-HPMcwcCK1OceirwuA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 13 Apr 2023 22:49:03 +0200
Message-ID: <87o7nrzeww.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kal Cutter Conley <kal.conley@dectris.com> writes:

>> Well, you mentioned yourself that:
>>
>> > The disadvantage of this patchset is requiring the user to allocate
>> > HugeTLB pages which is an extra complication.
>
> It's a small extra complication *for the user*. However, users that
> need this feature are willing to allocate hugepages. We are one such
> user. For us, having to deal with packets split into disjoint buffers
> (from the XDP multi-buffer paradigm) is a significantly more annoying
> complication than allocating hugepages (particularly on the RX side).

"More annoying" is not a great argument, though. You're basically saying
"please complicate your code so I don't have to complicate mine". And
since kernel API is essentially frozen forever, adding more of them
carries a pretty high cost, which is why kernel developers tend not to
be easily swayed by convenience arguments (if all you want is a more
convenient API, just build one on top of the kernel primitives and wrap
it into a library).

So you'll need to come up with either (1) a use case that you *can't*
solve without this new API (with specifics as to why that is the case),
or (2) a compelling performance benchmark showing the complexity is
worth it. Magnus indicated he would be able to produce the latter, in
which case I'm happy to be persuaded by the numbers.

In any case, however, the behaviour needs to be consistent wrt the rest
of XDP, so it's not as simple as just increasing the limit (as I
mentioned in my previous email).

-Toke

