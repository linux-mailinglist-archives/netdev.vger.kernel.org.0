Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9313D4641
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 10:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbhGXHcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 03:32:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234232AbhGXHcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 03:32:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627114370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=93hq5CZItUG7Rw8nFRa2iRJVTYVV2mYt138MAmHu6C4=;
        b=iRbd+TzSvtH/7lUksqgONe/4yMRpr4vnHn5mmJmZRCXlzinblgxzQw2BGzrnLcvkaeBMjO
        LxTMgDvoalOE5qrgFUXVl3SyMteRrH+nZb+7KVT2/2IAj6yaW0xwypxqfXA88zN2t9avUb
        0xKpFkTcR4jeF8wsAbsfvDvg7sOiW1c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-bCY0bk2oM6GxySqTQGq4jQ-1; Sat, 24 Jul 2021 04:12:48 -0400
X-MC-Unique: bCY0bk2oM6GxySqTQGq4jQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E69E801A92;
        Sat, 24 Jul 2021 08:12:47 +0000 (UTC)
Received: from Laptop-X1 (ovpn-13-95.pek2.redhat.com [10.72.13.95])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0FD6960C0F;
        Sat, 24 Jul 2021 08:12:43 +0000 (UTC)
Date:   Sat, 24 Jul 2021 16:12:39 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Martynas Pumputis <m@lambda.lt>,
        Networking <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH iproute2] libbpf: fix attach of prog with multiple
 sections
Message-ID: <YPvLd5BiH7FHtyIp@Laptop-X1>
References: <20210705124307.201303-1-m@lambda.lt>
 <CAEf4Bzb_FAOMK+8J+wyvbR2etYFDU1ae=P3pwW3fzfcWctZ1Xw@mail.gmail.com>
 <df3396c3-9a4a-824d-648f-69f4da5bc78b@lambda.lt>
 <YPpIeppWpqFCSaqZ@Laptop-X1>
 <CAEf4Bzavevcn=p7iBSH6iXMOCXp5kCu71a1kZ7PSawW=LW5NSQ@mail.gmail.com>
 <YPp17yOht8W+Kaqy@Laptop-X1>
 <CAEf4BzYayFVz4SVw3RpmTd-9w01bkA58NQ_QH4S8gLDDUsVPHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYayFVz4SVw3RpmTd-9w01bkA58NQ_QH4S8gLDDUsVPHA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 09:09:01AM -0700, Andrii Nakryiko wrote:
> On Fri, Jul 23, 2021 at 12:55 AM Hangbin Liu <haliu@redhat.com> wrote:
> >
> > On Thu, Jul 22, 2021 at 09:51:50PM -0700, Andrii Nakryiko wrote:
> > > > > > This is still problematic, because one section can have multiple BPF
> > > > > > programs. I.e., it's possible two define two or more XDP BPF programs
> > > > > > all with SEC("xdp") and libbpf works just fine with that. I suggest
> > > > > > moving users to specify the program name (i.e., C function name
> > > > > > representing the BPF program). All the xdp_mycustom_suffix namings are
> >
> > I just propose an implementation as you suggested.
> >
> > > > > > a hack and will be rejected by libbpf 1.0, so it would be great to get
> > > > > > a head start on fixing this early on.
> > > > >
> > > > > Thanks for bringing this up. Currently, there is no way to specify a
> > > > > function name with "tc exec bpf" (only a section name via the "sec" arg). So
> > > > > probably, we should just add another arg to specify the function name.
> > > >
> > > > How about add a "prog" arg to load specified program name and mark
> > > > "sec" as not recommended? To keep backwards compatibility we just load the
> > > > first program in the section.
> > >
> > > Why not error out if there is more than one program with the same
> > > section name? if there is just one (and thus section name is still
> > > unique) -- then proceed. It seems much less confusing, IMO.
> >
> > If you and others think it's OK to only support one program each section.
> > I do no object.
> >
> 
> I'm not sure we are on the same page. I'll try to summarize what I
> understood and you guys can decide for yourself what you want to do.
> 
> So I like your idea of introducing "prog" arg that will expect BPF
> program name (i.e., C function name). In that case the name is always
> unique. For existing "sec" arg, for backwards compatibility, I'd keep
> it working, but when "sec" is used I'd check that the match is unique
> (i.e., there is only one BPF program within the specified section). If
> not and there are more than one matching BPF programs, that's a hard
> error, because otherwise you essentially randomly pick one BPF program
> out of a few.

Cool, we are in the same page now.

Thanks
Hangbin

