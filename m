Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81AC2A3F28
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 09:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbgKCImp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 03:42:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38537 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725997AbgKCImp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 03:42:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604392964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hrCT/XemvFvlhZnm+062tCDMJvlkgHd9UbXAuXqPsXI=;
        b=eJ7hQyYE+3RcFvZCbV+Vhj9zaruS50SPRLKTY3K46s5IN/FsJK1Q8BB+TEJXKKPfsdIwxC
        nKsTPwoTE610FNXNGxxq1931W/SyTNs3rdYfrMtE2umBFe0dYp+ennqRjMe1D2ZzQ+C4wb
        4tzgf8EN4vs93qvN41d9YSelbQYIMN8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-W_zeLT4DMaujKlpogxh6Ow-1; Tue, 03 Nov 2020 03:42:42 -0500
X-MC-Unique: W_zeLT4DMaujKlpogxh6Ow-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7018D800050;
        Tue,  3 Nov 2020 08:42:40 +0000 (UTC)
Received: from localhost (unknown [10.40.194.154])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E67BE60BF1;
        Tue,  3 Nov 2020 08:42:26 +0000 (UTC)
Date:   Tue, 3 Nov 2020 09:42:24 +0100
From:   Jiri Benc <jbenc@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201103094224.6de1470d@redhat.com>
In-Reply-To: <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
        <20201029151146.3810859-1-haliu@redhat.com>
        <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
        <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Nov 2020 22:58:06 -0800, Andrii Nakryiko wrote:
> But I don't think I got a real answer as to what's the exact reason
> against the submodule. Like what "inappropriate" even means in this
> case? Jesper's security argument so far was the only objective
> criteria, as far as I can tell.

It's the fundamental objection. Distributions in general have the "no
bundled libraries" policy. It is sometimes annoying but it helps to
understand that the policy is not a whim of distros, it's coming from
years of experience with package maintenance for security and stability.

> But I also see that using libbpf through submodule gives iproute2
> exact control over which version of libbpf is being used. And that
> does not depend at all on any specific Linux distribution, its
> version, LTS vs non-LTS, etc. iproute2 will just work the same across
> all of them. So matches your stated goals very directly and
> explicitly.

If you take this route, the end result would be all dependencies for
all projects being included as submodules and bundled. At the first
sight, this sounds easier for the developers. Why bother with dynamic
linking at all? Everything can be linked statically.

The result would be nightmare for both distros and users. No timely
security updates possible, critical bugs not being fixed in some
programs, etc. There is enough experience with this kind of setup to
conclude it is not the right way to go.

Yes, dynamic linking is initially more work for developers of both apps
and libraries. However, it pays off over time - there's no need to keep
track of security and other important fixes in the dependencies, it
comes for free from the distro work.

Btw, taking the bundling to the extreme, every app could bundle its own
well tested and compatible kernel version and be run in a VM. This
might sound far fetched but there were actual attempts to do that. It
didn't take off; I think part of the reason was that the Linux kernel
is very good in keeping its APIs stable.

And I'm convinced this is the way to go for libraries, too: put an
emphasis on API stability. Make it easy to get consumed and updated
under the hood. Everybody wins this way.

 Jiri

