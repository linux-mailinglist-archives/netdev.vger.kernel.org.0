Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98F73D3C3F
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbhGWOdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 10:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbhGWOc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 10:32:59 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DC0C061757
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 08:13:32 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so4144217pjh.3
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 08:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jakma-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=iWZerGbwjoVxQTeT8tsyEDW75uJrbUDtI+N1FFthDTg=;
        b=g1RWklvlDsE5+9gzktg7nmbgBo+X8LnS52WfIcD6Lu4RFPzrWdcC7n/yxC60YF4FBi
         kq85gfolhOluRDRBf+nQJPkw8BGwrqq4Mtt3zsa+wXwbIffGaxoplkOyyGj7zqjWYaU/
         U053lODXGswYbYI/kOAurIzpou6PR3uzwE7hYpHZdiDIEh5zVQIngeI0eDWyjr8HW1BZ
         qA5uWNesohmtH6+JbuNrxxI8eCPgDEPuJ1hSB2kre5qsbZfWckpVREHVPnRMYp32jwWx
         tvLn01D3/FFa3rEA0XAnnxI3+Hq7qu/1QGqPDFSOxNts0VQN1phY6+PVPhdIPzPnRan+
         9A8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=iWZerGbwjoVxQTeT8tsyEDW75uJrbUDtI+N1FFthDTg=;
        b=g4NSLnKrbsCsq2M3ZUO0IK1bj1trVIdAPJ6UpuyVskGg5O5oTsNci1OYktGTVBzELd
         RmCipMECcOFLHj9gazlGHQKXUHZRtDN6YA+uqSFg0MU5l0E78XZQ1mkTvp8lH8HFr7l7
         yOwL7Wes/fs56CsNn3/JPa6LqaGmOy0tCdtIJi8upwQ+UdVjhDFQRQ6eirbiPuARu2hk
         Fx9g5NN/zzY2ovihInjsHMf8NFYIeTAlqTGbN3XM/Nb5rcxdxYKSmVONfQqd26o9Jj9/
         YMGaIqzH2DbPBjmLgee71pecr+6WsGWx13/T4qMqbKWfYEc7kkXqzTzqK/N36CcNnZle
         lnNQ==
X-Gm-Message-State: AOAM532BwnC7n5TX4Kyw1q00YvSJyubZve5jBnsATYpX3TwS+p6rV9xx
        270jL3z7e7H8NpL56+hJarxBnDm6obKjb3AR
X-Google-Smtp-Source: ABdhPJyV7tNeVh70mJgCArUxEWTbwHAlQUE1T7Lu+hEu4RF4i/yle+Q8PmCvI5MbuHn9dyDqX69BxQ==
X-Received: by 2002:a17:902:9b8d:b029:12a:d79e:6d40 with SMTP id y13-20020a1709029b8db029012ad79e6d40mr4396775plp.47.1627053211869;
        Fri, 23 Jul 2021 08:13:31 -0700 (PDT)
Received: from sagan.jakma.org ([185.97.239.6])
        by smtp.gmail.com with ESMTPSA id m2sm14894639pja.52.2021.07.23.08.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 08:13:31 -0700 (PDT)
From:   Paul Jakma <paul@jakma.org>
To:     netdev@vger.kernel.org
Cc:     Paul Jakma <paul@jakma.org>, Kangjie Lu <kjlu@umn.edu>,
        Shannon Nelson <shannon.lee.nelson@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] NIU: fix incorrect error return, missed in previous revert
Date:   Fri, 23 Jul 2021 16:13:04 +0100
Message-Id: <20210723151304.1258531-1-paul@jakma.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210721.084759.550228860951288308.davem () davemloft ! net>
References: <20210721.084759.550228860951288308.davem () davemloft ! net>
Reply-To: paul@jakma.org
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 7930742d6, reverting 26fd962, missed out on reverting an incorrect
change to a return value.  The niu_pci_vpd_scan_props(..) == 1 case appears
to be a normal path - treating it as an error and return -EINVAL was
breaking VPD_SCAN and causing the driver to fail to load.

Fix, so my Neptune card works again.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Shannon Nelson <shannon.lee.nelson@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>
Fixes: 7930742d ('Revert "niu: fix missing checks of niu_pci_eeprom_read"')
Signed-off-by: Paul Jakma <paul@jakma.org>
---
 drivers/net/ethernet/sun/niu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 74e748662ec0..860644d182ab 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -8191,8 +8191,9 @@ static int niu_pci_vpd_fetch(struct niu *np, u32 start)
 		err = niu_pci_vpd_scan_props(np, here, end);
 		if (err < 0)
 			return err;
+		/* ret == 1 is not an error */
 		if (err == 1)
-			return -EINVAL;
+			return 0;
 	}
 	return 0;
 }
-- 
2.31.1

