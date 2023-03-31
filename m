Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C6A6D2797
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 20:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbjCaSNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 14:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjCaSN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 14:13:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3BDDBE3;
        Fri, 31 Mar 2023 11:13:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB2D162AEE;
        Fri, 31 Mar 2023 18:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B25C433EF;
        Fri, 31 Mar 2023 18:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680286407;
        bh=gi1sjbTKdnugRO+PL96kuSl9ZpkullYMQIRnMD+4opM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iKqeZgwj7/oZFEgZi7luiiKzaSpuMx4JhHjR5zsxW49lod4nmNZh3dg7P1xAG7hBK
         oplDtMkzTPCHMkgmCyWv8pE0fAETRZiqUmhSWrFfVf8/3Iabzyq0Z+oSM9NQZ1Fbwd
         CEf05F98mgwLpd0xKBdH5dN5BYMAtWzXYVv0q3nx9XVL5yw9qMt3YyMz1fEMI0M06O
         Cg7SozlIBwZoTskYzzcYgqh6iBzP0QwTPr5hw4cH3Lt9hynzt9yiBfi3VRsqaMR98e
         ewwrhvZQ5tD5fnMP32Y362Q78jal1DHerccan2usf0sGUlf8aOFN37tgNtEnMwz7nS
         3KK8j4m+O1CfA==
Date:   Fri, 31 Mar 2023 11:13:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] netlink: Add multicast group level permissions
Message-ID: <20230331111325.5703499b@kernel.org>
In-Reply-To: <F49500D6-203F-428C-920A-EA43468A4448@oracle.com>
References: <20230329182543.1161480-1-anjali.k.kulkarni@oracle.com>
        <20230329182543.1161480-7-anjali.k.kulkarni@oracle.com>
        <20230330233941.70c98715@kernel.org>
        <830EC978-8B94-42D6-B70F-782724CEC82D@oracle.com>
        <20230331102454.1251a97f@kernel.org>
        <F49500D6-203F-428C-920A-EA43468A4448@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 17:48:18 +0000 Anjali Kulkarni wrote:
> > On Mar 31, 2023, at 10:24 AM, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 31 Mar 2023 17:00:27 +0000 Anjali Kulkarni wrote: =20
> >> Are you suggesting adding something like a new struct proto_ops for
> >> the connector family? I have not looked into that, though that would
> >> seem like a lot of work, and also I have not seen any infra structure
> >> to call into protocol specific bind from netlink bind? =20
> >=20
> > Where you're adding a release callback in patch 2 - there's a bind
> > callback already three lines above. What am I missing? =20
> Ah yes, that one is actually meant to be used for adding(bind) and
> deleting(unbind) multicast group memberships. So it is also called
> from setsockopt() - so I think just checking for root access
> permission changes the semantics of what it is meant to be used for?
> Besides we would need to change some of that ordering there (check
> for permissions & netlink_bind call) and changing it for all users of
> netlink might not be a good idea=E2=80=A6?

AFAICT genetlink uses that callback in the way I'm suggesting already
(see genl_bind()) so if you can spot a bug or a problem - we need to
fix it :S
