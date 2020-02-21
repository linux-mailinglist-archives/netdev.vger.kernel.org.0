Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A56167AAE
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 11:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbgBUKVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 05:21:55 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45036 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728340AbgBUKVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 05:21:54 -0500
Received: by mail-wr1-f65.google.com with SMTP id m16so1349856wrx.11
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 02:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=TmLwkk/guKqTf/mHwOqxZQJ3jMcnhln4oOrXZAv8WVI=;
        b=o+89ohl6SOF3YcWZpZYxBAZTtjPO+VGOXRLEbKwnFyvA8ZhNG6EBiWz6phPo7v19rB
         LafL/6TPnNh0Nmd2o4NKYNC1MoPm6fctpwoRxpu8eoREwNbwj9UzDLFI+e8shO1drJge
         VIKDrlQE8+rQAhiaktSeSWw+miKBFZIDpe1kw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=TmLwkk/guKqTf/mHwOqxZQJ3jMcnhln4oOrXZAv8WVI=;
        b=cxv/FCAHGg94L04L9XnqFh60JGkCWn78iinOzgBZiDSKdnSWY24ftIxBpD65Z8nWoY
         6rSMjDL34uaFhkfvT8FfLrJ97Hy5onp4Zj/fA93K+S8izATHeqYGPNErBc7n7eXSxAvR
         Be+lQ1koN6B6XYefnGlpLqwXaMxjRcJQbPEYurkMl0tVbu5WotldDuyRvswmgVx2ObZy
         T77+Ln7dLsqf265r0EvZ0lDO+D4QB/JJ2dtr6p4zDf1PE22zoMvafslxAPngGkFxYOYb
         o6X+jfea9DgXu83TidWygDSByimeTeWVZD4pIvkW7dzHXGEpAFZThF7laImDqoWpfYM0
         TpXg==
X-Gm-Message-State: APjAAAVDbGXVDc8fukEBg8Ja1C5C5VHwBKN/nnA3KGyCAhJ9Ng+U5iYL
        6zOXQhiTPihgN0Dpk1Q+QjdYvg==
X-Google-Smtp-Source: APXvYqwPAOXXpm6RrCPNTkSjuPOPXHMR1kjljwMWXeVQ6ovvtkEWsTihXAvM9mZhJC0/hkgj18gEYw==
X-Received: by 2002:a5d:6151:: with SMTP id y17mr47108565wrt.110.1582280512481;
        Fri, 21 Feb 2020 02:21:52 -0800 (PST)
Received: from cloudflare.com ([88.157.168.82])
        by smtp.gmail.com with ESMTPSA id c9sm3172427wmc.47.2020.02.21.02.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 02:21:52 -0800 (PST)
References: <20200220230546.769250-1-andriin@fb.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix trampoline_count clean up logic
In-reply-to: <20200220230546.769250-1-andriin@fb.com>
Date:   Fri, 21 Feb 2020 10:21:51 +0000
Message-ID: <87eeuo5jgg.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 11:05 PM GMT, Andrii Nakryiko wrote:
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
>  		bpf_link__destroy(inst[i].link_fentry);
>  		bpf_link__destroy(inst[i].link_fexit);
>  		bpf_object__close(inst[i].obj);

I'm not sure I'm grasping what the fix is about.

We don't access obj or link from cleanup, so what is the point of
setting them to NULL before jumping there?

Or is it all just an ancillary change to clamping the loop index
variable to (MAX_TRAMP_PROGS - 1)?
