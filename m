Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EA5426FCF
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 19:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238771AbhJHSBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 14:01:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231217AbhJHSBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 14:01:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30FBD60F43;
        Fri,  8 Oct 2021 17:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633715957;
        bh=PXB8edgi6jaB7x2t7nflUpLduYPoD+ghmIQNQR61/7g=;
        h=From:To:Cc:Subject:Date:From;
        b=l5Fj9TOsaQXgM8tTkj5vAvSbXyFN24zvn8FHNBORnHArQ8NOdbEV9S7VOlxajXcNC
         Fl07tYtbZeV2ydDf7dBsojAuyu0B8Mxv6fN/6I57LYtvbKrykASaUwlVcqVpjRtPQc
         dFL5ZTsImr9CS1q8WPT3ZVd3wcY92wfciIOd2y427FqqCZNZgdmlW8qQFMSzI7KFVX
         snVmpb/3zWtqSB1DdzT7vh6VoQ1iwo7BXaAFiG/RGnXcg2gramjju7mosT8ikvrhyO
         mui7URff5uOtAgBSrluLOWRCBnv+GweEpoDUqXd1RXoOKr5Ul4IBQHGIyPCM2wr5qE
         kL2BEo6wfY6DQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/5] net: remove direct netdev->dev_addr writes
Date:   Fri,  8 Oct 2021 10:59:08 -0700
Message-Id: <20211008175913.3754184-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount 
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

This series contains top 5 conversions in terms of LoC required
to bring the driver into compliance.

Jakub Kicinski (5):
  ethernet: forcedeth: remove direct netdev->dev_addr writes
  ethernet: tg3: remove direct netdev->dev_addr writes
  ethernet: tulip: remove direct netdev->dev_addr writes
  ethernet: sun: remove direct netdev->dev_addr writes
  ethernet: 8390: remove direct netdev->dev_addr writes

 drivers/net/ethernet/8390/apne.c            |  3 +-
 drivers/net/ethernet/8390/ax88796.c         |  6 ++-
 drivers/net/ethernet/8390/axnet_cs.c        |  7 ++-
 drivers/net/ethernet/8390/mcf8390.c         |  3 +-
 drivers/net/ethernet/8390/ne.c              |  4 +-
 drivers/net/ethernet/8390/pcnet_cs.c        | 22 ++++++---
 drivers/net/ethernet/8390/stnic.c           |  5 +--
 drivers/net/ethernet/8390/zorro8390.c       |  3 +-
 drivers/net/ethernet/broadcom/tg3.c         | 48 ++++++++++----------
 drivers/net/ethernet/dec/tulip/de2104x.c    | 15 ++++---
 drivers/net/ethernet/dec/tulip/de4x5.c      | 35 +++++++--------
 drivers/net/ethernet/dec/tulip/dmfe.c       |  9 ++--
 drivers/net/ethernet/dec/tulip/tulip_core.c | 37 +++++++++-------
 drivers/net/ethernet/dec/tulip/uli526x.c    | 11 +++--
 drivers/net/ethernet/dec/tulip/xircom_cb.c  |  4 +-
 drivers/net/ethernet/nvidia/forcedeth.c     | 49 +++++++++++----------
 drivers/net/ethernet/sun/cassini.c          |  7 +--
 drivers/net/ethernet/sun/ldmvsw.c           |  7 +--
 drivers/net/ethernet/sun/niu.c              | 42 ++++++++++--------
 drivers/net/ethernet/sun/sungem.c           | 11 +++--
 drivers/net/ethernet/sun/sunhme.c           | 15 +++++--
 21 files changed, 191 insertions(+), 152 deletions(-)

-- 
2.31.1

