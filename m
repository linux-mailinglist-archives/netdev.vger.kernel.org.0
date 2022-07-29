Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAFBE58530B
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237939AbiG2Poz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237892AbiG2Pox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:44:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5282E87366;
        Fri, 29 Jul 2022 08:44:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4FF4B8283F;
        Fri, 29 Jul 2022 15:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C3DC433B5;
        Fri, 29 Jul 2022 15:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659109489;
        bh=XRDAP0R73Isjq5OKuXb3XBsHRnvHuJUJz236d0YAmT8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gS1PRcPtxzIKKHkPMVQ9EH4aR3W0hjJBxXs+raEr8Ntga2Lyatvm+Uxrf+3fSkpmc
         XtRlRfLLYGl7OlAYGuRxEayU5Hpt/SMIUex62kSALDCiaz7L232RWCO0tkwwca5zX6
         ftykw5LfTsp8Fx3Jxnp7tZoajTF2iH1wZasYPVXTaX+XJ+bN0hDd4/wqQ1g+znQde1
         sY2SKutso+dqdsfwXviFZOth+X6N9+betfbQtEBk86chaMwq/VIPpB87ZG8C2OpYgk
         zvCPoLWNH7/N0nfmVKRPVLCouYn+e8bwMB2ITOF28Bb22pKN6lvL2jm4JJENyYFuMH
         3APeCaWJNDByQ==
Date:   Fri, 29 Jul 2022 08:44:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuniyu@amazon.co.jp, richard_siegfried@systemli.org,
        joannelkoong@gmail.com, socketcan@hartkopp.net,
        gerrit@erg.abdn.ac.uk, tomasz@grobelny.oswiecenia.net,
        dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dccp: put dccp_qpolicy_full() and dccp_qpolicy_push()
 in the same lock
Message-ID: <20220729084448.5a4492cc@kernel.org>
In-Reply-To: <f77aebb0-129a-bc73-0976-854eeea33ae5@gmail.com>
References: <20220727080609.26532-1-hbh25y@gmail.com>
        <20220728200139.1e7d9bc6@kernel.org>
        <f77aebb0-129a-bc73-0976-854eeea33ae5@gmail.com>
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

On Fri, 29 Jul 2022 18:34:39 +0800 Hangyu Hua wrote:
> >> thread1--->lock
> >> thread1--->dccp_qpolicy_full: queue is full. drop a skb  
> > 
> > This linie should say "not full"?  
> 
> dccp_qpolicy_full only call dccp_qpolicy_drop when queue is full. You 
> can check out qpolicy_prio_full. qpolicy_prio_full will drop a skb to 
> make suer there is enough space for the next data. So I think it should 
> be "full" here.

Oh, I see what you're saying. That's unnecessarily complicated, 
I reckon. The "simple" policy suffers from the same problem and 
is easier to understand. Anyway, you already sent v2 and it doesn't
matter enough to warrant v3, so fine.
