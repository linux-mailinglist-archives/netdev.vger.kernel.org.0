Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75CC546C10
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 20:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244328AbiFJSCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 14:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241580AbiFJSCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 14:02:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1ED7F04;
        Fri, 10 Jun 2022 11:02:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AE1EB836B6;
        Fri, 10 Jun 2022 18:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7501EC34114;
        Fri, 10 Jun 2022 18:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654884137;
        bh=xdgudyzcUYULsU1aZaCdI0nmCH/Fx4yp1ArgCFICDXI=;
        h=From:To:Cc:Subject:Date:From;
        b=UtaW+5X3ipQeRtYPqpcDTMZaIin+9ysNpz0fEi2YtrAsLi4wsHNl2CEqS3B8KSJoz
         9abRBQd61RqfV3IU9LEk0jqfa89mKz3FWH+mCJpjWqiED28TrCpk4k/hMMY6Ek0UNF
         EUL0+lG7ixf/amH+rh2mbkcQ85fOOTNWM4oKJL6ZpxYdnqVgDmq0L9W+HXkciM9P2Q
         ZLgFaEwRJXlQm3lmZ8aJyG0Pg68BCBsMFrYq+M9pCOWjtNNfbiTSP3bxHNvd0zXNdd
         1+RFnVn2kkPKxvz5MpE3KeKwKESWeKx4yKI7lg3tYQkrGGmoztNlrMyAsqhR7aCPzb
         LMQoE4UD23hnQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, maximmi@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>, corbet@lwn.net,
        linux-doc@vger.kernel.org
Subject: [PATCH net] docs: tls: document the TLS_TX_ZEROCOPY_RO
Date:   Fri, 10 Jun 2022 11:02:12 -0700
Message-Id: <20220610180212.110590-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing documentation for the TLS_TX_ZEROCOPY_RO opt-in.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: corbet@lwn.net
CC: linux-doc@vger.kernel.org
---
 Documentation/networking/tls.rst | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/Documentation/networking/tls.rst b/Documentation/networking/tls.rst
index 8cb2cd4e2a80..be8e10c14b05 100644
--- a/Documentation/networking/tls.rst
+++ b/Documentation/networking/tls.rst
@@ -214,6 +214,31 @@ of calling send directly after a handshake using gnutls.
 Since it doesn't implement a full record layer, control
 messages are not supported.
 
+Optional optimizations
+----------------------
+
+There are certain condition-specific optimizations the TLS ULP can make,
+if requested. Those optimizations are either not universally beneficial
+or may impact correctness, hence they require an opt-in.
+All options are set per-socket using setsockopt(), and their
+state can be checked using getsockopt() and via socket diag (``ss``).
+
+TLS_TX_ZEROCOPY_RO
+~~~~~~~~~~~~~~~~~~
+
+For device offload only. Allow sendfile() data to be transmitted directly
+to the NIC without making an in-kernel copy. This allows true zero-copy
+behavior when device offload is enabled.
+
+The application must make sure that the data is not modified between being
+submitted and transmission completing. In other words this is mostly
+applicable if the data sent on a socket via sendfile() is read-only.
+
+Modifying the data may result in different versions of the data being used
+for the original TCP transmission and TCP retransmissions. To the receiver
+this will look like TLS records had been tampered with and will result
+in record authentication failures.
+
 Statistics
 ==========
 
-- 
2.36.1

