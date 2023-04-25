Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831A86EE13B
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 13:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbjDYLr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 07:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjDYLrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 07:47:22 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9122B19AB;
        Tue, 25 Apr 2023 04:47:13 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 7ACED6015F;
        Tue, 25 Apr 2023 13:47:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682423231; bh=lK3t2FX+Y0YLPmB+ojyBIUSPIxd8F7uwZURJHu1cnUQ=;
        h=From:To:Cc:Subject:Date:From;
        b=yAA1U8tO0rmeT6zxY3FPg7PbGqS7VqxVvokE55cPRYxLT42glVWpD5iITiRkui3w/
         aW7wv9B9gvqgr4rVBRpHaSJP35a0kn/uJ/9HIXqJYRZOX+vc57RekQCWwHoAdUdubg
         YLpBr1JioJdXbnAf4LgtdIY0Cu2L0EQUCtJt+OmMSFM4ADa8weIN/6fpYGWarbxKtU
         mVetZ32rYefFOwSGRv4Iv5q+e9B82p1KU6hegyAzNelqYJn6yd9qkXQOwqynaLd3e+
         OcI4fTh4brF7gDvqLXqWAacAHLniuJc35I/GL3w/PDoY4gqRuxDq3+qfHNpt5IScU6
         EtDKHVSMvbR8g==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kmIMX-z_7TnB; Tue, 25 Apr 2023 13:47:07 +0200 (CEST)
Received: by domac.alu.hr (Postfix, from userid 1014)
        id 9AC076016E; Tue, 25 Apr 2023 13:47:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682423227; bh=lK3t2FX+Y0YLPmB+ojyBIUSPIxd8F7uwZURJHu1cnUQ=;
        h=From:To:Cc:Subject:Date:From;
        b=jRzu8o0xv+QSQuJIbDCc2VVfqoLW5b9pAHvwaNpVWJYP5T0TNj40jBxv3eTgb/O2R
         jlHiAq44b0/COjKkB+wvOVwGmOAt2IwPQcyRmcy+LFJY4oZjgRx4bAO60wtiAlOwpq
         c6VMi3QbpeMebFYtWmqhbEs4vRdjkuA2kgh7Qj8Tlki1hXXJQSWhvY1CJRhCJaRTPM
         nPez4fvqZffFEjQBYftsJ4qOKmr8V0VTocnSXGR8l15uPy5kJmOqJpGT7sjJTBpy9O
         +4ftvkIoEU9aKURO6I0YDRdhqoDxhdf4ypaglBRDYYq47ZhDOEbX10GymYeBb2KN1u
         TsxaXa92bKvVw==
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
To:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     nic_swsd@realtek.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: [RFC PATCH v1 1/1] net: r8169: fix the pci setup so the Realtek RTL8111/8168/8411 ethernet speeds up
Date:   Tue, 25 Apr 2023 13:44:56 +0200
Message-Id: <20230425114455.22706-1-mirsad.todorovac@alu.unizg.hr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was noticed that Ookla Speedtest had shown only 250 Mbps download and
310 Mbps upload where Windows 10 on the same box showed 440/310 Mbps, which
is the link capacity.

This article: https://www.phoronix.com/news/Intel-i219-LM-Linux-60p-Fix
inspired to check our speeds. (Previously I used to think it was a network
congestion, or reduction on our ISP, but now each time Windows 10 downlink
speed is 440 compared to 250 Mbps in Linuxes Linux is performing at 60% of
the speed.)

The latest 6.3 kernel shows 95% speed up with this patch as compared to the
same commit without it:

::::::::::::::
speedtest/6.3.0-00436-g173ea743bf7a-dirty-1
::::::::::::::
[marvin@pc-mtodorov ~]$ speedtest -s 41437

   Speedtest by Ookla

      Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
         ISP: Croatian Academic and Research Network
Idle Latency:     1.53 ms   (jitter: 0.15ms, low: 1.30ms, high: 1.71ms)
    Download:   225.13 Mbps (data used: 199.3 MB)
                  1.65 ms   (jitter: 20.15ms, low: 0.81ms, high: 418.27ms)
      Upload:   350.00 Mbps (data used: 157.9 MB)
                  3.35 ms   (jitter: 19.46ms, low: 1.61ms, high: 474.55ms)
 Packet Loss:     0.0%
  Result URL: https://www.speedtest.net/result/c/a0084fd8-c275-4019-899a-a1590e49a34b
[marvin@pc-mtodorov ~]$ speedtest -s 41437

   Speedtest by Ookla

      Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
         ISP: Croatian Academic and Research Network
Idle Latency:     1.54 ms   (jitter: 0.28ms, low: 1.17ms, high: 1.64ms)
    Download:   222.88 Mbps (data used: 207.9 MB)
                 10.23 ms   (jitter: 31.76ms, low: 0.75ms, high: 353.79ms)
      Upload:   349.91 Mbps (data used: 157.7 MB)
                  3.27 ms   (jitter: 13.05ms, low: 1.67ms, high: 236.76ms)
 Packet Loss:     0.0%
  Result URL: https://www.speedtest.net/result/c/f4c663ba-830d-44c6-8033-ce3b3b818c42
[marvin@pc-mtodorov ~]$
::::::::::::::
speedtest/6.3.0-r8169-00437-g323fe5352af6-dirty-2
::::::::::::::
[marvin@pc-mtodorov ~]$ speedtest -s 41437

   Speedtest by Ookla

      Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
         ISP: Croatian Academic and Research Network
Idle Latency:     0.84 ms   (jitter: 0.05ms, low: 0.82ms, high: 0.93ms)
    Download:   432.37 Mbps (data used: 360.5 MB)
                142.43 ms   (jitter: 76.45ms, low: 1.02ms, high: 1105.19ms)
      Upload:   346.29 Mbps (data used: 164.6 MB)
                  7.72 ms   (jitter: 29.80ms, low: 0.92ms, high: 283.48ms)
 Packet Loss:    12.8%
  Result URL: https://www.speedtest.net/result/c/e473359e-c37e-4f29-aa9f-4b008210cf7c
[marvin@pc-mtodorov ~]$ speedtest -s 41437

   Speedtest by Ookla

      Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
         ISP: Croatian Academic and Research Network
Idle Latency:     0.82 ms   (jitter: 0.16ms, low: 0.75ms, high: 1.05ms)
    Download:   440.97 Mbps (data used: 427.5 MB)
                 72.50 ms   (jitter: 52.89ms, low: 0.91ms, high: 865.08ms)
      Upload:   342.75 Mbps (data used: 166.6 MB)
                  3.26 ms   (jitter: 22.93ms, low: 1.07ms, high: 239.41ms)
 Packet Loss:    13.4%
  Result URL: https://www.speedtest.net/result/c/f393e149-38d4-4a34-acc4-5cf81ff13708

440 Mbps is the speed achieved in Windows 10, and Linux 6.3 with
the patch, while 225 Mbps without this patch is running at 51% of
the nominal speed with the same hardware and Linux kernel commit.

Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: nic_swsd@realtek.com
Cc: netdev@vger.kernel.org
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1671958#c60
Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
---
 drivers/net/ethernet/realtek/r8169_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 45147a1016be..b8a04301d130 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3239,6 +3239,7 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 	r8168_mac_ocp_write(tp, 0xc094, 0x0000);
 	r8168_mac_ocp_write(tp, 0xc09e, 0x0000);
 
+	pci_disable_link_state(tp->pci_dev, PCIE_LINK_STATE_CLKPM);
 	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
-- 
2.30.2

