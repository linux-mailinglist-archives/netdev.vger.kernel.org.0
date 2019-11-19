Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B64101A78
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 08:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfKSHpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 02:45:09 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36482 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfKSHpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 02:45:09 -0500
Received: by mail-lj1-f194.google.com with SMTP id k15so22141054lja.3
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 23:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=R4HtGm2QOg9Ec33jL2DRnBsQl/WknHSlLXUUXlcs6dM=;
        b=sMvozZnIqw9W8WEN+bjnvmE1AxKWEa5EJKkTfMJyqRk2su2NpLVo2mz2cH5EOHhuPw
         dUOHoSoQZDylMwin0FmkHq157oOrWdxDeNWcTGcuAZF9L0yUs3DWpVfR0bz3zZmnCKgx
         +OorbWr6OdYBmz20UvaafE0YDcip1+ZfBgd56IyAVmOB8YHoIqSaRTvMcddhO12RiOov
         cam2DvsmOrFUJ3yDJJXYroXTnxPJmZULkaaeMr0Hlrzx+RO6ROyVkge5sOYhh9LJA1AO
         hSjDo23D+8m9Rie1JWBgLRjNV73GG9jrb9z5oCNPhzw1CuBmB2tqH9F+d2U5AXtS/8FJ
         TryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-transfer-encoding;
        bh=R4HtGm2QOg9Ec33jL2DRnBsQl/WknHSlLXUUXlcs6dM=;
        b=P9TkLnEJIQYHZRh4DQNMJURM51lLEwPYgS+kbfG3WRFwV858kmv0+TPecn5IYmsKQ1
         1nLvX/UnfWq8w/mNLOMv9xiiUDUm5U59Ne9S30fDBFn8GworPY4j7xIZnVHV7hbRVEKT
         rfzGPqCNtqqfoHSxqk5j8+hrfzZ+HmyZ0CnXZBLWyRw1dTAJVRdfB9BD0079N2NRE8G3
         b0XHMf2ydj6O4Oe17/tfZrzsI5KxAZ2E0ObpTbFemhS2KDJkK9ErOCh3+ukc/w8Hm19p
         PmHgSHjpqKS1KTgIQCPH/Q7+i5YLWTZv13m7r5E9OUlS0ftZobHXFjsuTfX56pk2d2Ew
         pY2A==
X-Gm-Message-State: APjAAAXTtlNxfSqbAsKCBnrJl3/8rVb1iRdzF/QcbDepcFdasXluwWwZ
        XQWSqKmUfeW89l0CY/LISeR8pJ90hD0=
X-Google-Smtp-Source: APXvYqwSODMpqWr7m5KAOyCIRzOCk28jkywP4eT6dEJf6a99+YtU81PMT0Gdmz4JouJSHylxmbgCow==
X-Received: by 2002:a2e:8088:: with SMTP id i8mr2551646ljg.205.1574149504653;
        Mon, 18 Nov 2019 23:45:04 -0800 (PST)
Received: from GL-434 ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id g26sm9838884lfh.1.2019.11.18.23.45.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 18 Nov 2019 23:45:04 -0800 (PST)
From:   jouni.hogander@unikie.com (Jouni =?utf-8?Q?H=C3=B6gander?=)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Re: [PATCH v3] net-sysfs: Fix reference count leak
References: <20191118123246.27618-1-jouni.hogander@unikie.com>
        <20191118132705.GB261521@kroah.com>
Date:   Tue, 19 Nov 2019 09:45:02 +0200
In-Reply-To: <20191118132705.GB261521@kroah.com> (Greg Kroah-Hartman's message
        of "Mon, 18 Nov 2019 14:27:05 +0100")
