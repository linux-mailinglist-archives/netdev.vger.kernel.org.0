Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DCA52582A
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359397AbiELXTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347549AbiELXTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:19:54 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEE127BC43;
        Thu, 12 May 2022 16:19:52 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id p8so6131598pfh.8;
        Thu, 12 May 2022 16:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GbPvhZkWXt3QY9qEZgwTEjoyNuMBfGa+oZ63rvVL6pU=;
        b=KXo7F11DTbJvlXDBd9SjPMuEcgSvLN0+t9Z42Gnld89u3gv3d13it8R4mvdpD4Aj+A
         iX0ixvDywrk4zVp46MwFLGsn706vY+iYKx/Wopote1ECb78df+H+ykwo+SXk+kq8kKr6
         dKBUr+5AFsvbM2g2emjRGCteNR1c6oyj+Ckz4U3FAEyTulGbHnW9N6ENPcYVUI3kPYWy
         LApJXwuVMqeGxWjH49SbdfduZ+0u/VsJYIwqRI6qCnmstjBy4q6oijGZ4V/gFMDu8/fS
         0lcibXZXSJXqWQXWtSRZNEVTA3xK1eHsA2O/EOoaQsvNaUhp90DRWN/Cvk7cflzreJuQ
         ytQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=GbPvhZkWXt3QY9qEZgwTEjoyNuMBfGa+oZ63rvVL6pU=;
        b=7IRS2P156jvQaut0E70JSykuLO1zPuwb3Jxog4q5/LgJBWEn2GZwLxe6iWMjSXDOsA
         YpXuT0KAozm0Ag0UIxC6mdlcBEFxFUeo/EXjYk0guEhyKKStAOJGFEWDpWzbW7VasbkU
         ighv2ikM4AfrGnCk+QAkSIx9PR+TKFgDq67KF2rIezZs4dBX8aoZKHqV7nzgvbLkZ0L/
         ebYeso79JD6wzGo4O9VTRkShO+V133hDHoXIDK/DJXXE+LO0tvajIUQAuU3n1ZxeFTUw
         91/Cs5rCl5dktLl6BGzRuI+XFJ1JvNzGgO+SbjZ3AxDhmv96sdDabNIzTZ5pCzp3cG2R
         y5DA==
X-Gm-Message-State: AOAM532gnA6S5HJlzU1yb77MaFPVPmZEjl6UmPl8GbaeNvdGTNV1aSNK
        q9ARERH6zELtzzHkguQwH4c=
X-Google-Smtp-Source: ABdhPJyjZh9c6o2fHHw3TEt65QCqWYK5MnJjNiUnAYFi/lE+ZXQ7XfTmNu97r4JGi8v3BR2xEP6rxw==
X-Received: by 2002:a65:6250:0:b0:3c6:8a09:249 with SMTP id q16-20020a656250000000b003c68a090249mr1524507pgv.389.1652397592333;
        Thu, 12 May 2022 16:19:52 -0700 (PDT)
Received: from localhost.localdomain ([45.124.203.18])
        by smtp.gmail.com with ESMTPSA id u20-20020a63b554000000b003c6445e2aa8sm267814pgo.4.2022.05.12.16.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 16:19:50 -0700 (PDT)
Sender: "joel.stan@gmail.com" <joel.stan@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        David Wilder <dwilder@us.ibm.com>
Cc:     openbmc@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Wilder <wilder@us.ibm.com>
Subject: [PATCH net v2] net: ftgmac100: Disable hardware checksum on AST2600
Date:   Fri, 13 May 2022 08:49:38 +0930
Message-Id: <20220512231938.228651-1-joel@jms.id.au>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

The vendor suspects this this is a hardware issue when using NC-SI. The fixes line refers
to the patch that introduced AST2600 support.

Fixes: 39bfab8844a0 ("net: ftgmac100: Add support for DT phy-handle property")
Reported-by: David Wilder <wilder@us.ibm.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
---
v2 updates the commit message with confirmation form the vendor that
this is a hardware issue, and clarifes why the commit used in the fixes
tag was chosen.

 drivers/net/ethernet/faraday/ftgmac100.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index caf48023f8ea..5231818943c6 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1928,6 +1928,11 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	/* AST2400  doesn't have working HW checksum generation */
 	if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac")))
 		netdev->hw_features &= ~NETIF_F_HW_CSUM;
+
+	/* AST2600 tx checksum with NC-SI is broken */
+	if (priv->use_ncsi && of_device_is_compatible(np, "aspeed,ast2600-mac"))
+		netdev->hw_features &= ~NETIF_F_HW_CSUM;
+
 	if (np && of_get_property(np, "no-hw-checksum", NULL))
 		netdev->hw_features &= ~(NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
 	netdev->features |= netdev->hw_features;
-- 
2.35.1

