Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA84832CA9D
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 03:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhCDC6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 21:58:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25470 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231683AbhCDC6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 21:58:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614826599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2++HG/raBXrb2pYDlmO4aNJrzLxuw9/UCZRY3agwA7w=;
        b=e1T70P1walt2YjnQD/sigZXRz1Q07rW8An4AFP5lDE9cZ8QoSMqxBRL0ZFKah7/uT2yYep
        HI1m+rbnd3DVIms5UTPue1JBh3y6yQiBORbXYQZKuHtIEB6pxc1xvtA925QBAbp0OmW9Qx
        96P3yO5lzjjs5SxIOwriiljv0sbFlqg=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-NZA2lYJRMHGViU-KBDKkVw-1; Wed, 03 Mar 2021 21:56:37 -0500
X-MC-Unique: NZA2lYJRMHGViU-KBDKkVw-1
Received: by mail-pf1-f200.google.com with SMTP id t13so17148263pfg.13
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 18:56:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2++HG/raBXrb2pYDlmO4aNJrzLxuw9/UCZRY3agwA7w=;
        b=jJVwrkpc9hSUQJlae9/cH1yU7mriCN7qCSghZsntbZb842Etn9vYC5xJs47tIlMibS
         L/zYePEA2gbRP2olDWc8GulYtGGkxxHW+k5k0BwYxfS0555gvWHZFtUvNcKD/4x+d3C0
         58VhJdPEI28Tm2UnOcriLoC4Euhd7zfFYCdnL/NLiK7SWDtk9F6QNzFBJEBTGpbAiiuL
         uPkiMSzokippDlw6Abe93fJBRiPZTqAgxDbLCcSBiunX0FElpFNcIvlHFp7Dy7ZWFoTy
         ibJ8kQ+9eGxQiKloPpH8fvufuN7hODUOyADkkD/h3QQf7hX/ZQV1WSs6feiA1rxGfr/B
         QScA==
X-Gm-Message-State: AOAM533wh5A4dhB3i4NUHRP2aJR0UrfnpbHW2DkQNwPu/xYs+nr8F5bg
        BPAjZIWEb2os+u3AKi3dBItuCT1L7OToGbt81p/vDNUwkQTKOLSvoEFi1LGAxfXKzMewpmE4abu
        NJRhykP0TZX2ImJFiK0yamjHzVQAUQFqdqSiwGPQO8jmdYWjoQ9Y+f1pywDqdpoM=
X-Received: by 2002:a65:63c6:: with SMTP id n6mr1849044pgv.298.1614826596565;
        Wed, 03 Mar 2021 18:56:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxNF3mLv9QkYWO5TGYR64AQOa8lhwTHoP+hGHz+W6OXYdSFWgzrOJ+YI8ZH1CqKqskGK1p5tg==
X-Received: by 2002:a65:63c6:: with SMTP id n6mr1849016pgv.298.1614826596192;
        Wed, 03 Mar 2021 18:56:36 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gt22sm8090144pjb.35.2021.03.03.18.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 18:56:35 -0800 (PST)
From:   Coiby Xu <coxu@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kexec@lists.infradead.org, intel-wired-lan@lists.osuosl.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 3/3] i40e: use minimal admin queue for kdump
Date:   Thu,  4 Mar 2021 10:55:43 +0800
Message-Id: <20210304025543.334912-4-coxu@redhat.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304025543.334912-1-coxu@redhat.com>
References: <20210304025543.334912-1-coxu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The minimum size of admin send/receive queue is 1 and 2 respectively.
The admin send queue can't be set to 1 because in that case, the
firmware would fail to init.

Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h      | 2 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c | 9 +++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index cd53981fa5e0..09217944baa4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -66,6 +66,8 @@
 #define I40E_FDIR_RING_COUNT		32
 #define I40E_MAX_AQ_BUF_SIZE		4096
 #define I40E_AQ_LEN			256
+#define I40E_MIN_ARQ_LEN		1
+#define I40E_MIN_ASQ_LEN		2
 #define I40E_AQ_WORK_LIMIT		66 /* max number of VFs + a little */
 #define I40E_MAX_USER_PRIORITY		8
 #define I40E_DEFAULT_TRAFFIC_CLASS	BIT(0)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index d6868c7aee05..5d67fb12e576 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15327,8 +15327,13 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	i40e_check_recovery_mode(pf);
 
-	hw->aq.num_arq_entries = I40E_AQ_LEN;
-	hw->aq.num_asq_entries = I40E_AQ_LEN;
+	if (is_kdump_kernel()) {
+		hw->aq.num_arq_entries = I40E_MIN_ARQ_LEN;
+		hw->aq.num_asq_entries = I40E_MIN_ASQ_LEN;
+	} else {
+		hw->aq.num_arq_entries = I40E_AQ_LEN;
+		hw->aq.num_asq_entries = I40E_AQ_LEN;
+	}
 	hw->aq.arq_buf_size = I40E_MAX_AQ_BUF_SIZE;
 	hw->aq.asq_buf_size = I40E_MAX_AQ_BUF_SIZE;
 	pf->adminq_work_limit = I40E_AQ_WORK_LIMIT;
-- 
2.30.1

