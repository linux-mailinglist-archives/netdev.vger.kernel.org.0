Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC149234861
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 17:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgGaPYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 11:24:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55904 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726497AbgGaPYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 11:24:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596209079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AU1g5/YO071lOiefjmjUSK8NEKkezt1M1VCckB1QwQw=;
        b=fIlD92Fne2bmleQke9R/vZU6csaDAWBdvL7dqttsgzU7aZNKrdwncC0yVL0eXVxnlVQgdK
        8RtJl336Oi3BThd38Z/ipisl3UEdxVuhDhGsncVISY5DJ4S8P4lqCiknuCH5MmHiD6gxxs
        R0pb3HEz8z3hfdAWOQnWbpI50QyFm7I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-aElfc4omM6uzx_PJEc0UOg-1; Fri, 31 Jul 2020 11:24:37 -0400
X-MC-Unique: aElfc4omM6uzx_PJEc0UOg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71651101C8A0;
        Fri, 31 Jul 2020 15:24:35 +0000 (UTC)
Received: from krava (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with SMTP id BDAE019D9E;
        Fri, 31 Jul 2020 15:24:33 +0000 (UTC)
Date:   Fri, 31 Jul 2020 17:24:32 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        jolsa@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2020-07-31
Message-ID: <20200731152432.GA4296@krava>
References: <20200731135145.15003-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731135145.15003-1-daniel@iogearbox.net>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 03:51:45PM +0200, Daniel Borkmann wrote:
> Hi David,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 5 non-merge commits during the last 21 day(s) which contain
> a total of 5 files changed, 126 insertions(+), 18 deletions(-).
> 
> The main changes are:
> 
> 1) Fix a map element leak in HASH_OF_MAPS map type, from Andrii Nakryiko.
> 
> 2) Fix a NULL pointer dereference in __btf_resolve_helper_id() when no
>    btf_vmlinux is available, from Peilin Ye.
> 
> 3) Init pos variable in __bpfilter_process_sockopt(), from Christoph Hellwig.
> 
> 4) Fix a cgroup sockopt verifier test by specifying expected attach type,
>    from Jean-Philippe Brucker.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git
> 
> Thanks a lot!
> 
> Note that when net gets merged into net-next later on, there is a small
> merge conflict in kernel/bpf/btf.c between commit 5b801dfb7feb ("bpf: Fix
> NULL pointer dereference in __btf_resolve_helper_id()") from the bpf tree
> and commit 138b9a0511c7 ("bpf: Remove btf_id helpers resolving") from the
> net-next tree.
> 
> Resolve as follows: remove the old hunk with the __btf_resolve_helper_id()
> function. Change the btf_resolve_helper_id() so it actually tests for a
> NULL btf_vmlinux and bails out:
> 
> int btf_resolve_helper_id(struct bpf_verifier_log *log,
>                           const struct bpf_func_proto *fn, int arg)
> {
>         int id;
> 
>         if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID || !btf_vmlinux)
>                 return -EINVAL;
>         id = fn->btf_id[arg];
>         if (!id || id > btf_vmlinux->nr_types)
>                 return -EINVAL;
>         return id;
> }
> 
> Let me know if you run into any others issues (CC'ing Jiri Olsa so he's in
> the loop with regards to merge conflict resolution).

we'll loose the bpf_log message, but I'm fine with that ;-) looks good

thanks,
jirka

