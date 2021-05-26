Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAD2391AD6
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 16:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235179AbhEZO46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 10:56:58 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:55950 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235174AbhEZO44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 10:56:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622040925; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=P3GpVn3JVfMxDzrwZHRnbaDau1jXLxyfxJ/Pq0LMuzc=; b=Orv9q22G6SW+8mBqp75tmi3MTPEo6sQDQS8WTf5anxRjMxIbaEIffF7Pj1hpS9vWFocJjwJu
 HPjVIs/HIQkXbBhb0Nwe+5ddaCusLpEK1Z0lSHeZ/HKoWQ5w2lUAfkacTWd7hVMRpitEtPrZ
 rojrHcK571Adz86A16ZAOP/iP5Y=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 60ae614c2bff04e53b103c65 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 26 May 2021 14:55:08
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 80C00C43143; Wed, 26 May 2021 14:55:08 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from svurukal-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A70EBC4338A;
        Wed, 26 May 2021 14:55:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A70EBC4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sharathv@codeaurora.org
From:   Sharath Chandra Vurukala <sharathv@codeaurora.org>
To:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Subject: [PATCH net-next v6 1/3] docs: networking: Add documentation for MAPv5
Date:   Wed, 26 May 2021 20:24:40 +0530
Message-Id: <1622040882-27526-2-git-send-email-sharathv@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1622040882-27526-1-git-send-email-sharathv@codeaurora.org>
References: <1622040882-27526-1-git-send-email-sharathv@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding documentation explaining the new MAPv4/v5 packet formats
and the corresponding checksum offload headers.

Signed-off-by: Sharath Chandra Vurukala <sharathv@codeaurora.org>
---
 .../device_drivers/cellular/qualcomm/rmnet.rst     | 126 +++++++++++++++++++--
 1 file changed, 114 insertions(+), 12 deletions(-)

diff --git a/Documentation/networking/device_drivers/cellular/qualcomm/rmnet.rst b/Documentation/networking/device_drivers/cellular/qualcomm/rmnet.rst
index 70643b5..4118384 100644
--- a/Documentation/networking/device_drivers/cellular/qualcomm/rmnet.rst
+++ b/Documentation/networking/device_drivers/cellular/qualcomm/rmnet.rst
@@ -27,34 +27,136 @@ these MAP frames and send them to appropriate PDN's.
 2. Packet format
 ================
 
-a. MAP packet (data / control)
+a. MAP packet v1 (data / control)
 
-MAP header has the same endianness of the IP packet.
+MAP header fields are in big endian format.
 
 Packet format::
 
-  Bit             0             1           2-7      8 - 15           16 - 31
+  Bit             0             1           2-7      8-15           16-31
   Function   Command / Data   Reserved     Pad   Multiplexer ID    Payload length
-  Bit            32 - x
-  Function     Raw  Bytes
+
+  Bit            32-x
+  Function      Raw bytes
 
 Command (1)/ Data (0) bit value is to indicate if the packet is a MAP command
-or data packet. Control packet is used for transport level flow control. Data
+or data packet. Command packet is used for transport level flow control. Data
 packets are standard IP packets.
 
-Reserved bits are usually zeroed out and to be ignored by receiver.
+Reserved bits must be zero when sent and ignored when received.
 
-Padding is number of bytes to be added for 4 byte alignment if required by
-hardware.
+Padding is the number of bytes to be appended to the payload to
+ensure 4 byte alignment.
 
 Multiplexer ID is to indicate the PDN on which data has to be sent.
 
 Payload length includes the padding length but does not include MAP header
 length.
 
-b. MAP packet (command specific)::
+b. Map packet v4 (data / control)
+
+MAP header fields are in big endian format.
+
+Packet format::
+
+  Bit             0             1           2-7      8-15           16-31
+  Function   Command / Data   Reserved     Pad   Multiplexer ID    Payload length
+
+  Bit            32-(x-33)      (x-32)-x
+  Function      Raw bytes      Checksum offload header
+
+Command (1)/ Data (0) bit value is to indicate if the packet is a MAP command
+or data packet. Command packet is used for transport level flow control. Data
+packets are standard IP packets.
+
+Reserved bits must be zero when sent and ignored when received.
+
+Padding is the number of bytes to be appended to the payload to
+ensure 4 byte alignment.
+
+Multiplexer ID is to indicate the PDN on which data has to be sent.
+
+Payload length includes the padding length but does not include MAP header
+length.
+
+Checksum offload header, has the information about the checksum processing done
+by the hardware.Checksum offload header fields are in big endian format.
+
+Packet format::
+
+  Bit             0-14        15              16-31
+  Function      Reserved   Valid     Checksum start offset
+
+  Bit                31-47                    48-64
+  Function      Checksum length           Checksum value
+
+Reserved bits must be zero when sent and ignored when received.
+
+Valid bit indicates whether the partial checksum is calculated and is valid.
+Set to 1, if its is valid. Set to 0 otherwise.
+
+Padding is the number of bytes to be appended to the payload to
+ensure 4 byte alignment.
+
+Checksum start offset, Indicates the offset in bytes from the beginning of the
+IP header, from which modem computed checksum.
+
+Checksum length is the Length in bytes starting from CKSUM_START_OFFSET,
+over which checksum is computed.
+
+Checksum value, indicates the checksum computed.
+
+c. MAP packet v5 (data / control)
+
+MAP header fields are in big endian format.
+
+Packet format::
+
+  Bit             0             1         2-7      8-15           16-31
+  Function   Command / Data  Next header  Pad   Multiplexer ID   Payload length
+
+  Bit            32-x
+  Function      Raw bytes
+
+Command (1)/ Data (0) bit value is to indicate if the packet is a MAP command
+or data packet. Command packet is used for transport level flow control. Data
+packets are standard IP packets.
+
+Next header is used to indicate the presence of another header, currently is
+limited to checksum header.
+
+Padding is the number of bytes to be appended to the payload to
+ensure 4 byte alignment.
+
+Multiplexer ID is to indicate the PDN on which data has to be sent.
+
+Payload length includes the padding length but does not include MAP header
+length.
+
+d. Checksum offload header v5
+
+Checksum offload header fields are in big endian format.
+
+  Bit            0 - 6          7               8-15              16-31
+  Function     Header Type    Next Header     Checksum Valid    Reserved
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
+Reserved bits must be zero when sent and ignored when received.
+
+e. MAP packet v1/v5 (command specific)::
 
-    Bit             0             1           2-7      8 - 15           16 - 31
+    Bit             0             1         2-7      8 - 15           16 - 31
     Function   Command         Reserved     Pad   Multiplexer ID    Payload length
     Bit          32 - 39        40 - 45    46 - 47       48 - 63
     Function   Command name    Reserved   Command Type   Reserved
@@ -74,7 +176,7 @@ Command types
 3 is for error during processing of commands
 = ==========================================
 
-c. Aggregation
+f. Aggregation
 
 Aggregation is multiple MAP packets (can be data or command) delivered to
 rmnet in a single linear skb. rmnet will process the individual
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

