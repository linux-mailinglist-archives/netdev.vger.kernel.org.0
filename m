Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBEE74DA971
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 05:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347292AbiCPE5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 00:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbiCPE5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 00:57:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A673A5FF0D;
        Tue, 15 Mar 2022 21:55:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F75FB8175E;
        Wed, 16 Mar 2022 04:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75408C340E9;
        Wed, 16 Mar 2022 04:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647406555;
        bh=amkWBYQoEwRz3FDvhPf8X9F8qTN+mM47tSuGPEtpbPk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ESx3M/er7eLXhFBiE/SnfJLRmSA54LFudzjuAe1Jix7ADi95LTX261Mrk0ZcCjZQe
         JKlPJOiiheZZTXP+bPsr43fWSUu0hhb/uZY98ftPyGH+L5iG6L9ON8qbu17GJiXy+0
         PxYcBLPawsoDsZKXIt4Ir3/ftHCRbb6TWZZOOHMHphn5tTaufQIj6srVwGXIplEiEP
         IoraDRzLtG2R92G4JHLMXxcjI9kTvSMClQGLQ2yLfTLThKFRBSb7yZTCSOft1BKCQa
         KN6oFgt3gJuuLyQuMY2yohuWtQ0xgWITM/ClNiuGw8zd0iOGOfl0z/LDH5hx+DY3ul
         butZYo8yajmlw==
Date:   Tue, 15 Mar 2022 21:55:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     menglong8.dong@gmail.com, rostedt@goodmis.org, mingo@redhat.com,
        xeb@mail.ru, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Biao Jiang <benbjiang@tencent.com>
Subject: Re: [PATCH net-next 1/3] net: gre_demux: add skb drop reasons to
 gre_rcv()
Message-ID: <20220315215553.676a5d24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <daa287f3-fbed-515d-8f37-f2a36234cc8a@kernel.org>
References: <20220314133312.336653-1-imagedong@tencent.com>
        <20220314133312.336653-2-imagedong@tencent.com>
        <20220315200847.68c2efee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <daa287f3-fbed-515d-8f37-f2a36234cc8a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Mar 2022 21:49:01 -0600 David Ahern wrote:
> >>  	ver = skb->data[1]&0x7f;
> >> -	if (ver >= GREPROTO_MAX)
> >> +	if (ver >= GREPROTO_MAX) {
> >> +		reason = SKB_DROP_REASON_GRE_VERSION;  
> > 
> > TBH I'm still not sure what level of granularity we should be shooting
> > for with the reasons. I'd throw all unexpected header values into one 
> > bucket, not go for a reason per field, per protocol. But as I'm said
> > I'm not sure myself, so we can keep what you have..  
> 
> I have stated before I do not believe every single drop point in the
> kernel needs a unique reason code. This is overkill. The reason augments
> information we already have -- the IP from kfree_skb tracepoint.

That's certainly true. I wonder if there is a systematic way of
approaching these additions that'd help us picking the points were 
we add reasons less of a judgment call.
