Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506414CEA19
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 09:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbiCFI6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 03:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiCFI6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 03:58:18 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CEB6D95C
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 00:57:24 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id kt27so26111874ejb.0
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 00:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zsn0TnKzCl2FrAAd6QwRoWrGBEuaAsyN8iz8HOeqW00=;
        b=32wVg7CPYUQoZIzB4eex+rKmmjQBg7INLWrHq90XQ94OURa6vuZYzaDHNloxc+ydxm
         +/Sgqv1Or6vBFOuDE7eDR/ofp1l/VfpAlSCAd26VX9aYd/lJ3pAhciCbAeA97dr/mkHB
         t604EhEx9G4bLWzn9fQhG7kb37b16HsLcdGG1KHkZoFHxxDdVzGLj/GeZ8XziwwgCZRR
         BDJZDM6LTddYsIrVmYHGV5ROEMEWEviyDZoFXp1UbjLcRYJjdv3fAE5F0Nc2hR2fxZQ3
         mN5f8hNVA1VUfZG8YEfSGjyLWrI8EZFPLrUUAqtcpPc3NEfMac765VMTxcQr3Aq66udo
         ui5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zsn0TnKzCl2FrAAd6QwRoWrGBEuaAsyN8iz8HOeqW00=;
        b=IUhhWlBcrL7DQB4w8ap1MGwVdVbDbKMhYmWyzsorClvs7yJf5aJqtW3IhZxwXUYlrD
         fLWazxIzL5/gcoOzCNGFL59rXvaiqGHdwAM5Ypz+/ksnI68q1b+h6wOwnLX7PMEJ7x/v
         riBH+1zgimduWFM1Th0ggL+6s78HhT3rerSRdE6+jwZEt23KQEhZ7t8xZ4Y2qmobvzP0
         kqHswvdL3CeCYe9dh/FimrPfxi6xKkT+tXCYxl8tDYC1Xp35OLFyooyjdbw0P3hd7OXw
         Gd8cKEFQRTNHdN4b4LhRmrURKdmS4RP6tR+C5VXVbprCABg6DzgozIW+c0YYzcaBuGcU
         HjqA==
X-Gm-Message-State: AOAM531JeL68bnuwNVH5m0ddND6nkoNAc94LYWdy/PG/ByXvo/IC5pUy
        CfVnNZl4UBLGBzFSI6EDz5FzKA==
X-Google-Smtp-Source: ABdhPJwzJv6L2P6ooVOhHwDVIbxDVgdN1iOHgbYb1D5cCrO7qXO/W9xKxNJfYVcMqHxbvLmrHZFi2A==
X-Received: by 2002:a17:906:7d83:b0:6ce:fee:9256 with SMTP id v3-20020a1709067d8300b006ce0fee9256mr5396414ejo.647.1646557042226;
        Sun, 06 Mar 2022 00:57:22 -0800 (PST)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id z24-20020a170906815800b006dab4bd985dsm2663423ejw.107.2022.03.06.00.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 00:57:21 -0800 (PST)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with additional free running time
Date:   Sun,  6 Mar 2022 09:56:52 +0100
Message-Id: <20220306085658.1943-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ptp vclocks require a clock with free running time for the timecounter.
Currently only a physical clock forced to free running is supported.
If vclocks are used, then the physical clock cannot be synchronized
anymore. The synchronized time is not available in hardware in this
case. As a result, timed transmission with ETF/TAPRIO hardware support
is not possible anymore.

If hardware would support a free running time additionally to the
physical clock, then the physical clock does not need to be forced to
free running. Thus, the physical clocks can still be synchronized while
vclocks are in use.

The physical clock could be used to synchronize the time domain of the
TSN network and trigger ETF/TAPRIO. In parallel vclocks can be used to
synchronize other time domains.

One year ago I thought for two time domains within a TSN network also
two physical clocks are required. This would lead to new kernel
interfaces for asking for the second clock, ... . But actually for a
time triggered system like TSN there can be only one time domain that
controls the system itself. All other time domains belong to other
layers, but not to the time triggered system itself. So other time
domains can be based on a free running counter if similar mechanisms
to 2 step synchronisation are used.

Synchronisation was tested with two time domains between two directly
connected hosts. Each host run two ptp4l instances, the first used the
physical clock and the second used the virtual clock. I used my FPGA
based network controller as network device. ptp4l was used in
combination with the virtual clock support patch set from Miroslav
Lichvar.

Please give me some feedback. For me it seems like a straight forward
extension for ptp vclocks, but I'm new to this topic.

Gerhard Engleder (6):
  bpf: Access hwtstamp field of hwtstamps directly
  ptp: Initialize skb_shared_hwtstamps
  ptp: Add free running time support
  ptp: Support time stamps based on free running time
  ptp: Allow vclocks without free running physical clock
  tsnep: Add free running time support

 .../net/ethernet/cavium/liquidio/lio_main.c   |  1 +
 .../ethernet/cavium/liquidio/lio_vf_main.c    |  1 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_ptp.c    |  1 +
 drivers/net/ethernet/engleder/tsnep_hw.h      |  9 ++++--
 drivers/net/ethernet/engleder/tsnep_main.c    |  6 ++++
 drivers/net/ethernet/engleder/tsnep_ptp.c     | 28 +++++++++++++++++++
 .../hisilicon/hns3/hns3pf/hclge_ptp.c         |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    |  1 +
 drivers/net/ethernet/sfc/tx_common.c          |  1 +
 drivers/ptp/ptp_clock.c                       |  8 +++---
 drivers/ptp/ptp_ines.c                        |  1 +
 drivers/ptp/ptp_private.h                     |  9 ++++++
 drivers/ptp/ptp_sysfs.c                       | 11 ++++----
 drivers/ptp/ptp_vclock.c                      | 25 +++++++++++++----
 include/linux/ptp_clock_kernel.h              | 27 ++++++++++++++++++
 include/linux/skbuff.h                        |  3 ++
 net/core/filter.c                             |  3 +-
 17 files changed, 117 insertions(+), 19 deletions(-)

-- 
2.20.1

