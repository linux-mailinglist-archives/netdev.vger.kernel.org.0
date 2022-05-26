Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD7F534A03
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 06:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241287AbiEZEr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 00:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbiEZEr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 00:47:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FF7562F4
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 21:47:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2D17B81F15
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 04:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7417C385B8;
        Thu, 26 May 2022 04:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653540470;
        bh=dQcN+06ByEQot47T79tud8US6s7E+AuXEPMx73aXhoU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hBqp/riCB6B/CEZlCTNyO8EdviREfriUZUECTgM/jEWq6mUpnxNERs0sE22YLazod
         uXqxRJNCd8nVnkhZYhBcBfwDsXRpue9/shVY4TKmb2W+fZm+XECxS1XE6qYxO2TfaE
         E6nNlt5w0JxJfvh8ZGiRtF6vlLBCDdCxLc3gzibS9/HXcPmNIb6wpqrSvM5bvAueDu
         g2BvCuXlLEuXkOON70A+nucEwgctn1n/3H7ZngLk8FB+ifa7d5n3lLMVx2GKmcWhpq
         GldcNyC4YblXOvs5UYwckzJuDurTN7SHpcrbvwaELWNNR7xUts3Tk8jOueiVTXeG0S
         BTsuKbnW2JNEg==
Date:   Wed, 25 May 2022 21:47:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/3] amt: fix several bugs
Message-ID: <20220525214748.35fd8cf6@kernel.org>
In-Reply-To: <20220523161708.29518-1-ap420073@gmail.com>
References: <20220523161708.29518-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 May 2022 16:17:05 +0000 Taehee Yoo wrote:
> This patchset fixes several bugs in amt module
> 
> First patch fixes typo.
> 
> Second patch fixes wrong return value of amt_update_handler().
> A relay finds a tunnel if it receives an update message from the gateway.
> If it can't find a tunnel, amt_update_handler() should return an error,
> not success. But it always returns success.
> 
> Third patch fixes a possible memory leak in amt_rcv().
> A skb would not be freed if an amt interface doesn't have a socket.

Please double check you're not missing pskb_may_pull() calls.
E.g. in amt_update_handler()? There's more.
