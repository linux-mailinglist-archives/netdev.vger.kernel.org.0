Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03216559ED5
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 18:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbiFXQwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 12:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbiFXQwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 12:52:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75B4854F92
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 09:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656089554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eSmWhKN85hUOXMw10fIfO59X+ZLEvkJKbQQ70Wkx0zE=;
        b=QUZ0sF5hqvduj/ITgMNdc1hbw1fq5v0GrUQED6QupcZSkbuZIlruYQR+f9b4Ymqogpg+kq
        oSHA/PvZUwNzYJE2GZ4+9ifrToeP/2R8fr8mp6ZUW0Xi7RhiVV2MyM6hJo1Evll4llKGUP
        B87s48/jfuI/FwcPrYCf7eBNujNYtpQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-pAFhTVSxMUaoLJmsWNHhAg-1; Fri, 24 Jun 2022 12:52:33 -0400
X-MC-Unique: pAFhTVSxMUaoLJmsWNHhAg-1
Received: by mail-ed1-f70.google.com with SMTP id q18-20020a056402519200b004358ce90d97so2246138edd.4
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 09:52:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=eSmWhKN85hUOXMw10fIfO59X+ZLEvkJKbQQ70Wkx0zE=;
        b=heZZHiHnhnMkZaRNeuksP4Axhmw56ZahgazsVz6c8X+VrW0uoHjNmbi2uPfLfr6A9X
         GYUBlhncrSoOsldXWm7uzKBuV2eecfL3kQxUaAqAsYaF7WXbZRJOuXTkb4iic9oBJujb
         Q2bYkaQvrM+NiHt7oWGSFmZiDN3yfMJgINHIJFWIAjNPk7uv3U+yKu5hrq4QQeZRYjYU
         41Pu+KCODHd/QP++i1B3vI+IC6ZAw+8onJxVE/4qaWxWKX0mIarfVmUt6x1mnC8D9ZgY
         EhxXcebL32jg5MJKSZdaTRCk31Ro/6zclTvjSbGbn3HzY+uXyWiDipD1ZVCyyIikIqSq
         lLLg==
X-Gm-Message-State: AJIora+iiqtz+mk0MtQFXLw3ow20LtBJ5wchv3a8peEh6i+jZpnBsmzW
        qc7OC05thTyjk4/MxmGmxiUR4Bo4pn8ieHm4u0I1H8BcZmqxY6d3G9NhOefQ+DXqSWTqpoVTJ7t
        tFOA8Tm42/UTbbj0Z
X-Received: by 2002:a05:6402:5214:b0:437:5b1d:9966 with SMTP id s20-20020a056402521400b004375b1d9966mr30010edd.16.1656089549951;
        Fri, 24 Jun 2022 09:52:29 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uOBHJdfQR5BLBiriiW2ZbBGVmwEZgWZ1VaNrz82Pws9+EZPjMG7HYXm3Scorx5aPkpYhFvUQ==
X-Received: by 2002:a05:6402:5214:b0:437:5b1d:9966 with SMTP id s20-20020a056402521400b004375b1d9966mr29805edd.16.1656089547905;
        Fri, 24 Jun 2022 09:52:27 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g3-20020a1709061c8300b0070759e37183sm1400333ejh.59.2022.06.24.09.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 09:52:26 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 34C04476723; Fri, 24 Jun 2022 18:52:26 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [RFC Patch v5 0/5] net_sched: introduce eBPF based Qdisc
In-Reply-To: <20220602041028.95124-1-xiyou.wangcong@gmail.com>
References: <20220602041028.95124-1-xiyou.wangcong@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Jun 2022 18:52:26 +0200
Message-ID: <87h74aovg5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> writes:

> From: Cong Wang <cong.wang@bytedance.com>
>
> This *incomplete* patchset introduces a programmable Qdisc with eBPF.

Sorry for the delay in looking at this; a few comments below:

[...]

> The goal here is to make this Qdisc as programmable as possible,
> that is, to replace as many existing Qdisc's as we can, no matter
> in tree or out of tree. This is why I give up on PIFO which has
> serious limitations on the programmablity.

