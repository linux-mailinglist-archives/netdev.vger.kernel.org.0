Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5DC53B0A0
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 02:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbiFAXm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 19:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiFAXm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 19:42:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08F3C3C
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 16:42:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E52F661571
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 23:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04592C385B8;
        Wed,  1 Jun 2022 23:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654126973;
        bh=xwdbDx47P+vNoFwSsJeGXljCGfL+4D1C+1wrqKG6TOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sz4acZpORJqgCFHoKsmikar4MqG8VLJRY3vBh4DfsMzGv9l3iCzueRRw/qqydiWsv
         5+ofXMS0lU0Hres3/xv526I2+HK7ro29nuFj3nEP9/m7hzzIITGXQWeckOE4zaMgMl
         N0J+31Ghr+J5Kd2EeRZARjD7XIbropUHjefYjOfpazWbk0Sq0gG5Hl2dzKS7WDtbCI
         kNLG6Sh3I02gpYkX/EO/UYpfJ09POUS+JhInEkiXe1a7QaRzMgbAVRDpQQNFGQKjdN
         ZdGbsmolP/rrkK1Q8QvE5Z61BXLbtNV2RhdQCM6+YFJNTHbRcvX+fNxg6rAnC3PMH6
         n5N7X3awgRMvQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, maximmi@nvidia.com,
        stephen@networkplumber.org, tariqt@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH iproute2-next v2] ss: Shorter display format for TLS zerocopy sendfile
Date:   Wed,  1 Jun 2022 16:42:49 -0700
Message-Id: <20220601234249.244701-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220601122343.2451706-1-maximmi@nvidia.com>
References: <20220601122343.2451706-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 21c07b45688f ("ss: Show zerocopy sendfile status of TLS
sockets") used "key: value" format for the sendfile read-only
optimization. Move to a more appropriate "flag" display format.
Rename the flag to something based on the assumption it allows
the kernel to make. Avoid "salesman speak", the term "zero-copy"
is particularly confusing in TLS where we call decrypt/encrypt
directly from user space a zero-copy as well.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 misc/ss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/misc/ss.c b/misc/ss.c
index c4434a20bcfe..ac678c296006 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -2988,7 +2988,8 @@ static void tcp_tls_conf(const char *name, struct rtattr *attr)
 
 static void tcp_tls_zc_sendfile(struct rtattr *attr)
 {
-	out(" zerocopy_sendfile: %s", attr ? "active" : "inactive");
+	if (attr)
+		out(" sendfile_ro");
 }
 
 static void mptcp_subflow_info(struct rtattr *tb[])
-- 
2.36.1

