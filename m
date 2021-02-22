Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04904321D91
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 17:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhBVQ5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 11:57:42 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:54856 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231430AbhBVQ5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 11:57:10 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614013009; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=V/HwcADjuqy1QtqfOuHVMbT6dMiQduhJkkDSWD4MygU=; b=ts3vR8u4dhewKq7wxrxB0yMZZiPy7xJluUiVLqM+DsqWhoYYGTik0xi0JrvY0oqTGDcI9SAV
 5s+SLZa6K17bDb7Z4eFWbmcoe7gR1QgGrjdFVG8nspAreaYa/qELGkBNalsp5UU1MSr/+gR0
 /h82MlWgawWfdfJYqCznu0juElc=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 6033e22e090a774287a3a745 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 22 Feb 2021 16:56:14
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 56AF9C43463; Mon, 22 Feb 2021 16:56:14 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from svurukal-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5D32BC433C6;
        Mon, 22 Feb 2021 16:56:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5D32BC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sharathv@codeaurora.org
From:   Sharath Chandra Vurukala <sharathv@codeaurora.org>
To:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Subject: [PATCH net-next v2 0/3] net: qualcomm: rmnet: Enable Mapv5
Date:   Mon, 22 Feb 2021 22:25:43 +0530
Message-Id: <1614012946-23506-1-git-send-email-sharathv@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces the MAPv5 packet format.

Patch 0 documents the MAPv5.
Patch 1 introduces the Mapv5 and the Inline checksum offload for RX.
Patch 2 introduces the Mapv5 and the Inline checksum offload for TX.

A new checksum header format is used as part of MAPv5.
For RX checksum offload, the checksum is verified by the HW and the validity is marked in the checksum header of MAPv5.
for TX, the required metadata is filled up so hardware can compute the checksum.

v1->v2:
- Fixed the compilation errors, warnings reported by kernel test robot.
- Checksum header definition is expanded to support big, little endian formats as mentioned by Jakub.

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

