Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6D6231AF7
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 10:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgG2IP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 04:15:27 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:59819 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726336AbgG2IP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 04:15:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596010525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PUK1vUvNMFJqPqCN7rixVJ6pFpFUJ96T8n6RHgQXYPs=;
        b=X1FITsKVEgS2LlihBMF2Occd0RyQExKtygDyp2pKKGbhIK6tiAlWebSCMyauNJTJwWC8ui
        p+wlT+KwbGLu7d5LReqnzaRxSatznV21DjVaYGJsFasP4tY0ccE3yjHWdm3NAX2DbsnwVI
        FMkbZdy+wk1b9c3HPPLT3mXJsGvBNJE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-2fJNoF7XOCOZknvZQcLkdQ-1; Wed, 29 Jul 2020 04:09:13 -0400
X-MC-Unique: 2fJNoF7XOCOZknvZQcLkdQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47DF7106B242;
        Wed, 29 Jul 2020 08:09:12 +0000 (UTC)
Received: from krava (unknown [10.40.193.247])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEDED10001B3;
        Wed, 29 Jul 2020 08:09:06 +0000 (UTC)
Date:   Wed, 29 Jul 2020 10:09:05 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        toke@redhat.com
Subject: Re: fentry/fexit attach to EXT type XDP program does not work
Message-ID: <20200729080905.GG1319041@krava>
References: <159162546868.10791.12432342618156330247.stgit@ebuild>
 <42b0c8d3-e855-7531-b01c-a05414360aff@fb.com>
 <88B08061-F85B-454C-9E9D-234154B9F000@redhat.com>
 <20200726122450.GC1175442@krava>
 <5CF6086F-412C-4934-9AC6-4B1821ADDF74@redhat.com>
 <20200727145313.GA1201271@krava>
 <95AF8533-2C7D-4038-AD39-4C81DBF25551@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <95AF8533-2C7D-4038-AD39-4C81DBF25551@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 08:23:56AM +0200, Eelco Chaudron wrote:

SNIP

> > > > > a patch
> > > > > that would nice.
> > > > > You can also send it to me before bpf-next opens and I can verify
> > > > > it, and
> > > > > clean up the self-test so it can be included as well.
> > > > > 
> > > > 
> > > > hi,
> > > > it seems that you cannot exten fentry/fexit programs,
> > > > but it's possible to attach fentry/fexit to ext program.
> > > > 
> > > >    /* Program extensions can extend all program types
> > > >     * except fentry/fexit. The reason is the following.
> > > >     * The fentry/fexit programs are used for performance
> > > >     * analysis, stats and can be attached to any program
> > > >     * type except themselves. When extension program is
> > > >     * replacing XDP function it is necessary to allow
> > > >     * performance analysis of all functions. Both original
> > > >     * XDP program and its program extension. Hence
> > > >     * attaching fentry/fexit to BPF_PROG_TYPE_EXT is
> > > >     * allowed. If extending of fentry/fexit was allowed it
> > > >     * would be possible to create long call chain
> > > >     * fentry->extension->fentry->extension beyond
> > > >     * reasonable stack size. Hence extending fentry is not
> > > >     * allowed.
> > > >     */
> > > > 
> > > > I changed fexit_bpf2bpf.c test just to do a quick check
> > > > and it seems to work:
> > > 
> > > Hi Jiri this is exactly what I’m trying, however when you do this
> > > where the
> > > first argument is a pointer to some context data which you are
> > > accessing
> > > it’s failing in the verifier.
> > > This is a link to the original email, which has a test patch
> > > attached that
> > > will show the failure when trying to load/attach the fentry function
> > > and
> > > access the context:
> > > 
> > > https://lore.kernel.org/bpf/159162546868.10791.12432342618156330247.stgit@ebuild/
> > 
> > ok, I tried to trace ext program with __sk_buff argument and I can see
> > the issue as well.. can't acess the skb argument
> > 
> > patch below fixes it for me, I can access the skb pointer and its data
> > via probe read, like:
> > 
> > 	SEC("fexit/new_get_skb_ifindex")
> > 	int BPF_PROG(fexit_new_get_skb_ifindex, int val, struct __sk_buff *skb,
> > int var, int ret)
> > 	{
> > 		__u32 data;
> > 		int err;
> > 
> > 		bpf_printk("EXIT skb %p", skb);
> > 		bpf_probe_read_kernel(&data, sizeof(data), &skb->data);
> > 		bpf_printk("EXIT ret %d, data %p", err, data);
> > 		return 0;
> > 	}
> > 
> > I think it should fix the xdp_md acess as well
> 
> Excellent patch ;) It works with xdp_md as well, and even better it does not
> require the bpf_probe_read_kernel(), so the test_xdp_bpf2bpf.c code just
> works.

great ;-) will check on xdp_md

> 
> Are you planning to send the patch upstream?

yep, I'll add some test for that and send it

thanks,
jirka

