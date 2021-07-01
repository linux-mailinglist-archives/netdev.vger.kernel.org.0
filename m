Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4FA3B90F5
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 13:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbhGALIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 07:08:54 -0400
Received: from www259.your-server.de ([188.40.28.39]:57030 "EHLO
        www259.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236015AbhGALIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 07:08:53 -0400
X-Greylist: delayed 1100 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jul 2021 07:08:53 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=waldheinz.de; s=default1911; h=MIME-Version:Content-Type:Subject:Cc:To:From
        :Message-ID:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References;
        bh=olo+q1cjkFiUEc1+lqyaJ97zQc/9rXBpSSCctXlU9IU=; b=NUSaLnZ+eNDbFL+yVpNkDfMybV
        44R+wChzeFxFmRp15INUM4066E+99FuF8O7fJ4a/gpqBWbL2sPvORD7D+fJuKszpoBcYky8Ls9wXj
        0w5AvLqaFyoS2BT+HF2yTRsWTxHvykS+KdjOMWf+hEyoTh+AGBQmnYtT79TkeyABrN4CpVNhReXTT
        pFdBDFerboSFM0vVyzH2P89Vh8SaeyK6OOvioXwIA0IiU3Q6umerKvCVE/GWH6tqczVxxbFK/kCbi
        i7AoLeC2INxPm9fVigesa+7NiEHo8BXXYM8187uB2wET0vMYnMz83g6jt847ags2iIeHCWF7BaJPv
        gq9wR3sg==;
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www259.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <mt@waldheinz.de>)
        id 1lyuEV-0006ze-GM; Thu, 01 Jul 2021 12:47:47 +0200
Received: from [192.168.0.31] (helo=mail.your-server.de)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-CHACHA20-POLY1305:256)
        (Exim 4.92)
        (envelope-from <mt@waldheinz.de>)
        id 1lyuEV-000Xy1-9u; Thu, 01 Jul 2021 12:47:47 +0200
Received: from [77.21.132.210] ([77.21.132.210]) by mail.your-server.de
 (Horde Framework) with HTTPS; Thu, 01 Jul 2021 12:47:47 +0200
Date:   Thu, 01 Jul 2021 12:47:32 +0200
Message-ID: <20210701124732.Horde.HT4urccbfqv0Nr1Aayuy0BM@mail.your-server.de>
From:   Matthias Treydte <mt@waldheinz.de>
To:     stable@vger.kernel.org
Cc:     netdev@vger.kernel.org, regressions@lists.linux.dev,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Subject: [regression] UDP recv data corruption
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-Authenticated-Sender: mt@waldheinz.de
X-Virus-Scanned: Clear (ClamAV 0.103.2/26217/Wed Jun 30 13:10:04 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

we recently upgraded the Linux kernel from 5.11.21 to 5.12.12 in our  
video stream receiver appliance and noticed compression artifacts on  
video streams that were previously looking fine. We are receiving UDP  
multicast MPEG TS streams through an FFMpeg / libav layer which does  
the socket and lower level protocol handling. For affected kernels it  
spills the log with messages like

> [mpegts @ 0x7fa130000900] Packet corrupt (stream = 0, dts = 6870802195).
> [mpegts @ 0x7fa11c000900] Packet corrupt (stream = 0, dts = 6870821068).

Bisecting identified commit 18f25dc399901426dff61e676ba603ff52c666f7  
as the one introducing the problem in the mainline kernel. It was  
backported to the 5.12 series in  
450687386cd16d081b58cd7a342acff370a96078. Some random observations  
which may help to understand what's going on:

    * the problem exists in Linux 5.13
    * reverting that commit on top of 5.13 makes the problem go away
    * Linux 5.10.45 is fine
    * no relevant output in dmesg
    * can be reproduced on different hardware (Intel, AMD, different NICs, ...)
    * we do use the bonding driver on the systems (but I did not yet  
verify that this is related)
    * we do not use vxlan (mentioned in the commit message)
    * the relevant code in FFMpeg identifying packet corruption is here:
      https://github.com/FFmpeg/FFmpeg/blob/master/libavformat/mpegts.c#L2758

And the bonding configuration:

# cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v5.10.45

Bonding Mode: fault-tolerance (active-backup)
Primary Slave: None
Currently Active Slave: enp2s0
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0
Peer Notification Delay (ms): 0

Slave Interface: enp2s0
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 80:ee:73:XX:XX:XX
Slave queue ID: 0

Slave Interface: enp3s0
MII Status: down
Speed: Unknown
Duplex: Unknown
Link Failure Count: 0
Permanent HW addr: 80:ee:73:XX:XX:XX
Slave queue ID: 0


If there is anything else I can do to help tracking this down please  
let me know.


Regards,
-Matthias Treydte


