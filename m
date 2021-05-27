Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E62B392A0C
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235824AbhE0IvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:51:20 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:48271 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235724AbhE0Iuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 04:50:52 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622105359; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=Clw2/s+iDnPmn5bfkKOP5moMbRkF8z7t48xn9DXyOWE=; b=RcXSq40kmHE0Ly0sMNhAnbUmUH72N+tj6rlXsrw7YQkttgK99ugTMtPXlTTr/YNs0lDmpasS
 ZTwRD+atKW7Irwr+cnEp8cfTtjzPnHRKctChd+jPcCIJ2Mg2htVA6hFD9TXb1kjgamGF5Vxt
 kjuCtED5xJELzcMqytyKrDyQNdA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 60af5cf78dd30e785f8fd59d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 May 2021 08:48:55
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4611BC43217; Thu, 27 May 2021 08:48:54 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from svurukal-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A2E76C43460;
        Thu, 27 May 2021 08:48:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A2E76C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sharathv@codeaurora.org
From:   Sharath Chandra Vurukala <sharathv@codeaurora.org>
To:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Subject: [PATCH net-next v7 0/3] net: qualcomm: rmnet: Enable Mapv5
Date:   Thu, 27 May 2021 14:18:39 +0530
Message-Id: <1622105322-2975-1-git-send-email-sharathv@codeaurora.org>
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

Sharath Chandra Vurukala (3):
  docs: networking: Add documentation for MAPv5
  net: ethernet: rmnet: Support for ingress MAPv5 checksum offload
  net: ethernet: rmnet: Add support for MAPv5 egress packets

 .../device_drivers/cellular/qualcomm/rmnet.rst     | 126 +++++++++++++++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |   4 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |  34 +++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |  11 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 151 +++++++++++++++++++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |   3 +-
 include/linux/if_rmnet.h                           |  26 +++-
 include/uapi/linux/if_link.h                       |   2 +
 8 files changed, 320 insertions(+), 37 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

