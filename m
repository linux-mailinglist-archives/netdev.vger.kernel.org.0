Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC6B4F77FC
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238667AbiDGHrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242099AbiDGHrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:47:09 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8794BA205E
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:45:08 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k14so4339094pga.0
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 00:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KzsrWt8j76/wUQw6959z+QyLT3qqPlObCP7Fz9z/YWg=;
        b=aWZ0k12VGSGltoZCBcUscb9hH8BE31RogvBmbswhcokyKn82bGhYXOTgPtgUB3aosY
         jEZsgKKTsgs2Dzmy8i8H7IJ1Ts0hl6P1fEAVBZTMKbSEGDYBZYecNdvGdQ5KHZ7D60nb
         ZU04569AaAJh3qISde5BdYOInbfWVJmqeq2iZnfgaEw/rXplILhFHS9vC6gKW6cPbn0g
         75uG2jLifZ/rDfHX9XUEAxSYBIb9KS35fVqujTmzb3LEgiW655jJ6UdnwXRJLQAK4lmN
         Kx63PyBIcaGxoZvVChWvTBG8vyBV0YPCHFfItmu1TscpvgPfLEV4ZYS9xah4kU1OCCKL
         vrkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KzsrWt8j76/wUQw6959z+QyLT3qqPlObCP7Fz9z/YWg=;
        b=GcQWrGbUIiumswsdzyNldzfflK1Deeam5ROVdGOgAY4pXeyQDNEojQ89Monz+Mz6Gm
         F5TBRrjjcth0lH/v2XOBwrhQqegYT8XcA8vz4/c4sZ3z+6A+KdfWB4lrm0wR+mm0/4gY
         tPegV7j1qgeKYylm0CXIG+a2Eta+9b/1TkfaijAiNQReIGY3faf5ptgFydNMhfTFVT7p
         E4u+L9Aya/PPxMEBnDzxQJIFVbc4aIJEIlacZR9Muu+8Mz0S18JGMxaGoyX5UCGfBWuR
         7J41ylIdRWcj78iGBfH1PGPuuxbn5vhlkSwVQlASHwViO650zuDSnW2Mp/coBUwvQbAI
         ToRw==
X-Gm-Message-State: AOAM5303zmLB1eo+tH1PY4QqWDppsUzS9NV7cHXNh6GsYVwv9QdJyzx3
        HR5cIpgQbCe2uxPym0onJGeyRquaSCoJgMvO
X-Google-Smtp-Source: ABdhPJxPZxqzh3ftTit3YDkR8+rA6lXGJptX47km4U9G6HKIfJ1WftNq5lzv57CFUh7WgIMQHx50XQ==
X-Received: by 2002:a63:6443:0:b0:399:54fe:5184 with SMTP id y64-20020a636443000000b0039954fe5184mr10282377pgb.511.1649317507376;
        Thu, 07 Apr 2022 00:45:07 -0700 (PDT)
Received: from localhost.localdomain ([49.37.166.144])
        by smtp.gmail.com with ESMTPSA id j18-20020a633c12000000b0038204629cc9sm17860802pga.10.2022.04.07.00.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 00:45:05 -0700 (PDT)
From:   Arun Ajith S <aajith@arista.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, prestwoj@gmail.com, gilligan@arista.com,
        noureddine@arista.com, gk@arista.com, aajith@arista.com
Subject: [PATCH net-next v2] net/ipv6: Introduce accept_unsolicited_na knob to implement router-side changes for RFC9131
Date:   Thu,  7 Apr 2022 07:44:28 +0000
Message-Id: <20220407074428.1623-1-aajith@arista.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new neighbour cache entry in STALE state for routers on receiving
an unsolicited (gratuitous) neighbour advertisement with
target link-layer-address option specified.
This is similar to the arp_accept configuration for IPv4.
A new sysctl endpoint is created to turn on this behaviour:
/proc/sys/net/ipv6/conf/interface/accept_unsolicited_na.

Signed-off-by: Arun Ajith S <aajith@arista.com>
Tested-by: Arun Ajith S <aajith@arista.com>
---
 Documentation/networking/ip-sysctl.rst | 23 +++++++++++++++++++++++
 include/linux/ipv6.h                   |  1 +
 include/uapi/linux/ipv6.h              |  1 +
 net/ipv6/addrconf.c                    |  8 ++++++++
 net/ipv6/ndisc.c                       | 20 +++++++++++++++++++-
 5 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index b0024aa7b051..9e17efe343ac 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2467,6 +2467,29 @@ drop_unsolicited_na - BOOLEAN
 
 	By default this is turned off.
 
