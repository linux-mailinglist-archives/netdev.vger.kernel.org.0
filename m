Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F60551D06
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfFXVWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:22:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:42800 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfFXVWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 17:22:21 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfW4E-0002Kr-QH; Mon, 24 Jun 2019 22:59:58 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfW4E-0007X2-GT; Mon, 24 Jun 2019 22:59:58 +0200
Subject: Re: [PATCH V34 23/29] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
To:     Andy Lutomirski <luto@kernel.org>,
        Matthew Garrett <mjg59@google.com>
Cc:     James Morris <jmorris@namei.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Chun-Yi Lee <jlee@suse.com>, Jann Horn <jannh@google.com>,
        bpf@vger.kernel.org
References: <20190622000358.19895-1-matthewgarrett@google.com>
 <20190622000358.19895-24-matthewgarrett@google.com>
 <739e21b5-9559-d588-3542-bf0bc81de1b2@iogearbox.net>
 <CACdnJuvR2bn3y3fYzg06GWXXgAGjgED2Dfa5g0oAwJ28qCCqBg@mail.gmail.com>
 <CALCETrWmZX3R1L88Gz9vLY68gcK8zSXL4cA4GqAzQoyqSR7rRQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7f36edf7-3120-975e-b643-3c0fa470bafd@iogearbox.net>
Date:   Mon, 24 Jun 2019 22:59:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CALCETrWmZX3R1L88Gz9vLY68gcK8zSXL4cA4GqAzQoyqSR7rRQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25490/Mon Jun 24 10:02:14 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/24/2019 10:08 PM, Andy Lutomirski wrote:
> On Mon, Jun 24, 2019 at 12:54 PM Matthew Garrett <mjg59@google.com> wrote:
>> On Mon, Jun 24, 2019 at 8:37 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>> On 06/22/2019 02:03 AM, Matthew Garrett wrote:
>>>> From: David Howells <dhowells@redhat.com>
>>>>
>>>> There are some bpf functions can be used to read kernel memory:
>>>
>>> Nit: that
>>
>> Fixed.
>>
>>>> bpf_probe_read, bpf_probe_write_user and bpf_trace_printk.  These allow
>>>
>>> Please explain how bpf_probe_write_user reads kernel memory ... ?!
>>
>> Ha.
>>
>>>> private keys in kernel memory (e.g. the hibernation image signing key) to
>>>> be read by an eBPF program and kernel memory to be altered without
>>>
>>> ... and while we're at it, also how they allow "kernel memory to be
>>> altered without restriction". I've been pointing this false statement
>>> out long ago.
>>
>> Yup. How's the following description:
>>
>>     bpf: Restrict bpf when kernel lockdown is in confidentiality mode
>>
>>     There are some bpf functions that can be used to read kernel memory and
>>     exfiltrate it to userland: bpf_probe_read, bpf_probe_write_user and
>>     bpf_trace_printk.  These could be abused to (eg) allow private
>> keys in kernel
>>     memory to be leaked. Disable them if the kernel has been locked
>> down in confidentiality
>>     mode.
> 
> I'm confused.  I understand why we're restricting bpf_probe_read().
> Why are we restricting bpf_probe_write_user() and bpf_trace_printk(),
> though?

Agree, for example, bpf_probe_write_user() can never write into
kernel memory (only user one). Just thinking out loud, wouldn't it
be cleaner and more generic to perform this check at the actual function
which performs the kernel memory without faulting? All three of these
are in mm/maccess.c, and the very few occasions that override the
probe_kernel_read symbol are calling eventually into __probe_kernel_read(),
so this would catch all of them wrt lockdown restrictions. Otherwise
you'd need to keep tracking every bit of new code being merged that
calls into one of these, no? That way you only need to do it once like
below and are guaranteed that the check catches these in future as well.

Thanks,
Daniel

diff --git a/mm/maccess.c b/mm/maccess.c
index 482d4d6..2c8220f 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -29,6 +29,9 @@ long __probe_kernel_read(void *dst, const void *src, size_t size)
 	long ret;
 	mm_segment_t old_fs = get_fs();

+	if (security_locked_down(LOCKDOWN_KERNEL_READ))
+		return -EFAULT;
+
 	set_fs(KERNEL_DS);
 	pagefault_disable();
 	ret = __copy_from_user_inatomic(dst,
@@ -57,6 +60,9 @@ long __probe_kernel_write(void *dst, const void *src, size_t size)
 	long ret;
 	mm_segment_t old_fs = get_fs();

+	if (security_locked_down(LOCKDOWN_KERNEL_WRITE))
+		return -EFAULT;
+
 	set_fs(KERNEL_DS);
 	pagefault_disable();
 	ret = __copy_to_user_inatomic((__force void __user *)dst, src, size);
@@ -90,6 +96,9 @@ long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
 	const void *src = unsafe_addr;
 	long ret;

+	if (security_locked_down(LOCKDOWN_KERNEL_READ))
+		return -EFAULT;
+
 	if (unlikely(count <= 0))
 		return 0;

