Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA692325E6
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 22:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgG2ULb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 16:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgG2ULb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 16:11:31 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B5BC061794;
        Wed, 29 Jul 2020 13:11:30 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0sQ1-005BLO-LM; Wed, 29 Jul 2020 20:11:17 +0000
Date:   Wed, 29 Jul 2020 21:11:17 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
Message-ID: <20200729201117.GA1233513@ZenIV.linux.org.uk>
References: <20200722211223.1055107-1-jolsa@kernel.org>
 <20200722211223.1055107-10-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722211223.1055107-10-jolsa@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 11:12:19PM +0200, Jiri Olsa wrote:

> +BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
> +{
> +	char *p = d_path(path, buf, sz - 1);
> +	int len;
> +
> +	if (IS_ERR(p)) {
> +		len = PTR_ERR(p);
> +	} else {
> +		len = strlen(p);
> +		if (len && p != buf)
> +			memmove(buf, p, len);

*blink*
What the hell do you need that strlen() for?  d_path() copies into
the end of buffer (well, starts there and prepends to it); all you
really need is memmove(buf, p, buf + sz - p)


> +		buf[len] = 0;

Wait a minute...  Why are you NUL-terminating it separately?
You do rely upon having NUL in the damn thing (and d_path() does
guarantee it there).  Without that strlen() would've gone into
the nasal demon country; you can't call it on non-NUL-terminated
array.  So you are guaranteed that p[len] will be '\0'; why bother
copying the first len bytes and then separately deal with that
NUL?  Just memmove() the fucker and be done with that...

If you are worried about stray NUL in the middle of the returned
data... can't happen.  Note the rename_lock use in fs/d_path.c;
the names of everything involved are guaranteed to have been
stable throughout the copying them into the buffer - if anything
were to be renamed while we are doing that, we'd repeat the whole
thing (with rename_lock taken exclusive the second time around).

So make it simply
	if (IS_ERR(p))
		return PTR_ERR(p);
	len = buf + sz - p;
	memmove(buf, p, len);
	return len;
and be done with that.  BTW, the odds of p == buf are pretty much
nil - it would happen only if sz - 1 happened to be the exact length
of pathname.
