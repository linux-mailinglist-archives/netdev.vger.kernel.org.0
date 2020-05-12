Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E431CFF36
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 22:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731048AbgELU1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 16:27:37 -0400
Received: from www62.your-server.de ([213.133.104.62]:57332 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728882AbgELU1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 16:27:37 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYbV0-0001GB-3h; Tue, 12 May 2020 22:27:34 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYbUz-000MI3-No; Tue, 12 May 2020 22:27:33 +0200
Subject: Re: [PATCH v5 bpf-next 2/3] bpf: implement CAP_BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        linux-security-module@vger.kernel.org, acme@redhat.com,
        jamorris@linux.microsoft.com, jannh@google.com, kpsingh@google.com
References: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
 <20200508215340.41921-3-alexei.starovoitov@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <311508c5-b80f-498e-2d0a-b98fe751ead9@iogearbox.net>
Date:   Tue, 12 May 2020 22:27:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200508215340.41921-3-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25810/Tue May 12 14:14:24 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/8/20 11:53 PM, Alexei Starovoitov wrote:
[...]
> @@ -2880,8 +2933,6 @@ static int bpf_prog_test_run(const union bpf_attr *attr,
>   	struct bpf_prog *prog;
>   	int ret = -ENOTSUPP;
>   
> -	if (!capable(CAP_SYS_ADMIN))
> -		return -EPERM;

Should above be under bpf_capable() as well or is the intention to really let
(fully) unpriv users run sk_filter test progs here? I would assume only progs
that have prior been loaded under bpf_capable() should suffice, so no need to
lower the bar for now, no?

>   	if (CHECK_ATTR(BPF_PROG_TEST_RUN))
>   		return -EINVAL;
>   
> @@ -3163,7 +3214,7 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
>   	info.run_time_ns = stats.nsecs;
>   	info.run_cnt = stats.cnt;
>   
> -	if (!capable(CAP_SYS_ADMIN)) {
> +	if (!bpf_capable()) {

Given the JIT dump this also exposes addresses when bpf_dump_raw_ok() passes.
I presume okay, but should probably be documented given CAP_SYS_ADMIN isn't
required anymore?

>   		info.jited_prog_len = 0;
>   		info.xlated_prog_len = 0;
>   		info.nr_jited_ksyms = 0;
> @@ -3522,7 +3573,7 @@ static int bpf_btf_load(const union bpf_attr *attr)
>   	if (CHECK_ATTR(BPF_BTF_LOAD))
>   		return -EINVAL;
>   
> -	if (!capable(CAP_SYS_ADMIN))
> +	if (!bpf_capable())
>   		return -EPERM;
>   
>   	return btf_new_fd(attr);
> @@ -3736,9 +3787,6 @@ static int link_create(union bpf_attr *attr)
>   	struct bpf_prog *prog;
>   	int ret;
>   
> -	if (!capable(CAP_NET_ADMIN))
> -		return -EPERM;
> -
>   	if (CHECK_ATTR(BPF_LINK_CREATE))
>   		return -EINVAL;
>   
> @@ -3784,9 +3832,6 @@ static int link_update(union bpf_attr *attr)
>   	u32 flags;
>   	int ret;
>   
> -	if (!capable(CAP_NET_ADMIN))
> -		return -EPERM;
> -
>   	if (CHECK_ATTR(BPF_LINK_UPDATE))
>   		return -EINVAL;
>   
