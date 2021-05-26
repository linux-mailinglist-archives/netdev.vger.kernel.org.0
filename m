Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C59391AD4
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 16:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbhEZO4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 10:56:49 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:32772 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235007AbhEZO4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 10:56:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622040917; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=53KMbWrHWLmq5ylrUR1cp7KG0RzHoDEqqnfOHSApgk4=; b=OcA5yPIwoBC1DT6YS2miqdmkH28gTmuci8mhCSuMRmb023KG+P2D5DfnJOlNAr+orn77IioM
 +H6wajv2iIkGMWAJWtXG54mzoFpwIO70k9SacWOWf/06BS1Uwkbqva+dJ3WRKrY44Vcuusmc
 elKOzPhEa41dhvC9QKQsfwdwF/w=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60ae61477b5af81b5c0f0294 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 26 May 2021 14:55:03
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EEF57C4323A; Wed, 26 May 2021 14:55:02 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from svurukal-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 184C2C4338A;
        Wed, 26 May 2021 14:54:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 184C2C4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sharathv@codeaurora.org
From:   Sharath Chandra Vurukala <sharathv@codeaurora.org>
To:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Subject: [PATCH net-next v6 0/3] net: qualcomm: rmnet: Enable Mapv5
Date:   Wed, 26 May 2021 20:24:39 +0530
Message-Id: <1622040882-27526-1-git-send-email-sharathv@codeaurora.org>
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

Sharath Chandra Vurukala (3):
  docs: networking: Add documentation for MAPv5
  net: ethernet: rmnet: Support for ingress MAPv5 checksum offload
  net: ethernet: rmnet: Add support for MAPv5 egress packets

 .../device_drivers/cellular/qualcomm/rmnet.rst     | 126 +++++++++++++++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |   4 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |  34 +++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |  11 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 152 +++++++++++++++++++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |   3 +-
 include/linux/if_rmnet.h                           |  26 +++-
 include/uapi/linux/if_link.h                       |   2 +
 8 files changed, 321 insertions(+), 37 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

