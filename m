Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD87A432559
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 19:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbhJRRtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 13:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234155AbhJRRtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 13:49:52 -0400
X-Greylist: delayed 417 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Oct 2021 10:47:41 PDT
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0810EC061745;
        Mon, 18 Oct 2021 10:47:40 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1634578840; bh=FVM/cjw4IBkLaXSB40QytfJFa5MUoqqQ7l3nk9AgC3I=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=xKbLdwwt5RszbRAxplVhNJWjebgIvvIsPRXd/VOlCoLkrLCS8bySl4O14YbA73KAN
         eREHNsU5xctMI5Rl7DP3Hi9/tn0Oz3sqbm/hgMH/0cn6ODeXZTYUTrvr+jVaLqhBeW
         ydpVLaXuBaweLDwzDRFdJgOfWkYixdE1GEZDvyUDIs6HfGDAMcPtF31K/kBLhcwCx/
         6l0Ze5QxWKTK5FeU6TrLxrLqXjwslIr7rQvoI/8YnkwsmhB17Ge9GNoWFOMUgw2Xma
         VWVy+xO3JY+P64uSG+lLM98ZI6aRc5Tm6eM98wxXfNkF9Lt0SCdg2VGJcZOxjTjFVy
         LIg7R3hwQCn8g==
To:     Jakub Kicinski <kuba@kernel.org>, Vlad Buslov <vladbu@nvidia.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzbot+62e474dd92a35e3060d8@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com, joamaki@gmail.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [syzbot] BUG: corrupted list in netif_napi_add
In-Reply-To: <20211018084201.4c7e5be1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <0000000000005639cd05ce3a6d4d@google.com>
 <f821df00-b3e9-f5a8-3dcb-a235dd473355@iogearbox.net>
 <f3cc125b2865cce2ea4354b3c93f45c86193545a.camel@redhat.com>
 <ygnh5ytubfa4.fsf@nvidia.com>
 <20211018084201.4c7e5be1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Mon, 18 Oct 2021 19:40:40 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87lf2qi63r.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 18 Oct 2021 17:04:19 +0300 Vlad Buslov wrote:
>> We got a use-after-free with very similar trace [0] during nightly
>> regression. The issue happens when ip link up/down state is flipped
>> several times in loop and doesn't reproduce for me manually. The fact
>> that it didn't reproduce for me after running test ten times suggests
>> that it is either very hard to reproduce or that it is a result of some
>> interaction between several tests in our suite.
>> 
>> [0]:
>> 
>> [ 3187.779569] mlx5_core 0000:08:00.0 enp8s0f0: Link up
>>  [ 3187.890694] ==================================================================
>>  [ 3187.892518] BUG: KASAN: use-after-free in __list_add_valid+0xc3/0xf0
>>  [ 3187.894132] Read of size 8 at addr ffff8881150b3fb8 by task ip/119618
>
> Hm, not sure how similar it is. This one looks like channel was freed
> without deleting NAPI. Do you have list debug enabled?

Well, the other report[0] also kinda looks like the NAPI thread keeps
running after it should have been disabled, so maybe they are in fact
related?

-Toke

[0] https://lore.kernel.org/r/000000000000c1524005cdeacc5f@google.com