Message-ID: <87eey4s41t.fsf@unikie.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Mon, Nov 18, 2019 at 02:32:46PM +0200, jouni.hogander@unikie.com wrote:
>> From: Jouni Hogander <jouni.hogander@unikie.com>
>>=20
>> Netdev_register_kobject is calling device_initialize. In case of error
>> reference taken by device_initialize is not given up.
>>=20
>> Drivers are supposed to call free_netdev in case of error. In non-error
>> case the last reference is given up there and device release sequence
>> is triggered. In error case this reference is kept and the release
>> sequence is never started.
>>=20
>> Fix this reference count leak by allowing giving up the reference also
>> in error case in free_netdev.
>>=20
>> Also replace BUG_ON with WARN_ON in free_netdev and in netdev_release.
>>=20
>> This is the rootcause for couple of memory leaks reported by Syzkaller:
>>=20
>> BUG: memory leak unreferenced object 0xffff8880675ca008 (size 256):
>>   comm "netdev_register", pid 281, jiffies 4294696663 (age 6.808s)
>>   hex dump (first 32 bytes):
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
>>   backtrace:
>>     [<0000000058ca4711>] kmem_cache_alloc_trace+0x167/0x280
>>     [<000000002340019b>] device_add+0x882/0x1750
>>     [<000000001d588c3a>] netdev_register_kobject+0x128/0x380
>>     [<0000000011ef5535>] register_netdevice+0xa1b/0xf00
>>     [<000000007fcf1c99>] __tun_chr_ioctl+0x20d5/0x3dd0
>>     [<000000006a5b7b2b>] tun_chr_ioctl+0x2f/0x40
>>     [<00000000f30f834a>] do_vfs_ioctl+0x1c7/0x1510
>>     [<00000000fba062ea>] ksys_ioctl+0x99/0xb0
>>     [<00000000b1c1b8d2>] __x64_sys_ioctl+0x78/0xb0
>>     [<00000000984cabb9>] do_syscall_64+0x16f/0x580
>>     [<000000000bde033d>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>     [<00000000e6ca2d9f>] 0xffffffffffffffff
>>=20
>> BUG: memory leak
>> unreferenced object 0xffff8880668ba588 (size 8):
>>   comm "kobject_set_nam", pid 286, jiffies 4294725297 (age 9.871s)
>>   hex dump (first 8 bytes):
>>     6e 72 30 00 cc be df 2b                          nr0....+
>>   backtrace:
>>     [<00000000a322332a>] __kmalloc_track_caller+0x16e/0x290
>>     [<00000000236fd26b>] kstrdup+0x3e/0x70
>>     [<00000000dd4a2815>] kstrdup_const+0x3e/0x50
>>     [<0000000049a377fc>] kvasprintf_const+0x10e/0x160
>>     [<00000000627fc711>] kobject_set_name_vargs+0x5b/0x140
>>     [<0000000019eeab06>] dev_set_name+0xc0/0xf0
>>     [<0000000069cb12bc>] netdev_register_kobject+0xc8/0x320
>>     [<00000000f2e83732>] register_netdevice+0xa1b/0xf00
>>     [<000000009e1f57cc>] __tun_chr_ioctl+0x20d5/0x3dd0
>>     [<000000009c560784>] tun_chr_ioctl+0x2f/0x40
>>     [<000000000d759e02>] do_vfs_ioctl+0x1c7/0x1510
>>     [<00000000351d7c31>] ksys_ioctl+0x99/0xb0
>>     [<000000008390040a>] __x64_sys_ioctl+0x78/0xb0
>>     [<0000000052d196b7>] do_syscall_64+0x16f/0x580
>>     [<0000000019af9236>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>     [<00000000bc384531>] 0xffffffffffffffff
>>=20
>> Reported-by: syzbot+ad8ca40ecd77896d51e2@syzkaller.appspotmail.com
>> Cc: David Miller <davem@davemloft.net>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
>> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
>> ---
>> v2 -> v3:
>> * Replaced BUG_ON with WARN_ON in free_netdev and netdev_release
>> v1 -> v2:
>> * Relying on driver calling free_netdev rather than calling
>>   put_device directly in error path
>> ---
>>  net/core/dev.c       | 14 +++++++-------
>>  net/core/net-sysfs.c |  6 +++++-
>>  2 files changed, 12 insertions(+), 8 deletions(-)
>>=20
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 99ac84ff398f..1d6c0bfb5ec5 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -9603,14 +9603,14 @@ void free_netdev(struct net_device *dev)
>>=20=20
>>  	netdev_unregister_lockdep_key(dev);
>>=20=20
>> -	/*  Compatibility with error handling in drivers */
>> -	if (dev->reg_state =3D=3D NETREG_UNINITIALIZED) {
>> -		netdev_freemem(dev);
>> -		return;
>> -	}
>> +	/* reg_state is NETREG_UNINITIALIZED if there is an error in
>> +	 * registration.
>> +	 */
>> +	WARN_ON(dev->reg_state !=3D NETREG_UNREGISTERED &&
>> +		dev->reg_state !=3D NETREG_UNINITIALIZED);
>
> You "warn" about this, but do not actually handle the problem.  So what
> is this helping with?
>

Now as I have replaced BUG_ON with WARN_ON different reg_states are
actually handled. In free_netdev reference is given up and release
sequence is expected to start no matter what is the dev->reg_state. In
netdev_release memories are freed. There are just extra warnings in the
log from the functions.

> Systems with panic-on-warn just rebooted, and a "normal" system saw a
> traceback yet no error handling happened so why would the code even test
> this?

One use for panic-on-warn is the stabilation phase before "product"
quality. In this case you are interested in everything that is
unexpected. Having panic-on-warn set is easy way to make each warning in
the system visible to user and force to react on it.

Another example is my Syzkaller excercise. I gathered all the crashes
from the system and these include warnings as well. I will probably next
look at these warnings Syzkaller found and try to understand why they
are and do they need fixes.

>
> I'm not trying to be picky here, just to think about what you are doing
> with these checks please.

This state was not expected being anything else than
NETREG_UNREGISTERED. Probably error cases were not taken into account or
maybe error cases were not expected to end up to device release
sequence. Especially as cleaning up relies on normal device release
sequence on error cases this assumption is wrong.

Do you think better choise would be to remove BUG_ON completely rather
than replacing it with WARN_ON?

BR,

Jouni H=C3=B6gander

