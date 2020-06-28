Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A098620CA52
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 22:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgF1UQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 16:16:21 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31207 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726685AbgF1UQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 16:16:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593375379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UORC3khSPgkKki06+WolbXfIYGTlBXEi1rqLOGOEVvU=;
        b=N2frVJLvdCP0NYC2pvQi/aOY9RSLg54A/zRSqupjbKn86zGgT0O88iraxBmPRryHfjWrgL
        zvx2oO2A8GNt5jIn1uDHxdSnGBvL5NfxEnylNtk1BVBfYSp1e6Nf0wUW7xMRnWS5dIfx+C
        CO2zQKnzLDhHzrVeNPyr9WrtupU7HQQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-0HeNvHBmP-6eZiv6eQvr8g-1; Sun, 28 Jun 2020 16:16:14 -0400
X-MC-Unique: 0HeNvHBmP-6eZiv6eQvr8g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B6EA804001;
        Sun, 28 Jun 2020 20:16:12 +0000 (UTC)
Received: from krava (unknown [10.40.192.56])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5511F2857D;
        Sun, 28 Jun 2020 20:16:09 +0000 (UTC)
Date:   Sun, 28 Jun 2020 22:16:08 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 bpf-next 05/14] bpf: Remove btf_id helpers resolving
Message-ID: <20200628201608.GG2988321@krava>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-6-jolsa@kernel.org>
 <7480f7b2-01f0-f575-7e4f-cf3bde851c3f@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7480f7b2-01f0-f575-7e4f-cf3bde851c3f@fb.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 02:36:37PM -0700, Yonghong Song wrote:

SNIP

> > -	}
> > -
> > -	t = btf_type_by_id(btf_vmlinux, t->type);
> > -	if (!btf_type_is_ptr(t))
> > -		return -EFAULT;
> > -	t = btf_type_by_id(btf_vmlinux, t->type);
> > -	if (!btf_type_is_func_proto(t))
> > -		return -EFAULT;
> > -
> > -	args = (const struct btf_param *)(t + 1);
> > -	if (arg >= btf_type_vlen(t)) {
> > -		bpf_log(log, "bpf helper %s doesn't have %d-th argument\n",
> > -			fnname, arg);
> > +	if (WARN_ON_ONCE(!fn->btf_id))
> 
> The original code does not have this warning. It directly did
> "ret = READ_ONCE(*btf_id);" after testing reg arg type ARG_PTR_TO_BTF_ID.

not sure why I put it in there, it's probably enough guarded
by arg_type having ARG_PTR_TO_BTF_ID, will remove

> 
> >   		return -EINVAL;
> > -	}
> > -	t = btf_type_by_id(btf_vmlinux, args[arg].type);
> > -	if (!btf_type_is_ptr(t) || !t->type) {
> > -		/* anything but the pointer to struct is a helper config bug */
> > -		bpf_log(log, "ARG_PTR_TO_BTF is misconfigured\n");
> > -		return -EFAULT;
> > -	}
> > -	btf_id = t->type;
> > -	t = btf_type_by_id(btf_vmlinux, t->type);
> > -	/* skip modifiers */
> > -	while (btf_type_is_modifier(t)) {
> > -		btf_id = t->type;
> > -		t = btf_type_by_id(btf_vmlinux, t->type);
> > -	}
> > -	if (!btf_type_is_struct(t)) {
> > -		bpf_log(log, "ARG_PTR_TO_BTF is not a struct\n");
> > -		return -EFAULT;
> > -	}
> > -	bpf_log(log, "helper %s arg%d has btf_id %d struct %s\n", fnname + 4,
> > -		arg, btf_id, __btf_name_by_offset(btf_vmlinux, t->name_off));
> > -	return btf_id;
> > -}
> > +	id = fn->btf_id[arg];
> 
> The corresponding BTF_ID definition here is:
>   BTF_ID_LIST(bpf_skb_output_btf_ids)
>   BTF_ID(struct, sk_buff)
> 
> The bpf helper writer needs to ensure proper declarations
> of BTF_IDs like the above matching helpers definition.
> Support we have arg1 and arg3 as BTF_ID. then the list
> definition may be
> 
>   BTF_ID_LIST(bpf_skb_output_btf_ids)
>   BTF_ID(struct, sk_buff)
>   BTF_ID(struct, __unused)
>   BTF_ID(struct, task_struct)
> 
> This probably okay, I guess.

right, AFAIK we don't have such case yet, but would be good
to be ready and have something like

  BTF_ID(struct, __unused)

maybe adding new type for that will be better:

  BTF_ID(none, unused)

jirka

