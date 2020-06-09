Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D067E1F3671
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 10:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgFIIwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 04:52:47 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37173 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727023AbgFIIwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 04:52:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591692765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TMch0AWzbuAuHwcbj8NlZFX3yPyXENB2SeSZXqxbPs0=;
        b=gpyLBf3MMo3KBjqzE9/93yMbsyZqxKnpBBxBZFSFCGoX0fK1O2BAicWAopdHIQnWMz+RhL
        Maj/F8DfdHjWVivcJosKpCjGjQ5RElRnlkuWj0QCkqklEZAnwwtvfMkBAeMvgZ2nHXu43y
        Hib7Y6wTM7U/2CE5lsWYAKGGUQfLZ60=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-40gb-ARRPNOwherVnyjURA-1; Tue, 09 Jun 2020 04:52:43 -0400
X-MC-Unique: 40gb-ARRPNOwherVnyjURA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B6C3872FE1;
        Tue,  9 Jun 2020 08:52:41 +0000 (UTC)
Received: from [10.36.113.33] (ovpn-113-33.ams2.redhat.com [10.36.113.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5ADA92B4D7;
        Tue,  9 Jun 2020 08:52:36 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Yonghong Song" <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        andriin@fb.com, toke@redhat.com
Subject: Re: fentry/fexit attach to EXT type XDP program does not work
Date:   Tue, 09 Jun 2020 10:52:34 +0200
Message-ID: <88B08061-F85B-454C-9E9D-234154B9F000@redhat.com>
In-Reply-To: <42b0c8d3-e855-7531-b01c-a05414360aff@fb.com>
References: <159162546868.10791.12432342618156330247.stgit@ebuild>
 <42b0c8d3-e855-7531-b01c-a05414360aff@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8 Jun 2020, at 18:58, Yonghong Song wrote:

> On 6/8/20 7:11 AM, Eelco Chaudron wrote:
>> I'm trying for a while to do a fentry/fexit trace an EXT program
>> attached to an XDP program. To make it easier to explain I've
>> created a test case (see patch below) to show the issue.
>>
>> Without the changes to test_xdp_bpf2bpf.c I'll get the following 
>> error:
>>
>>    libbpf: -- BEGIN DUMP LOG ---
>>    libbpf:
>>    arg#0 type is not a struct
>>    Unrecognized arg#0 type PTR
>>    ; int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
>>    0: (79) r6 = *(u64 *)(r1 +0)
>>    invalid bpf_context access off=0 size=8
>>    processed 1 insns (limit 1000000) max_states_per_insn 0 
>> total_states 0 peak_states 0 mark_read 0
>>
>>    libbpf: -- END LOG --
>>    libbpf: failed to load program 'fentry/FUNC'
>>    libbpf: failed to load object 'test_xdp_bpf2bpf'
>>    libbpf: failed to load BPF skeleton 'test_xdp_bpf2bpf': -4007
>>    test_xdp_fentry_ext:FAIL:__load ftrace skeleton failed
>>    #91 xdp_fentry_ext:FAIL
>>    Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
>>
>> With the change I get the following (but I do feel this change
>> should not be needed):
>>
>>    libbpf: -- BEGIN DUMP LOG ---
>>    libbpf:
>>    Unrecognized arg#0 type PTR
>>    ; int trace_on_entry(struct xdp_buff *xdp)
>>    0: (bf) r6 = r1
>>    ; void *data = (void *)(long)xdp->data;
>>    1: (79) r1 = *(u64 *)(r6 +0)
>>    invalid bpf_context access off=0 size=8
>>    processed 2 insns (limit 1000000) max_states_per_insn 0 
>> total_states 0 peak_states 0 mark_read 0
>>
>>    libbpf: -- END LOG --
>>    libbpf: failed to load program 'fentry/FUNC'
>>    libbpf: failed to load object 'test_xdp_bpf2bpf'
>>    libbpf: failed to load BPF skeleton 'test_xdp_bpf2bpf': -4007
>>    test_xdp_fentry_ext:FAIL:__load ftrace skeleton failed
>>    #91 xdp_fentry_ext:FAIL
>>    Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
>>
>> Any idea what could be the case here? The same fentry/fexit attach
>> code works fine in the xdp_bpf2bpf.c tests case.

<SNIP>
>
> I think this is not supported now. That is, you cannot attach a fentry 
> trace
> to the EXT program. The current implementation for fentry program 
> simply
> trying to find and match the signature of freplace program which by 
> default
> is a pointer to void.
>
> It is doable in that in kernel we could recognize to-be-attached 
> program is
> a freplace and further trace down to find the real signature. The 
> related
> kernel function is btf_get_prog_ctx_type(). You can try to implement 
> by yourself
> or I can have a patch for this once bpf-next opens.

I’m not familiar with this area of the code, so if you could prepare a 
patch that would nice.
You can also send it to me before bpf-next opens and I can verify it, 
and clean up the self-test so it can be included as well.

