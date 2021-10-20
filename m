Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D568435578
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 23:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhJTVtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 17:49:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58049 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229977AbhJTVtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 17:49:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634766421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cNmNbFiusSQEhvTQhL3QXrQHS2adP+qMkCylFAPSqDE=;
        b=CyLZKg22vzRLsFtJQPyf9n6zlVCH0X4X4k3QFkvxeWqABihM0OCZWksli4QmV6wo2QZfYs
        Qc1xs1dJi4SwAeJ0ev7YIRyOzIsIE3yWLTxZpxNYEjBKgRUnfxlsiip7WZYsjDNkVpctME
        +/ZVBQNJUNXAOMtLpmJ4yDDm5AdqHbs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-BfOH2vpQNHKGDM9GflD-Tw-1; Wed, 20 Oct 2021 17:47:00 -0400
X-MC-Unique: BfOH2vpQNHKGDM9GflD-Tw-1
Received: by mail-ed1-f69.google.com with SMTP id g28-20020a50d0dc000000b003dae69dfe3aso22290987edf.7
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 14:47:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=cNmNbFiusSQEhvTQhL3QXrQHS2adP+qMkCylFAPSqDE=;
        b=Hlc2zhAQMf4uvfirnUsQhUQwzUAJXssRplUNaohJNNlA5g5j8nX9zDkIsoIpph3V6f
         V1jr3E/vvqVtoSkEQrQ4u+IX7C4Li970wv2PYyXVYLWyFlJcTTxV0IQF1k+uVVDS/mFm
         qhz3aA1f3Mvro2JNQSOX2qc9Vnk8BGnl6vLBU9AIEALXycdGOctZKenYUhSmdr6iFMPb
         t34f0+xl5x0ZyPgcl+jAP30TrJwtUptQ/eL4fV7oNzT8YPrI5dNoT0yhO/paj+KEaffC
         k5IxgeXks+ZWrHDN/2GwWfcX1OLYfSoGI+NiDAQ9bZ7novMsjAUfqBWor00P/Gm2E0Ct
         NdYQ==
X-Gm-Message-State: AOAM531Azi64i9RwEu2wlk3dcJ2g33XKEw8v9E7+utKhlAP04mc4nxry
        SjFdF9s0T8F5pCXCT0ggwkxSm3y+Up8UES2xBXeSBKiA4tU7e1N4N3PPkE7Kb8JrxWkzvVyXmgn
        kCigsLR8Pam9DhtvJ
X-Received: by 2002:a17:906:3944:: with SMTP id g4mr2425612eje.426.1634766418545;
        Wed, 20 Oct 2021 14:46:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzloBJ0ABfZKxvJ5oddxXMS5yn5sGhM6dX9QUIQs8sZ8439h25LVLfEzWQ/MhRWWuU9jIQPcQ==
X-Received: by 2002:a17:906:3944:: with SMTP id g4mr2425476eje.426.1634766416761;
        Wed, 20 Oct 2021 14:46:56 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id nd36sm1620589ejc.17.2021.10.20.14.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:46:56 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E4A10180262; Wed, 20 Oct 2021 23:46:54 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH net-next v2] fq_codel: generalise ce_threshold marking
 for subset of traffic
In-Reply-To: <190a2292-8903-b4e9-954e-d07f5dbd8693@gmail.com>
References: <20211019174709.69081-1-toke@redhat.com>
 <9cec30c9-ede1-82aa-9eca-ca76bcb206d5@gmail.com> <87ilxre6rz.fsf@toke.dk>
 <190a2292-8903-b4e9-954e-d07f5dbd8693@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 20 Oct 2021 23:46:54 +0200
Message-ID: <87fssve5dd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> On 10/20/21 2:16 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Eric Dumazet <eric.dumazet@gmail.com> writes:
>>=20
>>> On 10/19/21 10:47 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> The commit in the Fixes tag expanded the ce_threshold feature of FQ-Co=
Del
>>>> so it can be applied to a subset of the traffic, using the ECT(1) bit =
of
>>>> the ECN field as the classifier. However, hard-coding ECT(1) as the on=
ly
>>>> classifier for this feature seems limiting, so let's expand it to be m=
ore
>>>> general.
>>>>
>>>> To this end, change the parameter from a ce_threshold_ect1 boolean, to=
 a
>>>> one-byte selector/mask pair (ce_threshold_{selector,mask}) which is ap=
plied
>>>> to the whole diffserv/ECN field in the IP header. This makes it possib=
le to
>>>> classify packets by any value in either the ECN field or the diffserv
>>>> field. In particular, setting a selector of INET_ECN_ECT_1 and a mask =
of
>>>> INET_ECN_MASK corresponds to the functionality before this patch, and a
>>>> mask of ~INET_ECN_MASK allows using the selector as a straight-forward
>>>> match against a diffserv code point:
>>>>
>>>>  # apply ce_threshold to ECT(1) traffic
>>>>  tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold=
_selector 0x1/0x3
>>>>
>>>>  # apply ce_threshold to ECN-capable traffic marked as diffserv AF22
>>>>  tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold=
_selector 0x50/0xfc
>>>>
>>>> Regardless of the selector chosen, the normal rules for ECN-marking of
>>>> packets still apply, i.e., the flow must still declare itself ECN-capa=
ble
>>>> by setting one of the bits in the ECN field to get marked at all.
>>>>
>>>> v2:
>>>> - Add tc usage examples to patch description
>>>>
>>>> Fixes: e72aeb9ee0e3 ("fq_codel: implement L4S style ce_threshold_ect1 =
marking")
>>>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>>> ---
>>>
>>> Reviewed-by: Eric Dumazet <edumazet@google.com>
>>=20
>> Thanks!
>>=20
>>> BTW, the Fixes: tag seems not really needed, your patch is a
>>> followup/generalization.
>>=20
>> Yeah, I included it because I don't know of any other way to express
>> "this is a follow-up commit to this other one, and the two should be
>> kept together" - for e.g., backports. And I figured that since this
>> changes the UAPI from your initial patch, this was important to express
>> in case someone does backport that.
>
> The patch targeted net-next, and was not stable material.
>
> Also, this is pure opt-in behavior, so there was no risk
> of breaking something.
>
> Note that I have not provided yet an iproute2 patch, so only your
> iproute2 change will possibly enable the new behavior.
>
>>=20
>> Is there another way to express this that I'm not aware of?
>
> Just mentioning the commit directly in the changelog is what I
> do for followups.

Right, I'll do that next time. Thanks :)

-Toke

