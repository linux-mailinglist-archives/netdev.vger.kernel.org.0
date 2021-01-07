Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D147C2ED76A
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 20:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729104AbhAGTW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 14:22:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:43858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbhAGTW4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 14:22:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 344DC2343E;
        Thu,  7 Jan 2021 19:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610047335;
        bh=NKw13higlPr7vxzB65i0Cno3rCSi5GgoNmc9KiXS7aU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FFUHOYm4fGslJBrEI3tMqpjOdxIsJRcY7KGUtSXzsYm+IouqlCVZSwUu1I0IcqLYg
         pa1iqbPmANkZUHKdtsYENCOXEbXGOcaVSoTHNm/3QsQa8vexrZtnW1OfHfVjiWQkw3
         jSBfItYfMkzgHVFMWSzoaxFRHufsbU2Pzr7qF+OVqMkOwdJhBDA+9yyZf/CEzRMlsg
         wRRaEeVlcEbcAgWAqisfiJo+BoWn9Idj+XadS5mDpGJI+ZX+tGHoI3G3IqCCcRtOWO
         FaGtte1ynguFP5Vgotdbb0OpKx8gho1ahFxvXKM9EoOmvvyz2EwPAs/BY37mtH/Tn5
         9mQcSoAI44YRw==
Date:   Thu, 7 Jan 2021 11:22:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>
Cc:     netdev@vger.kernel.org, ying.xue@windriver.com, maloy@donjonn.com,
        jmaloy@redhat.com
Subject: Re: [net] tipc: fix NULL deref in tipc_link_xmit()
Message-ID: <20210107112214.61ffc4f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107033419.8090-1-hoang.h.le@dektech.com.au>
References: <20210107033419.8090-1-hoang.h.le@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Jan 2021 10:34:19 +0700 Hoang Huu Le wrote:
> From: Hoang Le <hoang.h.le@dektech.com.au>
> 
> The buffer list can have zero skb as following path:
> tipc_named_node_up()->tipc_node_xmit()->tipc_link_xmit(), so
> we need to check the list before casting an &sk_buff.
> 
> Fault report:
>  [] tipc: Bulk publication failure
>  [] general protection fault, probably for non-canonical [#1] PREEMPT [...]
>  [] KASAN: null-ptr-deref in range [0x00000000000000c8-0x00000000000000cf]
>  [] CPU: 0 PID: 0 Comm: swapper/0 Kdump: loaded Not tainted 5.10.0-rc4+ #2
>  [] Hardware name: Bochs ..., BIOS Bochs 01/01/2011
>  [] RIP: 0010:tipc_link_xmit+0xc1/0x2180
>  [] Code: 24 b8 00 00 00 00 4d 39 ec 4c 0f 44 e8 e8 d7 0a 10 f9 48 [...]
>  [] RSP: 0018:ffffc90000006ea0 EFLAGS: 00010202
>  [] RAX: dffffc0000000000 RBX: ffff8880224da000 RCX: 1ffff11003d3cc0d
>  [] RDX: 0000000000000019 RSI: ffffffff886007b9 RDI: 00000000000000c8
>  [] RBP: ffffc90000007018 R08: 0000000000000001 R09: fffff52000000ded
>  [] R10: 0000000000000003 R11: fffff52000000dec R12: ffffc90000007148
>  [] R13: 0000000000000000 R14: 0000000000000000 R15: ffffc90000007018
>  [] FS:  0000000000000000(0000) GS:ffff888037400000(0000) knlGS:000[...]
>  [] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  [] CR2: 00007fffd2db5000 CR3: 000000002b08f000 CR4: 00000000000006f0
> 
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>

Can we get a Fixes tag?
