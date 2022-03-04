Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1904CCCF4
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 06:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238095AbiCDFU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 00:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237340AbiCDFUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 00:20:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D189C184B5C;
        Thu,  3 Mar 2022 21:19:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56D1261BC2;
        Fri,  4 Mar 2022 05:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAC9C340E9;
        Fri,  4 Mar 2022 05:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646371194;
        bh=1syFzkLYlaK4Nlev3kwooahlVeSR21eC4nLtX/E7zz8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nbgtjBsdXTJh3QuZrpVH9t1n4E/f1HYyRvUmHhhL50fcJ1oBQH+QcZgWmIQszw0pz
         PyFA4kt6irWBMSbhg9LWURKb8Ufm0nyonuiVSYw+XOa7BnLVaWhKsSZR+MDTrNL0Ix
         3L9I3nFZn8I4XQDvexlUPgM9MNLvb3orh5Jnx3UzaoPSMl62gUAnv0HrzvYC7L5Czz
         w6ivVvU0Vxw0ZdGIO8KJK2Nh8bnb6AvcwDTm9niOa6y+Cq0muZWGwwkgldFeDM0Ql+
         NGB4ePgSZEpwmIOmM5bKTNvSZxeB6b+vaHmgZ9aS5gZ8BwE0V7WlVqv9NB8gmL3mMn
         KjAj4ZTM9lrVA==
Date:   Thu, 3 Mar 2022 21:19:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: qlogic: check the return value of
 dma_alloc_coherent() in qed_vf_hw_prepare()
Message-ID: <20220303211953.7d937dfc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220303033450.2108-1-baijiaju1990@gmail.com>
References: <20220303033450.2108-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Mar 2022 19:34:50 -0800 Jia-Ju Bai wrote:
> --- a/drivers/net/ethernet/qlogic/qed/qed_vf.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_vf.c
> @@ -513,6 +513,9 @@ int qed_vf_hw_prepare(struct qed_hwfn *p_hwfn)
>  						    p_iov->bulletin.size,
>  						    &p_iov->bulletin.phys,
>  						    GFP_KERNEL);
> +	if (!p_iov->bulletin.p_virt)
> +		goto free_vf2pf_request;

leaking the reply buffer
