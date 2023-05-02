Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE056F449E
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 15:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbjEBNFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 09:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234248AbjEBNEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 09:04:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15AC72A4
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 06:03:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1785061792
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 13:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805C7C433EF;
        Tue,  2 May 2023 13:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683032606;
        bh=Oy705wmPZq9J9RJgznHF1ey4xCpJYiyTAHgBxwHiyE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q2l6rZrvcU43npY0cZYZIaSPN4meyX/s3aSKoi3Oa+5YSKt3URXGb1lnHS1CabKkh
         pBXWiREb09ZrYAG5fWvaYZHVPNRr+xvZe06vHMTDar4MYweRmsywjSpgK017uJh3s2
         3M4Coui5SojNvN1DXKk36m3qIwc2xVcYT8PsVyg/fD8LZGVFam3Tf+lCjYkJrl5rvR
         X+TfrVXXcQVASOZP5ds6OuiAl2o+owr5Vr6XS2I1ltVaUzadsGvdFnyCZ5qZfdJe2o
         G1dJCC8cTxKYRq/WCAvJCefSHY80oGjy2/lDRUyexl9m+SAd4sMUUIU5D3JRyOhMQS
         stdS6t/gYpeZQ==
Date:   Tue, 2 May 2023 16:03:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, danieller@nvidia.com,
        mlxsw@nvidia.com
Subject: Re: [PATCH net] ethtool: Fix uninitialized number of lanes
Message-ID: <20230502130321.GB525452@unreal>
References: <20230502122050.917205-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502122050.917205-1-idosch@nvidia.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 03:20:50PM +0300, Ido Schimmel wrote:
> It is not possible to set the number of lanes when setting link modes
> using the legacy IOCTL ethtool interface. Since 'struct
> ethtool_link_ksettings' is not initialized in this path, drivers receive
> an uninitialized number of lanes in 'struct
> ethtool_link_ksettings::lanes'.
> 
> When this information is later queried from drivers, it results in the
> ethtool code making decisions based on uninitialized memory, leading to
> the following KMSAN splat [1]. In practice, this most likely only
> happens with the tun driver that simply returns whatever it got in the
> set operation.
> 
> As far as I can tell, this uninitialized memory is not leaked to user
> space thanks to the 'ethtool_ops->cap_link_lanes_supported' check in
> linkmodes_prepare_data().
> 
> Fix by initializing the structure in the IOCTL path. Did not find any
> more call sites that pass an uninitialized structure when calling
> 'ethtool_ops::set_link_ksettings()'.
> 
> [1]
> BUG: KMSAN: uninit-value in ethnl_update_linkmodes net/ethtool/linkmodes.c:273 [inline]
> BUG: KMSAN: uninit-value in ethnl_set_linkmodes+0x190b/0x19d0 net/ethtool/linkmodes.c:333
>  ethnl_update_linkmodes net/ethtool/linkmodes.c:273 [inline]
>  ethnl_set_linkmodes+0x190b/0x19d0 net/ethtool/linkmodes.c:333
>  ethnl_default_set_doit+0x88d/0xde0 net/ethtool/netlink.c:640
>  genl_family_rcv_msg_doit net/netlink/genetlink.c:968 [inline]
>  genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
>  genl_rcv_msg+0x141a/0x14c0 net/netlink/genetlink.c:1065
>  netlink_rcv_skb+0x3f8/0x750 net/netlink/af_netlink.c:2577
>  genl_rcv+0x40/0x60 net/netlink/genetlink.c:1076
>  netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
>  netlink_unicast+0xf41/0x1270 net/netlink/af_netlink.c:1365
>  netlink_sendmsg+0x127d/0x1430 net/netlink/af_netlink.c:1942
>  sock_sendmsg_nosec net/socket.c:724 [inline]
>  sock_sendmsg net/socket.c:747 [inline]
>  ____sys_sendmsg+0xa24/0xe40 net/socket.c:2501
>  ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2555
>  __sys_sendmsg net/socket.c:2584 [inline]
>  __do_sys_sendmsg net/socket.c:2593 [inline]
>  __se_sys_sendmsg net/socket.c:2591 [inline]
>  __x64_sys_sendmsg+0x36b/0x540 net/socket.c:2591
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Uninit was stored to memory at:
>  tun_get_link_ksettings+0x37/0x60 drivers/net/tun.c:3544
>  __ethtool_get_link_ksettings+0x17b/0x260 net/ethtool/ioctl.c:441
>  ethnl_set_linkmodes+0xee/0x19d0 net/ethtool/linkmodes.c:327
>  ethnl_default_set_doit+0x88d/0xde0 net/ethtool/netlink.c:640
>  genl_family_rcv_msg_doit net/netlink/genetlink.c:968 [inline]
>  genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
>  genl_rcv_msg+0x141a/0x14c0 net/netlink/genetlink.c:1065
>  netlink_rcv_skb+0x3f8/0x750 net/netlink/af_netlink.c:2577
>  genl_rcv+0x40/0x60 net/netlink/genetlink.c:1076
>  netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
>  netlink_unicast+0xf41/0x1270 net/netlink/af_netlink.c:1365
>  netlink_sendmsg+0x127d/0x1430 net/netlink/af_netlink.c:1942
>  sock_sendmsg_nosec net/socket.c:724 [inline]
>  sock_sendmsg net/socket.c:747 [inline]
>  ____sys_sendmsg+0xa24/0xe40 net/socket.c:2501
>  ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2555
>  __sys_sendmsg net/socket.c:2584 [inline]
>  __do_sys_sendmsg net/socket.c:2593 [inline]
>  __se_sys_sendmsg net/socket.c:2591 [inline]
>  __x64_sys_sendmsg+0x36b/0x540 net/socket.c:2591
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Uninit was stored to memory at:
>  tun_set_link_ksettings+0x37/0x60 drivers/net/tun.c:3553
>  ethtool_set_link_ksettings+0x600/0x690 net/ethtool/ioctl.c:609
>  __dev_ethtool net/ethtool/ioctl.c:3024 [inline]
>  dev_ethtool+0x1db9/0x2a70 net/ethtool/ioctl.c:3078
>  dev_ioctl+0xb07/0x1270 net/core/dev_ioctl.c:524
>  sock_do_ioctl+0x295/0x540 net/socket.c:1213
>  sock_ioctl+0x729/0xd90 net/socket.c:1316
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:870 [inline]
>  __se_sys_ioctl+0x222/0x400 fs/ioctl.c:856
>  __x64_sys_ioctl+0x96/0xe0 fs/ioctl.c:856
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Local variable link_ksettings created at:
>  ethtool_set_link_ksettings+0x54/0x690 net/ethtool/ioctl.c:577
>  __dev_ethtool net/ethtool/ioctl.c:3024 [inline]
>  dev_ethtool+0x1db9/0x2a70 net/ethtool/ioctl.c:3078
> 
> Fixes: 012ce4dd3102 ("ethtool: Extend link modes settings uAPI with lanes")
> Reported-and-tested-by: syzbot+ef6edd9f1baaa54d6235@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/netdev/0000000000004bb41105fa70f361@google.com/
> Reviewed-by: Danielle Ratson <danieller@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ethtool/ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
