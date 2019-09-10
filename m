Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D674AF31A
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 01:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfIJXCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 19:02:48 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35001 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbfIJXCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 19:02:47 -0400
Received: by mail-io1-f65.google.com with SMTP id f4so40780152ion.2;
        Tue, 10 Sep 2019 16:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qFQvEySkMVQBX12lnH0ZCFalhV4g8jKTY1/3imp1kQE=;
        b=IpScRasRmgFQwgEw+l1MwSj9YWZUhrtD/QFkL3h+p+nBJCeW4KtHswV8I7Fa6HkT3Z
         DBRipKPZZ/T6xhnNFMDW3RgWGIXMXIN3QYVfkDxVuYGWo4gf0c8iGOt9P2wOTfCen7lK
         f3hVLn+kzNDkltdMkOwz+AQi+TAMcrjKExt8a8bUmPZuOF960aHyBNo8RLpadn8FUZ9K
         A5r9Ae2ma1+GQv25BwF0ex8kq0KlOdw0Kp90HaKRcqWkY26XSAloMS3WR46WikeeNOf9
         ucunkuignpQiy/4suqjm3kT5Qi75eE8Xw2WfGuiynLrn8WFtKu97U0b8lcFemOUtd69B
         gTfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qFQvEySkMVQBX12lnH0ZCFalhV4g8jKTY1/3imp1kQE=;
        b=U/rCmTfUcNPgmnDz1edCuCktxTmuZ1hAzx4rhReqJWjPSDdb9coo1WcK6u6+cb4uL+
         Dn/ZIU6BTiOkbMJ6EpANSNTVEOwe+bfaSZgh1ZV4itSVjGtABhs4+JHa/ob1OiB78Xa1
         IphRFV401d+UZECv/rzmFg8IxrF0u4CDjVjeHsDfcltEbp4UbtA3RfmrvAvWuHyvTj/z
         u+nuISjA7fc+s7Kb5SZMyL9X6tWiw+Y7e/XLKnLTzUiujT0jA6wIXWYFLdffGtVljGPc
         gomKIyu4RafzuLtOCDhTgVxR/fTtjf5adwg4xKDdYsQuZwoueeN4w2K4XygnkwsBF7Xk
         sJFw==
X-Gm-Message-State: APjAAAVYiys3mGl76WY/fxZ9Zfdxkv7l/515Exb+pnoza+WSTelQ9OEt
        uW1ymCFhVX5oWW4bVzpOY/4=
X-Google-Smtp-Source: APXvYqxg7g+TQmNyPqur7MV1wMlYWfcOO9bGfGA8D0Bdz2Kz1F7gUODgj9ZQ3Ix1h1SjFQtQYMARsg==
X-Received: by 2002:a02:712b:: with SMTP id n43mr7641019jac.2.1568156565341;
        Tue, 10 Sep 2019 16:02:45 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id f6sm13572733iob.58.2019.09.10.16.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 16:02:44 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wimax: i2400: fix memory leak
Date:   Tue, 10 Sep 2019 18:01:40 -0500
Message-Id: <20190910230210.19012-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In i2400m_op_rfkill_sw_toggle cmd buffer should be released along with
skb response.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/wimax/i2400m/op-rfkill.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wimax/i2400m/op-rfkill.c b/drivers/net/wimax/i2400m/op-rfkill.c
index 6642bcb27761..8efb493ceec2 100644
--- a/drivers/net/wimax/i2400m/op-rfkill.c
+++ b/drivers/net/wimax/i2400m/op-rfkill.c
@@ -127,6 +127,7 @@ int i2400m_op_rfkill_sw_toggle(struct wimax_dev *wimax_dev,
 			"%d\n", result);
 	result = 0;
 error_cmd:
+	kfree(cmd);
 	kfree_skb(ack_skb);
 error_msg_to_dev:
 error_alloc:
-- 
2.17.1

