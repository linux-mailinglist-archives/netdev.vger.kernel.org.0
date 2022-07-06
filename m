Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6724568C71
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 17:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbiGFPOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 11:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiGFPNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 11:13:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0381F22BF2
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 08:13:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CE4061FAC
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 15:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8802C3411C;
        Wed,  6 Jul 2022 15:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657120434;
        bh=7NJZphqCeO5GSfarY02LTgSHbOVFzLYl3rja7lZQLho=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=fvcIBkAVVCFbNMMwkWy0E7jYN2SXaRwsDILtxLsbDfY7o5JbVW/z2k+llAD6TdGdI
         vN1zKLq3WJXiKHeqKbfInenIqK9s8r1COVxaOEWabT6LnLEmudAbszZRmN0EM7sEqR
         +DAwHcLWTUUbKucEFMOmSgm2O4HYMrlP2gWzE/zYcDnD/wKggFgw4yNmzbTT46Q4mL
         ny6WlgoFGdQcR89+Y4NtkeexYT1JLqTxDW1SRABW3ww7e4PQVkExqso4uf5wdfwAal
         a1V4vgpK04UXFkgClPyEzuX4P2ipuOB3ogg+FzVkPjY+oy75yuvtHOW0c3EG2hXFJ8
         9dkpfqBes54DA==
Message-ID: <2579f17d-159d-ce14-e312-9ceb2da52372@kernel.org>
Date:   Wed, 6 Jul 2022 09:13:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH] net: Fix IP_UNICAST_IF option behavior for connected
 sockets
Content-Language: en-US
To:     Richard Gobert <richardbgobert@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
References: <20220627085219.GA9597@debian>
 <80b97cf6d0591c615a229d754805d989be9183bc.camel@redhat.com>
 <20220705155016.GA17630@debian>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220705155016.GA17630@debian>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/5/22 9:50 AM, Richard Gobert wrote:
> On Tue, Jun 28, 2022 at 03:08:48PM +0200, Paolo Abeni wrote:
>> This also changes a long-established behavior for such socket option.
>> It can break existing application assuming connect() is not affected by
>> IP_UNICAST_IF. I'm unsure we can accept it.
> 
> The IP_UNICAST_IF option was initially introduced for better compatibility
> with the matching Windows socket-option. Its goal was better support for
> wine applications.
> This patch improves the compatibility even further since Windows behaves
> this way for connect()ed sockets.
> 
> Also, I have not been able to find any examples of Linux applications
> that use IP_UNICAST_IF with connect(). It would be quite confusing to use
> this sockopt and expect that it would not affect your socket.
> I think that unless someone finds an example of such a use case, then it
> is better to accept this patch to improve compatibility for applications
> that run with wine.
> 
> What are your thoughts on this?
> 

I can't imagine how a 'connected' socket would propelry work if connect
path does not consider oif and then per message does. i.e, i think the
patch has some risk but is the right thing to do.
