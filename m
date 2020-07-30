Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE1E233044
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 12:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbgG3KXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 06:23:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50328 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728795AbgG3KXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 06:23:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596104581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M55NVo/p4Ki/zb/dZ0gL9E7SRpn8neFKlVQ6d5TPxlA=;
        b=Xx2T3xa43WG+HttAbYjTg/obEfruY2jbn3UyIL2lzf/jPHXaOC8wQYlHJfYISLPURCGI3y
        veNPAyBSf2tFL+fZj4YJq1I00eBKpJ22d6onGz+uD3uaozywUmYCXaqseJXbcCUOL0yl9R
        XizQDE0UIQgzopK91BtSbeyh/ctjyIQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-6wiMTaGKO6yT5rox6Fjatg-1; Thu, 30 Jul 2020 06:22:59 -0400
X-MC-Unique: 6wiMTaGKO6yT5rox6Fjatg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36662101C8A9;
        Thu, 30 Jul 2020 10:22:57 +0000 (UTC)
Received: from krava (unknown [10.40.194.223])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2453A6179D;
        Thu, 30 Jul 2020 10:22:53 +0000 (UTC)
Date:   Thu, 30 Jul 2020 12:22:52 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>
Subject: Re: [PATCH v8 bpf-next 09/13] bpf: Add d_path helper
Message-ID: <20200730102252.GR1319041@krava>
References: <20200722211223.1055107-1-jolsa@kernel.org>
 <20200722211223.1055107-10-jolsa@kernel.org>
 <20200729201117.GA1233513@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729201117.GA1233513@ZenIV.linux.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 09:11:17PM +0100, Al Viro wrote:
> On Wed, Jul 22, 2020 at 11:12:19PM +0200, Jiri Olsa wrote:
> 
> > +BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
> > +{
> > +	char *p = d_path(path, buf, sz - 1);
> > +	int len;
> > +
> > +	if (IS_ERR(p)) {
> > +		len = PTR_ERR(p);
> > +	} else {
> > +		len = strlen(p);
> > +		if (len && p != buf)
> > +			memmove(buf, p, len);
> 
> *blink*
> What the hell do you need that strlen() for?  d_path() copies into
> the end of buffer (well, starts there and prepends to it); all you
> really need is memmove(buf, p, buf + sz - p)

I used the code from some of the other users like
  backing_dev_show
  fsg_show_file

nice, looks like we could omit strlen call in perf mmap event call as well

> 
> 
> > +		buf[len] = 0;
> 
> Wait a minute...  Why are you NUL-terminating it separately?
> You do rely upon having NUL in the damn thing (and d_path() does
> guarantee it there).  Without that strlen() would've gone into
> the nasal demon country; you can't call it on non-NUL-terminated
> array.  So you are guaranteed that p[len] will be '\0'; why bother
> copying the first len bytes and then separately deal with that
> NUL?  Just memmove() the fucker and be done with that...
> 
> If you are worried about stray NUL in the middle of the returned
> data... can't happen.  Note the rename_lock use in fs/d_path.c;
> the names of everything involved are guaranteed to have been
> stable throughout the copying them into the buffer - if anything
> were to be renamed while we are doing that, we'd repeat the whole
> thing (with rename_lock taken exclusive the second time around).
> 
> So make it simply
> 	if (IS_ERR(p))
> 		return PTR_ERR(p);
> 	len = buf + sz - p;
> 	memmove(buf, p, len);
> 	return len;

ok, will use this

> and be done with that.  BTW, the odds of p == buf are pretty much
> nil - it would happen only if sz - 1 happened to be the exact length
> of pathname.
> 

ok, great

thanks,
jirka