Could you elaborate on the limitations of the PIFO? It looks to me like
the SKB map you're proposing is very close to a PIFO (it's a priority
queue that SKBs can be inserted into at an arbitrary position)?

> Here is a summary of design decisions I made:
>
> 1. Avoid eBPF struct_ops, as it would be really hard to program
>    a Qdisc with this approach, literally all the struct Qdisc_ops
>    and struct Qdisc_class_ops are needed to implement. This is almost
>    as hard as programming a Qdisc kernel module.

I agree that implementing the full Qdisc_class_ops as BPF functions is
going to be prohibitive; let's use this opportunity to define a simpler
API!

> 2. Introduce skb map, which will allow other eBPF programs to store skb's
>    too.
>
>    a) As eBPF maps are not directly visible to the kernel, we have to
>    dump the stats via eBPF map API's instead of netlink.

Why not do a hybrid thing where the kernel side of the qdisc keeps some
basic stats (packet counter for number of packets queued/dropped for
instance) and define a separate BPF callback that can return more stats
to the kernel for translation into netlink (e.g., "how many packets are
currently in the queue")? And then if a particular implementation wants
to do more custom stats, they can use BPF APIs for that?

>    b) The user-space is not allowed to read the entire packets, only
>    __sk_buff itself is readable, because we don't have such a use case
>    yet and it would require a different API to read the data, as map
>    values have fixed length.

I agree there's not any need to make the packet contents directly
accessible to userspace via reading the map.

>    c) Two eBPF helpers are introduced for skb map operations:
>    bpf_skb_map_push() and bpf_skb_map_pop(). Normal map update is
>    not allowed.

So with kptr support in the map this could conceivably be done via the
existing map_push() etc helpers?

>    d) Multi-queue support is implemented via map-in-map, in a similar
>    push/pop fasion.

Not sure I understand what you mean by this? Will the qdisc
automatically attach itself to all HWQs of an interface (like sch_mq
does)? Surely it will be up to the BPF program whether it'll use
map-in-map or something else?

>    e) Use the netdevice notifier to reset the packets inside skb map upon
>    NETDEV_DOWN event.

Is it really necessary to pull out SKBs from under the BPF program? If
the qdisc is removed and the BPF program goes away, so will the map and
all SKBs stored in it?

> 3. Integrate with existing TC infra. For example, if the user doesn't want
>    to implement her own filters (e.g. a flow dissector), she should be able
>    to re-use the existing TC filters. Another helper bpf_skb_tc_classify() is
>    introduced for this purpose.

This seems a bit convoluted? If a BPF program wants to reuse an existing
BPF TC filter it can just do that at the code level. As for the
in-kernel filters are there really any of them it would be worth reusing
from a BPF qdisc other than the flow dissector? In which case, why not
just expose that instead of taking all the TC filter infrastructure with
you?


Bringing in some text from patch 4 as well to comment on it all in one go:

> Introduce a new Qdisc which is completely managed by eBPF program
> of type BPF_PROG_TYPE_SCHED_QDISC. It accepts two eBPF programs of the
> same type, but one for enqueue and the other for dequeue.
> 
> And it interacts with Qdisc layer in two ways:
> 1) It relies on Qdisc watchdog to handle throttling;

Having a way for BPF to schedule the qdisc watchdog wakeup is probably
needed. For the XDP queueing side I'm planning to use BPF timers for
(the equivalent of) this, but since we already have a watchdog mechanism
on the qdisc side maybe just exposing that is fine...

> 2) It could pass the skb enqueue/dequeue down to child classes

I'm not sure I think it's a good idea to keep the qdisc hierarchy. If
someone wants to build a classification hierarchy they could just do
this directly in BPF by whichever mechanism they want? I.e., it can just
instantiate multiple skb maps in a single program to do classful
queueing and select the right one however it wants?

Keeping the qdisc itself simple as, basically:

enqueue: pass skb to BPF program to do with as it will (enqueue into a
map, drop, etc)

dequeue: execute BPF program, transmit pkt if it returns one

-Toke

