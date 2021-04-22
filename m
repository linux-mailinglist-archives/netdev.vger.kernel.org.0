Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A3036878F
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 22:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238922AbhDVUDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 16:03:08 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:47757 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237049AbhDVUDH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 16:03:07 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619121752; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=a881ow+4PhxSX+A5ZfdVsrzB9Qul8Rd5g0XoSWyK3+o=; b=igIv3XfG4OWoTgdOkMSa2RibFM/iq2GJcKeQGUJmQjOREmARxuq5g+88m/bSpPKfnPRvDNcD
 4eJe2ZX+RuAw3d2w8w81k40Gap0svU5Ogx0dtIPEiUz/Wco0ZWGh1JDwoNiAvrOLKhiVKPGe
 k+6cFA+04aZiWtRAY5jRq8jJamM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 6081d652215b831afb7c3756 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 22 Apr 2021 20:02:26
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 368F1C43460; Thu, 22 Apr 2021 20:02:26 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from svurukal-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 48F80C433D3;
        Thu, 22 Apr 2021 20:02:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 48F80C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sharathv@codeaurora.org
From:   Sharath Chandra Vurukala <sharathv@codeaurora.org>
To:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Subject: [PATCH net-next v4 0/3] net: qualcomm: rmnet: Enable Mapv5
Date:   Fri, 23 Apr 2021 01:32:08 +0530
Message-Id: <1619121731-17782-1-git-send-email-sharathv@codeaurora.org>
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

Sharath Chandra Vurukala (3):
  docs: networking: Add documentation for MAPv5
  net: ethernet: rmnet: Support for ingress MAPv5 checksum offload
  net: ethernet: rmnet: Add support for MAPv5 egress packets

 .../device_drivers/cellular/qualcomm/rmnet.rst     | 126 +++++++++++++++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |   4 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |  29 ++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |  11 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 151 ++++++++++++++++++++-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |   3 +-
 include/linux/if_rmnet.h                           |  27 +++-
 include/uapi/linux/if_link.h                       |   2 +
 8 files changed, 318 insertions(+), 35 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

