Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52E711581F5
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 19:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbgBJSCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 13:02:55 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:38249 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbgBJSCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 13:02:53 -0500
Received: by mail-oi1-f196.google.com with SMTP id l9so10042430oii.5;
        Mon, 10 Feb 2020 10:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wXC6oc+4UBFWkewyjEg7ayTLhBGjw3S/PawgMMFUDos=;
        b=HcRb3qc8SoQSfQwOHFdR720hQXZkNdYx0zuqlUo8m1qjrPCuQsZ7Ec3ntds3zPqJeF
         z77DvcklM1fUTRz5+q4jvI4YDxHr1nCoeLxyPftg/nhjSFSFFcNMUX2/kLPrEjb8zXdt
         my74VYvFLYPkcqMzgqbFN0yBot1xZTJ28aCh5pOAdKLYJ0o5Vh5HQMnEnkHXwVPzve0l
         Izv9nAn3D9JCGQOyck6h6RhWDeDCOJ61hlggnA5jJ4T/CUlLobZ7Ppdiwhvtj2AzNIYT
         1WDudvP8+RbMKCqKSLWRZADgZh/F1ElhwwYvrSA4rBnGf3pP2AdEcKo69KUhq2/3Rzp2
         qxNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=wXC6oc+4UBFWkewyjEg7ayTLhBGjw3S/PawgMMFUDos=;
        b=BvTgoUryN4ECMt7ZuXxgXctczoCrPXVlkO2HCF+8BoGz8K6pQnp1NopZ214ROQVoNG
         7cGlPqFhwq9ISEvbMn9IKYfx1buR394kQUPDMvRP2SYhn+O+9x9qIHkFOb1IiVpwK95n
         rnd+SSakFSfyqpY6WasVuS5COBy7H2jzAYfY17tdF7cBt7UU6sg4A85gkULYE6pXmnJ+
         LZ7IH/EH+mG827uxPc6VX0doq+8tqL41NJwRfoImYbkQ08Tw6XyHBC/FIT6Rs8wPqAl+
         Rs8GOvD4sQJnKdPZiJ+jnbekaN49yQBE5jzr231+PUI2iTGqBOp7qZ/9c1seKUrcwL2+
         ex0w==
X-Gm-Message-State: APjAAAWpWCBdTr3ThzzmQFTslEKxwCTt+q4MuvjKwESX+T3Zk27AEbTe
        h3PBFGbPhvnk8K1fyyG0gJc=
X-Google-Smtp-Source: APXvYqwV2WStgiD8M3gFwGDUleN4quPrzFwpQ+YwjvtXMKu9A9zuEJhU89Fosiv5UlW/0+BW4TrL7Q==
X-Received: by 2002:aca:45c1:: with SMTP id s184mr187780oia.158.1581357773252;
        Mon, 10 Feb 2020 10:02:53 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id d131sm313031oia.36.2020.02.10.10.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 10:02:52 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pietro Oliva <pietroliva@gmail.com>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH 3/6] staging: rtl8188eu: Fix potential overuse of kernel memory
Date:   Mon, 10 Feb 2020 12:02:32 -0600
Message-Id: <20200210180235.21691-4-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210180235.21691-1-Larry.Finger@lwfinger.net>
References: <20200210180235.21691-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In routine wpa_supplicant_ioctl(), the user-controlled p->length is
checked to be at least the size of struct ieee_param size, but the code
does not detect the case where p->length is greater than the size
of the struct, thus a malicious user could be wasting kernel memory.
Fixes commit a2c60d42d97c ("Add files for new driver - part 16").

Reported by: Pietro Oliva <pietroliva@gmail.com>
Cc: Pietro Oliva <pietroliva@gmail.com>
Cc: Stable <stable@vger.kernel.org>
Fixes commit a2c60d42d97c ("Add files for new driver - part 16").
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 7d21f5799640..acca3ae8b254 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -2009,7 +2009,7 @@ static int wpa_supplicant_ioctl(struct net_device *dev, struct iw_point *p)
 	struct ieee_param *param;
 	uint ret = 0;
 
-	if (p->length < sizeof(struct ieee_param) || !p->pointer) {
+	if (!p->pointer || p->length != sizeof(struct ieee_param)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.25.0

