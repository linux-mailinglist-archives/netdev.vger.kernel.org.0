Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C7939E823
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 22:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhFGUOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 16:14:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56721 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231470AbhFGUOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 16:14:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623096728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RjC5hu9P7TcADt3HV6KMSytilg003dBj/PWOnkNe0v8=;
        b=hA4IZ2/WBh0tlo7WNySGqmXVPu7YhmauMxOSGheYWBstCbCYs4MAYsNfifBx4AQGmpjoHJ
        9jnAdGgvzxR30Y5WudIo+CrM4DdFjpfQTjcth1uQ4LEHjZLVYnLa1sMQ2BVomuO1aCJ+Qs
        RPqBFvjo0cmFv5wRDBPRe3nFQ012Rpk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-WGatHWHYNqWAYSv9K99akA-1; Mon, 07 Jun 2021 16:12:04 -0400
X-MC-Unique: WGatHWHYNqWAYSv9K99akA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BBB080362B;
        Mon,  7 Jun 2021 20:12:02 +0000 (UTC)
Received: from krava (unknown [10.40.192.167])
        by smtp.corp.redhat.com (Postfix) with SMTP id EBD6610013C1;
        Mon,  7 Jun 2021 20:11:58 +0000 (UTC)
Date:   Mon, 7 Jun 2021 22:11:58 +0200
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
Message-ID: <YL59jlLrQrZvoMa0@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-16-jolsa@kernel.org>
 <50f92d1e-1138-656c-4318-8fecf61f2025@fb.com>
 <YL5lYPJdx5mmd06F@krava>
 <a96ca297-ecc3-2bb7-6f76-97d541cd90e5@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a96ca297-ecc3-2bb7-6f76-97d541cd90e5@fb.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 12:42:51PM -0700, Yonghong Song wrote:

SNIP

> 
> +static int bpf_tracing_multi_attach(struct bpf_prog *prog,
> +				    const union bpf_attr *attr)
> +{
> +	void __user *ubtf_ids = u64_to_user_ptr(attr->link_create.multi_btf_ids);
> +	u32 size, i, cnt = attr->link_create.multi_btf_ids_cnt;
> +	struct bpf_tracing_multi_link *link = NULL;
> +	struct bpf_link_primer link_primer;
> +	struct bpf_trampoline *tr = NULL;
> +	int err = -EINVAL;
> +	u8 nr_args = 0;
> +	u32 *btf_ids;
> +
> +	if (check_multi_prog_type(prog))
> +		return -EINVAL;
> +
> +	size = cnt * sizeof(*btf_ids);
> +	btf_ids = kmalloc(size, GFP_USER | __GFP_NOWARN);
> +	if (!btf_ids)
> +		return -ENOMEM;
> +
> +	err = -EFAULT;
> +	if (ubtf_ids && copy_from_user(btf_ids, ubtf_ids, size))
> +		goto out_free;
> +
> +	link = kzalloc(sizeof(*link), GFP_USER);
> +	if (!link)
> +		goto out_free;
> +
> +	for (i = 0; i < cnt; i++) {
> +		struct bpf_attach_target_info tgt_info = {};
> +
> +		err = bpf_check_attach_target(NULL, prog, NULL, btf_ids[i],
> +					      &tgt_info);
> +		if (err)
> +			goto out_free;
> +
> +		if (ftrace_set_filter_ip(&link->ops, tgt_info.tgt_addr, 0, 0))
> +			goto out_free;
> +
> +		if (nr_args < tgt_info.fmodel.nr_args)
> +			nr_args = tgt_info.fmodel.nr_args;
> +	}
> +
> +	tr = bpf_trampoline_multi_alloc();
> +	if (!tr)
> +		goto out_free;
> +
> +	bpf_func_model_nargs(&tr->func.model, nr_args);
> +
> +	err = bpf_trampoline_link_prog(prog, tr);
> +	if (err)
> +		goto out_free;
> +
> +	err = register_ftrace_direct_multi(&link->ops, (unsigned long)
> tr->cur_image->image);
> +	if (err)
> +		goto out_free;
> +
> +	bpf_link_init(&link->link, BPF_LINK_TYPE_TRACING_MULTI,
> +		      &bpf_tracing_multi_link_lops, prog);
> +	link->attach_type = prog->expected_attach_type;
> +
> +	err = bpf_link_prime(&link->link, &link_primer);
> +	if (err)
> +		goto out_unlink;
> +
> +	link->tr = tr;
> +	/* Take extra ref so we are even with progs added by link_update. */
> +	bpf_prog_inc(prog);
> +	return bpf_link_settle(&link_primer);
> +
> +out_unlink:
> +	unregister_ftrace_direct_multi(&link->ops);
> +out_free:
> +	kfree(tr);
> +	kfree(btf_ids);
> +	kfree(link);
> +	return err;
> +}
> +
> 
> Looks like cnt = 0 is okay in bpf_tracing_multi_attach().

right, we should fail for that with EINVAL, also the
maximum with prog->aux->attach_btf->nr_types at least

thanks,
jirka

