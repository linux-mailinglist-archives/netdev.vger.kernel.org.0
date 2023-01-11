Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6E26666F5
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 00:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbjAKXH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 18:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235566AbjAKXHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 18:07:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C211632255
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 15:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673478425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XVDx2/WWIzcI9cRYlOIbEA8yT9L5duaZXrF59o7gokY=;
        b=RC6gKpZhHUKNTJG8IAukUziRmENQuoeh5OlFbxPVrxbxK/CG4RfPzGrDAzCjAqn1zNUxU4
        H4OsfPAvSO6H0shzrdGI+JtDODriY1ZVbx/g9kpw+3VKwTMxK5cmTavBKQ/l63Qk1wvVKl
        C3n181lh40ZYAaxpnyIn09ResGZYZuU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-86-_3xueOjNOOqpmoz1901LKw-1; Wed, 11 Jan 2023 18:07:04 -0500
X-MC-Unique: _3xueOjNOOqpmoz1901LKw-1
Received: by mail-ej1-f70.google.com with SMTP id hs18-20020a1709073e9200b007c0f9ac75f9so11110553ejc.9
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 15:07:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XVDx2/WWIzcI9cRYlOIbEA8yT9L5duaZXrF59o7gokY=;
        b=hVterHWkk5Mf6JCTwTgtYFis8DmsBpE59dvLB/x9zQ5VMXLRGNhbBIp58RAAma7brF
         oQaeuO9oS2VOvm6ynf1JE5On/L0e81wZgmcHekxIaZO3O9v7YBI7rgRG8l/U9oj5ciBP
         ziOj4VhmcxU1RPN0H1q1xcyo6eJ/854RLcsDlukPX37qvm5wF4RVGPAhhEQ21eV1T8xr
         E7l4FZHGhkriXv2ppX4VvrErorn9YLit82Ax6FwwhZSZsKhby1v5DFfKDWyuanCATwHQ
         ekVqMzPx0UNAhQpXi2n7XHtdXycAOQ6cEbr9009cs3Qvlngr/rJz92zhn7bzV3dieocI
         qDCg==
X-Gm-Message-State: AFqh2kqLaAlzkXvzV4Ms5KVRab3dxLw4v1C/+RMs+O+QrNb+L0G4TpMO
        HE7hKs3OHrEybTyoPv18tOBe8KSzj8mHmAblNFcLfKnrMT+TFHVYWgPrhK3LG4KsIo3/MrZAj+I
        S7zJTDIIFlc4doEnZ
X-Received: by 2002:a17:906:703:b0:84d:1366:c74d with SMTP id y3-20020a170906070300b0084d1366c74dmr20388796ejb.63.1673478421464;
        Wed, 11 Jan 2023 15:07:01 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv7QPwihRELKJLjkFSjO/5FD83RBKm/qMqBXB7IUAWfQawhBfwJXrPoXWE+b0o50vAk3B6utw==
X-Received: by 2002:a17:906:703:b0:84d:1366:c74d with SMTP id y3-20020a170906070300b0084d1366c74dmr20388764ejb.63.1673478420608;
        Wed, 11 Jan 2023 15:07:00 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v10-20020a170906292a00b00782fbb7f5f7sm6749474ejd.113.2023.01.11.15.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 15:06:59 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5729290052F; Thu, 12 Jan 2023 00:06:58 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Shawn Bohrer <sbohrer@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, bjorn@kernel.org, kernel-team@cloudflare.com,
        davem@davemloft.net
Subject: Re: [PATCH] veth: Fix race with AF_XDP exposing old or
 uninitialized descriptors
In-Reply-To: <CAJ8uoz3Yqqaxmj2x+mXhS9UhSZr-UGh8-Njmk9wB9ceC4cYn1g@mail.gmail.com>
References: <Y5pO+XL54ZlzZ7Qe@sbohrer-cf-dell>
 <20221220185903.1105011-1-sbohrer@cloudflare.com>
 <e6b0414dbc7e97857fee5936ed04efca81b1d472.camel@redhat.com>
 <CAJ8uoz2ZL54EbZw+jTCQowjmC=MBzdpVzn=uQNcM7K+sCH7K5Q@mail.gmail.com>
 <877cxtgnjh.fsf@toke.dk>
 <CAJ8uoz3Yqqaxmj2x+mXhS9UhSZr-UGh8-Njmk9wB9ceC4cYn1g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 12 Jan 2023 00:06:58 +0100
