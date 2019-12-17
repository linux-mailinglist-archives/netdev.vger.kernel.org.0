Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 734DD1235D7
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 20:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbfLQTje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 14:39:34 -0500
Received: from www62.your-server.de ([213.133.104.62]:50978 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbfLQTje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 14:39:34 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihIgs-00037v-NF; Tue, 17 Dec 2019 20:39:30 +0100
Received: from [178.197.249.31] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihIgs-000HxU-Dm; Tue, 17 Dec 2019 20:39:30 +0100
Subject: Re: [PATCH bpf-next v13 1/2] bpf: add new helper get_fd_path for
 mapping a file descriptor to a pathname
To:     Yonghong Song <yhs@fb.com>, Wenbo Zhang <ethercflow@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Cc:     "ast@kernel.org" <ast@kernel.org>,
        "bgregg@netflix.com" <bgregg@netflix.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <cover.1576575253.git.ethercflow@gmail.com>
 <8f6b8979fb64bedf5cb406ba29146c5fa2539267.1576575253.git.ethercflow@gmail.com>
 <f54e3df6-626f-e9c4-f2c2-a63fb9953944@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a8a763e2-65d2-7c71-e99d-ffae1523f0f0@iogearbox.net>
Date:   Tue, 17 Dec 2019 20:39:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <f54e3df6-626f-e9c4-f2c2-a63fb9953944@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25666/Tue Dec 17 10:54:52 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/19 5:29 PM, Yonghong Song wrote:
> On 12/17/19 1:47 AM, Wenbo Zhang wrote:
[...]
>> + *		On failure, it is filled with zeroes.
[...]
>>     */
>>    #define __BPF_FUNC_MAPPER(FN)		\
>>    	FN(unspec),			\
>> @@ -2938,7 +2964,8 @@ union bpf_attr {
>>    	FN(probe_read_user),		\
>>    	FN(probe_read_kernel),		\
>>    	FN(probe_read_user_str),	\
>> -	FN(probe_read_kernel_str),
>> +	FN(probe_read_kernel_str),	\
>> +	FN(get_fd_path),
>>    
>>    /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>>     * function eBPF program intends to call
>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>> index e5ef4ae9edb5..43a6aa6ad967 100644
>> --- a/kernel/trace/bpf_trace.c
>> +++ b/kernel/trace/bpf_trace.c
>> @@ -762,6 +762,71 @@ static const struct bpf_func_proto bpf_send_signal_proto = {
>>    	.arg1_type	= ARG_ANYTHING,
>>    };
>>    
>> +BPF_CALL_3(bpf_get_fd_path, char *, dst, u32, size, int, fd)
>> +{
>> +	int ret = -EBADF;
>> +	struct file *f;
>> +	char *p;
>> +
>> +	/* Ensure we're in user context which is safe for the helper to
>> +	 * run. This helper has no business in a kthread.
>> +	 */
>> +	if (unlikely(in_interrupt() ||
>> +		     current->flags & (PF_KTHREAD | PF_EXITING))) {
>> +		ret = -EPERM;
>> +		goto error;
>> +	}
>> +
>> +	/* Use fget_raw instead of fget to support O_PATH, and it doesn't
>> +	 * have any sleepable code, so it's ok to be here.
>> +	 */
>> +	f = fget_raw(fd);
>> +	if (!f)
>> +		goto error;
>> +
>> +	/* For unmountable pseudo filesystem, it seems to have no meaning
>> +	 * to get their fake paths as they don't have path, and to be no
>> +	 * way to validate this function pointer can be always safe to call
>> +	 * in the current context.
>> +	 */
>> +	if (f->f_path.dentry->d_op && f->f_path.dentry->d_op->d_dname) {
>> +		ret = -EINVAL;
>> +		fput(f);
>> +		goto error;
>> +	}
>> +
>> +	/* After filter unmountable pseudo filesytem, d_path won't call
>> +	 * dentry->d_op->d_name(), the normally path doesn't have any
>> +	 * sleepable code, and despite it uses the current macro to get
>> +	 * fs_struct (current->fs), we've already ensured we're in user
>> +	 * context, so it's ok to be here.
>> +	 */
>> +	p = d_path(&f->f_path, dst, size);
>> +	if (IS_ERR(p)) {
>> +		ret = PTR_ERR(p);
>> +		fput(f);
>> +		goto error;
>> +	}
>> +
>> +	ret = strlen(p) + 1;
>> +	memmove(dst, p, ret);
>> +	fput(f);
>> +	return ret;
>> +
>> +error:
>> +	memset(dst, '0', size);

You fill it with 0x30's ...

>> +	return ret;
>> +}
