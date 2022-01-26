Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C9049CEBC
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 16:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242983AbiAZPi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 10:38:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33274 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236156AbiAZPi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 10:38:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643211537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=2hXfD/07pOc1wZRhpA398EaJhEOiZ4QB6/W4g6umBLI=;
        b=UOt7VS9uc0kElMETKNRrlxMnXMbBC0xwXiGWHxWv7477GYynH+RmJVVa9DsgcoghqQMCr2
        57NU5mkVmGrUDE9XQ/LUvK22uC5/gSyFN1nnhi05iDLMXbUD9mWukgb+BoK4D+tTAa4fNz
        ac0q6lXpn5FUPiVHz3NCYGoAlxjqYck=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-Rqwy2_T3P2Wrt6moHygxVA-1; Wed, 26 Jan 2022 10:38:56 -0500
X-MC-Unique: Rqwy2_T3P2Wrt6moHygxVA-1
Received: by mail-wr1-f72.google.com with SMTP id c9-20020adfa709000000b001dde29c3202so614945wrd.22
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 07:38:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=2hXfD/07pOc1wZRhpA398EaJhEOiZ4QB6/W4g6umBLI=;
        b=NghMufn/H9wgKtLRq3xsiRX3ZXF1qQsKmIY5Hd/goxnuRO+fS47WV124NcSmPSV4Db
         c9flOqYgItoye89kBfzVNbAi5asF5KleIbS4RR5fhRxum1TSK/4J/qGLanQfxl7tHpEa
         jrVMGsqemj3HaFTjVlJMg2Lxjr/3Wa/9MmTM3eJOi4M78KAAg3CZATUNqZPFKHz3fAqh
         R/IuKVPYf4JT4qqYB9jygO00S0gguwd2hPsVkVOHK/Exws+tvqV9lOKubz/aOix2heT3
         ObztZgnEPLfKtvXhdnHcfda4uMih3gRT6aMTcBZI1XZY21HhD9943x3DB6rsGXjChays
         byaQ==
X-Gm-Message-State: AOAM533L3No7pOYomp6qozf87S5wjPvYuJhW3VkkU3sIAdOAQjVo0eKq
        TTFvEtpW0w/FtTr3QO6vjSX9uutxvAfAmtdtMNBzj8Prl6j2/U2yFcHcgsr0J8kRbbtiZcCBvvt
        oLhxI/cG4zYDGYwob
X-Received: by 2002:a5d:5088:: with SMTP id a8mr23922370wrt.326.1643211534895;
        Wed, 26 Jan 2022 07:38:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxfMoYrTbTsrIrCWUCiy2PcC/UKZ1+3H/G+BFLO61S1Yr/F0k3p1hZnBNyl3DhmDjY5tOAB6A==
X-Received: by 2002:a5d:5088:: with SMTP id a8mr23922355wrt.326.1643211534642;
        Wed, 26 Jan 2022 07:38:54 -0800 (PST)
Received: from pc-1.home (2a01cb058d24940001d1c23ad2b4ba61.ipv6.abo.wanadoo.fr. [2a01:cb05:8d24:9400:1d1:c23a:d2b4:ba61])
        by smtp.gmail.com with ESMTPSA id u17sm3844037wmq.41.2022.01.26.07.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 07:38:54 -0800 (PST)
Date:   Wed, 26 Jan 2022 16:38:52 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Fernando Gont <fgont@si6networks.com>
Subject: [PATCH net] Revert "ipv6: Honor all IPv6 PIO Valid Lifetime values"
Message-ID: <e767ccf72eaee6e816d277248dd3a98ebf5718c1.1643210627.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit b75326c201242de9495ff98e5d5cff41d7fc0d9d.

This commit breaks Linux compatibility with USGv6 tests. The RFC this
commit was based on is actually an expired draft: no published RFC
currently allows the new behaviour it introduced.

Without full IETF endorsement, the flash renumbering scenario this
patch was supposed to enable is never going to work, as other IPv6
equipements on the same LAN will keep the 2 hours limit.

Fixes: b75326c20124 ("ipv6: Honor all IPv6 PIO Valid Lifetime values")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
No changes since RFC, apart from rebasing on top of net.

 include/net/addrconf.h |  2 ++
 net/ipv6/addrconf.c    | 27 ++++++++++++++++++++-------
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 78ea3e332688..e7ce719838b5 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -6,6 +6,8 @@
 #define RTR_SOLICITATION_INTERVAL	(4*HZ)
 #define RTR_SOLICITATION_MAX_INTERVAL	(3600*HZ)	/* 1 hour */
 
+#define MIN_VALID_LIFETIME		(2*3600)	/* 2 hours */
+
 #define TEMP_VALID_LIFETIME		(7*86400)
 #define TEMP_PREFERRED_LIFETIME		(86400)
 #define REGEN_MAX_RETRY			(3)
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3eee17790a82..f927c199a93c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2589,7 +2589,7 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
 				 __u32 valid_lft, u32 prefered_lft)
 {
 	struct inet6_ifaddr *ifp = ipv6_get_ifaddr(net, addr, dev, 1);
-	int create = 0;
+	int create = 0, update_lft = 0;
 
 	if (!ifp && valid_lft) {
 		int max_addresses = in6_dev->cnf.max_addresses;
@@ -2633,19 +2633,32 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
 		unsigned long now;
 		u32 stored_lft;
 
-		/* Update lifetime (RFC4862 5.5.3 e)
-		 * We deviate from RFC4862 by honoring all Valid Lifetimes to
-		 * improve the reaction of SLAAC to renumbering events
-		 * (draft-gont-6man-slaac-renum-06, Section 4.2)
-		 */
+		/* update lifetime (RFC2462 5.5.3 e) */
 		spin_lock_bh(&ifp->lock);
 		now = jiffies;
 		if (ifp->valid_lft > (now - ifp->tstamp) / HZ)
 			stored_lft = ifp->valid_lft - (now - ifp->tstamp) / HZ;
 		else
 			stored_lft = 0;
-
 		if (!create && stored_lft) {
+			const u32 minimum_lft = min_t(u32,
+				stored_lft, MIN_VALID_LIFETIME);
+			valid_lft = max(valid_lft, minimum_lft);
+
+			/* RFC4862 Section 5.5.3e:
+			 * "Note that the preferred lifetime of the
+			 *  corresponding address is always reset to
+			 *  the Preferred Lifetime in the received
+			 *  Prefix Information option, regardless of
+			 *  whether the valid lifetime is also reset or
+			 *  ignored."
+			 *
+			 * So we should always update prefered_lft here.
+			 */
+			update_lft = 1;
+		}
+
+		if (update_lft) {
 			ifp->valid_lft = valid_lft;
 			ifp->prefered_lft = prefered_lft;
 			ifp->tstamp = now;
-- 
2.21.3

