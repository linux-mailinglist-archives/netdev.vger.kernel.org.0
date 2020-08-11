Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2A9241702
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 09:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgHKHOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 03:14:51 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45845 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726421AbgHKHOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 03:14:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597130089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uTqevzskIuxr2fW9mxCLYhc+F3dSF+3vsiY5yqTWqEo=;
        b=eIreTP8qO6wWwweLD1qVPvtadUsCFMrlzvz3fH4rYicfEk/6LS3/exb8aWj9FZS6T2sAaJ
        4cJzPYymhiSykWjOVwdT8D79GgqqvZHMn3kbdq4P2VZCkVq4x3xlE9DE8P/xiRNt5q4jJT
        1PuMqe+YAjUKqHQui/LHEiyQ1TyejSs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-vtSkwn9COCO6syPSMZCdFA-1; Tue, 11 Aug 2020 03:14:44 -0400
X-MC-Unique: vtSkwn9COCO6syPSMZCdFA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 274E280183C;
        Tue, 11 Aug 2020 07:14:43 +0000 (UTC)
Received: from krava (unknown [10.40.193.75])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2B2587C0F5;
        Tue, 11 Aug 2020 07:14:39 +0000 (UTC)
Date:   Tue, 11 Aug 2020 09:14:38 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC] bpf: verifier check for dead branch
Message-ID: <20200811071438.GC699846@krava>
References: <20200807173045.GC561444@krava>
 <f13fde40-0c07-ff73-eeb3-3c59c5694f74@fb.com>
 <20200810135451.GA699846@krava>
 <e4abe45b-2c80-9448-677c-e352f0ecb24e@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4abe45b-2c80-9448-677c-e352f0ecb24e@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 10:16:12AM -0700, Yonghong Song wrote:

SNIP

> 
> Thanks for the test case. I can reproduce the issue. The following
> is why this happens in llvm.
> the pseudo IR code looks like
>    data = skb->data
>    data_end = skb->data_end
>    comp = data + 42 > data_end
>    ip = select "comp" nullptr "data + some offset"
>          <=== select return one of nullptr or "data + some offset" based on
> "comp"
>    if comp   // original skb_shorter condition
>       ....
>    ...
>       = ip
> 
> In llvm, bpf backend "select" actually inlined "comp" to generate proper
> control flow. Therefore, comp is computed twice like below
>    data = skb->data
>    data_end = skb->data_end
>    if (data + 42 > data_end) {
>       ip = nullptr; goto block1;
>    } else {
>       ip = data + some_offset;
>       goto block2;
>    }
>    ...
>    if (data + 42 > data_end) // original skb_shorter condition
> 
> The issue can be workarounded the source. Just check data + 42 > data_end
> and if failure return. Then you will be able to assign
> a value to "ip" conditionally.

is the change below what you mean? it produces the same code for me:

	diff --git a/tools/testing/selftests/bpf/progs/verifier-cond-repro.c b/tools/testing/selftests/bpf/progs/verifier-cond-repro.c
	index 2f11027d7e67..9c401bd00ab7 100644
	--- a/tools/testing/selftests/bpf/progs/verifier-cond-repro.c
	+++ b/tools/testing/selftests/bpf/progs/verifier-cond-repro.c
	@@ -41,12 +41,10 @@ static INLINE struct iphdr *get_iphdr (struct __sk_buff *skb)
		struct ethhdr *eth;
	 
		if (skb_shorter(skb, ETH_IPV4_UDP_SIZE))
	-		goto out;
	+		return NULL;
	 
		eth = (void *)(long)skb->data;
		ip = (void *)(eth + 1);
	-
	-out:
		return ip;
	 }
	 

I also tried this one:

	diff --git a/tools/testing/selftests/bpf/progs/verifier-cond-repro.c b/tools/testing/selftests/bpf/progs/verifier-cond-repro.c
	index 2f11027d7e67..00ff06fe6fdd 100644
	--- a/tools/testing/selftests/bpf/progs/verifier-cond-repro.c
	+++ b/tools/testing/selftests/bpf/progs/verifier-cond-repro.c
	@@ -57,7 +57,7 @@ int my_prog(struct __sk_buff *skb)
		__u8 proto = 0;
	 
		if (!(ip = get_iphdr(skb)))
	-               goto out;
	+               return -1;
	 
		proto = ip->protocol;

it did just slight change in generated code - added 'w0 = -1'
before the second condition

> 
> Will try to fix this issue in llvm12 as well.
> Thanks!

great, could you please CC me on the changes?

thanks a lot!
jirka

