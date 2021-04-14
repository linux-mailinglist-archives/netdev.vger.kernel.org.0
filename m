Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D3D35EEB7
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 09:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349731AbhDNHqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 03:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349671AbhDNHqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 03:46:42 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E883C061756
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 00:46:20 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id c8-20020a9d78480000b0290289e9d1b7bcso4473510otm.4
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 00:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HE1GrmBu4V6WQXUq6gjFYYmeNvbtG5Wm01EiBjvhCwk=;
        b=sE/A9dan6z2dFFoDGGs+eArXe3EE63A/eLyON1BvTN5Ozs1pzgmPTtw8wbX/Ldua5i
         OGEEEg0TNEJrF1FSbfk46bwFiR+3JBrMQ6SHsrMR99JrNSeKOfJm+i6y358aRrWSk62l
         hyplA9HxuVaUiT2hNpaKTggrtRTJ3F/VCoZdDOmkAElyVuWw/rAd0Y+0PApMnnxErmU7
         b3cTbx52NQuT/e1C5KrqXAyPfNmrdZ5nyET1dgWPT4R5gV1DJ+3Q6jQhJ7M4VsgK2ROb
         ICfQkHZHDCQQGsga4VJQ+v7C2+GcDt/s/C8kkhAKd4WM5w4UZPaWKlEc3ypYtiffOuUc
         LftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HE1GrmBu4V6WQXUq6gjFYYmeNvbtG5Wm01EiBjvhCwk=;
        b=XeYjD3FlUuPjlpicNMyVtbsWlcAbuwVY+2+IVVnNf0MNKwoZYsGC52DzpZq2dMaAiR
         As1lu/FbZxVOwSQFFun4yVyaqBbgVOh/OuySY13UiIsvl6+Ei1uR501b9tlZUtFta/ZT
         L34j2c4p0lNbF4oybeK3nay71575DRi2BJnUkYpXbqt1neL3SPKravaHvaLn8LYD1CJA
         dS6stN/WgpEdrXL7S/Q5i6sOpFlrPVcNaYkJvWvGmlCOAwdlKhyIrONN7sF9MkyXT3gV
         jvN5WN267Mi9HzhTrHdVkEIwRKM3xzSPh5X4JCRiD9vh5lw8qGRO4ScK9EFjMhoTpsHY
         4Sdw==
X-Gm-Message-State: AOAM5333TOz5SBgUqJaqwz7NOE/vbQ8czLPTA8hG5lpJeP0D85wfO0cl
        Bi9jpK9wx3+kEK2uMTVCWclkFCDRtCZabQ==
X-Google-Smtp-Source: ABdhPJz9qhiup/78vKU7GJ8HtprfB3H+PwkSOUeuV5fhkPAR74JkQgx/mkJG16SZa5Tk1W8koQIQcQ==
X-Received: by 2002:a9d:1e83:: with SMTP id n3mr18877296otn.233.1618386379484;
        Wed, 14 Apr 2021 00:46:19 -0700 (PDT)
Received: from pear.attlocal.net ([2600:1700:271:1a80:7124:9f6b:8552:7fdf])
        by smtp.gmail.com with ESMTPSA id w3sm2833015otg.78.2021.04.14.00.46.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Apr 2021 00:46:19 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net 1/3] ibmvnic: avoid calling napi_disable() twice
Date:   Wed, 14 Apr 2021 02:46:14 -0500
Message-Id: <20210414074616.11299-2-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210414074616.11299-1-lijunp213@gmail.com>
References: <20210414074616.11299-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__ibmvnic_open calls napi_disable without checking whether NAPI polling
has already been disabled or not. This could cause napi_disable
being called twice, which could generate deadlock. For example,
the first napi_disable will spin until NAPI_STATE_SCHED is cleared
by napi_complete_done, then set it again.
When napi_disable is called the second time, it will loop infinitely
because no dev->poll will be running to clear NAPI_STATE_SCHED.

To prevent above scenario from happening, call ibmvnic_napi_disable()
which checks if napi is disabled or not before calling napi_disable.

Fixes: bfc32f297337 ("ibmvnic: Move resource initialization to its own routine")
Suggested-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 110a0d0eaabb..2d27f8aa0d4b 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1149,8 +1149,7 @@ static int __ibmvnic_open(struct net_device *netdev)
 
 	rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_UP);
 	if (rc) {
-		for (i = 0; i < adapter->req_rx_queues; i++)
-			napi_disable(&adapter->napi[i]);
+		ibmvnic_napi_disable(adapter);
 		release_resources(adapter);
 		return rc;
 	}
-- 
2.23.0

