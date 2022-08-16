Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E72C595A18
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbiHPL23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbiHPL2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:28:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADAA2CDF7;
        Tue, 16 Aug 2022 03:43:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03D99B8165D;
        Tue, 16 Aug 2022 10:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EA3C433C1;
        Tue, 16 Aug 2022 10:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646614;
        bh=yqe/EMQmD3VLnGHghypui0+k7E1d1JAMjbBdNpJp/Ac=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=WmDtk6Cf5S1czeeVK0DAKEntmyWn/ucxbgRUOJ7EvCnJ+hlnMmXKs7d2LzLusOWjG
         P9BZUnyFCygTSaBGyI+/ZMRsimDcw4lKZrmIl00p7YDKYDDZRS07+VkGYYjkDQNVZE
         /NHOq/5udUF8/K0YgcGNQGgSV+Ea36YQkWf7qRPhQgneFDWP9m6nB5Vly8RrTfkWTj
         Gx54EcrUu0WWbaHKs8uubbJDflr8MXwUMFtLvri3hNPrkYfanr9K/Ae48SXOeGfelg
         0y7pVw8dF2stIh5VXYLv1fnS+4FQo+ZvQ2DKZC+sGfyc7TYLSt7uY6amkS3OtqU5wE
         xT3sWq5r6idFg==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0ED1D55F5FC; Tue, 16 Aug 2022 12:43:32 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Florian Westphal <fw@strlen.de>
Cc:     Daniel Xu <dxu@dxuuu.xyz>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/3] bpf: Add support for writing to nf_conn:mark
In-Reply-To: <CAADnVQLB1SQoYAYEzU_VuJ=q3azeyhBiK-NkU5OZC7rrumi0xQ@mail.gmail.com>
References: <CAADnVQLB1SQoYAYEzU_VuJ=q3azeyhBiK-NkU5OZC7rrumi0xQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 16 Aug 2022 12:43:32 +0200
Message-ID: <87v8qswjsb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Mon, Aug 15, 2022 at 3:40 PM Florian Westphal <fw@strlen.de> wrote:
>>
>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@kernel.org> wrote:
>> > > Support direct writes to nf_conn:mark from TC and XDP prog types. Th=
is
>> > > is useful when applications want to store per-connection metadata. T=
his
>> > > is also particularly useful for applications that run both bpf and
>> > > iptables/nftables because the latter can trivially access this metad=
ata.
>> > >
>> > > One example use case would be if a bpf prog is responsible for advan=
ced
>> > > packet classification and iptables/nftables is later used for routing
>> > > due to pre-existing/legacy code.
>> > >
>> > > Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
>> >
>> > Didn't we agree the last time around that all field access should be
>> > using helper kfuncs instead of allowing direct writes to struct nf_con=
n?
>>
>> I don't see why ct->mark needs special handling.
>>
>> It might be possible we need to change accesses on nf/tc side to use
>> READ/WRITE_ONCE though.
>
> +1
> I don't think we need to have a hard rule.
> If fields is safe to access directly than it's faster
> to let bpf prog read/write it.
> There are no backward compat concerns. If conntrack side decides
> to make that field special we can disallow direct writes in
> the same kernel version.

Right, I was under the impression we wanted all fields to be wrapper by
helpers so that the struct owner could change their semantics without
affecting users (and solve the performance issue by figuring out a
generic way to inline those helpers). I guess there could also be an API
consistency argument for doing this.

However, I don't have a strong opinion on this, so if y'all prefer
keeping these as direct field writes, that's OK with me.

> These accesses, just like kfuncs, are unstable.

Well, it will be interesting to see how that plays out the first time
an application relying on one of these breaks on a kernel upgrade :)

-Toke
