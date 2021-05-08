Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D497376F49
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 05:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhEHDyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 23:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhEHDyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 23:54:14 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BD8C061574;
        Fri,  7 May 2021 20:53:11 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id t21so6244985plo.2;
        Fri, 07 May 2021 20:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UVAOZkyEJJo57GwyWj7UmAw4YWwIKnE98l3Qa37aUrA=;
        b=mNwrBtO/OOX8pi/1NNE+PTtq0ZOeF3CacIDY7MHwUixuNegSIOdz4+2Y70kXv/HdPw
         6xL96O+ZDjTNkhDVUUHqdFNN5okffMHJtnzZBIbT05kZEJXInJFqrjksb7VEPm9pVtaH
         Bnh5V9pqZMrcSfdSgvC8OTtR3kvvF1Ae0By8xqKaeAGphPmMkNn+P/0xo0b3hZO4YADA
         khKpYcNkXfHlLLB+B0J4k8GmIdEH87h5Sy3xkktS3um2eLYgV4OFVWQCDVSIwCw0qL70
         F9teJL1xCwel3MW1cLpokvIU3IbFD5ixCrJY3DNEm47zIYixWGWwUsZywX2IBtbssSAi
         lKHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UVAOZkyEJJo57GwyWj7UmAw4YWwIKnE98l3Qa37aUrA=;
        b=K+mUcvMVFUHnBGDVWIzSGSa3blhHXokyyOi8fS7XZNGV+6/yEl+5evqU0Rds/ZT/6J
         bq9So0Gr9wzLsc1t8kLDHXAoOEtOh41foHI4/MMvCOExZiRzSh+0/AZDPTB3vXLFvWr5
         kowgUNJKJmPUBO05kAw+jwZfswuEypo2JUoy/1/Ia4mimVcjaeKu2WWBr1BdZcW8JGKk
         4Ur8pXIrMca5kP99QHEK7fQBIeFbKh/pdMlv3nBCn53+sgz9nhaSquShNybM6qo0nyoH
         uOElGyF18CBTPMg79EImhWRwUxTFXmZCCdOMfkP1vQupr6EhjxaPPZ37s12C2WiWyFra
         /ikw==
X-Gm-Message-State: AOAM531aUgaA7hqLNMmpJPtthGvYhTO4CABjfwrCXSBfdSQNaxzqrqJU
        1rS1Qu6nCJ1+4B+MIeJq4w==
X-Google-Smtp-Source: ABdhPJz00ehHYbTCOyJuzDdcnPdndMZbvOZBT+hYbOvMjS+C7Yh/JrMU21VkKlC5C6zpOtljamD5kw==
X-Received: by 2002:a17:903:230a:b029:ee:a909:4f92 with SMTP id d10-20020a170903230ab02900eea9094f92mr13880320plh.44.1620445991077;
        Fri, 07 May 2021 20:53:11 -0700 (PDT)
Received: from localhost.localdomain ([210.32.145.152])
        by smtp.gmail.com with ESMTPSA id a13sm5694824pgm.43.2021.05.07.20.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 20:53:10 -0700 (PDT)
From:   Jinmeng Zhou <jjjinmeng.zhou@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        shenwenbosmile@gmail.com, Jeimon <jjjinmeng.zhou@gmail.com>
Subject: [PATCH] net/nfc/rawsock.c: fix a permission check bug
Date:   Sat,  8 May 2021 11:52:30 +0800
Message-Id: <20210508035230.8229-1-jjjinmeng.zhou@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeimon <jjjinmeng.zhou@gmail.com>

The function rawsock_create() calls a privileged function sk_alloc(), which requires a ns-aware check to check net->user_ns, i.e., ns_capable(). However, the original code checks the init_user_ns using capable(). So we replace the capable() with ns_capable().

Signed-off-by: Jeimon <jjjinmeng.zhou@gmail.com>
---
 net/nfc/rawsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 955c195ae..a76b62f55 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -329,7 +329,7 @@ static int rawsock_create(struct net *net, struct socket *sock,
 		return -ESOCKTNOSUPPORT;
 
 	if (sock->type == SOCK_RAW) {
-		if (!capable(CAP_NET_RAW))
+		if (!ns_capable(net->user_ns, CAP_NET_RAW))
 			return -EPERM;
 		sock->ops = &rawsock_raw_ops;
 	} else {
-- 
2.17.1

