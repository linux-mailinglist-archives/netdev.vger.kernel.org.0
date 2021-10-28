Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771D243E84E
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 20:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhJ1S1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 14:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbhJ1S1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 14:27:44 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE3DC061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 11:25:17 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id i14so9294278ioa.13
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 11:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=on9i/3CJlLYGIG+xeoCAoOgzpm0872OBX3UlTMj8Cxg=;
        b=FQtmkT0oQOPOWEQR/mo8nwgiQ0H0UxjBJtk3fsJG/e46PTRsxwwhJVjNL5HF0WJQ0F
         maq8O8CPzvZ3RhlZgjTFPNbA8u65eE52AEZyxNn/otCWhXmEiq90/2pAvejFZ6ZY06RC
         kwW70B4S3IqDuUEb9jtc4ifk9MKUI8RgPZEeWqs4rLhjWO0XuONMkNYhTfcel2E0jxkZ
         3i5ys1FOZ/lqmpIwvQTjafHV/DhsTLubM8vCPJhLvSmS3v52sKu8nsr6ia//sQHy3haY
         LIE8ArVCIb404EpA63fl8WWFtPBlCXCFI1UTZYIiO05JQEDv9hXnNDoRUc7LcGwuSQpf
         Cw4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=on9i/3CJlLYGIG+xeoCAoOgzpm0872OBX3UlTMj8Cxg=;
        b=W0nY/IZOorQJSmz/70cxilwFWo8P1sJhUJMLE74PGgH16ICxUeygNLWUt+58yxaaP8
         5L+TiBdhdtyJ/bJtHppv5vkCUoI0Kaa0wTN46uTsIVx+63kEArrFLXvsG853e1vyg85v
         XYZzP4s83rUMtpzQaP84jrhSbDo37NaNjvvSVLs3Lol3Xnbe/FwlkkLD/3sMhvG06ZVE
         ZkiFgDQ7ItoQktVWMp0bxph7+sDOSZ9ExnsKKd5jJbpbiIF3GyVQwd4Zlx/DMc7BIuw8
         7BwVi7v6OxNhc8shCqNqAvoeRDOskNkCSk9fooxM1VnsmwntRqUyIzF3zKaUdRyRkXJ9
         4//w==
X-Gm-Message-State: AOAM5334G+xjc9VP7AqBZPDFHQuisJpJ2VHWI1o8rL92kLa4Df84yjM0
        D0WR6lOi2xEOmiFU2nxOtsY=
X-Google-Smtp-Source: ABdhPJy48590RXENCIZ8tpxRmCIsRbodoWwNsAInam5ii7wenWVWcZGqtlJ8G9qBiae3wX6jmJ4R+A==
X-Received: by 2002:a05:6602:2e08:: with SMTP id o8mr4332730iow.10.1635445516548;
        Thu, 28 Oct 2021 11:25:16 -0700 (PDT)
Received: from localhost (elenagb.nos-oignons.net. [185.233.100.23])
        by smtp.gmail.com with ESMTPSA id 7sm2071214ilq.32.2021.10.28.11.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 11:25:16 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net: bareudp: fix duplicate checks of data[] expressions
Date:   Thu, 28 Oct 2021 12:24:53 -0600
Message-Id: <20211028182453.9713-2-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

Both !data[IFLA_BAREUDP_PORT] and !data[IFLA_BAREUDP_ETHERTYPE] are
checked.  We should remove the checks of data[IFLA_BAREUDP_PORT] and
data[IFLA_BAREUDP_ETHERTYPE] that follow since they are always true.

Put both statements together in group and balance the space on both
sides of '=' sign.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 drivers/net/bareudp.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 54e321a695ce..edffc3489a12 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -577,11 +577,8 @@ static int bareudp2info(struct nlattr *data[], struct bareudp_conf *conf,
 		return -EINVAL;
 	}
 
-	if (data[IFLA_BAREUDP_PORT])
-		conf->port =  nla_get_u16(data[IFLA_BAREUDP_PORT]);
-
-	if (data[IFLA_BAREUDP_ETHERTYPE])
-		conf->ethertype =  nla_get_u16(data[IFLA_BAREUDP_ETHERTYPE]);
+	conf->port = nla_get_u16(data[IFLA_BAREUDP_PORT]);
+	conf->ethertype = nla_get_u16(data[IFLA_BAREUDP_ETHERTYPE]);
 
 	if (data[IFLA_BAREUDP_SRCPORT_MIN])
 		conf->sport_min =  nla_get_u16(data[IFLA_BAREUDP_SRCPORT_MIN]);
