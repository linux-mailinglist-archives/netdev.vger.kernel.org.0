Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856035A8682
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 21:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbiHaTNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 15:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbiHaTMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 15:12:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFD5D99D9;
        Wed, 31 Aug 2022 12:12:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57012B8229F;
        Wed, 31 Aug 2022 19:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19D9C433D7;
        Wed, 31 Aug 2022 19:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661973169;
        bh=ZlVKgKTrX1x0CLe8TUlE5hyyKfAJCRY7X7EjuH+f/KY=;
        h=Date:From:To:Cc:Subject:From;
        b=NauY8gKc395GmXMkKYgRYOcanRSq67fKagRo2SsvKcny8F8tUOcJ97RH2mV0YmFdU
         adZHHr0yAzJofxtXBoBcKL/5uVgavG6GwYz3NSJ+oWLqQmAsFnz5an6jrH1saD1sOt
         g/3GFcT/qwULN8B1WK5V3g0/4086v0pf5F4dCDSmZE2Kh7/ooVp5IlbK1DzPtN+33e
         Q9C8KpeK6ezNrDX61tTutZgNoVEUE5sKDK8geUvV1MtGcnRc4t8DIw1yOExUIh0yA8
         2M14x2n+/2B+Er96OdP9IHsBjWy2aBfP9pBi1WtxM2kS/g4fP+ZVyMPyykMXrCyAsS
         jx6wLNeBuqPoQ==
Date:   Wed, 31 Aug 2022 14:12:42 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH v2][next] net/ipv4: Use __DECLARE_FLEX_ARRAY() helper
Message-ID: <Yw+yqpCd5A/Q1oo5@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We now have a cleaner way to keep compatibility with user-space
(a.k.a. not breaking it) when we need to keep in place a one-element
array (for its use in user-space) together with a flexible-array
member (for its use in kernel-space) without making it hard to read
at the source level. This is through the use of the new
__DECLARE_FLEX_ARRAY() helper macro.

The size and memory layout of the structure is preserved after the
changes. See below.

Before changes:

$ pahole -C ip_msfilter net/ipv4/igmp.o
struct ip_msfilter {
	union {
		struct {
			__be32     imsf_multiaddr_aux;   /*     0     4 */
			__be32     imsf_interface_aux;   /*     4     4 */
			__u32      imsf_fmode_aux;       /*     8     4 */
			__u32      imsf_numsrc_aux;      /*    12     4 */
			__be32     imsf_slist[1];        /*    16     4 */
		};                                       /*     0    20 */
		struct {
			__be32     imsf_multiaddr;       /*     0     4 */
			__be32     imsf_interface;       /*     4     4 */
			__u32      imsf_fmode;           /*     8     4 */
			__u32      imsf_numsrc;          /*    12     4 */
			__be32     imsf_slist_flex[0];   /*    16     0 */
		};                                       /*     0    16 */
	};                                               /*     0    20 */

	/* size: 20, cachelines: 1, members: 1 */
	/* last cacheline: 20 bytes */
};

After changes:

$ pahole -C ip_msfilter net/ipv4/igmp.o
struct ip_msfilter {
	__be32                     imsf_multiaddr;       /*     0     4 */
	__be32                     imsf_interface;       /*     4     4 */
	__u32                      imsf_fmode;           /*     8     4 */
	__u32                      imsf_numsrc;          /*    12     4 */
	union {
		__be32             imsf_slist[1];        /*    16     4 */
		struct {
			struct {
			} __empty_imsf_slist_flex;       /*    16     0 */
			__be32     imsf_slist_flex[0];   /*    16     0 */
		};                                       /*    16     0 */
	};                                               /*    16     4 */

	/* size: 20, cachelines: 1, members: 5 */
	/* last cacheline: 20 bytes */
};

In the past, we had to duplicate the whole original structure within
a union, and update the names of all the members. Now, we just need to
declare the flexible-array member to be used in kernel-space through
the __DECLARE_FLEX_ARRAY() helper together with the one-element array,
within a union. This makes the source code more clean and easier to read.

Link: https://github.com/KSPP/linux/issues/193
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v2:
 - Remove unnecessary internal anonymous struct. (Kees)

 include/uapi/linux/in.h | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index 14168225cecd..578daa6f816b 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -188,21 +188,13 @@ struct ip_mreq_source {
 };
 
 struct ip_msfilter {
+	__be32		imsf_multiaddr;
+	__be32		imsf_interface;
+	__u32		imsf_fmode;
+	__u32		imsf_numsrc;
 	union {
-		struct {
-			__be32		imsf_multiaddr_aux;
-			__be32		imsf_interface_aux;
-			__u32		imsf_fmode_aux;
-			__u32		imsf_numsrc_aux;
-			__be32		imsf_slist[1];
-		};
-		struct {
-			__be32		imsf_multiaddr;
-			__be32		imsf_interface;
-			__u32		imsf_fmode;
-			__u32		imsf_numsrc;
-			__be32		imsf_slist_flex[];
-		};
+		__be32		imsf_slist[1];
+		__DECLARE_FLEX_ARRAY(__be32, imsf_slist_flex);
 	};
 };
 
-- 
2.34.1

