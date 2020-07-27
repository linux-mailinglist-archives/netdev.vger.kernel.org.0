Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631C122F31A
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 16:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730143AbgG0Ox1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 10:53:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27141 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728593AbgG0Ox0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 10:53:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595861604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vsclEH4/HoXSeidb0EPcZes5Bz9S1rapf621nmEC7Bg=;
        b=BznM9slvSbHfcHGkcWoH3nIkHSqodPTjm/GHKwv3mDSFsM+y4iv0VR57ERxzkQw9Sn3MB/
        STuOAjFfmfs6q1NqXt5ZI4ClHcQlAKQeqpNa3CdV7K6loAOWQbXsPzDR85DlWgRcbBjd+R
        4GoYJvIWRePHnGyB0vlgKyzD2ij6A1M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-oen48mWPO5uFTpPc4DJpMg-1; Mon, 27 Jul 2020 10:53:23 -0400
X-MC-Unique: oen48mWPO5uFTpPc4DJpMg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67636C746F;
        Mon, 27 Jul 2020 14:53:21 +0000 (UTC)
Received: from krava (unknown [10.40.193.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EF75705A0;
        Mon, 27 Jul 2020 14:53:14 +0000 (UTC)
Date:   Mon, 27 Jul 2020 16:53:13 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        toke@redhat.com
Subject: Re: fentry/fexit attach to EXT type XDP program does not work
Message-ID: <20200727145313.GA1201271@krava>
References: <159162546868.10791.12432342618156330247.stgit@ebuild>
 <42b0c8d3-e855-7531-b01c-a05414360aff@fb.com>
 <88B08061-F85B-454C-9E9D-234154B9F000@redhat.com>
 <20200726122450.GC1175442@krava>
 <5CF6086F-412C-4934-9AC6-4B1821ADDF74@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5CF6086F-412C-4934-9AC6-4B1821ADDF74@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 09:59:14AM +0200, Eelco Chaudron wrote:
> 
> 
> On 26 Jul 2020, at 14:24, Jiri Olsa wrote:
> 
> > On Tue, Jun 09, 2020 at 10:52:34AM +0200, Eelco Chaudron wrote:
> > 
> > SNIP
> > 
> > > > >    libbpf: failed to load object 'test_xdp_bpf2bpf'
> > > > >    libbpf: failed to load BPF skeleton 'test_xdp_bpf2bpf': -4007
> > > > >    test_xdp_fentry_ext:FAIL:__load ftrace skeleton failed
> > > > >    #91 xdp_fentry_ext:FAIL
> > > > >    Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
> > > > > 
> > > > > Any idea what could be the case here? The same fentry/fexit attach
> > > > > code works fine in the xdp_bpf2bpf.c tests case.
> > > 
> > > <SNIP>
> > > > 
> > > > I think this is not supported now. That is, you cannot attach a
> > > > fentry
> > > > trace
> > > > to the EXT program. The current implementation for fentry
> > > > program simply
> > > > trying to find and match the signature of freplace program which by
> > > > default
> > > > is a pointer to void.
> > > > 
> > > > It is doable in that in kernel we could recognize to-be-attached
> > > > program
> > > > is
> > > > a freplace and further trace down to find the real signature. The
> > > > related
> > > > kernel function is btf_get_prog_ctx_type(). You can try to
> > > > implement by
> > > > yourself
> > > > or I can have a patch for this once bpf-next opens.
> > > 
> > > I’m not familiar with this area of the code, so if you could prepare
> > > a patch
> > > that would nice.
> > > You can also send it to me before bpf-next opens and I can verify
> > > it, and
> > > clean up the self-test so it can be included as well.
> > > 
> > 
> > hi,
> > it seems that you cannot exten fentry/fexit programs,
> > but it's possible to attach fentry/fexit to ext program.
> > 
> >    /* Program extensions can extend all program types
> >     * except fentry/fexit. The reason is the following.
> >     * The fentry/fexit programs are used for performance
> >     * analysis, stats and can be attached to any program
> >     * type except themselves. When extension program is
> >     * replacing XDP function it is necessary to allow
> >     * performance analysis of all functions. Both original
> >     * XDP program and its program extension. Hence
> >     * attaching fentry/fexit to BPF_PROG_TYPE_EXT is
> >     * allowed. If extending of fentry/fexit was allowed it
> >     * would be possible to create long call chain
> >     * fentry->extension->fentry->extension beyond
> >     * reasonable stack size. Hence extending fentry is not
> >     * allowed.
> >     */
> > 
> > I changed fexit_bpf2bpf.c test just to do a quick check
> > and it seems to work:
> 
> Hi Jiri this is exactly what I’m trying, however when you do this where the
> first argument is a pointer to some context data which you are accessing
> it’s failing in the verifier.
> This is a link to the original email, which has a test patch attached that
> will show the failure when trying to load/attach the fentry function and
> access the context:
> 
> https://lore.kernel.org/bpf/159162546868.10791.12432342618156330247.stgit@ebuild/

ok, I tried to trace ext program with __sk_buff argument and I can see
the issue as well.. can't acess the skb argument

patch below fixes it for me, I can access the skb pointer and its data
via probe read, like:

	SEC("fexit/new_get_skb_ifindex")
	int BPF_PROG(fexit_new_get_skb_ifindex, int val, struct __sk_buff *skb, int var, int ret)
	{
		__u32 data;
		int err;

		bpf_printk("EXIT skb %p", skb);
		bpf_probe_read_kernel(&data, sizeof(data), &skb->data);
		bpf_printk("EXIT ret %d, data %p", err, data);
		return 0;
	}

I think it should fix the xdp_md acess as well

jirka


---
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index ee36b7f60936..2145329f7b1b 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3828,6 +3828,10 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	}
 
 	info->reg_type = PTR_TO_BTF_ID;
+
+	if (tgt_prog && tgt_prog->type == BPF_PROG_TYPE_EXT)
+		tgt_prog = tgt_prog->aux->linked_prog;
+
 	if (tgt_prog) {
 		ret = btf_translate_to_vmlinux(log, btf, t, tgt_prog->type, arg);
 		if (ret > 0) {

