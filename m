Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0AA4E74BE
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 15:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359267AbiCYOGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 10:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359264AbiCYOGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 10:06:33 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147B7D8F47
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:04:59 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id h23so11022060wrb.8
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V8rESgnRRVosu5hPSZc35M3ikXmcWBK5NfYg41ecw5c=;
        b=HOgZGTvcQJx8GrOHPi+59IHKDvj0sqsLKe/NXu5r6bLevjhiQ1kHSGQC8pyhEktGrX
         opJ0ULprPb+vSoZJJ/Y0JBv3z8z15ZWBbrPfNIxnSFA4dhmpgZ9V/pF+ykMCCNKcEKMy
         WS5is4qykGuGCiSEgxZRh0+x7c19u1tnrOs0t8bRWqMHI5PKTUoLSmA53Yl2o6ru+hye
         iaV24SEO2h4Fj2p6X7GxEe5UZgQ/VO7Q+alfS4grdSApAnPy/rG2UeX6pG8lnCR0d7nS
         BgyBt36iirhodUgPM5kWSgWlu50IXBdH3RAS8LIr1I8KqliwhDKUk4ep08h4IGHMygZV
         DAOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V8rESgnRRVosu5hPSZc35M3ikXmcWBK5NfYg41ecw5c=;
        b=HTEJB0+/xukGEWqe0Ka/+X60+CHvy3IDXTYPSJXKAWmkvBCVATp7B1MDi9WBbsYgc3
         Sh1P3iXLTbNuyh+hcB8swYmeFqc7n5UiKF13cLvPYTiJG4kADJW7Ta+UIZIXQkSgFeIm
         IKT5lLVxtH6H5gOjTOQKRzzQq/x3lPH5Yo4fQdAlYGtNE/sue2R1reAMi8nkFN8Rl6OT
         smmM+sLnr4iz0kwU2jvYzVmTHac4J5055stok7WSn2CFmpfoMT+hDXcIqMRfWlMO4moO
         mXhwXeLViYzIOIZWsC3Pnm7IpKD69eiKI17t3Cf8QCUX3zFVC2rD1CZU4HKAxFEzRpBY
         75rA==
X-Gm-Message-State: AOAM533bhBqWbno3UVUuqNz5Pg0j6jLsCToGA0c7fdpcZFV0aVir9uDy
        6wVpfy1m5YYPw7mC3CVsPV6nK+7+g+D3LQ==
X-Google-Smtp-Source: ABdhPJwM9U2Rklxk8YNFWBlR+9dB4/9mjYDp0kY7KH/RjKqVlCMK1g1Xgo8ACtEY6qXy+WHwP/cwTw==
X-Received: by 2002:a5d:67cb:0:b0:204:674:fd12 with SMTP id n11-20020a5d67cb000000b002040674fd12mr9447051wrw.528.1648217097627;
        Fri, 25 Mar 2022 07:04:57 -0700 (PDT)
Received: from gojira.dev.6wind.com ([185.13.181.2])
        by smtp.gmail.com with ESMTPSA id o8-20020a5d6488000000b002051f1028f6sm6347642wri.111.2022.03.25.07.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 07:04:56 -0700 (PDT)
From:   Olivier Matz <olivier.matz@6wind.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org,
        Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net 2/2] ixgbe: fix unexpected VLAN Rx in promisc mode on VF
Date:   Fri, 25 Mar 2022 15:02:50 +0100
Message-Id: <20220325140250.21663-3-olivier.matz@6wind.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220325140250.21663-1-olivier.matz@6wind.com>
References: <20220325140250.21663-1-olivier.matz@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the promiscuous mode is enabled on a VF, the IXGBE_VMOLR_VPE
bit (VLAN Promiscuous Enable) is set. This means that the VF will
receive packets whose VLAN is not the same than the VLAN of the VF.

For instance, in this situation:

┌────────┐    ┌────────┐    ┌────────┐
│        │    │        │    │        │
│        │    │        │    │        │
│     VF0├────┤VF1  VF2├────┤VF3     │
│        │    │        │    │        │
└────────┘    └────────┘    └────────┘
   VM1           VM2           VM3

vf 0:  vlan 1000
vf 1:  vlan 1000
vf 2:  vlan 1001
vf 3:  vlan 1001

If we tcpdump on VF3, we see all the packets, even those transmitted
on vlan 1000.

This behavior prevents to bridge VF1 and VF2 in VM2, because it will
create a loop: packets transmitted on VF1 will be received by VF2 and
vice-versa, and bridged again through the software bridge.

This patch remove the activation of VLAN Promiscuous when a VF enables
the promiscuous mode. However, the IXGBE_VMOLR_UPE bit (Unicast
Promiscuous) is kept, so that a VF receives all packets that has the
same VLAN, whatever the destination MAC address.

Fixes: 8443c1a4b192 ("ixgbe, ixgbevf: Add new mbox API xcast mode")
Cc: stable@vger.kernel.org
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Olivier Matz <olivier.matz@6wind.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 8d108a78941b..d4e63f0644c3 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -1208,9 +1208,9 @@ static int ixgbe_update_vf_xcast_mode(struct ixgbe_adapter *adapter,
 			return -EPERM;
 		}
 
-		disable = 0;
+		disable = IXGBE_VMOLR_VPE;
 		enable = IXGBE_VMOLR_BAM | IXGBE_VMOLR_ROMPE |
-			 IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE | IXGBE_VMOLR_VPE;
+			 IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE;
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
2.30.2

