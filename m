Return-Path: <netdev+bounces-11838-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 264E1734C2E
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:16:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29BEE1C20939
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 07:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 333836FBE;
	Mon, 19 Jun 2023 07:15:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153FB6ADF
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:15:27 +0000 (UTC)
Received: from mail.avm.de (mail.avm.de [IPv6:2001:bf0:244:244::119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADA71A8
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 00:15:25 -0700 (PDT)
Received: from mail-auth.avm.de (unknown [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Mon, 19 Jun 2023 09:15:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1687158917; bh=spw1yFudJVNbLjJ2XmY8xfK19c3QY7SZsgYE96aOcGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mAI0qzS2tEaShvuJM6ctmYosY5vJGcx3BIJYnQEy2y60v9JopLIKrnB9FbAzlKI7a
	 rfvBw9HkikmoZ2Voe+4D2m8WwraN/QWgQMz1Ns1RzqfJaLsOgCzsWcR8UuC+kzEUo9
	 5TvZbBsrAXRlWyiHlPEe8lWUoUqfZbkrqyhlGzls=
Received: from u-jnixdorf.avm.de (unknown [172.17.88.63])
	by mail-auth.avm.de (Postfix) with ESMTPA id 49456821D3;
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
Subject: [PATCH iproute2-next 1/1] iplink: bridge: Add support for bridge FDB learning limits
Date: Mon, 19 Jun 2023 09:14:44 +0200
Message-Id: <20230619071444.14625-5-jnixdorf-oss@avm.de>
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
X-purgate-ID: 149429::1687158916-21DE33F9-EAA435FC/0/0
X-purgate-type: clean
X-purgate-size: 4612
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Support setting the FDB limit through ip link. The arguments is:
 - fdb_max_learned_entries: A 32-bit unsigned integer specifying the
                            maximum number of learned FDB entries, with 0
                            disabling the limit.

Also support reading back the current number of learned FDB entries in
the bridge by this count. The returned value's name is:
 - fdb_cur_learned_entries: A 32-bit unsigned integer specifying the
                             current number of learned FDB entries.

Example:

 # ip -d -j -p link show br0
[ {
...
        "linkinfo": {
            "info_kind": "bridge",
            "info_data": {
...
                "fdb_cur_learned_entries": 2,
                "fdb_max_learned_entries": 0,
...
            }
        },
...
    } ]
 # ip link set br0 type bridge fdb_max_learned_entries 1024
 # ip -d -j -p link show br0
[ {
...
        "linkinfo": {
            "info_kind": "bridge",
            "info_data": {
...
                "fdb_cur_learned_entries": 2,
                "fdb_max_learned_entries": 1024,
...
            }
        },
...
    } ]

Signed-off-by: Johannes Nixdorf <jnixdorf-oss@avm.de>
---
 include/uapi/linux/if_link.h |  2 ++
 ip/iplink_bridge.c           | 21 +++++++++++++++++++++
 man/man8/ip-link.8.in        |  9 +++++++++
 3 files changed, 32 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 94fb7ef9e226..5ad1e2727e0d 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -508,6 +508,8 @@ enum {
 	IFLA_BR_VLAN_STATS_PER_PORT,
 	IFLA_BR_MULTI_BOOLOPT,
 	IFLA_BR_MCAST_QUERIER_STATE,
+	IFLA_BR_FDB_CUR_LEARNED_ENTRIES,
+	IFLA_BR_FDB_MAX_LEARNED_ENTRIES,
 	__IFLA_BR_MAX,
 };
 
diff --git a/ip/iplink_bridge.c b/ip/iplink_bridge.c
index 7e4e62c81c0c..68ed3c251945 100644
--- a/ip/iplink_bridge.c
+++ b/ip/iplink_bridge.c
@@ -34,6 +34,7 @@ static void print_explain(FILE *f)
 		"		  [ group_fwd_mask MASK ]\n"
 		"		  [ group_address ADDRESS ]\n"
 		"		  [ no_linklocal_learn NO_LINKLOCAL_LEARN ]\n"
+		"		  [ fdb_max_learned_entries FDB_MAX_LEARNED_ENTRIES ]\n"
 		"		  [ vlan_filtering VLAN_FILTERING ]\n"
 		"		  [ vlan_protocol VLAN_PROTOCOL ]\n"
 		"		  [ vlan_default_pvid VLAN_DEFAULT_PVID ]\n"
@@ -168,6 +169,14 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
 				bm.optval |= no_ll_learn_bit;
 			else
 				bm.optval &= ~no_ll_learn_bit;
+		} else if (matches(*argv, "fdb_max_learned_entries") == 0) {
+			__u32 fdb_max_learned_entries;
+
+			NEXT_ARG();
+			if (get_u32(&fdb_max_learned_entries, *argv, 0))
+				invarg("invalid fdb_max_learned_entries", *argv);
+
+			addattr32(n, 1024, IFLA_BR_FDB_MAX_LEARNED_ENTRIES, fdb_max_learned_entries);
 		} else if (matches(*argv, "fdb_flush") == 0) {
 			addattr(n, 1024, IFLA_BR_FDB_FLUSH);
 		} else if (matches(*argv, "vlan_default_pvid") == 0) {
@@ -544,6 +553,18 @@ static void bridge_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 	if (tb[IFLA_BR_GC_TIMER])
 		_bridge_print_timer(f, "gc_timer", tb[IFLA_BR_GC_TIMER]);
 
+	if (tb[IFLA_BR_FDB_CUR_LEARNED_ENTRIES])
+		print_uint(PRINT_ANY,
+			   "fdb_cur_learned_entries",
+			   "fdb_cur_learned_entries %u ",
+			   rta_getattr_u32(tb[IFLA_BR_FDB_CUR_LEARNED_ENTRIES]));
+
+	if (tb[IFLA_BR_FDB_MAX_LEARNED_ENTRIES])
+		print_uint(PRINT_ANY,
+			   "fdb_max_learned_entries",
+			   "fdb_max_learned_entries %u ",
+			   rta_getattr_u32(tb[IFLA_BR_FDB_MAX_LEARNED_ENTRIES]));
+
 	if (tb[IFLA_BR_VLAN_DEFAULT_PVID])
 		print_uint(PRINT_ANY,
 			   "vlan_default_pvid",
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index bf3605a9fa2e..a29595858a51 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -1620,6 +1620,8 @@ the following additional arguments are supported:
 ] [
 .BI no_linklocal_learn " NO_LINKLOCAL_LEARN "
 ] [
+.BI fdb_max_entries " FDB_MAX_ENTRIES "
+] [
 .BI vlan_filtering " VLAN_FILTERING "
 ] [
 .BI vlan_protocol " VLAN_PROTOCOL "
@@ -1731,6 +1733,13 @@ or off
 When disabled, the bridge will not learn from link-local frames (default:
 enabled).
 
+.BI fdb_max_learned_entries " FDB_MAX_LEARNED_ENTRIES "
+- set the maximum number of learned FDB entries linux may create. If
+.RI ( FDB_MAX_LEARNED_ENTRIES " == 0) "
+the feature is disabled.
+.I FDB_MAX_LEARNED_ENTRIES
+is a 32bit unsigned integer.
+
 .BI vlan_filtering " VLAN_FILTERING "
 - turn VLAN filtering on
 .RI ( VLAN_FILTERING " > 0) "
-- 
2.40.1


