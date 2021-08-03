Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291C73DE74E
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 09:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbhHCHjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 03:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbhHCHjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 03:39:19 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A470FC06175F
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 00:39:08 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627976345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uCiXJdY6Mkt7tDKHjDv5iwt09Pk1VrfKKQN/UOqXcOE=;
        b=TD+FzImL5u7+cSbO4RDUb0eIQVZAa/dYL9IP3nXuk+9TLd+DqGifLoUR6z6jAiAHIzRVyO
        TqEYL2uic5a1i9uvcAF84ijLTUGC7CgeAZjXVLqZAfF4RqFSr/nl1MpKoAJYKO/ao985k2
        8ZXb9famDCJVMlyXFhMRkBsVrrV5nnU=
Date:   Tue, 03 Aug 2021 07:39:03 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <7eb04004be9b50c4a6877c2b0291574c@linux.dev>
Subject: Re: [PATCH net-next] ipv4: Fix refcount warning for new fib_info
To:     "Jakub Kicinski" <kuba@kernel.org>,
        "David Ahern" <dsahern@gmail.com>
Cc:     "Matthieu Baerts" <matthieu.baerts@tessares.net>,
        "David Ahern" <dsahern@kernel.org>, ciorneiioana@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net
In-Reply-To: <20210802132031.2331e6b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210802132031.2331e6b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210802160221.27263-1-dsahern@kernel.org>
 <332304e5-7ef7-d977-a777-fd513d6e7d26@tessares.net>
 <21559c43-d034-2352-efe4-b366d659da7c@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

August 3, 2021 4:20 AM, "Jakub Kicinski" <kuba@kernel.org> wrote:=0A=0A> =
On Mon, 2 Aug 2021 12:04:01 -0600 David Ahern wrote:=0A> =0A>> On 8/2/21 =
11:58 AM, Matthieu Baerts wrote:=0A>> Hi David,=0A>> =0A>> On 02/08/2021 =
18:02, David Ahern wrote:=0A>> Ioana reported a refcount warning when boo=
ting over NFS:=0A>> =0A>> [ 5.042532] ------------[ cut here ]-----------=
-=0A>> [ 5.047184] refcount_t: addition on 0; use-after-free.=0A>> [ 5.05=
2324] WARNING: CPU: 7 PID: 1 at lib/refcount.c:25 refcount_warn_saturate+=
0xa4/0x150=0A>> ...=0A>> [ 5.167201] Call trace:=0A>> [ 5.169635] refcoun=
t_warn_saturate+0xa4/0x150=0A>> [ 5.174067] fib_create_info+0xc00/0xc90=
=0A>> [ 5.177982] fib_table_insert+0x8c/0x620=0A>> [ 5.181893] fib_magic.=
isra.0+0x110/0x11c=0A>> [ 5.185891] fib_add_ifaddr+0xb8/0x190=0A>> [ 5.18=
9629] fib_inetaddr_event+0x8c/0x140=0A>> =0A>> fib_treeref needs to be se=
t after kzalloc. The old code had a ++ which=0A>> led to the confusion wh=
en the int was replaced by a refcount_t.=0A>> =0A>> Thank you for the pat=
ch!=0A>> =0A>> My CI was also complaining of not being able to run kernel=
 selftests [1].=0A>> Your patch fixes the issue, thanks!=0A>> =0A>> Teste=
d-by: Matthieu Baerts <matthieu.baerts@tessares.net>=0A>> =0A>> Given how=
 easily it is to trigger the warning, I get the impression the=0A>> origi=
nal was an untested patch.=0A> =0A> Yeah :( In hindsight any refcount pat=
ch which doesn't contain a=0A> refcount_set() is suspicious. Thanks for t=
he quick fix, applied!=0A=0ASorry for that, there is another patch needed=
 to apply for the same reason. I just submitted it.
