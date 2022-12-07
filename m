Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D84B64557B
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 09:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiLGIgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 03:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiLGIgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 03:36:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1CF614D;
        Wed,  7 Dec 2022 00:36:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A87FB815D2;
        Wed,  7 Dec 2022 08:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C48C433D6;
        Wed,  7 Dec 2022 08:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670402167;
        bh=E2k/S4IWq4268SqoF+jsOx7+AvY9SyZ6/+luz3zQmZY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p/JiMyBqjevkUJdnmY2aWRkVd17UAyK6bPKA6BIr+groClPZ910t7m576Y2B2cqlq
         m4aoAy5gCCl+R3Jh58dc3oXacb4HIO21EC+oxo7IVbpyv1dxuEc7gyRAR+mlxUw8XD
         xo8qYpiziGTWyxc3C6py25v99bPJ7wmcWA7vv0ke2CM7ayk3mEOU8svoV2CEVwGN1s
         Q8BPmKPvDdM03jjDb96Y8XT8W3EGV/PWfMIObnqj1YwyjBb5ULxHzkSgBkV+aSVnlb
         4/m4H7gTACIrgHfd3Bzf7rcT9anTfqLYP3RSz09T0wFnKOQVhUAl5y4wsMGkHfDq2n
         vDHwFO27r0bwg==
Date:   Wed, 7 Dec 2022 10:36:02 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Subject: Re: [PATCH net] s390/qeth: fix use-after-free in hsci
Message-ID: <Y5BQctZgtUoYzW92@unreal>
References: <20221206145614.1401170-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206145614.1401170-1-wintera@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 03:56:14PM +0100, Alexandra Winter wrote:
> KASAN found that addr was dereferenced after br2dev_event_work was freed.

Please add KASAN report to be part of commit message.

Thanks

> 
> Fixes: f7936b7b2663 ("s390/qeth: Update MACs of LEARNING_SYNC device")
> Reported-by: Thorsten Winkler <twinkler@linux.ibm.com>
> Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
> Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
> Reviewed-by: Thorsten Winkler <twinkler@linux.ibm.com>
> ---
>  drivers/s390/net/qeth_l2_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
> index 9dc935886e9f..c6ded3fdd715 100644
> --- a/drivers/s390/net/qeth_l2_main.c
> +++ b/drivers/s390/net/qeth_l2_main.c
> @@ -758,7 +758,6 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
>  	struct list_head *iter;
>  	int err = 0;
>  
> -	kfree(br2dev_event_work);
>  	QETH_CARD_TEXT_(card, 4, "b2dw%04lx", event);
>  	QETH_CARD_TEXT_(card, 4, "ma%012llx", ether_addr_to_u64(addr));
>  
> @@ -815,6 +814,7 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
>  	dev_put(brdev);
>  	dev_put(lsyncdev);
>  	dev_put(dstdev);
> +	kfree(br2dev_event_work);
>  }
>  
>  static int qeth_l2_br2dev_queue_work(struct net_device *brdev,
> -- 
> 2.34.1
> 
