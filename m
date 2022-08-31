Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A86F5A7F14
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbiHaNlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiHaNlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:41:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF50C9900;
        Wed, 31 Aug 2022 06:41:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B118461ADD;
        Wed, 31 Aug 2022 13:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC13BC433D6;
        Wed, 31 Aug 2022 13:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661953308;
        bh=2OVyDIwCVzLaucnnxSgE4rX/OnsOuYwLpXKOxA+L+rQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=gZqlUTbmKCA8DkRggchoaE/FO4dh12DSdcWEVGuo/4Iaw++a9gIA9ATF0lowcCoYg
         5L3M3m2Ue7MrIlvii3GP7jTDoEgO3Li/J2WvLXJKYrzLRkZ7hwmq33Vla44Ax9u1kQ
         TgUslEcIIerJzUVOnnG9isEX4e13Zgq14u64radPJ3qF4mvIeB+6ftD9//Ku/jHBrC
         MwLk0k8Xar9+X9Qj59Facjol2TfJBWeXpiUc0Pe8lvcsDOod/4njyA6E17soFvQBuS
         sDVJcWbyf746AsTJ0wdDEnmJrGyKX4Z/dyN/PCCD7xRxxeijo72o75uXnk/8NyYYGf
         AVhCzLykuUvpA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 23262588B0A; Wed, 31 Aug 2022 15:41:45 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
In-Reply-To: <20220831125608.GA8153@breakpoint.cc>
References: <20220831101617.22329-1-fw@strlen.de> <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 31 Aug 2022 15:41:44 +0200
Message-ID: <87o7w04jjb.fsf@toke.dk>
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

Florian Westphal <fw@strlen.de> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@kernel.org> wrote:
>> > Tag and program id are dumped to userspace on 'list' to allow to see w=
hich
>> > program is in use in case the filename isn't available/present.
>>=20
>> It seems a bit odd to include the file path in the kernel as well.
>
> Its needed to be able to re-load the ruleset.

How does that work, exactly? Is this so that the userspace binary can
query the current ruleset, and feed it back to the kernel expecting it
to stay the same? Because in that case, if the pinned object goes away
in the meantime (or changes to a different program), this could lead to
some really hard to debug errors, where a reload subtly changes the
behaviour because the BPF program is not in fact the same.

Using IDs would avoid this ambiguity at least, so I think that's a
better solution. We'd have to make sure the BPF program is not released
completely until after the reload has finished, so that it doesn't
suddenly disappear.

>> But doesn't NFT already have a per-rule comment feature,
>> so why add another specifically for BPF?
>
> You can attach up to 256 bytes to a rule, yes.
> Might not be enough for a longer path, and there could be multiple
> expressions in the same rule.
>
> This way was the most simple solution.

My point here was more that if it's just a label for human consumption,
the comment field should be fine, didn't realise it was needed for the
tool operation (and see above re: that).

>> Instead we could just teach the
>> userspace utility to extract metadata from the BPF program (based on the
>> ID) like bpftool does. This would include the program name, BTW, so it
>> does have a semantic identifier.
>
> Sure, I could change the grammar so it expects a tag or ID, e.g.
> 'ebpf id 42'
>
> If thats preferred, I can change this, it avoids the need for storing
> the name.

I think for echoing back, just relying on the ID is better as that is at
least guaranteed to stay constant for the lifetime of the BPF program in
the kernel. We could still support the 'pinned <path>' syntax on the
command line so that the initial load could be done from a pinned file,
just as a user interface improvement...

>> > cbpf bytecode isn't supported.
>> > add rule ... ebpf pinned "/sys/fs/bpf/myprog"
>>=20
>> Any plan to also teach the nft binary to load a BPF program from an ELF
>> file (instead of relying on pinning)?
>
> I used pinning because that is what '-m bpf' uses.

I'm not against supporting pinning, per se (except for the issues noted
above), but we could do multiple things, including supporting loading
the program from an object file. This is similar to how TC operates, for
instance...

-Toke
