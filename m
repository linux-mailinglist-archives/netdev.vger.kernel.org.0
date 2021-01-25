Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992C53033CD
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731368AbhAZFF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:05:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50684 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728462AbhAYMxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 07:53:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611579141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6FXhf8ogC0Yvd8SLnwk+TGje6bwkLwvi38NvjevotxQ=;
        b=f1VHWgfc1WeDa4eH6SECKEMMn9TL1NRP5XGAzdKcL11pDcQbB+OYPWllhNs+jM1yMOW8rd
        TtdChZ0OVoPxhlLAriwjg54ybOXT5UWZTRTH5r6v/khwAk63CKgrl0GxN4YLkfUOklGlpZ
        r+2gTuLu2+JMM7DMuFSwuUd47JqkZO4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-DDlah-w-NvuBSxhwXtEMuA-1; Mon, 25 Jan 2021 07:52:18 -0500
X-MC-Unique: DDlah-w-NvuBSxhwXtEMuA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89E5F8030BE;
        Mon, 25 Jan 2021 12:52:16 +0000 (UTC)
Received: from krava (unknown [10.40.194.55])
        by smtp.corp.redhat.com (Postfix) with SMTP id 753EE19C44;
        Mon, 25 Jan 2021 12:52:14 +0000 (UTC)
Date:   Mon, 25 Jan 2021 13:52:13 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, john.fastabend@gmail.com,
        kpsingh@chromium.org, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 2/4] bpf: allow bpf_d_path in sleepable
 bpf_iter program
Message-ID: <20210125125213.GA256721@krava>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-3-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215233702.3301881-3-songliubraving@fb.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 03:37:00PM -0800, Song Liu wrote:
> task_file and task_vma iter programs have access to file->f_path. Enable
> bpf_d_path to print paths of these file.
> 
> bpf_iter programs are generally called in sleepable context. However, it
> is still necessary to diffientiate sleepable and non-sleepable bpf_iter
> programs: sleepable programs have access to bpf_d_path; non-sleepable
> programs have access to bpf_spin_lock.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  kernel/trace/bpf_trace.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 4be771df5549a..9e5f9b968355f 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1191,6 +1191,11 @@ BTF_SET_END(btf_allowlist_d_path)
>  
>  static bool bpf_d_path_allowed(const struct bpf_prog *prog)
>  {
> +	if (prog->type == BPF_PROG_TYPE_TRACING &&
> +	    prog->expected_attach_type == BPF_TRACE_ITER &&
> +	    prog->aux->sleepable)
> +		return true;
> +
>  	if (prog->type == BPF_PROG_TYPE_LSM)
>  		return bpf_lsm_is_sleepable_hook(prog->aux->attach_btf_id);
>  
> -- 
> 2.24.1
> 

would be great to have this merged for bpftrace

Tested-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

