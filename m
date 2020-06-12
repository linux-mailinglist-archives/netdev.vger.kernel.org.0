Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914431F7771
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 13:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgFLLrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 07:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgFLLrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 07:47:42 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E4AC03E96F;
        Fri, 12 Jun 2020 04:47:42 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id v24so3646934plo.6;
        Fri, 12 Jun 2020 04:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HbZcKA6Rhm4nCGMfP9Rvp1r28EhMhEPMy4TrCL8RdRE=;
        b=F7ak+z3ro6mwAOVAPjbpePKPk1HpE4idBe9F7nEJ8IuSytT9FHSrtY2q0ypzgnaKOD
         SxNdViTlOLsFhiAtjY9J+rEU0UgsHhl1B0JZB2+POC4M/V4MZ2dcUAx79NKsBVT9VB1k
         qFT8SVXTrmGZjUqxB1b/g8d9GBBEQtFdVIuZJyLHM9A5YHF7T+/0uDdfnlrXLoqLbi2z
         ddhwEEi8iIOJJwWv7k5yLGnYeujMBfvJxjyZmELN1Prq4qcBLLTNM/vZc7XuK91jA8Wn
         VWyX/rqspi9i5IQFxTvvt+5VF4o0CQtK/bMMxqqCz5BJzE+Pkdxs2veEOZ74YEz1S7bd
         BVbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HbZcKA6Rhm4nCGMfP9Rvp1r28EhMhEPMy4TrCL8RdRE=;
        b=SbFRiZoAwwqXo3ovKLdoVl18az+q1ZLUN32lNBBKVjzH5MKGD5k/70yWX509ZZW9Zx
         GcrblN7nlIB9y2LfMq0OJdIzbpybew0RbSI5clngVgsUzZjsqO5n0JWSp7xnb1p0pmk7
         pSlv9jpuDn/SNeHuh9ZHmbnTUXhqyhBOScgPPxY7DcwjismAVgkG0tvRPOytMqCFDuy7
         mK0jB82saCRJVn0mlf42fDoWQn4Wzj0tmiqY4/OZKCKUnfE3/6oANeZFm7Zqe+8s97Z/
         ixqEqVYL1v1wly1K+LdEMPhGxo9xgU1rLDk8B49Mqfc96X4oiHwsqwm4mTfy/vrZ1yJS
         TANg==
X-Gm-Message-State: AOAM530TfZeaG9eyxFqqWHIbWiz6O5vAZL2ssPl5/L61+nbK7TchGK/Q
        MSJTtstLtNDTcVud1rFD95PuVZIZAnM=
X-Google-Smtp-Source: ABdhPJxpadzLW2w3UQlGH5ka4zIsvW0vagy1Xsm/dkF+Pkm3xn2KQUBOIoAUK2XGhw/Nq9EWCGynnA==
X-Received: by 2002:a17:90a:d3d6:: with SMTP id d22mr12533184pjw.184.1591962461401;
        Fri, 12 Jun 2020 04:47:41 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id h9sm3227266pjs.50.2020.06.12.04.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 04:47:40 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH net] i40e: fix crash when Rx descriptor count is changed
Date:   Fri, 12 Jun 2020 13:47:31 +0200
Message-Id: <20200612114731.144630-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

When the AF_XDP buffer allocator was introduced, the Rx SW ring
"rx_bi" allocation was moved from i40e_setup_rx_descriptors()
function, and was instead done in the i40e_configure_rx_ring()
function.

This broke the ethtool set_ringparam() hook for changing the Rx
descriptor count, which was relying on i40e_setup_rx_descriptors() to
handle the alloction.

Fix this by adding an explicit i40e_alloc_rx_bi() call to
i40e_set_ringparam().

Fixes: be1222b585fd ("i40e: Separate kernel allocated rx_bi rings from AF_XDP rings")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index aa8026b1eb81..67806b7b2f49 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2070,6 +2070,9 @@ static int i40e_set_ringparam(struct net_device *netdev,
 			 */
 			rx_rings[i].tail = hw->hw_addr + I40E_PRTGEN_STATUS;
 			err = i40e_setup_rx_descriptors(&rx_rings[i]);
+			if (err)
+				goto rx_unwind;
+			err = i40e_alloc_rx_bi(&rx_rings[i]);
 			if (err)
 				goto rx_unwind;
 

base-commit: 18dbd4cd9b8c957025cf90a3c50102b31bde14f7
-- 
2.25.1

