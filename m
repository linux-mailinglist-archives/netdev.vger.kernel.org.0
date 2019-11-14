Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 829E4FC1E1
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 09:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKNIvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 03:51:22 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35159 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfKNIvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 03:51:21 -0500
Received: by mail-lf1-f65.google.com with SMTP id i26so4391659lfl.2
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 00:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=v1sBGYGWupHZXHTRz2oItmsgw4egV4vDdKvUn2PB7eg=;
        b=EM3Is2pN+ydzDoSwIrueo89AH1XY1Y2R+UL06ji0y3O2UchnHwn2Xv4ksLwxNWwGZh
         Cw9SvrjCb2QaVibMh5BbAlf3jckxJwc/YYCDUQimpS7EqcaWrNVqPyyG+roSNtHCNZKS
         Y/V5w1+56YHDIxpAV1xenb7lHK8mMbwN07r1wiMiVZ7/CSm2aQ7F24gjmbTZqQG91qVL
         EECgkmVum1ni6tLkAJE92GECP5sR/wvUHH8bEK0U3LJt5l+ryiKq1gInA2BftSRm2g7p
         4W2lIKZC8fJHzYAL1LqnD0nblfd4eD+TxsYOTKSltY5YPWjHxOpVmphhCjMlCSVQZ/Wf
         TuLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-transfer-encoding;
        bh=v1sBGYGWupHZXHTRz2oItmsgw4egV4vDdKvUn2PB7eg=;
        b=KzJLGuCcf1i7yxRRX1OY6NHKbnvNLiiy2vv5qzpfx7nOVqSys7bMGNrEKRtgdbaUF7
         L1xuTrYw1RaNYk6OCvrLxS2QTxmJ0TXYLMvhqi2hw6ahXkVgofKoHrUMOKffIjZujLcq
         LF8um4YyocCmNuKe2PDLllP8qqPZPk01iUVqYLNGvYVzmh1ZXFxKjOtUvnmEhsJbXD/e
         iskX2ZwmBtqydX1ro42F0d7hPHUfZO6JxVKay1fSjxzKl6XqXiGz9IAAysrky1vHntrU
         QdDsbEuRGhyIz261qpz9wHjEhT+Am8iakvdpbi2iFuVSYcbUxO2OIXdif0Iv3G3O3/Zt
         DVwg==
X-Gm-Message-State: APjAAAX7Op+V+VMuE1DNqJZaYDoB8iaGPm/OFU+a8uVRKmcMThfb838y
        NYRsT0IOb8HkFHEsMor/RrgQAggp/4hSXw==
X-Google-Smtp-Source: APXvYqwK+ZMDuiYXuZOv60H238tUxluC76DUq9k0c8Klt5j3YYgpvleOtPfomWD2kCd1VXMw/1PrPg==
X-Received: by 2002:a19:f811:: with SMTP id a17mr5862712lff.132.1573721479976;
        Thu, 14 Nov 2019 00:51:19 -0800 (PST)
Received: from GL-434 ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id y7sm1574006lfb.75.2019.11.14.00.51.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Nov 2019 00:51:19 -0800 (PST)
From:   jouni.hogander@unikie.com (Jouni =?utf-8?Q?H=C3=B6gander?=)
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Re: [PATCH] slip: Fix memory leak in slip_open error path
References: <20191113114502.22462-1-jouni.hogander@unikie.com>
        <87sgmqapi4.fsf@unikie.com>
Date:   Thu, 14 Nov 2019 10:51:18 +0200
In-Reply-To: <87sgmqapi4.fsf@unikie.com> ("Jouni \=\?utf-8\?Q\?H\=C3\=B6gander\?\=
 \=\?utf-8\?Q\?\=22's\?\= message of "Thu,
        14 Nov 2019 09:25:23 +0200")
Message-ID: <87k182alix.fsf@unikie.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

jouni.hogander@unikie.com (Jouni H=C3=B6gander) writes:

> jouni.hogander@unikie.com writes:
>
>> From: Jouni Hogander <jouni.hogander@unikie.com>
>>
>> Driver/net/can/slcan.c is derived from slip.c. Memory leak was detected
>> by Syzkaller in slcan. Same issue exists in slip.c and this patch is
>> addressing the leak in slip.c.
>>
>> Here is the slcan memory leak trace reported by Syzkaller:
>>
>> BUG: memory leak unreferenced object 0xffff888067f65500 (size 4096):
>>   comm "syz-executor043", pid 454, jiffies 4294759719 (age 11.930s)
>>   hex dump (first 32 bytes):
>>     73 6c 63 61 6e 30 00 00 00 00 00 00 00 00 00 00 slcan0..........
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
>>   backtrace:
>>     [<00000000a06eec0d>] __kmalloc+0x18b/0x2c0
>>     [<0000000083306e66>] kvmalloc_node+0x3a/0xc0
>>     [<000000006ac27f87>] alloc_netdev_mqs+0x17a/0x1080
>>     [<0000000061a996c9>] slcan_open+0x3ae/0x9a0
>>     [<000000001226f0f9>] tty_ldisc_open.isra.1+0x76/0xc0
>>     [<0000000019289631>] tty_set_ldisc+0x28c/0x5f0
>>     [<000000004de5a617>] tty_ioctl+0x48d/0x1590
>>     [<00000000daef496f>] do_vfs_ioctl+0x1c7/0x1510
>>     [<0000000059068dbc>] ksys_ioctl+0x99/0xb0
>>     [<000000009a6eb334>] __x64_sys_ioctl+0x78/0xb0
>>     [<0000000053d0332e>] do_syscall_64+0x16f/0x580
>>     [<0000000021b83b99>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>     [<000000008ea75434>] 0xfffffffffffffff
>>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
>> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
>> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
>> ---
>>  drivers/net/slip/slip.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
>> index cac64b96d545..4d479e3c817d 100644
>> --- a/drivers/net/slip/slip.c
>> +++ b/drivers/net/slip/slip.c
>> @@ -855,6 +855,7 @@ static int slip_open(struct tty_struct *tty)
>>  	sl->tty =3D NULL;
>>  	tty->disc_data =3D NULL;
>>  	clear_bit(SLF_INUSE, &sl->flags);
>> +	free_netdev(sl->dev);
>>=20=20
>>  err_exit:
>>  	rtnl_unlock();
>
> Observed panic in another error path in my overnight Syzkaller run with
> this patch. Better not to apply it. Sorry for inconvenience.

The panic was caused by another error path fix I had in my Syzkaller
setup. I.e. this patch is ok.

BR,

Jouni H=C3=B6gander