Message-ID: <871qo0hdrh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson <magnus.karlsson@gmail.com> writes:

> On Wed, Jan 11, 2023 at 3:21 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Magnus Karlsson <magnus.karlsson@gmail.com> writes:
>>
>> > On Thu, Dec 22, 2022 at 11:18 AM Paolo Abeni <pabeni@redhat.com> wrote:
>> >>
>> >> On Tue, 2022-12-20 at 12:59 -0600, Shawn Bohrer wrote:
>> >> > When AF_XDP is used on on a veth interface the RX ring is updated i=
n two
>> >> > steps.  veth_xdp_rcv() removes packet descriptors from the FILL ring
>> >> > fills them and places them in the RX ring updating the cached_prod
>> >> > pointer.  Later xdp_do_flush() syncs the RX ring prod pointer with =
the
>> >> > cached_prod pointer allowing user-space to see the recently filled =
in
>> >> > descriptors.  The rings are intended to be SPSC, however the existi=
ng
>> >> > order in veth_poll allows the xdp_do_flush() to run concurrently wi=
th
>> >> > another CPU creating a race condition that allows user-space to see=
 old
>> >> > or uninitialized descriptors in the RX ring.  This bug has been obs=
erved
>> >> > in production systems.
>> >> >
>> >> > To summarize, we are expecting this ordering:
>> >> >
>> >> > CPU 0 __xsk_rcv_zc()
>> >> > CPU 0 __xsk_map_flush()
>> >> > CPU 2 __xsk_rcv_zc()
>> >> > CPU 2 __xsk_map_flush()
>> >> >
>> >> > But we are seeing this order:
>> >> >
>> >> > CPU 0 __xsk_rcv_zc()
>> >> > CPU 2 __xsk_rcv_zc()
>> >> > CPU 0 __xsk_map_flush()
>> >> > CPU 2 __xsk_map_flush()
>> >> >
>> >> > This occurs because we rely on NAPI to ensure that only one napi_po=
ll
>> >> > handler is running at a time for the given veth receive queue.
>> >> > napi_schedule_prep() will prevent multiple instances from getting
>> >> > scheduled. However calling napi_complete_done() signals that this
>> >> > napi_poll is complete and allows subsequent calls to
>> >> > napi_schedule_prep() and __napi_schedule() to succeed in scheduling=
 a
>> >> > concurrent napi_poll before the xdp_do_flush() has been called.  Fo=
r the
>> >> > veth driver a concurrent call to napi_schedule_prep() and
>> >> > __napi_schedule() can occur on a different CPU because the veth xmit
>> >> > path can additionally schedule a napi_poll creating the race.
>> >>
>> >> The above looks like a generic problem that other drivers could hit.
>> >> Perhaps it could be worthy updating the xdp_do_flush() doc text to
>> >> explicitly mention it must be called before napi_complete_done().
>> >
>> > Good observation. I took a quick peek at this and it seems there are
>> > at least 5 more drivers that can call napi_complete_done() before
>> > xdp_do_flush():
>> >
>> > drivers/net/ethernet/qlogic/qede/
>> > drivers/net/ethernet/freescale/dpaa2
>> > drivers/net/ethernet/freescale/dpaa
>> > drivers/net/ethernet/microchip/lan966x
>> > drivers/net/virtio_net.c
>> >
>> > The question is then if this race can occur on these five drivers.
>> > Dpaa2 has AF_XDP zero-copy support implemented, so it can suffer from
>> > this race as the Tx zero-copy path is basically just a napi_schedule()
>> > and it can be called/invoked from multiple processes at the same time.
>> > In regards to the others, I do not know.
>> >
>> > Would it be prudent to just switch the order of xdp_do_flush() and
>> > napi_complete_done() in all these drivers, or would that be too
>> > defensive?
>>
>> We rely on being inside a single NAPI instance trough to the
>> xdp_do_flush() call for RCU protection of all in-kernel data structures
>> as well[0]. Not sure if this leads to actual real-world bugs for the
>> in-kernel path, but conceptually it's wrong at least. So yeah, I think
>> we should definitely swap the order everywhere and document this!
>
> OK, let me take a stab at it. For at least the first four, it will be
> compilation tested only from my side since I do not own any of those
> SoCs/cards. Will need the help of those maintainers for sure.

Sounds good, thanks! :)

-Toke

