Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6079C8FE
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 08:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbfHZGLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 02:11:31 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42660 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729348AbfHZGLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 02:11:30 -0400
Received: by mail-pf1-f193.google.com with SMTP id i30so11081354pfk.9;
        Sun, 25 Aug 2019 23:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MXb24woiG3vysdnh2s/h7S9B75FkjdRNzF9eK8dEZkQ=;
        b=Em844pTpiX2dTIuGbxD5rHts6qiIuBWjFNpE63v90SbvL/nmEuOjCNW4RSSuO+7tHc
         54aNcRRDilJtY3naKW5iXRlMoOuUzJ8O3xWVNSJvgdwfFACf/A6ADSpc/G3ouhNFZP6+
         B6FeWFHMNsyk9x3MGvzop+vIRCec0TU3WJ19G7vzRdPXjNq97xQtNUj9seokb6d2ZgTX
         VAohEHVkZvz/OLwegWGwNRuGMHOzGzh13pLGZmgMFCZ1gJYdMAy9VdeJRlXPDC33gFxr
         Q/96FODxity/7nf8qtC4Pkng4m93fsg2DD/bFm3m3Cu0/+12yPeeGEN/pwDYCFQDY+gr
         2x9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MXb24woiG3vysdnh2s/h7S9B75FkjdRNzF9eK8dEZkQ=;
        b=V5wN8kKSl1oyLFgJ5Q/JLjaF+//+De8plgqkVIVIO6Qt3ovSBWQdOMXWINbAoRf9zS
         5NGlDRQ6gvyAt3iOXqCWrgDQxwFyOAhyIyNFvFGI7JcRwt46R7dWSMJIFN6+ouXjFLfg
         ljo5WrCbSkXKf6cu/xv0s45RP3064y75n1znCpgDbp62UfjRBi8o69Fpmpwk15aMPmJf
         8XhKOcTEJGVuZZuqDeGpDbjuz+0mAAJMVdKWqDekxwHXJcrsR8p94Lloqqa+YCwCkxfE
         vwAtrIvAV7NKZ80tb53h8yUovNROha0xjnDfcLMvj80dkoVcop4YKqgeL0Wu0PlQ7xZb
         1V8Q==
X-Gm-Message-State: APjAAAUhIymgj8l6sqy4n8Akl8EqiSUVwEwuPLMzCKvNrO2k5q5I/r0k
        q6WGlSDFCwWxqN6gxY5UZVY=
X-Google-Smtp-Source: APXvYqwWSpmSNI8hJ5viwyWNEVsstNYclKqJDblCk4pRLmfn1+UYo4DMOprkxnHkxFRjPS/UxAlTNA==
X-Received: by 2002:a17:90a:a78b:: with SMTP id f11mr16676229pjq.16.1566799890173;
        Sun, 25 Aug 2019 23:11:30 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id d2sm9567452pjs.21.2019.08.25.23.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 23:11:29 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: [PATCH bpf-next v2 3/4] xsk: avoid store-tearing when assigning umem
Date:   Mon, 26 Aug 2019 08:10:52 +0200
Message-Id: <20190826061053.15996-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190826061053.15996-1-bjorn.topel@gmail.com>
References: <20190826061053.15996-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The umem member of struct xdp_sock is read outside of the control
mutex, in the mmap implementation, and needs a WRITE_ONCE to avoid
potentional store-tearing.

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Fixes: 423f38329d26 ("xsk: add umem fill queue support and mmap")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 8fafa3ce3ae6..e3e99ee5631b 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -716,7 +716,7 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 
 		/* Make sure umem is ready before it can be seen by others */
 		smp_wmb();
-		xs->umem = umem;
+		WRITE_ONCE(xs->umem, umem);
 		mutex_unlock(&xs->mutex);
 		return 0;
 	}
-- 
2.20.1

