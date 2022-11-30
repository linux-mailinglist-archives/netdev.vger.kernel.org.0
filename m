Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755EC63DC46
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiK3RoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiK3RoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:44:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419D650D70
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 09:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669830197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=voK5XLV56Q9FI5eyVszeBGUsLnZ4M62G6sR/KUxS2MY=;
        b=h6jFSWVIz2P6NA+ItFXCnCkrMe7+RJ2qg5svIIN8UxztaC/m+CcagJzzpa57AGckSvTWFt
        pVBSYxVHzeQnPZ4nNHSiDrpyMg/tqTz3788k/sUKmj9T544vINzEyTLH+ihqSJ0g/OVXRz
        1G7lq1W9m2EvtXsFJDVF/RUuVNKBQmk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-342-q8qHOwNuNTmF6O-WRn0VWA-1; Wed, 30 Nov 2022 12:43:07 -0500
X-MC-Unique: q8qHOwNuNTmF6O-WRn0VWA-1
Received: by mail-qk1-f197.google.com with SMTP id w14-20020a05620a424e00b006fc46116f7dso39259356qko.12
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 09:43:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=voK5XLV56Q9FI5eyVszeBGUsLnZ4M62G6sR/KUxS2MY=;
        b=q+5uqjbX+MwBzle8vRB20ZMe3Kz+ADQW4uKd0zWFraxGJdjfEQsRvpNoQiKQRaUNXu
         mwNaGfjyyeWVcAzT1V9CnDCPQhbv0DzSuqkcOt81IRKlZPLK+2nIjJ4dDYm2LKc0hU3Q
         18ecduO01HKuAdneQZjFckgU7s0/D7dIsKtgSZuTRmZ0UuqdLFJNelGsdklAlyHhRg6x
         VP6AsMBNwWmIzImglR28Sv8JHfVkV1EukXfV8NnIzGYtNPl+1XlZ84i47ZzAeRvEAcqc
         qZUsiY2EwFe2Vz7+DiuH3pW7LHTRz0nP2p1n2SucDI4jTIXnLUovljrTUmevE/8VSQ0s
         U9sA==
X-Gm-Message-State: ANoB5pmvbErGIvYk6VFwNdXYtlZOUrrOaRCTOqlUGqgeRN396un2YH1m
        b/S7a5fRGxYL4YjNLShe+cDYydiwsu1kowJyVydgT+rbYLyhL8azohmh2tE/Yuan58xmtxSICbZ
        f+7g6tM5ETfHfG72R
X-Received: by 2002:ac8:1416:0:b0:3a5:6822:1a42 with SMTP id k22-20020ac81416000000b003a568221a42mr44920283qtj.174.1669830187016;
        Wed, 30 Nov 2022 09:43:07 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6WAPHf8bd6gCmpsnoP2kOmMN0tOtqukSeMA0xoipZdye6rc5uujfvMb4ufBL+lhjVaLVVJug==
X-Received: by 2002:ac8:1416:0:b0:3a5:6822:1a42 with SMTP id k22-20020ac81416000000b003a568221a42mr44920254qtj.174.1669830186742;
        Wed, 30 Nov 2022 09:43:06 -0800 (PST)
Received: from x1.redhat.com (c-73-214-169-22.hsd1.pa.comcast.net. [73.214.169.22])
        by smtp.gmail.com with ESMTPSA id s18-20020a05620a29d200b006fba0a389a4sm1666087qkp.88.2022.11.30.09.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 09:43:06 -0800 (PST)
From:   Brian Masney <bmasney@redhat.com>
To:     irusskikh@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cth451@gmail.com
Subject: [PATCH] net: atlantic: fix check for invalid ethernet addresses
Date:   Wed, 30 Nov 2022 12:42:59 -0500
Message-Id: <20221130174259.1591567-1-bmasney@redhat.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Qualcomm sa8540p automotive development board (QDrive3) has an
Aquantia NIC wired over PCIe. The ethernet MAC address assigned to
all of the boards in our lab is 00:17:b6:00:00:00. The existing
check in aq_nic_is_valid_ether_addr() only checks for leading zeros
in the MAC address. Let's update the check to also check for trailing
zeros in the MAC address so that a random MAC address is assigned
in this case.

Signed-off-by: Brian Masney <bmasney@redhat.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 06508eebb585..c9c850bbc805 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -293,7 +293,8 @@ static bool aq_nic_is_valid_ether_addr(const u8 *addr)
 	/* Some engineering samples of Aquantia NICs are provisioned with a
 	 * partially populated MAC, which is still invalid.
 	 */
-	return !(addr[0] == 0 && addr[1] == 0 && addr[2] == 0);
+	return !(addr[0] == 0 && addr[1] == 0 && addr[2] == 0) &&
+		!(addr[3] == 0 && addr[4] == 0 && addr[5] == 0);
 }
 
 int aq_nic_ndev_register(struct aq_nic_s *self)
-- 
2.38.1

