Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632C4599C9E
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 15:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349271AbiHSNF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 09:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348922AbiHSNF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 09:05:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA0F5D0D4;
        Fri, 19 Aug 2022 06:05:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1A9761866;
        Fri, 19 Aug 2022 13:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29269C433C1;
        Fri, 19 Aug 2022 13:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660914354;
        bh=miZ6oqPG1q3ZNV0ucgXlV6pfatEjWryNvNqVONznrCA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=CCXDNBjVcl95t6o0lHxLOUfzo1yO6QdoJydJrp09z2yCzvBjISWJcQIpE2hdtiufJ
         ZwMn5mcHZZgsKc4bfkDBhK3PjjqLMV/zbXb9ndNaLrhCjZ3yhHnuHbkgYYSI8Je9Ws
         dq8Zl+IEeYb79+Q6OvEa6g/jLh1R7Ml4t+pYPWdePMuwbj21jd1bNTXW3ST90AUysc
         rE4ZBeDOZoRMV5v7kR1N1+Sivr8qbOs0ut33tdsODWsEdGQgf8fRRkwPl1ORSVNJ/t
         deGb/TJvNd1M3fCYbWY1bi29aaivz2bLudfse00eGpETuWYJhQVT7+LxO2ylWHB8Ol
         g2FI/f21zSgwg==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 118D955FC1B; Fri, 19 Aug 2022 15:05:51 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 3/4] bpf: Add support for writing to
 nf_conn:mark
In-Reply-To: <20220818221032.7b4lcpa7i4gchdvl@kashmir.localdomain>
References: <cover.1660761470.git.dxu@dxuuu.xyz>
 <edbca42217a73161903a50ba07ec63c5fa5fde00.1660761470.git.dxu@dxuuu.xyz>
 <87pmgxuy6v.fsf@toke.dk>
 <20220818221032.7b4lcpa7i4gchdvl@kashmir.localdomain>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 19 Aug 2022 15:05:51 +0200
Message-ID: <87wnb4tmc0.fsf@toke.dk>
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

Daniel Xu <dxu@dxuuu.xyz> writes:

> Hi Toke,
>
> On Thu, Aug 18, 2022 at 09:52:08PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Daniel Xu <dxu@dxuuu.xyz> writes:
>>=20
>> > Support direct writes to nf_conn:mark from TC and XDP prog types. This
>> > is useful when applications want to store per-connection metadata. This
>> > is also particularly useful for applications that run both bpf and
>> > iptables/nftables because the latter can trivially access this
>> > metadata.
>>=20
>> Looking closer at the nf_conn definition, the mark field (and possibly
>> secmark) seems to be the only field that is likely to be feasible to
>> support direct writes to, as everything else either requires special
>> handling (like status and timeout), or they are composite field that
>> will require helpers anyway to use correctly.
>>=20
>> Which means we're in the process of creating an API where users have to
>> call helpers to fill in all fields *except* this one field that happens
>> to be directly writable. That seems like a really confusing and
>> inconsistent API, so IMO it strengthens the case for just making a
>> helper for this field as well, even though it adds a bit of overhead
>> (and then solving the overhead issue in a more generic way such as by
>> supporting clever inlining).
>>=20
>> -Toke
>
> I don't particularly have a strong opinion here. But to play devil's
> advocate:
>
> * It may be confusing now, but over time I expect to see more direct
>   write support via BTF, especially b/c there is support for unstable
>   helpers now. So perhaps in the future it will seem more sensible.

Right, sure, for other structs. My point was that it doesn't look like
this particular one (nf_conn) is likely to grow any other members we can
access directly, so it'll be a weird one-off for that single field...

> * The unstable helpers do not have external documentation. Nor should
>   they in my opinion as their unstableness + stale docs may lead to
>   undesirable outcomes. So users of the unstable API already have to
>   splunk through kernel code and/or selftests to figure out how to wield
>   the APIs. All this to say there may not be an argument for
>   discoverability.

This I don't buy at all. Just because it's (supposedly) "unstable" is no
excuse to design a bad API, or make it actively user-hostile by hiding
things so users have to go browse kernel code to know how to use it. So
in any case, we should definitely document everything.

> * Direct writes are slightly more ergnomic than using a helper.

This is true, and that's the main argument for doing it this way. The
point of my previous email was that since it's only a single field,
consistency weighs heavier than ergonomics :)

-Toke
