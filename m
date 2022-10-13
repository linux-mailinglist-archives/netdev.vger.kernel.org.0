Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBFD5FDCF6
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiJMPTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJMPTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:19:17 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13B8E09B2;
        Thu, 13 Oct 2022 08:19:16 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id b5so1822550pgb.6;
        Thu, 13 Oct 2022 08:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3muxJhNWv1hg7XONepRN26NwBDFTg3vZFivnKP3G+hw=;
        b=F8jmyvQukbGYiASMQsZRXYBAgV0Gnw2M5nkuujeTetPf3rsaauv9xqFMQYUT5FQ9Ud
         Kzm0YATZRoKU5vKU9gHFXBPOg/rD6S1vhqv6hIGfuZ5kcBrh5w6IZ1bhSSzfKiOObQNs
         UMP6K5+2vUvly2DoPvsBAZPTKeTBWcakE49W3hgUx0wDOWxMeujG93vUGfR/2vPwxihL
         glDzsN22bDxXHParQbQfmUPIxzQ9MwKrKB2doeaqcqTfN1AHs0Ug/bw/R+8scqA8scOF
         OPyhkNNPjjHd0G2cEEHkktgDhX8FLhEX05vFqHnfXkoPY5X7RhhgLUPRx+nOr1bA73L7
         naew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3muxJhNWv1hg7XONepRN26NwBDFTg3vZFivnKP3G+hw=;
        b=owAIRCTwM6A/D/NIdjOS7XreUu6WAg/mKstc/IVC7VTfG9nCbvsDog6IKYRbdZrEpp
         SabhYpETPM/GQLuCjcA693pH43KpnZ43w333ZU6zHwn+lgpYJQ2HLNRHPpsBJsBjdE/P
         D9hx2A6teVfQShYSyrnLa6HRMk/7HBXCBnnPa5OXX48PEoGfkd+0pPIq2U3aCOtqVjiU
         ykY6+3L06vZo6jlDKZprari0/YD5YmWMj3PsPEkb86I+6atqHdeHxv/RUfv9G3O84/pC
         M4YkqpNkC8hoi4qnWMiB2+uYAen/Uu2ftN1F0brLehcY2RGwOVVIyFfKy3d2R93PdPgK
         zaNw==
X-Gm-Message-State: ACrzQf3AQUrw9XP4OxlkAup5XVOF1VopfjkkjWaPcO55ftmphEB6soFG
        7FLpHkBdyspC20PVjHUfLFg=
X-Google-Smtp-Source: AMsMyM7KzUH6zyRCq0rjPfxSwxmRq5ml7euKx/4M8cKfmc6iy6SK4ugTZjvTtd+gJ7hAo2SCwSXXFQ==
X-Received: by 2002:a65:5688:0:b0:3c2:1015:988e with SMTP id v8-20020a655688000000b003c21015988emr349335pgs.280.1665674356367;
        Thu, 13 Oct 2022 08:19:16 -0700 (PDT)
Received: from localhost.localdomain (67.230.176.239.16clouds.com. [67.230.176.239])
        by smtp.gmail.com with ESMTPSA id j63-20020a625542000000b00562e9f636e0sm2260596pfb.10.2022.10.13.08.19.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Oct 2022 08:19:15 -0700 (PDT)
From:   Xiaobo Liu <cppcoffee@gmail.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaobo Liu <cppcoffee@gmail.com>
Subject: [PATCH] net/atm: fix proc_mpc_write 1 byte less calculated
Date:   Thu, 13 Oct 2022 23:19:01 +0800
Message-Id: <20221013151901.29368-1-cppcoffee@gmail.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Then the input contains '\0' or '\n', proc_mpc_write has read them,
so the return value needs +1.

Signed-off-by: Xiaobo Liu <cppcoffee@gmail.com>
---
 net/atm/mpoa_proc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/atm/mpoa_proc.c b/net/atm/mpoa_proc.c
index 829db9eba..444ceda60 100755
--- a/net/atm/mpoa_proc.c
+++ b/net/atm/mpoa_proc.c
@@ -224,8 +224,11 @@ static ssize_t proc_mpc_write(struct file *file, const char __user *buff,
 			free_page((unsigned long)page);
 			return -EFAULT;
 		}
-		if (*p == '\0' || *p == '\n')
+
+		if (*p == '\0' || *p == '\n') {
+			len += 1
 			break;
+		}
 	}
 
 	*p = '\0';
-- 
2.21.0 (Apple Git-122.2)

