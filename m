Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0CB241BFD
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 16:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgHKOCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 10:02:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54064 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728758AbgHKOC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 10:02:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597154548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=SgyJE5z7EIbqui8zp079gmXNR4ujowSS+mR+zDN1ANU=;
        b=QsiLhW8JaxALncazUpZEzs24UZ1oGyLPyNPb2qnO0NwkqRczl2WZrQ2nk0v10VJ+wU5Z04
        lxvZgH4P/qrvzCJIXlHfgetVOFum9BNJGoC0jcidWk5HH5eWyTovQruUU2tvzQbB69Fvaw
        kWQQEBEgcKhRkoVTrpv1p+Y85cexLd4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-YR_pNeCPPUqVVHDRzs8SXQ-1; Tue, 11 Aug 2020 10:02:26 -0400
X-MC-Unique: YR_pNeCPPUqVVHDRzs8SXQ-1
Received: by mail-qt1-f197.google.com with SMTP id q19so9920040qtp.0
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 07:02:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SgyJE5z7EIbqui8zp079gmXNR4ujowSS+mR+zDN1ANU=;
        b=Rxjew2/GBniU0Rm+XjiYvo56lpTt1Jw9xLSpwaM4vGh6wW7UuMx4FIwZUxv3QpBs1h
         OobkPKGIrG3jIlPfFvwcslAAAWrpnna82/gEAGJ8RbNB9SbfzNfoN8feeZLmLaZr0o5q
         fRzDI86wfpT17IhHkrCYYC09hu+jri2bhbdcYp4BZdrPnXQeJpzoVL4NxX37KFEqf4f5
         M2x9ySRfxJ0p5wyyKFRwSiR/CMf7MdCpC5LGq5qRyXyK6CN1hOcbZDJX5zCyNGeIF72E
         SrBpqYJN8fnpgPz62ziJB9DwQ/4cBkbiEnUCgSd4MX5yHVNKHO/Shde393B841+7Wps6
         xBqA==
X-Gm-Message-State: AOAM530X5rc0e/GjetPASHj+gTcSnByhVq1oq2tbq7TzcL9oiukW/cRI
        ++e31H8dH96KEoRX++j/kGWhaE1WhkUBywF384OZmGlC64X9fOBVLhax89zqvmnHT5XZndNWesK
        Q6VK899q86xA1UyCu
X-Received: by 2002:a37:a7cc:: with SMTP id q195mr1308250qke.110.1597154546449;
        Tue, 11 Aug 2020 07:02:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw366l3R5s3TvVY4PxkrGfdyG3vc+gh1kf15sl4qCHXt7bTIdrb6+TrU8ogRMSgvCoM/y7eKA==
X-Received: by 2002:a37:a7cc:: with SMTP id q195mr1308207qke.110.1597154545969;
        Tue, 11 Aug 2020 07:02:25 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id y24sm18891721qtv.71.2020.08.11.07.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 07:02:24 -0700 (PDT)
From:   trix@redhat.com
To:     jussi.kivilinna@iki.fi, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] rndis_wlan: tighten check of rndis_query_oid return
Date:   Tue, 11 Aug 2020 07:02:19 -0700
Message-Id: <20200811140219.8412-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analysis reports this problem

rndis_wlan.c:3147:25: warning: Assigned value is garbage or undefined
                wiphy->max_num_pmkids = le32_to_cpu(caps.num_pmkids);
                                      ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The setting of caps happens here, with a call to rndis_query_oid()

	retval = rndis_query_oid(usbdev,
	if (retval >= 0) {

Reviewing rndis_query_oid() shows that on success 0 is returned,
failure is otherwise.  So the retval check is not tight enough.
So tighten the retval check.  Similar problem in
rndis_wlan_get_caps().

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/rndis_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 8852a1832951..75b5d545b49e 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -3112,7 +3112,7 @@ static int rndis_wlan_get_caps(struct usbnet *usbdev, struct wiphy *wiphy)
 	retval = rndis_query_oid(usbdev,
 				 RNDIS_OID_802_11_NETWORK_TYPES_SUPPORTED,
 				 &networks_supported, &len);
-	if (retval >= 0) {
+	if (!retval) {
 		n = le32_to_cpu(networks_supported.num_items);
 		if (n > 8)
 			n = 8;
@@ -3137,7 +3137,7 @@ static int rndis_wlan_get_caps(struct usbnet *usbdev, struct wiphy *wiphy)
 	retval = rndis_query_oid(usbdev,
 				 RNDIS_OID_802_11_CAPABILITY,
 				 &caps, &len);
-	if (retval >= 0) {
+	if (!retval) {
 		netdev_dbg(usbdev->net, "RNDIS_OID_802_11_CAPABILITY -> len %d, "
 				"ver %d, pmkids %d, auth-encr-pairs %d\n",
 				le32_to_cpu(caps.length),
-- 
2.18.1

