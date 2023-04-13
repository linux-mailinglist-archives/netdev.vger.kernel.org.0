Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14BD36E0D02
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 13:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbjDMLs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 07:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjDMLsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 07:48:06 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C82C7AF37;
        Thu, 13 Apr 2023 04:47:40 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E2377153B;
        Thu, 13 Apr 2023 04:48:05 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.65])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 721B33F73F;
        Thu, 13 Apr 2023 04:47:20 -0700 (PDT)
From:   Kevin Brodsky <kevin.brodsky@arm.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 3/3] net/ipv6: Initialise msg_control_is_user
Date:   Thu, 13 Apr 2023 12:47:05 +0100
Message-Id: <20230413114705.157046-4-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230413114705.157046-1-kevin.brodsky@arm.com>
References: <20230413114705.157046-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

do_ipv6_setsockopt() makes use of struct msghdr::msg_control in the
IPV6_2292PKTOPTIONS case. Make sure to initialise
msg_control_is_user accordingly.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 net/ipv6/ipv6_sockglue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 2917dd8d198c..ae818ff46224 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -716,6 +716,7 @@ int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 			goto done;
 
 		msg.msg_controllen = optlen;
+		msg.msg_control_is_user = false;
 		msg.msg_control = (void *)(opt+1);
 		ipc6.opt = opt;
 
-- 
2.38.1

