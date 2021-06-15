Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAEB3A7B5A
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 12:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhFOKEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 06:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbhFOKEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 06:04:00 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9477AC061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 03:01:54 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id c11so24208038ljd.6
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 03:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=br7/P8hS646NsafH/OdbTgJv7OyUNpHOzNdDEJ2Eqa8=;
        b=X2CoBEC2uX/LjBYYPyZna/+fwXGuGAVOJWZrH6fd2vmLf9n7GJfH3BReDNzM1r6d3P
         zz0wsL4sDpPtcYPa6Yqa2n2JlPqdv7OTYQUXTFB3cdITcnuo47BanhF98vBV6PXf1Cah
         EpHmcsga5rBEdMjkuTjPqwLGSKXYlI5mGYT/+z5bRus6WYJjnp0pF4k9Oj6WPv18qpx3
         QJhTzuetCtwTNCI4VRhOCYW59ZyT7xd5EYijjw5gwsd6DMwkcKzb9ADIY+H3hMqE39Up
         FKON/J8a0hq2lj57COolwMsg4qVLIM2PwRB0o872NiJqf6zWP7i2eJM/hEhTYcMTFFek
         6ZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=br7/P8hS646NsafH/OdbTgJv7OyUNpHOzNdDEJ2Eqa8=;
        b=it/bmn0X/t6Oa9V009c7gpIXtLsA/mFycvnNFa+/SZlAIqyEP3KA0ctHIU93O5p2/9
         oJFZXDqePKYH8SMEFLpjwii6B1FAHGNeqfAMrhdZK6by3AIUJ+eIGpmf+jEO/kJ31ktz
         pRa1gRYQJDxOroMIxJahHFuTWWWkHwXMnjcTQinNBNMeFLnsrKWaVSUxX0mrKldTy5oT
         XkDsrHO1kouloxC7GOKYmo7tVorz8fvr+wx7GAsJnelmQhrst2J+oydDhRqm3f/tIADR
         QEzUtTbzkS3/4mzBst7Dy9fkAfgGHSdIDZWKzqEgDWYHjUwWv3R+wMZDGKd0fMxUhhY1
         0S4Q==
X-Gm-Message-State: AOAM532jk0N3Gl0BVbif7qBrbHq61tJnO222/DpRMnCK9gj0oThvHWkH
        TPb+XAUFfTHJzT0gk9Byorq0fzwyq/0=
X-Google-Smtp-Source: ABdhPJxKaD9gV7/tnrq558/IfTlal2H0LQF/s0BkTY7ycGbGCzZcI4mPZBIjQ1p195jXdWaSvSeRPg==
X-Received: by 2002:a05:651c:3dc:: with SMTP id f28mr17161269ljp.294.1623751312947;
        Tue, 15 Jun 2021 03:01:52 -0700 (PDT)
Received: from kristrev-XPS-15-9570.lan (telia-5908c5-232.connect.netcom.no. [89.8.197.232])
        by smtp.gmail.com with ESMTPSA id i16sm2111181ljj.38.2021.06.15.03.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 03:01:52 -0700 (PDT)
From:   Kristian Evensen <kristian.evensen@gmail.com>
To:     netdev@vger.kernel.org, bjorn@mork.no
Cc:     Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH] qmi_wwan: Do not call netif_rx from rx_fixup
Date:   Tue, 15 Jun 2021 12:01:51 +0200
Message-Id: <20210615100151.317004-1-kristian.evensen@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the QMI_WWAN_FLAG_PASS_THROUGH is set, netif_rx() is called from
qmi_wwan_rx_fixup(). When the call to netif_rx() is successful (which is
most of the time), usbnet_skb_return() is called (from rx_process()).
usbnet_skb_return() will then call netif_rx() a second time for the same
skb.

Simplify the code and avoid the redundant netif_rx() call by changing
qmi_wwan_rx_fixup() to always return 1 when QMI_WWAN_FLAG_PASS_THROUGH
is set. We then leave it up to the existing infrastructure to call
netif_rx().

Suggested-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 drivers/net/usb/qmi_wwan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index db8d3a4f2678..b39553a56250 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -621,7 +621,7 @@ static int qmi_wwan_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 
 	if (info->flags & QMI_WWAN_FLAG_PASS_THROUGH) {
 		skb->protocol = htons(ETH_P_MAP);
-		return (netif_rx(skb) == NET_RX_SUCCESS);
+		return 1;
 	}
 
 	switch (skb->data[0] & 0xf0) {
-- 
2.25.1

