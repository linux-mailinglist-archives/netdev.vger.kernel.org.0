Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034DB29D44C
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgJ1VvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728124AbgJ1VvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:51:04 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1ACC0613CF;
        Wed, 28 Oct 2020 14:51:04 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id b3so401080vsc.5;
        Wed, 28 Oct 2020 14:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZgaymEmZcwxxsKVYh/F35SxRK5AS1vNWLJ9SX/my/Ac=;
        b=FZESs+U1d6sdbxRLH0jg9AXZ+yso0T3lAdUEm1/pGjJykilNBfVc1W462V4HFS4uuV
         uevITlOOCBo+e2d7Lb21N0rQ1BJ6T6twTtQryZCXGsHxJKEoQbUu/vCy5+6unnqla5e/
         m8sXJ7mKMhjYrX5js/6FQjfsqbIQ74xUVtipNBoILMcI1vQuyqOki9lHZ+fJ6hJpGP0M
         au7JZxLu2+Dh/QKiB6fx6KWpOxAdXwkXC8CbzGg1f2hgwhHWuOlwDaBXBrCE0dAIiNwg
         KggqBUn56qDexBDgJ5tskpakEnAdEzvwK/koeblf/9yW8uU2o2ggvdTuqo/oFQSfI55k
         KXQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZgaymEmZcwxxsKVYh/F35SxRK5AS1vNWLJ9SX/my/Ac=;
        b=niRhlNm3eNGOaA3KxPt1MkpviCKnCwIP9/TZj/LTIUrxB80TK4sBdZ53fGv8lTGGck
         LkKkMhAml6C3U46vT/t9d+DAFbmvW3q1syu0vLBvznfh58fmRK2oWt9f7WE9W8s8pEvB
         pwGBwBCiUhcS7Hs4mkkDj8plebB/JGVImGhYalSYpqnjTDLVPAbjGcX8QILcIEyxi69G
         /7+v0QhDcrEzYxCRSv6V0I3gBH8O8tCa1XKV7jW/TIoU2z88tr+n/O/+nYgcRwcGDQWS
         vJPXrgitOf+x3JKQtdLR1wxVz8upCnS++bDpwjFzOF4mtWf4aNuw956e+Z0gwUHrAbEB
         M1sw==
X-Gm-Message-State: AOAM531DoUrwd1hEEFrIpXcZPCt5GApOfirR4EpwSgW8TTQm820jNLbW
        3P1QVpUL5fu2xAUyDVPjrAOzQYrxKY4=
X-Google-Smtp-Source: ABdhPJxVKLbcv9Q4AuWMalLmnvAx18i9bzgMyTiuxqf0aFwQWWPSRHhIU3ufIjJEJ5oVHG3F49TDMQ==
X-Received: by 2002:a62:878f:0:b029:155:ec80:9658 with SMTP id i137-20020a62878f0000b0290155ec809658mr6745127pfe.57.1603882682137;
        Wed, 28 Oct 2020 03:58:02 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:a46c:8b86:395a:7a3d])
        by smtp.gmail.com with ESMTPSA id 65sm557863pge.37.2020.10.28.03.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 03:58:01 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next 3/4] net: hdlc_fr: Improve the initial check when we receive an skb
Date:   Wed, 28 Oct 2020 03:57:04 -0700
Message-Id: <20201028105705.460551-4-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201028105705.460551-1-xie.he.0141@gmail.com>
References: <20201028105705.460551-1-xie.he.0141@gmail.com>
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

