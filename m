Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACDD36E05ED
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 06:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjDMEVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 00:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjDMEVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 00:21:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E311A4
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 21:21:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E947561372
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 04:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C18C433D2;
        Thu, 13 Apr 2023 04:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681359661;
        bh=a7iyMSprvQAiuxOJ0H/Q7m2rxNH4MwLwSCb2Ss9FZSE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bE3DBXOVajXdhk8bYKx+4nrdxCGajailSiPWESEDHwj6KpCGVUcsNZ2oj0ktd/Yjg
         mLmN94u6y0jrc8Wf6Juviqqxh8VxSPIBO4cVpqTLoeDyLo8hVdb7tm/PMqRlplMatT
         BRkFH4wjj0wQ5EIqCELr0ja+RvWa6vZXblVKTZyqfyMo1gYP/5/DhPOtkXJr700cS7
         WA2shVBWEZwyq9z2KIa2QdFfqHH5XkmN3rDjJbmTDHU27Z+HgtEDQJWwySfDljpEMp
         rXeeHaCy2hh9RBNmlxqiIQVe6Z0Zlk/NW4napLN4FQCHiUyJnPSAPAlWew+6PA4F5p
         x1XOa6OQ4zvkQ==
Date:   Wed, 12 Apr 2023 21:20:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     davem@davemloft.net, brouer@redhat.com, netdev@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com, hawk@kernel.org,
        ilias.apalodimas@linaro.org, linyunsheng@huawei.com,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net-next 1/3] net: skb: plumb napi state thru skb
 freeing paths
Message-ID: <20230412212059.1b7a3364@kernel.org>
In-Reply-To: <9ecc38df-a185-fc1f-e94e-cf0c1fef865f@redhat.com>
References: <20230411201800.596103-1-kuba@kernel.org>
        <20230411201800.596103-2-kuba@kernel.org>
        <9ecc38df-a185-fc1f-e94e-cf0c1fef865f@redhat.com>
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

On Wed, 12 Apr 2023 11:29:08 +0200 Jesper Dangaard Brouer wrote:
> On 11/04/2023 22.17, Jakub Kicinski wrote:
> > We maintain a NAPI-local cache of skbs which is fed by napi_consume_skb().
> > Going forward we will also try to cache head and data pages.
> > Plumb the "are we in a normal NAPI context" information thru
> > deeper into the freeing path, up to skb_release_data() and
> > skb_free_head()/skb_pp_recycle().
> > 
> > Use "bool in_normal_napi" rather than bare "int budget",  
> 
> The code was changed to "napi_safe", the desc should reflect this ;-)

Ah, sed would have been a better idea after all :)

> > the further we get from NAPI the more confusing the budget
> > argument may seem (particularly whether 0 or MAX is the
> > correct value to pass in when not in NAPI).  
> 
> I do like the code cleanup.
> It is worth explaining/mentioning that where budget==0 comes from?
> 
> (Cc. Alex, please correct me.)
> My understanding is that this is caused by netconsole/netpoll (see
> net/core/netpoll.c func poll_one_napi()), which is a kernel (net)console
> debugging facility sending UDP packets via using only TX side of
> napi_poll.  Thus, we are really trying to protect against doing these
> recycle tricks for when netpoll/netconcole is running (which I guess
> makes sense as we are likely printing/sending an OOPS msg over UDP).

Yup, that's correct. I'll add a sentence or two to that effect.

