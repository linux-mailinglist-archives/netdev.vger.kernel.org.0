Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173AD36E9DD
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 13:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbhD2L73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 07:59:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230148AbhD2L73 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 07:59:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 831836145A;
        Thu, 29 Apr 2021 11:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619697522;
        bh=lyNfyoxsqMlUGOpA/NkL35gSdKjhxCzdXm5yGHglZig=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bokxKh1aGS+yKBfQn3k9jpOkqTUrSa+PRpoxhdODJKRxZD+6i44WmQziUceLHcHDd
         VOd9FZYYJI0m9hG4S5O5We73OBw3dXnvrqThUP09lAOeaA/lmXQ/n7r/0NfOk1t3Oz
         HTh3qyMN/4QjnCH0wv9w8/AQWH7PtIjvM1rZMrZkjroIUjw6cCI5h6ut5ZrZ6Oc9Fs
         B+FhdtMapIh+q8JRlIYyRQuCpmVXn5L7ouKg1jgcW6wkAyyom55f2NOvthsC3v660N
         B5TcT4wxkwiBCCRKMaGWAR25WZvT+2pspEb3K9Y+2eKOJAHWeJyTovKGZls9VcvtP0
         1aew3bTUyTAbg==
Received: by mail-ej1-f47.google.com with SMTP id w3so99497697ejc.4;
        Thu, 29 Apr 2021 04:58:42 -0700 (PDT)
X-Gm-Message-State: AOAM530rs2WktsMhZXcsomXAq0Gev9jZz1Cy4TDoaQ9Xf8lWzhxur/GW
        EtGhPZmqtEAtlR8YHXXZfWZMtbVxFyxZFin+twY=
X-Google-Smtp-Source: ABdhPJzIW9XWBND47ohyx1jdYR+ajCfUvsZUaiihkpvKQz9aAeW9fdYN+2xvNjq5JNecjo89JIRcPgQ8PdO5ptqp7aM=
X-Received: by 2002:a17:906:4a55:: with SMTP id a21mr1199259ejv.215.1619697520822;
 Thu, 29 Apr 2021 04:58:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210420075406.64105-1-acelan.kao@canonical.com>
