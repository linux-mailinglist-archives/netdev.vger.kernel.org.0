Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D803F2FB8CE
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394743AbhASNs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:48:26 -0500
Received: from foss.arm.com ([217.140.110.172]:47980 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389227AbhASJ7A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 04:59:00 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A97F41FB;
        Tue, 19 Jan 2021 01:57:30 -0800 (PST)
Received: from e107158-lin (e107158-lin.cambridge.arm.com [10.1.194.78])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70A163F66E;
        Tue, 19 Jan 2021 01:57:29 -0800 (PST)
Date:   Tue, 19 Jan 2021 09:57:26 +0000
From:   Qais Yousef <qais.yousef@arm.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 2/2] selftests: bpf: Add a new test for bare
 tracepoints
Message-ID: <20210119095726.obfhqanp6wmauzqs@e107158-lin>
References: <20210116182133.2286884-1-qais.yousef@arm.com>
 <20210116182133.2286884-3-qais.yousef@arm.com>
 <e9d4b132-288d-594f-308c-132e89fcf63f@fb.com>
 <20210118121818.muifeogh4hvakfeb@e107158-lin>
 <fdda7117-e823-e240-4735-617a3df8a0cc@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fdda7117-e823-e240-4735-617a3df8a0cc@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yonghong

On 01/18/21 09:48, Yonghong Song wrote:
> The original patch code:
> 
> +static int trigger_module_test_write(int write_sz)
> +{
> +	int fd, err;
> +	char *buf = malloc(write_sz);
> +
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	memset(buf, 'a', write_sz);
> +	buf[write_sz-1] = '\0';
> +
> +	fd = open("/sys/kernel/bpf_testmod", O_WRONLY);
> +	err = -errno;
> +	if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", err))
> +		goto out;
> +
> +	write(fd, buf, write_sz);
> +	close(fd);
> +out:
> +	free(buf);
> +
> +	return 0;
> +}
> 
> Even for "fd < 0" case, it "goto out" and "return 0". We should return
> error code here instead of 0.
> 
> Second, "err = -errno" is set before checking fd < 0. If fd >= 0, err might
> inherit an postive errno from previous failure.
> In trigger_module_test_write(), it is okay since the err is only used
> when fd < 0:
>         err = -errno;
>         if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", err))
>                 return err;
> 
> My above rewrite intends to use "err" during final "return" statement,
> so I put assignment of "err = -errno" inside the CHECK branch.
> But there are different ways to implement this properly.

Okay I see now. Sorry I missed your point initially. I will fix and send v3.

Thanks

--
Qais Yousef
