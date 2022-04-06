Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D97174F6051
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbiDFNew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbiDFNeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:34:31 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CE32E1971
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 21:24:24 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id bx5so1412134pjb.3
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 21:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EeYSfZ5xH+IlAcJ+xTcG79IheqB96eU+egCEaXP6x+E=;
        b=AHF1rXqXob8GH6Q42EmoIPDa3FIN/ShW5cryQ1NF5CsnI3Q4IBqEluwLsG6COLPDx0
         Z3SWGnP4ihH7x8YNVj62yYfO/96aZU1+aPoiUYoyc1wtms/QghNZFvN1KvjESswg8R2y
         ZQ1Bqo3CjtDWo0i3JnzVofQ3E0Ldc26N4vNQhVuTq++0u02l+131z6Vr9gQXIBGSmEeg
         Hykj0SsCvX1UZh9VrWSUeejNNeT6m2/JJx+vx00vsGB7nmgeX0TCZVIbjdYLk7ANs7oO
         GelNP2wxknJhqLGogdUwWbHfeTPsYaPkfdbjig+bKUNEuOXbK621hVR7CMejpJ8ViiBo
         e3WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EeYSfZ5xH+IlAcJ+xTcG79IheqB96eU+egCEaXP6x+E=;
        b=mjLSpxRkTIfXA6cU63eYQ/LsKqATi6z+4oAn3oSn8bPZtSSAUyPArBNFihD0arFkLL
         eSmfztqCvOd+7rQa97xxaYa+Wae9KGv6LI4RriTBktU4sqrn6fsmhWQ4mqOjwVbN35ni
         PI6PLvzIYsUETC5bTAWJrTGdhVF4qF7ddRdAQkvRIPdsC6yqKeNa/pttVOaam96tnW24
         6iJASNR8dY2R7nz2gdiHGEKT+hVU4PAnQdpnHBRUm9m1RBW9EVWb2OKFkuwkvE7CjY6I
         YeT1WzUxHAbSPr/KMWDLmgpB3GU6OleJehCclxKNMZio33WCzHwyAAoUh2frV7y9tibW
         +ukw==
X-Gm-Message-State: AOAM5327wyMbrUFQm9ofTxRdsxW9Ssqw7Xk3oAbvmLBCkohXVERbblPD
        6tAKyVzl0xYNbrQ2eMcwhwerflx3VrnHSw==
X-Google-Smtp-Source: ABdhPJxtDZ3YxYOmx1j8+U4YCNNKFsjDW1w53GcKKllZ/RrkFc1eKLttBEbYltHxtMDJirkkE7liRQ==
X-Received: by 2002:a17:90b:4a01:b0:1c9:a552:f487 with SMTP id kk1-20020a17090b4a0100b001c9a552f487mr8001917pjb.68.1649219063598;
        Tue, 05 Apr 2022 21:24:23 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:d008:8bfd:2c57:ced7:5f4:42e2])
        by smtp.gmail.com with ESMTPSA id l27-20020a63701b000000b0038233e59422sm14437523pgc.84.2022.04.05.21.24.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Apr 2022 21:24:22 -0700 (PDT)
From:   Arun Ajith S <aajith@arista.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, gilligan@arista.com,
        noureddine@arista.com, aajith@arista.com
Subject: [PATCH net-next] net/ipv6: Introduce accept_unsolicited_na knob to implement router-side changes for RFC9131
Date:   Wed,  6 Apr 2022 09:53:39 +0530
Message-Id: <20220406042339.10986-1-aajith@arista.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new neighbour cache entry in STALE state for routers on receiving
an unsolicited (gratuitous) neighbour advertisement with
source-link-layer-address option specified.
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
index b0024aa7b051..92e870693436 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2467,6 +2467,29 @@ drop_unsolicited_na - BOOLEAN
 
 	By default this is turned off.
 
+accept_unsolicited_na - BOOLEAN
+	Add a new neighbour cache entry in STALE state for routers on receiving an
+	unsolicited neighbour advertisement with source-link-layer address option
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
index b22504176588..e8a50f2c08d7 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5569,6 +5569,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_IOAM6_ID] = cnf->ioam6_id;
 	array[DEVCONF_IOAM6_ID_WIDE] = cnf->ioam6_id_wide;
 	array[DEVCONF_NDISC_EVICT_NOCARRIER] = cnf->ndisc_evict_nocarrier;
+	array[DEVCONF_ACCEPT_UNSOLICITED_NA] = cnf->accept_unsolicited_na;
 }
 
 static inline size_t inet6_ifla6_size(void)
@@ -7019,6 +7020,13 @@ static const struct ctl_table addrconf_sysctl[] = {
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
2.32.0 (Apple Git-132)

