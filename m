Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1569F64E2E9
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 22:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiLOVRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 16:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiLOVRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 16:17:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638A758BF7;
        Thu, 15 Dec 2022 13:17:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0784161F27;
        Thu, 15 Dec 2022 21:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87DBC433EF;
        Thu, 15 Dec 2022 21:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671139021;
        bh=naga9Srm6Vs0kp9gzyWOYSbHJ4ApJqSDzqKZwSyas2o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lk2HkdJFAdcleX8wQ8wFgWbsIF8qYsUVZi43S7kksNKVU8rjLuEZAmceh3Pv9uvTa
         bsG1Bu7H3xpMD+IJL3hcsAzp1eXO2ZoLXF6yV+9KJZSQM0lEVp83kAora/iDavsSRa
         Zmk8PwWBda2GWnh65iXpwibSNbdWUFl0fb5is5JLnANbNApJWXA19vyt2JReGOFf7n
         nPwESpz8gPeGMMtTV0+RBc5Dc+xNIo05TUwdrB9tEAR8aN6R+FVskSiP0nWCOZVhs/
         lWQROmWU5u00vZHKzOrtiutO2mCYQRY/d5LAxST71VLKa02UXnDDyfmak+w+U4dCX6
         qPBogLi6mMFGQ==
Date:   Thu, 15 Dec 2022 13:16:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Decotigny <ddecotig@google.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "Mahesh Bandewar (=?UTF-8?B?4KSu4KS5?=
        =?UTF-8?B?4KWH4KS2IOCkrOCkguCkoeClh+CkteCkvuCksA==?=) " 
        <maheshb@google.com>, David Decotigny <decot+git@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
Subject: Re: [PATCH v1 1/1] net: neigh: persist proxy config across link
 flaps
Message-ID: <20221215131659.7410a1da@kernel.org>
In-Reply-To: <CAG88wWYA72sij4iaWowLpawzM7tJdYdHCKQnE0bjndGO74vROw@mail.gmail.com>
References: <20221213073801.361500-1-decot+git@google.com>
        <20221214204851.2102ba31@kernel.org>
        <CAF2d9jh_O0-uceNq=AP5rqPm9xcn=9y8bVxMD-2EiJ3bD_mZsQ@mail.gmail.com>
        <CAG88wWbZ3eXCFJBZ8mrfvddKiVihF-GfEOYAOmT_7VX_AeOoqQ@mail.gmail.com>
        <20221215110544.7e832e41@kernel.org>
        <CAG88wWYA72sij4iaWowLpawzM7tJdYdHCKQnE0bjndGO74vROw@mail.gmail.com>
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

On Thu, 15 Dec 2022 12:36:32 -0800 David Decotigny wrote:
> > Makes sense. This is not urgent, tho, right?  
> 
> Not that kind of urgent.
> 
> FTR, in the v2 you suggested to use NUD_PERMANENT,

I think that was Alex. I don't have a strong preference. I could see
arguments being made in both directions (basically whether it's more
important to leave objects which are clearly not cache vs we care 
more about consistent behavior based on the permanent flag itself).

Let's limit the reposts until experts are in town ;)

>  I can try to see how this would look like. Note that this will make
> the patch larger and more intrusive, and with potentially a behavior
> change for whoever uses the netlink API directly instead of the
> iproute2 implementation for ip neigh X proxy things.
