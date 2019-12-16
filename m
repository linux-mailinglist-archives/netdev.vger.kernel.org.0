Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D19A711FE8B
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 07:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfLPGoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 01:44:16 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39265 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbfLPGoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 01:44:14 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so5046439pfx.6
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 22:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/5SAJnBSaAMbrMeiwHHdUv3nEKIBfgV3gh2nbG82OwQ=;
        b=HebtQASz86gIgD+gpW6Tnz8PfRygnyRXtq96sOuKnqbW8FGnJmvIV6joXYQpqpNxAh
         9KPu3okbT1a9J1QTv+9YhpeLqqOtQOeBKuaG0JRxH5P1CpibvNhT/Jt42cxoqXiKB/nm
         uQOcxOBOqoS9FgmMnixcCklsG8fB5w/JHyFZ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/5SAJnBSaAMbrMeiwHHdUv3nEKIBfgV3gh2nbG82OwQ=;
        b=EvGPlThwzXdzteXDYNS95ubiaKemc5MJLEL0XLWcyv1d9YGO5pQJorSmRfZ2T6XZFs
         jQdacuLDzBbzSxsK9ZJWJp1zeQVqx5P8aQZYNyx2jwGO2jFkKiWkXEE8z/66yxHfCzdM
         Ol5kHGHd5t6aBFjxLKxofLxN5Tna/NyU6YHqVcae3m7dCijFdZk3FxUsr8/HcOsnkpNV
         LNeXZZCn4rPMqw6Gy3Bkz7wcBBNNmtsit7Gn03GEwlGR2kSpKaixbWKYO/5ZTonVarJk
         V7uRL/WaMZArQFhy7hWZQnUl3MFfZsJl5ptJqpm2rg/z542U0BUCRuRAcZHdqrMPU+kv
         3+Vg==
X-Gm-Message-State: APjAAAXD2al6FlR75Q00GfnQdqryQi4GkKaCMRdsae1gyQz8KsbGT+5L
        RobgTLONvdrGi57wyPuH15Uuq7EQnYg=
X-Google-Smtp-Source: APXvYqzhpVcSuoUi1pRVdkRncx+optrQAaxMQ0f2V1aJavx/sjdfATZPruN93j/DBOkeMzXU2CoBgg==
X-Received: by 2002:a65:58ce:: with SMTP id e14mr16331345pgu.153.1576478653375;
        Sun, 15 Dec 2019 22:44:13 -0800 (PST)
Received: from f3.synalogic.ca (ag061063.dynamic.ppp.asahi-net.or.jp. [157.107.61.63])
        by smtp.gmail.com with ESMTPSA id y62sm21881502pfg.45.2019.12.15.22.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 22:44:12 -0800 (PST)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [PATCH iproute2 5/8] bridge: Fix BRIDGE_VLAN_TUNNEL attribute sizes
Date:   Mon, 16 Dec 2019 15:43:41 +0900
Message-Id: <20191216064344.1470824-6-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
References: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per the kernel's vlan_tunnel_policy, IFLA_BRIDGE_VLAN_TUNNEL_VID and
IFLA_BRIDGE_VLAN_TUNNEL_FLAGS have type NLA_U16.

Fixes: 8652eeb3ab12 ("bridge: vlan: support for per vlan tunnel info")
Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 bridge/vlan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 6dc694b6..c0294aa6 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -71,8 +71,8 @@ static int add_tunnel_info(struct nlmsghdr *n, int reqsize,
 
 	tinfo = addattr_nest(n, reqsize, IFLA_BRIDGE_VLAN_TUNNEL_INFO);
 	addattr32(n, reqsize, IFLA_BRIDGE_VLAN_TUNNEL_ID, tun_id);
-	addattr32(n, reqsize, IFLA_BRIDGE_VLAN_TUNNEL_VID, vid);
-	addattr32(n, reqsize, IFLA_BRIDGE_VLAN_TUNNEL_FLAGS, flags);
+	addattr16(n, reqsize, IFLA_BRIDGE_VLAN_TUNNEL_VID, vid);
+	addattr16(n, reqsize, IFLA_BRIDGE_VLAN_TUNNEL_FLAGS, flags);
 
 	addattr_nest_end(n, tinfo);
 
@@ -304,7 +304,7 @@ static void print_vlan_tunnel_info(FILE *fp, struct rtattr *tb, int ifindex)
 
 		if (ttb[IFLA_BRIDGE_VLAN_TUNNEL_VID])
 			tunnel_vid =
-				rta_getattr_u32(ttb[IFLA_BRIDGE_VLAN_TUNNEL_VID]);
+				rta_getattr_u16(ttb[IFLA_BRIDGE_VLAN_TUNNEL_VID]);
 		else
 			continue;
 
@@ -314,7 +314,7 @@ static void print_vlan_tunnel_info(FILE *fp, struct rtattr *tb, int ifindex)
 
 		if (ttb[IFLA_BRIDGE_VLAN_TUNNEL_FLAGS])
 			tunnel_flags =
-				rta_getattr_u32(ttb[IFLA_BRIDGE_VLAN_TUNNEL_FLAGS]);
+				rta_getattr_u16(ttb[IFLA_BRIDGE_VLAN_TUNNEL_FLAGS]);
 
 		if (!(tunnel_flags & BRIDGE_VLAN_INFO_RANGE_END)) {
 			last_vid_start = tunnel_vid;
-- 
2.24.0

