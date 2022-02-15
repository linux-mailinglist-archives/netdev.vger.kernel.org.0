Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC83E4B79A7
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 22:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240997AbiBOUyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 15:54:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237170AbiBOUyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 15:54:03 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D029F27159
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 12:53:50 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id u6so39271785lfc.3
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 12:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=zs1X+4dxG6okt2I00rgovQNtmvzB1hcgZ4AtIwR6ja4=;
        b=Pxyt2Sj69HAuCQbk/xiNvFWlU30e4vcxlO9FLridgLaqPAYn3ELvG1kjNpI48i4bQl
         +5f62N2lKQGERrx+wmMZH2AY2gken4mYHG/1eXzjDBTbIIvcQaWAqPLQHWRU6dz/ZAuL
         GWZN15B/MOJtfXTd7RZuYQXw5Z5NEDQAp9YmT3aDMRpwn1wFNlLkoh0jSPAvfBwSbSXa
         av1xtyztg5YtOT20kIQn/4z/FJHfpZFAqVCF2OJ4ol9pPKpke2MjdJtRoU5fMoJYvvjB
         wNQOKhPtBb3itjx6HqhX4h88vrfNoVf7yfQ1IdJi4eJ77nJGu7gkrlzQmPn5PhjQrCqC
         GbJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=zs1X+4dxG6okt2I00rgovQNtmvzB1hcgZ4AtIwR6ja4=;
        b=ekivuYOqbCVR1ZaKnExFvH/k6GFPD+x+0ks9E67W0EQ5twPmtJdxosrLe9Utvaheya
         eTWSk8VYDxQYGKu8i+YrryljyfdsJy9l/WvFA2uFwGM2EfDdJtjpDa66J7+UE9j/OyAu
         QKslLeBfAU8XLkr50PkhtzM315VOiF0WgjpuDitGtQy9JnDI76+QzmepH2nmvJlNNqQY
         4UnqpERFwhrA7HAiqyJMrj570bMQqoHvqRrVKoPPMkoSUbz3aH1gDgOChaGvP8pM4t8k
         uoVZRBGTvgEUcLXQGIA1C5pbv8bhUQe1Sgj2kLpApFCNyXdeN1UmzSUDQY8vAyZqTHN7
         ASVA==
X-Gm-Message-State: AOAM531EGhzfqSO6CpJS+WmvmBBnmLhzC2zyL1KaZZRyY7spyk7xTAbA
        4v9afFWRlEeMDvXz/1q0tJoPIOeo8T0=
X-Google-Smtp-Source: ABdhPJyMN3ccXvC8MeySSLuzmNsEtM7TwLmf9gVY/EfLm6rq/yyEYnrGxyboV36v79AkZapminPGxw==
X-Received: by 2002:a05:6512:398a:: with SMTP id j10mr648960lfu.189.1644958428811;
        Tue, 15 Feb 2022 12:53:48 -0800 (PST)
Received: from [192.168.88.200] (pppoe.178-66-239-7.dynamic.avangarddsl.ru. [178.66.239.7])
        by smtp.gmail.com with ESMTPSA id f6sm1132215lfs.64.2022.02.15.12.53.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 12:53:48 -0800 (PST)
Message-ID: <9766312d-58ae-4219-036e-73a587de1111@gmail.com>
Date:   Tue, 15 Feb 2022 23:53:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
From:   Maxim Petrov <mmrmaximuzz@gmail.com>
Subject: [PATCH iproute2] lnstat: fix strdup leak in -w argument parsing
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'tmp' string is used for safe tokenizing, but it is not required after
getting all the widths in -w option. As 'tmp' string is obtained by strdup
call, the caller has to deallocate it to avoid memory leak.

Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>
---
 misc/lnstat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/misc/lnstat.c b/misc/lnstat.c
index 98904d45..c3293a8e 100644
--- a/misc/lnstat.c
+++ b/misc/lnstat.c
@@ -331,6 +331,7 @@ int main(int argc, char **argv)
 				for (i = 0; i < MAX_FIELDS; i++)
 					fp.params[i].print.width = len;
 			}
+			free(tmp);
 			break;
 		default:
 			usage(argv[0], 1);
-- 
2.25.1
