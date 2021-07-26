Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCB03D6A53
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 01:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhGZW6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 18:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbhGZW6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 18:58:13 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C3EC061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 16:38:40 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so2323609pjh.3
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 16:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=UznCEhRz1sKBvX5U3kkm1ME29tbbCltwUHbLW9Ny4XE=;
        b=WCZIh10J8tyc3MJESAQxCuOWBjpFt5oMaTexgw2SVv3lawGtWg47EjqNZjSOzu6BLf
         fZu4XI3GkfvlWIUBwE9CJuRi4m6Vzr9zkNO2m9P7wetA+Uz7ZB2Al5eyAWihTtRAKvSE
         H1FNWqTD1/QoYtrJZWA9hQxywNxmAU4E6gKfCez9AxM5eYp4d/E7zQKgyGarV+ec/jlP
         pIu8CiDN6Uw6aM7ZpFXHkBF49yDayK3hvzxC4KwxORbmNX+4HpgJjakSOqCbOOodJdC1
         rt1GyoiY9l026MGi5DKreJMYy8TU9eZqK/LcCFGgg5VdgE8/1y0Y0OoBMOZwKc+HE4iU
         L4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=UznCEhRz1sKBvX5U3kkm1ME29tbbCltwUHbLW9Ny4XE=;
        b=ZD5pSslbXtpXQ6fSep3XSqljYra2q/xr7wp3Zo+vwzQMio+HmqKo7tkdwGni4GS/M6
         makIWW/rQU4dMnJEAb56pqEVECs637f/gzdA8hIQEy+aOpfVBJTgcTIvZSqQR6mWXTuf
         Uj3DIYydm66oruzGyWClW1ooMHasS8GqNKGyPadFfMiHnt9NhQm6Fr22bYWaqnj5qSAy
         AId+xXZkQRCWgWGwSz3VnUvo6YmD2t2c7TjAAiqF1z2K+kcv8XSnD4EEfJW/Pa3vTDiA
         xcGF9ImNXcMwYgyC6FlT8RHB/a7IbzBh9E8RYmtwuSRlHWEFxJPu+kQgULcJm5EY8R+r
         lfYg==
X-Gm-Message-State: AOAM533rXDZepm+CsMcdDdUqxVsvTGjxA+ZdFbpal7iJ2UGS+8G0QZkL
        dmcbdPnFKnaiIO6VXqQ7K8nhlg==
X-Google-Smtp-Source: ABdhPJzAKAw3A7CyOUHmjyvERqxZHkGLVTW1jK3XeP4h2JHReBbMpH2jGTjr3LpL7Sm1cqQZBHrFyg==
X-Received: by 2002:a62:78cd:0:b029:327:de34:ad60 with SMTP id t196-20020a6278cd0000b0290327de34ad60mr20407648pfc.18.1627342719749;
        Mon, 26 Jul 2021 16:38:39 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id on9sm577210pjb.47.2021.07.26.16.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 16:38:39 -0700 (PDT)
