Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445184B02DE
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbiBJCAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:00:15 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234409AbiBJB7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:59:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC75728CF4;
        Wed,  9 Feb 2022 17:36:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60345616D6;
        Thu, 10 Feb 2022 00:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC71C340E7;
        Thu, 10 Feb 2022 00:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644454711;
        bh=mam86/hmxQgJVtMNzGAN4d9yDX7tUd/mNwP63YOf5F0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V43w39BD+F7dgNOypAmevLK7ZC6WIHOc6o8/cF+MhMVC/EVUxmqPQ8vDQHiDCvV/f
         irB7Wz9NLzP1SlVu6aNFPaBgJOstrhxffUFNNxu7k6VlPF4jCI2nWhjbjGNUgqVs59
         ebtdYPEEZynoQ6PT8+hSwJWjYwlc5fpsjIYH4H0CnnVDlaAtitTDvs7nTOHCfqFMxQ
         qpkZudq2YjYMmvS2UlMID9yAiKRMAJBm1EEhW8XWOyF463eudtGIpR7ye03BHMogZa
         O0ZqLg7Se1rLLIsOKb1hRR41IA2qmnOTOIdoKeX029kqv7d7sFheCZn05VmNx4roUK
         t6EIKQRONKUFg==
Date:   Wed, 9 Feb 2022 16:58:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cpp Code <cpp.code.lv@gmail.com>
Cc:     Pravin Shelar <pravin.ovn@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        ovs dev <dev@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6 extension
 header support
Message-ID: <20220209165830.5f3645ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAASuNyWRh4++uLh4zPuJAuwX4NhYa4HvO1M7iMYdg3Dm0Qbc7Q@mail.gmail.com>
References: <20211124193327.2736-1-cpp.code.lv@gmail.com>
        <CAOrHB_AUCGG0uF4d30Eb4dguPqwvDL8A2c=2EGXqdcqkqLZK-g@mail.gmail.com>
        <CAASuNyWViYk6rt7bpqVApMFJB+k9NKSwasm1H_70uMMRUHxoHw@mail.gmail.com>
        <CAOrHB_D1HKirnub8AQs=tjX60Mc+EP=aWf+xpr9YdOCOAPsi2Q@mail.gmail.com>
        <CAASuNyUKj+dsf++7mhdkjm2mabQggYW4x42_BV=y+VPPSBFqfA@mail.gmail.com>
        <CAOrHB_CyBoTYO8Qn-qtcfrbqfVc9TjaU6ib_2ZSQx-R9ns-bUQ@mail.gmail.com>
        <CAASuNyWRh4++uLh4zPuJAuwX4NhYa4HvO1M7iMYdg3Dm0Qbc7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Feb 2022 12:46:01 -0800 Cpp Code wrote:
> > ok, I see advantage of using skb_header_pointer() in this case, but
> > replacing all check_header() with skb_header_pointer() would add lot
> > of copy operation in flow extract. Anyways for this use case
> > skb_header_pointer() is fine.
> >
> > Acked-by: Pravin B Shelar <pshelar@ovn.org>  
> 
> Could this be applied please.

Please repost with Pravin's ack included.
