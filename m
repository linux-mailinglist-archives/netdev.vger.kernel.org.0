Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3226D21BBB9
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 19:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgGJRBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 13:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgGJRBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 13:01:23 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AAEC08C5DC
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 10:01:22 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 145so5923098qke.9
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 10:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kFQ0eUhz7HB9XG8MyoJEbUJZFoBck3nLYwhQTC8kEXs=;
        b=G8Ddc6zpHUvBqVBAtzeBrlvzY0nhRUemdn4D+Nz0r7JhxvyGamlxISCpeZ1TYBjEC+
         JC+6NSaBTObNMFSWunq2Q0upDz9/7t+L9mvcxnUsPNwJfsgcFJ3zGQvyWS892t1WDm6n
         FCdPrx8skAuGjtXd/DT0KUpwETSTVcH9IGwU4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kFQ0eUhz7HB9XG8MyoJEbUJZFoBck3nLYwhQTC8kEXs=;
        b=bTdnodrLxbf8Yn2Ojeb1/6xMlhW4X0VrYsywjFQUcJFgjp1yR04kGZtySFbGDzyiLi
         QEcaIDinr3zOUSLzjWsdFpOGorY8ia24fNEo7vI90kAmQIBD633ZaTUBP3toDSE2D4O5
         N5Z6qLNX2yPIZMiSd69tGtFx11KHWwk+BuEfdvGoD0p5EAFEsIJ/TrZ4XWaJClio/sPS
         zLxVWoklSUzSNy9wubDDeUEfayJeG+atxTNNSbdmYDalZNJAMLmtcjwTk4in9YHdl45h
         ZJpBo2tlGUalPfI4axhaAXmc0fgg+sSMt6Ia19vgJdDlsdjXhAhp+uSxAnmRfBxLaQHg
         yaCg==
X-Gm-Message-State: AOAM532/9Fr8tgEI2hLIbBu3NUhUwbS+tHcFcEwEu37VEtWgKeomH/ym
        TNWC8Fwmvd/69TvY+69oKLLG3nAtRbJJLKb54sn3Ng==
X-Google-Smtp-Source: ABdhPJxnnYyZu6K/bxbYJvfjaoUG4VO4HqVgGNrkZJg2hDV5xP1jBU+WlWt6x6PecGAKDa/dN9ALRzC4WhLNC51igCU=
X-Received: by 2002:a37:2c41:: with SMTP id s62mr63074738qkh.165.1594400481803;
 Fri, 10 Jul 2020 10:01:21 -0700 (PDT)
MIME-Version: 1.0
References: <44c96038dc3b3e78d2bb763ad5ea1e989694a68e.1594377971.git.dcaratti@redhat.com>
In-Reply-To: <44c96038dc3b3e78d2bb763ad5ea1e989694a68e.1594377971.git.dcaratti@redhat.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Fri, 10 Jul 2020 10:01:10 -0700
Message-ID: <CACKFLimcM8i1gA8LvAV3ny+mw-6GvjYRUYue-rkje1aobdFtvQ@mail.gmail.com>
Subject: Re: [PATCH net] bnxt_en: fix NULL dereference in case SR-IOV
 configuration fails
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>, feliu@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 3:55 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
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
> CC: Michael Chan <michael.chan@broadcom.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Reviewed-by: Michael Chan <michael.chan@broadcom.com>

Thanks.
