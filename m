Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966DD6A878C
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 18:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjCBRKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 12:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCBRKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 12:10:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0D93E638
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 09:10:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7982EB811E9
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 17:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C28C433D2;
        Thu,  2 Mar 2023 17:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677777004;
        bh=JnWnhuDLXBpRstUzHZdNmP+BVZ/typcGyQdolsxCSfg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YaeFnvx8wtlUA/r8Cgc+ahh4kKnH8BXnIwOfMfjQ3+YHvPfumGHdxeGdyjhLInZn5
         nRxQobA+wI2pvETzu/V/mh54JlD23d6BsIRYIAXafL+N0Poj9n8/pau5uwqoX/WdSe
         O7bOMnVXy/8J67eIB+TuqcxUe1sKGKQM2rNcKiwohFbCHUpES8nbdPSCqyQnri68ok
         05kzjIwW8ZFx3plJeZjjU5MUlqYWvaf87ztru7lbexWCKBtBwZUk64qKu0l61V443+
         3lriXOS26yFQeNPMmRHBooBW6FCSM4fV7CXITM51fpExeQp3lPF0U5ZE71ixydeqEA
         /UjU6pOIkbxfw==
Date:   Thu, 2 Mar 2023 09:10:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH RFC v1 net-next 1/5] ethtool: Add support for
 configuring tx_push_buf_len
Message-ID: <20230302091003.6e4b1e11@kernel.org>
In-Reply-To: <pj41zledq742hf.fsf@u570694869fb251.ant.amazon.com>
References: <20230301175916.1819491-1-shayagr@amazon.com>
        <20230301175916.1819491-2-shayagr@amazon.com>
        <20230301200055.69e86e53@kernel.org>
        <pj41zledq742hf.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Mar 2023 16:23:59 +0200 Shay Agroskin wrote:
> > Why gate both on kr->tx_push_buf_len and not current and max 
> > separately?
> > Is kr->tx_push_buf_len == 0 never a valid setting?
> 
> Hi, thanks for reviewing it
> 
> There's actually no requirement that tx_push_buf_len needs to be > 
> 0. I'll drop this check.
> It seems like the reply object gets zeroed at 
> ethnl_init_reply_data() so ENA can simply not touch this field if 
> no push buffer exists, leaving the values at 0.

Maybe gate them based on driver supported features?
Save the supported during prep so we don't need to find ops again,
and only report if needed. No point spamming outputs with 0 on all
devices.
