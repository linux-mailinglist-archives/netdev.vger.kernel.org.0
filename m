Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29C2517924
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 23:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387668AbiEBVee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 17:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239512AbiEBVed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 17:34:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D82E09E
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 14:31:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B27C60FE2
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731EDC385A4;
        Mon,  2 May 2022 21:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651527063;
        bh=469Q9DNaEIPYIXOr+FOOByQ9W9OuBg7RzK/8YlJ5Ycw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h1OshzAC3BKIPMcF52nOEqxZCYn0us4odyiQrCrEIFkOBEPDWkHUiB3XB+BCEl/AJ
         ckWccs+4sfH70y08rRlLWVBrR+bnTZac5y+uQKgajr74T6tvTrSF8pgXnrl3TwWPdQ
         di9PysVQX+bVg+Y3S9gJx0pnWd4i2Q2ImiH4Z4Tctw/gfc3yL2Q2Fh9tGX4RFg9wzm
         rNv5Yj1dS3zzuROVvX3iDNLNr6dgScPRJBD98Cw8vl1JX9cRwbOWojh2KFj2Lq2AQ+
         Vpq5kEz+ZCGd8gypfS9LvaRVlgJNzbAUcwz8T0NzoOEBrwetFln+8EBnfWzI/8/vJL
         KH2sctDtU1dSQ==
Date:   Mon, 2 May 2022 14:31:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Niels Dossche <dossche.niels@gmail.com>
Cc:     netdev@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Harman Kalra <hkalra@marvell.com>,
        Christina Jacob <cjacob@marvell.com>
Subject: Re: [PATCH net] octeontx2-af: debugfs: fix error return of
 allocations
Message-ID: <20220502143101.3aa37dac@kernel.org>
In-Reply-To: <20220430194656.44357-1-dossche.niels@gmail.com>
References: <20220430194656.44357-1-dossche.niels@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 30 Apr 2022 21:46:56 +0200 Niels Dossche wrote:
> @@ -407,7 +407,7 @@ static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
>  
>  	buf = kzalloc(buf_size, GFP_KERNEL);
>  	if (!buf)
> -		return -ENOSPC;
> +		return -ENOMEM;
>  
>  	/* Get the maximum width of a column */
>  	lf_str_size = get_max_column_width(rvu);

Looks intentional, other allocation failures in this file use ENOMEM.
Still probably worth cleaning up, applied to net-next.
