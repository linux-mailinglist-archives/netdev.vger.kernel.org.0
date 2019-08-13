Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67B648B1A5
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 09:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbfHMH4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 03:56:01 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:47593 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725981AbfHMH4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 03:56:00 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id B933730D2;
        Tue, 13 Aug 2019 03:55:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 13 Aug 2019 03:55:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=P1rm92h4dBKRE32uuSGa2030s95LDr78Wk1QK+5WDYo=; b=ODOGDIlw
        so8vU6636v3CxlwdEU79xuFcS6XMV3DihWcovxmFqJlVrzlNoPjjMl504OWlogtr
        IkJRA6EIAXpqBqKggRmJnztCaFPT0ENEyuHBEaGPrNE7jzcE8zKlXqQF3O3b56b9
        ynH9vS6xwDHG04Kumz5bSJV//q5BJ1NvDmG2WHxanBjQVodft7qujYU9Nc2+w1Rm
        anpp94hbs9xgrGhkMFOjQsY7hkJZji6TrCD8yBqenhp09WLQ5A/0OK/8bVB7Iz0G
        qLvskpzBaAfGkqfiR6NVAZbVVMOC+y3NY9LGA91v1GvGyGHxjCLP839W6uHr+asg
        S1VWayIMhCplVg==
X-ME-Sender: <xms:D21SXTH1L-mgDVyR70s1SILxAVIF9SWZD4yipUWRZalY1-GO0VLqDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvhedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgepvd
X-ME-Proxy: <xmx:D21SXWJ-Oiyw6u53ZKbmFFqIO6qZL-sM0aq5uGts5niSeNYfkJQszw>
    <xmx:D21SXacVTChKZVoDzCUSEtz1_Cx_0RoQoOYrO3tT2sW5dzBarh1Taw>
    <xmx:D21SXbaHqA5B_VLBVEfzv2lypgIFOIJQNDEI8h6usB1ffuFW0I2GYw>
    <xmx:D21SXfe-p0bNZmmGH6G1r3KD6eJZrQc709U72YcNhkUdkhULU-tLJg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A964F8005C;
        Tue, 13 Aug 2019 03:55:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 04/14] drop_monitor: Consider all monitoring states before performing configuration
Date:   Tue, 13 Aug 2019 10:53:50 +0300
Message-Id: <20190813075400.11841-5-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813075400.11841-1-idosch@idosch.org>
References: <20190813075400.11841-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The drop monitor configuration (e.g., alert mode) is global, but user
will be able to enable monitoring of only software or hardware drops.

Therefore, ensure that monitoring of both software and hardware drops are
disabled before allowing drop monitor configuration to take place.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/drop_monitor.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 6020f34728af..a2c7f9162c9d 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -633,6 +633,11 @@ static int set_all_monitor_traces(int state, struct netlink_ext_ack *extack)
 	return rc;
 }
 
+static bool net_dm_is_monitoring(void)
+{
+	return trace_state == TRACE_ON || monitor_hw;
+}
+
 static int net_dm_alert_mode_get_from_info(struct genl_info *info,
 					   enum net_dm_alert_mode *p_alert_mode)
 {
@@ -694,8 +699,8 @@ static int net_dm_cmd_config(struct sk_buff *skb,
 	struct netlink_ext_ack *extack = info->extack;
 	int rc;
 
-	if (trace_state == TRACE_ON) {
-		NL_SET_ERR_MSG_MOD(extack, "Cannot configure drop monitor while tracing is on");
+	if (net_dm_is_monitoring()) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot configure drop monitor during monitoring");
 		return -EBUSY;
 	}
 
-- 
2.21.0

