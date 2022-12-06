Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4E7644595
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 15:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbiLFO0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 09:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiLFO0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 09:26:23 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94817D7E;
        Tue,  6 Dec 2022 06:26:19 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id m18so5045142eji.5;
        Tue, 06 Dec 2022 06:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3Wg3wyhZI1iQp1XKP6mxboGBlL0AzpG0TjS50hdCrEM=;
        b=GXTK4+2h3fN/c9v0DEiyJun1Nm1XyhVTLMlM/+Jyb9MoCD4lkOV3244RiR9LSbyLJX
         LbNhGYfgwFPBa8egNdotONC1yQwlB6O4vyhif26Lj4p2u7Fj5yF6+6G1LaWgAy9ez6Ke
         Sko3vIyWUxp/miDPqpmCCKejeMRsLzww3km1N5AjfxzzallZ+M+DIOeBTLWHtwfm22aT
         trM+Ldfh27UrmzUX5BE1zA05xxBigSrTLULr1UC/Cg3he9npXJif4OEhIiOv0x79hJKd
         LOEj7fwQylbKVnd8bijCOGEVPMdub6SHBZj+DXcavgwNY6mzgAunkrSPqQe1PnXv3Mwk
         ejhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Wg3wyhZI1iQp1XKP6mxboGBlL0AzpG0TjS50hdCrEM=;
        b=h4H0uvZZbt7A+oew6595e2mSUIf7f6KPUlouZtMJDJnuUFIqgyWODi6q8599ddz2zx
         N1dxo4/wuGqiRH0J/GYA/18FwiIW8ClbIqipAWkjwJoLZIb8t6LJhZuAQAzrX0vd+rjN
         JBuAkOZNS+UarDdn2iAEUmuXV2rypofUiG1jshs38b6y1P6og7CWoqTtyiogLSAoSEXX
         NoupXwRRIMngZqbaCANtkBiBUIkcYCFVmPX0OKXK+Vy4n+/NuVwsrSlEC8wMIslr2ZH0
         PZW02nplB9n36WuFoQ34OIhbH+En6Z08C2314+pbD+XtOL+EG1+/FLoXPYqbtItXaDu4
         L8zA==
X-Gm-Message-State: ANoB5pmZQ7AgBaXWU83XWZz/uwiIJs6/9Qus7Q/p+T5HmuhnL1bv7gMX
        gZDZOLxGQud2XL+Cc6FK/B0=
X-Google-Smtp-Source: AA0mqf6J+3aSlpTEjQxJsHcNJ5xwvum3vCNI9XWcwh/QmnikWZfrelRh/I8Bad9Kos4CWkIgvIOCXA==
X-Received: by 2002:a17:906:17c9:b0:782:fd8e:9298 with SMTP id u9-20020a17090617c900b00782fd8e9298mr56803474eje.640.1670336778026;
        Tue, 06 Dec 2022 06:26:18 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id kw25-20020a170907771900b007c0ae8569d6sm1303612ejc.146.2022.12.06.06.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 06:26:17 -0800 (PST)
Date:   Tue, 6 Dec 2022 17:26:05 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: mvneta: Fix an out of bounds check
Message-ID: <Y49Q/Z1X1PKxIFfx@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In an earlier commit, I added a bounds check to prevent an out of bounds
read and a WARN().  On further discussion and consideration that check
was probably too aggressive.  Instead of returning -EINVAL, a better fix
would be to just prevent the out of bounds read but continue the process.

Background: The value of "pp->rxq_def" is a number between 0-7 by default,
or even higher depending on the value of "rxq_number", which is a module
parameter. If the value is more than the number of available CPUs then
it will trigger the WARN() in cpu_max_bits_warn().

Fixes: e8b4fc13900b ("net: mvneta: Prevent out of bounds read in mvneta_config_rss()")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 66b7f27c9a48..5aefaaff0871 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4271,7 +4271,7 @@ static void mvneta_percpu_elect(struct mvneta_port *pp)
 	/* Use the cpu associated to the rxq when it is online, in all
 	 * the other cases, use the cpu 0 which can't be offline.
 	 */
-	if (cpu_online(pp->rxq_def))
+	if (pp->rxq_def < nr_cpu_ids && cpu_online(pp->rxq_def))
 		elected_cpu = pp->rxq_def;
 
 	max_cpu = num_present_cpus();
@@ -4927,9 +4927,6 @@ static int  mvneta_config_rss(struct mvneta_port *pp)
 		napi_disable(&pp->napi);
 	}
 
-	if (pp->indir[0] >= nr_cpu_ids)
-		return -EINVAL;
-
 	pp->rxq_def = pp->indir[0];
 
 	/* Update unicast mapping */
-- 
2.35.1

