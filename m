Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207092008C5
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 14:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732416AbgFSMfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 08:35:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28498 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730721AbgFSMfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 08:35:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592570152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NXJ8JwYP5yMf+56IORlViCZxc1+aN4iEbLDz8h9YxWA=;
        b=eAZMgczL2S+UJbZZsYX+g1y4F3j/9w8vGEXrf20NgVa4gGzx0vzmse2oTa0fewSZWNVjMh
        oTgXXO9/olnAVvvX73QssVfX8YT0QvgDS3SAvCKKWlzrdQVXr/jhSE4LsbyiGr1Ns0Ucfo
        sosnPgyeagdhyiwpC7GfBtOoYqalxZ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-qxceCPf6Oea1rHQcpnhBOA-1; Fri, 19 Jun 2020 08:35:33 -0400
X-MC-Unique: qxceCPf6Oea1rHQcpnhBOA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71648464;
        Fri, 19 Jun 2020 12:35:31 +0000 (UTC)
Received: from krava (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with SMTP id 1226F10013C4;
        Fri, 19 Jun 2020 12:35:27 +0000 (UTC)
Date:   Fri, 19 Jun 2020 14:35:27 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCHv3 0/9] bpf: Add d_path helper
Message-ID: <20200619123527.GA2465907@krava>
References: <20200616100512.2168860-1-jolsa@kernel.org>
 <5eebd52fc68ee_6d292ad5e7a285b816@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eebd52fc68ee_6d292ad5e7a285b816@john-XPS-13-9370.notmuch>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 01:57:19PM -0700, John Fastabend wrote:
> Jiri Olsa wrote:
> > hi,
> > adding d_path helper to return full path for 'path' object.
> > 
> > I originally added and used 'file_path' helper, which did the same,
> > but used 'struct file' object. Then realized that file_path is just
> > a wrapper for d_path, so we'd cover more calling sites if we add
> > d_path helper and allowed resolving BTF object within another object,
> > so we could call d_path also with file pointer, like:
> > 
> >   bpf_d_path(&file->f_path, buf, size);
> > 
> > This feature is mainly to be able to add dpath (filepath originally)
> > function to bpftrace:
> > 
> >   # bpftrace -e 'kfunc:vfs_open { printf("%s\n", dpath(args->path)); }'
> > 
> > v3 changes:
> >   - changed tests to use seleton and vmlinux.h [Andrii]
> >   - refactored to define ID lists in C object [Andrii]
> >   - changed btf_struct_access for nested ID check,
> >     instead of adding new function for that [Andrii]
> >   - fail build with CONFIG_DEBUG_INFO_BTF if libelf is not detected [Andrii]
> > 
> > Also available at:
> >   https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> >   bpf/d_path
> > 
> > thanks,
> > jirka
> 
> Hi Jira, Apologize for waiting until v3 to look at this series, but a
> couple general requests as I review this.
> 
> In the cover letter can we get some more details. The above is really
> terse/cryptic in my opinion. The bpftrace example gives good motiviation,
> but nothing above mentions a new .BTF_ids section and the flow to create
> and use this section.

ok, will add more details in next version

> 
> Also if we add a BTF_ids  section adding documentation in btf.rst should
> happen as well. I would like to see something in the ELF File Format
> Interface section and BTF Generation sections.

did not know there was bpf.rst ;-) will update

> 
> I'm not going to nitpick if its in this series or a stand-alone patch
> but do want to see it. So far the Documentation on BTF is fairly
> good and I want to avoid these kind of gaps.

sure, thanks

jirka

> 
> Thanks!
> John
> 

