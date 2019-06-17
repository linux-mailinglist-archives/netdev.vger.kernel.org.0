Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B7348B38
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfFQSCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:02:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbfFQSCw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 14:02:52 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CC29781DFE;
        Mon, 17 Jun 2019 18:02:46 +0000 (UTC)
Received: from oldenburg2.str.redhat.com (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D96978401;
        Mon, 17 Jun 2019 18:02:41 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Joseph Myers <joseph@codesourcery.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux API <linux-api@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Paul Burton <pburton@wavecomp.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
References: <20190319165123.3967889-1-arnd@arndb.de>
        <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
        <87tvd2j9ye.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wio1e4=WUUwmo-Ph55BEgH_X3oXzBpvPyLQg2TxzfGYuw@mail.gmail.com>
        <871s05fd8o.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wg4ijSoPq-w7ct_VuZvgHx+tUv_QX-We-62dEwK+AOf2w@mail.gmail.com>
        <87sgs8igfj.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wjCwnk0nfgCcMYqqX6o9bBrutDtut_fzZ-2VwiZR1y4kw@mail.gmail.com>
Date:   Mon, 17 Jun 2019 20:02:39 +0200
In-Reply-To: <CAHk-=wjCwnk0nfgCcMYqqX6o9bBrutDtut_fzZ-2VwiZR1y4kw@mail.gmail.com>
        (Linus Torvalds's message of "Mon, 17 Jun 2019 10:49:44 -0700")
Message-ID: <87k1dkdr9c.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 17 Jun 2019 18:02:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Linus Torvalds:

>> A different approach would rename <asm/posix_types.h> to something more
>> basic, exclude the two structs, and move all internal #includes which do
>> need the structs to the new header.
>
> In fact, I wouldn't even rename <posix_types.h> at all, I'd just make
> sure it's namespace-clean.
>
> I _think_ the only thing causing problems is  '__kernel_fsid_t' due to
> that "val[]" thing, so just remove ity entirely, and add it to
> <statfs.h> instead.

There's also __kernel_fd_set in <linux/posix_types.h>.  I may have
lumped this up with <asm/posix_types.h>, but it has the same problem.

If it's okay to move them both to more natural places (maybe
<asm/statfs.h> and <linux/socket.h>), I think that should work well for
glibc.

However, application code may have to include additional header files.
I think the GCC/LLVM sanitizers currently get __kernel_fd_set from
<linux/posix_types.h> (but I think we discussed it before, they really
shouldn't use this type because it's misleading).

Thanks,
Florian
