Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8418F397AB3
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 21:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbhFATay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 15:30:54 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:28545 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbhFATav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 15:30:51 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622575749; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=IXojnZomeL2M1SfU/E6nWYLv9q7MmRAE/sdo4Qiv96k=; b=iodjb3h95sBKhR/IS1l8C/6XuFkbd9/02MivutKmMucE/CwA9bwBJ3F51251tw3Skn7Ucv2Y
 DJfEsf7B0XUufarr79SGCUo/Yp8+Azv82lO/X97Qp1Z/GkxyMIxXJqt3e3dJaTCoJ5yk2jQG
 b1Cha/wYKXx16c8LPMUylvbtttE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 60b68a71f726fa418865fe08 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Jun 2021 19:28:49
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9BEB2C43460; Tue,  1 Jun 2021 19:28:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from svurukal-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3FAF0C433D3;
        Tue,  1 Jun 2021 19:28:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3FAF0C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sharathv@codeaurora.org
From:   Sharath Chandra Vurukala <sharathv@codeaurora.org>
To:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org
Cc:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Subject: [PATCH net-next v8 0/3] net: qualcomm: rmnet: Enable Mapv5
Date:   Wed,  2 Jun 2021 00:58:33 +0530
Message-Id: <1622575716-13415-1-git-send-email-sharathv@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces the MAPv5 packet format.

   Patch 0 documents the MAPv4/v5.
   Patch 1 introduces the MAPv5 and the Inline checksum offload for RX/Ingress.
   Patch 2 introduces the MAPv5 and the Inline checksum offload for TX/Egress.

   A new checksum header format is used as part of MAPv5.For RX checksum offload,
   the checksum is verified by the HW and the validity is marked in the checksum
   header of MAPv5. For TX, the required metadata is filled up so hardware can
   compute the checksum.

   v1->v2:
   - Fixed the compilation errors, warnings reported by kernel test robot.
   - Checksum header definition is expanded to support big, little endian
           formats as mentioned by Jakub.

   v2->v3:
   - Fixed compilation errors reported by kernel bot for big endian flavor.

   v3->v4:
   - Made changes to use masks instead of C bit-fields as suggested by Jakub/Alex.

   v4->v5:
   - Corrected checkpatch errors and warnings reported by patchwork.

   v5->v6:
   - Corrected the bug identified by Alex and incorporated all his comments.

   v6->v7:
   - Removed duplicate inclusion of linux/bitfield.h in rmnet_map_data.c

   v7->v8:
   - Have addressed comments given by JAkub on v7 patches.
   - As suggested by Jakub, skb_cow_head() is used instead of expanding 
     the head directly. This is now done in  rmnet_map_egress_handler().

Sharath Chandra Vurukala (3):
  docs: networking: Add documentation for MAPv5
  net: ethernet: rmnet: Support for ingress MAPv5 checksum offload
  net: ethernet: rmnet: Add support for MAPv5 egress packets

 .../device_drivers/cellular/qualcomm/rmnet.rst     | 126 +++++++++++++++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |   4 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |  40 +++---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |  11 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 149 +++++++++++++++++++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |   1 +
 include/linux/if_rmnet.h                           |  30 ++++-
 include/uapi/linux/if_link.h                       |   2 +
 8 files changed, 321 insertions(+), 42 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

