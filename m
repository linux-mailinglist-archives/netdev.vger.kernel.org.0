Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CAB4242E9
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 18:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbhJFQnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 12:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhJFQnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 12:43:39 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8BAC061746;
        Wed,  6 Oct 2021 09:41:47 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so2780264pjb.4;
        Wed, 06 Oct 2021 09:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=th6CTyWl3y9lBfjOIdAhLyrGx2yHPT3/CDRsEtTPQ38=;
        b=V/JOhJ9blBKDkmspPYzUlGgInTcRDR0SDjMvQJcgVkbbkox6Hsx8EItASuat72pKXg
         Sv3Jr31VwEI7LqJpTJK7B02dREXrXn4czSDrJtUQlhW0T1QzGbfTUhKIrEhPm5s7MAzv
         Qahs8VMKhUBubNZzC9i5yrQuhQbo3h3Ethkt6aFhw0/xR7sSuR4LCe0zCjzQRD4X8kNn
         64ZbGv4MC6FalD4p1P44100k8OTAP6D22ZWOYdM62PdokhlNfyvdTLEKAACMTaq/ihda
         27PFKprrGWsu+nhx+BCmrW3fKBk9Bunuc3XpDR12KMm40+E6JibeX70oV9xDgaFjvrqd
         AvnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=th6CTyWl3y9lBfjOIdAhLyrGx2yHPT3/CDRsEtTPQ38=;
        b=hbB6HA0khPscwpTp6w5Yq7TqQS3PnKQF4kHV5Db9gZ0zbxz+bInrMrkzCnsXnqdQ/R
         AT+RU1IKeApJti5rrumRojFhPiUWt3ZV6OBCj0VpcPjIJyNcnI/BHcJ1Gz9mTuZ1KBwC
         y3ijTihNs0RnbIAMn+JlGW64D4V7BGFnaHPMYShQo37xr1W+FIlLBXpXWtObLEBHgmLc
         ZYQ1ydTxAohsXMkZGmjuEcx/kEt6kolcw7HjpaGjInBLVzwckFgLOGDtsXxsnL48fdtt
         RjLsLJjjfR4L1G4DBGj44CCdDApiHau3I173tIDB0qPF53GtMha3Dqz9LzVFXkDqgP9n
         7DCQ==
X-Gm-Message-State: AOAM530/3dRGJiFbIg8WAkn7t/8+kH/Mk4OJtVrnoIKG2xJBdrGR0dDc
        nzD67ovv7RzdvK6AR7E1u4k=
X-Google-Smtp-Source: ABdhPJxef4DTTLu0SDASUyOcvYvD39a450fIjjWMkxSRLPL1984t3SfSBkZ/VBsl+QqGWj2o7pIYuA==
X-Received: by 2002:a17:90b:4f4b:: with SMTP id pj11mr6466894pjb.4.1633538506543;
        Wed, 06 Oct 2021 09:41:46 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:500::2:547])
        by smtp.gmail.com with ESMTPSA id k3sm20753012pfi.6.2021.10.06.09.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 09:41:46 -0700 (PDT)
Date:   Wed, 6 Oct 2021 09:41:43 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Joe Burton <jevburton@google.com>
Cc:     Joe Burton <jevburton.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/13] Introduce BPF map tracing capability
Message-ID: <20211006164143.fuvbzxjca7cxe5ur@ast-mbp.dhcp.thefacebook.com>
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
 <20211005051306.4zbdqo3rnecj3hyv@ast-mbp>
 <CAL0ypaB3=cPnCGdwfEHhSLf8zh_mMJ=mL5T_3EfTsPFbNuLSAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL0ypaB3=cPnCGdwfEHhSLf8zh_mMJ=mL5T_3EfTsPFbNuLSAA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 02:47:34PM -0700, Joe Burton wrote:
> > It's a neat idea to user verifier powers for this job,
> > but I wonder why simple tracepoint in map ops was not used instead?
> 
> My concern with tracepoints is that they execute for all map updates,
> not for a particular map. Ideally performing an upgrade of program X
> should not affect the performance characteristics of program Y.

Right, but single 'if (map == map_ptr_being_traced)'
won't really affect update() speed of maps.
For hash maps the update/delete are heavy operations with a bunch of
checks and spinlocks.
Just to make sure we're on the same patch I'm proposing something like
the patch below...

> If n programs are opted into this model, then upgrading any of them
> affects the performance characteristics of every other. There's also
> the (very remote) possibility of multiple simultaneous upgrades tracing
> map updates at the same time, causing a greater performance hit.

Also consider that the verifier fixup of update/delete in the code
is permanent whereas attaching fentry or fmod_ret to a nop function is temporary.
Once tracing of the map is no longer necessary that fentry program
will be detached and overhead will go back to zero.
Which is not the case for 'fixup' approach.

With fmod_ret the tracing program might be the enforcing program.
It could be used to disallow certain map access in a generic way.

> > I don't think the "solution" for lookup operation is worth pursuing.
> > The bpf prog that needs this map tracing is completely in your control.
> > So just don't do writes after lookup.
> 
> I eventually want to support apps that use local storage. Those APIs
> generally only allow updates via a pointer. E.g. bpf_sk_storage_get()
> only allows updates via the returned pointer and via
> bpf_sk_storage_delete().
> 
> Since I eventually have to solve this problem to handle local storage,
> then it seems worth solving it for normal maps as well. They seem
> like isomorphic problems.

Especially for local storage... doing tracing from bpf program itself
seems to make the most sense.

From c7b6ec4488ee50ebbca61c22c6837fd6fe7007bf Mon Sep 17 00:00:00 2001
From: Alexei Starovoitov <ast@kernel.org>
Date: Wed, 6 Oct 2021 09:30:21 -0700
Subject: [PATCH] bpf: trace array map update

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/arraymap.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 5e1ccfae916b..89f853b1a217 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -293,6 +293,13 @@ static void check_and_free_timer_in_array(struct bpf_array *arr, void *val)
 		bpf_timer_cancel_and_free(val + arr->map.timer_off);
 }
 
+noinline int bpf_array_map_trace_update(struct bpf_map *map, void *key,
+					void *value, u64 map_flags)
+{
+	return 0;
+}
+ALLOW_ERROR_INJECTION(bpf_array_map_trace_update, ERRNO);
+
 /* Called from syscall or from eBPF program */
 static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
 				 u64 map_flags)
@@ -300,6 +307,7 @@ static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
 	u32 index = *(u32 *)key;
 	char *val;
+	int err;
 
 	if (unlikely((map_flags & ~BPF_F_LOCK) > BPF_EXIST))
 		/* unknown flags */
@@ -317,6 +325,9 @@ static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
 		     !map_value_has_spin_lock(map)))
 		return -EINVAL;
 
+	if (unlikely(err = bpf_array_map_trace_update(map, key, value, map_flags)))
+		return err;
+
 	if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY) {
 		memcpy(this_cpu_ptr(array->pptrs[index & array->index_mask]),
 		       value, map->value_size);
-- 
2.30.2

