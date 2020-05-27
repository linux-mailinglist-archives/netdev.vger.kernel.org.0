Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116881E3E2D
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 11:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbgE0J5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 05:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729645AbgE0J5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 05:57:06 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96F1C061A0F;
        Wed, 27 May 2020 02:57:05 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id w10so28201630ljo.0;
        Wed, 27 May 2020 02:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jTJhwZSJoyE8wrAnL4MnSgyDxfzg5z5BsSA6iH2Lsr4=;
        b=I/UHm7IDoWtRiKnycgBMtf56gDPpQrztOCVzmZO2cu1mUG+xbHnZbehIc1PDMmyz2n
         ipHj41QkegdeoTMWOWO8A6VHn6DgveZ+lAyiYeWBzJwwAJyejmudwu2WGe8gCh5IVzc3
         1tKpxNl5f9WCa13bPo4T65791GJSXC/SLHR8I78o73aZz0NGRMDY7Q4nDrao3SbnYWab
         22zuvOQfGaK6eLadMZWrEWgajDmWY2ercb6vreHeixQnjC3KhxLd14NRXL+VfPv0Ohs1
         NUxbcl0X0BmOQEI9cmhoNatcks3sc6LYGr+s9bibIJhB3CMQnyDQ3+O3cjiVeOey3lDf
         erkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jTJhwZSJoyE8wrAnL4MnSgyDxfzg5z5BsSA6iH2Lsr4=;
        b=dpqBOopuoD/IQqfwZUGyYyGUOIWFuNOPe39CI54DdeXYlFFcg+o71PA4/dxUoRGVcH
         BXOgIKNp/Ca/KICuwLiaM6/UQQ2j4HjPlM2yyobmz8SAODHMPtdPrS7n1JygI2t96Nkr
         VOiC8cQ8Ruc4XFRfoQIXNQHAVE6t+dS+JJ0Jjcfv94pk52rj7+9M6MNAb8+TEsOC326q
         uu8pGpywTmgsqXVFvJdf1y50nsinl2bOWZR1bnNjUuGe23+rwVbq0PdhWjHOBTGauA8J
         foiXRfvHubfyyNRcTyuYWm+YGEYh8MJIJfwVA7dOi+/RiWrhCTQvxIQrSJvCgpTbP75M
         0YvA==
X-Gm-Message-State: AOAM530U11RvQhCaXewIWXoyrWWXF7mIeFqojG2/PiUnmZ6u/KSvzxLk
        Ebv4bEUuF4qnXS1kGWJo1+k=
X-Google-Smtp-Source: ABdhPJzw5Z55iO0cTtVwUE5LkxageVrap6NYxPm2ll+URyAOP+9OobfaJ3meIyFBdtMHyQPG0lpeFg==
X-Received: by 2002:a2e:9a0d:: with SMTP id o13mr2430084lji.15.1590573424447;
        Wed, 27 May 2020 02:57:04 -0700 (PDT)
Received: from bitter.drabanten.lan ([195.178.180.206])
        by smtp.gmail.com with ESMTPSA id s8sm700499lfc.83.2020.05.27.02.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 02:57:03 -0700 (PDT)
From:   Jonas Falkevik <jonas.falkevik@gmail.com>
To:     marcelo.leitner@gmail.com, lucien.xin@gmail.com,
        nhorman@tuxdriver.com, vyasevich@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jonas Falkevik <jonas.falkevik@gmail.com>
Subject: [PATCH v2] sctp: check assoc before SCTP_ADDR_{MADE_PRIM,ADDED} event
Date:   Wed, 27 May 2020 11:56:40 +0200
Message-Id: <20200527095640.270986-1-jonas.falkevik@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure SCTP_ADDR_{MADE_PRIM,ADDED} are sent only for associations
that have been established.

These events are described in rfc6458#section-6.1
SCTP_PEER_ADDR_CHANGE:
This tag indicates that an address that is
part of an existing association has experienced a change of
state (e.g., a failure or return to service of the reachability
of an endpoint via a specific transport address).

Signed-off-by: Jonas Falkevik <jonas.falkevik@gmail.com>
---
Changes in v2:
 - Check asoc state to be at least established.
   Instead of associd being SCTP_FUTURE_ASSOC.
 - Common check for all peer addr change event

 net/sctp/ulpevent.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index c82dbdcf13f2..77d5c36a8991 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -343,6 +343,9 @@ void sctp_ulpevent_nofity_peer_addr_change(struct sctp_transport *transport,
 	struct sockaddr_storage addr;
 	struct sctp_ulpevent *event;
 
+	if (asoc->state < SCTP_STATE_ESTABLISHED)
+		return;
+
 	memset(&addr, 0, sizeof(struct sockaddr_storage));
 	memcpy(&addr, &transport->ipaddr, transport->af_specific->sockaddr_len);
 
-- 
2.25.4