+accept_unsolicited_na - BOOLEAN
+	Add a new neighbour cache entry in STALE state for routers on receiving an
+	unsolicited neighbour advertisement with target link-layer address option
+	specified. This is as per router-side behavior documented in RFC9131.
+	This has lower precedence than drop_unsolicited_na.
+	 drop   accept  fwding                   behaviour
+	 ----   ------  ------  ----------------------------------------------
+	    1        X       X  Drop NA packet and don't pass up the stack
+	    0        0       X  Pass NA packet up the stack, don't update NC
+	    0        1       0  Pass NA packet up the stack, don't update NC
+	    0        1       1  Pass NA packet up the stack, and add a STALE
+	                          NC entry
+	This will optimize the return path for the initial off-link communication
+	that is initiated by a directly connected host, by ensuring that
+	the first-hop router which turns on this setting doesn't have to
+	buffer the initial return packets to do neighbour-solicitation.
+	The prerequisite is that the host is configured to send
+	unsolicited neighbour advertisements on interface bringup.
+	This setting should be used in conjunction with the ndisc_notify setting
+	on the host to satisfy this prerequisite.
+
+	By default this is turned off.
+
 enhanced_dad - BOOLEAN
 	Include a nonce option in the IPv6 neighbor solicitation messages used for
 	duplicate address detection per RFC7527. A received DAD NS will only signal
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 16870f86c74d..918bfea4ef5f 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -61,6 +61,7 @@ struct ipv6_devconf {
 	__s32		suppress_frag_ndisc;
 	__s32		accept_ra_mtu;
 	__s32		drop_unsolicited_na;
+	__s32		accept_unsolicited_na;
 	struct ipv6_stable_secret {
 		bool initialized;
 		struct in6_addr secret;
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index d4178dace0bf..549ddeaf788b 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -194,6 +194,7 @@ enum {
 	DEVCONF_IOAM6_ID,
 	DEVCONF_IOAM6_ID_WIDE,
 	DEVCONF_NDISC_EVICT_NOCARRIER,
+	DEVCONF_ACCEPT_UNSOLICITED_NA,
 	DEVCONF_MAX
 };
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 1afc4c024981..1b4d278d0454 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5587,6 +5587,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_IOAM6_ID] = cnf->ioam6_id;
 	array[DEVCONF_IOAM6_ID_WIDE] = cnf->ioam6_id_wide;
 	array[DEVCONF_NDISC_EVICT_NOCARRIER] = cnf->ndisc_evict_nocarrier;
+	array[DEVCONF_ACCEPT_UNSOLICITED_NA] = cnf->accept_unsolicited_na;
 }
 
 static inline size_t inet6_ifla6_size(void)
@@ -7037,6 +7038,13 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.extra1		= (void *)SYSCTL_ZERO,
 		.extra2		= (void *)SYSCTL_ONE,
 	},
+	{
+		.procname	= "accept_unsolicited_na",
+		.data		= &ipv6_devconf.accept_unsolicited_na,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{
 		/* sentinel */
 	}
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index fcb288b0ae13..254addad0dd3 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -979,6 +979,7 @@ static void ndisc_recv_na(struct sk_buff *skb)
 	struct inet6_dev *idev = __in6_dev_get(dev);
 	struct inet6_ifaddr *ifp;
 	struct neighbour *neigh;
+	bool create_neigh;
 
 	if (skb->len < sizeof(struct nd_msg)) {
 		ND_PRINTK(2, warn, "NA: packet too short\n");
@@ -999,6 +1000,7 @@ static void ndisc_recv_na(struct sk_buff *skb)
 	/* For some 802.11 wireless deployments (and possibly other networks),
 	 * there will be a NA proxy and unsolicitd packets are attacks
 	 * and thus should not be accepted.
+	 * drop_unsolicited_na takes precedence over accept_unsolicited_na
 	 */
 	if (!msg->icmph.icmp6_solicited && idev &&
 	    idev->cnf.drop_unsolicited_na)
@@ -1039,7 +1041,23 @@ static void ndisc_recv_na(struct sk_buff *skb)
 		in6_ifa_put(ifp);
 		return;
 	}
-	neigh = neigh_lookup(&nd_tbl, &msg->target, dev);
+	/* RFC 9131 updates original Neighbour Discovery RFC 4861.
+	 * An unsolicited NA can now create a neighbour cache entry
+	 * on routers if it has Target LL Address option.
+	 *
+	 * drop   accept  fwding                   behaviour
+	 * ----   ------  ------  ----------------------------------------------
+	 *    1        X       X  Drop NA packet and don't pass up the stack
+	 *    0        0       X  Pass NA packet up the stack, don't update NC
+	 *    0        1       0  Pass NA packet up the stack, don't update NC
+	 *    0        1       1  Pass NA packet up the stack, and add a STALE
+	 *                          NC entry
+	 * Note that we don't do a (daddr == all-routers-mcast) check.
+	 */
+	create_neigh = !msg->icmph.icmp6_solicited && lladdr &&
+		       idev && idev->cnf.forwarding &&
+		       idev->cnf.accept_unsolicited_na;
+	neigh = __neigh_lookup(&nd_tbl, &msg->target, dev, create_neigh);
 
 	if (neigh) {
 		u8 old_flags = neigh->flags;
-- 
2.27.0
---
Changes from v1:
- Change bad documentation and commit description. (source link-layer-address option -> target link-layer-address option)
- CCed all maintainers from .scripts/get_maintainer.pl
- Rebased to latest origin/master
