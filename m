Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3FB4ACC0D
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 23:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236733AbiBGW3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 17:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235284AbiBGW3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 17:29:07 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7A0C061355
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 14:29:06 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3-20020a250103000000b0061d99b7d0b8so10795735ybb.13
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 14:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=QuijYF+04EYaRO1xmsTnFw9WlvdYW3PC3n9o6MreiFo=;
        b=Ys5Xu0fgkt3dS1V4emV9InTqPge5N86XyCxBB7ADLoUwknheJVZIaYw+E+293FI1/n
         z40X2I+5kz5qluTA5XzKZYW/AszDDzysUSerh2dShoLeFIJjSqamdiotQgDGKBhkyUpS
         cnEnNevLkYCglq7pi/afj3y89TQNw2S3HtIh6GIKjfkFMmb5Vxa0Uk1QYRW18v5owYot
         zVwuPJAxT1tZetpARaI274Lr+pYOtsubsPLdVXMqKmpmTPSHHt9W3gBZqWxq2rYUL32b
         fcyNlYA5sRc3Ah8Jma+VrQSAj6bWFJ8kvvHA2XEtFdl9v8ySIfc3lEbF7uTvgcht/07g
         xC7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=QuijYF+04EYaRO1xmsTnFw9WlvdYW3PC3n9o6MreiFo=;
        b=P8ZsUab5/aWFDjgSz2lJa5WZxBfdYEZOVazMo2zqoMksvuEeZct5p6UeP9p/2cVLUK
         nRUxkiSZWnX9PwdrE0HIQ4TUcOV10AiVCqYHTFVq8FS2n3/zsH0i8/o3Q5QltDGdbbM/
         xPp/lJ9bJ2XrWqsDTGi1s6Op30VYJByoON/3XljfFbl6+HIIaxbXCjZ/NmurGPN7dpj+
         DGlGGLnF4Q3xxPKyTEZxaxu+qTnXzB3ItSehW9GfSWt0iTDakysGGhfYFf+g7odFiaXN
         LBbtQNG0xS8u+A/0zr0RHD53dfe6fDNyyfYudB0GCvDQ+8Jz7sJvVpYOxngHaEUKZ67x
         Iz6Q==
X-Gm-Message-State: AOAM533DAuUHLNvrWOfXKH8phTD4w3bFUyX4kfKJfVWnaFNBWU1yrGFo
        zYqr2Bg12TSOsb4X4lNxl/KoCrWWM7gq4IN4QAFm9xuJ7JXbpyQ/d0BKsp7CQM3n1fiuGmZDPQf
        tCKpO1tFg9HJ0Ri1s4TGtKqkp1cBV0h2g6aTnj7lD4BERaqNXiZismvI5zsyavhll
X-Google-Smtp-Source: ABdhPJyyxOBqlQwmlJhyu9LGk0DyinOI2OizdZgZ8UE5qRTFrhrLLCyoqwjuvi91NRY6pbuDvpYi1NOO3iPM
X-Received: from coldfire2.svl.corp.google.com ([2620:15c:2c4:201:b98b:c7e7:44b:5c2d])
 (user=maheshb job=sendgmr) by 2002:a25:900d:: with SMTP id
 s13mr2046493ybl.550.1644272945751; Mon, 07 Feb 2022 14:29:05 -0800 (PST)
Date:   Mon,  7 Feb 2022 14:29:01 -0800
Message-Id: <20220207222901.1795287-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v4] bonding: pair enable_port with slave_arr_updates
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When 803.2ad mode enables a participating port, it should update
the slave-array. I have observed that the member links are participating
and are part of the active aggregator while the traffic is egressing via
only one member link (in a case where two links are participating). Via
kprobes I discovered that slave-arr has only one link added while
the other participating link wasn't part of the slave-arr.

I couldn't see what caused that situation but the simple code-walk
through provided me hints that the enable_port wasn't always associated
with the slave-array update.

Fixes: ee6377147409 ("bonding: Simplify the xmit function for modes that us=
e xmit_hash")
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
---
 drivers/net/bonding/bond_3ad.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 6006c2e8fa2b..9fd1d6cba3cd 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1021,8 +1021,8 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
 				if (port->aggregator &&
 				    port->aggregator->is_active &&
 				    !__port_is_enabled(port)) {
-
 					__enable_port(port);
+					*update_slave_arr = true;
 				}
 			}
 			break;
@@ -1779,6 +1779,7 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 			     port = port->next_port_in_aggregator) {
 				__enable_port(port);
 			}
+			*update_slave_arr = true;
 		}
 	}
 
-- 
2.35.0.263.gb82422642f-goog

