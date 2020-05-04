Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38AF1C34E0
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgEDIu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726864AbgEDIu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:50:56 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B020C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:50:56 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id f8so6531915plt.2
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 01:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=nd088o/WqC4IOwffDBLTLrYANo/TO5nA56wwfzvcmcU=;
        b=YaWsI1EnZOpwtnZSmmIHvBpHSNrYM4lNkdjAAceuv9D4New2LWrLVBVdBGzrwedrM2
         rV3AaBbm6P4SmFhYs3L82gbhLwD82ep/6aaBNNzysyDbWjXi/vFgUjaloqxwULvi/otA
         weCaxwiN4xfKNvGEux4II4LZuPTyzR9zxkmIM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nd088o/WqC4IOwffDBLTLrYANo/TO5nA56wwfzvcmcU=;
        b=mMGQP6/h3U4BOVr2HlXBzs0klWcpFjO40epf7zFL4XRlP61p1e9btHRe8xOD80bfN1
         WTNW9q9ACB6qoMhiYhLjpG3sPlPudMoaK+G/cxsaIRDDsOMTJ9PPkTWK94DvYA8mb6OF
         BPMYtrWtJieQlijumuJ/W1aKKV5POI+Z/4q+eTLrmWBKMsbaD5Bs52vxGbNEC/311W1w
         urdoJTdcj3bR+V46bQ//iDE/5ThnJ6dNyn+sBVaXMm6IMwgropYlZKw2jsi+KcHiY3Lm
         IpEN1qHBph5wUCju27sJ4XnlyUJKbZnZn67td6kiFmzlOf3BpDUxbeC1ZTm5+Oqln4as
         VJZg==
X-Gm-Message-State: AGi0PuY3XL44KKN8WN+VXHrjVIjTohIB4M6A9iTFRBreLUMkV+IQi3/B
        ox7tgCD72J1agLX07InJcrlYA/hiU1E=
X-Google-Smtp-Source: APiQypLwZcRgkI+iQEc4bRCmpPDnICS9ZV+kYY/l0AeyYAF/1adEHLxXWyf65FEjDEFBDnP7M+D1Lw==
X-Received: by 2002:a17:902:6901:: with SMTP id j1mr5503098plk.255.1588582255634;
        Mon, 04 May 2020 01:50:55 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x193sm8754088pfd.54.2020.05.04.01.50.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 01:50:54 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 00/15] bnxt_en: Updates for net-next.
Date:   Mon,  4 May 2020 04:50:26 -0400
Message-Id: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset includes these main changes:

1. Firmware spec. update.
2. Context memory sizing improvements for the hardware TQM block.
3. ethtool chip reset improvements and fixes for correctness.
4. Improve L2 doorbell mapping by mapping only up to the size specified
by firmware.  This allows the RoCE driver to map the remaining doorbell
space for its purpose, such as write-combining.
5. Improve ethtool -S channel statistics by showing only relevant ring
counters for non-combined channels.

Edwin Peer (4):
  bnxt_en: prepare to refactor ethtool reset types
  bnxt_en: refactor ethtool firmware reset types
  bnxt_en: fix ethtool_reset_flags ABI violations
  bnxt_en: Improve kernel log messages related to ethtool reset.

Michael Chan (9):
  bnxt_en: Update firmware spec. to 1.10.1.33.
  bnxt_en: Allocate TQM ring context memory according to fw
    specification.
  bnxt_en: Improve TQM ring context memory sizing formulas.
  bnxt_en: Define the doorbell offsets on 57500 chips.
  bnxt_en: Set the db_offset on 57500 chips for the RDMA MSIX entries.
  bnxt_en: Add support for L2 doorbell size.
  bnxt_en: Add doorbell information to bnxt_en_dev struct.
  bnxt_en: Refactor the software ring counters.
  bnxt_en: Split HW ring statistics strings into RX and TX parts.

Rajesh Ravi (1):
  bnxt_en: show only relevant ethtool stats for a TX or RX ring

Vasundhara Volam (1):
  bnxt_en: Do not include ETH_FCS_LEN in the max packet length sent to
    fw.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 100 ++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  24 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 255 ++++++++++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h     | 216 +++++++++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c   |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c     |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h     |   8 +
 8 files changed, 482 insertions(+), 141 deletions(-)

-- 
2.5.1

