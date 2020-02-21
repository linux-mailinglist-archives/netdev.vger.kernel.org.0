Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 731A0167DE8
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 14:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgBUNEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 08:04:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37594 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728228AbgBUNEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 08:04:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582290274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jfTaPwFwfVfloTrqRo/jXrYI4mshzW51zNBd1o0glHQ=;
        b=D49EqNc0c4gq5fUyaNgg4bZgZgEy7Pv87Zxef3D9hLcztxM0LrbfllRK0bwcDdvEuwDlzO
        OEUt3SA+nny1HolZP+VWoqLw10HBzb2mcLivxh26oTLQJfqQJdPYwQChZA26cLS87SJrlV
        B07v7+M+ue2VZDv2c98k48mmKgt3H2s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-v6dgwrJhOJCFmKGlXm7isw-1; Fri, 21 Feb 2020 08:04:30 -0500
X-MC-Unique: v6dgwrJhOJCFmKGlXm7isw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C96F0101FC66;
        Fri, 21 Feb 2020 13:04:28 +0000 (UTC)
Received: from krava (unknown [10.43.17.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F0F6090F71;
        Fri, 21 Feb 2020 13:04:26 +0000 (UTC)
Date:   Fri, 21 Feb 2020 14:04:24 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix trampoline_count clean up
 logic
Message-ID: <20200221130424.GB652992@krava>
References: <20200220230546.769250-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220230546.769250-1-andriin@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 03:05:46PM -0800, Andrii Nakryiko wrote:
> Libbpf's Travis CI tests caught this issue. Ensure bpf_link and bpf_object
> clean up is performed correctly.
> 
> Fixes: d633d57902a5 ("selftest/bpf: Add test for allowed trampolines count")
> Cc: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  .../bpf/prog_tests/trampoline_count.c         | 25 +++++++++++++------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
> index 1f6ccdaed1ac..781c8d11604b 100644
> --- a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
> +++ b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
> @@ -55,31 +55,40 @@ void test_trampoline_count(void)
>  	/* attach 'allowed' 40 trampoline programs */
>  	for (i = 0; i < MAX_TRAMP_PROGS; i++) {
>  		obj = bpf_object__open_file(object, NULL);
> -		if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
> +		if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj))) {
> +			obj = NULL;
>  			goto cleanup;
> +		}
>  
>  		err = bpf_object__load(obj);
>  		if (CHECK(err, "obj_load", "err %d\n", err))
>  			goto cleanup;
>  		inst[i].obj = obj;
> +		obj = NULL;
>  
>  		if (rand() % 2) {
> -			link = load(obj, fentry_name);
> -			if (CHECK(IS_ERR(link), "attach prog", "err %ld\n", PTR_ERR(link)))
> +			link = load(inst[i].obj, fentry_name);
> +			if (CHECK(IS_ERR(link), "attach prog", "err %ld\n", PTR_ERR(link))) {
> +				link = NULL;
>  				goto cleanup;
> +			}
>  			inst[i].link_fentry = link;
>  		} else {
> -			link = load(obj, fexit_name);
> -			if (CHECK(IS_ERR(link), "attach prog", "err %ld\n", PTR_ERR(link)))
> +			link = load(inst[i].obj, fexit_name);
> +			if (CHECK(IS_ERR(link), "attach prog", "err %ld\n", PTR_ERR(link))) {
> +				link = NULL;
>  				goto cleanup;
> +			}
>  			inst[i].link_fexit = link;
>  		}
>  	}
>  
>  	/* and try 1 extra.. */
>  	obj = bpf_object__open_file(object, NULL);
> -	if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
> +	if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj))) {
> +		obj = NULL;
>  		goto cleanup;
> +	}
>  
>  	err = bpf_object__load(obj);
>  	if (CHECK(err, "obj_load", "err %d\n", err))
> @@ -104,7 +113,9 @@ void test_trampoline_count(void)
>  cleanup_extra:
>  	bpf_object__close(obj);
>  cleanup:
> -	while (--i) {
> +	if (i >= MAX_TRAMP_PROGS)
> +		i = MAX_TRAMP_PROGS - 1;
> +	for (; i >= 0; i--) {

ugh right, if we fail in first iteration, 'i' would get get -1 in here

thanks,
jirka

>  		bpf_link__destroy(inst[i].link_fentry);
>  		bpf_link__destroy(inst[i].link_fexit);
>  		bpf_object__close(inst[i].obj);
> -- 
> 2.17.1
> 

