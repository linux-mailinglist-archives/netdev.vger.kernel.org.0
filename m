Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FFE365396
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 09:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhDTHyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 03:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhDTHym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 03:54:42 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3A4C06174A;
        Tue, 20 Apr 2021 00:54:09 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id s14so14550286pjl.5;
        Tue, 20 Apr 2021 00:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ke/YR/P2u+Tpx4KPA57i+VGmo9ckKXtimwr72CBdflY=;
        b=TBon4ejEdfyPf45ZQEv44fhDBiKbIyGGygqrFBMsj/lgNVefNCOh+s0hKnj36+Mr0S
         mq9w7FcnCcHT1xMjR2Fq6SBnXy9kbMBhKvoqBElLxM36FeQm3vZzQQv/QaVO75h3AsRV
         wgtUabWX8glAW9qLXLKzMH8W5Ib3HM4G2kjVDmg48lRWVL6s2tFuhTscnlxxThYw/+mK
         5Ct1BMqAYPk0uJk4ob6bGQtSG3z+aSz8/tWfZyDtkOTAz60qCZy5oiyYApIQzLeYuYJR
         UrArmW4M+i2vbSD3oG1PtVPlov2EXGoJXwu6URIQu01OowbSEplwUF8W10tiYDCwGlEC
         IEZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Ke/YR/P2u+Tpx4KPA57i+VGmo9ckKXtimwr72CBdflY=;
        b=bCHLABcM554I67ALuH/JhGl5/GkmaOhO9WO8x4n0w1OVRh08dByTkBfOWaKJM7vVY7
         9zFVgLw7D+Gf3tsjMPvvznUck6cU0E1XiEpDGSArIXnY9UuWIW2ugREM6vUxAIOiYhZ+
         +vtYnY8Yoyw3RdYgklrEzuuq1E+T0rDszAwjiIo9MTWB/2O0o2KkFJwZzyVTvQdTMJvz
         yuxR8BDG8U1y7wB7SfxHyIyZFVlqbH4bWLDsViLCQo7U6mnDhOPqfLBhE+sYDOTMeYjj
         lA78hbUlQa5jNHfHVdWL+L48YBeH9VQ381DblbPSkWmknqbVuvyWy9M6W8FPWV/W3HVt
         M9jg==
X-Gm-Message-State: AOAM530RpfjjIQaKgdaM9SsLqjaMlyTmQWRPMkA1Nm9hH1UNjcX6aTWR
        IunnpxcLON91mvcyHGd/MCo=
X-Google-Smtp-Source: ABdhPJwd2xuyhLHRhZypxTgCkTxEfR4+k+OuBG25+iyBAE51EkqrPoKEdm1EfKWi5yrfSH039szw0Q==
X-Received: by 2002:a17:90a:c8:: with SMTP id v8mr3617344pjd.18.1618905249046;
        Tue, 20 Apr 2021 00:54:09 -0700 (PDT)