In-Reply-To: <20210420075406.64105-1-acelan.kao@canonical.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Thu, 29 Apr 2021 13:58:28 +0200
X-Gmail-Original-Message-ID: <CAJKOXPfp875V3zHorfyf+QLwia5HYX3N=AXe=xRCxCDi6ifbtg@mail.gmail.com>
Message-ID: <CAJKOXPfp875V3zHorfyf+QLwia5HYX3N=AXe=xRCxCDi6ifbtg@mail.gmail.com>
Subject: Re: [PATCH] net: called rtnl_unlock() before runpm resumes devices
To:     AceLan Kao <acelan.kao@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Apr 2021 at 09:55, AceLan Kao <acelan.kao@canonical.com> wrote:
>
> From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
>
> The rtnl_lock() has been called in rtnetlink_rcv_msg(), and then in
> __dev_open() it calls pm_runtime_resume() to resume devices, and in
> some devices' resume function(igb_resum,igc_resume) they calls rtnl_lock()
> again. That leads to a recursive lock.
>
> It should leave the devices' resume function to decide if they need to
> call rtnl_lock()/rtnl_unlock(), so call rtnl_unlock() before calling
> pm_runtime_resume() and then call rtnl_lock() after it in __dev_open().
>
> [  967.723577] INFO: task ip:6024 blocked for more than 120 seconds.
> [  967.723588]       Not tainted 5.12.0-rc3+ #1
> [  967.723592] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  967.723594] task:ip              state:D stack:    0 pid: 6024 ppid:  5957 flags:0x00004000
> [  967.723603] Call Trace:
> [  967.723610]  __schedule+0x2de/0x890
> [  967.723623]  schedule+0x4f/0xc0
> [  967.723629]  schedule_preempt_disabled+0xe/0x10
> [  967.723636]  __mutex_lock.isra.0+0x190/0x510
> [  967.723644]  __mutex_lock_slowpath+0x13/0x20
> [  967.723651]  mutex_lock+0x32/0x40
> [  967.723657]  rtnl_lock+0x15/0x20
> [  967.723665]  igb_resume+0xee/0x1d0 [igb]
> [  967.723687]  ? pci_pm_default_resume+0x30/0x30
> [  967.723696]  igb_runtime_resume+0xe/0x10 [igb]
> [  967.723713]  pci_pm_runtime_resume+0x74/0x90
> [  967.723718]  __rpm_callback+0x53/0x1c0
> [  967.723725]  rpm_callback+0x57/0x80
> [  967.723730]  ? pci_pm_default_resume+0x30/0x30
> [  967.723735]  rpm_resume+0x547/0x760
> [  967.723740]  __pm_runtime_resume+0x52/0x80
> [  967.723745]  __dev_open+0x56/0x160
> [  967.723753]  ? _raw_spin_unlock_bh+0x1e/0x20
> [  967.723758]  __dev_change_flags+0x188/0x1e0
> [  967.723766]  dev_change_flags+0x26/0x60
> [  967.723773]  do_setlink+0x723/0x10b0
> [  967.723782]  ? __nla_validate_parse+0x5b/0xb80
> [  967.723792]  __rtnl_newlink+0x594/0xa00
> [  967.723800]  ? nla_put_ifalias+0x38/0xa0
> [  967.723807]  ? __nla_reserve+0x41/0x50
> [  967.723813]  ? __nla_reserve+0x41/0x50
> [  967.723818]  ? __kmalloc_node_track_caller+0x49b/0x4d0
> [  967.723824]  ? pskb_expand_head+0x75/0x310
> [  967.723830]  ? nla_reserve+0x28/0x30
> [  967.723835]  ? skb_free_head+0x25/0x30
> [  967.723843]  ? security_sock_rcv_skb+0x2f/0x50
> [  967.723850]  ? netlink_deliver_tap+0x3d/0x210
> [  967.723859]  ? sk_filter_trim_cap+0xc1/0x230
> [  967.723863]  ? skb_queue_tail+0x43/0x50
> [  967.723870]  ? sock_def_readable+0x4b/0x80
> [  967.723876]  ? __netlink_sendskb+0x42/0x50
> [  967.723888]  ? security_capable+0x3d/0x60
> [  967.723894]  ? __cond_resched+0x19/0x30
> [  967.723900]  ? kmem_cache_alloc_trace+0x390/0x440
> [  967.723906]  rtnl_newlink+0x49/0x70
> [  967.723913]  rtnetlink_rcv_msg+0x13c/0x370
> [  967.723920]  ? _copy_to_iter+0xa0/0x460
> [  967.723927]  ? rtnl_calcit.isra.0+0x130/0x130
> [  967.723934]  netlink_rcv_skb+0x55/0x100
> [  967.723939]  rtnetlink_rcv+0x15/0x20
> [  967.723944]  netlink_unicast+0x1a8/0x250
> [  967.723949]  netlink_sendmsg+0x233/0x460
> [  967.723954]  sock_sendmsg+0x65/0x70
> [  967.723958]  ____sys_sendmsg+0x218/0x290
> [  967.723961]  ? copy_msghdr_from_user+0x5c/0x90
> [  967.723966]  ? lru_cache_add_inactive_or_unevictable+0x27/0xb0
> [  967.723974]  ___sys_sendmsg+0x81/0xc0
> [  967.723980]  ? __mod_memcg_lruvec_state+0x22/0xe0
> [  967.723987]  ? kmem_cache_free+0x244/0x420
> [  967.723991]  ? dentry_free+0x37/0x70
> [  967.723996]  ? mntput_no_expire+0x4c/0x260
> [  967.724001]  ? __cond_resched+0x19/0x30
> [  967.724007]  ? security_file_free+0x54/0x60
> [  967.724013]  ? call_rcu+0xa4/0x250
> [  967.724021]  __sys_sendmsg+0x62/0xb0
> [  967.724026]  ? exit_to_user_mode_prepare+0x3d/0x1a0
> [  967.724032]  __x64_sys_sendmsg+0x1f/0x30
> [  967.724037]  do_syscall_64+0x38/0x90
> [  967.724044]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
> ---
>  net/core/dev.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 1f79b9aa9a3f..427cbc80d1e5 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1537,8 +1537,11 @@ static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
>
>         if (!netif_device_present(dev)) {
>                 /* may be detached because parent is runtime-suspended */
> -               if (dev->dev.parent)
> +               if (dev->dev.parent) {
> +                       rtnl_unlock();
>                         pm_runtime_resume(dev->dev.parent);

A side topic, maybe a little bit silly question (I don't know that
much about net core):
Why not increase the parent or current PM runtime usage counter
instead? The problem with calling pm_runtime_resume() is that if the
parent device was already suspended (so it's usage counter ==0), it
might get suspended right after this call. IOW, you do not have any
guarantee that the device will be really resumed. Probably it should
be pm_runtime_resume_and_get() (and later "put" on close or other
events). This however might not solve the lock problem at all.

Best regards,
Krzysztof
