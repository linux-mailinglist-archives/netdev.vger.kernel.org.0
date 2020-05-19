Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73C71D9EF3
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgESSOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgESSOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 14:14:24 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25761C08C5C1
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 11:14:24 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s10so223171pgm.0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 11:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=GWcc8oVpXNGnhmVFSGsMCYNch8YIZsE+7UZfyDX1b1s=;
        b=qDxV66tUkSvuPJb7KqJEMgMn6a6QQv5vMRFGKOOlXTaP9TVGqmf+swUWW6F3ibePpm
         jGMjoYXGMJ8J9WOVwGakwM02ksOKmj9XmG+n8Y08QaAYsEih7trLFLwaLPbOB5jjIQYf
         M6VJzccmMaUWK4jw+axMKaSnumIKZgFkncQKmXSBkOGyjK6KpvLwByruFYP26AUeF48n
         vZhgrMVSMOJCgzy1lqW8+8G3bJ3vjtcERhDeWf4LqQeSdMGrK3jtpSbPFVjEOSJ6kmfE
         MAkCOVpIY+z2/rCAXGW5/lFvs+sNwcKa8qUi9vV13a7eZ1lUXNUp0T4k2DnxpCWlFWg9
         FWFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GWcc8oVpXNGnhmVFSGsMCYNch8YIZsE+7UZfyDX1b1s=;
        b=IGbxGDn+eNFeCgE0RbbK2gJqi3YCwhP3/4XqHF+2Ou6jvnyXAxNc4ffzcFjn/8qltf
         59aKA6I0hWbzzwQmHiBoBpXsAitkhC7HClajycAvy1115Ws17jTu+0bZJ9wkZtXSa/Bw
         pMhew0AufWrJKU5p9cAOh3HAtdfE/1FWu3lGUhyg4dNMYr0/QJQ0b0S3Sgg9eXVOj3jR
         aurI9nGYjGP9JfOw2/IaWnyEZM2PnabVR3YYiEE2y5JvOyDNnzFAyL0dZifBIIGfqwU0
         TmlPxRl77XXp5dgHlowRYm7xkQwDyYrjHvDQtyUDNeCTnuM5rdOlOM0e5tTZdaY0saV5
         V8fg==
X-Gm-Message-State: AOAM532GuihVzMup0MPu2MctkOhtKRJARyMSYoJbrcLLPAwSz0KTFkjp
        wv0oQil/80RoyH9fNqI44BkB
X-Google-Smtp-Source: ABdhPJwugN3E28mkgq62MwyOHN6GuwFZQCbSjgrj5P9JL3FNCPKsli5EFHbI2c2y0hHHPx8+GvXwhA==
X-Received: by 2002:a62:5487:: with SMTP id i129mr312992pfb.77.1589912063535;
        Tue, 19 May 2020 11:14:23 -0700 (PDT)
Received: from localhost.localdomain ([2409:4072:908:98af:f00e:87b6:e4b4:50f0])
        by smtp.gmail.com with ESMTPSA id q201sm156543pfq.40.2020.05.19.11.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 11:14:22 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH] net: qrtr: Fix passing invalid reference to qrtr_local_enqueue()
Date:   Tue, 19 May 2020 23:44:16 +0530
Message-Id: <20200519181416.4235-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once the traversal of the list is completed with list_for_each_entry(),
the iterator (node) will point to an invalid object. So passing this to
qrtr_local_enqueue() which is outside of the iterator block is erroneous
eventhough the object is not used.

So fix this by passing NULL to qrtr_local_enqueue().

Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 net/qrtr/qrtr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 7ed31b5e77e4..2d8d6131bc5f 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -854,7 +854,7 @@ static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 	}
 	mutex_unlock(&qrtr_node_lock);
 
-	qrtr_local_enqueue(node, skb, type, from, to);
+	qrtr_local_enqueue(NULL, skb, type, from, to);
 
 	return 0;
 }
-- 
2.17.1

