Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9FA5E63B7
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 15:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbiIVNfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 09:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiIVNfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 09:35:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2731895AD5;
        Thu, 22 Sep 2022 06:35:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08F45B836C9;
        Thu, 22 Sep 2022 13:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C88DC433D6;
        Thu, 22 Sep 2022 13:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663853711;
        bh=nJJIoxmfg1ze0By12etJ8sHU9D6q2GWnxZ6S2dAgcn4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iCR7ZDWAugocKrdKeMLcdilgdLE7zqepKo7VgF9tPRnmOlt3GHrXe3wzFAaXNKxcg
         xFQunKcTqplZG/N4KaplTzDlGgs1d0D3VdjU2rUSmYnAlQVEEUe4nZ8Nbi2IxrhRe+
         MSThV4GMcKqoWnvusa/HuJYlikiobrO6/kwY7TVr80aV9g3p8WOjJ7PlYchCiJUhzP
         3nWYuOSDdTvDbOPQvDAzx5vRXZHf2k91kTeDjpFn/mGMzbJ8StUWWtZ248f5U1J5QT
         /F/Mdv0uoV4gblAx7hpIHY4skYdtvNJPFvmZwCT80mWryKD9n8lwBlE7mWp6vsvTEf
         patNCb6U6aJHw==
Date:   Thu, 22 Sep 2022 06:35:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        isdn@linux-pingi.de
Subject: Re: [PATCH] mISDN: fix use-after-free bugs in l1oip timer handlers
Message-ID: <20220922063510.3d241df4@kernel.org>
In-Reply-To: <20220920115716.125741-1-duoming@zju.edu.cn>
References: <20220920115716.125741-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Sep 2022 19:57:16 +0800 Duoming Zhou wrote:
> -	if (timer_pending(&hc->keep_tl))
> -		del_timer(&hc->keep_tl);
> +	del_timer_sync(&hc->keep_tl);
>  
> -	if (timer_pending(&hc->timeout_tl))
> -		del_timer(&hc->timeout_tl);
> +	del_timer_sync(&hc->timeout_tl);
>  
>  	cancel_work_sync(&hc->workq);

There needs to be some more cleverness here.
hc->workq and hc->socket_thread can kick those timers right back in.
