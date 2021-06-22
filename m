Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABD93B0FC6
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 00:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhFVWDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 18:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbhFVWC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 18:02:58 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C99FC061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 15:00:41 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id l11so244034pji.5
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 15:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kuajKqzpWjCiwmekj9qI0WNU1KHn52SeYYwuwPJd5DM=;
        b=pWp2zjRHHO3BLCn+0kvGaPjEQZdLxJmYfL4Pq/RtZOTBH7H3xR6Tj7Q9orknqfeHV7
         rPVvfm2fUaUGTIVcbZAITRR6t8FM4LaA82A2ARbOhzDUddLZ/rQT5hgQgT7j+4XVzeEK
         yh6uaYsy7v2FUP8e7PMTuIiG21bBanPwhW06mP8F2LzlLMz+mItxTtvdynwkMY1wSdys
         xidvtaRALL7l52RhdBlN8Ts57F5S8AmISlCe3v5PTWh6DxgOUf//p85Gfx2z9PQ/Rqy7
         v+8CK9lHxtGw/efOGt77VQAAOvdF9HLG8D35/3ssPyA87BMsFXtw4H2NEAhUqURLW08V
         MPQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kuajKqzpWjCiwmekj9qI0WNU1KHn52SeYYwuwPJd5DM=;
        b=LY8qHOdGw7fggDu1FftnB5UOGfVaw+2grwxZyxR9EQNUcP8UZ/BLxCdYFX22HWSd4A
         v+waovJg/gGbK6eqxSyf49oEblMxAMUyvVzwCtEwgb9ax/jKK8ZInK6M3mB8tNK7Tno3
         m11DmG3aoc2LG15risZkcDSA9kraf4RsZgK6JhNGzu7asqt5k+P4aDXdFQk3EREgCcxE
         x1dEksDhhmCMvJ3uAi4yaqQgGIPtMiyzENXx7PhnPqNxmKJm5IMU63l1kX7Dw4KE5MZM
         l4DgaTLpHQT4zOfwTSbG6VLdlQQl6mrEk1V4wzRWKDSOLMKHh6fY5zutzIp7AysGW8CU
         ixuA==
X-Gm-Message-State: AOAM531N8pla2fFfn4x2j6d1Tey2qSbV6veLwBw42zOkvRMNrpcsKj9W
        2mRYcYtsKLKlhsRA/VzQJww=
X-Google-Smtp-Source: ABdhPJyJO95x1K6+TBo6WxAYiQgu0NzzyCAnr+e1rueWmoZvvHC/qooFAl9HBQeXw2kEiGfBuNnhMA==
X-Received: by 2002:a17:902:8ec9:b029:11f:f1dc:6c8d with SMTP id x9-20020a1709028ec9b029011ff1dc6c8dmr24428460plo.34.1624399240911;
        Tue, 22 Jun 2021 15:00:40 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:2af4])
        by smtp.gmail.com with ESMTPSA id a23sm273465pfn.117.2021.06.22.15.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 15:00:40 -0700 (PDT)
Date:   Tue, 22 Jun 2021 15:00:37 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     maciej.fijalkowski@intel.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com, netdev@vger.kernel.org
Subject: Re: [PATCH bpf v2 3/4] bpf: track subprog poke correctly
Message-ID: <20210622220037.6uwrba6tl7vofcu5@ast-mbp.dhcp.thefacebook.com>
References: <162388400488.151936.1658153981415911010.stgit@john-XPS-13-9370>
 <162388413965.151936.16775592753297385087.stgit@john-XPS-13-9370>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162388413965.151936.16775592753297385087.stgit@john-XPS-13-9370>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 03:55:39PM -0700, John Fastabend wrote:
>  
> -static void bpf_free_used_maps(struct bpf_prog_aux *aux)
> +void bpf_free_used_maps(struct bpf_prog_aux *aux)
>  {
>  	__bpf_free_used_maps(aux, aux->used_maps, aux->used_map_cnt);
>  	kfree(aux->used_maps);
> @@ -2211,8 +2211,10 @@ static void bpf_prog_free_deferred(struct work_struct *work)
>  #endif
>  	if (aux->dst_trampoline)
>  		bpf_trampoline_put(aux->dst_trampoline);
> -	for (i = 0; i < aux->func_cnt; i++)
> +	for (i = 0; i < aux->func_cnt; i++) {
> +		bpf_free_used_maps(aux->func[i]->aux);
>  		bpf_jit_free(aux->func[i]);
> +	}

The sub-progs don't have all the properties of the main prog.
Only main prog suppose to keep maps incremented.
After this patch the prog with 100 subprogs will artificially bump maps
refcnt 100 times as a workaround for poke_tab access.
May be we can use single poke_tab in the main prog instead.
Looks like jit_subprogs is splitting the poke_tab into individual arrays
for each subprog, but maps are tracked by the main prog only.
That's the root cause of the issue, right?
I think that split of poke_tab isn't necessary.
bpf_int_jit_compile() can look into main prog poke_tab instead.
Then the loop:
for (j = 0; j < prog->aux->size_poke_tab)
    bpf_jit_add_poke_descriptor(func[i], &prog->aux->poke_tab[j]);
can be removed (It will address the concern in patch 2 as well, right?)
And hopefully will fix UAF too?
