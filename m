Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D429227CE1
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 12:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgGUK0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 06:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgGUK0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 06:26:38 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF96C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 03:26:38 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id k17so11388461lfg.3
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 03:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=iEtIpcE2+eB88wPtSA/h/7VVqnZlQB2tR2jGDGVyYxc=;
        b=X7LNw7VGLA5oaTPrTEWpegK064LUf2zcRuwTHFopPh/FVA/7Qlsnv4QfosaA0nwSp8
         RJ0368G+HMHbVF1EY1dTtsPGuKFnEP6SBy901+uB8DU+xpfQQOHRFvVsWLRidv2tt033
         XXjaB1qupBisCZMYyvSED4LNCe2QqBzbXrVo4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=iEtIpcE2+eB88wPtSA/h/7VVqnZlQB2tR2jGDGVyYxc=;
        b=EW1hpJ2hGn8GvxR/1Kv60m1l/d/0ay1dTRKbLT9seuWkGOCGa9SjdeY85WdaibMCXa
         1QULePWq80SCcsEbDdnp76zxaHG8hSkX7B8Hkc/u9xcvlrA/V6v3lraonPD9Bky+JJ+Q
         8sNAiZyt8f4DMaOGpeDyMEjxm/jWZuEgFO1cq6r0cRnFmUIBGvQh9y8t/CvOwFCG+yq8
         C6n4HiTsRT8xMiZbyzmD4ZSqd7DUbTt/gsVQ4iIvAMv2UITMDOQ57HQnfsNAK7zHju5V
         k3lOBMVGQw0723yAuCyl4e30oCd5HfR1UZymjGjzZODhsLkA62E79KQ3rYvsEJtOJW5n
         lAtw==
X-Gm-Message-State: AOAM533ACSr37Xspv79Of3v8iDH0M5m4WSlBIZ5Cl8upZvEzA01X6W5/
        xKikGghGLrw7Np2JieZPU3A7YA==
X-Google-Smtp-Source: ABdhPJyLRXz3jhf9wd1fzW33kxcBXO5VTHseQroJryeiFKyfzu3E40Ygd+D18n83SgGUPVJTzmG14w==
X-Received: by 2002:a19:7e42:: with SMTP id z63mr9685633lfc.36.1595327196309;
        Tue, 21 Jul 2020 03:26:36 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id l18sm1043730lje.45.2020.07.21.03.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 03:26:35 -0700 (PDT)
References: <e54f2aabf959f298939e5507b09c48f8c2e380be.1595170625.git.lorenzo@kernel.org>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, kuba@kernel.org
Subject: Re: [PATCH bpf-next] bpf: cpumap: fix possible rcpu kthread hung
In-reply-to: <e54f2aabf959f298939e5507b09c48f8c2e380be.1595170625.git.lorenzo@kernel.org>
Date:   Tue, 21 Jul 2020 12:26:34 +0200
Message-ID: <87zh7tw4dh.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 19, 2020 at 05:52 PM CEST, Lorenzo Bianconi wrote:
> Fix the following cpumap kthread hung. The issue is currently occurring
> when __cpu_map_load_bpf_program fails (e.g if the bpf prog has not
> BPF_XDP_CPUMAP as expected_attach_type)
>
> $./test_progs -n 101
> 101/1 cpumap_with_progs:OK
> 101 xdp_cpumap_attach:OK
> Summary: 1/1 PASSED, 0 SKIPPED, 0 FAILED
> [  369.996478] INFO: task cpumap/0/map:7:205 blocked for more than 122 seconds.
> [  369.998463]       Not tainted 5.8.0-rc4-01472-ge57892f50a07 #212
> [  370.000102] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  370.001918] cpumap/0/map:7  D    0   205      2 0x00004000
> [  370.003228] Call Trace:
> [  370.003930]  __schedule+0x5c7/0xf50
> [  370.004901]  ? io_schedule_timeout+0xb0/0xb0
> [  370.005934]  ? static_obj+0x31/0x80
> [  370.006788]  ? mark_held_locks+0x24/0x90
> [  370.007752]  ? cpu_map_bpf_prog_run_xdp+0x6c0/0x6c0
> [  370.008930]  schedule+0x6f/0x160
> [  370.009728]  schedule_preempt_disabled+0x14/0x20
> [  370.010829]  kthread+0x17b/0x240
> [  370.011433]  ? kthread_create_worker_on_cpu+0xd0/0xd0
> [  370.011944]  ret_from_fork+0x1f/0x30
> [  370.012348]
>                Showing all locks held in the system:
> [  370.013025] 1 lock held by khungtaskd/33:
> [  370.013432]  #0: ffffffff82b24720 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x28/0x1c3
>
> [  370.014461] =============================================
>
> Fixes: 9216477449f3 ("bpf: cpumap: Add the possibility to attach an eBPF program to cpumap")
> Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Tested-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
