Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00455234AA3
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387661AbgGaSIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 14:08:13 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54270 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730040AbgGaSIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 14:08:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596218892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KkBcthLhdgcdVY5kQ1Abco4F2of49EuasnuDiDQxBXc=;
        b=eT9Jtu8sz3SMXTiJ0xTc5SBiNSwwDoLbN0sovEblMe46SkfyXU00QGwRULn+jVzQdLgABe
        4rAy8AmBAR8V39d974IrEspHMbLJYPRyUsYVu6uAPLaTdtB9YAEHKI/3SgVolCzIOWkFtK
        AUn8ZNODo86eEt9v3dJj91d0pxjrX1k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-678_S1YvMWqUBPfkLBRz_A-1; Fri, 31 Jul 2020 14:08:10 -0400
X-MC-Unique: 678_S1YvMWqUBPfkLBRz_A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68AA2800597;
        Fri, 31 Jul 2020 18:08:08 +0000 (UTC)
Received: from krava (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with SMTP id A936860BE2;
        Fri, 31 Jul 2020 18:08:06 +0000 (UTC)
Date:   Fri, 31 Jul 2020 20:08:05 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        jolsa@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2020-07-31
Message-ID: <20200731180805.GA27597@krava>
References: <20200731135145.15003-1-daniel@iogearbox.net>
 <20200731152432.GA4296@krava>
 <03545f38-c01a-faeb-adab-a0a471ff9fc3@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03545f38-c01a-faeb-adab-a0a471ff9fc3@iogearbox.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 06:12:48PM +0200, Daniel Borkmann wrote:

SNIP

> > >                  return -EINVAL;
> > >          return id;
> > > }
> > > 
> > > Let me know if you run into any others issues (CC'ing Jiri Olsa so he's in
> > > the loop with regards to merge conflict resolution).
> > 
> > we'll loose the bpf_log message, but I'm fine with that ;-) looks good
> 
> Checking again on the fix, even though it was only triggered by syzkaller
> so far, I think it's also possible if users don't have BTF debug data set
> in the Kconfig but use a helper that expects it, so agree, lets re-add the
> log in this case:
> 
> int btf_resolve_helper_id(struct bpf_verifier_log *log,
>                           const struct bpf_func_proto *fn, int arg)
> {
>         int id;
> 
>         if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID)
>                 return -EINVAL;
>         if (!btf_vmlinux) {
>                 bpf_log(log, "btf_vmlinux doesn't exist\n");
>                 return -EINVAL;
>         }
>         id = fn->btf_id[arg];
>         if (!id || id > btf_vmlinux->nr_types)
>                 return -EINVAL;
>         return id;
> }

ok, looks good
jirka

