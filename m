Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941CD32E492
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhCEJSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:18:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhCEJRi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 04:17:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BCD464F45;
        Fri,  5 Mar 2021 09:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614935858;
        bh=UJVX4I3e0gzembYyUDgRF/x6Iaw/gv9eTJamAsBUUVo=;
        h=Date:From:To:Cc:Subject:From;
        b=SYSnKtSVXAFosF5bO2DiPV43aMMITUXl2N6iRPa7mQv6gSdu6zBAXAmEq52Flc1T+
         0eu7nDK1j3UhLxaZ8HSOkFEA0N4Z7ctC5+40Dc7gtkkjadlT1DtA8M0h72VQMfyyGS
         Dh4veEgT7TkDS+n+5fUOziL7gyk+yV9gpHD4ztrkLi54yrIxH7KgPjwkBhWk4s1cgf
         FkNPAZAPMI7ypXNNcLIeBdJgEM+nvrVFTKbm+npfP3flMJVS2ACZy+AzFiJ2TkvxUz
         meq5h2fJ2r9Tv5Qzjf4c/J0mOam+z50wffmB1a8mZRPEp2kUtYuvV2njf8eUxJEzLN
         Z1h7QnERrTsSg==
Date:   Fri, 5 Mar 2021 03:17:35 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] qlcnic: Fix fall-through warnings for Clang
Message-ID: <20210305091735.GA139591@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding a break and a goto statements instead of
just letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c   | 1 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
index bdf15d2a6431..af4c516a9e7c 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -1390,6 +1390,7 @@ static int qlcnic_process_rcv_ring(struct qlcnic_host_sds_ring *sds_ring, int ma
 			break;
 		case QLCNIC_RESPONSE_DESC:
 			qlcnic_handle_fw_message(desc_cnt, consumer, sds_ring);
+			goto skip;
 		default:
 			goto skip;
 		}
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 96b947fde646..8966f1bcda77 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -3455,6 +3455,7 @@ qlcnic_fwinit_work(struct work_struct *work)
 			adapter->fw_wait_cnt = 0;
 			return;
 		}
+		break;
 	case QLCNIC_DEV_FAILED:
 		break;
 	default:
-- 
2.27.0

