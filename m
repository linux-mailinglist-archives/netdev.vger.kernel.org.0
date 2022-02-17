Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 892B14BABAB
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 22:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244255AbiBQVXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 16:23:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242293AbiBQVXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 16:23:33 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF6F8020D;
        Thu, 17 Feb 2022 13:23:18 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id u5so5573380ple.3;
        Thu, 17 Feb 2022 13:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8z3d63SHqcR3mVKHY24fDb7BLgrlDasVQnpnwy2k9bA=;
        b=Or2EAeF7OG9Y0jkZlUMw5eiIyDn8Jn5IMGBUKJoepqo9VcwlEbh8Yn0VEqKAvAmFhT
         weo8hKHvvJN5o7MM62XT02IsvY5YteZJPBb7J3YFTGPwuZCqFBJXEuYeAqpJY2/cG1zO
         4NScJxRj9PJlK+5xsDVSZGFx+4qjQLiuKF9UsNSKnk8ezGfJGSDX6iaZ2uQK0ppjOql+
         r1IAAizitkSMZLuWFOXlvRuESmn2Pm+L/vBj0hwGqd8tUhYl9PYSvGZfX5dtDDRH45og
         th84ud2vVbyEwrL+IOWOmpnN0VDSJkWS3eroA+bMqUXYjVH1PwPUNhcLi8VSB23yQCus
         asNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8z3d63SHqcR3mVKHY24fDb7BLgrlDasVQnpnwy2k9bA=;
        b=gLRB57uW2G706lxGZWXYMOR8vqlCmDYs/TdPKoz0nkectmhxjXiknpQ5N7yRwR52wQ
         oW/SbBU4xeHWwe5ytIXQsDSw9ptlvJw/OQJ03DGsXdB9YGnqabaoYM1Ibb6MSXmryE+j
         1IBQaCyTJkmh/DLkx6b/MQF8m53m8s0ayQh22PBBncjkYwKyIsn4k5xZ/I4YJgG/WtYF
         lnd3DM3H7aEgBXZydsxDMPhgyEVEfDL1AckAUtvmgDOT95qV6GBkMPy4Frt7aeydSgJJ
         JjSX+il66x9lAbarbOc+E6Bg0glshHKWWcLPgzM4L+9qdtRrHbm90Wo+7g4sMzDg+XF+
         coVQ==
X-Gm-Message-State: AOAM5323Y7IuTQnRYp7QOJqTxj8uoLHcnKYP5yV5Uvbpole15FB/Hph1
        6x1JQjFsYrhD3mvlBkwNtYI=
X-Google-Smtp-Source: ABdhPJyFjH22s7GuFlRHTSHAsxZp5MToH7MfkJjgeqx06xX0SCyD6FKiRXcYAxzgw+IPq9OocGqd8A==
X-Received: by 2002:a17:90a:f409:b0:1b8:b6fe:5adf with SMTP id ch9-20020a17090af40900b001b8b6fe5adfmr4873749pjb.49.1645132997692;
        Thu, 17 Feb 2022 13:23:17 -0800 (PST)
Received: from jeffreyji1.c.googlers.com.com (180.145.227.35.bc.googleusercontent.com. [35.227.145.180])
        by smtp.gmail.com with ESMTPSA id s2sm520899pfk.3.2022.02.17.13.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 13:23:16 -0800 (PST)
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
X-Google-Original-From: Jeffrey Ji <jeffreyji@google.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Brian Vazquez <brianvv@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        jeffreyji <jeffreyji@google.com>
Subject: [PATCH v2 net-next] teaming: deliver link-local packets with the link they arrive on
Date:   Thu, 17 Feb 2022 21:23:12 +0000
Message-Id: <20220217212312.2827792-1-jeffreyji@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
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

From: jeffreyji <jeffreyji@google.com>

skb is ignored if team port is disabled. We want the skb to be delivered
if it's an link layer packet.

Issue is already fixed for bonding in
commit b89f04c61efe ("bonding: deliver link-local packets with skb->dev set to link that packets arrived on")

changelog:

v2: change LLDP -> link layer in comments/commit descrip, comment format

Signed-off-by: jeffreyji <jeffreyji@google.com>
---
 drivers/net/team/team.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 8b2adc56b92a..b07dde6f0abf 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -734,6 +734,11 @@ static rx_handler_result_t team_handle_frame(struct sk_buff **pskb)
 	port = team_port_get_rcu(skb->dev);
 	team = port->team;
 	if (!team_port_enabled(port)) {
+		if (is_link_local_ether_addr(eth_hdr(skb)->h_dest))
+			/* link-local packets are mostly useful when stack receives them
+			 * with the link they arrive on.
+			 */
+			return RX_HANDLER_PASS;
 		/* allow exact match delivery for disabled ports */
 		res = RX_HANDLER_EXACT;
 	} else {
-- 
2.35.1.265.g69c8d7142f-goog

