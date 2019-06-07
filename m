Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA6639487
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731888AbfFGSnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:43:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48226 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729449AbfFGSnP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 14:43:15 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 19B81308FC4E;
        Fri,  7 Jun 2019 18:43:15 +0000 (UTC)
Received: from oldenburg2.str.redhat.com (ovpn-116-64.ams2.redhat.com [10.36.116.64])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D2AD27856D;
        Fri,  7 Jun 2019 18:43:05 +0000 (UTC)
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
Date:   Fri, 07 Jun 2019 20:43:03 +0200
In-Reply-To: <CAHk-=wio1e4=WUUwmo-Ph55BEgH_X3oXzBpvPyLQg2TxzfGYuw@mail.gmail.com>
        (Linus Torvalds's message of "Fri, 7 Jun 2019 11:27:57 -0700")
Message-ID: <871s05fd8o.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 07 Jun 2019 18:43:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Linus Torvalds:

> If we're changing kernel header files, it's easy enough to change the
> kernel users. I'd be more worried about user space that *uses* that
> thing, and currently accesses 'val[]' by name.
>
> So the patch looks a bit odd to me. How are people supposed to use
> fsid_t if they can't look at it?

The problem is that the header was previously not used pervasively in
userspace headers.  See commit a623a7a1a5670c25a16881f5078072d272d96b71
("y2038: fix socket.h header inclusion").  Very little code needed it
before.

On the glibc side, we nowadays deal with this by splitting headers
further.  (We used to suppress definitions with macros, but that tended
to become convoluted.)  In this case, moving the definition of
__kernel_long_t to its own header, so that
include/uapi/asm-generic/socket.h can include that should fix it.

> So now that I _do_ see the patch, there's no way I'll apply it.

Fair enough.

Thanks,
Florian
