Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6683231C1
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 21:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhBWUEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 15:04:54 -0500
Received: from z11.mailgun.us ([104.130.96.11]:10740 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232855AbhBWUEH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 15:04:07 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614110623; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=t0cz53IAX+/FneoR+vsyiw9pb0SsZhCyMYdQLz+4UIY=; b=xJ0IfNqdWaARYM3RL0tjdpueeIqBPEUNGPbHZRdWcg6+gKzkm5Sj77EX+3eNMSCIAnr36m9Z
 CHhjTV5HO8K9GjJ2KUXHLtLIRexbvQZu9COgsYJfhgR2l/uK/9YtXf8m8xu/M+5lN4UaKVak
 9BEfI1UmKK8VF3SXenyTrWsoStw=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 60355f84e9080d5ff7f668d2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 23 Feb 2021 20:03:16
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CB618C433CA; Tue, 23 Feb 2021 20:03:15 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from svurukal-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6F910C433CA;
        Tue, 23 Feb 2021 20:03:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6F910C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sharathv@codeaurora.org
From:   Sharath Chandra Vurukala <sharathv@codeaurora.org>
To:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Subject: [PATCH net-next v3 1/3] docs: networking: Add documentation for MAPv5
Date:   Wed, 24 Feb 2021 01:32:49 +0530
Message-Id: <1614110571-11604-2-git-send-email-sharathv@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614110571-11604-1-git-send-email-sharathv@codeaurora.org>
References: <1614110571-11604-1-git-send-email-sharathv@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding documentation explaining the new MAPv5 packet format
and the corresponding checksum offload header.

Signed-off-by: Sharath Chandra Vurukala <sharathv@codeaurora.org>
---
 .../device_drivers/cellular/qualcomm/rmnet.rst     | 53 ++++++++++++++++++++--
 1 file changed, 49 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/device_drivers/cellular/qualcomm/rmnet.rst b/Documentation/networking/device_drivers/cellular/qualcomm/rmnet.rst
index 70643b5..8c81f19 100644
--- a/Documentation/networking/device_drivers/cellular/qualcomm/rmnet.rst
+++ b/Documentation/networking/device_drivers/cellular/qualcomm/rmnet.rst
@@ -27,7 +27,7 @@ these MAP frames and send them to appropriate PDN's.
 2. Packet format
 ================
 
-a. MAP packet (data / control)
+a. MAP packet v1 (data / control)
 
 MAP header has the same endianness of the IP packet.
 
@@ -35,8 +35,9 @@ Packet format::
 
   Bit             0             1           2-7      8 - 15           16 - 31
   Function   Command / Data   Reserved     Pad   Multiplexer ID    Payload length
-  Bit            32 - x
-  Function     Raw  Bytes
+
+  Bit            32-x
+  Function      Raw bytes
 
 Command (1)/ Data (0) bit value is to indicate if the packet is a MAP command
 or data packet. Control packet is used for transport level flow control. Data
@@ -52,7 +53,51 @@ Multiplexer ID is to indicate the PDN on which data has to be sent.
 Payload length includes the padding length but does not include MAP header
 length.
 
-b. MAP packet (command specific)::
+b. MAP packet v5 (data / control)
+
+MAP header has the same endianness of the IP packet.
+
+Packet format::
+
+  Bit             0             1         2-7      8 - 15           16 - 31
+  Function   Command / Data  Next Header  Pad   Multiplexer ID   Payload length
+
+  Bit            32 - 38        1               40              41-63
+  Function     Header Type    Next Header     Checksum Valid    Reserved
+
+  Bit            64-x
+  Function      Raw bytes
+
+Command (1)/ Data (0) bit value is to indicate if the packet is a MAP command
+or data packet. Control packet is used for transport level flow control. Data
+packets are standard IP packets.
+
+Next header is used to indicate the presence of another header, currently is
+limited to checksum header.
+
+Padding is number of bytes to be added for 4 byte alignment if required by
+hardware.
+
+Multiplexer ID is to indicate the PDN on which data has to be sent.
+
+Payload length includes the padding length but does not include MAP header
+length.
+
+Header Type is to indicate the type of header, this usually is set to CHECKSUM
+
+Header types
+= ==========================================
+0 Reserved
+1 Reserved
+2 checksum header
+
+Checksum Valid is to indicate whether the header checksum is valid. Value of 1
+implies that checksum is calculated on this packet and is valid, value of 0
+indicates that the calculated packet checksum is invalid.
+
+Reserved bits are usually zeroed out and to be ignored by receiver.
+
+c. MAP packet v1/v5 (command specific)::
 
     Bit             0             1           2-7      8 - 15           16 - 31
     Function   Command         Reserved     Pad   Multiplexer ID    Payload length
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

