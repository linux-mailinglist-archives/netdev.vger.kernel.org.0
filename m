Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E635E11371A
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 22:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbfLDVch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 16:32:37 -0500
Received: from mail-qv1-f74.google.com ([209.85.219.74]:51901 "EHLO
        mail-qv1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbfLDVch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 16:32:37 -0500
Received: by mail-qv1-f74.google.com with SMTP id e11so736075qvv.18
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 13:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=hdA/yt7JKMKARsapFB5/yPNoavoVnDwqDt85DMJoGDM=;
        b=nn7uQurGxXsRNEO68nFnqUGTDf3FdcEXQ3iky8Wa7U55A85rDuICKRZIL5FqKgEloo
         bkyRb10Qyxm62SpoUH7hjl8B1Gbk4mlqT+NWZZBMYNhBFfZo+tdkCGfzwRRGluAROLj5
         WK7q480GrNKwAt9sWiYzkKU52mIzywDWXFisZkSV4y1TDt6wxX60pAEh3pyWcSXBtsZu
         s+wm0jifufkb8S2nXAp1VvJ2HzELAaShrtql7/JzY36iY5FK1wxdqa31zvTbrU3QLfIM
         epOPPflhUutTMMdy38tay0d5UIGDcnRDWcjNRMD0cRi1XZzVEQfrLiou7WvDigKAH47L
         5uWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=hdA/yt7JKMKARsapFB5/yPNoavoVnDwqDt85DMJoGDM=;
        b=bMp3oZpmrLkhB2GBM9PHa/0g0OaRvT9q8oqCnsxngkM4Amh+K+FkPaC2cNpz6GDu/S
         oqES0/cT3WXuOlT9QgAGh8zFV6iVyBEB/7o5vYv8ygfBjOp1mIeUmfhQnPLZMJM87PR1
         WOXqCp146dRYDm8Pq6mIwDnJEx4ezYCuQ1GJvuJPt3M4uj2DUIabSQ6SnkAFyZ23urSL
         uajSf8wGrm3TeotWmVhrzMOBS0My/gQivPrw0xrM5K/QRsqGLEnSeMUIl/mGZON+5uGv
         sU1Pl7nOcNlvyNFDYVMQ70W352Y15KQ/ODD0c69ESE+m5o4e6c5Rx09ZrQ+DVM15nmTu
         QaeA==
X-Gm-Message-State: APjAAAXQNC9IKf3WV0I9pcj6WJanbIz7EiZhDT7uqzHKQwy7fIAQUd3g
        2daXelYuYB/Y6EcLkl48kHO8hMS9S5uT
X-Google-Smtp-Source: APXvYqwSlz6wHyVqPccqXmxtMoP9NrMJRjligqWjIekJ842SgJwCXuHiUBnBwRNflWLygf+3Y5slk2JAxcS1
X-Received: by 2002:a37:6087:: with SMTP id u129mr5100376qkb.219.1575495155838;
 Wed, 04 Dec 2019 13:32:35 -0800 (PST)
Date:   Wed,  4 Dec 2019 13:32:28 -0800
Message-Id: <20191204213228.164704-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH iproute2 v2] ss: fix end-of-line printing in misc/ss.c
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Mahesh Bandewar <maheshb@google.com>,
        Maciej Zenczykowski <maze@google.com>, netdev@vger.kernel.org,
        Brian Vazquez <brianvv@google.com>,
        Hritik Vijay <hritikxx8@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous change to ss to show header broke the printing of
end-of-line for the last entry.

Tested:
diff <(./ss.old -nltp) <(misc/ss -nltp)
38c38
< LISTEN   0  128   [::1]:35417  [::]:*  users:(("foo",pid=65254,fd=116))
\ No newline at end of file
---
> LISTEN   0  128   [::1]:35417  [::]:*  users:(("foo",pid=65254,fd=116))

Cc: Hritik Vijay <hritikxx8@gmail.com>
Fixes: 5883c6eba517 ("ss: show header for --processes/-p")
Signed-off-by: Brian Vazquez <brianvv@google.com>
Tested-by: Michal Kubecek <mkubecek@suse.cz>
---
 v2: Rewrote commit message as suggested by Stephen Hemminger.

 misc/ss.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/misc/ss.c b/misc/ss.c
index c58e5c4d..95f1d37a 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -1290,6 +1290,11 @@ static void render(void)
 
 		token = buf_token_next(token);
 	}
+	/* Deal with final end-of-line when the last non-empty field printed
+	 * is not the last field.
+	 */
+	if (line_started)
+		printf("\n");
 
 	buf_free_all();
 	current_field = columns;
-- 
2.24.0.393.g34dc348eaf-goog

