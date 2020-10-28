Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7F429D8E9
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389094AbgJ1Wku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389070AbgJ1Wks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:40:48 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38E7C0613CF;
        Wed, 28 Oct 2020 15:40:47 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id b19so360360pld.0;
        Wed, 28 Oct 2020 15:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZgaymEmZcwxxsKVYh/F35SxRK5AS1vNWLJ9SX/my/Ac=;
        b=NqrrPl5IAyqECj76dMGuM5xm0RZ8Rj4wyDANCyUbxak5WfXMSUyNgEQpwgTwH0hNXA
         vRE5OQhTwoy+hPQUX38GvmZ/Cb31P5hS4C34PM/Xf2RgHhMQsDrKCu+08N1H76Cqxssk
         f1yPZFJRoS0UFf6h3tXs0cdd5IVYo/x/v84OCS/PfelbxTwxr7/EfBnO5PWt7/DXM5az
         O2dExDvPxJoeJilvFLa3NdqejDOGmHwweQBXGysoGMGhoGPQR2nUrIJQavjBx7BHb2H2
         qvXrlEO5jvqSIqReEc4kxy8uWjtMW+nrgYUIGpxpbzjQxCZ/C1IaF5vnKSWJUvmdCAIr
         SaQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZgaymEmZcwxxsKVYh/F35SxRK5AS1vNWLJ9SX/my/Ac=;
        b=aQS90mTuGr9dcuWCthu/4iWt2MqneLco0mTrQRNfw2uN8nbPJbD8amdYxIAYyE+zPL
         LL+N06gmjfPpBjba50fXFU7hDdMqUjGPOmEmSQ0J56Gucp8R+fzeKlZ+EflEj3pykOHG
         /D0tKzvLuus4k6lLPALX9lx/jkUnqfWHVIePsiMNYWbgBzBoGP2RaSoBvF29kv/ojALY
         /0MyiyOIzgtE2pUmmzCXKAu2zQuCS5CFQ4eHcCzZw5V5fqBEANU91OUu8rfT1BC9Z57H
         p1rwmL4QHra1OTbUmWZ77hgyPbLVzUiFCioSft+9tOmeD6RMSuFvSlMHqgKkxnxxWTjR
         ls9A==
X-Gm-Message-State: AOAM5322k3yn9yQMEB0kmyG10yycC3JPj0gE7jQvgXk2sb7QwGfOSG1e
        qmDDk5ReZEl5t2GqBXXeBvNJKPEvrTQ=
X-Google-Smtp-Source: ABdhPJwwqxKGvnkuElikx8r2ZmXj4J4dw/eIAsTBCBcc5R6EwV9aBOXJh9cadR+PMdDSrN0BBfwVXw==
X-Received: by 2002:a17:902:b492:b029:d4:d88c:d1a7 with SMTP id y18-20020a170902b492b02900d4d88cd1a7mr7508840plr.15.1603891193194;
        Wed, 28 Oct 2020 06:19:53 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:6d80:dec8:7340:3009])
        by smtp.gmail.com with ESMTPSA id r8sm7058032pgn.30.2020.10.28.06.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 06:19:52 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v2 3/4] net: hdlc_fr: Improve the initial check when we receive an skb
Date:   Wed, 28 Oct 2020 06:18:06 -0700
Message-Id: <20201028131807.3371-4-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201028131807.3371-1-xie.he.0141@gmail.com>
References: <20201028131807.3371-1-xie.he.0141@gmail.com>
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
Add an fh->ea2 check to the initial checks in fr_fx. fh->ea2 == 1 means
the second address byte is the final address byte. We only support the
case where the address length is 2 bytes.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index ac65f5c435ef..3639c2bfb141 100644
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
2.25.1

