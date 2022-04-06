Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4EA4F6BF5
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbiDFVBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235097AbiDFVBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:01:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D88E0F4
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 12:26:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B5ACB8252B
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 19:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EDCC385A5;
        Wed,  6 Apr 2022 19:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649273178;
        bh=4mMredy28mGbjg2kKITJg/1T3LzjD+BhUB+GJLVAbYk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KcPyRxAbbQ9QHB3GR8usRZn8gSf20tXb5CRNqKW9Jp4hreylG7DKnHyqaeA/9Vgya
         Q3T2ARdrlhykgBtueWmR6+XYBWVtZnP/8Gsfv3J5UDnSM+6Yr1gj+WSU7iNnMA4C6T
         eEc78z71PzGJebSLm+a4i5xCHhqbEIAKAxa2lYAxgUz2SRVoQb4mcbnPiYiRWJy8bW
         Jhz7c//ZEFxI+EvnpIfIspRGhgXm3JxOvAF0J5t+wCLNE6o7H0Xm+STI2l5PufUn4o
         pZ/T9Z5hZnOC0eXbiEXa+h5bRH6ECOI1b2UWszUVtW5+btSs22sZAfIzbARqdd8KjK
         d62KCyx848bBA==
Date:   Wed, 6 Apr 2022 12:26:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: Re: [PATCH net-next] tcp: add accessors to read/set tp->snd_cwnd
Message-ID: <20220406122616.302dc84c@kernel.org>
In-Reply-To: <20220405233538.947344-1-eric.dumazet@gmail.com>
References: <20220405233538.947344-1-eric.dumazet@gmail.com>
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

On Tue,  5 Apr 2022 16:35:38 -0700 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We had various bugs over the years with code
> breaking the assumption that tp->snd_cwnd is greater
> than zero.
> 
> Lately, syzbot reported the WARN_ON_ONCE(!tp->prior_cwnd) added
> in commit 8b8a321ff72c ("tcp: fix zero cwnd in tcp_cwnd_reduction")
> can trigger, and without a repro we would have to spend
> considerable time finding the bug.
> 
> Instead of complaining too late, we want to catch where
> and when tp->snd_cwnd is set to an illegal value.

I wish we could cover BPF CCs as well :)
