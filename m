Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A569B329166
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 21:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241670AbhCAUZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 15:25:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35978 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241499AbhCAUUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 15:20:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614629942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tm9fKMa+OeMDf8cjUn2OSKTxJ285HlE2LNt99VSxN9w=;
        b=VaxaXNAEKslfsChZ69FgJMB8sswHB2AsYIlIgVyoWiNp7vlUk616kbhBFc3xDSkmFC/UDf
        hOnDy7tjmSntYlqDtqHJ/jiKMUdhHq/E0m2kGSI0GITZ9jg2Oa0g5PVwHf+iil9mhxgmRo
        KwxETiY4MADv/C7IVl8+EwYdUxjTsC0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-MBh0QM-gMKGCfu9mq5AcXw-1; Mon, 01 Mar 2021 15:18:59 -0500
X-MC-Unique: MBh0QM-gMKGCfu9mq5AcXw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4489D1005501;
        Mon,  1 Mar 2021 20:18:56 +0000 (UTC)
Received: from carbon (unknown [10.36.110.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA3FC6E52F;
        Mon,  1 Mar 2021 20:18:38 +0000 (UTC)
Date:   Mon, 1 Mar 2021 21:18:37 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
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
        <grygorii.strashko@ti.com>, <ecree.xilinx@gmail.com>,
        brouer@redhat.com
Subject: Re: [PATCH v2 bpf-next] bpf: devmap: move drop error path to devmap
 for XDP_REDIRECT
Message-ID: <20210301211837.4a755c44@carbon>
In-Reply-To: <pj41zlpn0jcgms.fsf@u68c7b5b1d2d758.ant.amazon.com>
References: <d0c326f95b2d0325f63e4040c1530bf6d09dc4d4.1614422144.git.lorenzo@kernel.org>
        <pj41zly2f8wfq6.fsf@u68c7b5b1d2d758.ant.amazon.com>
        <YDwYzYVIDQABINyy@lore-laptop-rh>
        <20210301084847.5117a404@carbon>
        <pj41zlpn0jcgms.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Mar 2021 13:23:06 +0200
Shay Agroskin <shayagr@amazon.com> wrote:

> Jesper Dangaard Brouer <brouer@redhat.com> writes:
> 
> > On Sun, 28 Feb 2021 23:27:25 +0100
> > Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
> >  
> >> > >  	drops = bq->count - sent;
> >> > > -out:
> >> > > -	bq->count = 0;
> >> > > +	if (unlikely(drops > 0)) {
> >> > > +		/* If not all frames have been 
> >> > > transmitted, it is our
> >> > > +		 * responsibility to free them
> >> > > +		 */
> >> > > +		for (i = sent; i < bq->count; i++)
> >> > > + 
> >> > > xdp_return_frame_rx_napi(bq->q[i]);
> >> > > +	}    
> >> > 
> >> > Wouldn't the logic above be the same even w/o the 'if' 
> >> > condition ?    
> >> 
> >> it is just an optimization to avoid the for loop instruction if 
> >> sent = bq->count  
> >
> > True, and I like this optimization.
> > It will affect how the code layout is (and thereby I-cache 
> > usage).  
> 
> I'm not sure what I-cache optimization you mean here. Compiling 
> the following C code:
> 
> # define unlikely(x)	__builtin_expect(!!(x), 0)
> 
> extern void xdp_return_frame_rx_napi(int q);
> 
> struct bq_stuff {
>     int q[4];
>     int count;
> };
> 
> int test(int sent, struct bq_stuff *bq) {
>     int i;
>     int drops;
> 
>     drops = bq->count - sent;
>     if(unlikely(drops > 0))
>         for (i = sent; i < bq->count; i++)
>             xdp_return_frame_rx_napi(bq->q[i]);
> 
>     return 2;
> }
> 
> with x86_64 gcc 10.2 with -O3 flag in https://godbolt.org/ (which 
> provides the assembly code for different compilers) yields the 
> following assembly:
> 
> test:
>         mov     eax, DWORD PTR [rsi+16]
>         mov     edx, eax
>         sub     edx, edi
>         test    edx, edx
>         jg      .L10
> .L6:
>         mov     eax, 2
>         ret

This exactly shows my point.  Notice how 'ret' happens earlier in this
function.  This is the common case, thus the CPU don't have to load the
asm instruction below.

> .L10:
>         cmp     eax, edi
>         jle     .L6
>         push    rbp
>         mov     rbp, rsi
>         push    rbx
>         movsx   rbx, edi
>         sub     rsp, 8
> .L3:
>         mov     edi, DWORD PTR [rbp+0+rbx*4]
>         add     rbx, 1
>         call    xdp_return_frame_rx_napi
>         cmp     DWORD PTR [rbp+16], ebx
>         jg      .L3
>         add     rsp, 8
>         mov     eax, 2
>         pop     rbx
>         pop     rbp
>         ret
> 
> 
> When dropping the 'if' completely I get the following assembly 
> output
> test:
>         cmp     edi, DWORD PTR [rsi+16]
>         jge     .L6

Jump to .L6 which is the common case.  The code in between is not used
in common case, but the CPU will likely load this into I-cache, and
then jumps over the code in common case.

>         push    rbp
>         mov     rbp, rsi
>         push    rbx
>         movsx   rbx, edi
>         sub     rsp, 8
> .L3:
>         mov     edi, DWORD PTR [rbp+0+rbx*4]
>         add     rbx, 1
>         call    xdp_return_frame_rx_napi
>         cmp     DWORD PTR [rbp+16], ebx
>         jg      .L3
>         add     rsp, 8
>         mov     eax, 2
>         pop     rbx
>         pop     rbp
>         ret
> .L6:
>         mov     eax, 2
>         ret
> 
> which exits earlier from the function if 'drops > 0' compared to 
> the original code (the 'for' loop looks a little different, but 
> this shouldn't affect icache).
>
> When removing the 'if' and surrounding the 'for' condition with 
> 'unlikely' statement:
> 
> for (i = sent; unlikely(i < bq->count); i++)
> 
> I get the following assembly code:
> 
> test:
>         cmp     edi, DWORD PTR [rsi+16]
>         jl      .L10
>         mov     eax, 2
>         ret
> .L10:
>         push    rbx
>         movsx   rbx, edi
>         sub     rsp, 16
> .L3:
>         mov     edi, DWORD PTR [rsi+rbx*4]
>         mov     QWORD PTR [rsp+8], rsi
>         add     rbx, 1
>         call    xdp_return_frame_rx_napi
>         mov     rsi, QWORD PTR [rsp+8]
>         cmp     DWORD PTR [rsi+16], ebx
>         jg      .L3
>         add     rsp, 16
>         mov     eax, 2
>         pop     rbx
>         ret
> 
> which is shorter than the other two (one line compared to the 
> second and 7 lines compared the original code) and seems as 
> optimized as the second.

You are also using unlikely() and get the earlier return, with less
instructions, which is great.  Perhaps we can use this type of
unlikely() in the for-statement?  WDYT Lorenzo?
 
 
> I'm far from being an assembly expert, and I tested a code snippet 
> I wrote myself rather than the kernel's code (for the sake of 
> simplicity only).
> Can you please elaborate on what makes the original 'if' essential 
> (I took the time to do the assembly tests, please take the time on 
> your side to prove your point, I'm not trying to be grumpy here).
> 
> Shay

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

