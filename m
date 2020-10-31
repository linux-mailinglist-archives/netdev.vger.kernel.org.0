Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8A32A1227
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgJaAtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbgJaAte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 20:49:34 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767F1C0613D7;
        Fri, 30 Oct 2020 17:49:34 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id e7so6687922pfn.12;
        Fri, 30 Oct 2020 17:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A5VISFliYPxBF2FZExW90UdGjgnJGxgyq60Vib8f+PE=;
        b=Uyw7yJz2TKpGOMI5vjaMS08xQhltlgoTS7NgEH1NX7eqFJ4k6zEZRu/R29o5XCYmfX
         1n0S2yiC7SBx8mhnkBoR0QtDSK9XuGvS/rv1IL0T4GYPbYiNM/UlchfmCiICalW+ake9
         4jcP6F3BNBOONzGxds/PI4RTpUqIRrLK6/IP5mFzUhsBFSdl1kORSGJkBKmUEqoZrzE5
         lPs8AAAGM3AiGGV+eej6Eaf+L7Eq/VkKdnITzIXajXjr/lm1nY8fLtHS+DgWcd5vAppx
         yY4VNob1VVYk/qe3NOFiYO3x0uV5G2syAAny29jeeN5tsKK06AJGte4WSv+puCCNMj3p
         ShPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A5VISFliYPxBF2FZExW90UdGjgnJGxgyq60Vib8f+PE=;
        b=bzRHFayzYUtgiKvOXrZfn1syFSoUCk038CilyEDITry9T07nt5oZfmYuapTE9zJIzT
         Pf4cO4+DHil6Shv/MmZ1hcSHbwQl08XXeVRZuToo1l2hJxUeMRlQol1dRR9G9haYwsne
         nQbdhA1k1jfRs88TIv9sivqLhXuhlyr6hh65u/CmF2LFmdXgudYsgmaHo71fqZO2dNxs
         EiqSxe5fhA9RaOBm9AjMGP/UWiXsPGCfN1mFfwFJCd3voaVA5Xgsi9C3GOwdX/r27BbI
         HbGiJzsya8uKGSqVRWrRINnq+L2OO6gMFZ1JUkztphYOnEPK4SdbIsYLIuJly3X8hmT4
         gUKA==
X-Gm-Message-State: AOAM530G5l4SUs4weh+qRyaqA/akGq9xXIRO/PQd15N1/myTxsut8r4r
        ok4BT4IKMjlvd5hsWTULAJ0=
X-Google-Smtp-Source: ABdhPJwkHz0sVZ6C3l26bMVu/d59I5cwiBwcKjVrP/N/uYmbqF/1OZVFUdngNi2OWf/OZxC4mwF1Og==
X-Received: by 2002:a63:e642:: with SMTP id p2mr4259835pgj.79.1604105374079;
        Fri, 30 Oct 2020 17:49:34 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:48fd:1408:262f:a64b])
        by smtp.gmail.com with ESMTPSA id w10sm4466634pjy.57.2020.10.30.17.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 17:49:33 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v6 4/5] net: hdlc_fr: Improve the initial checks when we receive an skb
Date:   Fri, 30 Oct 2020 17:49:17 -0700
Message-Id: <20201031004918.463475-5-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031004918.463475-1-xie.he.0141@gmail.com>
References: <20201031004918.463475-1-xie.he.0141@gmail.com>
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
case where the address length is 2 bytes. If the address length is not
2 bytes, the control field and the protocol field would not be the 3rd
and 4th byte as we assume. (Say it is 3 bytes, then the control field
and the protocol field would be the 4th and 5th byte instead.)

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index eb83116aa9df..98444f1d8cc3 100644
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

