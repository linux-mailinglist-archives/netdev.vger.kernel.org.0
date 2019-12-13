Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFF2511E3AB
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 13:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfLMMj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 07:39:26 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33724 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbfLMMj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 07:39:26 -0500
Received: by mail-wr1-f67.google.com with SMTP id b6so6539877wrq.0;
        Fri, 13 Dec 2019 04:39:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZZ04V3mwA+LuIkYCugZJQn1tkjaZz+RiqfNWE7WVglY=;
        b=Bp29Hy40fKS8JlQ5LxwUUVq17iini6M4zvRSuMiyY2jX/VH5oIm5plSzwMXxOB8vqt
         wwLf5gq5JEx8T9R3U3IPv4jNJ7hxRRv2CngCQKTDnduqo98+0fWoZObRUoIApcgp6J1M
         g1TXkYN/Nh5QTE96RwonHAahd8cLvf4LjpW+OoVOkN0Ur0tz2g/w29CuK7dxJtEmOpvc
         FCUzihqTRsyYFVxJ6+YHy/1urMHVPsGMbAxOd3GF9N16ufFZv+S9AObZKiLoXJcCpNLq
         0QP9BNNx2W7LIQM+NfdotCsWbjshIviPqRTcOLzSnLmPorYlblEIK1l1C8aC/svOf3Wx
         NRIw==
X-Gm-Message-State: APjAAAUeSeZT3lpxwftns8yI0HCqxPPt4QXmWHP4dh3S7TjbtBuvH8vO
        5ea9E0CxJKW8z3/EQA6MuQA=
X-Google-Smtp-Source: APXvYqxpmoYITwuBJK9JLi6VrOsRB+CFk+YZeRC+Z5qer9cMm6DonZl3hHZ2oxFmJ/KVU91oEAB/Bg==
X-Received: by 2002:a05:6000:160d:: with SMTP id u13mr12996632wrb.22.1576240764130;
        Fri, 13 Dec 2019 04:39:24 -0800 (PST)
Received: from Omicron ([185.64.192.240])
        by smtp.gmail.com with ESMTPSA id z21sm10115657wml.5.2019.12.13.04.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 04:39:23 -0800 (PST)
Date:   Fri, 13 Dec 2019 13:39:22 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     bpf@vger.kernel.org, Quentin Monnet <quentin.monnet@netronome.com>,
        paul.chaignon@gmail.com, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpftool: match several programs with same
 tag
Message-ID: <20191213123922.GA6538@Omicron>
References: <cover.1575991886.git.paul.chaignon@orange.com>
 <4db34d127179faafd6eca408792222c922969904.1575991886.git.paul.chaignon@orange.com>
 <20191210123625.48ab21fa@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210123625.48ab21fa@cakuba.netronome.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 12:36:25PM -0800, Jakub Kicinski wrote:
> On Tue, 10 Dec 2019 17:06:25 +0100, Paul Chaignon wrote:
> > When several BPF programs have the same tag, bpftool matches only the
> > first (in ID order).  This patch changes that behavior such that dump and
> > show commands return all matched programs.  Commands that require a single
> > program (e.g., pin and attach) will error out if given a tag that matches
> > several.  bpftool prog dump will also error out if file or visual are
> > given and several programs have the given tag.
> > 
> > In the case of the dump command, a program header is added before each
> > dump only if the tag matches several programs; this patch doesn't change
> > the output if a single program matches.
> 
> How does this work? Could you add examples to the commit message?
> 
> This header idea doesn't seem correct, aren't id and other per-instance
> fields only printed once?

Sorry, that was unclear.  What I call the header here is the first line
from the prog show output (in the case of plain output).  So the output
when multiple programs match looks as follows.  When a single program
matches, the first line (with the ID, type, name, tag and license) is
omitted.

$ ./bpftool prog dump xlated tag 6deef7357e7b4530
3: cgroup_skb  tag 6deef7357e7b4530  gpl
   0: (bf) r6 = r1
   [...]
   7: (95) exit

4: cgroup_skb  tag 6deef7357e7b4530  gpl
   0: (bf) r6 = r1
   [...]
   7: (95) exit

> 
> > Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
> 
> > -		close(fd);
> > +		if (nb_fds > 0) {
> > +			tmp = realloc(fds, (nb_fds + 1) * sizeof(int));
> > +			if (!tmp) {
> > +				p_err("failed to realloc");
> > +				goto err_close_fd;
> > +			}
> > +			fds = tmp;
> 
> How does this work? the new array is never returned to the caller, and
> the caller will most likely access freed memory, no?

Oh, this is bad.  Yes, fds should actually be "int **" and this line
should be "*fds = tmp;".  I'll fix it in v2.

[...]

> > +				close(fds[nb_fds]);
> > +		}
> > +		fd = -1;
> > +		goto err_free;
> > +	}
> > +
> > +	fd = fds[0];
> > +err_free:
> 
> nit: we tried to call the labels exit_xyz if the code is used on both
>      error and success path, but maybe that pattern got lost over time.

Seems lost in prog.c but still valid across bpftool.  I'll make the
change.

[...]

Paul
> 
