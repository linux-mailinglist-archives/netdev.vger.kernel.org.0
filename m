Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F5F127D2
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 08:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfECGjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 02:39:03 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42125 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfECGjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 02:39:03 -0400
Received: by mail-qt1-f193.google.com with SMTP id p20so5522492qtc.9
        for <netdev@vger.kernel.org>; Thu, 02 May 2019 23:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=DZ2IHyxIY3tc20Fav7PGg8oi4DI7SoA47YJWJXbH2tE=;
        b=IgC/WSM6QdvA97J9Eradk1OkSe2topjqiObiWYIbZdyx/kL61mmr2oXQehbtGj/T+1
         IZIXz2OMO5RgtUp2K9jrVtD6UPycSwS5ujp38wnBHdq4aoLNN9gqWzPm11o1FMYq28qF
         r7WOPZ3u6QEA8zGkp9qgzNwDICHurIJ/ik3OnJOFyIB8t2vXHUr9ylAxEEmjxoa1/EYM
         r6a0I0aeeI36BxPDFIp1RUwLhjzkxaAjeo2n2JY8Tmq1xSKALC3eZIsSnqIp7pJY79Dz
         keoJra/8M3YhAoPs6SG4NtVkCAtFVj2riHFbKnf3LDSYk5JoZQtcIEgc3dplfqUwsIC1
         lTRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=DZ2IHyxIY3tc20Fav7PGg8oi4DI7SoA47YJWJXbH2tE=;
        b=d5+Ez1TuPDdMoKs79hKgffpWjXGhQV1570L/MFdi89UQHWmgjlVgLdUjTTsKFSCp8Q
         fq9QgjTFTuZ00YsiSP863cTj4V3o+gQO0MAPD63fxUD42yoL0VVhuAqYdTx0W0ESUj/e
         Eoxml862xb0Ew9DHSiLbbsEfNQqKV9Jvxi5R24CRQt2r2GKkrcv2qVubieGOSay34NlF
         O+zoCQZXJpDwdr2Q1JWduOijMckPi9fYpP9t1dZShmY/MxR0QrxaiHYU26nd0Cd6mJhS
         j/K86FD9FudM2shQaebKAyX4P2/hNbM2H7N9cjNH/8gHmOOwNbqVraYIn4WVd0lXKibZ
         eUtw==
X-Gm-Message-State: APjAAAVrmw/a9ykB693z6TmB97zzVCxI5Zr1B6IIrcdnwovWSsUMC8+R
        KwBztF8/96b0/+0/yVHD2tT/PB5bNDNoIRT3FO8m1Q==
X-Google-Smtp-Source: APXvYqyZbCWh74vb5VdL2cKae7QJoxTTDldS1TH5WTdKneC0Qmwikj8WKkbQ5N8esX/KXeusHW2I5RkliSFeEJQOg8g=
X-Received: by 2002:ac8:182e:: with SMTP id q43mr3816249qtj.128.1556865541833;
 Thu, 02 May 2019 23:39:01 -0700 (PDT)
MIME-Version: 1.0
From:   Chris Chiu <chiu@endlessm.com>
Date:   Fri, 3 May 2019 14:38:50 +0800
Message-ID: <CAB4CAwdHPfi3rhQofxbH+yWJZnLJCFK+r901HZ6HLxmHPjkU4w@mail.gmail.com>
Subject: Improve TX performance of RTL8723BU on rtl8xxxu driver
To:     Jes Sorensen <jes.sorensen@gmail.com>, kvalo@codeaurora.org,
        davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have 3 laptops which connect the wifi by the same RTL8723BU.
The PCI VID/PID of the wifi chip is 10EC:B720 which is supported.
They have the same problem with the in-kernel rtl8xxxu driver, the
iperf (as a client to an ethernet-connected server) gets ~1Mbps.
Nevertheless, the signal strength is reported as around -40dBm,
which is quite good. From the wireshark capture, the tx rate for each
data and qos data packet is only 1Mbps. Compare to the driver from
https://github.com/lwfinger/rtl8723bu, the same iperf test gets ~12
Mbps or more. The signal strength is reported similarly around
-40dBm. That's why we want to find out the cause and improve.

After reading the source code of the rtl8xxxu driver and Larry's, the
major difference is that Larry's driver has a watchdog which will keep
monitoring the signal quality and updating the rate mask just like the
rtl8xxxu_gen2_update_rate_mask() does if signal quality changes.
And this kind of watchdog also exists in rtlwifi driver of some specific
chips, ex rtl8192ee, rtl8188ee, rtl8723ae, rtl8821ae...etc. They have
the same member function named dm_watchdog and will invoke the
corresponding dm_refresh_rate_adaptive_mask to adjust the tx rate
mask.

Thus I created 2 commits and try to do the same thing on rtl8xxxu.
https://github.com/endlessm/linux/commit/503d0b6eb61f25984042b1f00e6293776ae722c7
https://github.com/endlessm/linux/commit/5b06665766d6c3e25cbf649022989a8f3abc83d6
The 1st commit brings a data structure for rate adaptive which will be
useful for determining higher or lower the tx rate. The second commit
adds a watchdog to monitor and update the tx rate mask and tell the
firmware. After applying these commits, the tx rate of each data and
qos data packet will be 39Mbps (MCS4) with the 0xf00000 as its tx
rate mask. The 20th bit ~ 23th bit means MCS4 to MCS7. It means
that the firmware still picks the lowest rate from the rate mask and
explains why the tx rate of data and qos data is always lowest 1Mbps
because the default rate mask passed is almost 0xFFFFFFF ranges
from the basic CCK rate, OFDM rate, and MCS rate. However, with
Larry's driver, the tx rate observed from wireshark under the same
condition is almost 65Mbps or 72Mbps.

I believe the firmware of RTL8723BU may need fix. And I think we
can still bring in the dm_watchdog as rtlwifi to improve from the
driver side. Please leave precious comments for my commits and
suggest what I can do better to get them upstream. Or suggest if
there's any better idea to fix this. Thanks.

Chris
