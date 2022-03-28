Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A9A4E9FBA
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 21:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245669AbiC1TZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 15:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239671AbiC1TZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 15:25:27 -0400
Received: from relay.hostedemail.com (relay.hostedemail.com [64.99.140.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2F44C7B0;
        Mon, 28 Mar 2022 12:23:45 -0700 (PDT)
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay13.hostedemail.com (Postfix) with ESMTP id B818960608;
        Mon, 28 Mar 2022 19:23:43 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf01.hostedemail.com (Postfix) with ESMTPA id 2E06A60009;
        Mon, 28 Mar 2022 19:23:42 +0000 (UTC)
Message-ID: <683c72536c0672aa69c285ee505ec552fa76935f.camel@perches.com>
Subject: Re: [PATCH 20/22 v2] ray_cs: Replace comments with C99 initializers
From:   Joe Perches <joe@perches.com>
To:     Benjamin =?ISO-8859-1?Q?St=FCrz?= <benni@stuerz.xyz>,
        Kalle Valo <kvalo@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 28 Mar 2022 12:23:41 -0700
In-Reply-To: <1b694c4c-100b-951a-20f7-df1c912bb550@stuerz.xyz>
References: <20220326165909.506926-20-benni@stuerz.xyz>
         <164846920750.11945.16978682699891961444.kvalo@kernel.org>
         <1b694c4c-100b-951a-20f7-df1c912bb550@stuerz.xyz>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Stat-Signature: j6q6ks3ibsbnzi366ndy55ttbs79k55w
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 2E06A60009
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19IQarYsxSxQqbvpub87YW3Yy3ZsQhFYBU=
X-HE-Tag: 1648495422-430544
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-03-28 at 20:21 +0200, Benjamin Stürz wrote:
> Replace comments with C99's designated initializers.
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
> +	[0]  = "Card inserted - uninitialized",

If you are going to do this at all, please use the #defines
in drivers/net/wireless/rayctl.h

	[CARD_INSERTED] = "Card inserted - uninitialized",
	[CARD_AWAITING_PARAM] = "Card not downloaded",

etc...

$ git grep -w -P 'CARD_\w+' drivers/net/wireless/rayctl.h
drivers/net/wireless/rayctl.h:#define CARD_INSERTED       (0)
drivers/net/wireless/rayctl.h:#define CARD_AWAITING_PARAM (1)
drivers/net/wireless/rayctl.h:#define CARD_INIT_ERROR     (11)
drivers/net/wireless/rayctl.h:#define CARD_DL_PARAM       (2)
drivers/net/wireless/rayctl.h:#define CARD_DL_PARAM_ERROR (12)
drivers/net/wireless/rayctl.h:#define CARD_DOING_ACQ      (3)
drivers/net/wireless/rayctl.h:#define CARD_ACQ_COMPLETE   (4)
drivers/net/wireless/rayctl.h:#define CARD_ACQ_FAILED     (14)
drivers/net/wireless/rayctl.h:#define CARD_AUTH_COMPLETE  (5)
drivers/net/wireless/rayctl.h:#define CARD_AUTH_REFUSED   (15)
drivers/net/wireless/rayctl.h:#define CARD_ASSOC_COMPLETE (6)
drivers/net/wireless/rayctl.h:#define CARD_ASSOC_FAILED   (16)

> +	[1]  = "Card not downloaded",
> +	[2]  = "Waiting for download parameters",
> +	[3]  = "Card doing acquisition",
> +	[4]  = "Acquisition complete",
> +	[5]  = "Authentication complete",
> +	[6]  = "Association complete",
> +	[7]  = "???",
> +	[8]  = "???",
> +	[9]  = "???",
> +	[10] = "???",
> +	[11] = "Card init error",
> +	[12] = "Download parameters error",
> +	[13] = "???",
> +	[14] = "Acquisition failed",
> +	[15] = "Authentication refused",
> +	[16] = "Association failed"
>  };
> 
>  static const char *nettype[] = { "Adhoc", "Infra " };


