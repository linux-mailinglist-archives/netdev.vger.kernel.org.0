Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57DA4025FA
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 11:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244756AbhIGJLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 05:11:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243766AbhIGJLM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 05:11:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 62DA061100;
        Tue,  7 Sep 2021 09:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631005806;
        bh=EB27ps7wZ1ULN9yMmY3ZhqmKMQzC2+1rr3ug6ilsAp8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o3eO9kMTRQjmACPoH6/lYGl0o15r0Ekiq6KCAn/E1Fm9V3Q0NnDa931b8S+wauZoy
         ToATbszUSuuBmPhq74D9fAgmsZUYDNKH7GROSdoVI3pqmD/EJvEsFnr8VqTRuLdrpj
         59fGmTbd1XLBTqjHpmTbKjem4iyVnelDn/e5AG3l9aCA6FquTZqKokOFGk2ijpvic+
         kT86IPvCfnFcJ4nfhCOBjZiQl+LH/Vu93qr4+nOW3t+PqwJjaEtfyH8b5ZWBOHsPU0
         yBkWmuRrsI+ek8KKb/C6SEOiJlNHOcFsie/pJB8hf6Dn8ABFfnJSBnm+e7+KIaVkR+
         4VUaPZ2EUS5FQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5820460A6D;
        Tue,  7 Sep 2021 09:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] cxgb3: fix oops on module removal
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163100580635.1890.7604320936147832111.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Sep 2021 09:10:06 +0000
References: <2200f320-37dd-3a89-fc74-6f4003bbdf16@gmail.com>
In-Reply-To: <2200f320-37dd-3a89-fc74-6f4003bbdf16@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     rajur@chelsio.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, ihuguet@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 6 Sep 2021 22:51:33 +0200 you wrote:
> When removing the driver module w/o bringing an interface up before
> the error below occurs. Reason seems to be that cancel_work_sync() is
> called in t3_sge_stop() for a queue that hasn't been initialized yet.
> 
> [10085.941785] ------------[ cut here ]------------
> [10085.941799] WARNING: CPU: 1 PID: 5850 at kernel/workqueue.c:3074 __flush_work+0x3ff/0x480
> [10085.941819] Modules linked in: vfat snd_hda_codec_hdmi fat snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio led_class ee1004 iTCO_
> wdt intel_tcc_cooling x86_pkg_temp_thermal coretemp aesni_intel crypto_simd cryptd snd_hda_intel snd_intel_dspcfg snd_hda_codec snd_hda_core r
> 8169 snd_pcm realtek mdio_devres snd_timer snd i2c_i801 i2c_smbus libphy i915 i2c_algo_bit cxgb3(-) intel_gtt ttm mdio drm_kms_helper mei_me s
> yscopyarea sysfillrect sysimgblt mei fb_sys_fops acpi_pad sch_fq_codel crypto_user drm efivarfs ext4 mbcache jbd2 crc32c_intel
> [10085.941944] CPU: 1 PID: 5850 Comm: rmmod Not tainted 5.14.0-rc7-next-20210826+ #6
> [10085.941974] Hardware name: System manufacturer System Product Name/PRIME H310I-PLUS, BIOS 2603 10/21/2019
> [10085.941992] RIP: 0010:__flush_work+0x3ff/0x480
> [10085.942003] Code: c0 74 6b 65 ff 0d d1 bd 78 75 e8 bc 2f 06 00 48 c7 c6 68 b1 88 8a 48 c7 c7 e0 5f b4 8b 45 31 ff e8 e6 66 04 00 e9 4b fe ff ff <0f> 0b 45 31 ff e9 41 fe ff ff e8 72 c1 79 00 85 c0 74 87 80 3d 22
> [10085.942036] RSP: 0018:ffffa1744383fc08 EFLAGS: 00010246
> [10085.942048] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000923
> [10085.942062] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff91c901710a88
> [10085.942076] RBP: ffffa1744383fce8 R08: 0000000000000001 R09: 0000000000000001
> [10085.942090] R10: 00000000000000c2 R11: 0000000000000000 R12: ffff91c901710a88
> [10085.942104] R13: 0000000000000000 R14: ffff91c909a96100 R15: 0000000000000001
> [10085.942118] FS:  00007fe417837740(0000) GS:ffff91c969d00000(0000) knlGS:0000000000000000
> [10085.942134] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [10085.942146] CR2: 000055a8d567ecd8 CR3: 0000000121690003 CR4: 00000000003706e0
> [10085.942160] Call Trace:
> [10085.942166]  ? __lock_acquire+0x3af/0x22e0
> [10085.942177]  ? cancel_work_sync+0xb/0x10
> [10085.942187]  __cancel_work_timer+0x128/0x1b0
> [10085.942197]  ? __pm_runtime_resume+0x5b/0x90
> [10085.942208]  cancel_work_sync+0xb/0x10
> [10085.942217]  t3_sge_stop+0x2f/0x50 [cxgb3]
> [10085.942234]  remove_one+0x26/0x190 [cxgb3]
> [10085.942248]  pci_device_remove+0x39/0xa0
> [10085.942258]  __device_release_driver+0x15e/0x240
> [10085.942269]  driver_detach+0xd9/0x120
> [10085.942278]  bus_remove_driver+0x53/0xd0
> [10085.942288]  driver_unregister+0x2c/0x50
> [10085.942298]  pci_unregister_driver+0x31/0x90
> [10085.942307]  cxgb3_cleanup_module+0x10/0x18c [cxgb3]
> [10085.942324]  __do_sys_delete_module+0x191/0x250
> [10085.942336]  ? syscall_enter_from_user_mode+0x21/0x60
> [10085.942347]  ? trace_hardirqs_on+0x2a/0xe0
> [10085.942357]  __x64_sys_delete_module+0x13/0x20
> [10085.942368]  do_syscall_64+0x40/0x90
> [10085.942377]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [10085.942389] RIP: 0033:0x7fe41796323b
> 
> [...]

Here is the summary with links:
  - [net] cxgb3: fix oops on module removal
    https://git.kernel.org/netdev/net/c/be27a47a760e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


