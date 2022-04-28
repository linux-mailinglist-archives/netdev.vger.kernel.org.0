Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4640F513A68
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244028AbiD1Qz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 12:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235369AbiD1Qz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 12:55:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96927A8896;
        Thu, 28 Apr 2022 09:52:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E50EB82EE5;
        Thu, 28 Apr 2022 16:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A9CC385A0;
        Thu, 28 Apr 2022 16:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651164729;
        bh=fx5RkNquTGCkXNjnkB5LE4zNNi++sI7qkDCeTKCbAew=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NGbGDVjEsm0opha5U9ftTxdHryAA/VQKRKn2EUlfLdiZSAt5RdBUzepHdH1Bsou2r
         D1kaevHCxz4DSnOQJRYjlstVmjgqBYxUm3bEPabei3aSztnyRE22TfuuS+99hrNVXz
         RHpZOuqqfO4kYxhXZObR4iWYowI793SCcC3EQoq7M8/Y8ANrjHvzU568zMdZgGmaL3
         8SnDE6gUR8xBGYTzLAodht3V0gfqDwtdbwmFzujoLoWQKHzOETT4iEA5z5NOOtVypT
         Cbs46T73rCklEXXTQ7boOSv8njZTGDprtA3V8OeGHrGs2oc1yhcxuwdgUzrB4OdN3L
         iFHdrKuCcryKA==
Date:   Thu, 28 Apr 2022 09:52:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <grygorii.strashko@ti.com>, <davem@davemloft.net>
Subject: Re: [PATCH] net: cpsw: add missing of_node_put() in cpsw_probe_dt()
Message-ID: <20220428095207.6a8ce4ed@kernel.org>
In-Reply-To: <20220428014514.2509940-1-yangyingliang@huawei.com>
References: <20220428014514.2509940-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Apr 2022 09:45:14 +0800 Yang Yingliang wrote:
> If devm_kcalloc() fails, 'tmp_node' should be put in cpsw_probe_dt().
> 
> Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Why does the error path (the err_node_put label) 
not put the tmp_node reference either?

> diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
> index bd4b1528cf99..b81179f7d738 100644
> --- a/drivers/net/ethernet/ti/cpsw_new.c
> +++ b/drivers/net/ethernet/ti/cpsw_new.c
> @@ -1246,8 +1246,10 @@ static int cpsw_probe_dt(struct cpsw_common *cpsw)
>  	data->slave_data = devm_kcalloc(dev, CPSW_SLAVE_PORTS_NUM,
>  					sizeof(struct cpsw_slave_data),
>  					GFP_KERNEL);
> -	if (!data->slave_data)
> +	if (!data->slave_data) {
> +		of_node_put(tmp_node);
>  		return -ENOMEM;
> +	}
>  
>  	/* Populate all the child nodes here...
>  	 */

