Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCC38139546
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 16:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgAMPxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 10:53:14 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41254 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728801AbgAMPxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 10:53:13 -0500
Received: by mail-lf1-f67.google.com with SMTP id m30so7215448lfp.8
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 07:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PRyqckMelSpsU5GT1G5t3lfW5edpIQYUQ5mkpJoZLoc=;
        b=B3RI9S6ux6Bz7F3Z6iJdMne3JGNiJyN/Cf1wlSsDYcpxEHzR2ennhEmVqawknl8aFL
         p7nlAc9947MP654THkWj7oO8m1jXCVZjjUoktDd9VdqrlWXSCfTAktvPkhCBzQ36JEpe
         AJTLaT4IhzNlc0tO2hrw2WkZDnaSnQOoCAYC0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PRyqckMelSpsU5GT1G5t3lfW5edpIQYUQ5mkpJoZLoc=;
        b=S7+TGPOVsnjFdXp4J/+aI5T19gKBDnGzofB8DZ/tlJ3WGOcKhbh2bDfwjbuG746WHX
         SDhnnTM8fggHTMv6dAaB2nP+sDllcHS0aZKEuT2kErInEUsyScPyWSlCH2EQeFPPRBmm
         lGFFsBboS3LFv/fkN1udFyc1VS98j45Rn3mZwXVnqgS+/WK8Eax+UxZC6hErbfnM5SHR
         AmSZfvcbkNGglT0UfcZLp5eaFtrfEaUpZ54oJqNp9BIfPEe4EoI0Z6/TKReqyblpdA7b
         JEt3zQ3vibvtMHtkU9QcgWBIfA1x/7xygkoj/znqPlCrM8TVmLisrN5U3ccBGh3TgVFL
         yRmQ==
X-Gm-Message-State: APjAAAUFsb5S8nJyIandt20LJ3WB/US1pHoON+AosIGIlwsv0BxccD+R
        Gs5jbvr8jcd6XvEmWL6125Il6+6GY5w=
X-Google-Smtp-Source: APXvYqy7OgenELfveYV0yNpAN8onaC/V7cTEBIy4m7VmDX2ffCKIx3xe6I/Q5UTTJ8OTc/Pt3egUTw==
X-Received: by 2002:a19:ae18:: with SMTP id f24mr10001955lfc.155.1578930790551;
        Mon, 13 Jan 2020 07:53:10 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id e20sm6175658ljl.59.2020.01.13.07.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 07:53:09 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 5/8] net: bridge: vlan: add del rtm message support
Date:   Mon, 13 Jan 2020 17:52:30 +0200
Message-Id: <20200113155233.20771-6-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
References: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding RTM_DELVLAN support similar to RTM_NEWVLAN is simple, just need to
map DELVLAN to DELLINK and register the handler.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_vlan.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index b8f52a7616c4..bd75cee48ad3 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1698,6 +1698,9 @@ static int br_vlan_rtm_process_one(struct net_device *dev,
 	case RTM_NEWVLAN:
 		cmdmap = RTM_SETLINK;
 		break;
+	case RTM_DELVLAN:
+		cmdmap = RTM_DELLINK;
+		break;
 	}
 
 	err = br_process_vlan_info(br, p, cmdmap, vinfo, &vinfo_last, &changed,
@@ -1757,10 +1760,13 @@ void br_vlan_rtnl_init(void)
 			     br_vlan_rtm_dump, 0);
 	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_NEWVLAN,
 			     br_vlan_rtm_process, NULL, 0);
+	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_DELVLAN,
+			     br_vlan_rtm_process, NULL, 0);
 }
 
 void br_vlan_rtnl_uninit(void)
 {
 	rtnl_unregister(PF_BRIDGE, RTM_GETVLAN);
 	rtnl_unregister(PF_BRIDGE, RTM_NEWVLAN);
+	rtnl_unregister(PF_BRIDGE, RTM_DELVLAN);
 }
-- 
2.21.0

