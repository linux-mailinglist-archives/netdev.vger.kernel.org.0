Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3F963B4C9
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 23:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbiK1W0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 17:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiK1W0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 17:26:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D6410FC6
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 14:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669674328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=esifUvS4rY25Js6P1Az3k3jokEJ6OjEKTAKMI9a6KbM=;
        b=QBLveBDSR0COGGlaG10rCLLi0xLFLG13dTJsOFNNifHT/ZGcabhrz4kn9zOfRytJyE4pmL
        xbz1A7Q1xKD2sRK+kXFoygaiC/28UrPMtLT3S3UmbAokGwTXKfLaIml7r5IDvMy+CeH8j9
        ogRiNrpvxoU0QXEKztAr7uNBLUOG90g=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-3-5qNuoXfbPq-xgdtF7TD64A-1; Mon, 28 Nov 2022 17:25:27 -0500
X-MC-Unique: 5qNuoXfbPq-xgdtF7TD64A-1
Received: by mail-ej1-f71.google.com with SMTP id qw20-20020a1709066a1400b007af13652c92so5222914ejc.20
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 14:25:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=esifUvS4rY25Js6P1Az3k3jokEJ6OjEKTAKMI9a6KbM=;
        b=l+S8rxLFZcRFZEyr5up6+yAkjfRdBYaUvM0rKzZxC1JlfT7M5dXIzrqe+nJlBzR/Kw
         OMOSWCRB++xLSyIeZ2OcmQseEeMRvZYW8S/FNdii86gdbgT+GjIlhCtt+1Ljx/x3E5jn
         Sm5NutWnPJdTzTFTjLzFOq6WkNaTqFD6VhIx+yRGpGW8Q9ZvG9fn0fO5HBX+B6fzh9zT
         JbkAXUza0ANH32oqoPhITnT6u23Xhlt1vYuhFTKLK+h0jHoyGaarVIBV8EzkSyo8rIeS
         N1/ANwcQFJlgaSH2XCODa8FkW/EnEC9qmVOpUxFGF+2odro3R5LbfXyZtaw4J9xxE5iu
         pndg==
X-Gm-Message-State: ANoB5pmDh8jB/TvNQkBrsocbrfUMquzgdqRR/AyUeeQ2LnQrm2Z6HL6p
        4X4KrZrgGcCzVqD2oR4+s91yB7OHsiScp698JH1jEJfOX2+9MijgkTXzXPDTXM2qh5nSZvar6Hr
        49XaleDSHsnTqVvS1
X-Received: by 2002:a17:906:6892:b0:78d:ab48:bc84 with SMTP id n18-20020a170906689200b0078dab48bc84mr9183526ejr.22.1669674325028;
        Mon, 28 Nov 2022 14:25:25 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6OCJ/Pgejoyv/p1k+ImioFvemvLHuM7p17Mrwjj7a0VNSDVjrd/Xmy9cF9wmodsOZsxMEB0g==
X-Received: by 2002:a17:906:6892:b0:78d:ab48:bc84 with SMTP id n18-20020a170906689200b0078dab48bc84mr9183466ejr.22.1669674323990;
        Mon, 28 Nov 2022 14:25:23 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id n17-20020a05640206d100b00459f4974128sm5581663edy.50.2022.11.28.14.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 14:25:23 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 04F0D7EBEA3; Mon, 28 Nov 2022 23:25:23 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] [PATCH bpf-next v2 2/8] bpf: XDP metadata RX kfuncs
In-Reply-To: <CAKH8qBvp+4MjRpwMeG3G_duC6RCoJurswMFuC9ynf-F9-is0+g@mail.gmail.com>
References: <20221121182552.2152891-1-sdf@google.com>
 <20221121182552.2152891-3-sdf@google.com> <87mt8e2a69.fsf@toke.dk>
 <CAKH8qBvmgx0Lr7efP0ucdZMEzZM-jzDKcAW9YPBqADWVsHb9cA@mail.gmail.com>
 <CAKH8qBvp+4MjRpwMeG3G_duC6RCoJurswMFuC9ynf-F9-is0+g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 28 Nov 2022 23:25:22 +0100
Message-ID: <87y1ruzpgt.fsf@toke.dk>
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

