Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE37D512E8A
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 10:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344252AbiD1Igg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 04:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344178AbiD1IgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 04:36:05 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188E3A66DB;
        Thu, 28 Apr 2022 01:29:13 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id q12so3391489pgj.13;
        Thu, 28 Apr 2022 01:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fVM62GyHltSE0ionm6SdLetw0VDoqMgiKzSssxmigAY=;
        b=QAg/+pe8G9Sc1mDs8zVzp2hV9mfGq78LAOAd66G/6sLc/MF0CQzJ+bcaT+w90Jh2Av
         8HNDkJ3nqfhlCnkcwEmEpxoPBuZYl+bg4oAGMUv+lHlqdU5B+7U81PP648+Yp3LFWan2
         P21d/yeqp3wWUW9qrIholko+vTlpsdc7JFWCIaMc+X3Xk+llOP1UjzKEB7ABeH5PVukb
         zUycFoHjS6PqN+FO/soY2wkuuvzG/vccsNhDQpW4zC5sE+dNYAIVpYjZXDbv5gluvKxw
         VOWM6/HpQ+dl+L0G7Al0ETAMQAnC35i/vMB48RkbhXVKP5rD+rw3fvMiNiO2hqNyyy0w
         IY3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=fVM62GyHltSE0ionm6SdLetw0VDoqMgiKzSssxmigAY=;
        b=icbFEHYnApDcsowDGYdsqXAMQnq8BjVuyYemrRD/XxNBnn2yaKr7Y2onIxBpoIgPPs
         Knb9XFn94NaGF3fJQMruxvI5JnWg6Bw7yIzHwzt6wBTaxfz5/TpCos/B0AgJEwco4vlB
         is113rpQqDP1a06EtZELkupPLDnyXlft11XjcaFV+LaJq3T/R8iMTuYff2lDoTaiew+e
         uSgL4NRFXZDwofK+tJU/vWFtTwUjq0MUod1JcQ22dAKYl4kCNXuGEHiG4jFawhCg22iA
         fMtf5IIA2GHaTf2g0gRZpIFYSBbHKN2Nl+nuWCqKQAIBimks2QLHQCVqS+J59rTGINgZ
         j92A==
X-Gm-Message-State: AOAM5318dWVu9gmi3Qfsu1xY/5n+Tbo9gL+damTgnR0n4ecOLeK6HcpI
        Dq6mTsTRYKK3+Cqq4VNR4PM=
X-Google-Smtp-Source: ABdhPJyTwDWftDHCcw6uVgNjozxu/y8Z4nCvbradyfoQcJDA2hYLwD/0AaZAp85aHF8Lo+WyhP0sgg==
X-Received: by 2002:a63:42:0:b0:3a8:47f7:bf0d with SMTP id 63-20020a630042000000b003a847f7bf0dmr27515113pga.276.1651134552242;
        Thu, 28 Apr 2022 01:29:12 -0700 (PDT)
Received: from voyager.ozlabs.ibm.com (pa49-178-80-133.pa.nsw.optusnet.com.au. [49.178.80.133])
        by smtp.gmail.com with ESMTPSA id i62-20020a639d41000000b003c14af50627sm1827176pgd.63.2022.04.28.01.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 01:29:11 -0700 (PDT)
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
Subject: [PATCH net] net: ftgmac100: Disable hardware checksum on AST2600
Date:   Thu, 28 Apr 2022 17:58:58 +0930
Message-Id: <20220428082858.545176-1-joel@jms.id.au>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
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

Fixes: 39bfab8844a0 ("net: ftgmac100: Add support for DT phy-handle property")
Reported-by: David Wilder <wilder@us.ibm.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
---
Net maintainers, if no one has a counter proposal I would like this
merged as a fix. Please give Dylan from Aspeed a chance to reply before
applying the patch.

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