Received: from localhost (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id pc17sm528432pjb.19.2021.04.20.00.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 00:54:07 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
From:   AceLan Kao <acelan.kao@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: called rtnl_unlock() before runpm resumes devices
Date:   Tue, 20 Apr 2021 15:54:05 +0800
Message-Id: <20210420075406.64105-1-acelan.kao@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>

The rtnl_lock() has been called in rtnetlink_rcv_msg(), and then in
__dev_open() it calls pm_runtime_resume() to resume devices, and in
some devices' resume function(igb_resum,igc_resume) they calls rtnl_lock()
again. That leads to a recursive lock.

It should leave the devices' resume function to decide if they need to
call rtnl_lock()/rtnl_unlock(), so call rtnl_unlock() before calling
pm_runtime_resume() and then call rtnl_lock() after it in __dev_open().

[  967.723577] INFO: task ip:6024 blocked for more than 120 seconds.
[  967.723588]       Not tainted 5.12.0-rc3+ #1
[  967.723592] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  967.723594] task:ip              state:D stack:    0 pid: 6024 ppid:  5957 flags:0x00004000
[  967.723603] Call Trace:
[  967.723610]  __schedule+0x2de/0x890
[  967.723623]  schedule+0x4f/0xc0
[  967.723629]  schedule_preempt_disabled+0xe/0x10
[  967.723636]  __mutex_lock.isra.0+0x190/0x510
[  967.723644]  __mutex_lock_slowpath+0x13/0x20
[  967.723651]  mutex_lock+0x32/0x40
[  967.723657]  rtnl_lock+0x15/0x20
[  967.723665]  igb_resume+0xee/0x1d0 [igb]
[  967.723687]  ? pci_pm_default_resume+0x30/0x30
[  967.723696]  igb_runtime_resume+0xe/0x10 [igb]
[  967.723713]  pci_pm_runtime_resume+0x74/0x90
[  967.723718]  __rpm_callback+0x53/0x1c0
[  967.723725]  rpm_callback+0x57/0x80
[  967.723730]  ? pci_pm_default_resume+0x30/0x30
[  967.723735]  rpm_resume+0x547/0x760
[  967.723740]  __pm_runtime_resume+0x52/0x80
[  967.723745]  __dev_open+0x56/0x160
[  967.723753]  ? _raw_spin_unlock_bh+0x1e/0x20
[  967.723758]  __dev_change_flags+0x188/0x1e0
[  967.723766]  dev_change_flags+0x26/0x60
[  967.723773]  do_setlink+0x723/0x10b0
[  967.723782]  ? __nla_validate_parse+0x5b/0xb80
[  967.723792]  __rtnl_newlink+0x594/0xa00
[  967.723800]  ? nla_put_ifalias+0x38/0xa0
[  967.723807]  ? __nla_reserve+0x41/0x50
[  967.723813]  ? __nla_reserve+0x41/0x50
[  967.723818]  ? __kmalloc_node_track_caller+0x49b/0x4d0
[  967.723824]  ? pskb_expand_head+0x75/0x310
[  967.723830]  ? nla_reserve+0x28/0x30
[  967.723835]  ? skb_free_head+0x25/0x30
[  967.723843]  ? security_sock_rcv_skb+0x2f/0x50
[  967.723850]  ? netlink_deliver_tap+0x3d/0x210
[  967.723859]  ? sk_filter_trim_cap+0xc1/0x230
[  967.723863]  ? skb_queue_tail+0x43/0x50
[  967.723870]  ? sock_def_readable+0x4b/0x80
[  967.723876]  ? __netlink_sendskb+0x42/0x50
[  967.723888]  ? security_capable+0x3d/0x60
[  967.723894]  ? __cond_resched+0x19/0x30
[  967.723900]  ? kmem_cache_alloc_trace+0x390/0x440
[  967.723906]  rtnl_newlink+0x49/0x70
[  967.723913]  rtnetlink_rcv_msg+0x13c/0x370
[  967.723920]  ? _copy_to_iter+0xa0/0x460
[  967.723927]  ? rtnl_calcit.isra.0+0x130/0x130
[  967.723934]  netlink_rcv_skb+0x55/0x100
[  967.723939]  rtnetlink_rcv+0x15/0x20
[  967.723944]  netlink_unicast+0x1a8/0x250
[  967.723949]  netlink_sendmsg+0x233/0x460
[  967.723954]  sock_sendmsg+0x65/0x70
[  967.723958]  ____sys_sendmsg+0x218/0x290
[  967.723961]  ? copy_msghdr_from_user+0x5c/0x90
[  967.723966]  ? lru_cache_add_inactive_or_unevictable+0x27/0xb0
[  967.723974]  ___sys_sendmsg+0x81/0xc0
[  967.723980]  ? __mod_memcg_lruvec_state+0x22/0xe0
[  967.723987]  ? kmem_cache_free+0x244/0x420
[  967.723991]  ? dentry_free+0x37/0x70
[  967.723996]  ? mntput_no_expire+0x4c/0x260
[  967.724001]  ? __cond_resched+0x19/0x30
[  967.724007]  ? security_file_free+0x54/0x60
[  967.724013]  ? call_rcu+0xa4/0x250
[  967.724021]  __sys_sendmsg+0x62/0xb0
[  967.724026]  ? exit_to_user_mode_prepare+0x3d/0x1a0
[  967.724032]  __x64_sys_sendmsg+0x1f/0x30
[  967.724037]  do_syscall_64+0x38/0x90
[  967.724044]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
---
 net/core/dev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1f79b9aa9a3f..427cbc80d1e5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1537,8 +1537,11 @@ static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 
 	if (!netif_device_present(dev)) {
 		/* may be detached because parent is runtime-suspended */
-		if (dev->dev.parent)
+		if (dev->dev.parent) {
+			rtnl_unlock();
 			pm_runtime_resume(dev->dev.parent);
+			rtnl_lock();
+		}
 		if (!netif_device_present(dev))
 			return -ENODEV;
 	}
-- 
2.25.1

