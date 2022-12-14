Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAB564C12B
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 01:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237422AbiLNAb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 19:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237433AbiLNAb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 19:31:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B1213DD7
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 16:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670977841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5/DKXnmJkH8N016jW/1YR9trr0KMuzerJfu4aLg0h/g=;
        b=LeGeow8pa9ZYFxsM1TGmil3JsMyAo5V1e654tJBL5MuMon4k8/VMqw95DbI7Fkk5NqCU+q
        aCI8Wi1sAxjjANuMj/EBHPdXdpa1KmIEsIHazgBIN+hxNJx/XCmh4a3vMDt3c3k1y5LOTj
        0HSdo2GBAV+2Lf83EXxNxCMubP82fWw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-606-Zxx87T6lMuigs-LhGxnbPA-1; Tue, 13 Dec 2022 19:30:40 -0500
X-MC-Unique: Zxx87T6lMuigs-LhGxnbPA-1
Received: by mail-ed1-f71.google.com with SMTP id r12-20020a05640251cc00b00463699c95aeso8298337edd.18
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 16:30:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5/DKXnmJkH8N016jW/1YR9trr0KMuzerJfu4aLg0h/g=;
        b=ztL8hQ7gIWU2bvQgeo4m/es/qBHC70GYmhypFPRgEey8lP81r5S/Ed60n98ALbjTRj
         NJnwVGv04FKa/VzxuTVGSPD6A0MrjOqVvZxE8RY7fkbSTkRqTA9mW/79MED7KNKWxKWV
         uTRUDBm2jMTw+B3JJy2rfUJSuhBTW1K++46oU2q6GKIwS4StQdareRAdhpMtO7t+39nh
         YFjpjrIUY0yn4rP4lixir8xZDqsVDEqpFer1ZMoHBj4qUKKoSUQuFcwVxCeMYJjDglIU
         p28KoK+Yallm7ec9O8/Tx6n6t8lMg6u1KRmbOxEoS9plOblVgSZE0v0jtBiszLKWcIBp
         5pUA==
X-Gm-Message-State: ANoB5plZE0pDdhd37xlkghM0YqfhErHKQ9IMswlQXkOFwLl3z1VgjNBy
        zze+t1ECRwW3lqkm+1+Uw4jLS8teP1Fo/OSEMYwkFyBx1dBkBT5qmOoUux8PC9h/8149AFavWLI
        v7FYpiTKdqZm3pj5J
X-Received: by 2002:a17:906:5a87:b0:7c1:962e:cf24 with SMTP id l7-20020a1709065a8700b007c1962ecf24mr3056238ejq.50.1670977838816;
        Tue, 13 Dec 2022 16:30:38 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4Sa6XkMcSkNV/JP3TsVUZAOpfdGZylfeDnpVOOclMkVkNySPr4qBDk65ovykUjrlKdSgYFUg==
X-Received: by 2002:a17:906:5a87:b0:7c1:962e:cf24 with SMTP id l7-20020a1709065a8700b007c1962ecf24mr3056220ejq.50.1670977838504;
        Tue, 13 Dec 2022 16:30:38 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id u18-20020a170906069200b007ad84cf1346sm5072862ejb.110.2022.12.13.16.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 16:30:36 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7480282F40E; Wed, 14 Dec 2022 01:30:35 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Shuah Khan <shuah@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf v3 2/2] selftests/bpf: Add a test for using a cpumap
 from an freplace-to-XDP program
In-Reply-To: <CAEf4BzaHeT5+JQaJdF70THve7e7UxYoL58iVWKCGG6XmQCbxYA@mail.gmail.com>
References: <20221213232441.652313-1-toke@redhat.com>
 <20221213232441.652313-2-toke@redhat.com>
 <CAEf4BzaHeT5+JQaJdF70THve7e7UxYoL58iVWKCGG6XmQCbxYA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 14 Dec 2022 01:30:35 +0100
Message-ID: <87r0x2hln8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Dec 13, 2022 at 3:24 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> This adds a simple test for inserting an XDP program into a cpumap that =
is
>> "owned" by an XDP program that was loaded as PROG_TYPE_EXT (as libxdp
>> does). Prior to the kernel fix this would fail because the map type
>> ownership would be set to PROG_TYPE_EXT instead of being resolved to
>> PROG_TYPE_XDP.
>>
>> v3:
>> - Update comment to better explain the cause
>> - Add Yonghong's ACK
>>
>> Acked-by: Yonghong Song <yhs@fb.com>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>
> what a race, I just replied a few minutes ago on your v2. Let's use
> modern BPF skeleton approach instead of adding legacy stuff to
> testing_helpers

Sure, will respin...

-Toke

