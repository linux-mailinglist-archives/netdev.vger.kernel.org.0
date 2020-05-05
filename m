Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15881C54D2
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 13:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgEELyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 07:54:40 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:11182 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgEELyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 07:54:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588679679; x=1620215679;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=8BQjmnGt09a7PAHU18wEkeIfDAmDAJHpQTHJEnn6w0k=;
  b=aUUbOoS2RtAtpHXKclGfaQLW6yeqezbmLc+xAOZADImRYqhuXlfysdcB
   DbKzin9MwuUY68ikfclv0PQHuf9nT7iXe8hGrqJPtTQiou6LarrqFPTh8
   7TpMroLAXhXLwllHhN0h78QiX22+f8v324m//4UsmIMjXt2GQVjjgjRci
   g=;
IronPort-SDR: FZlmZwqxqqUZrb6JmIrTHUBiXbJoSIHpzmQ1GRvTLuYiD3jqOlzFxcoLjShd7Mzo8yVjiLfolf
 NMGkI93GDOTw==
X-IronPort-AV: E=Sophos;i="5.73,354,1583193600"; 
   d="scan'208";a="28942070"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 05 May 2020 11:54:25 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id A54A5A22CE;
        Tue,  5 May 2020 11:54:24 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 11:54:24 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.161.204) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 11:54:18 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     SeongJae Park <sjpark@amazon.com>
CC:     <davem@davemloft.net>, <viro@zeniv.linux.org.uk>,
        <kuba@kernel.org>, <gregkh@linuxfoundation.org>,
        <edumazet@google.com>, <sj38.park@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, <snu@amazon.com>,
        <amit@kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
Date:   Tue, 5 May 2020 13:54:02 +0200
Message-ID: <20200505115402.25768-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505081035.7436-1-sjpark@amazon.com> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.204]
X-ClientProxiedBy: EX13D06UWC004.ant.amazon.com (10.43.162.97) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC-ing stable@vger.kernel.org and adding some more explanations.

On Tue, 5 May 2020 10:10:33 +0200 SeongJae Park <sjpark@amazon.com> wrote:

> From: SeongJae Park <sjpark@amazon.de>
> 
> The commit 6d7855c54e1e ("sockfs: switch to ->free_inode()") made the
> deallocation of 'socket_alloc' to be done asynchronously using RCU, as
> same to 'sock.wq'.  And the following commit 333f7909a857 ("coallocate
> socket_sq with socket itself") made those to have same life cycle.
> 
> The changes made the code much more simple, but also made 'socket_alloc'
> live longer than before.  For the reason, user programs intensively
> repeating allocations and deallocations of sockets could cause memory
> pressure on recent kernels.

I found this problem on a production virtual machine utilizing 4GB memory while
running lebench[1].  The 'poll big' test of lebench opens 1000 sockets, polls
and closes those.  This test is repeated 10,000 times.  Therefore it should
consume only 1000 'socket_alloc' objects at once.  As size of socket_alloc is
about 800 Bytes, it's only 800 KiB.  However, on the recent kernels, it could
consume up to 10,000,000 objects (about 8 GiB).  On the test machine, I
confirmed it consuming about 4GB of the system memory and results in OOM.

[1] https://github.com/LinuxPerfStudy/LEBench

> 
> To avoid the problem, this commit reverts the changes.

I also tried to make fixup rather than reverts, but I couldn't easily find
simple fixup.  As the commits 6d7855c54e1e and 333f7909a857 were for code
refactoring rather than performance optimization, I thought introducing complex
fixup for this problem would make no sense.  Meanwhile, the memory pressure
regression could affect real machines.  To this end, I decided to quickly
revert the commits first and consider better refactoring later.


Thanks,
SeongJae Park

> 
> SeongJae Park (2):
>   Revert "coallocate socket_wq with socket itself"
>   Revert "sockfs: switch to ->free_inode()"
> 
>  drivers/net/tap.c      |  5 +++--
>  drivers/net/tun.c      |  8 +++++---
>  include/linux/if_tap.h |  1 +
>  include/linux/net.h    |  4 ++--
>  include/net/sock.h     |  4 ++--
>  net/core/sock.c        |  2 +-
>  net/socket.c           | 23 ++++++++++++++++-------
>  7 files changed, 30 insertions(+), 17 deletions(-)
> 
> -- 
> 2.17.1
