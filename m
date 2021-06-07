Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CC839E6AF
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 20:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbhFGSas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 14:30:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36883 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230311AbhFGSar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 14:30:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623090535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SzmjRmeOXm182lTS+IXTdvaHkoejd63RnL9vUU/eUY4=;
        b=KHPBEIG2hjp2LueOpfweL3TWTJHpVHh+WSAtenhfCmxWbTdoExCz+ivXJsoB/LZQzyHwOe
        xwjDEcEK7B++nfX4+ZWAjLjIVQy5nMawwjuRDNADvDlgn4kZNbOBY2YgDyKw7+j4ppjbc0
        04TV5sDN0GV+QkLa5cmIVLGR1VeF4sU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-0nWweTWzOpmfheW2o9YqBg-1; Mon, 07 Jun 2021 14:28:53 -0400
X-MC-Unique: 0nWweTWzOpmfheW2o9YqBg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B291D800D62;
        Mon,  7 Jun 2021 18:28:51 +0000 (UTC)
Received: from krava (unknown [10.40.192.167])
        by smtp.corp.redhat.com (Postfix) with SMTP id DD4325D736;
        Mon,  7 Jun 2021 18:28:48 +0000 (UTC)
Date:   Mon, 7 Jun 2021 20:28:48 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH 15/19] libbpf: Add support to link multi func tracing
 program
Message-ID: <YL5lYPJdx5mmd06F@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-16-jolsa@kernel.org>
 <50f92d1e-1138-656c-4318-8fecf61f2025@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50f92d1e-1138-656c-4318-8fecf61f2025@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 06, 2021 at 10:49:16PM -0700, Yonghong Song wrote:
> 
> 
> On 6/5/21 4:10 AM, Jiri Olsa wrote:
> > Adding support to link multi func tracing program
> > through link_create interface.
> > 
> > Adding special types for multi func programs:
> > 
> >    fentry.multi
> >    fexit.multi
> > 
> > so you can define multi func programs like:
> > 
> >    SEC("fentry.multi/bpf_fentry_test*")
> >    int BPF_PROG(test1, unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)
> > 
> > that defines test1 to be attached to bpf_fentry_test* functions,
> > and able to attach ip and 6 arguments.
> > 
> > If functions are not specified the program needs to be attached
> > manually.
> > 
> > Adding new btf id related fields to bpf_link_create_opts and
> > bpf_link_create to use them.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   tools/lib/bpf/bpf.c    | 11 ++++++-
> >   tools/lib/bpf/bpf.h    |  4 ++-
> >   tools/lib/bpf/libbpf.c | 72 ++++++++++++++++++++++++++++++++++++++++++
> >   3 files changed, 85 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> > index 86dcac44f32f..da892737b522 100644
> > --- a/tools/lib/bpf/bpf.c
> > +++ b/tools/lib/bpf/bpf.c
> > @@ -674,7 +674,8 @@ int bpf_link_create(int prog_fd, int target_fd,
> >   		    enum bpf_attach_type attach_type,
> >   		    const struct bpf_link_create_opts *opts)
> >   {
> > -	__u32 target_btf_id, iter_info_len;
> > +	__u32 target_btf_id, iter_info_len, multi_btf_ids_cnt;
> > +	__s32 *multi_btf_ids;
> >   	union bpf_attr attr;
> >   	int fd;
> [...]
> > @@ -9584,6 +9597,9 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog, int *btf_obj_fd,
> >   	if (!name)
> >   		return -EINVAL;
> > +	if (prog->prog_flags & BPF_F_MULTI_FUNC)
> > +		return 0;
> > +
> >   	for (i = 0; i < ARRAY_SIZE(section_defs); i++) {
> >   		if (!section_defs[i].is_attach_btf)
> >   			continue;
> > @@ -10537,6 +10553,62 @@ static struct bpf_link *bpf_program__attach_btf_id(struct bpf_program *prog)
> >   	return (struct bpf_link *)link;
> >   }
> > +static struct bpf_link *bpf_program__attach_multi(struct bpf_program *prog)
> > +{
> > +	char *pattern = prog->sec_name + prog->sec_def->len;
> > +	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
> > +	enum bpf_attach_type attach_type;
> > +	int prog_fd, link_fd, cnt, err;
> > +	struct bpf_link *link = NULL;
> > +	__s32 *ids = NULL;
> > +
> > +	prog_fd = bpf_program__fd(prog);
> > +	if (prog_fd < 0) {
> > +		pr_warn("prog '%s': can't attach before loaded\n", prog->name);
> > +		return ERR_PTR(-EINVAL);
> > +	}
> > +
> > +	err = bpf_object__load_vmlinux_btf(prog->obj, true);
> > +	if (err)
> > +		return ERR_PTR(err);
> > +
> > +	cnt = btf__find_by_pattern_kind(prog->obj->btf_vmlinux, pattern,
> > +					BTF_KIND_FUNC, &ids);
> > +	if (cnt <= 0)
> > +		return ERR_PTR(-EINVAL);
> 
> In kernel, looks like we support cnt = 0, here we error out.
> Should we also error out in the kernel if cnt == 0?

hum, I'm not what you mean.. what kernel code are you referring to?

thanks,
jirka

