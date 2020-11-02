Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC382A2F6C
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 17:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgKBQO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 11:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgKBQOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 11:14:52 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F991C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 08:14:52 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id s9so15262078wro.8
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 08:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z6618xJXhXqXHodxwmKYhO6tkPP3WPr6UxJwjTPsCDQ=;
        b=XQa4ZCTJc70MalCEMRbstL9yhQ4aW+Muw9kK/V815HmkgCapYFtoyDWH+xFMOxXqEy
         J/CNvNCaQJd/n9/rWezWyW2+FWtl00gTQTyM3cfj/AMrnGmFUvVghNMV0zBZqftPDYm9
         it8r9jiiVUoJEPLFgdsnIn0s9JFsGJ2nnJnAlvum6wVD/sp95K3XDHvIldVqeXnXGI6n
         bsruMepaFNrqeqvpOCCMUIoyNx/Vp61vhMXhZNSIJhDzFk/AVse7Z1Z8Xk+licP2bPTn
         XdKSMzWCaHyTYfCrHREhRCF7PlP9/EUup2yCefARbeot8neoBX55alipTDWy7dhuPLf7
         3VJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z6618xJXhXqXHodxwmKYhO6tkPP3WPr6UxJwjTPsCDQ=;
        b=OtqFtiQslM8/ek5j57QZzv12gTVBZUfyOomX/UkJaINGjVrxzG4I/KCFiv6uNE8+PL
         prc/YIuTJwEhmPI2sA4Wq9en0zC2DBEsNcFCywmlHt8RkD794MsMtdi9fuvCD4Zc/yZ3
         04YbPFcbcRtGCwkmGYNxz+H4LVgWg20EikUw/yOef3uTllczbGwDXZBt+m5iGpeb9P1+
         ZOVBo/fNDxuHDJu90ax2i3txTnuhkQ7sYh6sNdM9pYaQA0HdQLTBSq22LNzsx4ZWPpkQ
         L0TMAL51abcSEkOdUwZtchzedHw9EHrx8XhwvKDczoVG3dXwjiBGgHDllEyUrPuz5ai3
         6wQQ==
X-Gm-Message-State: AOAM5303mEvFoMIlvfsLR5h6hdOaQGa3WCd2zCusCBndwl8FsHrjcqKb
        d3UJSs34o8zfCBsK1o6mhoBb3w==
X-Google-Smtp-Source: ABdhPJyx8kw0GtHnHiZVHl/JP/ocb946aS8LqaiSCCdAWExQH/L/4D4M3A9HeSVnpR5lCk8w6YgceA==
X-Received: by 2002:adf:bd86:: with SMTP id l6mr21763532wrh.205.1604333690852;
        Mon, 02 Nov 2020 08:14:50 -0800 (PST)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id x18sm24127878wrg.4.2020.11.02.08.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:14:50 -0800 (PST)
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
Subject: [PATCH v2 1/3] xfrm/compat: Translate by copying XFRMA_UNSPEC attribute
Date:   Mon,  2 Nov 2020 16:14:45 +0000
Message-Id: <20201102161447.1266001-2-dima@arista.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102161447.1266001-1-dima@arista.com>
References: <20201102161447.1266001-1-dima@arista.com>
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

Fixes: 5461fc0c8d9f ("xfrm/compat: Add 64=>32-bit messages translator")
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

