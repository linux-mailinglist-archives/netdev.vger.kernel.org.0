Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19474F6260
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 16:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbiDFOy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 10:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbiDFOy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 10:54:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7293FC854;
        Wed,  6 Apr 2022 04:31:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6B52617A4;
        Wed,  6 Apr 2022 11:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61650C385A3;
        Wed,  6 Apr 2022 11:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649244672;
        bh=rq06VmIuMSd782CjswQUqWiuw4QAO8FvZY+ZJ8QuK7g=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=eTgBx5rJB/8+yVjy2Zo/heV1EaidJsxo9DgXseaMLBGEg6/PAVKRBOSwYMd/ti5yi
         bMXZqADalBiI3q3c8OJk/j2+DUhTylOcgi+TbhgJ4jt9Lk4nTo96B9cqAX42Me83tw
         QIVuZb1+cp/BdNQjP7tDIpZWu/SJRNkfjadDa+NTJ9s4AD+lf6Unfncf7d8oanyl1l
         sulKvpZtYGhUnKfqtNmvawMolKW1eP7ReTuKKT5pTlCGlaBThEZOSeSvgnM1HwjqVU
         XtCYmZK87uR8p/CzGIQk9K/KwshnF/Qy7pifAZA+bn8gewL/H9X69hHkss/UPhBgIn
         481qFTz86eZ0g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 20/22 v3] ray_cs: Improve card_status[]
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <6cae7be8-0329-7b0f-9a61-695f3d0cceb4@stuerz.xyz>
References: <6cae7be8-0329-7b0f-9a61-695f3d0cceb4@stuerz.xyz>
To:     =?utf-8?q?Benjamin_St=C3=BCrz?= <benni@stuerz.xyz>
Cc:     Joe Perches <joe@perches.com>, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164924466816.19026.18285097320216238925.kvalo@kernel.org>
Date:   Wed,  6 Apr 2022 11:31:10 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Benjamin Stürz <benni@stuerz.xyz> wrote:

> On 28.03.22 21:23, Joe Perches wrote:
> > On Mon, 2022-03-28 at 20:21 +0200, Benjamin Stürz wrote:
> >> Replace comments with C99's designated initializers.
> > []
> >> diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
> > []
> >> @@ -2529,20 +2529,23 @@ static void clear_interrupt(ray_dev_t *local)
> >>  #define MAXDATA (PAGE_SIZE - 80)
> >>
> >>  static const char *card_status[] = {
> >> -	"Card inserted - uninitialized",	/* 0 */
> >> -	"Card not downloaded",			/* 1 */
> >> -	"Waiting for download parameters",	/* 2 */
> >> -	"Card doing acquisition",		/* 3 */
> >> -	"Acquisition complete",			/* 4 */
> >> -	"Authentication complete",		/* 5 */
> >> -	"Association complete",			/* 6 */
> >> -	"???", "???", "???", "???",		/* 7 8 9 10 undefined */
> >> -	"Card init error",			/* 11 */
> >> -	"Download parameters error",		/* 12 */
> >> -	"???",					/* 13 */
> >> -	"Acquisition failed",			/* 14 */
> >> -	"Authentication refused",		/* 15 */
> >> -	"Association failed"			/* 16 */
> >> +	[0]  = "Card inserted - uninitialized",
> > 
> > If you are going to do this at all, please use the #defines
> > in drivers/net/wireless/rayctl.h
> > 
> > 	[CARD_INSERTED] = "Card inserted - uninitialized",
> > 	[CARD_AWAITING_PARAM] = "Card not downloaded",
> > 
> > etc...
> > 
> > $ git grep -w -P 'CARD_\w+' drivers/net/wireless/rayctl.h
> > drivers/net/wireless/rayctl.h:#define CARD_INSERTED       (0)
> > drivers/net/wireless/rayctl.h:#define CARD_AWAITING_PARAM (1)
> > drivers/net/wireless/rayctl.h:#define CARD_INIT_ERROR     (11)
> > drivers/net/wireless/rayctl.h:#define CARD_DL_PARAM       (2)
> > drivers/net/wireless/rayctl.h:#define CARD_DL_PARAM_ERROR (12)
> > drivers/net/wireless/rayctl.h:#define CARD_DOING_ACQ      (3)
> > drivers/net/wireless/rayctl.h:#define CARD_ACQ_COMPLETE   (4)
> > drivers/net/wireless/rayctl.h:#define CARD_ACQ_FAILED     (14)
> > drivers/net/wireless/rayctl.h:#define CARD_AUTH_COMPLETE  (5)
> > drivers/net/wireless/rayctl.h:#define CARD_AUTH_REFUSED   (15)
> > drivers/net/wireless/rayctl.h:#define CARD_ASSOC_COMPLETE (6)
> > drivers/net/wireless/rayctl.h:#define CARD_ASSOC_FAILED   (16)
> > 
> >> +	[1]  = "Card not downloaded",
> >> +	[2]  = "Waiting for download parameters",
> >> +	[3]  = "Card doing acquisition",
> >> +	[4]  = "Acquisition complete",
> >> +	[5]  = "Authentication complete",
> >> +	[6]  = "Association complete",
> >> +	[7]  = "???",
> >> +	[8]  = "???",
> >> +	[9]  = "???",
> >> +	[10] = "???",
> >> +	[11] = "Card init error",
> >> +	[12] = "Download parameters error",
> >> +	[13] = "???",
> >> +	[14] = "Acquisition failed",
> >> +	[15] = "Authentication refused",
> >> +	[16] = "Association failed"
> >>  };
> >>
> >>  static const char *nettype[] = { "Adhoc", "Infra " };
> > 
> > 
> 
> 
> - Make card_status[] const, because it should never be modified
> - Replace comments with C99's designated initializers to improve
>   readability and maintainability
> 
> Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>

Please don't include the email discussion in the commit log.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/6cae7be8-0329-7b0f-9a61-695f3d0cceb4@stuerz.xyz/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

