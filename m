Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5ABE1251DF
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 20:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfLRT3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 14:29:34 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33755 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbfLRT3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 14:29:33 -0500
Received: by mail-wm1-f65.google.com with SMTP id d139so5358391wmd.0;
        Wed, 18 Dec 2019 11:29:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4IX65XoG+lwuyGD3Arbm1HfcvG4rtyZykcaNuxF6tEY=;
        b=mVsS2/OUB4a46cAU3MuAtepvnB7/AS3q9R4C07Ndq5qQTWCE/JiSwpT0p4Jh9H3117
         vkrvHxtk1Fq4qf0Z7d5hrn/aCBV6CvZMgtS161otpP9WG6Q8aRuweXP3mXLxzEtNIB5O
         S8zfASDMSBYMfEB4SIS74cCYuOFGUCokFdojVON34r79I4BfemnqU0WS4tvFTvc4HZD7
         A6hlBaog1ualbpJODqjONpxOO/HjeI06k3rIJ4mlGEEAvF+AQ/JNnJGN5JPe8bn55dke
         XqB07fU1tEmplexks1VF7f0GChU/Rc0D24BpOmNp0stCO5X/lDlSGkLsWnMArmkN/9NM
         bLww==
X-Gm-Message-State: APjAAAUvwoQUDF3/rQVkQSEFvlgJpqoFwtunC4RtNFUmE8Ps8s33wiXn
        z478eDCpfD8+ztLDCeBgdfE=
X-Google-Smtp-Source: APXvYqyK1OMFwWWb59RszGP5uH603/DBrKT/7xYrvbbHGQLo/Tw5nDHPh5Z16lTxL9dEY0+D9fHnAw==
X-Received: by 2002:a1c:a745:: with SMTP id q66mr4924228wme.167.1576697371509;
        Wed, 18 Dec 2019 11:29:31 -0800 (PST)
Received: from Omicron ([217.76.31.1])
        by smtp.gmail.com with ESMTPSA id j12sm3644010wrt.55.2019.12.18.11.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 11:29:30 -0800 (PST)
Date:   Wed, 18 Dec 2019 20:29:30 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Quentin Monnet <quentin.monnet@netronome.com>,
        paul.chaignon@gmail.com, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v2 0/3] bpftool: match programs and maps by names
Message-ID: <20191218192930.GA30898@Omicron>
References: <cover.1576263640.git.paul.chaignon@gmail.com>
 <20191215174004.57deg3fs7665jokd@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191215174004.57deg3fs7665jokd@ast-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 15, 2019 at 09:40:05AM -0800, Alexei Starovoitov wrote:
> On Fri, Dec 13, 2019 at 08:09:52PM +0100, Paul Chaignon wrote:
> > When working with frequently modified BPF programs, both the ID and the
> > tag may change.  bpftool currently doesn't provide a "stable" way to match
> > such programs.  This patchset allows bpftool to match programs and maps by
> > name.
> > 
> > When given a tag that matches several programs, bpftool currently only
> > considers the first match.  The first patch changes that behavior to
> > either process all matching programs (for the show and dump commands) or
> > error out.  The second patch implements program lookup by name, with the
> > same behavior as for tags in case of ambiguity.  The last patch implements
> > map lookup by name.
> > 
> > Changelogs:
> >   Changes in v2:
> >     - Fix buffer overflow after realloc.
> >     - Add example output to commit message.
> >     - Properly close JSON arrays on errors.
> >     - Fix style errors (line breaks, for loops, exit labels, type for
> >       tagname).
> >     - Move do_show code for argc == 2 to do_show_subset functions.
> >     - Rebase.
> 
> Loogs good. Applied.
> 
> I found the exact match logic unintuitive though.
> Since 'prog show' can print multiple may be allow partial match on name?
> So 'bpftool p s name tracepoint__' would print all BCC-based programs
> that attach to tracepoints.
> It would be roughly equivalent to 'bpftool p s |grep tracepoint__',
> but grep captures single line.

I had a look at bcc and it actually removes these prefixes from the
program's name (except for kretprobes, but it looks like an oversight).

I still agree a partial match would be good to have since related
programs are more likely to share prefixes (e.g., func_entry and
func_exit).  Maybe matching on prefixes would be enough though?  I can't
think of use cases for a true partial match and the behavior might be a
bit unexpected for users...

Or we go all the way and implement support for * (e.g., tcp_* for all bcc
kprobes on tcp functions; *tcp* for all programs containing 'tcp').

> There is 'bpftool perf|grep tracepoint' as well, but since the tool
> matches on name it probably should match partial name too.
> 
