Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEDA255E938
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347055AbiF1N7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 09:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347130AbiF1N7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 09:59:15 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB80435A98
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 06:58:46 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 64EFA320102;
        Tue, 28 Jun 2022 14:58:44 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.95)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1o6Bjn-0008Gk-A7;
        Tue, 28 Jun 2022 14:58:43 +0100
Subject: [PATCH net-next v2 00/10]  sfc: Add extra states for VDPA
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jonathan.s.cooper@amd.com
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Tue, 28 Jun 2022 14:58:43 +0100
Message-ID: <165642465886.31669.17429834766693417246.stgit@palantir17.mph.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL,SPOOF_GMAIL_MID,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For EF100 VDPA support we need to enhance the sfc driver's load and
unload functionality so that it can probe and then unregister its
network device, so that VDPA can use services such as MCDI to initialise
VDPA resources.

v2:
- Fix checkpatch errors.
- Correct signoffs.
---

Jonathan Cooper (10):
      sfc: Split STATE_READY in to STATE_NET_DOWN and STATE_NET_UP.
      sfc: Add a PROBED state for EF100 VDPA use.
      sfc: Remove netdev init from efx_init_struct
      sfc: Change BUG_ON to WARN_ON and recovery code.
      sfc: Encapsulate access to netdev_priv()
      sfc: Separate efx_nic memory from net_device memory
      sfc: Move EF100 efx_nic_type structs to the end of the file
      sfc: Unsplit literal string.
      sfc: replace function name in string with __func__
      sfc: Separate netdev probe/remove from PCI probe/remove


 drivers/net/ethernet/sfc/ef10.c           |    4 
 drivers/net/ethernet/sfc/ef100.c          |   69 ++---
 drivers/net/ethernet/sfc/ef100_ethtool.c  |    2 
 drivers/net/ethernet/sfc/ef100_netdev.c   |  130 ++++++++-
 drivers/net/ethernet/sfc/ef100_netdev.h   |    4 
 drivers/net/ethernet/sfc/ef100_nic.c      |  422 +++++++++++++----------------
 drivers/net/ethernet/sfc/ef100_nic.h      |   10 +
 drivers/net/ethernet/sfc/efx.c            |   73 +++--
 drivers/net/ethernet/sfc/efx_common.c     |   77 ++---
 drivers/net/ethernet/sfc/efx_common.h     |   16 -
 drivers/net/ethernet/sfc/ethtool.c        |   22 +-
 drivers/net/ethernet/sfc/ethtool_common.c |   50 ++-
 drivers/net/ethernet/sfc/mcdi.c           |   15 -
 drivers/net/ethernet/sfc/mcdi_port.c      |    4 
 drivers/net/ethernet/sfc/net_driver.h     |   69 ++++-
 drivers/net/ethernet/sfc/rx_common.c      |    4 
 drivers/net/ethernet/sfc/sriov.c          |   10 -
 drivers/net/ethernet/sfc/tx.c             |    4 
 18 files changed, 554 insertions(+), 431 deletions(-)

--
Martin Habets <habetsm.xilinx@gmail.com>

