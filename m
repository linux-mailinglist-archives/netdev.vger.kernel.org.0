Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB4C4C96B0
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 21:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238151AbiCAUZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 15:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238696AbiCAUXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 15:23:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE4B7EB2D;
        Tue,  1 Mar 2022 12:21:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EDA2B81D4B;
        Tue,  1 Mar 2022 20:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAB7C340EE;
        Tue,  1 Mar 2022 20:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646166056;
        bh=mYOW8nySUsb+Cg+OgPAYDtJqcyQT9cKYqnUBarEV7Wg=;
        h=From:To:Cc:Subject:Date:From;
        b=fTmxDfn+TRNPd6wWX/5Ed8MpDdh0aJaIIo+wVkhO60fPV57Mw/y06JXvJUpfqmXgT
         l85xpoPS9Y9jE//kHViigw6Cx9NrHD1keIZINidMPtC8EEXsp6OMEXdgCj/hwmiYG6
         tGrZqQEUh8yVmQz9N/78Ed7Lsz5AqlgjJsCj/XDEj/hxoUxk+X+Juh15i7KZ0YtdkJ
         6sGbKs42gd6/OqCbqGbDGpsdLz8e69rPZ23ZecJqowCNtPf5TYcdBtZGEYQhs5Qq4H
         c4mGye1pjg7WJEKv/Bvl3NLqhf1TrH3RcuTCcd1tt/X4AQ9E1Tksr2XhtF5Lz4Tv5T
         CbU4j9AxEeuQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     suresh kumar <suresh2514@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        atenart@kernel.org, edumazet@google.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 1/7] net-sysfs: add check for netdevice being present to speed_show
Date:   Tue,  1 Mar 2022 15:20:39 -0500
Message-Id: <20220301202046.19220-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: suresh kumar <suresh2514@gmail.com>

[ Upstream commit 4224cfd7fb6523f7a9d1c8bb91bb5df1e38eb624 ]

When bringing down the netdevice or system shutdown, a panic can be
triggered while accessing the sysfs path because the device is already
removed.

    [  755.549084] mlx5_core 0000:12:00.1: Shutdown was called
    [  756.404455] mlx5_core 0000:12:00.0: Shutdown was called
    ...
    [  757.937260] BUG: unable to handle kernel NULL pointer dereference at           (null)
    [  758.031397] IP: [<ffffffff8ee11acb>] dma_pool_alloc+0x1ab/0x280

    crash> bt
    ...
    PID: 12649  TASK: ffff8924108f2100  CPU: 1   COMMAND: "amsd"
    ...
     #9 [ffff89240e1a38b0] page_fault at ffffffff8f38c778
        [exception RIP: dma_pool_alloc+0x1ab]
        RIP: ffffffff8ee11acb  RSP: ffff89240e1a3968  RFLAGS: 00010046
        RAX: 0000000000000246  RBX: ffff89243d874100  RCX: 0000000000001000
        RDX: 0000000000000000  RSI: 0000000000000246  RDI: ffff89243d874090
        RBP: ffff89240e1a39c0   R8: 000000000001f080   R9: ffff8905ffc03c00
        R10: ffffffffc04680d4  R11: ffffffff8edde9fd  R12: 00000000000080d0
        R13: ffff89243d874090  R14: ffff89243d874080  R15: 0000000000000000
        ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
    #10 [ffff89240e1a39c8] mlx5_alloc_cmd_msg at ffffffffc04680f3 [mlx5_core]
    #11 [ffff89240e1a3a18] cmd_exec at ffffffffc046ad62 [mlx5_core]
    #12 [ffff89240e1a3ab8] mlx5_cmd_exec at ffffffffc046b4fb [mlx5_core]
    #13 [ffff89240e1a3ae8] mlx5_core_access_reg at ffffffffc0475434 [mlx5_core]
    #14 [ffff89240e1a3b40] mlx5e_get_fec_caps at ffffffffc04a7348 [mlx5_core]
    #15 [ffff89240e1a3bb0] get_fec_supported_advertised at ffffffffc04992bf [mlx5_core]
    #16 [ffff89240e1a3c08] mlx5e_get_link_ksettings at ffffffffc049ab36 [mlx5_core]
    #17 [ffff89240e1a3ce8] __ethtool_get_link_ksettings at ffffffff8f25db46
    #18 [ffff89240e1a3d48] speed_show at ffffffff8f277208
    #19 [ffff89240e1a3dd8] dev_attr_show at ffffffff8f0b70e3
    #20 [ffff89240e1a3df8] sysfs_kf_seq_show at ffffffff8eedbedf
    #21 [ffff89240e1a3e18] kernfs_seq_show at ffffffff8eeda596
    #22 [ffff89240e1a3e28] seq_read at ffffffff8ee76d10
    #23 [ffff89240e1a3e98] kernfs_fop_read at ffffffff8eedaef5
    #24 [ffff89240e1a3ed8] vfs_read at ffffffff8ee4e3ff
    #25 [ffff89240e1a3f08] sys_read at ffffffff8ee4f27f
    #26 [ffff89240e1a3f50] system_call_fastpath at ffffffff8f395f92

    crash> net_device.state ffff89443b0c0000
      state = 0x5  (__LINK_STATE_START| __LINK_STATE_NOCARRIER)

To prevent this scenario, we also make sure that the netdevice is present.

Signed-off-by: suresh kumar <suresh2514@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index e5dc04cb55992..7a11b2d90975d 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -203,7 +203,7 @@ static ssize_t speed_show(struct device *dev,
 	if (!rtnl_trylock())
 		return restart_syscall();
 
-	if (netif_running(netdev)) {
+	if (netif_running(netdev) && netif_device_present(netdev)) {
 		struct ethtool_link_ksettings cmd;
 
 		if (!__ethtool_get_link_ksettings(netdev, &cmd))
-- 
2.34.1

