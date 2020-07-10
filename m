Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580FF21BD19
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 20:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgGJShT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 14:37:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53362 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727082AbgGJShT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 14:37:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594406238;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/16CXVlkDyv9UJH6EiLYdF23kKmtfETALC5FdKRcVLY=;
        b=b0q+fPBwPVa6SRGs37t18GFs3BmwXsRZ4VUC9Z/T4kUub5q1vV8L5xkiVNlNvgM/OkFqF5
        DQJnJ+GJCnsIFtOsppUEY1F12Hs4GnkQlcY05Z/teuhWvnPUvlk9rNmypQn93bEeUITH8W
        TfZej2ZoQ5Sn8bjY+EuP+XJTI7Sb3lo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-5xLR7JX9P5SDcv7jl6I-fA-1; Fri, 10 Jul 2020 14:37:14 -0400
X-MC-Unique: 5xLR7JX9P5SDcv7jl6I-fA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 802251902EA0;
        Fri, 10 Jul 2020 18:37:13 +0000 (UTC)
Received: from jtoppins.rdu.csb (ovpn-112-244.rdu2.redhat.com [10.10.112.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE7BC6FEF5;
        Fri, 10 Jul 2020 18:37:12 +0000 (UTC)
Reply-To: jtoppins@redhat.com
Subject: Re: [PATCH net] bnxt_en: fix NULL dereference in case SR-IOV
 configuration fails
To:     Davide Caratti <dcaratti@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     feliu@redhat.com
References: <44c96038dc3b3e78d2bb763ad5ea1e989694a68e.1594377971.git.dcaratti@redhat.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
Organization: Red Hat
Message-ID: <3753284c-9d10-57c3-5564-ea3b4ab9730c@redhat.com>
Date:   Fri, 10 Jul 2020 14:37:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <44c96038dc3b3e78d2bb763ad5ea1e989694a68e.1594377971.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/20 6:55 AM, Davide Caratti wrote:
> we need to set 'active_vfs' back to 0, if something goes wrong during the
> allocation of SR-IOV resources: otherwise, further VF configurations will
> wrongly assume that bp->pf.vf[x] are valid memory locations, and commands
> like the ones in the following sequence:
> 
>  # echo 2 >/sys/bus/pci/devices/${ADDR}/sriov_numvfs
>  # ip link set dev ens1f0np0 up
>  # ip link set dev ens1f0np0 vf 0 trust on
> 
> will cause a kernel crash similar to this:
> 
>  bnxt_en 0000:3b:00.0: not enough MMIO resources for SR-IOV
>  BUG: kernel NULL pointer dereference, address: 0000000000000014
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 0 P4D 0
>  Oops: 0000 [#1] SMP PTI
>  CPU: 43 PID: 2059 Comm: ip Tainted: G          I       5.8.0-rc2.upstream+ #871
>  Hardware name: Dell Inc. PowerEdge R740/08D89F, BIOS 2.2.11 06/13/2019
>  RIP: 0010:bnxt_set_vf_trust+0x5b/0x110 [bnxt_en]
>  Code: 44 24 58 31 c0 e8 f5 fb ff ff 85 c0 0f 85 b6 00 00 00 48 8d 1c 5b 41 89 c6 b9 0b 00 00 00 48 c1 e3 04 49 03 9c 24 f0 0e 00 00 <8b> 43 14 89 c2 83 c8 10 83 e2 ef 45 84 ed 49 89 e5 0f 44 c2 4c 89
>  RSP: 0018:ffffac6246a1f570 EFLAGS: 00010246
>  RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000000b
>  RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff98b28f538900
>  RBP: ffff98b28f538900 R08: 0000000000000000 R09: 0000000000000008
>  R10: ffffffffb9515be0 R11: ffffac6246a1f678 R12: ffff98b28f538000
>  R13: 0000000000000001 R14: 0000000000000000 R15: ffffffffc05451e0
>  FS:  00007fde0f688800(0000) GS:ffff98baffd40000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000014 CR3: 000000104bb0a003 CR4: 00000000007606e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  PKRU: 55555554
>  Call Trace:
>   do_setlink+0x994/0xfe0
>   __rtnl_newlink+0x544/0x8d0
>   rtnl_newlink+0x47/0x70
>   rtnetlink_rcv_msg+0x29f/0x350
>   netlink_rcv_skb+0x4a/0x110
>   netlink_unicast+0x21d/0x300
>   netlink_sendmsg+0x329/0x450
>   sock_sendmsg+0x5b/0x60
>   ____sys_sendmsg+0x204/0x280
>   ___sys_sendmsg+0x88/0xd0
>   __sys_sendmsg+0x5e/0xa0
>   do_syscall_64+0x47/0x80
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Fixes: c0c050c58d840 ("bnxt_en: New Broadcom ethernet driver.")
> Reported-by: Fei Liu <feliu@redhat.com>
> CC: Jonathan Toppins <jtoppins@redhat.com>

Acked-by: Jonathan Toppins <jtoppins@redhat.com>

> CC: Michael Chan <michael.chan@broadcom.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---

