Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612491E5522
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 06:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgE1EkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 00:40:01 -0400
Received: from verein.lst.de ([213.95.11.211]:54138 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbgE1EkB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 00:40:01 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C991B68B05; Thu, 28 May 2020 06:39:57 +0200 (CEST)
Date:   Thu, 28 May 2020 06:39:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, x86@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/23] bpf: handle the compat string in
 bpf_trace_copy_string better
Message-ID: <20200528043957.GA28494@lst.de>
References: <20200521152301.2587579-1-hch@lst.de> <20200521152301.2587579-13-hch@lst.de> <20200527190432.e4af1fba00c13cb1421f5a37@linux-foundation.org> <2b64fae6-394c-c1e5-8963-c256f4284065@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b64fae6-394c-c1e5-8963-c256f4284065@fb.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 07:26:30PM -0700, Yonghong Song wrote:
>> --- a/kernel/trace/bpf_trace.c~xxx
>> +++ a/kernel/trace/bpf_trace.c
>> @@ -588,15 +588,22 @@ BPF_CALL_5(bpf_seq_printf, struct seq_fi
>>   		}
>>     		if (fmt[i] == 's') {
>> +			void *unsafe_ptr;
>> +
>>   			/* try our best to copy */
>>   			if (memcpy_cnt >= MAX_SEQ_PRINTF_MAX_MEMCPY) {
>>   				err = -E2BIG;
>>   				goto out;
>>   			}
>>   -			err = strncpy_from_unsafe(bufs->buf[memcpy_cnt],
>> -						  (void *) (long) args[fmt_cnt],
>> -						  MAX_SEQ_PRINTF_STR_LEN);
>> +			unsafe_ptr = (void *)(long)args[fmt_cnt];
>> +			if ((unsigned long)unsafe_ptr < TASK_SIZE) {
>> +				err = strncpy_from_user_nofault(
>> +					bufs->buf[memcpy_cnt], unsafe_ptr,
>> +					MAX_SEQ_PRINTF_STR_LEN);
>> +			} else {
>> +				err = -EFAULT;
>> +			}
>
> This probably not right.
> The pointer stored at args[fmt_cnt] is a kernel pointer,
> but it could be an invalid address and we do not want to fault.
> Not sure whether it exists or not, we should use 
> strncpy_from_kernel_nofault()?

If you know it is a kernel pointer with this series it should be
strncpy_from_kernel_nofault.  But even before the series it should have
been strncpy_from_unsafe_strict.
