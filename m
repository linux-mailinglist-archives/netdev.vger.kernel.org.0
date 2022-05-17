Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784C0529DE8
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243281AbiEQJX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244894AbiEQJWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:22:34 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EB9DEF3
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 02:22:32 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ev18so6194891pjb.4
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 02:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UQ4351L2HP//X/dnhx6DfmVwSjUQ2XvoIaRBFsv4r48=;
        b=jjmyQQopKP9lxVSgB5jDFBCm2lbrlH+y3b27rxayr/FHdo48UbYhhJpOCJu6Uduo92
         qMGSGMriHZyFgy0F8tOw3/JrNHTh3beU6CCmZp8ENYpj8g+fQTUjxGtkHV6C45XPzF/M
         phiZkapYWHvoKhi1T4lA19x9wslMtWk6e2ulGy2aqe9vTzx2GqLvVqCf4R+R2d8qC60F
         P1s9j2J1SDcppY1CVLyFDJyD3PCKD6UY4uIqYrMAxA6pfaBb2kMG9LkRyH91uBoTg1hX
         VGO5Gjxg+57q+msYJwdvre+J2Ik8/UQY07e8M0d2FXVb/W6R6AmwTubMY9C4tWwsR3F6
         gtmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=UQ4351L2HP//X/dnhx6DfmVwSjUQ2XvoIaRBFsv4r48=;
        b=z/7cJE5gA9W+zwMJLCtzKm2+t2pynmqhMlpHrCwMYZrwqfpIQPX8C6sQNMflPhxwEJ
         MFC/mX9HsNFaBIBNE7WKbdiz0IuiVs5Ugg81zziPelk6PAPGuWXbrnWDC3HlG8+xUW5m
         4Vjqe8zD4go7DqtZgZSm0RRmflOg1gr8Vx9J2YpFyA3DdqYiDIVvZORFRXmYJvsyvMOr
         wte0/C8LACWG+CAEgDhdEG+uxSDD0shY6RvevTQ+NvJqnEe6hz+GUW6ohF3d6irIVdSX
         gNDCAGwBuwSb5eXh7GWDO41gk6gRyRb5zY3FIW3Y26vHPXHjLxgvwLQIyq72fO7GDC0V
         Ol4w==
X-Gm-Message-State: AOAM5335xha2uC8vqP8NYEXgS5pWngY8b8zfQpjfTz30A3nQrAWvpUgn
        SrwqBMmS9313548fxx1QYlpZzX6n+6k=
X-Google-Smtp-Source: ABdhPJwcxmgYmbg3wS9+Q4qoyAqYE3D9gBE1s/TGq/piaGQbe7hiCkSLMCsOAK1T/26S1IuDLQ+Qtg==
X-Received: by 2002:a17:903:124a:b0:154:c7a4:9374 with SMTP id u10-20020a170903124a00b00154c7a49374mr21443077plh.68.1652779351458;
        Tue, 17 May 2022 02:22:31 -0700 (PDT)
Received: from localhost.localdomain ([45.124.203.18])
        by smtp.gmail.com with ESMTPSA id 26-20020aa7915a000000b00512ee2f2363sm6964176pfi.99.2022.05.17.02.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 02:22:30 -0700 (PDT)
Sender: "joel.stan@gmail.com" <joel.stan@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>
Cc:     netdev@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        David Wilder <wilder@us.ibm.com>,
        Dylan Hung <dylan_hung@aspeedtech.com>
Subject: [PATCH net v3] net: ftgmac100: Disable hardware checksum on AST2600
Date:   Tue, 17 May 2022 18:52:17 +0930
Message-Id: <20220517092217.323060-1-joel@jms.id.au>
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

The vendor suspects this this is a hardware issue when using NC-SI. The
fixes line refers to the patch that introduced AST2600 support.

Reported-by: David Wilder <wilder@us.ibm.com>
Reviewed-by: Dylan Hung <dylan_hung@aspeedtech.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
---
v3 modifies the wrapping of the commit message.

v2 updates the commit message with confirmation from the vendor that
this is a hardware issue, and clarifies why the commit used in the fixes

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
+	/* AST2600 tx checksum with NCSI is broken */
+	if (priv->use_ncsi && of_device_is_compatible(np, "aspeed,ast2600-mac"))
+		netdev->hw_features &= ~NETIF_F_HW_CSUM;
+
 	if (np && of_get_property(np, "no-hw-checksum", NULL))
 		netdev->hw_features &= ~(NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
 	netdev->features |= netdev->hw_features;
-- 
2.35.1

