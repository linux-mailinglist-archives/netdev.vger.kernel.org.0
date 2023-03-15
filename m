Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B3A6BA645
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 05:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjCOEhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 00:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjCOEhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 00:37:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A84C59E63
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 21:37:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33FA661AC9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332ABC433EF;
        Wed, 15 Mar 2023 04:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678855070;
        bh=PbDrCEESpZPbr3O7600U95r39pZKHGXnaW/Ysy45g5U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UcdPBCx1fMWb367cWKC1vO2SKTcGajgFTLQSqsTzrZ0oyyd5XN35it0ZLkSQZXEPF
         ZpjFWfgkthnEd7rYdca7Ty+NT/gW4fCRsGweJ5CrKB8c962BRz4vXEmktyrWUmSbAb
         ibuur1V3QxX5MMhEz0ORqJ7SRpKdKBi3et6JqFS6ykgqwJjWJ1DvLPMtYVnQJLN/h+
         7XDhhloKtPQuFn3J8F6piQwdN1CSWDkLli4Ig3Egp/wY/9jnnm6Z2EXHeGuR7zpPh4
         NFZvKtCTpRs6V5BjTOI7yu3VEygoPqSBAqJ5LQZjozpqlrtVd0AOUQnxC7UMvM6gwv
         Ygp2GtXEenQGA==
Date:   Tue, 14 Mar 2023 21:37:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, mlxsw@nvidia.com,
        Jacques de Laval <Jacques.De.Laval@westermo.com>
Subject: Re: [PATCH net-next 0/5] net: Extend address label support
Message-ID: <20230314213749.59b2aa43@kernel.org>
In-Reply-To: <ZBCyKtdDBkkECB3I@shredder>
References: <cover.1678448186.git.petrm@nvidia.com>
        <20230310171257.0127e74c@kernel.org>
        <87sfe8sniw.fsf@nvidia.com>
        <20230313151028.78fdfec6@kernel.org>
        <87a60fs2kp.fsf@nvidia.com>
        <ZBCyKtdDBkkECB3I@shredder>
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

On Tue, 14 Mar 2023 19:43:06 +0200 Ido Schimmel wrote:
> On Tue, Mar 14, 2023 at 10:44:00AM +0100, Petr Machata wrote:
> > Like with the labels, address replacement messages with an explicit
> > IFA_PROTO are not bounced, they just neglect to actually change the
> > protocol. But it makes no sense to me that someone would issue address
> > replacement with an explicit proto set which differs from the current
> > one, but would still rely on the fact that the proto doesn't change...  
> 
> Especially when replace does work with IPv6 addresses. Couple that with
> the fact that it's a much newer attribute than the labels (added in
> 5.18) and that it has no support in iproute2, FRR, libnl etc, the
> chances of such a change breaking anyone are slim to none...

Let's add Jacques, in case he knows something we don't know.

Yes, that sounds fairly safe, we can risk it. Then again we may be
putting different pieces of state into one field? There are holes 
next to ifa_proto in most (all?) structures. It wouldn't cost 
us too much to add a field for your exact use case, it seems.
But no strong feelings, ifa_proto > 3 is a free-for-all, anyway.
