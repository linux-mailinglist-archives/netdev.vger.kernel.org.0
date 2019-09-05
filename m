Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5377AA41B
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 15:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388358AbfIENOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 09:14:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:55914 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732648AbfIENOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 09:14:44 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i5raa-0007bZ-7U; Thu, 05 Sep 2019 15:14:16 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i5raa-000Xl9-0A; Thu, 05 Sep 2019 15:14:16 +0200
Subject: Re: [PATCH bpf-next v3 0/4] xsk: various CPU barrier and {READ,
 WRITE}_ONCE
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org
Cc:     magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, bjorn.topel@intel.com,
        jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
References: <20190904114913.17217-1-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e948901d-6d0a-3764-7d2e-723f891bd3d9@iogearbox.net>
Date:   Thu, 5 Sep 2019 15:14:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190904114913.17217-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25563/Thu Sep  5 10:24:28 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/19 1:49 PM, Björn Töpel wrote:
> This is a four patch series of various barrier, {READ, WRITE}_ONCE
> cleanups in the AF_XDP socket code. More details can be found in the
> corresponding commit message. Previous revisions: v1 [4] and v2 [5].
> 
> For an AF_XDP socket, most control plane operations are done under the
> control mutex (struct xdp_sock, mutex), but there are some places
> where members of the struct is read outside the control mutex. The
> dev, queue_id members are set in bind() and cleared at cleanup. The
> umem, fq, cq, tx, rx, and state member are all assigned in various
> places, e.g. bind() and setsockopt(). When the members are assigned,
> they are protected by the control mutex, but since they are read
> outside the mutex, a WRITE_ONCE is required to avoid store-tearing on
> the read-side.
> 
> Prior the state variable was introduced by Ilya, the dev member was
> used to determine whether the socket was bound or not. However, when
> dev was read, proper SMP barriers and READ_ONCE were missing. In order
> to address the missing barriers and READ_ONCE, we start using the
> state variable as a point of synchronization. The state member
> read/write is paired with proper SMP barriers, and from this follows
> that the members described above does not need READ_ONCE statements if
> used in conjunction with state check.
> 
> To summarize: The members struct xdp_sock members dev, queue_id, umem,
> fq, cq, tx, rx, and state were read lock-less, with incorrect barriers
> and missing {READ, WRITE}_ONCE. After this series umem, fq, cq, tx,
> rx, and state are read lock-less. When these members are updated,
> WRITE_ONCE is used. When read, READ_ONCE are only used when read
> outside the control mutex (e.g. mmap) or, not synchronized with the
> state member (XSK_BOUND plus smp_rmb())
> 
> Thanks,
> Björn
> 
> [1] https://lore.kernel.org/bpf/beef16bb-a09b-40f1-7dd0-c323b4b89b17@iogearbox.net/
> [2] https://lwn.net/Articles/793253/
> [3] https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE
> [4] https://lore.kernel.org/bpf/20190822091306.20581-1-bjorn.topel@gmail.com/
> [5] https://lore.kernel.org/bpf/20190826061053.15996-1-bjorn.topel@gmail.com/
> 
> v2->v3:
>    Minor restructure of commits.
>    Improve cover and commit messages. (Daniel)
> v1->v2:
>    Removed redundant dev check. (Jonathan)
> 
> Björn Töpel (4):
>    xsk: avoid store-tearing when assigning queues
>    xsk: avoid store-tearing when assigning umem
>    xsk: use state member for socket synchronization
>    xsk: lock the control mutex in sock_diag interface
> 
>   net/xdp/xsk.c      | 60 ++++++++++++++++++++++++++++++++--------------
>   net/xdp/xsk_diag.c |  3 +++
>   2 files changed, 45 insertions(+), 18 deletions(-)
> 

Applied, thanks!
