Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C286207A14
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405437AbgFXRSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405280AbgFXRSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 13:18:50 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9A8C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:18:48 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id d7so1677572lfi.12
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=VRK4NUDCzmf4Cc/2FGqRoSzQq0rIAZIjgN/TSq09gqc=;
        b=DsNWxMCDX9Yt/HYHEp7XXvu0ih/2hXDuC4FSG0NfwzLKCAP8Mcl2xs5yO09krjvbdP
         M41Wp7hDZKxBCCQu/XY+R5KJAgw8vmfKTm4tTXUZmpq9vVZ/aGLpEbsk/mqshI2XbXRN
         mT1s0EpkNlQx0415+HxTw9q/yGwDH8+3AuLsE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=VRK4NUDCzmf4Cc/2FGqRoSzQq0rIAZIjgN/TSq09gqc=;
        b=tDKzxujaS/1eCBAIIVQtAIC8gmpigGAW5q9DLmSmLGIvUGqyHy9iD6RhQUzIFYnGW1
         v0ZmUzd1jVli/Cc3FF5kOV+s7yqEyBWREv34HeVYmRavWRcwQ/uIHHks8DHwe954OVFC
         p14KfEtbS9eSFjHWJ9v+7ZXsVtMeDJdEE6ey2y8sz/FFwoarbDLITDfQ5DHCYhkPu1xy
         iwPKJmdDHY0gAHp/tGyP2RYPOPAM/pJvc5f47TDqTuo6VQ+YY8daforx6+oHt+f0ETPV
         weMnrOIN2nCAZqhXNyYjetRHfn6gvmnWgzJZ5xCfZqC1Uez0LxGyI97Qq0IsvSXS+GFy
         ikTQ==
X-Gm-Message-State: AOAM530ZFXXjTF529DoLO5xHnvG5pZkYLVrh2a9j+WZL+6fPKIupHR0w
        riWw78YwRc5aSvW5pvgTaGbIuQ==
X-Google-Smtp-Source: ABdhPJwgQE5Zz1gX9D/Hzz7ClbrRROoIUm162OppyK0Fg3078vcyueXsgbe9nVJXGR1cZVf/ihp9CQ==
X-Received: by 2002:a19:c78d:: with SMTP id x135mr15947474lff.82.1593019127145;
        Wed, 24 Jun 2020 10:18:47 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id n21sm4297381ljj.97.2020.06.24.10.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 10:18:46 -0700 (PDT)
References: <20200623103459.697774-1-jakub@cloudflare.com> <20200623103459.697774-3-jakub@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v2 2/3] bpf, netns: Keep attached programs in bpf_prog_array
In-reply-to: <20200623103459.697774-3-jakub@cloudflare.com>
Date:   Wed, 24 Jun 2020 19:18:42 +0200
Message-ID: <87o8p8mlfx.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 12:34 PM CEST, Jakub Sitnicki wrote:
> Prepare for having multi-prog attachments for new netns attach types by
> storing programs to run in a bpf_prog_array, which is well suited for
> iterating over programs and running them in sequence.
>
> Because bpf_prog_array is dynamically resized, after this change a
> potentially blocking memory allocation in bpf(PROG_QUERY) callback can
> happen, in order to collect program IDs before copying the values to
> user-space supplied buffer. This forces us to adapt how we protect access
> to the attached program in the callback. As bpf_prog_array_copy_to_user()
> helper can sleep, we switch from an RCU read lock to holding a mutex that
> serializes updaters.
>
> To handle bpf(PROG_ATTACH) scenario when we are replacing an already
> attached program, we introduce a new bpf_prog_array helper called
> bpf_prog_array_replace_item that will exchange the old program with a new
> one. bpf-cgroup does away with such helper by computing an index into the
> array from a program position in an external list of attached
> programs/links. Such approach fails when a dummy prog is left in the array
> after a memory allocation failure on link release, but is necessary in
> bpf-cgroup case because the same BPF program can be present in the array
> multiple times due to inheritance, and attachment cannot be reliably
> identified by bpf_prog pointer comparison.
>
> No functional changes intended.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  include/linux/bpf.h        |   3 +
>  include/net/netns/bpf.h    |   5 +-
>  kernel/bpf/core.c          |  20 ++++--
>  kernel/bpf/net_namespace.c | 137 +++++++++++++++++++++++++++----------
>  net/core/flow_dissector.c  |  21 +++---
>  5 files changed, 132 insertions(+), 54 deletions(-)
>

[...]

> diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
> index b951dab2687f..593523a22168 100644
> --- a/kernel/bpf/net_namespace.c
> +++ b/kernel/bpf/net_namespace.c

[...]

> @@ -93,8 +108,16 @@ static int bpf_netns_link_update_prog(struct bpf_link *link,
>  		goto out_unlock;
>  	}
>
> +	run_array = rcu_dereference_protected(net->bpf.run_array[type],
> +					      lockdep_is_held(&netns_bpf_mutex));
> +	if (run_array)
> +		ret = bpf_prog_array_replace_item(run_array, link->prog, new_prog);

Thinking about this some more, link update should fail with -EINVAL if
new_prog already exists in run_array. Same as PROG_ATTACH fails with
-EINVAL when trying to attach the same prog for the second time.

Otherwise, LINK_UPDATE can lead to having same BPF prog present multiple
times in the prog_array, once attaching more than one prog gets enabled.

Then we would we end up with the same challenge as bpf-cgroup, that is
how to find the program index into the prog_array in presence of
dummy_prog's.

> +	else
> +		ret = -ENOENT;
> +	if (ret)
> +		goto out_unlock;
> +
>  	old_prog = xchg(&link->prog, new_prog);
> -	rcu_assign_pointer(net->bpf.progs[type], new_prog);
>  	bpf_prog_put(old_prog);
>
>  out_unlock:

[...]

> @@ -217,14 +249,25 @@ int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>  	if (ret)
>  		goto out_unlock;
>
> -	attached = rcu_dereference_protected(net->bpf.progs[type],
> -					     lockdep_is_held(&netns_bpf_mutex));
> +	attached = net->bpf.progs[type];
>  	if (attached == prog) {
>  		/* The same program cannot be attached twice */
>  		ret = -EINVAL;
>  		goto out_unlock;
>  	}
> -	rcu_assign_pointer(net->bpf.progs[type], prog);
> +
> +	run_array = rcu_dereference_protected(net->bpf.run_array[type],
> +					      lockdep_is_held(&netns_bpf_mutex));
> +	if (run_array) {
> +		ret = bpf_prog_array_replace_item(run_array, attached, prog);

I didn't consider here that there can be a run_array with a dummy_prog
from a link release that failed to allocate memory.

In such case bpf_prog_array_replace_item will fail, while we actually
want to replace the dummy_prog.

The right thing to do is to replace the first item in prog array:

	if (run_array) {
		WRITE_ONCE(run_array->items[0].prog, prog);
	} else {
                /* allocate a bpf_prog_array */
        }

This leaves just one user of bpf_prog_array_replace_item(), so I think
I'm just going to fold it into its only caller, that is the update_prog
callback.

> +	} else {
> +		ret = bpf_prog_array_copy(NULL, NULL, prog, &run_array);
> +		rcu_assign_pointer(net->bpf.run_array[type], run_array);
> +	}
> +	if (ret)
> +		goto out_unlock;
> +
> +	net->bpf.progs[type] = prog;
>  	if (attached)
>  		bpf_prog_put(attached);
>

[...]