Subject: Re: [PATCH net-next] ethtool: Fix rxnfc copy to user buffer overflow
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>
References: <20210726221539.492937-1-saeed@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <f2c412b0-57a8-defa-eff7-48483a469055@pensando.io>
Date:   Mon, 26 Jul 2021 16:38:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210726221539.492937-1-saeed@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/26/21 3:15 PM, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
>
> In the cited commit, copy_to_user() got called with the wrong pointer,
> instead of passing the actual buffer ptr to copy from, a pointer to
> the pointer got passed, which causes a buffer overflow calltrace to pop
> up when executing "ethtool -x ethX".
>
> Fix ethtool_rxnfc_copy_to_user() to use the rxnfc pointer as passed
> to the function, instead of a pointer to it.
>
> This fixes below call trace:
> [   15.533533] ------------[ cut here ]------------
> [   15.539007] Buffer overflow detected (8 < 192)!
> [   15.544110] WARNING: CPU: 3 PID: 1801 at include/linux/thread_info.h:200 copy_overflow+0x15/0x20
> [   15.549308] Modules linked in:
> [   15.551449] CPU: 3 PID: 1801 Comm: ethtool Not tainted 5.14.0-rc2+ #1058
> [   15.553919] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
> [   15.558378] RIP: 0010:copy_overflow+0x15/0x20
> [   15.560648] Code: e9 7c ff ff ff b8 a1 ff ff ff eb c4 66 0f 1f 84 00 00 00 00 00 55 48 89 f2 89 fe 48 c7 c7 88 55 78 8a 48 89 e5 e8 06 5c 1e 00 <0f> 0b 5d c3 0f 1f 80 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 55
> [   15.565114] RSP: 0018:ffffad49c0523bd0 EFLAGS: 00010286
> [   15.566231] RAX: 0000000000000000 RBX: 00000000000000c0 RCX: 0000000000000000
> [   15.567616] RDX: 0000000000000001 RSI: ffffffff8a7912e7 RDI: 00000000ffffffff
> [   15.569050] RBP: ffffad49c0523bd0 R08: ffffffff8ab2ae28 R09: 00000000ffffdfff
> [   15.570534] R10: ffffffff8aa4ae40 R11: ffffffff8aa4ae40 R12: 0000000000000000
> [   15.571899] R13: 00007ffd4cc2a230 R14: ffffad49c0523c00 R15: 0000000000000000
> [   15.573584] FS:  00007f538112f740(0000) GS:ffff96d5bdd80000(0000) knlGS:0000000000000000
> [   15.575639] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   15.577092] CR2: 00007f5381226d40 CR3: 0000000013542000 CR4: 00000000001506e0
> [   15.578929] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   15.580695] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   15.582441] Call Trace:
> [   15.582970]  ethtool_rxnfc_copy_to_user+0x30/0x46
> [   15.583815]  ethtool_get_rxnfc.cold+0x23/0x2b
> [   15.584584]  dev_ethtool+0x29c/0x25f0
> [   15.585286]  ? security_netlbl_sid_to_secattr+0x77/0xd0
> [   15.586728]  ? do_set_pte+0xc4/0x110
> [   15.587349]  ? _raw_spin_unlock+0x18/0x30
> [   15.588118]  ? __might_sleep+0x49/0x80
> [   15.588956]  dev_ioctl+0x2c1/0x490
> [   15.589616]  sock_ioctl+0x18e/0x330
> [   15.591143]  __x64_sys_ioctl+0x41c/0x990
> [   15.591823]  ? irqentry_exit_to_user_mode+0x9/0x20
> [   15.592657]  ? irqentry_exit+0x33/0x40
> [   15.593308]  ? exc_page_fault+0x32f/0x770
> [   15.593877]  ? exit_to_user_mode_prepare+0x3c/0x130
> [   15.594775]  do_syscall_64+0x35/0x80
> [   15.595397]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   15.596037] RIP: 0033:0x7f5381226d4b
> [   15.596492] Code: 0f 1e fa 48 8b 05 3d b1 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d b1 0c 00 f7 d8 64 89 01 48
> [   15.598743] RSP: 002b:00007ffd4cc2a1f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [   15.599804] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f5381226d4b
> [   15.600795] RDX: 00007ffd4cc2a350 RSI: 0000000000008946 RDI: 0000000000000003
> [   15.601712] RBP: 00007ffd4cc2a340 R08: 00007ffd4cc2a350 R09: 0000000000000001
> [   15.602751] R10: 00007f538128a990 R11: 0000000000000246 R12: 0000000000000000
> [   15.603882] R13: 00007ffd4cc2a350 R14: 00007ffd4cc2a4b0 R15: 0000000000000000
> [   15.605042] ---[ end trace 325cf185e2795048 ]---
>
> Fixes: dd98d2895de6 ("ethtool: improve compat ioctl handling")
> Reported-by: Shannon Nelson <snelson@pensando.io>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Thanks!

Tested-by: Shannon Nelson <snelson@pensando.io>

> ---
>   net/ethtool/ioctl.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 6134b180f59f..af011534bcb2 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -906,7 +906,7 @@ static int ethtool_rxnfc_copy_to_user(void __user *useraddr,
>   						   rule_buf);
>   		useraddr += offsetof(struct compat_ethtool_rxnfc, rule_locs);
>   	} else {
> -		ret = copy_to_user(useraddr, &rxnfc, size);
> +		ret = copy_to_user(useraddr, rxnfc, size);
>   		useraddr += offsetof(struct ethtool_rxnfc, rule_locs);
>   	}
>   

