Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84AB15A5863
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 02:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiH3AVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 20:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiH3AVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 20:21:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866376D556;
        Mon, 29 Aug 2022 17:21:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 215286132F;
        Tue, 30 Aug 2022 00:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2D4C433C1;
        Tue, 30 Aug 2022 00:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661818871;
        bh=s+OBNXHeiC/7YlCgYcgl1W4cfCFenomwgAAxuz8XPoU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Gkz2Boz7icTLWU71ES4UPrUbsTszAKYKROAazD14GZ7ZNiKtw0hjA4GCCxrjQLL+g
         CoN6+lNrE37/GrerxrGidpetGxjV87QGdL3LYAgmbnfc4ldLuRWx5C7+g6L9euxRr5
         Kl75B2TNpVqrjCQ4LmBZIAAecN9v23UtBGAMXuZJQK2VYpeXYuvkFYLQDECVTCGBvq
         Hwo0J2roQrWaB7kcN5lWuZgOTUrtp5BKUeqtmPLA0RluFeWW56eCykx187Pr1eaSzJ
         puHMh27ErnDdKgMDh6AzgQFaWJchKcsDbGxST8V2F2lTNF98oV/Ic/qcHamleDH7WT
         H3EUusp49M53w==
Date:   Mon, 29 Aug 2022 17:21:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Peilin Ye <peilin.ye@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Dave Taht <dave.taht@gmail.com>
Subject: Re: [PATCH RFC v2 net-next 0/5] net: Qdisc backpressure
 infrastructure
Message-ID: <20220829172111.4471d913@kernel.org>
In-Reply-To: <Ywzu/ey83T8QCT/Z@pop-os.localdomain>
References: <cover.1651800598.git.peilin.ye@bytedance.com>
        <cover.1661158173.git.peilin.ye@bytedance.com>
        <20220822091737.4b870dbb@kernel.org>
        <Ywzu/ey83T8QCT/Z@pop-os.localdomain>
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

On Mon, 29 Aug 2022 09:53:17 -0700 Cong Wang wrote:
> > Similarly to Eric's comments on v1 I'm not seeing the clear motivation
> > here. Modern high speed UDP users will have a CC in user space, back
> > off and set transmission time on the packets. Could you describe your
> > _actual_ use case / application in more detail?  
> 
> Not everyone implements QUIC or CC, it is really hard to implement CC
> from scratch. This backpressure mechnism is much simpler than CC (TCP or
> QUIC), as clearly it does not deal with any remote congestions.
> 
> And, although this patchset only implements UDP backpressure, it can be
> applied to any other protocol easily, it is protocol-independent.

No disagreement on any of your points. But I don't feel like 
you answered my question about the details of the use case.
