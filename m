Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C33F516791
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 21:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354210AbiEATtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 15:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiEATtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 15:49:49 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CC719288;
        Sun,  1 May 2022 12:46:22 -0700 (PDT)
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d73c42b1d8248fa9506c0d17.dip0.t-ipconnect.de [IPv6:2003:e9:d73c:42b1:d824:8fa9:506c:d17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 2C31AC06B0;
        Sun,  1 May 2022 21:46:20 +0200 (CEST)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: pull-request: ieee802154-next 2022-05-01
Date:   Sun,  1 May 2022 21:46:14 +0200
Message-Id: <20220501194614.1198325-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave, Jakub.

An update from ieee802154 for your *net-next* tree.
For the merge conflict resolution please see below.

Miquel Raynal landed two patch series bundled in this pull request.

The first series re-works the symbol duration handling to better
accommodate the needs of the various phy layers in ieee802154.

In the second series Miquel improves th errors handling from drivers
up mac802154. THis streamlines the error handling throughout the
ieee/mac802154 stack in preparation for sync TX to be introduced for
MLME frames.

When merging into the current net-next HEAD the following merge conflict
resolution is needed:

--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@@ -2974,9 -2931,6 +2931,12 @@@ static void ca8210_hw_setup(struct ieee
        ca8210_hw->phy->cca.mode = NL802154_CCA_ENERGY_CARRIER;
        ca8210_hw->phy->cca.opt = NL802154_CCA_OPT_ENERGY_CARRIER_AND;
        ca8210_hw->phy->cca_ed_level = -9800;
 +      ca8210_hw->phy->symbol_duration = 16;
 +      ca8210_hw->phy->lifs_period = 40 * ca8210_hw->phy->symbol_duration;
 +      ca8210_hw->phy->sifs_period = 12 * ca8210_hw->phy->symbol_duration;
        ca8210_hw->flags =
                IEEE802154_HW_AFILT |
                IEEE802154_HW_OMIT_CKSUM |

regards
Stefan Schmidt


The following changes since commit 9557167bc63e3910c656a1628f2f52ab1cf6d541:

  Merge tag 'ieee802154-for-davem-2022-02-10' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan-next (2022-02-10 14:28:04 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan-next.git tags/ieee802154-for-davem-2022-05-01

for you to fetch changes up to 1229df4b313acf15d372caadcbbc62a430cd2697:

  net: mac802154: Fix symbol durations (2022-04-30 20:29:47 +0200)

----------------------------------------------------------------
Miquel Raynal (15):
      net: ieee802154: ca8210: Fix lifs/sifs periods
      net: mac802154: Convert the symbol duration into nanoseconds
      net: mac802154: Set durations automatically
      net: ieee802154: Drop duration settings when the core does it already
      net: ieee802154: Enhance/fix the names of the MLME return codes
      net: ieee802154: Fill the list of MLME return codes
      net: mac802154: Save a global error code on transmissions
      net: mac802154: Create an offloaded transmission error helper
      net: mac802154: Create an error helper for asynchronous offloading errors
      net: ieee802154: at86rf230: Call _xmit_hw_error() when failing to offload frames
      net: ieee802154: at86rf230: Forward Tx trac errors
      net: ieee802154: atusb: Call _xmit_hw_error() upon transmission error
      net: ieee802154: ca8210: Use core return codes instead of hardcoding them
      net: ieee802154: ca8210: Call _xmit_error() when a transmission fails
      net: mac802154: Fix symbol durations

 drivers/net/ieee802154/Kconfig     |   7 --
 drivers/net/ieee802154/at86rf230.c | 163 +++++---------------------------
 drivers/net/ieee802154/atusb.c     |  37 +-------
 drivers/net/ieee802154/ca8210.c    | 184 ++++++++++++++-----------------------
 drivers/net/ieee802154/mcr20a.c    |   5 -
 include/linux/ieee802154.h         |  81 ++++++++++++++--
 include/net/cfg802154.h            |   6 +-
 include/net/mac802154.h            |  19 ++++
 net/mac802154/cfg.c                |   1 +
 net/mac802154/ieee802154_i.h       |   2 +
 net/mac802154/main.c               |  54 ++++++++++-
 net/mac802154/util.c               |  22 ++++-
 12 files changed, 262 insertions(+), 319 deletions(-)
