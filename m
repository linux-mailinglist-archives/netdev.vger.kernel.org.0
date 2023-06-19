Return-Path: <netdev+bounces-11837-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3FCD734C2D
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:16:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58AAF280FE5
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 07:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2BEB63DB;
	Mon, 19 Jun 2023 07:15:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E785D63DA
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:15:26 +0000 (UTC)
Received: from mail.avm.de (mail.avm.de [IPv6:2001:bf0:244:244::119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BA11A4
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 00:15:25 -0700 (PDT)
Received: from mail-auth.avm.de (unknown [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Mon, 19 Jun 2023 09:15:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1687158917; bh=qdpfcwYJozREfwO7wJNLhMCU7PvcwSIQgOBak+A3XJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJXRGuwLpufvyO35rY7eiPTeWucD3UIqOIZF7OLPG+6A9/2CYXequAkMHnKARmVkl
	 4qB6wRHhAXle0ZR2kpEg8KgX/V1W1Hy303tnJHQ7yNrD5Xd4T+kxERlEZJShny2tJM
	 pAu6B/MqCEHzFkvz0wvfdKS/gpM9KYjfVa6p5Jt4=
Received: from u-jnixdorf.avm.de (unknown [172.17.88.63])
	by mail-auth.avm.de (Postfix) with ESMTPA id 3999C81EDA;
	Mon, 19 Jun 2023 09:15:16 +0200 (CEST)
From: Johannes Nixdorf <jnixdorf-oss@avm.de>
To: bridge@lists.linux-foundation.org
Cc: netdev@vger.kernel.org,
	David Ahern <dsahern@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Johannes Nixdorf <jnixdorf-oss@avm.de>
Subject: [PATCH net-next v2 3/3] net: bridge: Add a configurable default FDB learning limit
Date: Mon, 19 Jun 2023 09:14:43 +0200
Message-Id: <20230619071444.14625-4-jnixdorf-oss@avm.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230619071444.14625-1-jnixdorf-oss@avm.de>
References: <20230619071444.14625-1-jnixdorf-oss@avm.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-purgate-ID: 149429::1687158916-20DED3F9-83200A2B/0/0
X-purgate-type: clean
X-purgate-size: 1673
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This adds a Kconfig option to configure a default FDB learning limit
system wide, so a distributor building a special purpose kernel can
limit all created bridges by default.

The limit is only a soft default setting and overridable per bridge
using netlink.

Signed-off-by: Johannes Nixdorf <jnixdorf-oss@avm.de>

---

Changes since v1:
 - Added a default limit in Kconfig. (deemed acceptable in review
   comments)

 net/bridge/Kconfig     | 13 +++++++++++++
 net/bridge/br_device.c |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/net/bridge/Kconfig b/net/bridge/Kconfig
index 3c8ded7d3e84..c0d9c08088c4 100644
--- a/net/bridge/Kconfig
+++ b/net/bridge/Kconfig
@@ -84,3 +84,16 @@ config BRIDGE_CFM
 	  Say N to exclude this support and reduce the binary size.
 
 	  If unsure, say N.
+
+config BRIDGE_DEFAULT_FDB_MAX_LEARNED
+	int "Default FDB learning limit"
+	default 0
+	depends on BRIDGE
+	help
+	  Sets a default limit on the number of learned FDB entries on
+	  new bridges. This limit can be overwritten via netlink on a
+	  per bridge basis.
+
+	  The default of 0 disables the limit.
+
+	  If unsure, say 0.
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 8eca8a5c80c6..93f081ce8195 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -530,6 +530,8 @@ void br_dev_setup(struct net_device *dev)
 	br->bridge_ageing_time = br->ageing_time = BR_DEFAULT_AGEING_TIME;
 	dev->max_mtu = ETH_MAX_MTU;
 
+	br->fdb_max_learned_entries = CONFIG_BRIDGE_DEFAULT_FDB_MAX_LEARNED;
+
 	br_netfilter_rtable_init(br);
 	br_stp_timer_init(br);
 	br_multicast_init(br);
-- 
2.40.1


