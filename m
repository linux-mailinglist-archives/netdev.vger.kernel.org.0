Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF72364AF4
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 22:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238476AbhDSUD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 16:03:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhDSUDO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 16:03:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D22AB613AC;
        Mon, 19 Apr 2021 20:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618862564;
        bh=l7tbs71vNbfqZ/AP/qGjqBVLU20kb4G96/EQ/B0Bs5g=;
        h=From:To:Cc:Subject:Date:From;
        b=LlQMdTGZ2FJ58I0UAbrwNjooQmZt/DtfaSg+GAOcxUeCI1OTLJ8PpEikUKKNaLXEY
         H7lCTJiqUt1BECZGNrOwxNM0H7vjTHQflbu/uwV/SKBo9wotYqsAnGp7klbCiOPAce
         XWzVA50MPtoj+cLvcfzTg6S1ecAtNxtWYJb6pUI+Fq/ouJU04l+0ieqy5mtkLvwBVs
         iZ1mapfoSBvv1wkeGsLZ0NyTg4lX8waydhdYgy96xqx6rPD5l5EuuMkQ9sYitItHvQ
         i9UhWD09DZtHWemh/p9IIptuLrQt6bq5II5SEgSaPOm0/wljHXAHqVDHicD7Mj8PWH
         F/Glhl+9Zvk0g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] bnxt: add more ethtool standard stats
Date:   Mon, 19 Apr 2021 13:02:42 -0700
Message-Id: <20210419200242.2984499-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michael suggest a few more stats we can expose.

$ ethtool -S eth0 --groups eth-mac
Standard stats for eth0:
eth-mac-FramesTransmittedOK: 902623288966
eth-mac-FramesReceivedOK: 28727667047
eth-mac-FrameCheckSequenceErrors: 1
eth-mac-AlignmentErrors: 0
eth-mac-OutOfRangeLengthField: 0
$ ethtool -S eth0 | grep '\(fcs\|align\|oor\)'
     rx_fcs_err_frames: 1
     rx_align_err_frames: 0
     tx_fcs_err_frames: 0

Suggested-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 832252313b18..3b66e300c962 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -4020,6 +4020,12 @@ static void bnxt_get_eth_mac_stats(struct net_device *dev,
 		BNXT_GET_RX_PORT_STATS64(rx, rx_good_frames);
 	mac_stats->FramesTransmittedOK =
 		BNXT_GET_TX_PORT_STATS64(tx, tx_good_frames);
+	mac_stats->FrameCheckSequenceErrors =
+		BNXT_GET_RX_PORT_STATS64(rx, rx_fcs_err_frames);
+	mac_stats->AlignmentErrors =
+		BNXT_GET_RX_PORT_STATS64(rx, rx_align_err_frames);
+	mac_stats->OutOfRangeLengthField =
+		BNXT_GET_RX_PORT_STATS64(rx, rx_oor_len_frames);
 }
 
 static void bnxt_get_eth_ctrl_stats(struct net_device *dev,
-- 
2.30.2

