Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1993B62445E
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 15:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiKJOdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 09:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiKJOde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 09:33:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AD312605
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 06:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668090756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kKjCDDez5PjtMLjEbRFqRZ0Q9e8y5qhGRMnKFr/7yvE=;
        b=J/d+gh0DembRYM05GqXxdfpY4mT6HDVOb3n2DsORnMg7FV3PilxjqCG0Cfl3DX5C0vHRf2
        9oPEocGObOyQ4cjEZUqZi5Ebt8cuLy92sUChDWFYGWKS8JU3WdC5Kjxih6DjMGSQ4OYwS7
        eYDl3Vfac2a0bW0eCYtu2iTyy0KBaiE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-654-QvQhEEbpMQuGIPX7bD1eEQ-1; Thu, 10 Nov 2022 09:32:35 -0500
X-MC-Unique: QvQhEEbpMQuGIPX7bD1eEQ-1
Received: by mail-ed1-f71.google.com with SMTP id s15-20020a056402520f00b0046321fff42dso1658474edd.0
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 06:32:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kKjCDDez5PjtMLjEbRFqRZ0Q9e8y5qhGRMnKFr/7yvE=;
        b=cxnFtdYrDFJ2dicw+BRbG0Q/iC9edDJBJ+sa97Xe0kd0GJIa3c9lNjCuV+5SuSsQDp
         go7Y+L3vw1dMDWLUQJuzjaxAaKSijwTbQYZmL+EHqv69N0wl7Ak5lBUytt/8+zCutzzy
         AwwW8YDWwkEUN7IznNEZ5JjaPp4yaj/cpJi2HLm+4fWcKUj1YzXd3M76+W1vWfbsBJWV
         Xg8sOqXC7eUIAW404UuOMTxEdn7hAS6FBgHykaeGlv/y7kGxbtesvBXCfB1wZlq8L6S4
         hvDSzC/MDzNTPS4pv5GnfvDtYGeouzQssXVcBfZnXwwgpO6C1RJZA4xxOiV7QDtolRX4
         /e4Q==
X-Gm-Message-State: ANoB5pk9PGqzsMOtuiFX+mrFAztFo1tXKKBlxwrb5oz26zuFaPuWZVyQ
        06Y7lRL0YAqlzY92PO1K622UlgMKIaEJcp0lE2EC/6rdCjkr27O2+EEC5vrBQvcb/R/w/ergJGL
        MFcqML326nDbvuDQz
X-Received: by 2002:a17:906:748:b0:7ae:8d01:8202 with SMTP id z8-20020a170906074800b007ae8d018202mr5362134ejb.384.1668090753682;
        Thu, 10 Nov 2022 06:32:33 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6UEJrPsczEooz7DX8InQa+zTUE9wf/exSIc56qc+Cf6pWb/J8hT4/bzL4bKtHmF+mnPM0WRw==
X-Received: by 2002:a17:906:748:b0:7ae:8d01:8202 with SMTP id z8-20020a170906074800b007ae8d018202mr5362115ejb.384.1668090753302;
        Thu, 10 Nov 2022 06:32:33 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id j2-20020a17090623e200b007aa3822f4d2sm7396132ejg.17.2022.11.10.06.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 06:32:32 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 77CB87826D5; Thu, 10 Nov 2022 15:32:32 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [xdp-hints] Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp
 metadata into skb context
In-Reply-To: <636c533231572_13c9f42087c@john.notmuch>
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-7-sdf@google.com>
 <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev>
 <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
 <9a8fefe4-2fcb-95b7-cda0-06509feee78e@linux.dev>
 <6f57370f-7ec3-07dd-54df-04423cab6d1f@linux.dev> <87leokz8lq.fsf@toke.dk>
 <636c533231572_13c9f42087c@john.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 10 Nov 2022 15:32:32 +0100
Message-ID: <87v8nmyj5r.fsf@toke.dk>
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

John Fastabend <john.fastabend@gmail.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Snipping a bit of context to reply to this bit:
>>=20
>> >>>> Can the xdp prog still change the metadata through xdp->data_meta? =
tbh, I am not
>> >>>> sure it is solid enough by asking the xdp prog not to use the same =
random number
>> >>>> in its own metadata + not to change the metadata through xdp->data_=
meta after
>> >>>> calling bpf_xdp_metadata_export_to_skb().
>> >>>
>> >>> What do you think the usecase here might be? Or are you suggesting we
>> >>> reject further access to data_meta after
>> >>> bpf_xdp_metadata_export_to_skb somehow?
>> >>>
>> >>> If we want to let the programs override some of this
>> >>> bpf_xdp_metadata_export_to_skb() metadata, it feels like we can add
>> >>> more kfuncs instead of exposing the layout?
>> >>>
>> >>> bpf_xdp_metadata_export_to_skb(ctx);
>> >>> bpf_xdp_metadata_export_skb_hash(ctx, 1234);
>>=20
>
> Hi Toke,
>
> Trying not to bifurcate your thread. Can I start a new one here to
> elaborate on these use cases. I'm still a bit lost on any use case
> for this that makes sense to actually deploy on a network.
>
>> There are several use cases for needing to access the metadata after
>> calling bpf_xdp_metdata_export_to_skb():
>>=20
>> - Accessing the metadata after redirect (in a cpumap or devmap program,
>>   or on a veth device)
>
> I think for devmap there are still lots of opens how/where the skb
> is even built.

For veth it's pretty clear; i.e., when redirecting into containers.

> For cpumap I'm a bit unsure what the use case is. For ice, mlx and
> such you should use the hardware RSS if performance is top of mind.

Hardware RSS works fine if your hardware supports the hashing you want;
many do not. As an example, Jesper wrote this application that uses
cpumap to divide out ISP customer traffic among different CPUs (solving
an HTB scaling problem):

https://github.com/xdp-project/xdp-cpumap-tc

> And then for specific devices on cpumap (maybe realtime or ptp
> things?) could we just throw it through the xdp_frame?

Not sure what you mean here? Throw what through the xdp_frame?

>> - Transferring the packet+metadata to AF_XDP
>
> In this case we have the metadata and AF_XDP program and XDP program
> simply need to agree on metadata format. No need to have some magic
> numbers and driver specific kfuncs.

See my other reply to Martin: Yeah, for AF_XDP users that write their
own kernel XDP programs, they can just do whatever they want. But many
users just rely on the default program in libxdp, so having a standard
format to include with that is useful.

>> - Returning XDP_PASS, but accessing some of the metadata first (whether
>>   to read or change it)
>>=20
>
> I don't get this case? XDP_PASS should go to stack normally through
> drivers build_skb routines. These will populate timestamp normally.
> My guess is simply descriptor->skb load/store is cheaper than carrying
> around this metadata and doing the call in BPF side. Anyways you
> just built an entire skb and hit the stack I don't think you will
> notice this noise in any benchmark.

If you modify the packet before calling XDP_PASS you may want to update
the metadata as well (for instance the RX hash, or in the future the
metadata could also carry transport header offsets).

-Toke

