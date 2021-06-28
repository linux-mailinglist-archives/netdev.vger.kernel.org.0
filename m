Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02063B6016
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 16:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbhF1OWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 10:22:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:52636 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbhF1OVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 10:21:36 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lxs6M-0001mq-1O; Mon, 28 Jun 2021 16:19:06 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lxs6L-000VbA-PF; Mon, 28 Jun 2021 16:19:05 +0200
Subject: Re: [PATCH] bpf: fix false positive kmemleak report in
 bpf_ringbuf_area_alloc()
To:     Rustam Kovhaev <rkovhaev@gmail.com>, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, dvyukov@google.com, andrii@kernel.org
References: <20210626181156.1873604-1-rkovhaev@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <254ef541-6fd6-9ddf-3491-97b854a09554@iogearbox.net>
Date:   Mon, 28 Jun 2021 16:19:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210626181156.1873604-1-rkovhaev@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26215/Mon Jun 28 13:09:26 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/26/21 8:11 PM, Rustam Kovhaev wrote:
> kmemleak scans struct page, but it does not scan the page content.
> if we allocate some memory with kmalloc(), then allocate page with
> alloc_page(), and if we put kmalloc pointer somewhere inside that page,
> kmemleak will report kmalloc pointer as a false positive.
> 
> we can instruct kmemleak to scan the memory area by calling
> kmemleak_alloc()/kmemleak_free(), but part of struct bpf_ringbuf is
> mmaped to user space, and if struct bpf_ringbuf changes we would have to
> revisit and review size argument in kmemleak_alloc(), because we do not
> want kmemleak to scan the user space memory.
> let's simplify things and use kmemleak_not_leak() here.
> 
> Link: https://lore.kernel.org/lkml/YNTAqiE7CWJhOK2M@nuc10/
> Link: https://lore.kernel.org/lkml/20210615101515.GC26027@arm.com/
> Link: https://syzkaller.appspot.com/bug?extid=5d895828587f49e7fe9b
> Reported-and-tested-by: syzbot+5d895828587f49e7fe9b@syzkaller.appspotmail.com
> Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>

Applied, thanks! (Also included Andrii's prior analysis as well to the commit
log so there's a bit more context if we need to revisit in future [0].)

   [0] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=ccff81e1d028bbbf8573d3364a87542386c707bf
