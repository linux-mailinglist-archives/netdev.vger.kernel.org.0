Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FFF29FB4D
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 03:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgJ3CaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgJ3CaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 22:30:23 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A19C0613CF;
        Thu, 29 Oct 2020 19:30:23 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r10so3916384pgb.10;
        Thu, 29 Oct 2020 19:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B/7mr9at8aiFOt20RGTnPfBfr8OJELJGRx4fnyFdhVY=;
        b=GJQ8PtnZApmXB+RWDiwdR/Ie54aWpuDdciUE6GRIGU4i5scEBoCJZWoOcP0zpS4umm
         s91cXSD6S+RnIoj3E7GwGc0PXn3j1V7ugSH7sMJqZ3fIeXzIzRcdokKPqgPAtb3GHLlI
         4Aekdn1+pqklGd6JI556X2/2ubwBmpRebIniDeoxyV+cjApk766h1WP8JKfmAnPCY6XW
         wNcPpAUZODX8iCSSknJqS8icSldyjxXdaMDQwsCLWPvxPpISDcgjBXRlANs8nsI0i3Bx
         /sjz4AggzLULNhoUfrmyfrCxDQqzsnynOI4aA0feZHWKFBGfcSpjYjoRuLoLdxP8+tcC
         GH4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B/7mr9at8aiFOt20RGTnPfBfr8OJELJGRx4fnyFdhVY=;
        b=bfGIWuQK+1uUebN11/MbuUM5Fk3TyCBqu2ls3Vrbxpnyt5iejwhTSXTjyDfiXkaWCO
         7oGNzTesO7DIB873oqxTSQCEBPSmlFxTSJj/2f3ufCdI0tmtjBPxe4hxZPAO3TfKJtR8
         PsNUGmxwKuvu87YNiwBAYYswrL4ExKOcF6rC+OemsHrhdtzhnHbVXabXMGWVmTjiri5B
         fkiUDo53nde7q01CRSvvsyQrmunft+WzCi2csadS3P6xjvsfoPVX2hhUECbPOnuY+/FS
         lUygZ+Pc2Rd7NghNS9QlZDfgWfDmLX9gvMxOHtfp+isXNVOzJRzWFvO8hQMEGC5qHIIY
         gStA==
X-Gm-Message-State: AOAM530fYWH2yeLPZLdwspMID8ESa2evhicctp1FBBJu83c6AuTEaXPa
        gS3YawBA6he5aZzi33mArehT+iKJYuo=
X-Google-Smtp-Source: ABdhPJzYAMEvf7Rzsp9xQu4cRdfgJ0a9Dc5srYHfsgwkz/I39XsKmgRLqNFu3Q1p74bVAT7F/vO9/Q==
X-Received: by 2002:a62:5251:0:b029:164:3604:578d with SMTP id g78-20020a6252510000b02901643604578dmr7507679pfb.51.1604025022710;
        Thu, 29 Oct 2020 19:30:22 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:dd13:d62a:9d03:9a42])
        by smtp.gmail.com with ESMTPSA id i24sm4216588pfd.7.2020.10.29.19.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 19:30:22 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v4 3/5] net: hdlc_fr: Improve the initial checks when we receive an skb
Date:   Thu, 29 Oct 2020 19:28:37 -0700
Message-Id: <20201030022839.438135-4-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201030022839.438135-1-xie.he.0141@gmail.com>
References: <20201030022839.438135-1-xie.he.0141@gmail.com>
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
Add an fh->ea2 check to the initial checks in fr_rx. fh->ea2 == 1 means
the second address byte is the final address byte. We only support the
case where the address length is 2 bytes.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
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
2.27.0

