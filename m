Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 844C91186DE
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 12:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbfLJLox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 06:44:53 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37980 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbfLJLos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 06:44:48 -0500
Received: by mail-lj1-f194.google.com with SMTP id k8so19469742ljh.5;
        Tue, 10 Dec 2019 03:44:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F3MUQ+LoTrV2G6U9Nx6QBaOEztQsCtDS4fhJs3lb6uk=;
        b=WQjHRa1Rd9HrJDvYvp+V5fv1u0o04jD+0dPjwlccq09x1hliNur938by9zCheSeX/N
         jpmtRaKQVjXuBsAluezv6budmd/28xuiVRf2znnpT/3xGF+ILsOEn7WgsHVHU9d+EaQ9
         Gn87D+pZY/al0I99Hh5WUZwtHidEsaJRU0Yv5Y9/ZTubJ6zfpGt/Zo0g0sefE5g0NB7j
         CkGFAKf3DuSxWkcei37F/h05y/r5BvZVERRuaDzbgUid5n87FH+KHezgYTCtcWzQVFd9
         ogBGB0xB7RJ2RLKJNFBX5NQwkFarda+tmqBZFYm23PcF2LrzDbYA3/z8TdWdMjN00Qao
         dd9g==
X-Gm-Message-State: APjAAAUZKOACTcvFph2mhOEQaNZpVSCdAG2lgAeLtMJ6gRw8UUqWeWNo
        l7ZcLRfClfVU3kuc/PCvo5A=
X-Google-Smtp-Source: APXvYqw03jFaxhFit7cE2chDwKeaHkFNy6WoFDjYlzs0rvx/sssv7BW88ZQ6ko03rUmUBzFNEZlD+g==
X-Received: by 2002:a05:651c:112c:: with SMTP id e12mr20374152ljo.169.1575978286314;
        Tue, 10 Dec 2019 03:44:46 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id q27sm1634622ljm.25.2019.12.10.03.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:44:43 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedwa-0001I8-No; Tue, 10 Dec 2019 12:44:44 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Arend van Spriel <arend@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 5/7] rtl8xxxu: fix interface sanity check
Date:   Tue, 10 Dec 2019 12:44:24 +0100
Message-Id: <20191210114426.4713-6-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191210114426.4713-1-johan@kernel.org>
References: <20191210114426.4713-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Cc: stable <stable@vger.kernel.org>     # 4.4
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index aa2bb2ae9809..54a1a4ea107b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6384,7 +6384,7 @@ static int rtl8xxxu_parse_usb(struct rtl8xxxu_priv *priv,
 	u8 dir, xtype, num;
 	int ret = 0;
 
-	host_interface = &interface->altsetting[0];
+	host_interface = interface->cur_altsetting;
 	interface_desc = &host_interface->desc;
 	endpoints = interface_desc->bNumEndpoints;
 
-- 
2.24.0

