Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F3B32C43A
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382947AbhCDAL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:11:59 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:18479 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357937AbhCCLhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 06:37:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1614771442; x=1646307442;
  h=references:from:to:cc:subject:message-id:in-reply-to:
   date:mime-version;
  bh=P+9ZEX5jb4kFkvXoeddXjfa/sYVvgxi4ph9PG42mxPk=;
  b=o4t7uuVdf60bE40wEYYw2TQ9fZie4+EKvwhb4OCw1ErOtfAap+JQoDoQ
   bWfvFtONhlD1Lm1vEs0wy2xVXJVl60yUDV7yxiRv1j4DbqS4FS9d+THxf
   8MfQixGZJ/Vk8X+U9YxozwfZvDEbIF/A9h+6iABBU3msnb+44PKw+2lk1
   U=;
X-IronPort-AV: E=Sophos;i="5.81,219,1610409600"; 
   d="scan'208";a="95074814"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 03 Mar 2021 11:29:33 +0000
Received: from EX13D28EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 6C95A28229A;
        Wed,  3 Mar 2021 11:29:26 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.160.27) by
 EX13D28EUB001.ant.amazon.com (10.43.166.50) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 3 Mar 2021 11:29:13 +0000
References: <d0c326f95b2d0325f63e4040c1530bf6d09dc4d4.1614422144.git.lorenzo@kernel.org>
 <pj41zly2f8wfq6.fsf@u68c7b5b1d2d758.ant.amazon.com>
 <YDwYzYVIDQABINyy@lore-laptop-rh> <20210301084847.5117a404@carbon>
 <pj41zlpn0jcgms.fsf@u68c7b5b1d2d758.ant.amazon.com>
 <20210301211837.4a755c44@carbon>
User-agent: mu4e 1.4.12; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <toke@redhat.com>,
        <freysteinn.alfredsson@kau.se>, <john.fastabend@gmail.com>,
        <jasowang@redhat.com>, <mst@redhat.com>,
        <thomas.petazzoni@bootlin.com>, <mw@semihalf.com>,
        <linux@armlinux.org.uk>, <ilias.apalodimas@linaro.org>,
        <netanel@amazon.com>, <akiyano@amazon.com>,
        <michael.chan@broadcom.com>, <madalin.bucur@nxp.com>,
        <ioana.ciornei@nxp.com>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <saeedm@nvidia.com>,
        <grygorii.strashko@ti.com>, <ecree.xilinx@gmail.com>
Subject: Re: [PATCH v2 bpf-next] bpf: devmap: move drop error path to devmap
 for XDP_REDIRECT
Message-ID: <pj41zlk0qod0rh.fsf@u68c7b5b1d2d758.ant.amazon.com>
In-Reply-To: <20210301211837.4a755c44@carbon>
Date:   Wed, 3 Mar 2021 13:29:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.160.27]
X-ClientProxiedBy: EX13D27UWA001.ant.amazon.com (10.43.160.19) To
 EX13D28EUB001.ant.amazon.com (10.43.166.50)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Mon, 1 Mar 2021 13:23:06 +0200
> Shay Agroskin <shayagr@amazon.com> wrote:
>
>> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>> 
>> > On Sun, 28 Feb 2021 23:27:25 +0100
>> > Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
>> >  
>> >> > >  	drops = bq->count - sent;
>> >> > > -out:
>> >> > > -	bq->count = 0;
>> >> > > +	if (unlikely(drops > 0)) {
>> >> > > +		/* If not all frames have been 
>> >> > > transmitted, it is our
>> >> > > +		 * responsibility to free them
>> >> > > +		 */
>> >> > > +		for (i = sent; i < bq->count; i++)
>> >> > > + 
>> >> > > xdp_return_frame_rx_napi(bq->q[i]);
>> >> > > +	}    
>> >> > 
>> >> > Wouldn't the logic above be the same even w/o the 'if' 
>> >> > condition ?    
>> >> 
>> >> it is just an optimization to avoid the for loop instruction 
>> >> if 
>> >> sent = bq->count  
>> >
>> > True, and I like this optimization.
>> > It will affect how the code layout is (and thereby I-cache 
>> > usage).  
>> 
>> I'm not sure what I-cache optimization you mean here. Compiling 
>> the following C code:
>> 
>> # define unlikely(x)	__builtin_expect(!!(x), 0)
>> 
>> extern void xdp_return_frame_rx_napi(int q);
>> 
>> struct bq_stuff {
>>     int q[4];
>>     int count;
>> };
>> 
>> int test(int sent, struct bq_stuff *bq) {
>>     int i;
>>     int drops;
>> 
>>     drops = bq->count - sent;
>>     if(unlikely(drops > 0))
>>         for (i = sent; i < bq->count; i++)
>>             xdp_return_frame_rx_napi(bq->q[i]);
>> 
>>     return 2;
>> }
>> 
>> with x86_64 gcc 10.2 with -O3 flag in https://godbolt.org/ 
>> (which 
>> provides the assembly code for different compilers) yields the 
>> following assembly:
>> 
>> test:
>>         mov     eax, DWORD PTR [rsi+16]
>>         mov     edx, eax
>>         sub     edx, edi
>>         test    edx, edx
>>         jg      .L10
>> .L6:
>>         mov     eax, 2
>>         ret
>
> This exactly shows my point.  Notice how 'ret' happens earlier 
> in this
> function.  This is the common case, thus the CPU don't have to 
> load the
> asm instruction below.
>

