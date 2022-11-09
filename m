Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9A4623605
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 22:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiKIVpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 16:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiKIVpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 16:45:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFAE2F3AB
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 13:45:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15A69B82010
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 21:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A00AC433D6;
        Wed,  9 Nov 2022 21:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668030338;
        bh=DXoc5gls4vTZKu9vRgbd2UWLjUdVXGLmPsgeISjiHCw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WleEXAflKkK3YlIqNngmuOz1YMPSC+pbd0RZ9ez/OIt7BJqGxCun3/jFBYkAPW8r4
         QcTlbHifgzAgq6sNM7bkSpaYJagT6wZzYKBmf0X4OR9nRqzTBvuH7qX2/JGmeCZcCm
         LPYcpnA+KpEujFjoAQVXC3V2OVUWg+uG2GByBSopmCgZ2fE/OWgZDG2gJUVRJgoZ5+
         8s3yoAwlVKwiB8zpEsfOrppz/GnfWzM5L6Zs+l9//7vAvcD74nf7WR/Dsv8alrcz1z
         FU85qNxIZx4xPVeNCw4gKAjtsK2Fmebvjt2XrXtQVD911zbJ5fG06I+I/hehlp8vHz
         UlShumXxov+/g==
Date:   Wed, 9 Nov 2022 13:45:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Ido Schimmel <idosch@idosch.org>, Jiri Pirko <jiri@resnulli.us>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        bigeasy@linutronix.de, imagedong@tencent.com, kuniyu@amazon.com,
        petrm@nvidia.com
Subject: Re: [patch net-next v2 3/3] net: devlink: add WARN_ON to check
 return value of unregister_netdevice_notifier_net() call
Message-ID: <20221109134536.447890fb@kernel.org>
In-Reply-To: <CANn89iJgTLe0EJ61xYji6W-VzQAGtoXpZJAxgKe-nE9ESw=p7w@mail.gmail.com>
References: <20221108132208.938676-1-jiri@resnulli.us>
        <20221108132208.938676-4-jiri@resnulli.us>
        <Y2uT1AZHtL4XJ20E@shredder>
        <CANn89iJgTLe0EJ61xYji6W-VzQAGtoXpZJAxgKe-nE9ESw=p7w@mail.gmail.com>
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

On Wed, 9 Nov 2022 08:26:10 -0800 Eric Dumazet wrote:
> > On Tue, Nov 08, 2022 at 02:22:08PM +0100, Jiri Pirko wrote:  
> > > From: Jiri Pirko <jiri@nvidia.com>
> > >
> > > As the return value is not 0 only in case there is no such notifier
> > > block registered, add a WARN_ON() to yell about it.
> > >
> > > Suggested-by: Ido Schimmel <idosch@idosch.org>
> > > Signed-off-by: Jiri Pirko <jiri@nvidia.com>  
> >
> > Reviewed-by: Ido Schimmel <idosch@nvidia.com>  
> 
> Please consider WARN_ON_ONCE(), or DEBUG_NET_WARN_ON_ONCE()

Do you have any general guidance on when to pick WARN() vs WARN_ONCE()?
Or should we always prefer _ONCE() going forward?

Let me take the first 2 in, to lower the syzbot volume.
