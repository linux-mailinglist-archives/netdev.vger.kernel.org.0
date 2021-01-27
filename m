Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598E6306223
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 18:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343824AbhA0RfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 12:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343971AbhA0Rdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 12:33:51 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB4EC061574;
        Wed, 27 Jan 2021 09:33:11 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id e15so2395024wme.0;
        Wed, 27 Jan 2021 09:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JX/8GTplWaX87X7dc46w0AUNuF+gLdIS0hovfiOe7V4=;
        b=NVC4G0g8320myIaVop1R6qvXSC7iaeFuH5Vi+k8uwTU7yA84d30FADqZA2jRTXn/HO
         s4y9wzRP3q74zSx/yAzuZoM9+r0+6sS6vfuELFtp7V5+Zc03BX4fpqtsGZT44q3gO519
         HRuodDTpJjJLaWPfNYhXjP/7d0NS6NQKttZNXvUTOZn0f6f3i5Zsut9kn8h1pxcUb1Ea
         mPo5lhHDZpKPeTdGtvRL1Lig/5+KWROxphsIFRt/ML5pgFN2zvSwMiLAPFJXvS2DxEXG
         pDUv09yeW3J2NWgSxDG9rqSVJAhUI9YnW7EYwsdfq18mEh8Uzgynqw6RxYSMQgFQgStV
         hwqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=JX/8GTplWaX87X7dc46w0AUNuF+gLdIS0hovfiOe7V4=;
        b=V2QUZXBg7xP+9mEbwdSXG0/qfEjIEGCodskU7DQW8MHyvufM7J1xXLONUaPIYwfdlT
         8S1eHqOEwXil0FU4y22w0DAZGYSw5zwYZAfooYY4SbxyJLTaINjRiceNdbwbYI2GEpVl
         eZj0SqhoheSONh96BLwVVu9et6S+fG9YgqcurR7s6AKJjQJ91/FKmgR7iCgzgykrzn0V
         lS9gbv9FziAeuVGKR7e+km1jPWnHGRPhVG3lj8ZTzAsql786RLk6Ek/phLb5iIxqqfa/
         arVT4TIWJSeYAs1iaZs+pK0N0xiHrJswBWsohIBuwcocIr+zu9D4NRANQZuYuZLhRIo6
         6xDg==
X-Gm-Message-State: AOAM533b03LDxxxnewFoEWCUnx9F++bYPSxKsHIRdFQ89KTfyV/mwp7F
        /UHkpH5KrcrJIeENeNiBltu3j0awgOu5Eg==
X-Google-Smtp-Source: ABdhPJxBtVSi+xCizygfb14pKc6WvGCVnCcwB0rX+r0WLVUKQi9y8mOOPFVEQJeCpUbN1nRhUyvlvA==
X-Received: by 2002:a1c:f415:: with SMTP id z21mr5226267wma.114.1611768790015;
        Wed, 27 Jan 2021 09:33:10 -0800 (PST)
Received: from stitch.. ([80.71.140.73])
        by smtp.gmail.com with ESMTPSA id m8sm3768636wrv.37.2021.01.27.09.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 09:33:09 -0800 (PST)
Sender: Emil Renner Berthing <emil.renner.berthing@gmail.com>
From:   Emil Renner Berthing <kernel@esmil.dk>
To:     netdev@vger.kernel.org
Cc:     Emil Renner Berthing <kernel@esmil.dk>,
        Mitchell Blank Jr <mitch@sfgoth.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: atm: pppoatm: use new API for wakeup tasklet
Date:   Wed, 27 Jan 2021 18:32:56 +0100
Message-Id: <20210127173256.13954-2-kernel@esmil.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210127173256.13954-1-kernel@esmil.dk>
References: <20210127173256.13954-1-kernel@esmil.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts the driver to use the new tasklet API introduced in
commit 12cc923f1ccc ("tasklet: Introduce new initialization API")

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
---
 net/atm/pppoatm.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c
index 5f06af098390..3e4f17d335fe 100644
--- a/net/atm/pppoatm.c
+++ b/net/atm/pppoatm.c
@@ -101,9 +101,11 @@ static inline struct pppoatm_vcc *chan_to_pvcc(const struct ppp_channel *chan)
  * doesn't want to be called in interrupt context, so we do it from
  * a tasklet
  */
-static void pppoatm_wakeup_sender(unsigned long arg)
+static void pppoatm_wakeup_sender(struct tasklet_struct *t)
 {
-	ppp_output_wakeup((struct ppp_channel *) arg);
+	struct pppoatm_vcc *pvcc = from_tasklet(pvcc, t, wakeup_tasklet);
+
+	ppp_output_wakeup(&pvcc->chan);
 }
 
 static void pppoatm_release_cb(struct atm_vcc *atmvcc)
@@ -411,8 +413,7 @@ static int pppoatm_assign_vcc(struct atm_vcc *atmvcc, void __user *arg)
 	pvcc->chan.ops = &pppoatm_ops;
 	pvcc->chan.mtu = atmvcc->qos.txtp.max_sdu - PPP_HDRLEN -
 	    (be.encaps == e_vc ? 0 : LLC_LEN);
-	tasklet_init(&pvcc->wakeup_tasklet, pppoatm_wakeup_sender,
-		     (unsigned long)&pvcc->chan);
+	tasklet_setup(&pvcc->wakeup_tasklet, pppoatm_wakeup_sender);
 	err = ppp_register_channel(&pvcc->chan);
 	if (err != 0) {
 		kfree(pvcc);
-- 
2.30.0

