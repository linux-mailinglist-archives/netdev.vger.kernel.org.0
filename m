Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CA53231BF
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 21:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbhBWUD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 15:03:57 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:59305 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230494AbhBWUDy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 15:03:54 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614110614; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=24Di64oJbXIbyESGUykkIrDVguN5McqqVzflAdbS4+E=; b=VnEVsjidT01gFyBE/zi6REEyaPryV4NNIVHEIuEJWjc6bqXHbjlGk/xkeYUgsaRkv4wddltk
 RlvGmYW8HfNLuXIAeC++/R+qqLuriIAP6PZvuvdxtJJy+t11igOpiIySI37BqURcYWd/FsbF
 SbFOjRowtDNIGaxhxAESZFP/htQ=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60355f7c090a774287dd044e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 23 Feb 2021 20:03:08
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DBCE2C43462; Tue, 23 Feb 2021 20:03:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from svurukal-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DBAA0C433CA;
        Tue, 23 Feb 2021 20:03:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DBAA0C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sharathv@codeaurora.org
From:   Sharath Chandra Vurukala <sharathv@codeaurora.org>
To:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Subject: [PATCH net-next v3 0/3] net: qualcomm: rmnet: Enable Mapv5
Date:   Wed, 24 Feb 2021 01:32:48 +0530
Message-Id: <1614110571-11604-1-git-send-email-sharathv@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces the MAPv5 packet format.

Patch 0 documents the MAPv5.
Patch 1 introduces the Mapv5 and the Inline checksum offload for RX.
Patch 2 introduces the Mapv5 and the Inline checksum offload for TX.

A new checksum header format is used as part of MAPv5.
For RX checksum offload, the checksum is verified by the HW and the
validity is marked in the checksum header of MAPv5.
for TX, the required metadata is filled up so hardware can compute the
checksum.

v1->v2:
- Fixed the compilation errors, warnings reported by kernel test robot.
- Checksum header definition is expanded to support big, little endian
	formats as mentioned by Jakub.

v2->v3:
- Fixed compilation errors reported by kernel bot for big endian flavor.

Sharath Chandra Vurukala (3):
  docs: networking: Add documentation for MAPv5
  net: ethernet: rmnet: Support for downlink MAPv5 checksum offload
  net: ethernet: rmnet: Add support for Mapv5 uplink packet

 .../device_drivers/cellular/qualcomm/rmnet.rst     |  53 ++++++-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |   4 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |  34 +++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |  22 ++-
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 153 ++++++++++++++++++++-
 include/linux/if_rmnet.h                           |  24 +++-
 include/uapi/linux/if_link.h                       |   2 +
 7 files changed, 263 insertions(+), 29 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

