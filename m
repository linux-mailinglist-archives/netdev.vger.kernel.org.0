Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16827353477
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 17:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236728AbhDCPOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 11:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbhDCPOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 11:14:01 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FAEC0613E6;
        Sat,  3 Apr 2021 08:13:57 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id v15so11346399lfq.5;
        Sat, 03 Apr 2021 08:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K3Jb56LOApi297xEEIjS/VCdKqZUuXjd8AUAcVzA0V8=;
        b=pZosICLiqaTDTTeAzLLUy72xsrdO36JNiueb9h/Hl+9w64PtoFL6arRGY5oBpfJ6uk
         +mM8ZmHBQlZdqHoBOlIrit92IJd/+fJ+yKK/mOvAqnDJvRGKkVmm9NCTnPAhB+LUWG0l
         n+pKTIemjHPoj5+gwj2QC/7lQkArIRxxJKYg9H3vWim81hT4mt3ceHTk64kN9lFrIQA2
         OvXnOA/QRJXPOlkaBFlstVVfOQ68ax4yGQqdl/aCG48gGyQ5egbUeSu365Ow3sbGZht5
         q6hsxj73BtuGaQWE52Egc1ptQwszlmmPhUNbZBCiNvIPCIqcyarP//lqpEyqXtoiatvZ
         wyTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K3Jb56LOApi297xEEIjS/VCdKqZUuXjd8AUAcVzA0V8=;
        b=fjUC50NzQyVRao2ZAMBsj8ww6bOBRKmSjnMQIMuKn8Z0ReNMDNTljjn4qUglNrSSxm
         rSZHXfjL96cB0gYCYz6vF2E2IwuHwz3e4tKAEfGJmAjJJ9SnVSFCu0WEgNJGxShYEzOE
         eLuTTpvaqCN/URj1NVtyXR1qSJIx3D7/LYw3/rrLd4k0/tzic28vWZ14uPm/EvUSWWwB
         yK11FjB7zMWwqKaWkoVJGJUYM1JZT0qyAn6l4nfP9FOZfoJd6wP8K7m+Qmwuq/ewv1pf
         NisM6WmvKHUU0FrjyiHC4I1BwidhQqsczaKaxp4zpGUGGt5XuFOJvu3puJwf5iiIg8fv
         CG0w==
X-Gm-Message-State: AOAM533+3aPhs7UFAbV3+XtqNLI+tQwD/J7hFm7VDLsaorBTW8hq6uDP
        d3h+31jFo2T0emUeCM4BkXw=
X-Google-Smtp-Source: ABdhPJy6unKX9vl33a30tYZ3wwEi9Eq7hlSy7MoPtLgXyzwMglTnVkHtjpHd+1Qaw5xpWNBHmHbwxg==
X-Received: by 2002:a19:5219:: with SMTP id m25mr11517883lfb.416.1617462836237;
        Sat, 03 Apr 2021 08:13:56 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.149])
        by smtp.gmail.com with ESMTPSA id z7sm1222966ljo.64.2021.04.03.08.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 08:13:55 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes.berg@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH] net: netlink: fix error check in genl_family_rcv_msg_doit
Date:   Sat,  3 Apr 2021 18:13:12 +0300
Message-Id: <20210403151312.31796-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

genl_family_rcv_msg_attrs_parse() can return NULL
pointer:

	if (!ops->maxattr)
		return NULL;

But this condition doesn't cause an error in
genl_family_rcv_msg_doit

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/netlink/genetlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 2d6fdf40df66..c06d06ead181 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -719,6 +719,8 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 						  GENL_DONT_VALIDATE_STRICT);
 	if (IS_ERR(attrbuf))
 		return PTR_ERR(attrbuf);
+	if (!attrbuf)
+		return -EINVAL;
 
 	info.snd_seq = nlh->nlmsg_seq;
 	info.snd_portid = NETLINK_CB(skb).portid;
-- 
2.30.2

