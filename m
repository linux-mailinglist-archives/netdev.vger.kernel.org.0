Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D10295C2F
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 11:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895869AbgJVJsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 05:48:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54762 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2509966AbgJVJsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 05:48:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603360086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9XQkLZVZQx4DjBArygkCNODq84ypuNcvahgE7zZrd14=;
        b=LCq3qDfeBxv1MHOIlnzSjVCsU82YLE/EImLEFLn19bDnkB+BrGRInWRkhbZC1oWLJ4/4eU
        rF6ia1EL/Rp0p+eY+TKuimeYDyFdBRYUWa8wKQ9kCwIbUlV3VPsbBjthUZujKShqlE0iUV
        /o7RcIyra/Y0uudQ8NYaA7xdzWsVi7Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-yE851czBOIOUzGIEnaaPHQ-1; Thu, 22 Oct 2020 05:48:02 -0400
X-MC-Unique: yE851czBOIOUzGIEnaaPHQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C12A186DD29;
        Thu, 22 Oct 2020 09:48:01 +0000 (UTC)
Received: from krava (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with SMTP id 23F3E19C4F;
        Thu, 22 Oct 2020 09:47:58 +0000 (UTC)
Date:   Thu, 22 Oct 2020 11:47:58 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net,
        john.fastabend@gmail.com, jolsa@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/3] bpf: Pointers beyond packet end.
Message-ID: <20201022094758.GC2318292@krava>
References: <20201021182015.39000-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021182015.39000-1-alexei.starovoitov@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 11:20:12AM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> In some cases LLVM uses the knowledge that branch is taken to optimze the code
> which causes the verifier to reject valid programs.
> Teach the verifier to recognize that
> r1 = skb->data;
> r1 += 10;
> r2 = skb->data_end;
> if (r1 > r2) {
>   here r1 points beyond packet_end and subsequent
>   if (r1 > r2) // always evaluates to "true".
> }
> 
> Alexei Starovoitov (3):
>   bpf: Support for pointers beyond pkt_end.
>   selftests/bpf: Add skb_pkt_end test
>   selftests/bpf: Add asm tests for pkt vs pkt_end comparison.

Tested-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

> 
>  include/linux/bpf_verifier.h                  |   2 +-
>  kernel/bpf/verifier.c                         | 131 +++++++++++++++---
>  .../bpf/prog_tests/test_skb_pkt_end.c         |  41 ++++++
>  .../testing/selftests/bpf/progs/skb_pkt_end.c |  54 ++++++++
>  .../testing/selftests/bpf/verifier/ctx_skb.c  |  42 ++++++
>  5 files changed, 247 insertions(+), 23 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_skb_pkt_end.c
>  create mode 100644 tools/testing/selftests/bpf/progs/skb_pkt_end.c
> 
> -- 
> 2.23.0
> 