Wasn't aware of that. I'll dig into it

>> .L10:
>>         cmp     eax, edi
>>         jle     .L6
>>         push    rbp
>>         mov     rbp, rsi
>>         push    rbx
>>         movsx   rbx, edi
>>         sub     rsp, 8
>> .L3:
>>         mov     edi, DWORD PTR [rbp+0+rbx*4]
>>         add     rbx, 1
>>         call    xdp_return_frame_rx_napi
>>         cmp     DWORD PTR [rbp+16], ebx
>>         jg      .L3
>>         add     rsp, 8
>>         mov     eax, 2
>>         pop     rbx
>>         pop     rbp
>>         ret
>> 
>> 
>> When dropping the 'if' completely I get the following assembly 
>> output
>> test:
>>         cmp     edi, DWORD PTR [rsi+16]
>>         jge     .L6
>
> Jump to .L6 which is the common case.  The code in between is 
> not used
> in common case, but the CPU will likely load this into I-cache, 
> and
> then jumps over the code in common case.
>
>>         push    rbp
>>         mov     rbp, rsi
>>         push    rbx
>>         movsx   rbx, edi
>>         sub     rsp, 8
>> .L3:
>>         mov     edi, DWORD PTR [rbp+0+rbx*4]
>>         add     rbx, 1
>>         call    xdp_return_frame_rx_napi
>>         cmp     DWORD PTR [rbp+16], ebx
>>         jg      .L3
>>         add     rsp, 8
>>         mov     eax, 2
>>         pop     rbx
>>         pop     rbp
>>         ret
>> .L6:
>>         mov     eax, 2
>>         ret
>> 
>> which exits earlier from the function if 'drops > 0' compared 
>> to 
>> the original code (the 'for' loop looks a little different, but 
>> this shouldn't affect icache).
>>
>> When removing the 'if' and surrounding the 'for' condition with 
>> 'unlikely' statement:
>> 
>> for (i = sent; unlikely(i < bq->count); i++)
>> 
>> I get the following assembly code:
>> 
>> test:
>>         cmp     edi, DWORD PTR [rsi+16]
>>         jl      .L10
>>         mov     eax, 2
>>         ret
>> .L10:
>>         push    rbx
>>         movsx   rbx, edi
>>         sub     rsp, 16
>> .L3:
>>         mov     edi, DWORD PTR [rsi+rbx*4]
>>         mov     QWORD PTR [rsp+8], rsi
>>         add     rbx, 1
>>         call    xdp_return_frame_rx_napi
>>         mov     rsi, QWORD PTR [rsp+8]
>>         cmp     DWORD PTR [rsi+16], ebx
>>         jg      .L3
>>         add     rsp, 16
>>         mov     eax, 2
>>         pop     rbx
>>         ret
>> 
>> which is shorter than the other two (one line compared to the 
>> second and 7 lines compared the original code) and seems as 
>> optimized as the second.
>
> You are also using unlikely() and get the earlier return, with 
> less
> instructions, which is great.  Perhaps we can use this type of
> unlikely() in the for-statement?  WDYT Lorenzo?
>  
>

Thank you for this detail explanation (: Learned a lot from it.
I'd rather remove the 'if' if we can use 'for' and 'unlikely'. I 
think it looks prettier.

Shay

>> I'm far from being an assembly expert, and I tested a code 
>> snippet 
>> I wrote myself rather than the kernel's code (for the sake of 
>> simplicity only).
>> Can you please elaborate on what makes the original 'if' 
>> essential 
>> (I took the time to do the assembly tests, please take the time 
>> on 
>> your side to prove your point, I'm not trying to be grumpy 
>> here).
>> 
>> Shay

