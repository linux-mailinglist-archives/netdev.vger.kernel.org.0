Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9369B69F38
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 00:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731721AbfGOWyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 18:54:17 -0400
Received: from www62.your-server.de ([213.133.104.62]:38728 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730960AbfGOWyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 18:54:17 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hn9rI-0004FB-U8; Tue, 16 Jul 2019 00:54:12 +0200
Received: from [99.0.85.34] (helo=localhost.localdomain)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hn9rI-0001NB-Cu; Tue, 16 Jul 2019 00:54:12 +0200
Subject: Re: [PATCH V35 23/29] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
To:     Matthew Garrett <matthewgarrett@google.com>, jmorris@namei.org
Cc:     linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Matthew Garrett <mjg59@google.com>, netdev@vger.kernel.org,
        Chun-Yi Lee <jlee@suse.com>
References: <20190715195946.223443-1-matthewgarrett@google.com>
 <20190715195946.223443-24-matthewgarrett@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5d363f09-d649-5693-45c0-bb99d69f0f38@iogearbox.net>
Date:   Tue, 16 Jul 2019 00:54:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190715195946.223443-24-matthewgarrett@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25511/Mon Jul 15 10:10:35 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/19 9:59 PM, Matthew Garrett wrote:
> From: David Howells <dhowells@redhat.com>
> 
> bpf_read() and bpf_read_str() could potentially be abused to (eg) allow
> private keys in kernel memory to be leaked. Disable them if the kernel
> has been locked down in confidentiality mode.
> 
> Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> cc: netdev@vger.kernel.org
> cc: Chun-Yi Lee <jlee@suse.com>
> cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  include/linux/security.h     |  1 +
>  kernel/trace/bpf_trace.c     | 10 ++++++++++
>  security/lockdown/lockdown.c |  1 +
>  3 files changed, 12 insertions(+)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 987d8427f091..8dd1741a52cd 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -118,6 +118,7 @@ enum lockdown_reason {
>  	LOCKDOWN_INTEGRITY_MAX,
>  	LOCKDOWN_KCORE,
>  	LOCKDOWN_KPROBES,
> +	LOCKDOWN_BPF_READ,
>  	LOCKDOWN_CONFIDENTIALITY_MAX,
>  };
>  
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index ca1255d14576..605908da61c5 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -142,7 +142,12 @@ BPF_CALL_3(bpf_probe_read, void *, dst, u32, size, const void *, unsafe_ptr)
>  {
>  	int ret;
>  
> +	ret = security_locked_down(LOCKDOWN_BPF_READ);
> +	if (ret)
> +		goto out;
> +
>  	ret = probe_kernel_read(dst, unsafe_ptr, size);
> +out:
>  	if (unlikely(ret < 0))
>  		memset(dst, 0, size);

Hmm, does security_locked_down() ever return a code > 0 or why do you
have the double check on return code? If not, then for clarity the
ret code from security_locked_down() should be checked as 'ret < 0'
as well and out label should be at the memset directly instead.

> @@ -569,6 +574,10 @@ BPF_CALL_3(bpf_probe_read_str, void *, dst, u32, size,
>  {
>  	int ret;
>  
> +	ret = security_locked_down(LOCKDOWN_BPF_READ);
> +	if (ret)
> +		goto out;
> +
>  	/*
>  	 * The strncpy_from_unsafe() call will likely not fill the entire
>  	 * buffer, but that's okay in this circumstance as we're probing
> @@ -579,6 +588,7 @@ BPF_CALL_3(bpf_probe_read_str, void *, dst, u32, size,
>  	 * is returned that can be used for bpf_perf_event_output() et al.
>  	 */
>  	ret = strncpy_from_unsafe(dst, unsafe_ptr, size);
> +out:
>  	if (unlikely(ret < 0))
>  		memset(dst, 0, size);

Ditto.

Thanks,
Daniel
