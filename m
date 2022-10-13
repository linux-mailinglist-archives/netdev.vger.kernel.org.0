Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A963D5FE5AF
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 00:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiJMWzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 18:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiJMWzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 18:55:36 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A7615200C
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 15:55:28 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id f193so2833788pgc.0
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 15:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9xzIvBQboVU6QSJeZ36bSnwTh4/Q/wHVlnO0sL376rQ=;
        b=inUPe8i3pDgU690g6pKYXdJ+J3eqN19cSvhrQnycfJcOebhPFZqZKPj63H3xdJTUJN
         96WdWngcIk6Hc7/CK1zxnO9TB474LFR3+a2AzswLbIaCMnAZuY6g86oNyqfOtHHr8D1O
         oqH+bp6096+6QoL2ZudSDzEmng63bV2rz4rW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9xzIvBQboVU6QSJeZ36bSnwTh4/Q/wHVlnO0sL376rQ=;
        b=jhXq5TnRS2yjRsKGiP4njaI2KKBqhe6+gIO8iqZnzqGKM8mZfrfpAnlFXuIAFZBEhU
         nIWeQ4XPEVrTEkXXUsV4oPNYIrKpPV6VeX3nuuvye1rXhj/jGL38qjodqLTXTBOnoqfZ
         7DgEFUjquRJRvhBEh+GdbfB7DS2UbZWTiEF2SQkmhGcHIZFEZO1eBDC80eyEIif++5iH
         WT/0LUiGOST7J26sJZvt870aPkXmyvOlnztwTfDwzL7FsTti/vnjS4vsKoQtstRImfCp
         7P6EET4pelSABqnP8nMuMNz2ybrR4rTaECcO6q1NNeoPqF4+woMS1XDsvMCMjus1lzjl
         yw7A==
X-Gm-Message-State: ACrzQf07omdTDOIsCaNtzVVo8LJFWHLrmePL+miR20sbuhgY3OeOt/F+
        BgzSApU+ILTc1CSrsEbfR5t3EQ==
X-Google-Smtp-Source: AMsMyM4bWk5UMVBpYhVx7JHLiBqIpyiiByE5lDDHmJvZKOMsjHJWRw5JtFt3bcHjhhlkcmUsC8i6sg==
X-Received: by 2002:a05:6a00:14c8:b0:564:5e5:8d85 with SMTP id w8-20020a056a0014c800b0056405e58d85mr1998375pfu.36.1665701727798;
        Thu, 13 Oct 2022 15:55:27 -0700 (PDT)
Received: from localhost.localdomain (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id b14-20020a170902650e00b00174fa8cbf31sm313110plk.303.2022.10.13.15.55.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Oct 2022 15:55:27 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        Joe Damato <jdamato@fastly.com>
Subject: [net-queue bugfix RFC] i40e: Clear IFF_RXFH_CONFIGURED when RSS is reset
Date:   Thu, 13 Oct 2022 15:54:31 -0700
Message-Id: <1665701671-6353-1-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sending this first as an RFC to ensure that this is the correct and desired
behavior when changing queue counts and flowhashes in i40e.

If this is approved, I can send an official "v1".

Before this change, reconfiguring the queue count using ethtool doesn't
always work, even for queue counts that were previously accepted because
the IFF_RXFH_CONFIGURED bit was not cleared when the flow indirection hash
is cleared by the driver.

For example:

$ sudo ethtool -x eth0
RX flow hash indirection table for eth0 with 34 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9    10    11    12    13    14    15
   16:     16    17    18    19    20    21    22    23
   24:     24    25    26    27    28    29    30    31
   32:     32    33     0     1     2     3     4     5
[...snip...]

As you can see, the flow indirection hash distributes flows to 34 queues.

Increasing the number of queues from 34 to 64 works, and the flow
indirection hash is reset automatically:

$ sudo ethtool -L eth0 combined 64
$ sudo ethtool -x eth0
RX flow hash indirection table for eth0 with 64 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9    10    11    12    13    14    15
   16:     16    17    18    19    20    21    22    23
   24:     24    25    26    27    28    29    30    31
   32:     32    33    34    35    36    37    38    39
   40:     40    41    42    43    44    45    46    47
   48:     48    49    50    51    52    53    54    55
   56:     56    57    58    59    60    61    62    63

However, reducing the queue count back to 34 (which previously worked)
fails:

$ sudo ethtool -L eth0 combined 34
Cannot set device channel parameters: Invalid argument

This happens because the kernel thinks that the user configured the flow
hash (since the IFF_RXFH_CONFIGURED bit is not cleared by the driver when
the driver reset it) and thus returns -EINVAL, presumably to prevent the
driver from resizing the queues and resetting the user-defined flowhash.

With this patch applied, the queue count can be reduced to fewer queues
than the flow indirection hash is set to distribute flows to if the flow
indirection hash was not modified by the user.

For example, with the patch applied:

$ sudo ethtool -L eth0 combined 32
$ sudo ethtool -x eth0
RX flow hash indirection table for eth0 with 32 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9    10    11    12    13    14    15
   16:     16    17    18    19    20    21    22    23
   24:     24    25    26    27    28    29    30    31
[..snip..]

I can now reduce the queue count to below 32 without error (unlike earlier):

$ sudo ethtool -L eth0 combined 24
$ sudo ethtool -x eth0
RX flow hash indirection table for eth0 with 24 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9    10    11    12    13    14    15
   16:     16    17    18    19    20    21    22    23

This works because I was using the default flow hash, so the driver discards
it and regenerates it.

However, if I manually set the flow hash to some user defined value:

$ sudo ethtool -X eth0 equal 20
$ sudo ethtool -x eth0
RX flow hash indirection table for eth0 with 24 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9    10    11    12    13    14    15
   16:     16    17    18    19     0     1     2     3
[..snip..]

I will now not be able to shrink the queue count again:

$ sudo ethtool -L eth0 combined 16
Cannot set device channel parameters: Invalid argument

But, I can increase the queue count and the flow hash is preserved:

$ sudo ethtool -L eth0 combined 64
$ sudo ethtool -x eth0
RX flow hash indirection table for eth0 with 64 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9    10    11    12    13    14    15
   16:     16    17    18    19     0     1     2     3

Fixes: 28c5869f2bc4 ("i40e: add new fields to store user configuration")
Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index feabd26..0e8dca7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -11522,6 +11522,8 @@ static void i40e_clear_rss_config_user(struct i40e_vsi *vsi)
 
 	kfree(vsi->rss_lut_user);
 	vsi->rss_lut_user = NULL;
+
+	vsi->netdev->priv_flags &= ~IFF_RXFH_CONFIGURED;
 }
 
 /**
-- 
2.7.4

