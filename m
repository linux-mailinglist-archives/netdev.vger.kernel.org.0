Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31949574A3B
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 12:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238163AbiGNKN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 06:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237829AbiGNKNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 06:13:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4AFA7F5A7
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657793628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DsGwO9HWD4Cbhq+MSuSkc+2KenLUZr7HYDGzQyLBjVQ=;
        b=QFf/Xg6YIBDHDDuDyalrCt70ciT6WYq3dIT0KhKnNy/Uc0MmkVpWmyYfQ0Fr2MeYFg0+33
        +n505eHNXmIjAE/YSNuCjecqqhZziUyGDQp5Vwky4BmKTslt8zxD9a+p1Q347wV1K6zaMv
        onCzSsEEvu5btdPR6koZfw3clsW4McQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-8jTZorkGO36i23G0HEP_Bw-1; Thu, 14 Jul 2022 06:13:47 -0400
X-MC-Unique: 8jTZorkGO36i23G0HEP_Bw-1
Received: by mail-ed1-f69.google.com with SMTP id c9-20020a05640227c900b0043ad14b1fa0so1234495ede.1
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:13:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=DsGwO9HWD4Cbhq+MSuSkc+2KenLUZr7HYDGzQyLBjVQ=;
        b=BGiJU6fnH8TvPIX1MKp8/4l0809Fs6ULt4hl5eshIx4/BeTGTmrlc6/GwAke8fBjmh
         fmbSW9MXYIlnTYgeLGbuAp8yEkMxBKZQ8OVpM2+rRoTZJ/yH09yuoxalSNJEko51mb1i
         HGR+fpooQViSoF9a7Iqk0RGukChIaYEpTubG4FIUBse+LpCpyjCWqXioEIxUhbTL/8hI
         yVnZYJCq1Q4hz9n0yubSYXNVlD1R0lkQ+Zv2b0hnWfNKJasD59oVDprer+IhCHc0UVdx
         mLkJW/mVhbP/Y0dj8AiilFB3TJxqQi7fWGM3StXkCI1Dl6vPM7L0Dx6PWj58ImAuDeo+
         /JFw==
X-Gm-Message-State: AJIora/W1ABpJMI7BVHJe3UB7wv35m634A5AbcjvuFFJFN0OX6h5GjxV
        u9Yb2ZTbEvZF3Ep6jNa9nXXZRxyPwbHpjf5PzQCD1gif10JY9k4swNxBIwJ9H+DdNhpiS0zCu/o
        wRQCaRzeivBp36Oc+
X-Received: by 2002:a17:907:d26:b0:72b:8311:a167 with SMTP id gn38-20020a1709070d2600b0072b8311a167mr7906420ejc.89.1657793625862;
        Thu, 14 Jul 2022 03:13:45 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vb+Oj04dmGnnVMDrCOQd21EmWUcvqli1zsK3U0RSfLzgvyUxFIuAa6i7QblpSW/cJ0hl5LGg==
X-Received: by 2002:a17:907:d26:b0:72b:8311:a167 with SMTP id gn38-20020a1709070d2600b0072b8311a167mr7906371ejc.89.1657793625493;
        Thu, 14 Jul 2022 03:13:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id eu18-20020a170907299200b006fe921fcb2dsm524228ejc.49.2022.07.14.03.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 03:13:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 205744D9B1B; Thu, 14 Jul 2022 12:13:43 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
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
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [RFC PATCH 14/17] libbpf: Add support for querying dequeue
 programs
In-Reply-To: <CAEf4BzZN2kBafJPQKaM4Pakf=PSYGiVzq53ED0NCRZ+DkaZHKA@mail.gmail.com>
References: <20220713111430.134810-1-toke@redhat.com>
 <20220713111430.134810-15-toke@redhat.com>
 <CAEf4BzZN2kBafJPQKaM4Pakf=PSYGiVzq53ED0NCRZ+DkaZHKA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 14 Jul 2022 12:13:43 +0200
Message-ID: <871quoovc8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Wed, Jul 13, 2022 at 4:15 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Add support to libbpf for reading the dequeue program ID from netlink wh=
en
>> querying for installed XDP programs. No additional support is needed to
>> install dequeue programs, as they are just using a new mode flag for the
>> regular XDP program installation mechanism.
>>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  tools/lib/bpf/libbpf.h  | 1 +
>>  tools/lib/bpf/netlink.c | 8 ++++++++
>>  2 files changed, 9 insertions(+)
>>
>> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
>> index e4d5353f757b..b15ff90279cb 100644
>> --- a/tools/lib/bpf/libbpf.h
>> +++ b/tools/lib/bpf/libbpf.h
>> @@ -906,6 +906,7 @@ struct bpf_xdp_query_opts {
>>         __u32 drv_prog_id;      /* output */
>>         __u32 hw_prog_id;       /* output */
>>         __u32 skb_prog_id;      /* output */
>> +       __u32 dequeue_prog_id;  /* output */
>
> can't do that, you have to put it after attach_mode to preserve
> backwards/forward compat

Argh, yes, of course, total brainfart - thanks for pointing that out! :)

-Toke

