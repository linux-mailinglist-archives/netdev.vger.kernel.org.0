Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84FCE4B0611
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 07:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbiBJGIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 01:08:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiBJGIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 01:08:50 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555C61A5;
        Wed,  9 Feb 2022 22:08:52 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id k4so3961315qvt.6;
        Wed, 09 Feb 2022 22:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7JmUNCH8ILvUpgW5tfKMuBrQ9Oc08aN4VH7PCjI93Sg=;
        b=XURn4hJpnc9rH6q6uqnGir8XcYYLszbadb/32HdlDIZAesJDwK97Yze8V+sz4BhEY5
         PuwMZLEifxqHRd27nB6fRtRvMXY+JF8aW7DZJwJD1avljzuFKC9JC15tANE0zROJOFUv
         Calf8rI/v5S7GvEYHIRtXELkZV0+1nqzFPnysN37w0zj3ZaypfJnMZQpU1QFrZlXVfov
         EfSxVQ99/K9wqGY2ShWsqd+hHWk+CLAhoFS8nVSx2chA857udYczOslXTLHklB8P5Zsm
         gVmhY5QBqAS3pBDbnabH04R89ntWFoOWfQKPA8urWTnS32bnOWXqTrO3NTPKx/gGUSW4
         4dgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7JmUNCH8ILvUpgW5tfKMuBrQ9Oc08aN4VH7PCjI93Sg=;
        b=QScmdlvmoiBPCIZ+67kQZJra7yyuUWwZBRIVmikLmGFa1NOW0wXlxVBrG8kcMHr/t/
         ZVNBI83IpK65XINZEP+A/BeYS/akWvfSBeRdW6dgb4E5V+wWqOKjk0dTqNv0PFelxcCW
         Z2W/grB+C2cOH23oOHLN9eqJVe9vryCTZ0Ut4qSL82WEFkFZrW4X0P/Qfpw+TEjtL8pz
         hY8DH68n89QzucO/JJuOK1AXkUMIG0zKQVMRZDPzPgxZrmEw2sXlBmrrTBRkYCx09s8c
         n23XMWroSY3X0I3ND1h5HFQ9DunZQheZkuu0HWOAQAXjuU5tkHiAguS11e5ovye4osNQ
         0Rfg==
X-Gm-Message-State: AOAM5319Egnj5HXu1Vpl5q+EFwOorg68yNDW/SQuCHKlHiDKom3Yd+SA
        8ukCRK498/59A982b7nch20=
X-Google-Smtp-Source: ABdhPJxoS1gFeEW+kHFthBrPAumPRtegWqJziHdxjRwdjbPjnN9LJW1nPN96Evo+JpE1y6xfm/IGhw==
X-Received: by 2002:ad4:5deb:: with SMTP id jn11mr3994703qvb.120.1644473331569;
        Wed, 09 Feb 2022 22:08:51 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id d11sm10224915qtd.63.2022.02.09.22.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 22:08:51 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH V2] net/802: use struct_size over open coded arithmetic
Date:   Thu, 10 Feb 2022 06:08:45 +0000
Message-Id: <20220210060845.1608290-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>

Replace zero-length array with flexible-array member and make use
of the struct_size() helper in kmalloc(). For example:

struct garp_attr {
    struct rb_node            node;
    enum garp_applicant_state    state;
    u8                type;
    u8                dlen;
    unsigned char            data[];
};

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
---
 net/802/mrp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/802/mrp.c b/net/802/mrp.c
index 35e04cc5390c..880cb9ed9c4b 100644
--- a/net/802/mrp.c
+++ b/net/802/mrp.c
@@ -273,7 +273,7 @@ static struct mrp_attr *mrp_attr_create(struct mrp_applicant *app,
 			return attr;
 		}
 	}
-	attr = kmalloc(sizeof(*attr) + len, GFP_ATOMIC);
+	attr = kmalloc(struct_size(attr, data, len), GFP_ATOMIC);
 	if (!attr)
 		return attr;
 	attr->state = MRP_APPLICANT_VO;
-- 
2.25.1

