Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9734F69AA
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 21:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiDFTSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 15:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbiDFTRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 15:17:16 -0400
Received: from relay3.hostedemail.com (relay3.hostedemail.com [64.99.140.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7C62AEE30
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 10:58:41 -0700 (PDT)
Received: from omf13.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay10.hostedemail.com (Postfix) with ESMTP id C613E35D0;
        Wed,  6 Apr 2022 17:58:39 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf13.hostedemail.com (Postfix) with ESMTPA id AA85120011;
        Wed,  6 Apr 2022 17:58:37 +0000 (UTC)
Message-ID: <1064228a2bb8a5fbdcb483295c641c100dd08c9f.camel@perches.com>
Subject: Re: [PATCH v4 1/2] ray_cs: Improve card_status[]
From:   Joe Perches <joe@perches.com>
To:     Benjamin =?ISO-8859-1?Q?St=FCrz?= <benni@stuerz.xyz>,
        kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 06 Apr 2022 10:58:35 -0700
In-Reply-To: <20220406152247.386267-2-benni@stuerz.xyz>
References: <20220406152247.386267-1-benni@stuerz.xyz>
         <20220406152247.386267-2-benni@stuerz.xyz>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Stat-Signature: 4x93hygzkp67pzsimy8pxrem6idwkheg
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: AA85120011
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18okezJojRz1U2N98r1sNAPyIQfCdYT8Jw=
X-HE-Tag: 1649267917-578212
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-04-06 at 17:22 +0200, Benjamin Stürz wrote:
> Replace comments with C99's designated initializers to improve
> readability and maintainability.
[]
> diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
[]
> @@ -2529,20 +2529,23 @@ static void clear_interrupt(ray_dev_t *local)
>  #define MAXDATA (PAGE_SIZE - 80)
>  
>  static const char *card_status[] = {
> -	"Card inserted - uninitialized",	/* 0 */
> -	"Card not downloaded",			/* 1 */
> -	"Waiting for download parameters",	/* 2 */
> -	"Card doing acquisition",		/* 3 */
> -	"Acquisition complete",			/* 4 */
> -	"Authentication complete",		/* 5 */
> -	"Association complete",			/* 6 */
> -	"???", "???", "???", "???",		/* 7 8 9 10 undefined */
> -	"Card init error",			/* 11 */
> -	"Download parameters error",		/* 12 */
> -	"???",					/* 13 */
> -	"Acquisition failed",			/* 14 */
> -	"Authentication refused",		/* 15 */
> -	"Association failed"			/* 16 */
> +	[CARD_INSERTED]		= "Card inserted - uninitialized",
> +	[CARD_AWAITING_PARAM]	= "Card not downloaded",
> +	[CARD_DL_PARAM]		= "Waiting for download parameters",
> +	[CARD_DOING_ACQ]	= "Card doing acquisition",
> +	[CARD_ACQ_COMPLETE]	= "Acquisition complete",
> +	[CARD_AUTH_COMPLETE]	= "Authentication complete",
> +	[CARD_ASSOC_COMPLETE]	= "Association complete",
> +	[7]			= "???",
> +	[8]			= "???",
> +	[9]			= "???",
> +	[10]			= "???",

Rather than using specific numbers and "???"
it's probably better to use no initialization at all
and change the output call to test the array index
ao all of the [number] = "???" could be removed.

---
 drivers/net/wireless/ray_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 87e98ab068ed..29451cd0a22a 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2600,7 +2600,7 @@ static int ray_cs_proc_show(struct seq_file *m, void *v)
 		i = 10;
 	if (i > 16)
 		i = 10;
-	seq_printf(m, "Card status          = %s\n", card_status[i]);
+	seq_printf(m, "Card status          = %s\n", card_status[i] ?: "???");
 
 	seq_printf(m, "Framing mode         = %s\n", framing[translate]);
 

