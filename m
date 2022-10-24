Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1825A60BB9B
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 23:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbiJXVG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 17:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbiJXVGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 17:06:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135CA157881
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 12:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666638678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k6Iv37BZjDnrVPt/sYH1BuQaiP4r9Kpi3Yk+J1KoazQ=;
        b=Dpal2y06JGOt4zoNT2EPLTDzQSwXI3CMqdXVcq620NLdtSH34F/GdwKcOraAdEQMQ7VL1X
        FCpjvhSkVcW9o0A7aY9EGvfJ1hjXIsrqTemCeglx4+INAeTZy111FMw+h6Yu7nujEXxZgs
        uf/YLKbKbKM/ZILqhGDst453xRKJHHs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-189-hL6RzGvjPFG0s3jPmqzksA-1; Mon, 24 Oct 2022 09:34:22 -0400
X-MC-Unique: hL6RzGvjPFG0s3jPmqzksA-1
Received: by mail-ed1-f71.google.com with SMTP id h9-20020a05640250c900b00461d8ee12e2so2296789edb.23
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 06:34:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k6Iv37BZjDnrVPt/sYH1BuQaiP4r9Kpi3Yk+J1KoazQ=;
        b=w1GOG/MN3IEV0C/yJDw5HtgIFZZqGU9jFcjdR5S4PisNVnkYHacv6AzbSx9iTNqnIc
         iq4QJEMmS7w8GhDW4T43+1bd3DhRFV1AMyqH0lMq3ysAZ1eQSkuz7N1BD/oSwrPqE2R2
         3FJI2gV4f2G3tA6d9AYFGsSAkIBcXPLnNB3t47zuy9MURkYskHMezmWQFvace3BKyZiy
         LDNYRllqfKsxkO2RDOY7N21YDelzOa5WZNdqXzxlgzGWfqtSGql7j+jxd87j1BEyebi4
         MO/mIZp2E8tUEWwVJnnflAPeNHODCPk8g2VlyczmfUQlrEa8HKG0lDtlI6Pb2MNkCZy1
         il5w==
X-Gm-Message-State: ACrzQf01tz4/KsWH7xlz82uBEL8JvGHpYZFog94tNo+Kzf28sOv4gJv9
        Jl2Pf4lZ1/4W9m9+gWLeA264InNdNIarYI1YOmKRHBZ0U6+P0h4P4eOggjBqQgaZ6BoQXz8xkV9
        PlhQDd3WDWP5AERI+
X-Received: by 2002:aa7:d9d1:0:b0:461:9556:23e6 with SMTP id v17-20020aa7d9d1000000b00461955623e6mr9235876eds.25.1666618460074;
        Mon, 24 Oct 2022 06:34:20 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4BZfX0af6m4s1RExBrCHhefRyGGEPIDd39wtzhBuN8NwJWS1mUOwnynUQjHUo9Gnz8Tx8WjA==
X-Received: by 2002:aa7:d9d1:0:b0:461:9556:23e6 with SMTP id v17-20020aa7d9d1000000b00461955623e6mr9235781eds.25.1666618458874;
        Mon, 24 Oct 2022 06:34:18 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k15-20020a17090632cf00b0078d38cda2b1sm15434285ejk.202.2022.10.24.06.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 06:34:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F1FCF6EEAFE; Mon, 24 Oct 2022 15:34:17 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Heng Qi <hengqi@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] veth: Avoid drop packets when xdp_redirect performs
In-Reply-To: <089cff2e-b113-0603-d751-9ca0ad998553@linux.alibaba.com>
References: <1664267413-75518-1-git-send-email-hengqi@linux.alibaba.com>
 <87wn9proty.fsf@toke.dk>
 <f760701a-fb9d-11e5-f555-ebcf773922c3@linux.alibaba.com>
 <87v8p7r1f2.fsf@toke.dk>
 <189b8159-c05f-1730-93f3-365999755f72@linux.alibaba.com>
 <567d3635f6e7969c4e1a0e4bc759556c472d1dff.camel@redhat.com>
 <c1831b89-c896-80c3-7258-01bcf2defcbc@linux.alibaba.com>
 <87o7uymlh5.fsf@toke.dk>
 <c128d468-0c87-8759-e7de-b482abf8aab6@linux.alibaba.com>
 <87bkq6v4hn.fsf@toke.dk>
 <3a9b641a-f84d-92e0-a416-43bbde26f866@linux.alibaba.com>
 <089cff2e-b113-0603-d751-9ca0ad998553@linux.alibaba.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 24 Oct 2022 15:34:17 +0200
Message-ID: <87r0yxgxba.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heng Qi <hengqi@linux.alibaba.com> writes:

> =E5=9C=A8 2022/10/21 =E4=B8=8B=E5=8D=882:31, Heng Qi =E5=86=99=E9=81=93:
>>
>>
>> =E5=9C=A8 2022/10/21 =E4=B8=8A=E5=8D=8812:34, Toke H=C3=B8iland-J=C3=B8r=
gensen =E5=86=99=E9=81=93:
>>> Heng Qi <hengqi@linux.alibaba.com> writes:
>>>
>>>> maybe we should consider a simpler method: when loading xdp in veth,
>>>> we can automatically enable the napi ring of peer veth, which seems to
>>>> have no performance impact and functional impact on the veth pair, and
>>>> no longer requires users to do more things for peer veth (after all,
>>>> they may be unaware of more requirements for peer veth). Do you think
>>>> this is feasible?
>>> It could be, perhaps? One issue is what to do once the XDP program is
>>> then unloaded? We should probably disable NAPI on the peer in this case,
>>> but then we'd need to track whether it was enabled by loading an XDP
>>> program; we don't want to disable GRO/NAPI if the user requested it
>>> explicitly. This kind of state tracking gets icky fast, so I guess it'll
>>> depend on the patch...
>>
>> Regarding tracking whether we disable the napi of peer veth when=20
>> unloading
>> the veth's xdp program, this can actually be handled cleanly.
>>
>> We need to note that when peer veth enable GRO, the peer veth device will
>> update the `dev->wanted_features` with NETIF_F_GRO of peer veth (refer to
>> __netdev_update_features() and veth_set_features() ).
>>
>> When veth loads the xdp program and the napi of peer veth is not ready
>> (that is, peer veth does not load the xdp program or has no enable gro),
>> at this time, we can choose `ethtool -K veth0 gro on` to enable the=20
>> napi of
>> peer veth, this command also makes the peer veth device update their
>> wanted_features, or choose we automatically enable napi for peer veth.
>>
>> If we want to unload the xdp program for veth, peer veth cannot directly
>> disable its napi, because we need to judge whether peer veth is=20
>> gro_requested
>> ( ref to veth_gro_requested() ) or has its priv->_xdp_prog, if so, just
>> clean veth's xdp environment and disable the napi of veth instead of
>> directly disable the napi of peer veth, because of the existence of the
>> gro_requested and the xdp program loading on peer veth.
>>
>> But, if peer veth does not have gro_requested or xdp_program loading=20
>> on itself,
>> then we can directly disable the napi of peer veth.
>
> Hi, Toke. Do you think the above solution is effective for the problem=20
> of veth
> xdp_rediect dropping packets? Or is there more to add? If the above solut=
ion
> seems to be no problem for the time being, I'm ready to start with this i=
dea
> and try to make the corresponding patch.

I think it might? Please write a patch and we can have a look :)

-Toke

