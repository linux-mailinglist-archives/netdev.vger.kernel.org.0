Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B942E318550
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 07:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhBKGpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 01:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhBKGox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 01:44:53 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB5FC06178C
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:43:50 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id s107so4246758otb.8
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gr0eKrk4K/BYOP1u+/BzgsKv0MAbRZ7OTW4YmnTfTpo=;
        b=PgaObfFFeiEuMUsIhUiMBBsan4v1M0PI7funcgfHEECv11tDFJfX+J6TFt/Q7TGCwS
         J+zxvsNHOf2ymMcvx0gxbh2MeXx9XzhrIKzImjI/aVkvU018in9YEtbXgYUaAGj7Aygu
         b1YJe6SCvKAncDwJDnYk1jZqJOT+DF6QYdS+kZNGJ/J5vJ6+ibpMx/GMCMl66WePfTEO
         A7ExIRU0Uc77Tw27CvSfMK1wFcaQGkXahm9+eYs7mVkfASrjVC79p02DEWh5HWan2Zxm
         69624dn+hO6nPK40Omuhk2xM2Kz1KmYbHJVzAT10gmB6JTPxF4I0dxMbleYCH/OK/UIZ
         jH+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gr0eKrk4K/BYOP1u+/BzgsKv0MAbRZ7OTW4YmnTfTpo=;
        b=cVPuBkxyKAebTWiZYZKmhtXGHvVKgbpbstArW3DwPylh7Nqcym2AqV9Ba1IN9IQoQh
         aPdlJcdBdN1h55b4Hfgyi1Jr2fqLW+1JRxxLKbfFYvvS3qv4Z5+o1xpbALn5jWvkyCM/
         ev2TPHvK1rA/L5b4Bj02qhHb7sQDMaWKRzIs1MciplqLPIr3fPWZMVKTgD6A6pCie+Hu
         8CVWverkFfQXAMTDiDr1aCAbPLYg0rnqhwLD3hQctYYSoDONjyJYctcDtfigw4DFiKuJ
         j7p0wvY25mvO6BUHIDF4ullBmiS4N2Rigk6jVSfQtj6kzgUzGZFZRda0sGEHWFXjE9ib
         EpVQ==
X-Gm-Message-State: AOAM531RxtaLdQZupX3tDnuMoZqHI8PLhZ8DJYAYw4OnYR0CLLypMywE
        q1spaHyuXW+SFBRHpSalkBp7wxhvk7A=
X-Google-Smtp-Source: ABdhPJwp0+ysAWLR45EfHY2LZA5ls6JeqwQyVvbTyL5YVCFTUwXxVo20TNi69t9Q2n4Zefb/X5wYAg==
X-Received: by 2002:a05:6830:2106:: with SMTP id i6mr4707996otc.260.1613025829737;
        Wed, 10 Feb 2021 22:43:49 -0800 (PST)
Received: from pear.attlocal.net ([2600:1700:271:1a80:302d:c724:5317:9751])
        by smtp.gmail.com with ESMTPSA id y65sm993375oie.50.2021.02.10.22.43.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Feb 2021 22:43:49 -0800 (PST)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next v2 8/8] ibmvnic: prefer strscpy over strlcpy
Date:   Thu, 11 Feb 2021 00:43:25 -0600
Message-Id: <20210211064325.80591-9-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210211064325.80591-1-lijunp213@gmail.com>
References: <20210211064325.80591-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix this warning:
WARNING: Prefer strscpy over strlcpy - see: https://lore.kernel.org/r/CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL=V6A6G1oUZcprmknw@mail.gmail.com/

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 778e56e05cd7..1774fbaab146 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2633,9 +2633,9 @@ static void ibmvnic_get_drvinfo(struct net_device *netdev,
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(info->driver, ibmvnic_driver_name, sizeof(info->driver));
-	strlcpy(info->version, IBMVNIC_DRIVER_VERSION, sizeof(info->version));
-	strlcpy(info->fw_version, adapter->fw_version,
+	strscpy(info->driver, ibmvnic_driver_name, sizeof(info->driver));
+	strscpy(info->version, IBMVNIC_DRIVER_VERSION, sizeof(info->version));
+	strscpy(info->fw_version, adapter->fw_version,
 		sizeof(info->fw_version));
 }
 
-- 
2.23.0

