Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD2D4F762A
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 08:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241184AbiDGGgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 02:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbiDGGgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 02:36:24 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDA3A8B6DE;
        Wed,  6 Apr 2022 23:34:22 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app4 (Coremail) with SMTP id cS_KCgBnKRC7hU5imJbiAA--.58581S2;
        Thu, 07 Apr 2022 14:33:35 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org
Cc:     chris@zankel.net, jcmvbkbc@gmail.com, mustafa.ismail@intel.com,
        shiraz.saleem@intel.com, jgg@ziepe.ca, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jes@trained-monkey.org,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alexander.deucher@amd.com, linux-xtensa@linux-xtensa.org,
        linux-rdma@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-hippi@sunsite.dk,
        linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH 00/11] Fix deadlocks caused by del_timer_sync()
Date:   Thu,  7 Apr 2022 14:33:16 +0800
Message-Id: <cover.1649310812.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgBnKRC7hU5imJbiAA--.58581S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AFWkWw1rJF47KF45KFyUJrb_yoW8GF4DpF
        45u390kr1jvF4xu3W8tw1kZFy3Gw4xJrWrK39Fq3s5Xa4rZF43XF17GFy8WrZ5JryxGa4a
        yF1qyw4rGF4avrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvm1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IY
        c2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
        z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
        UI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgYNAVZdtZEbDgAOs8
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the timer handlers need a lock owned by the thread calling 
del_timer_sync(), then, the caller thread will block forever.

Duoming Zhou (11):
  drivers: tty: serial: Fix deadlock in sa1100_set_termios()
  drivers: usb: host: Fix deadlock in oxu_bus_suspend()
  drivers: staging: rtl8192u: Fix deadlock in ieee80211_beacons_stop()
  drivers: staging: rtl8723bs: Fix deadlock in
    rtw_surveydone_event_callback()
  drivers: staging: rtl8192e: Fix deadlock in rtllib_beacons_stop()
  drivers: staging: rtl8192e: Fix deadlock in
    rtw_joinbss_event_prehandle()
  drivers: net: hippi: Fix deadlock in rr_close()
  drivers: net: can: Fix deadlock in grcan_close()
  drivers: infiniband: hw: Fix deadlock in irdma_cleanup_cm_core()
  arch: xtensa: platforms: Fix deadlock in iss_net_close()
  arch: xtensa: platforms: Fix deadlock in rs_close()

 arch/xtensa/platforms/iss/console.c                    | 4 +++-
 arch/xtensa/platforms/iss/network.c                    | 2 ++
 drivers/infiniband/hw/irdma/cm.c                       | 5 ++++-
 drivers/net/can/grcan.c                                | 2 ++
 drivers/net/hippi/rrunner.c                            | 2 ++
 drivers/staging/rtl8192e/rtllib_softmac.c              | 2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c | 2 +-
 drivers/staging/rtl8723bs/core/rtw_mlme.c              | 4 ++++
 drivers/tty/serial/sa1100.c                            | 2 ++
 drivers/usb/host/oxu210hp-hcd.c                        | 2 ++
 10 files changed, 23 insertions(+), 4 deletions(-)

-- 
2.17.1

