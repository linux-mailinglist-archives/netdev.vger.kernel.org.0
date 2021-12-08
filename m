Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF80146D72F
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 16:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236199AbhLHPoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbhLHPoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 10:44:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550B7C061746;
        Wed,  8 Dec 2021 07:40:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1873B8169E;
        Wed,  8 Dec 2021 15:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339CDC341C7;
        Wed,  8 Dec 2021 15:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638978047;
        bh=sCrhisWZMIILr8ekJ2MwM7LZIYTIdDxf4VpcG3GHNGo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Soe6RpbKBeM38JlLp9FJmpQ1szUiEcZlfZ3jzWlJhtQ5o+vp1jGaPg8kFbJYpVCO4
         YTAg4BAaUKkXQXV9hq6O6Px+lW4QVxr2AVC17vgA853SHl3dsXATHK+2Hf2/FvWzjz
         l1qsaD2LcfGG5atOZES4RX9mvf81TYNFiFmXrlJA=
Date:   Wed, 8 Dec 2021 16:40:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tun: avoid double free in tun_free_netdev
Message-ID: <YbDR/JStiIco3HQS@kroah.com>
References: <1638974605-24085-1-git-send-email-george.kennedy@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638974605-24085-1-git-send-email-george.kennedy@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 09:43:25AM -0500, George Kennedy wrote:
> Avoid double free in tun_free_netdev() by clearing tun->security
> after free and using it to indicate that free has already been done.
> 
> BUG: KASAN: double-free or invalid-free in selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
> 
> CPU: 0 PID: 25750 Comm: syz-executor416 Not tainted 5.16.0-rc2-syzk #1
> Hardware name: Red Hat KVM, BIOS
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:106
>  print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c:247
>  kasan_report_invalid_free+0x55/0x80 mm/kasan/report.c:372
>  ____kasan_slab_free mm/kasan/common.c:346 [inline]
>  __kasan_slab_free+0x107/0x120 mm/kasan/common.c:374
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:1723 [inline]
>  slab_free_freelist_hook mm/slub.c:1749 [inline]
>  slab_free mm/slub.c:3513 [inline]
>  kfree+0xac/0x2d0 mm/slub.c:4561
>  selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
>  security_tun_dev_free_security+0x4f/0x90 security/security.c:2342
>  tun_free_netdev+0xe6/0x150 drivers/net/tun.c:2215
>  netdev_run_todo+0x4df/0x840 net/core/dev.c:10627
>  rtnl_unlock+0x13/0x20 net/core/rtnetlink.c:112
>  __tun_chr_ioctl+0x80c/0x2870 drivers/net/tun.c:3302
>  tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:874 [inline]
>  __se_sys_ioctl fs/ioctl.c:860 [inline]
>  __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Reported-by: syzkaller <syzkaller@googlegroups.com>
> Signed-off-by: George Kennedy <george.kennedy@oracle.com>
> ---
>  drivers/net/tun.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 1572878..617c71f 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2212,7 +2212,10 @@ static void tun_free_netdev(struct net_device *dev)
>  	dev->tstats = NULL;
>  
>  	tun_flow_uninit(tun);
> -	security_tun_dev_free_security(tun->security);
> +	if (tun->security) {
> +		security_tun_dev_free_security(tun->security);
> +		tun->security = NULL;
> +	}
>  	__tun_set_ebpf(tun, &tun->steering_prog, NULL);
>  	__tun_set_ebpf(tun, &tun->filter_prog, NULL);
>  }
> @@ -2779,7 +2782,11 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
>  
>  err_free_flow:
>  	tun_flow_uninit(tun);
> -	security_tun_dev_free_security(tun->security);
> +	if (tun->security) {
> +		security_tun_dev_free_security(tun->security);
> +		/* Let tun_free_netdev() know the free has already been done. */
> +		tun->security = NULL;

What protects this from racing with tun_free_netdev()?

And why can't security_tun_dev_free_security() handle a NULL value?

thanks,

greg k-h
