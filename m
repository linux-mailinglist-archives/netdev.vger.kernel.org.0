Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94E81D22AB
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 01:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732342AbgEMXEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 19:04:43 -0400
Received: from www62.your-server.de ([213.133.104.62]:36932 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731815AbgEMXEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 19:04:43 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZ0QZ-0006AE-Sk; Thu, 14 May 2020 01:04:39 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZ0QZ-000IG3-GK; Thu, 14 May 2020 01:04:39 +0200
Subject: Re: clean up and streamline probe_kernel_* and friends v2
To:     Christoph Hellwig <hch@lst.de>, x86@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20200513160038.2482415-1-hch@lst.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <10c58b09-5ece-e49f-a7c8-2aa6dfd22fb4@iogearbox.net>
Date:   Thu, 14 May 2020 01:04:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200513160038.2482415-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25811/Wed May 13 14:11:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/20 6:00 PM, Christoph Hellwig wrote:
> Hi all,
> 
> this series start cleaning up the safe kernel and user memory probing
> helpers in mm/maccess.c, and then allows architectures to implement
> the kernel probing without overriding the address space limit and
> temporarily allowing access to user memory.  It then switches x86
> over to this new mechanism by reusing the unsafe_* uaccess logic.
> 
> This version also switches to the saner copy_{from,to}_kernel_nofault
> naming suggested by Linus.
> 
> I kept the x86 helprs as-is without calling unsage_{get,put}_user as
> that avoids a number of hard to trace casts, and it will still work
> with the asm-goto based version easily.

Aside from comments on list, the series looks reasonable to me. For BPF
the bpf_probe_read() helper would be slightly penalized for probing user
memory given we now test on copy_from_kernel_nofault() first and if that
fails only then fall back to copy_from_user_nofault(), but it seems
small enough that it shouldn't matter too much and aside from that we have
the newer bpf_probe_read_kernel() and bpf_probe_read_user() anyway that
BPF progs should use instead, so I think it's okay.

For patch 14 and patch 15, do you roughly know the performance gain with
the new probe_kernel_read_loop() + arch_kernel_read() approach?

Thanks,
Daniel
