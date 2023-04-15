Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823FC6E2F36
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 07:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjDOFtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 01:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjDOFtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 01:49:18 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D852A55B4
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:49:15 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id xd13so16945146ejb.4
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google; t=1681537754; x=1684129754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KjriD5FCdH2a/g++1E9APszM1FlDTgYU+lq4VWSvnFA=;
        b=vF7Xzuua89QO0OMIk2N15uCHG+sJA8D7jU2wjqPck/LO5zW/FNu2UIgOvsuvbvTuNh
         ptF5/2jvcuhM+TXobLpslSfnldvPNZHN5f0r4R7J0weQy+yZS7wVqsamSgFrC8I5RjZf
         09jbk2ojae6rCV8XDIe9UEmXzU8DHuhsv9FXk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681537754; x=1684129754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KjriD5FCdH2a/g++1E9APszM1FlDTgYU+lq4VWSvnFA=;
        b=fkrcrNpfxMSXwITwifgyO0gBCnvWc33SvWqcaS7mjo0oBmjujuOJKUT7Q9viQxbI8f
         rrXKljo5Q8gia6cBqm9WaKOoHHXfk0uqL3sCsVaoCBF2rwUrUoF2k9KPeaYLgIZgy+KF
         BqFwjrlggM75cD3Y5KYsWhf/M7mi9FelpvIFEbrkgSfLgq+gLmNvavaUxosiK2sG7Vyq
         MIYpjhVYjA5KnpwSfDk/0sjO3HEpGN9V68+XRhgpLhrGL7HkYPHlk3GWvErmnhsXdw2D
         Kplgsk/HZDVZhWcfbojYkMDV7qi5uvTfqmYvqWFB6RkUGNXzt0OOGPBHSVUllp5O7HSf
         QyWA==
X-Gm-Message-State: AAQBX9fQ6reAP64ikO5HlR3Oknwl3o2QGM4z+Z5hgnR9G8B5BqaOg4yl
        3KFE0R2beqZapDf7vbSsiI9tbA==
X-Google-Smtp-Source: AKy350YssNhoqlKHwl8NnPvgqpYczYd2nxY8tzFvbqdPBCfbOkUOhKrfzokmXFpYgdzW8DuKepa16g==
X-Received: by 2002:a17:906:6bd0:b0:94e:f969:fb3e with SMTP id t16-20020a1709066bd000b0094ef969fb3emr1252290ejs.43.1681537754369;
        Fri, 14 Apr 2023 22:49:14 -0700 (PDT)
Received: from perf-sql133-029021.hosts.secretcdn.net ([2620:11a:c018:0:ea8:be91:8d1:f59b])
        by smtp.gmail.com with ESMTPSA id b1-20020a170906038100b00947ccb6150bsm3294856eja.102.2023.04.14.22.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 22:49:14 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        Joe Damato <jdamato@fastly.com>
Subject: [PATCH net 2/2] ixgbe: Allow ixgbe to reset default flow hash
Date:   Sat, 15 Apr 2023 05:48:55 +0000
Message-Id: <20230415054855.9293-3-jdamato@fastly.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230415054855.9293-1-jdamato@fastly.com>
References: <20230415054855.9293-1-jdamato@fastly.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool uses `ETHTOOL_GRXRINGS` to compute how many queues are supported
by RSS. The driver should return the smaller of either:
  - The maximum number of RSS queues the device supports, OR
  - The number of RX queues configured

Prior to this change, running `ethtool -X $iface default` fails if the
number of queues configured is larger than the number supported by RSS,
even though changing the queue count correctly resets the flowhash to
use all supported queues.

Other drivers (for example, i40e) will succeed but the flow hash will
reset to support the maximum number of queues supported by RSS, even if
that amount is smaller than the configured amount.

Prior to this change:

$ sudo ethtool -L eth1 combined 20
$ sudo ethtool -x eth1
RX flow hash indirection table for eth1 with 20 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9    10    11    12    13    14    15
   16:      0     1     2     3     4     5     6     7
   24:      8     9    10    11    12    13    14    15
   32:      0     1     2     3     4     5     6     7
...

You can see that the flowhash was correctly set to use the maximum
number of queues supported by the driver (16).

However, asking the NIC to reset to "default" fails:

$ sudo ethtool -X eth1 default
Cannot set RX flow hash configuration: Invalid argument

After this change, the flowhash can be reset to default which will use
all of the available RSS queues (16) or the configured queue count,
whichever is smaller.

Starting with eth1 which has 10 queues and a flowhash distributing to
all 10 queues:

$ sudo ethtool -x eth1
RX flow hash indirection table for eth1 with 10 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9     0     1     2     3     4     5
   16:      6     7     8     9     0     1     2     3
...

Increasing the queue count to 48 resets the flowhash to distribute to 16
queues, as it did before this patch:

$ sudo ethtool -L eth1 combined 48
$ sudo ethtool -x eth1
RX flow hash indirection table for eth1 with 16 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9    10    11    12    13    14    15
   16:      0     1     2     3     4     5     6     7
...

Due to the other bugfix in this series, the flowhash can be set to use
queues 0-5:

$ sudo ethtool -X eth1 equal 5
$ sudo ethtool -x eth1
RX flow hash indirection table for eth1 with 16 RX ring(s):
    0:      0     1     2     3     4     0     1     2
    8:      3     4     0     1     2     3     4     0
   16:      1     2     3     4     0     1     2     3
...

Due to this bugfix, the flowhash can be reset to default and use 16
queues:

$ sudo ethtool -X eth1 default
$ sudo ethtool -x eth1
RX flow hash indirection table for eth1 with 16 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9    10    11    12    13    14    15
   16:      0     1     2     3     4     5     6     7
...

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 821dfd323fa9..0bbad4a5cc2f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -2665,6 +2665,14 @@ static int ixgbe_get_rss_hash_opts(struct ixgbe_adapter *adapter,
 	return 0;
 }
 
+static int ixgbe_rss_indir_tbl_max(struct ixgbe_adapter *adapter)
+{
+	if (adapter->hw.mac.type < ixgbe_mac_X550)
+		return 16;
+	else
+		return 64;
+}
+
 static int ixgbe_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
 			   u32 *rule_locs)
 {
@@ -2673,7 +2681,8 @@ static int ixgbe_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
 
 	switch (cmd->cmd) {
 	case ETHTOOL_GRXRINGS:
-		cmd->data = adapter->num_rx_queues;
+		cmd->data = min_t(int, adapter->num_rx_queues,
+				  ixgbe_rss_indir_tbl_max(adapter));
 		ret = 0;
 		break;
 	case ETHTOOL_GRXCLSRLCNT:
@@ -3075,14 +3084,6 @@ static int ixgbe_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 	return ret;
 }
 
-static int ixgbe_rss_indir_tbl_max(struct ixgbe_adapter *adapter)
-{
-	if (adapter->hw.mac.type < ixgbe_mac_X550)
-		return 16;
-	else
-		return 64;
-}
-
 static u32 ixgbe_get_rxfh_key_size(struct net_device *netdev)
 {
 	return IXGBE_RSS_KEY_SIZE;
-- 
2.25.1

