Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31AB22A120B
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgJaAiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgJaAis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 20:38:48 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C305FC0613D9;
        Fri, 30 Oct 2020 17:38:48 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 15so6525232pgd.12;
        Fri, 30 Oct 2020 17:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fH/DoVxYj9YJGUaw9Q701340pAXyR23j//JGf26ZwbY=;
        b=uALSM4m8ukaREcbEZZ58kVhrRgI8oqIx2pyTa8Wl7S3dzQ7W9BkY50drxvZylHA9n/
         lIEFdVY+DWMiIGDhsNWgp+CrBUjJ6ZvA7GTwKsLCimjZmDL6a1jOIVO1JvgY8fCs6zFK
         HpN3741jvxlXIbxjMkrCiyzosYoDY62LQZZ35AFXtsB5sev+Lu6Hqr2ao2XPMMvrGG6o
         QpqaIJmN2rK1ON4vdz5IPlsOYMPjpY2oVIh4c0urDUtHAACuwPyGmS2cuaj1hh5lV+YR
         fO71V+qszosqHb4es4oVk8JW+KqrMHBhwKi9AxfcSeoymoJm0sovW63sE9wNP0ELJj1Z
         Xoiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fH/DoVxYj9YJGUaw9Q701340pAXyR23j//JGf26ZwbY=;
        b=LFCeGKwBnX3k4lBpRjrfJGgIGrY7rCy5qNGclfLgD/quc+wfiHTc196rsw/ap+a2n/
         cy/B2PnT/ZwbzmXloW++nKn2QjF/sVsG+sadw/n6nnrRz1FkCOllu8toedFI7VL3IbXH
         lq/I/mfQL61JLNFcNcrSPdoP8WPh+//JMo7tgiG1P6wVqSWOUVxRyqlh+LVJU7uCvObn
         DLSV+OWzsgtq8TbTPY8teRHz8740J0dx5llM3Q5yG0CKBDiQ7V4iH99ZsU7HGIOKDB2q
         RkYYI5AbtILyr8t+8vdhdxH+kFSvRjFNqxBDSbz1k3AIyv416mFuy2dJWdf6xB+UNwfR
         ocZQ==
X-Gm-Message-State: AOAM530CECei6aZp4wONreiwy7fwTkRSiq5U1X824M3FSaMMHqPZDnfB
        +sUa/jbzaMK3up/Q9LIj/6A=
X-Google-Smtp-Source: ABdhPJz1gJU8qKuwm4hFM0eQusCwC9v/OnB79xWy3s6hFdIYxYylZ1xBk8Fn4V24dCIr8TZv/SdMJw==
X-Received: by 2002:a63:134d:: with SMTP id 13mr4287915pgt.370.1604104728388;
        Fri, 30 Oct 2020 17:38:48 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:48fd:1408:262f:a64b])
        by smtp.gmail.com with ESMTPSA id ch21sm4596888pjb.24.2020.10.30.17.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 17:38:47 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v5 4/5] net: hdlc_fr: Improve the initial checks when we receive an skb
Date:   Fri, 30 Oct 2020 17:37:30 -0700
Message-Id: <20201031003731.461437-5-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031003731.461437-1-xie.he.0141@gmail.com>
References: <20201031003731.461437-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1.
Change the skb->len check from "<= 4" to "< 4".
At first we only need to ensure a 4-byte header is present. We indeed
normally need the 5th byte, too, but it'd be more logical and cleaner
to check its existence when we actually need it.

2.
Add an fh->ea2 check to the initial checks in fr_rx. fh->ea2 == 1 means
the second address byte is the final address byte. We only support the
case where the address length is 2 bytes. If the address length is not
2 bytes, the control field and the protocol field would not be the 3rd
and 4th byte as we assume. (Say if it is 3 bytes, then the control field
and the protocol field would be the 4th and 5th byte instead.)

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index eb83116aa9df..98444f1d8cc3 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -882,7 +882,7 @@ static int fr_rx(struct sk_buff *skb)
 	struct pvc_device *pvc;
 	struct net_device *dev;
 
-	if (skb->len <= 4 || fh->ea1 || data[2] != FR_UI)
+	if (skb->len < 4 || fh->ea1 || !fh->ea2 || data[2] != FR_UI)
 		goto rx_error;
 
 	dlci = q922_to_dlci(skb->data);
-- 
2.27.0

