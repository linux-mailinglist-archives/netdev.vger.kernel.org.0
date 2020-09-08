Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A82A260BAE
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 09:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgIHHRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 03:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729190AbgIHHR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 03:17:27 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D96C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 00:17:26 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id k18so919009wmj.5
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 00:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MDml+4/3PfnJNB4HUyBwYEmPzEU6EDN9UbSshq5rEdY=;
        b=M+Rnb4ynm2iU6lluWeltiofHSpRpXZzbNABBkU+8Dwrjfri4QepL4RNOjq46BzjAhG
         A4FywqJbu/ihEIs2VQMzT7KBVbDMGIk96ubSkO7oQIU6pLFdEWPE71+DJldSw0IDDzQl
         Hh0S5Fol2i8+2dEHolcj/f7TYUetCqOP4omUQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MDml+4/3PfnJNB4HUyBwYEmPzEU6EDN9UbSshq5rEdY=;
        b=BUznMbQ1zK34fzaMKKPZG9+p/GZUMXE/kyBY5Arw5MIdd+HZD4+BDTLLdV3KILpMsm
         +OWjqdrGGx8k6HEJdgJbsau5dlY9pTb3NmEylvcXR+8lzWqyWEUZYJXPtQHRPF3SmV2H
         PFAvoY/Psz5nP8gHlMu1PTcsRtYn4gkZ8+g0PIe5dg4adYReUXaAU7YW5wwtvmPp2JfD
         wknmwYkuCjEg2etEQ58QhcmLIxDuBIM5iCpPbw/EO6kz4a5fMGWrD7HG1uyNOtUAuPD4
         muuLpLNXj4hKGXMpKsQffTxECIddK+ZZxoqoPo1b17pKazzFEbZ+cehJchxQgWhLxA4z
         BP/A==
X-Gm-Message-State: AOAM532n2Lsk7ucPLSSymmG8BPEhbIsGoa5kaS3j3mAe5EnCXj507I9W
        MNIDNsVPD8yg1ao0ueJXe5g/vUqfClZu/biZ
X-Google-Smtp-Source: ABdhPJziU5GLM5roIfqd4CIrMhc1YV1yYu0zCBAgLEFpbWSM+5nxkm65Z523xGr58aUw0qrHzfnWnA==
X-Received: by 2002:a1c:5685:: with SMTP id k127mr2974188wmb.135.1599549445182;
        Tue, 08 Sep 2020 00:17:25 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 188sm54392964wmz.2.2020.09.08.00.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 00:17:24 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, roopa@nvidia.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next] net: bridge: mcast: fix unused br var when lockdep isn't defined
Date:   Tue,  8 Sep 2020 10:17:13 +0300
Message-Id: <20200908071713.916165-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200908130000.7d33d787@canb.auug.org.au>
References: <20200908130000.7d33d787@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen reported the following warning:
 net/bridge/br_multicast.c: In function 'br_multicast_find_port':
 net/bridge/br_multicast.c:1818:21: warning: unused variable 'br' [-Wunused-variable]
  1818 |  struct net_bridge *br = mp->br;
       |                     ^~

It happens due to bridge's mlock_dereference() when lockdep isn't defined.
Silence the warning by annotating the variable as __maybe_unused.

Fixes: 0436862e417e ("net: bridge: mcast: support for IGMPv3/MLDv2 ALLOW_NEW_SOURCES report")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index b83f11228948..33adf44ef7ec 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1814,8 +1814,8 @@ br_multicast_find_port(struct net_bridge_mdb_entry *mp,
 		       struct net_bridge_port *p,
 		       const unsigned char *src)
 {
+	struct net_bridge *br __maybe_unused = mp->br;
 	struct net_bridge_port_group *pg;
-	struct net_bridge *br = mp->br;
 
 	for (pg = mlock_dereference(mp->ports, br);
 	     pg;
-- 
2.25.4

