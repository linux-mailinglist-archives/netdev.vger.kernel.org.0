Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15DCF64545D
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 08:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiLGHGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 02:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiLGHGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 02:06:37 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C4B4B9B8;
        Tue,  6 Dec 2022 23:06:36 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id h10so17196828wrx.3;
        Tue, 06 Dec 2022 23:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aMIaupsjBzYoj3oHl6ISBy9SaKUaHfbUmGVEOiCO/Zw=;
        b=AGMxaYUx7nIsG+zrtjflWNBmycUOvMrq6beQCJqB84swIrJJxKFJZzMW0S9zuJMGjR
         hjCO7agUQtLPdZTbzSsRE7O2IfqoSHCsq1o/LO/WRKQqPB5kHr1iRiqkx3d81z3opg7p
         6vCCIm6GUjk3gULYg4cDEGR+QJHAZMPVDR+zK/Q2v+bxgP35K06lQvjG6tMAh8EQyIjD
         zl7eZOmZ/M/OH9d4WaIc6IDDEboNLPRa3M8hoD/Z8Gk2qMRHgoZE2oyJ7W5DpNUhLPhQ
         7OSh9GOkEec8L6Hv7142d6leif5F0Ujjf68X33bW1ubXPk9O4axBrxSELf5BlEwshmbg
         m4Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aMIaupsjBzYoj3oHl6ISBy9SaKUaHfbUmGVEOiCO/Zw=;
        b=BMYJW155u5VgVqdkRTUGYflLn0Ju58FQss59BuvQRhIbIZEG+BB1X/q9qWnK2ADLt0
         arpFdmfoGz8XhFjSBRgevlkV09Gninw7SnP9DYAu7AWlCDtBPCGKvfjdryITIZhsg7tX
         KOs8AfR+0qfP0R8j6aG1O3HCu7HlLDa/DefoyIT8N1WRpCW2R7b+urpTtbrzb9u2/sxg
         J6CFa63wrXYCuz3DX4quD01dTMmbeQrz9TXw3DX5SrAHrQffnPZwpAG+/Urojax8QrpR
         J5uiwcxN3rgwPxTfLC+HB4QpKj5pG18mAtcvLtwRAVyr9Aoxll8iQV6vx8pPmLJhx9X5
         sG8w==
X-Gm-Message-State: ANoB5pmIwd9JmPtbPt/G0jWDUAYJQZGadqPVrqOeyUCzlMFQsYTK94Lw
        MJwDDUZi+d/Y5a5esL6eBZ0=
X-Google-Smtp-Source: AA0mqf59DrGolkaKKFPghPHRMk6OkfcWCp3fxT5XH/qdWz1zR+6qJb9moMxNQDF7YotJSF42fdwLiQ==
X-Received: by 2002:a5d:4950:0:b0:242:1f80:6cd9 with SMTP id r16-20020a5d4950000000b002421f806cd9mr22980844wrs.405.1670396794508;
        Tue, 06 Dec 2022 23:06:34 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id u16-20020adff890000000b0024165454262sm18739665wrp.11.2022.12.06.23.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 23:06:34 -0800 (PST)
Date:   Wed, 7 Dec 2022 10:06:31 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net v2] net: mvneta: Fix an out of bounds check
Message-ID: <Y5A7d1E5ccwHTYPf@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
v2: fix the subject to say net instead of net-next.

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
