Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0B7321128
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 08:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhBVHJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 02:09:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229549AbhBVHJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 02:09:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613977655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VDuXO5zUJ4skk3u4UbGFqeIktbCo8MisQ81CqMl1/44=;
        b=IC5KDmwRTYwIa9m5ZOcBQ0EewowhH5bONJHM+XClrcYyn066EXvudYS+VhmoLs9Xw2XqJ9
        cYPC7cZ1/TpuO6ROhxoDWIr7NgML2PDChhw6yoC/PHAoE3NPo5yjAo2h8DffTQu8GCOFW3
        WixHl0PCa0YpWQHX0IzCxBvKSQxnMbk=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-tlvv7RGANIi__YvwpBIpsw-1; Mon, 22 Feb 2021 02:07:32 -0500
X-MC-Unique: tlvv7RGANIi__YvwpBIpsw-1
Received: by mail-pl1-f200.google.com with SMTP id k13so2578295plc.3
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 23:07:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VDuXO5zUJ4skk3u4UbGFqeIktbCo8MisQ81CqMl1/44=;
        b=ssME3f0sdVuwCjfIj3/HDWkstDRuygqkrZZ6TnEr+pHDZ4WysCr8ewTLpShMPD2CKo
         jnhYAbJKN+Wi2FE83jxgWwTL8Rbvy5TQdSW821P03UXkDeni1TwiwSxwK+CfUwOaCZMB
         pftPPOCg/V9k0nCJ+r5II3KE9KL8biOwOxG1udwr4IQg1pNI9HdrzsbY3KjTz0ohHdJ5
         UbfZyEf1kM/uGzzOrars6bBwmoqjZCSWVQo5fldFN9FRSn3qcmOnmf1+0b08/gpgiFqG
         BAxaPCkmLptaqr88isQBMzO2AXSd8qYzp8hJu+9S7cB2nVkIyyyt8aWW4JQ8ziqC7Z5a
         eOjg==
X-Gm-Message-State: AOAM531osrEWedAvc/J419QoWTxW05OxQinC4p2tcz/fSbBOzmkwZJX+
        gfNKEA79mQa2GhR+ejoYV7TqZ8iAynkllKh8g8Ua3IZTNVDNSQOFn0E72A3KcIUH2KdA13YJm4y
        00TZtgTxnhFqvdCSbIQvI2HnjqDzgufuz4wWW/ZqTV9MjQRuDflKRYhe0cucfhG4=
X-Received: by 2002:a17:90a:cd06:: with SMTP id d6mr4867761pju.138.1613977650595;
        Sun, 21 Feb 2021 23:07:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz79OrKbRrtAfiD6Esm6oEGGKH8K+mEKBsf+u12b+o9o8Q4Qyg003s3d36qBlqAERFQrUMlJA==
X-Received: by 2002:a17:90a:cd06:: with SMTP id d6mr4867739pju.138.1613977650377;
        Sun, 21 Feb 2021 23:07:30 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g65sm16855068pfb.20.2021.02.21.23.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 23:07:29 -0800 (PST)
From:   Coiby Xu <coxu@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kexec@lists.infradead.org, intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH 1/4] i40e: use minimal tx and rx pairs for kdump
Date:   Mon, 22 Feb 2021 15:06:58 +0800
Message-Id: <20210222070701.16416-2-coxu@redhat.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222070701.16416-1-coxu@redhat.com>
References: <20210222070701.16416-1-coxu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the number of the MSI-X vectors to 1. When MSI-X is enabled,
it's not allowed to use more TC queue pairs than MSI-X vectors
(pf->num_lan_msix) exist. Thus the number of tx and rx pairs
(vsi->num_queue_pairs) will be equal to the number of MSI-X vectors,
i.e., 1.

Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1db482d310c2..069c86e2f69d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6,6 +6,7 @@
 #include <linux/pci.h>
 #include <linux/bpf.h>
 #include <generated/utsrelease.h>
+#include <linux/crash_dump.h>
 
 /* Local includes */
 #include "i40e.h"
@@ -15000,6 +15001,14 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_switch_setup;
 
+	/* Reduce tx and rx pairs for kdump
+	 * When MSI-X is enabled, it's not allowed to use more TC queue
+	 * pairs than MSI-X vectors (pf->num_lan_msix) exist. Thus
+	 * vsi->num_queue_pairs will be equal to pf->num_lan_msix, i.e., 1.
+	 */
+	if (is_kdump_kernel())
+		pf->num_lan_msix = 1;
+
 	pf->udp_tunnel_nic.set_port = i40e_udp_tunnel_set_port;
 	pf->udp_tunnel_nic.unset_port = i40e_udp_tunnel_unset_port;
 	pf->udp_tunnel_nic.flags = UDP_TUNNEL_NIC_INFO_MAY_SLEEP;
-- 
2.30.0

