Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E83836900C
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 12:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242048AbhDWKFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 06:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242019AbhDWKFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 06:05:47 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04101C06174A
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 03:05:11 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id j5so46806365wrn.4
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 03:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qnu8+xANZ9fCEYBDMJeqZXufIm484UwdqLlibJM+xGg=;
        b=gTywlByTY8QOwBs3ivbEvMqShqcmbc4tS9l9NuuXjPrkAexiFBUVJjPIZWN6Pqi2Ek
         ly2V/tpirLtOQD9WJ+jvJ2Sj6Gn3qkCh9idbNI5dBkXGK2lYa7esVN2E5GvOlfJ2mDG0
         i0OiVaFxW6Ij7RpgIF0CqP8TqN5wPdtoHIUvTMuudrupWItd1FrHaV7lqnfebOwumtsy
         p+XHdCPypdhizZI0H413GnC/MvtTWMZ0WirnT1dBwIPviLe3hVLUOv1e4mCEwKUZFqGW
         92wy55YvAlADM4FjY34V+mLELpOI5zbh35QAZeqtLDJGdSvULAbLh20HNlD7vcfY33E9
         4Dog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qnu8+xANZ9fCEYBDMJeqZXufIm484UwdqLlibJM+xGg=;
        b=Gew0mmqmGsRQLKgIFMZAsaTllgZjSAZs6nbwsxEEHHxHilSbo94fuWrIsjmegWvmeR
         YjobafSy8mnFUbiKhnyIpixCX83fjVeEl35UKVgOLIMJGPMEvAGvqs+5Hda5NFar09hj
         c1DAt8brRjzeXknIV745UPogqTPeJ3CACdsJYR8TFdCdsqYTk2hX5mflLVsq8Xk0LbnB
         wZkV+LnhxzDbHn64wQ9MAZ0kn5g1pfrSj5MBcLFnG2Ln78vinUZuqmTc/EnyTNg4814t
         pIg3/z08W1ktL+DHq9osCt5upBnksO5uK5sPZFsfSJLYbBXP5LA11BT2GBdVy0hNga09
         MAOQ==
X-Gm-Message-State: AOAM532zab+Gwq5So3ldndr5m7K7YD3/4A24mJSzBrkzcok9TwRZe0Wh
        mCahJB3f+tXwcyQE6scxf7Q=
X-Google-Smtp-Source: ABdhPJzii5OWQkCLiIFA+BGj7w6KHZ66O4nqK+QYLm0i/NTPCGM5wB3mN8Lhidzx/+Dt8uLt6Jxcww==
X-Received: by 2002:a5d:47c1:: with SMTP id o1mr3672237wrc.216.1619172309744;
        Fri, 23 Apr 2021 03:05:09 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id t12sm8599481wrs.42.2021.04.23.03.05.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Apr 2021 03:05:09 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     netdev@vger.kernel.org, brouer@redhat.com
Subject: [PATCH intel-net 5/5] ixgbevf: add correct exception tracing for XDP
Date:   Fri, 23 Apr 2021 12:04:46 +0200
Message-Id: <20210423100446.15412-6-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210423100446.15412-1-magnus.karlsson@gmail.com>
References: <20210423100446.15412-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add missing exception tracing to XDP when a number of different
errors can occur. The support was only partial. Several errors
where not logged which would confuse the user quite a lot not
knowing where and why the packets disappeared.

Fixes: 21092e9ce8b1 ("ixgbevf: Add support for XDP_TX action")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 449d7d5b280d..b38860c48598 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1067,11 +1067,14 @@ static struct sk_buff *ixgbevf_run_xdp(struct ixgbevf_adapter *adapter,
 	case XDP_TX:
 		xdp_ring = adapter->xdp_ring[rx_ring->queue_index];
 		result = ixgbevf_xmit_xdp_ring(xdp_ring, xdp);
+		if (result == IXGBEVF_XDP_CONSUMED)
+			goto out_failure;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough; /* handle aborts by dropping packet */
 	case XDP_DROP:
-- 
2.29.0

