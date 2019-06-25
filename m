Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52B2854F69
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 14:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbfFYM4K convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Jun 2019 08:56:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44036 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfFYM4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 08:56:09 -0400
Received: from mail-wr1-f71.google.com ([209.85.221.71])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1hfkzX-0006SU-4y
        for netdev@vger.kernel.org; Tue, 25 Jun 2019 12:56:07 +0000
Received: by mail-wr1-f71.google.com with SMTP id r4so7940863wrt.13
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 05:56:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VJ8VdYo0DnObA64K1FvYQSMew8tJyJOTy4Xp3oei9UY=;
        b=DX8rAoWNG/e6RezUIqaLbnbHNYRlE0AY0CZIeVJGih4SSW0WAEkmmxkXEOoIU7a7C3
         QW+jsKIv6YOIas98ZVBYOgqTU7wZZuzCXg8ysXScX2gkNj2Y1+3PL3jD8au60nqmHG9m
         gTcB5x2Y6nlrsLGxBh7xpMzkhEdbRau2+UyUyktVgecTsoAy4OjR82FLe3hAtJoVYT47
         mI957PRAtrHLSUSC7NG8ZEAMbnOf2bbSwfKvOWghUaVRWhYYwWAXzS5s8wKAttBYz7T7
         iapepYvf0PoIWbxeqrn5c6pJQHLmKTnveLTW5il0xKiTNMfPsF5yEwyXxhz2dPmZbRib
         06Ng==
X-Gm-Message-State: APjAAAXZnA+zCMvxzDorGO0bacVnnSAEP4WrZhhPySmRn5YvsbpxPndK
        yRzSy9GWgbDx0HSRu7JBbhQR/CYvDzJKgTYS0aSKH9wBgiuTqqBHReHluPgZCtJpMg2ZS9YCTS1
        Fsw/tV6KHNQRxOFZRTDTworIgauOm2jYo4Rybar+xORkAVl7jvw==
X-Received: by 2002:a5d:61cd:: with SMTP id q13mr42183586wrv.114.1561467366947;
        Tue, 25 Jun 2019 05:56:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxyjHvrr3PM8rAn+CmesEnH4DjuM76PrrYfAJcE3RrDcoOf1ry44A1sxMnQftTGE7gshglpBIt0MUzNkOdJPRk=
X-Received: by 2002:a5d:61cd:: with SMTP id q13mr42183574wrv.114.1561467366795;
 Tue, 25 Jun 2019 05:56:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190624222356.17037-1-gpiccoli@canonical.com> <MN2PR18MB2528BCB89AC93EB791446BABD3E30@MN2PR18MB2528.namprd18.prod.outlook.com>
In-Reply-To: <MN2PR18MB2528BCB89AC93EB791446BABD3E30@MN2PR18MB2528.namprd18.prod.outlook.com>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Tue, 25 Jun 2019 09:55:30 -0300
Message-ID: <CAHD1Q_y7v5fVeDRT+KDimQ-RBJMujMCL2DPvdBh==YEJ3+2ZaQ@mail.gmail.com>
Subject: Re: [EXT] [PATCH V2] bnx2x: Prevent ptp_task to be rescheduled indefinitely
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 1:02 AM Sudarsana Reddy Kalluru
<skalluru@marvell.com> wrote:
>
> Thanks for your changes and time on this. In general time-latching happens in couple or more milliseconds (even in some 100s of usec) under the normal traffic conditions. With this approach, there's a possibility that every packet has to wait for atleast 50ms for the timestamping. This in turn affects the wait-queue (of packets to be timestamped) at hardware as next TS recording happens only after the register is freed/read. And also, it incurs some latency for the ptp applications.
>
> PTP thread is consuming time may be due to the debug messages in this error path, which you are planning address already (thanks!!).
>    "Also, I've dropped the PTP "outstanding, etc" messages to debug-level, they're quite flooding my log.
> Do you see cpu hog even after removing this message? In such case we may need to think of other alternatives such as sleep for 1 ms.
> Just for the info, the approach continuous-poll-for-timestamp() is used ixgbe driver (ixgbe_ptp_tx_hwtstamp_work()) as well.
>

Thanks again for the good insights Sudarsana! I'll do some experiments
dropping all messages and checking
if the ptp thread is still consuming a lot of CPU (I believe so). In
this case, I'll rework the approach by starting
the delays in 1ms to avoid impacting the HW wait-queue and causing
delays in ptp applications.

Cheers,


Guilherme
