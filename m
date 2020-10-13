Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A9E28D4FF
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 21:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgJMT4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 15:56:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44801 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726848AbgJMT4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 15:56:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602618993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iwU7tK6msSXXjxmtdCmiDX1VSEEaziIZMs2Jkm9hIlI=;
        b=Y9w4k85b5WKwhdc6Y7huZB53XuC69O5rhkZT/fpRPsFc6jZCkpj7ff3XlW8M+iSs9Huy6W
        1pAqdpza4Kj5tIorXSgwzx/Xm8vBQRRW46GEyyViieEJxLh3DoZWIXjqTs8UnISeZbDmGd
        7AQZNfRgyYUiPosLTPcb4UUUV/BRzaQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-Auzav5HPNgCSQebp_c0R_w-1; Tue, 13 Oct 2020 15:56:29 -0400
X-MC-Unique: Auzav5HPNgCSQebp_c0R_w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF6B61015C85;
        Tue, 13 Oct 2020 19:56:27 +0000 (UTC)
Received: from krava (unknown [10.40.193.3])
        by smtp.corp.redhat.com (Postfix) with SMTP id 393F65D9CD;
        Tue, 13 Oct 2020 19:56:24 +0000 (UTC)
Date:   Tue, 13 Oct 2020 21:56:22 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 3/4] selftests/bpf: Add profiler test
Message-ID: <20201013195622.GB1305928@krava>
References: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
 <20201009011240.48506-4-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009011240.48506-4-alexei.starovoitov@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 06:12:39PM -0700, Alexei Starovoitov wrote:

SNIP

> +
> +#ifdef UNROLL
> +#pragma unroll
> +#endif
> +	for (int i = 0; i < MAX_CGROUPS_PATH_DEPTH; i++) {
> +		filepart_length =
> +			bpf_probe_read_str(payload, MAX_PATH, BPF_CORE_READ(cgroup_node, name));
> +		if (!cgroup_node)
> +			return payload;
> +		if (cgroup_node == cgroup_root_node)
> +			*root_pos = payload - payload_start;
> +		if (filepart_length <= MAX_PATH) {
> +			barrier_var(filepart_length);
> +			payload += filepart_length;
> +		}
> +		cgroup_node = BPF_CORE_READ(cgroup_node, parent);
> +	}
> +	return payload;
> +}
> +
> +static ino_t get_inode_from_kernfs(struct kernfs_node* node)
> +{
> +	struct kernfs_node___52* node52 = (void*)node;
> +
> +	if (bpf_core_field_exists(node52->id.ino)) {
> +		barrier_var(node52);
> +		return BPF_CORE_READ(node52, id.ino);
> +	} else {
> +		barrier_var(node);
> +		return (u64)BPF_CORE_READ(node, id);
> +	}
> +}
> +
> +int pids_cgrp_id = 1;


hi,
I'm getting compilation failure with this:

	  CLNG-LLC [test_maps] profiler2.o
	In file included from progs/profiler2.c:6:
	progs/profiler.inc.h:246:5: error: redefinition of 'pids_cgrp_id' as different kind of symbol
	int pids_cgrp_id = 1;
	    ^
	/home/jolsa/linux-qemu/tools/testing/selftests/bpf/tools/include/vmlinux.h:14531:2: note: previous definition is here
		pids_cgrp_id = 11,
		^
	1 error generated.
	/opt/clang/bin/llc: error: /opt/clang/bin/llc: <stdin>:1:1: error: expected top-level entity
	BPF obj compilation failed
	^
	make: *** [Makefile:396: /home/jolsa/linux-qemu/tools/testing/selftests/bpf/profiler2.o] Error 1

jirka

