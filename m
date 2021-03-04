Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3219932CA9E
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 03:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhCDC6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 21:58:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59707 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231659AbhCDC5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 21:57:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614826589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=27t46XHebLzRKwK6kiEaa5rYWovZp6L1OdarLDSHed8=;
        b=XG6nlHDlyWhj+tezDz3Z5JVZKUrG7+B1021sdU8VxuLEm7tP79gG+ZgnjL6SGC+1h385t0
        HwZv01CVoVb+7yz2QmrGlEvBjh5s8J/N4m0iJ0UNl8wtFKjBew5LZwRXp6L+ht3vNXJQo5
        WTKHpviY91Rh0ggxQWevZEc9lSW77hQ=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-LuKSLyLYNciTZppC4oGqmQ-1; Wed, 03 Mar 2021 21:56:27 -0500
X-MC-Unique: LuKSLyLYNciTZppC4oGqmQ-1
Received: by mail-pf1-f200.google.com with SMTP id x63so17172392pfb.12
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 18:56:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=27t46XHebLzRKwK6kiEaa5rYWovZp6L1OdarLDSHed8=;
        b=M6rSdcUoaBuDdmn/AiX/jD2d5UULSaso1L+6p3gCl/PWmIYmlYJAqFPfJqvMlXocbC
         VrrV8DsgK9p03a5nTf+PqmJ6wcT9Yh+GQpcJFFtmrece2TJAMrrK9tpFHR9VhG4vhplu
         DpbOYfZoiGsvkk7v3SZ/Gs+oC//Rq8m1Qjil6ji+keys/QJGJs06uqOf8RCvl3RcuPvj
         hr1zqg4V7bmaGh85etgTzWRiEsMNp6iIgm70w4u6kgaPhsVU+8oRJYpp8Bw0gjXk7V82
         0U3W4UwCNsaK5H5nGBOJGat0Y09A1l8BqzXoqE5yt1w0lZjcMwHKe24aeaaourhXcc98
         kBvQ==
X-Gm-Message-State: AOAM530qm9HKwto1n7lAebNyrAS1ZqSQkhE+6hwhHCfVd3VftHvdEf/o
        2L3zNuI1PVaWigcrpIqdviCetYruVmqfZA/7IUN8jU+vwGJ2EdJSp+JG7AVGPD/RJb54rSg8CUi
        J/+0l28Na15+w99Ygm4+8W4DJLBycZrbDCl+rQV9TizgWV8YVDQC11D60Z3ri0uY=
X-Received: by 2002:a63:511:: with SMTP id 17mr1722721pgf.173.1614826586304;
        Wed, 03 Mar 2021 18:56:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy5O+3/Y8estRnruVL7Uuv/wewORRlTvTGikebpvnF1FMcUf9zFn3m1kmHhqr7CddFgmmra6A==
X-Received: by 2002:a63:511:: with SMTP id 17mr1722704pgf.173.1614826586086;
        Wed, 03 Mar 2021 18:56:26 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w188sm25973503pfw.177.2021.03.03.18.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 18:56:25 -0800 (PST)
From:   Coiby Xu <coxu@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kexec@lists.infradead.org, intel-wired-lan@lists.osuosl.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 2/3] i40e: use minimal rx and tx ring buffers for kdump
Date:   Thu,  4 Mar 2021 10:55:42 +0800
Message-Id: <20210304025543.334912-3-coxu@redhat.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304025543.334912-1-coxu@redhat.com>
References: <20210304025543.334912-1-coxu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the minimum of the number of descriptors thus we will allocate the
minimal ring buffers for kdump.

Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 77bf8c392750..d6868c7aee05 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -11029,6 +11029,11 @@ static int i40e_set_num_rings_in_vsi(struct i40e_vsi *vsi)
 		return -ENODATA;
 	}
 
+	if (is_kdump_kernel()) {
+		vsi->num_tx_desc = I40E_MIN_NUM_DESCRIPTORS;
+		vsi->num_rx_desc = I40E_MIN_NUM_DESCRIPTORS;
+	}
+
 	return 0;
 }
 
-- 
2.30.1

