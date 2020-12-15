Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486912DA6EB
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgLODlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:41:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgLODln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 22:41:43 -0500
Date:   Mon, 14 Dec 2020 19:41:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608003662;
        bh=BZ6+L14BALEBlEZN5aclup/NhEsGHeAS59yIV8zfbe8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=hC7chYTiroyWToVwiWV7C4BQjbJztHO5cQY94LcrJoWL0TaN3KVLvd9TjC2qWgAbi
         6jX7Vq52uQlhiFIxI+NEOrEoATNzN5iVweALtJQrttTxtTN6ez1QA4QuMIYWKD0BIk
         RR8UJteZrX8IG5k4tMAhp1PSmDFS4reT4zBOTASqwFy23g90rudHIRYiJ5iBpcOz+0
         L8IGomzskBKf+gxgBs92Kqf+UpavZFhPPqe3uvLTO2yrD46AUDpITCKCOazvI/n63x
         lEKN/qmXc3Cjh+TKd4VW3LAyIWX8Midmwxb9nypKv9KHMp39Z32B4xYMIgl2rDJRtp
         r09mJ2TSHcEuQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yonatan Linik <yonatanlinik@gmail.com>
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, willemb@google.com,
        john.ogness@linutronix.de, arnd@arndb.de, maowenan@huawei.com,
        colin.king@canonical.com, orcohen@paloaltonetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2 1/1] net: Fix use of proc_fs
Message-ID: <20201214194101.789109bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201214202550.3693-2-yonatanlinik@gmail.com>
References: <20201214202550.3693-1-yonatanlinik@gmail.com>
        <20201214202550.3693-2-yonatanlinik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 22:25:50 +0200 Yonatan Linik wrote:
> proc_fs was used, in af_packet, without a surrounding #ifdef,
> although there is no hard dependency on proc_fs.
> That caused the initialization of the af_packet module to fail
> when CONFIG_PROC_FS=n.
> 
> Specifically, proc_create_net() was used in af_packet.c,
> and when it fails, packet_net_init() returns -ENOMEM.
> It will always fail when the kernel is compiled without proc_fs,
> because, proc_create_net() for example always returns NULL.
> 
> The calling order that starts in af_packet.c is as follows:
> packet_init()
> register_pernet_subsys()
> register_pernet_operations()
> __register_pernet_operations()
> ops_init()
> ops->init() (packet_net_ops.init=packet_net_init())
> proc_create_net()
> 
> It worked in the past because register_pernet_subsys()'s return value
> wasn't checked before this Commit 36096f2f4fa0 ("packet: Fix error path in
> packet_init.").
> It always returned an error, but was not checked before, so everything
> was working even when CONFIG_PROC_FS=n.
> 
> The fix here is simply to add the necessary #ifdef.
> 
> This also fixes a similar error in tls_proc.c, that was found by Jakub
> Kicinski.
> 
> Signed-off-by: Yonatan Linik <yonatanlinik@gmail.com>

Applied, and queued for stable, thanks!
