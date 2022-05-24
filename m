Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29233532E77
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 18:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239503AbiEXQDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 12:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239353AbiEXQDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 12:03:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C83F29827;
        Tue, 24 May 2022 09:01:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 899D9B81785;
        Tue, 24 May 2022 16:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BB5C34113;
        Tue, 24 May 2022 16:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653408084;
        bh=av2qwQPk8Q+62nOvRzPKh+Ovja46k5PlRTy59g/6TXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qiVhyl8fttwqBGLWYShGgbmpLVSsYeTOiZ4VnbyZXtWScRhufo84AqwtylkYs8HOV
         5HpVyQdq0sLcZsusTUh1YrINAbhKS9i8fWZxXQJ7qc/g2R8MGJbmacF1lGYe90Mpqm
         wcdYrLdAgIC+h0wEzbXQ7NyKTA7KzXNWsl2+6Ow/nX5DNLDcx89fBSwY0U4MnUGJ/N
         T8QH7BOtPRxYAjtDPoVXR8JYwvynRmtRlouzUG87fJkNguii4R/JuobEnzF0THEGjW
         dQYcJPb8WfQHsTNz+xVjACVjhqIvkqZCU0CDVXe3BfDsfVYZT9Zt6Iofqu01bUlhLy
         1TQP1UgrkYLSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joel Stanley <joel@jms.id.au>, David Wilder <wilder@us.ibm.com>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, guoheyi@linux.alibaba.com,
        arnd@arndb.de, chenhao288@hisilicon.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 2/4] net: ftgmac100: Disable hardware checksum on AST2600
Date:   Tue, 24 May 2022 12:01:15 -0400
Message-Id: <20220524160117.827308-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524160117.827308-1-sashal@kernel.org>
References: <20220524160117.827308-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit 6fd45e79e8b93b8d22fb8fe22c32fbad7e9190bd ]

The AST2600 when using the i210 NIC over NC-SI has been observed to
produce incorrect checksum results with specific MTU values. This was
first observed when sending data across a long distance set of networks.

On a local network, the following test was performed using a 1MB file of
random data.

On the receiver run this script:

 #!/bin/bash
 while [ 1 ]; do
        # Zero the stats
        nstat -r  > /dev/null
        nc -l 9899 > test-file
        # Check for checksum errors
        TcpInCsumErrors=$(nstat | grep TcpInCsumErrors)
        if [ -z "$TcpInCsumErrors" ]; then
                echo No TcpInCsumErrors
        else
                echo TcpInCsumErrors = $TcpInCsumErrors
        fi
 done

On an AST2600 system:

 # nc <IP of  receiver host> 9899 < test-file

The test was repeated with various MTU values:

 # ip link set mtu 1410 dev eth0

The observed results:

 1500 - good
 1434 - bad
 1400 - good
 1410 - bad
 1420 - good

The test was repeated after disabling tx checksumming:

 # ethtool -K eth0 tx-checksumming off

And all MTU values tested resulted in transfers without error.

An issue with the driver cannot be ruled out, however there has been no
bug discovered so far.

David has done the work to take the original bug report of slow data
transfer between long distance connections and triaged it down to this
test case.

The vendor suspects this this is a hardware issue when using NC-SI. The
fixes line refers to the patch that introduced AST2600 support.

Reported-by: David Wilder <wilder@us.ibm.com>
Reviewed-by: Dylan Hung <dylan_hung@aspeedtech.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 964407deca35..23c019d1278c 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1869,6 +1869,11 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	/* AST2400  doesn't have working HW checksum generation */
 	if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac")))
 		netdev->hw_features &= ~NETIF_F_HW_CSUM;
+
+	/* AST2600 tx checksum with NCSI is broken */
+	if (priv->use_ncsi && of_device_is_compatible(np, "aspeed,ast2600-mac"))
+		netdev->hw_features &= ~NETIF_F_HW_CSUM;
+
 	if (np && of_get_property(np, "no-hw-checksum", NULL))
 		netdev->hw_features &= ~(NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
 	netdev->features |= netdev->hw_features;
-- 
2.35.1

