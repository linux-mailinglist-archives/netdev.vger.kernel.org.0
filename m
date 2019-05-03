Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86BED128AA
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 09:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfECHV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 03:21:58 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33515 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfECHV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 03:21:58 -0400
Received: by mail-pg1-f194.google.com with SMTP id k19so2315708pgh.0
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 00:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=LKhhq2nOhMH84Ql7gevkkqRsBvxQcsPWG4tyymGIQ0k=;
        b=EAFnyRRD0rxsPGwUF9O54bV46cgf1VVPj9l/3tdh87yRsJJyQAMqqe6SHe3O9MmNqX
         baP5r6PAHKZVOFP1ak9t1bzK2kZzOb+zluczE7rHn+zH90peyYBYMDklVnFV8VrZ1riV
         RhNXR0LGBxYaI+yy75uQOXvsEqRXx3uKr9YhvrZ2R85fnQGLk6si0PVD5GoGT1Iklv/u
         wC3z3yjEL4zaOT5Qmr65zSWJkBjl+ztDOybYlm8oY1t4/+J5mUrdvAF/1tHeXFUL/kKM
         v1tzpHkQWdhmjczUTa+28IS/RLNOMkw7YCQCHKiQW517ouewzoVB8U3S3ds9iSfywFLK
         L2uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LKhhq2nOhMH84Ql7gevkkqRsBvxQcsPWG4tyymGIQ0k=;
        b=C6Z52XsfZdWz4m2T8ReOFsf5e1X0EENuDXt3hMdsQJl05NdUyF53sSUaNuhRi/XyRS
         VY4KHRcepgEUXki0ymEDIzRHxXmNmYjJVW/CxrxKWBRYPH6Gw8zrrInNFiAr5Uw2b0w3
         4O8Eko8JbrkrzVujBgluLsAIsiyTZtvBO/GEf81H/wUL/jUQyzwgx/kdcFssVWEIXgRu
         ffZkudyOxY39h11Vuz5aYNdNc4KFYRqsmR0wlbx9vVGTjBJ85zrWtRBk+cCBxTDiyfLg
         5/rvGgPjdOg0tgbJMPH00gfWU94JtaZMyIP+cTTUpHvz8tOf5HXw/rcEgId1pTiw6La2
         Gpag==
X-Gm-Message-State: APjAAAV2WgsRZz1T7qTrvNSauPCMKJDT+Bk3OFmgry64lCkpHASZjKGI
        KBb2YcbkTtq1umfRgLH5e6jC6A==
X-Google-Smtp-Source: APXvYqxxQFy1IxwyfE0rdql14cVIMZle7uUOvGFWmgZo4wfWM1FlEQ3ethiJQAG6fc1SrDxJpFinIg==
X-Received: by 2002:a63:6804:: with SMTP id d4mr8500069pgc.240.1556868117801;
        Fri, 03 May 2019 00:21:57 -0700 (PDT)
Received: from localhost.localdomain (220-133-8-232.HINET-IP.hinet.net. [220.133.8.232])
        by smtp.gmail.com with ESMTPSA id u5sm2671465pfb.60.2019.05.03.00.21.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 May 2019 00:21:57 -0700 (PDT)
From:   Chris Chiu <chiu@endlessm.com>
To:     jes.sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Chris Chiu <chiu@endlessm.com>
Subject: [RFC PATCH 0/2] Improve TX performance of RTL8723BU on rtl8xxxu driver
Date:   Fri,  3 May 2019 15:21:44 +0800
Message-Id: <20190503072146.49999-1-chiu@endlessm.com>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
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
After applying these commits, the tx rate of each data and qos data
packet will be 39Mbps (MCS4) with the 0xf00000 as its tx rate mask.
The 20th bit ~ 23th bit means MCS4 to MCS7. It means that the firmware
still picks the lowest rate from the rate mask and explains why the
tx rate of data and qos data is always lowest 1Mbps because the default
rate mask passed is almost 0xFFFFFFF ranges from the basic CCK rate, 
OFDM rate, and MCS rate. However, with Larry's driver, the tx rate 
observed from wireshark under the same condition is almost 65Mbps or
72Mbps.

I believe the firmware of RTL8723BU may need fix. And I think we
can still bring in the dm_watchdog as rtlwifi to improve from the
driver side. Please leave precious comments for my commits and
suggest what I can do better. Or suggest if there's any better idea
to fix this. Thanks.

Chris Chiu (2):
  rtl8xxxu: Add rate adaptive related data
  rtl8xxxu: Add watchdog to update rate mask by signal strength

 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |  53 ++++++
 .../realtek/rtl8xxxu/rtl8xxxu_8723b.c         | 151 ++++++++++++++++++
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c |  83 +++++++++-
 3 files changed, 286 insertions(+), 1 deletion(-)

-- 
2.21.0

