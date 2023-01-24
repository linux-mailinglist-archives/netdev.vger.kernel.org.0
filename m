Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3304679706
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 12:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbjAXLuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 06:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbjAXLuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 06:50:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D967640BDB
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 03:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674560970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E+8CpAUiEMzDSueeZ/CcPXedjzkC+Vhi6CdGhcnqLlw=;
        b=Ggdwg5S/6Ghe/7OqpwMSqA/Ad3abToCLqY7SaPSnYquST2lUYs3uCH2yGaSqWk3Fjm3sQ2
        w//XDl1/ts9298v/E7aHbrWfsigo9/vVMnQg17PAVqTLHUrH7p4jPve7tnys+EU0aURXy2
        a1EC3EdDwpqCYtMazl5GCg9SqTBrp4I=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-494-Wl6mk_21PGiFEhqj9jaUqg-1; Tue, 24 Jan 2023 06:49:26 -0500
X-MC-Unique: Wl6mk_21PGiFEhqj9jaUqg-1
Received: by mail-ed1-f70.google.com with SMTP id s14-20020a056402520e00b0049e0bea1c3fso10476541edd.3
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 03:49:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E+8CpAUiEMzDSueeZ/CcPXedjzkC+Vhi6CdGhcnqLlw=;
        b=TAFM8U76eP8J/v8/TFbcBg2j6YKtYyEBu/CcgeXXq7B9de3E81Sr8KeeKU6Eq5jt4a
         TIt4F6FDF0L7tKITs2s4j2raE76VQ0Ago91dCbqdD8N2Zk0+uPIAZCVsIkoulizIDjlH
         tYyYCfUcKmEbtorIkOGyNcXE/tonrmTHXZ6FObkza2KdtZhBbe5xpK3Y1LF2PwpyIjXS
         OwxYLgXzeKhP0ODMG0SSyCE138DQ3GWijSIYbsZRGv603QL61Ksv4RIHWDtteENbYIAz
         +uujW12H5IS37hfIFEpwDNhQyfx8ZrGP+SboC098T78l6sx4ZBA3uflOXNeaAhyqTS+B
         BuqA==
X-Gm-Message-State: AFqh2kpjHoO+PwrvQIrv5yeNz4V6nT+i12HwUjmRieNN4zL/P3GexuQ9
        NBuwICj4n/lMaf1kH2Br1D6+Ia4rzwvRl2e5TsTTSKQgWKiUPOc+74xaZjPV80OkBAeoQ7Ceako
        yrg0eRzMKvrl0L5We
X-Received: by 2002:a17:906:4e09:b0:86f:2cc2:7029 with SMTP id z9-20020a1709064e0900b0086f2cc27029mr28409506eju.38.1674560965311;
        Tue, 24 Jan 2023 03:49:25 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuFW42pOrJS5TdgBDaQkg1EwxDSUf3jHUle3aR/jouGbhcEhzEDRCQA583LajKdODxHNXcZZQ==
X-Received: by 2002:a17:906:4e09:b0:86f:2cc2:7029 with SMTP id z9-20020a1709064e0900b0086f2cc27029mr28409417eju.38.1674560964159;
        Tue, 24 Jan 2023 03:49:24 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id vt4-20020a170907a60400b007e0e2e35205sm810924ejc.143.2023.01.24.03.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 03:49:23 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E30DB942AEF; Tue, 24 Jan 2023 12:49:22 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Stanislav Fomichev <sdf@google.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v8 00/17] xdp: hints via kfuncs
In-Reply-To: <5b757a2a-86a7-346c-4493-9ab903de19e4@intel.com>
References: <20230119221536.3349901-1-sdf@google.com>
 <901e1a7a-bb86-8d62-4bd7-512a1257d3b0@linux.dev>
 <CAKH8qBs=1NgpJBNwJg7dZQnSAAGpH4vJj0+=LNWuQamGFerfZw@mail.gmail.com>
 <5b757a2a-86a7-346c-4493-9ab903de19e4@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 24 Jan 2023 12:49:22 +0100
Message-ID: <87lelsp2yl.fsf@toke.dk>
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

Alexander Lobakin <alexandr.lobakin@intel.com> writes:

> From: Stanislav Fomichev <sdf@google.com>
> Date: Mon, 23 Jan 2023 10:55:52 -0800
>
>> On Mon, Jan 23, 2023 at 10:53 AM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>>
>>> On 1/19/23 2:15 PM, Stanislav Fomichev wrote:
>>>> Please see the first patch in the series for the overall
>>>> design and use-cases.
>>>>
>>>> See the following email from Toke for the per-packet metadata overhead:
>>>> https://lore.kernel.org/bpf/20221206024554.3826186-1-sdf@google.com/T/#m49d48ea08d525ec88360c7d14c4d34fb0e45e798
>>>>
>>>> Recent changes:
>>>> - Keep new functions in en/xdp.c, do 'extern mlx5_xdp_metadata_ops' (Tariq)
>>>>
>>>> - Remove mxbuf pointer and use xsk_buff_to_mxbuf (Tariq)
>>>>
>>>> - Clarify xdp_buff vs 'XDP frame' (Jesper)
>>>>
>>>> - Explicitly mention that AF_XDP RX descriptor lacks metadata size (Jesper)
>>>>
>>>> - Drop libbpf_flags/xdp_flags from selftests and use ifindex instead
>>>>    of ifname (due to recent xsk.h refactoring)
>>>
>>> Applied with the minor changes in the selftests discussed in patch 11 and 17.
>>> Thanks!
>> 
>> Awesome, thanks! I was gonna resend around Wed, but thank you for
>> taking care of that!
> Great stuff, congrats! :)

Yeah! Thanks for carrying this forward, Stanislav! :)

-Toke

