Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB1E5EB4F8
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 01:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiIZXCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 19:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiIZXC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 19:02:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBD3A6C32;
        Mon, 26 Sep 2022 16:02:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4848B815A2;
        Mon, 26 Sep 2022 23:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD04C433C1;
        Mon, 26 Sep 2022 23:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664233345;
        bh=5dChttAHV31mKU5I2NgaQQKiJXkhkhhDNgOij7T3c9Y=;
        h=Date:From:To:Cc:Subject:From;
        b=MR1D7pcp2gGikSxBXu28M3Ea1TFbxRqrIFnKiG843hTEk9Yy0ZGZ7KYMIaIz1U74V
         Z+KgP2tppCHkHY3kq1FtEFQoMlBCPN7JJj5tVsma2AVhdi1qSZ33yodiwri+mSrBrg
         RGD8w9NZ6e6MyN03WrII8BmS1wn2p+6TFP6jJYyCfrJRrIg2GAqpQBNkN05G3r6QxD
         WpweY2+iRKuGnAG5pA69CbPlXnd/bD85uMBaH8lj/mhWrmQvtr+vY3ZKmyIysAh9VB
         D4jBQm+eHUtSrJJD1kUuXi+J6Gek0E0vaZh10N7se7UvDRMDwyKPzecL6ZH34tTeXT
         uRw97VLopjl6g==
Date:   Mon, 26 Sep 2022 18:02:20 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] netns: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <YzIvfGXxfjdXmIS3@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays are deprecated and we are moving towards adopting
C99 flexible-array members, instead. So, replace zero-length arrays
declarations in anonymous union with the new DECLARE_FLEX_ARRAY()
helper macro.

This helper allows for flexible-array members in unions.

Link: https://github.com/KSPP/linux/issues/193
Link: https://github.com/KSPP/linux/issues/225
Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 include/net/netns/generic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netns/generic.h b/include/net/netns/generic.h
index 7ce68183f6e1..00c399edeed1 100644
--- a/include/net/netns/generic.h
+++ b/include/net/netns/generic.h
@@ -33,7 +33,7 @@ struct net_generic {
 			struct rcu_head rcu;
 		} s;
 
-		void *ptr[0];
+		DECLARE_FLEX_ARRAY(void *, ptr);
 	};
 };
 
-- 
2.34.1

