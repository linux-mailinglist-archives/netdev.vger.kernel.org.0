Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB27729FB2E
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 03:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgJ3C0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgJ3C0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 22:26:05 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F26C0613D2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 19:26:05 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k21so2410907wmi.1
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 19:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cffn0GfYN+WIFr13ZpJjw/0tqOhXXXnigKty10nABv0=;
        b=YaXQ0fVYKz4iwdSGVlHjlXUO8QIdNqsj9lzso9QZ91FBIM/LqXErDk035fXTD7OXVz
         xDrp56nksbdQkIe6B9HZZ6axhv2aGJzCk5uA3EXUYC1v7zzI5gA+ich4/PcNyQ/qLqz4
         hLueSqJkthTlJsAFVferUQxgqG0RKl/e7kMy0VhjAGOjbCO5IE8g4T6+wXGFguishGxQ
         0bUkT65bfVLzfxo/i5fblwPelC7rSCbMWHLnqu5KWvzCgo2GoqNMBDAeKQCP/Fc0EKxd
         VjVaa8aSXsJQBc6QumIFM93AP0NFDaFJJ6ejqKOMMjJwaKrc772OLqZj8NTheQEfqzTk
         AAQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cffn0GfYN+WIFr13ZpJjw/0tqOhXXXnigKty10nABv0=;
        b=bqHyi2P9Gvxz7AUxluiZpqJgWMLwbtnpULBoAh9O52QGxT6JZd/e9Ocg8codvfJ6l3
         3ExTXy/fDGfIQogHXawANDiFGB2GTCfC9tzF+o6pK4pH0IYAxBWrRjGKBDRyexgKHMsr
         n/Spxj3uwxaTvClnyccwNaXS/t99sEz7DOqWodn7fliVFff4nJrWdYo9rPKmbeyMRA9z
         RuLnpxAv/jzOL2Ay3dU/GR/RzWzPXfb8gOVBKatnJq1PPzVnbB0aeFjS/61dCXAkDNNK
         NWvD5UMZyiyT1TC+DCPlBucU2MyONGbQbzWoyQ4652IOAfuFv7QdkjrT8zRtG9B2547n
         sfTw==
X-Gm-Message-State: AOAM533CbxVqexH2QQb2Zc17M28O4M+xK5+2z2HvEzYwSbX/MUHFlVil
        XsBjdY4kXErIcjfe1aPBE3igaA==
X-Google-Smtp-Source: ABdhPJyYQbpl99Amn/qgVxUMfFO162iDjaySaks6WZ0A+OtEZqdAGdtEV3xKDtycI0A4wxozEO++Pw==
X-Received: by 2002:a1c:398a:: with SMTP id g132mr2394304wma.51.1604024763775;
        Thu, 29 Oct 2020 19:26:03 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id i14sm2757170wml.24.2020.10.29.19.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 19:26:03 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
        syzbot+a7e701c8385bd8543074@syzkaller.appspotmail.com
Subject: [PATCH 1/3] xfrm/compat: Translate by copying XFRMA_UNSPEC attribute
Date:   Fri, 30 Oct 2020 02:25:58 +0000
Message-Id: <20201030022600.724932-2-dima@arista.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030022600.724932-1-dima@arista.com>
References: <20201030022600.724932-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xfrm_xlate32() translates 64-bit message provided by kernel to be sent
for 32-bit listener (acknowledge or monitor). Translator code doesn't
expect XFRMA_UNSPEC attribute as it doesn't know its payload.
Kernel never attaches such attribute, but a user can.

I've searched if any opensource does it and the answer is no.
Nothing on github and google finds only tfcproject that has such code
commented-out.

What will happen if a user sends a netlink message with XFRMA_UNSPEC
attribute? Ipsec code ignores this attribute. But if there is a
monitor-process or 32-bit user requested ack - kernel will try to
translate such message and will hit WARN_ONCE() in xfrm_xlate64_attr().

Deal with XFRMA_UNSPEC by copying the attribute payload with
xfrm_nla_cpy(). In result, the default switch-case in xfrm_xlate64_attr()
becomes an unused code. Leave those 3 lines in case a new xfrm attribute
will be added.

Reported-by: syzbot+a7e701c8385bd8543074@syzkaller.appspotmail.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/xfrm/xfrm_compat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index e28f0c9ecd6a..17edbf935e35 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -234,6 +234,7 @@ static int xfrm_xlate64_attr(struct sk_buff *dst, const struct nlattr *src)
 	case XFRMA_PAD:
 		/* Ignore */
 		return 0;
+	case XFRMA_UNSPEC:
 	case XFRMA_ALG_AUTH:
 	case XFRMA_ALG_CRYPT:
 	case XFRMA_ALG_COMP:
-- 
2.28.0

