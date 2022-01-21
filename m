Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C96495885
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 04:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbiAUDTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 22:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiAUDTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 22:19:18 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FB5C061574;
        Thu, 20 Jan 2022 19:19:18 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id e28so3217297pfj.5;
        Thu, 20 Jan 2022 19:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CGitTWNmCApPfercouJnCpmunwtb4U1B1S9nDxOAfUY=;
        b=qPM5pBm7UJ+1/zUu7fTPbIs4gTRtuFzYxiovsxCPfquDFxKngb4lW73EArboB9uIZF
         8+479yhIE1ld3jPnfSZF1k0ZVmxuPMUj1Wwztib2o0DayeCD+1CifryLSKiDPqgBw75W
         ApkM4UnKuVbTzUUTVX2qUwJNWpnvATsOOH2YiaLV0ilX2XpI7fDpuTK+xG63wFa7a2kG
         UYW3YaN2+waOSrj1jjQ9cWHGPOWL03oeM1OZNbZt/0UYOclcDpaoESpFxnyDKoiVc6xP
         DMb9UUUyzBcBKa0w9tUHROXPzwGXZcxC/9M3lxHFREkqvOYoI4S3u1QzFcJ4VI41/fGy
         GP9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CGitTWNmCApPfercouJnCpmunwtb4U1B1S9nDxOAfUY=;
        b=qBF2l3d0HsOzWeBp1DSp4bU/Vm1GTNBn05FUlIVy7d+fbk19F3vOV+3ox3M7hcM91S
         TMpcaogKGb/HjlOfuVo6jBiXl4drS6D46FQ/yBBI0G9QVjXgryfonWtyKn1MSTYS73a7
         HT9MalVXMHM5YP/XF28Ystm7luuyAsPEmRMb9ZyPPA9xwqpFHw8iHKd7GtK5HkMkRtls
         qls3xrYwp/46X+ulOWK+55J0Gev1+k4XTNF1nPkkNJN2k7QXRREmEubHpZkl4l+sTIE9
         t5ZsffgXnIADXX6eE3UsbPTzISAvblGBKrNd3elW5HfXMpcnzdC2WyDZ4MKs1B6Ujasg
         VaZg==
X-Gm-Message-State: AOAM533R5c0Bz/VNgKlLqLGxWN2NyPZWSa05jlp7LowDG7jhKQLwOpvn
        siCdVk7ZnJSSzwFDQ9ve1Oo=
X-Google-Smtp-Source: ABdhPJwlPcPlvr9d1mrN9bYOrBucfw4DnJ6Okl6+ehJ101LhQHyGhhn9kV/rKDA4z174v/cOCdSX3w==
X-Received: by 2002:a63:6e4e:: with SMTP id j75mr1505084pgc.293.1642735158089;
        Thu, 20 Jan 2022 19:19:18 -0800 (PST)
Received: from localhost.localdomain ([106.11.30.62])
        by smtp.gmail.com with ESMTPSA id t8sm4705456pfg.210.2022.01.20.19.19.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jan 2022 19:19:17 -0800 (PST)
From:   ycaibb <ycaibb@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ycaibb@gmail.com
Subject: [PATCH] inet: missing lock releases in igmp.c
Date:   Fri, 21 Jan 2022 11:19:11 +0800
Message-Id: <20220121031911.5570-1-ycaibb@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ryan Cai <ycaibb@gmail.com>

In method igmp_mcf_get_next, the lock state->im->lock is not released when likely(psf) returns true.

Signed-off-by: Ryan Cai <ycaibb@gmail.com>
---
 net/ipv4/igmp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index d2e2b3d18c66..db6c7bfba1b8 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2903,6 +2903,7 @@ static inline struct ip_sf_list *igmp_mcf_get_first(struct seq_file *seq)
 			if (likely(psf)) {
 				state->im = im;
 				state->idev = idev;
+				spin_unlock_bh(&im->lock);
 				break;
 			}
 			spin_unlock_bh(&im->lock);
-- 
2.33.0

