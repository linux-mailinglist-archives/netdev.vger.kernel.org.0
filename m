Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D818C11E9C9
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 19:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbfLMSKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 13:10:45 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38854 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728599AbfLMSKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 13:10:44 -0500
Received: by mail-wm1-f68.google.com with SMTP id u2so106628wmc.3;
        Fri, 13 Dec 2019 10:10:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kKBG8s7/UNRfRjtd46YUWSu1m7U1t6STUY5i/CQM3E0=;
        b=IfhN8zjs77cndyVjZztFyteYTzlCoyXdu5eczqpheRyOLgBsi8Ul7I6rkEhiwifta1
         Mx0kaqabW1w5FyKFjle0XHgYFAxcgLy9c/R+8sz/zjTGHXbilN0BiVekj3fgPX0etbob
         xzzQ7pA9atFNqcb0ZX7f9K611CSkAP4EG+p1H29Jw/5GKKV72Qzu5y22oSvZqvjz2bE+
         da38ruAbgMSc1uFsoBQTzenpTk9FCGoq//qvJVLc5Zia5bgXy1E+Bp3EylUPLHArrZuc
         L66Je1pqQBwoWKQNXfgnM07fNJ/KJ3MBvDEUXlvHXFdtfs1TFZ+opvWO8m3IJ3lC608T
         GjCg==
X-Gm-Message-State: APjAAAXpu6i0Q8sxZlaKCBerS8cmvdx/fVQn16Uts2RUCEBo9bKPguHS
        8Qgftyoxgj6/N+2tifAvS/s=
X-Google-Smtp-Source: APXvYqz+YSwUyN0MAPF5ulAzVlDiqyu6/HIpLVvv/+nZog0J2tMTN4wGZKpV8x3VOH0/9lxAg0s7kw==
X-Received: by 2002:a7b:cf18:: with SMTP id l24mr14034197wmg.95.1576260641814;
        Fri, 13 Dec 2019 10:10:41 -0800 (PST)
Received: from Omicron ([185.64.192.240])
        by smtp.gmail.com with ESMTPSA id e18sm10345306wrw.70.2019.12.13.10.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 10:10:41 -0800 (PST)
Date:   Fri, 13 Dec 2019 19:10:40 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     bpf@vger.kernel.org, paul.chaignon@gmail.com,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpftool: match several programs with same
 tag
Message-ID: <20191213181040.GA6096@Omicron>
References: <cover.1575991886.git.paul.chaignon@orange.com>
 <4db34d127179faafd6eca408792222c922969904.1575991886.git.paul.chaignon@orange.com>
 <99f35770-9a3f-2135-a9a6-34d931b1ae1e@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99f35770-9a3f-2135-a9a6-34d931b1ae1e@netronome.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 05:29:18PM +0000, Quentin Monnet wrote:
> Hi Paul,
> 
> 2019-12-10 17:06 UTC+0100 ~ Paul Chaignon <paul.chaignon@orange.com>
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
> > 
> > Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
> > ---
> >  .../bpftool/Documentation/bpftool-prog.rst    |  16 +-
> >  tools/bpf/bpftool/prog.c                      | 371 ++++++++++++------
> >  2 files changed, 272 insertions(+), 115 deletions(-)
> > 

[...]

> > @@ -351,21 +421,43 @@ static int show_prog(int fd)
> >  
> >  static int do_show(int argc, char **argv)
> >  {
> > +	int fd, nb_fds, i;
> > +	int *fds = NULL;
> >  	__u32 id = 0;
> >  	int err;
> > -	int fd;
> >  
> >  	if (show_pinned)
> >  		build_pinned_obj_table(&prog_table, BPF_OBJ_PROG);
> >  
> >  	if (argc == 2) {
> > -		fd = prog_parse_fd(&argc, &argv);
> > -		if (fd < 0)
> > +		fds = malloc(sizeof(int));
> > +		if (!fds) {
> > +			p_err("mem alloc failed");
> >  			return -1;
> > +		}
> > +		nb_fds = prog_parse_fds(&argc, &argv, fds);
> > +		if (nb_fds < 1)
> > +			goto err_free;
> >  
> > -		err = show_prog(fd);
> > -		close(fd);
> > -		return err;
> > +		if (json_output && nb_fds > 1)
> > +			jsonw_start_array(json_wtr);	/* root array */
> > +		for (i = 0; i < nb_fds; i++) {
> > +			err = show_prog(fds[i]);
> > +			close(fds[i]);
> > +			if (err) {
> > +				for (i++; i < nb_fds; i++)
> > +					close(fds[i]);
> > +				goto err_free;
> 
> Alternatively, we could keep trying to list the remaining programs. For
> example, if the system has a long list of BPF programs running and one
> of them is removed while printing the list, we would still have the rest
> of the list.

As discussed off the list, since the kernel keeps a refcount for programs,
a program won't be removed while printing the list, not as long as we hold
an fd to it.  Unless there's another common case of failure, I'm going to
keep the current behavior in the v2 and break out of the loop on errors
(though, with the appropriate JSON array closing).

> 
> If we went this way, maybe just set err to non-zero if no program at all
> could be printed?
> 
> > +			}
> > +		}
> > +		if (json_output && nb_fds > 1)
> > +			jsonw_end_array(json_wtr);	/* root array */
> > +
> > +		return 0;
> > +
> > +err_free:
> > +		free(fds);
> > +		return -1;
> >  	}
> >  
> >  	if (argc)
