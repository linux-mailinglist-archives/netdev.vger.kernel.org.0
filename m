Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857561D2347
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 01:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732816AbgEMX6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 19:58:40 -0400
Received: from www62.your-server.de ([213.133.104.62]:43796 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732456AbgEMX6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 19:58:40 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZ1Gk-0002xZ-PI; Thu, 14 May 2020 01:58:34 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZ1Gk-000O73-Al; Thu, 14 May 2020 01:58:34 +0200
Subject: Re: [PATCH 11/18] maccess: remove strncpy_from_unsafe
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bgregg@netflix.com
References: <20200513160038.2482415-1-hch@lst.de>
 <20200513160038.2482415-12-hch@lst.de>
 <CAHk-=wj=u+nttmd1huNES2U=9nePtmk7WgR8cMLCYS8wc=rhdA@mail.gmail.com>
 <20200513192804.GA30751@lst.de>
 <0c1a7066-b269-9695-b94a-bb5f4f20ebd8@iogearbox.net>
 <20200513232816.GZ23230@ZenIV.linux.org.uk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <866cbe54-a027-04eb-65db-c6423d16b924@iogearbox.net>
Date:   Thu, 14 May 2020 01:58:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200513232816.GZ23230@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25811/Wed May 13 14:11:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/20 1:28 AM, Al Viro wrote:
> On Thu, May 14, 2020 at 12:36:28AM +0200, Daniel Borkmann wrote:
> 
>>> So on say s390 TASK_SIZE_USUALLy is (-PAGE_SIZE), which means we'd alway
>>> try the user copy first, which seems odd.
>>>
>>> I'd really like to here from the bpf folks what the expected use case
>>> is here, and if the typical argument is kernel or user memory.
>>
>> It's used for both. Given this is enabled on pretty much all program types, my
>> assumption would be that usage is still more often on kernel memory than user one.
> 
> Then it needs an argument telling it which one to use.  Look at sparc64.
> Or s390.  Or parisc.  Et sodding cetera.
> 
> The underlying model is that the kernel lives in a separate address space.
> Yes, on x86 it's actually sharing the page tables with userland, but that's
> not universal.  The same address can be both a valid userland one _and_
> a valid kernel one.  You need to tell which one do you want.

Yes, see also 6ae08ae3dea2 ("bpf: Add probe_read_{user, kernel} and probe_read_{user,
kernel}_str helpers"), and my other reply wrt bpf_trace_printk() on how to address
this. All I'm trying to say is that both bpf_probe_read() and bpf_trace_printk() do
exist in this form since early [e]bpf days for ~5yrs now and while broken on non-x86
there are a lot of users on x86 for this in the wild, so they need to have a chance
to migrate over to the new facilities before they are fully removed.
