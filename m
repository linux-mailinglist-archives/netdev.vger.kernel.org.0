Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2984E1C84
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 17:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245454AbiCTQR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 12:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245448AbiCTQRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 12:17:55 -0400
Received: from relay5.hostedemail.com (relay5.hostedemail.com [64.99.140.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE30643AF7
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 09:16:30 -0700 (PDT)
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay09.hostedemail.com (Postfix) with ESMTP id 404E023056;
        Sun, 20 Mar 2022 16:16:29 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf08.hostedemail.com (Postfix) with ESMTPA id A183320029;
        Sun, 20 Mar 2022 16:16:27 +0000 (UTC)
Message-ID: <fea406c589526e45d9f0167628e9925f29a20217.camel@perches.com>
Subject: Re: [PATCH] ath9k: initialize arrays at compile time
From:   Joe Perches <joe@perches.com>
To:     trix@redhat.com, toke@toke.dk, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 20 Mar 2022 09:16:26 -0700
In-Reply-To: <20220320152028.2263518-1-trix@redhat.com>
References: <20220320152028.2263518-1-trix@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Stat-Signature: dy9osjm7z8ziecmef8cxoawwx5f8z8fy
X-Rspamd-Server: rspamout06
X-Rspamd-Queue-Id: A183320029
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+fRE9F4p8U535woQ4iQkf2ESmX4XbbijM=
X-HE-Tag: 1647792987-69043
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-03-20 at 08:20 -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Early clearing of arrays with
> memset(array, 0, size);
> is equivilent to initializing the array in its decl with
> array[size] = { 0 };

This is true. (typo of equivalent btw)

> Since compile time is preferred over runtime,
> convert the memsets to initializations.

But this is not.

These aren't static but are stack declarations so these can not
be "initialized at compile time".

Both are zeroed at runtime, perhaps with different instructions.
Sometimes with smaller code, sometimes larger.
Sometimes faster, sometimes not.

Anyway, I think the patch is good, but the commit description is not.

> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
[]
> @@ -891,10 +891,9 @@ static void ar9003_hw_tx_iq_cal_outlier_detection(struct ath_hw *ah,
>  {
>  	int i, im, nmeasurement;
>  	int magnitude, phase;
> -	u32 tx_corr_coeff[MAX_MEASUREMENT][AR9300_MAX_CHAINS];
> +	u32 tx_corr_coeff[MAX_MEASUREMENT][AR9300_MAX_CHAINS] = { 0 };
>  	struct ath9k_hw_cal_data *caldata = ah->caldata;
>  
> -	memset(tx_corr_coeff, 0, sizeof(tx_corr_coeff));

etc...



