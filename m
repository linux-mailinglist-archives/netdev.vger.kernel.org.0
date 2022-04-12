Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875694FE414
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 16:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356740AbiDLOrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 10:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350260AbiDLOrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 10:47:14 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36C81CFC1
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 07:44:55 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id j17so16231296pfi.9
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 07:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=btzB568iXxZj9oc1tZbDY7UAY4m0s81uXgV8WCBbWRs=;
        b=dXdSmaigsQfS8iGJpoICwbRXz1FWNpMiL0cOtSsxpoStwnZDu8idR451LAKSFR0LbD
         WBvG1gRSfyZYV+fpXfeukko3SJfNYwqBBWJGmH368YCyXpc3GjQLRHJq6vIV620Zi+C+
         GFPN/IEJRPMpd56zrExzJS0jJiBWd21Z60iyUL/GM29N6qb53l1kbEHeybz26ZVz+ITV
         URfnlKx+gP6pFW2MXUOvUqUzOrFbZF/+TM8xcIn+SIlL38WlpsDKUhhYuj6r1XUunWxP
         nKp8mhXWh6RIxt006y1145LhvFYYhb+W9I8OAXs/+QfyIKGlec+ytOV/2nbRrfaHcQkU
         OEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=btzB568iXxZj9oc1tZbDY7UAY4m0s81uXgV8WCBbWRs=;
        b=Q6z71dsP5DuWp5ghrUP0Z2ZsTUhlwFUfi0fjdIlOfXVxWydzpYktysug8zwuHl7/dX
         KH+Cw+jAO4H1tD+w6SQGRWKL0dyuMn6yxGZ4iF4fum8JrCYMqZVFeKB6USIb2jBL7EnO
         yfEGljzlqHnUHWUNcgpdSib+4x2Jg75m8oo2fG2npJo8Ez7pNAEBjsWCyzJrptzr4eCx
         BlaDz2YF5y6qHxoIeAyjF+t6hXHrmudURohUB6f1WeT08hgt+xLB+qbWrV+xWa1ixY1w
         +4pMS42ZXy2/Mlq+aJOlTkMY6orsh8pnSrpXth7YaBSJ4/DMNWMNic6NZTHR9cBpvf1C
         41Yw==
X-Gm-Message-State: AOAM5319CygJFIyCqu5Yeb4BFAqEyKdaAOfrCzCQdGNcRq4MrRaEPFVH
        xU1NSmj3E+4N9lJ8yKHNT1vL5g==
X-Google-Smtp-Source: ABdhPJyuBZy2IK9V/ErFnZBxqvPrcAs/xWo9/wak/gn6mPURlCcLf7O6F2HqUPE4EGla+ANGH2SvSg==
X-Received: by 2002:a63:2f46:0:b0:382:230f:b155 with SMTP id v67-20020a632f46000000b00382230fb155mr31794155pgv.64.1649774695275;
        Tue, 12 Apr 2022 07:44:55 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id w14-20020a63474e000000b0039cce486b9bsm3111136pgk.13.2022.04.12.07.44.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 07:44:54 -0700 (PDT)
Message-ID: <b20d6ee6-d1ba-5c15-a50a-2a49874d96b6@linaro.org>
Date:   Tue, 12 Apr 2022 07:44:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] bpf: Fix KASAN use-after-free Read in
 compute_effective_progs
Content-Language: en-US
To:     bpf@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com,
        Alexei Starovoitov <ast@kernel.org>
References: <20220405170356.43128-1-tadeusz.struk@linaro.org>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <20220405170356.43128-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/22 10:03, Tadeusz Struk wrote:
> Syzbot found a Use After Free bug in compute_effective_progs().
> The reproducer creates a number of BPF links, and causes a fault
> injected alloc to fail, while calling bpf_link_detach on them.
> Link detach triggers the link to be freed by bpf_link_free(),
> which calls __cgroup_bpf_detach() and update_effective_progs().
> If the memory allocation in this function fails, the function restores
> the pointer to the bpf_cgroup_link on the cgroup list, but the memory
> gets freed just after it returns. After this, every subsequent call to
> update_effective_progs() causes this already deallocated pointer to be
> dereferenced in prog_list_length(), and triggers KASAN UAF error.
> To fix this don't preserve the pointer to the link on the cgroup list
> in __cgroup_bpf_detach(), but proceed with the cleanup and retry calling
> update_effective_progs() again afterwards.
> 
> 
> Cc: "Alexei Starovoitov" <ast@kernel.org>
> Cc: "Daniel Borkmann" <daniel@iogearbox.net>
> Cc: "Andrii Nakryiko" <andrii@kernel.org>
> Cc: "Martin KaFai Lau" <kafai@fb.com>
> Cc: "Song Liu" <songliubraving@fb.com>
> Cc: "Yonghong Song" <yhs@fb.com>
> Cc: "John Fastabend" <john.fastabend@gmail.com>
> Cc: "KP Singh" <kpsingh@kernel.org>
> Cc: <netdev@vger.kernel.org>
> Cc: <bpf@vger.kernel.org>
> Cc: <stable@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> Link: https://syzkaller.appspot.com/bug?id=8ebf179a95c2a2670f7cf1ba62429ec044369db4
> Fixes: af6eea57437a ("bpf: Implement bpf_link-based cgroup BPF program attachment")
> Reported-by: <syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
>   kernel/bpf/cgroup.c | 25 ++++++++++++++-----------
>   1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 128028efda64..b6307337a3c7 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -723,10 +723,11 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>   	pl->link = NULL;
>   
>   	err = update_effective_progs(cgrp, atype);
> -	if (err)
> -		goto cleanup;
> -
> -	/* now can actually delete it from this cgroup list */
> +	/*
> +	 * Proceed regardless of error. The link and/or prog will be freed
> +	 * just after this function returns so just delete it from this
> +	 * cgroup list and retry calling update_effective_progs again later.
> +	 */
>   	list_del(&pl->node);
>   	kfree(pl);
>   	if (list_empty(progs))
> @@ -735,12 +736,11 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>   	if (old_prog)
>   		bpf_prog_put(old_prog);
>   	static_branch_dec(&cgroup_bpf_enabled_key[atype]);
> -	return 0;
>   
> -cleanup:
> -	/* restore back prog or link */
> -	pl->prog = old_prog;
> -	pl->link = link;
> +	/* In case of error call update_effective_progs again */
> +	if (err)
> +		err = update_effective_progs(cgrp, atype);
> +
>   	return err;
>   }
>   
> @@ -881,6 +881,7 @@ static void bpf_cgroup_link_release(struct bpf_link *link)
>   	struct bpf_cgroup_link *cg_link =
>   		container_of(link, struct bpf_cgroup_link, link);
>   	struct cgroup *cg;
> +	int err;
>   
>   	/* link might have been auto-detached by dying cgroup already,
>   	 * in that case our work is done here
> @@ -896,8 +897,10 @@ static void bpf_cgroup_link_release(struct bpf_link *link)
>   		return;
>   	}
>   
> -	WARN_ON(__cgroup_bpf_detach(cg_link->cgroup, NULL, cg_link,
> -				    cg_link->type));
> +	err = __cgroup_bpf_detach(cg_link->cgroup, NULL, cg_link,
> +				  cg_link->type);
> +	if (err)
> +		pr_warn("cgroup_bpf_detach() failed, err %d\n", err);
>   
>   	cg = cg_link->cgroup;
>   	cg_link->cgroup = NULL;

Hi,
Any feedback/comments on this one?

-- 
Thanks,
Tadeusz
