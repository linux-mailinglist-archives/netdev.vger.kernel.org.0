Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F3B321131
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 08:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhBVHJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 02:09:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58641 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230087AbhBVHJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 02:09:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613977681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8cGC74PMCnaWbBAWCVUBDXRxKgEXEKkWJtgVHkIGS/0=;
        b=Hu8BhsvQqaMrksO9Xgnac+qPEsN4nEaIiKgIEN3UEUwTTJjoiNkBJ+3MLc0L5dNAz0nJT1
        ImFyLOPO2o67FRnu8RuZ0CeNp4J8/WT/mpdi0rO90h96P98Bk5/v0gET+ImT/uijVPKtaa
        YL1vjxsupzWImN2GAvQ/PXVHRhHZsKY=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-qn0aWhBVP_KzOCfSzopfAw-1; Mon, 22 Feb 2021 02:07:59 -0500
X-MC-Unique: qn0aWhBVP_KzOCfSzopfAw-1
Received: by mail-pf1-f199.google.com with SMTP id 137so6656290pfw.4
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 23:07:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8cGC74PMCnaWbBAWCVUBDXRxKgEXEKkWJtgVHkIGS/0=;
        b=aVLKUcNN10+QHhe5qPpezXFC+DMsTq0KmpHrbCD279D2YK39Ci6M1Bji5JEGIIKi4y
         IOs2ov6ct6fQtbEpma6mtSwxvFvrabW8p36/1YnB+bHSPQ4LWACA+1sl2rFw8KKhtO43
         VJW5QVuQKfPsPs9EeG15LZJNRiZdZl254tTAarHWPKi4Ll/Z5mjAGPa3yzC8e2PXqEEB
         +kwHoBMyQ6TysgCUYnI0rIVxuxo2MNX3bnm1b+U6fAhbGT6i1lZCR813oLOunqSHnDjS
         BP3Fb6TtLze+LjQRhEEYc2JUks0WepEHoZaNOUa12xe6Md/pPwuMzZNOEjUtZ9+U953e
         ce5A==
X-Gm-Message-State: AOAM531qUCKccrEb0r2Fp102tCXZqRWHSqtWF/n8BvJcYQMwm0mViG6p
        Xp6mn7m9JkETvsmk+ZmlHgujzMFh/W/8hLx78CsHdem2U/nbD1U94j9QiMBPFPjmYVjnujwwfLD
        a5D0HkPv2DwGhXfEi/aCTh7pzxbbPMsvKq1NSzTStAWgZCF2viG/+iBFMjsixpLY=
X-Received: by 2002:a63:3602:: with SMTP id d2mr18862407pga.81.1613977677979;
        Sun, 21 Feb 2021 23:07:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzG0zRT+B2eqBSHJCG+woLse614WOgfmD0XJ5e3O9heRqpM5jj6GbtUXuwOa2JP1tEgm2+OsA==
X-Received: by 2002:a63:3602:: with SMTP id d2mr18862385pga.81.1613977677597;
        Sun, 21 Feb 2021 23:07:57 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ig12sm8527195pjb.36.2021.02.21.23.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 23:07:57 -0800 (PST)
From:   Coiby Xu <coxu@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kexec@lists.infradead.org, intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH 4/4] i40e: don't open i40iw client for kdump
Date:   Mon, 22 Feb 2021 15:07:01 +0800
Message-Id: <20210222070701.16416-5-coxu@redhat.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222070701.16416-1-coxu@redhat.com>
References: <20210222070701.16416-1-coxu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

i40iw consumes huge amounts of memory. For example, on a x86_64 machine,
i40iw consumed 1.5GB for Intel Corporation Ethernet Connection X722 for
for 1GbE while "craskernel=auto" only reserved 160M. With the module
parameter "resource_profile=2", we can reduce the memory usage of i40iw
to ~300M which is still too much for kdump.

Disabling the client registration would spare us the client interface
operation open , i.e., i40iw_open for iwarp/uda device. Thus memory is
saved for kdump.

Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 drivers/net/ethernet/intel/i40e/i40e_client.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index a2dba32383f6..aafc2587f389 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -4,6 +4,7 @@
 #include <linux/list.h>
 #include <linux/errno.h>
 #include <linux/net/intel/i40e_client.h>
+#include <linux/crash_dump.h>
 
 #include "i40e.h"
 #include "i40e_prototype.h"
@@ -741,6 +742,12 @@ int i40e_register_client(struct i40e_client *client)
 {
 	int ret = 0;
 
+	/* Don't open i40iw client for kdump because i40iw will consume huge
+	 * amounts of memory.
+	 */
+	if (is_kdump_kernel())
+		return ret;
+
 	if (!client) {
 		ret = -EIO;
 		goto out;
-- 
2.30.1

