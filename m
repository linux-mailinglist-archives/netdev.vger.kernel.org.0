Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AF0597364
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 17:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237384AbiHQPvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 11:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237220AbiHQPvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 11:51:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76ABA9BB65
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 08:51:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39253B81E1A
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 15:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F538C433C1;
        Wed, 17 Aug 2022 15:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660751479;
        bh=mRWaSwAWrVSW5xWS69xv2YwO0eCFBQtF69gVkM+CU4s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JfH+8pzazyKLgRpES8TDvrCY3UBRuJyhZqTXY7UifVl8yiMsRMacl3XP4jkABpfq2
         kp1+73fb+vnUyiMnxeLQtkOkZpcpGOoIr942H48lF40kTVJdvIvCKH8c5UrXCLdhgq
         A/qIfytwz1episvXJisn/l8MPy9B/Ztz1grNbCMLVrg80dciPKViX+oVxZ9CS94WzZ
         ZCoFyAOggdXW0hNlDJjPHTWqT5Aj7CfYa8PYeYi5M9nYCr2JA5hbxqE8T7Zj1ipW00
         LK/Ff+0BDUjLsGPsJZ+Y/U2UjVZoGkQnE42cKdce1kPvjGkSCdmitdFJS/1Lq6EXEX
         Q/5eOdHPo0x4w==
Date:   Wed, 17 Aug 2022 08:51:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Haowei Yan <g1042620637@gmail.com>,
        Tom Parkin <tparkin@katalix.com>
Subject: Re: [PATCH net v2] l2tp: Serialize access to sk_user_data with sock
 lock
Message-ID: <20220817085118.0c45c690@kernel.org>
In-Reply-To: <87edxfvsxs.fsf@cloudflare.com>
References: <20220815130107.149345-1-jakub@cloudflare.com>
        <20220816184150.78d6e3e3@kernel.org>
        <87edxfvsxs.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Aug 2022 16:33:33 +0200 Jakub Sitnicki wrote:
> > Note to other netdev maintainers that based on the discussion about 
> > the reuseport locking it's unclear whether we shouldn't also take 
> > the callback lock...  
> 
> You're right. reuseport_array, psock, and kcm protect sk_user_data with
> the callback lock, not the sock lock. Need to fix it.

Where 'it' == current patch? Would you mind adding to the kdoc on
sk_user_data that it's protected by the callback lock while at it?
