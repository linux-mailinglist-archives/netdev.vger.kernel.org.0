Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697631A0A48
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 11:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgDGJjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 05:39:10 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22604 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725883AbgDGJjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 05:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586252349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BT0DOjBa5uu8x94CvxH++WNSrZ3ZhvAl1TY5DndZwnY=;
        b=FK3azqbTiB1VEsspdf6uEqNcpuC7NqVIYQU9a+MJ2LoM2ZdaYjSTij+vtixeW4yuRWOtCe
        w2sq4wZU+QZimBf0wjw0IPoCjNnut8PzvRYsjBzuoYeHBAuRBfS0xRuMBFe8B+r7XT9yN1
        9fOyzck/MoCJ2TqMsWqDbysZaqJy0Ao=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-vKYNsQNoOVaKwnUBu1uibA-1; Tue, 07 Apr 2020 05:37:36 -0400
X-MC-Unique: vKYNsQNoOVaKwnUBu1uibA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02E441088386;
        Tue,  7 Apr 2020 09:37:34 +0000 (UTC)
Received: from krava (unknown [10.40.192.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF3391001DF0;
        Tue,  7 Apr 2020 09:37:30 +0000 (UTC)
Date:   Tue, 7 Apr 2020 11:37:28 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/3] bpf: Add support to check if BTF object is nested in
 another object
Message-ID: <20200407093728.GB3144092@krava>
References: <20200401110907.2669564-1-jolsa@kernel.org>
 <20200401110907.2669564-2-jolsa@kernel.org>
 <20200407011601.526c6i6dyq6lndmf@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407011601.526c6i6dyq6lndmf@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 06, 2020 at 06:16:01PM -0700, Alexei Starovoitov wrote:

SNIP

> > +			continue;
> > +
> > +		/* the 'off' we're looking for is either equal to start
> > +		 * of this field or inside of this struct
> > +		 */
> > +		if (btf_type_is_struct(mtype)) {
> > +			/* our field must be inside that union or struct */
> > +			t = mtype;
> > +
> > +			/* adjust offset we're looking for */
> > +			off -= moff;
> > +			goto again;
> > +		}
> 
> Looks like copy-paste that should be generalized into common helper.

right, I think we could have some common code with btf_struct_access,
but id not want to complicate the change for rfc

> 
> > +
> > +		bpf_log(log, "struct %s doesn't have struct field at offset %d\n", tname, off);
> > +		return -EACCES;
> > +	}
> > +
> > +	bpf_log(log, "struct %s doesn't have field at offset %d\n", tname, off);
> > +	return -EACCES;
> > +}
> > +
> >  static int __btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn,
> >  				   int arg)
> >  {
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 04c6630cc18f..6eb88bef4379 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -3103,6 +3103,18 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
> >  	return 0;
> >  }
> >  
> > +static void check_ptr_in_btf(struct bpf_verifier_env *env,
> > +			     struct bpf_reg_state *reg,
> > +			     u32 exp_id)
> > +{
> > +	const struct btf_type *t = btf_type_by_id(btf_vmlinux, reg->btf_id);
> > +
> > +	if (!btf_struct_address(&env->log, t, reg->off, exp_id)) {
> > +		reg->btf_id = exp_id;
> > +		reg->off = 0;
> 
> This doesn't look right.
> If you simply overwrite btf_id and off in the reg it will contain wrong info
> in any subsequent instruction.
> Typically it would be ok, since this reg is a function argument and will be
> scratched after the call, but consider:
> bpf_foo(&file->f_path, &file->f_owner);
> The same base register will be used to construct R1 and R2
> and above re-assign will screw up R1.

ok.. I'll use the 'new btf id' just to do check on the helper args
and not change the reg's btf id

thanks,
jirka