Stanislav Fomichev <sdf@google.com> writes:

> On Mon, Nov 28, 2022 at 10:53 AM Stanislav Fomichev <sdf@google.com> wrot=
e:
>>
>>  s
>>
>> On Fri, Nov 25, 2022 at 9:53 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>> >
>> > Stanislav Fomichev <sdf@google.com> writes:
>> >
>> > > There is an ndo handler per kfunc, the verifier replaces a call to t=
he
>> > > generic kfunc with a call to the per-device one.
>> > >
>> > > For XDP, we define a new kfunc set (xdp_metadata_kfunc_ids) which
>> > > implements all possible metatada kfuncs. Not all devices have to
>> > > implement them. If kfunc is not supported by the target device,
>> > > the default implementation is called instead.
>> >
>> > BTW, this "the default implementation is called instead" bit is not
>> > included in this version... :)
>>
>> fixup_xdp_kfunc_call should return 0 when the device doesn't have a
>> kfunc defined and should fallback to the default kfunc implementation,
>> right?
>> Or am I missing something?
>>
>> > [...]
>> >
>> > > +#ifdef CONFIG_DEBUG_INFO_BTF
>> > > +BTF_SET8_START(xdp_metadata_kfunc_ids)
>> > > +#define XDP_METADATA_KFUNC(name, str) BTF_ID_FLAGS(func, str, 0)
>> > > +XDP_METADATA_KFUNC_xxx
>> > > +#undef XDP_METADATA_KFUNC
>> > > +BTF_SET8_END(xdp_metadata_kfunc_ids)
>> > > +
>> > > +static const struct btf_kfunc_id_set xdp_metadata_kfunc_set =3D {
>> > > +     .owner =3D THIS_MODULE,
>> > > +     .set   =3D &xdp_metadata_kfunc_ids,
>> > > +};
>> > > +
>> > > +u32 xdp_metadata_kfunc_id(int id)
>> > > +{
>> > > +     return xdp_metadata_kfunc_ids.pairs[id].id;
>> > > +}
>> > > +EXPORT_SYMBOL_GPL(xdp_metadata_kfunc_id);
>> >
>> > So I was getting some really weird values when testing (always getting=
 a
>> > timestamp value of '1'), and it turns out to be because this way of
>> > looking up the ID doesn't work: The set is always sorted by the BTF ID,
>> > not the order it was defined. Which meant that the mapping code got the
>> > functions mixed up, and would call a different one instead (so the
>> > timestamp value I was getting was really the return value of
>> > rx_hash_enabled()).
>> >
>> > I fixed it by building a secondary lookup table as below; feel free to
>> > incorporate that (or if you can come up with a better way, go ahead!).
>>
>> Interesting, will take a closer look. I took this pattern from
>> BTF_SOCK_TYPE_xxx, which means that 'sorting by btf-id' is something
>> BTF_SET8_START specific...
>> But if it's sorted, probably easier to do a bsearch over this table
>> than to build another one?
>
> Ah, I see, there is no place to store an index :-( Maybe the following
> is easier still?
>
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index e43f7d4ef4cf..8240805bfdb7 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -743,9 +743,15 @@ static const struct btf_kfunc_id_set
> xdp_metadata_kfunc_set =3D {
>         .set   =3D &xdp_metadata_kfunc_ids,
>  };
>
> +BTF_ID_LIST(xdp_metadata_kfunc_ids_unsorted)
> +#define XDP_METADATA_KFUNC(name, str) BTF_ID(func, str)
> +XDP_METADATA_KFUNC_xxx
> +#undef XDP_METADATA_KFUNC
> +
>  u32 xdp_metadata_kfunc_id(int id)
>  {
> -       return xdp_metadata_kfunc_ids.pairs[id].id;
> +       /* xdp_metadata_kfunc_ids is sorted and can't be used */
> +       return xdp_metadata_kfunc_ids_unsorted[id];
>  }
>  EXPORT_SYMBOL_GPL(xdp_metadata_kfunc_id);

Right, as long as having that extra list isn't problematic (does it make
things show up twice somewhere or something like that? not really sure
how that works), that is certainly simpler than what I came up with :)

-Toke

