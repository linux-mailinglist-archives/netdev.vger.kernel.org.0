Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0133E5EE4C7
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 21:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbiI1TIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 15:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiI1TH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 15:07:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD1F6E2D5
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 12:07:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1197BB821C3
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 19:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FC3C433C1;
        Wed, 28 Sep 2022 19:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664392075;
        bh=yAg89lI43v4w78qDCwQIoHUMZS32XlPZ3o97pn1ClPU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pakimi1MXQJ1tCMQV2yvrYinWVBnvSkQWDnltPlhuEJju4k2MgfWdzV7vXdIdXGuR
         PzM3hjY0aHXwbgS46wVJIVPJXsvKl8zs/px+Ch0kv7ZkehAxBGtr5ka/LIQWYexz3i
         s2V8ogTxUtApF+fy/PQ/PLeocjoL+SVlnPX89AL7UkfXhaVkjvcGnt5xXHLcw/1f+m
         47hLG0xCMekQYdde0ADxM0SsQIWQ6QxnRfkZPSJwqgBvUb3kp4sQPduvlpSG6C+hfh
         SKX9jFpXgKOglcJUPPcNs+AISYb8ErpfxmEGcKkSU2es5hNfmBUsFy/PStySGzUxiW
         ylhpKsri3pJ9A==
Date:   Wed, 28 Sep 2022 12:07:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com
Subject: Re: [PATCH v2 net-next 3/6] sfc: optional logging of TC offload
 errors
Message-ID: <20220928120754.5671c0d7@kernel.org>
In-Reply-To: <cd10c58a-5b82-10a3-8cf8-4c08f85f87e6@gmail.com>
References: <cover.1664218348.git.ecree.xilinx@gmail.com>
        <a1ff1d57bcd5a8229dd5f2147b09c4b2b896ecc9.1664218348.git.ecree.xilinx@gmail.com>
        <20220928104426.1edd2fa2@kernel.org>
        <b4359f7e-2625-1662-0a78-9dd65bfc8078@gmail.com>
        <20220928113253.1823c7e1@kernel.org>
        <cd10c58a-5b82-10a3-8cf8-4c08f85f87e6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 19:58:23 +0100 Edward Cree wrote:
> On 28/09/2022 19:32, Jakub Kicinski wrote:
> > I won't help with the indirect stuff, I fixed it once a while
> > back already and it keeps getting broken. It must be a case of=20
> > the extack not being plumbed thru, or people being conservative
> > because the errors are not fatal, right? Solvable. =20
>=20
> The conceptual problem, as I see it, is that multiple hw drivers /
>  driver instances might be trying to offload the same tunnel rule,
>  because the ingress device isn't actually specified anywhere in
>  the weird inside-out way TC tunnel rules work.
> So how do you deal with the case where one driver succeeds and
>  another fails to offload, or two fail with different rc and
>  extack messages?

Let's solve practical problems first :) The cases with multiple devices
offloading are rare AFAIK.

> But I really need to go and check what it does right now, because
>  my information might be out of date =E2=80=94 some of this driver code
>  was first written two years ago so maybe it's since been solved.
>=20
> > The printf'ing? I recon something simple like adding a destructor=20
> > for the message to the exack struct so you can allocate the message,  =
=20
>=20
> What about just a flag to say "please kfree() the msg on destruct"?
> I have a hard time imagining a destructor that would need to do
>  anything different.

Yes, seems like that could be good enough. I was wondering if perhaps
someone would like to have a "static" buffer and manage ownership (given
most of the config happens under rtnl_lock) but perhaps that's
unnecessary complexity.

BTW we will prolly need two bits, one to indicate the creator will
actually call free and the other to mark that it's needed. Otherwise
we'd need to sift thru the stack and find all extack instances.
You can if you want to but...

> > or adding a small buffer in place (the messages aren't very long,
> > usually) come to mind. =20
>=20
> Also an option, yeah.  Downside is that it consumes that memory
>  (I guess 80B or so?) for every netlink response whether it's using
>  formatted extack or not; idk if people with lots of netlink
>  traffic might start to care about that.

It's just a buffer on the stack, in the struct, the extack is
transformed into netlink attrs in the same way regardless.
Stack use is the only concern, no other impact on those not using it.

> Should I rustle up an RFC patch for one of these, or post an RFD to
>  the list to canvass other vendors' opinions?

Would be great! Maybe also grep the archive, cause this came up before.
Someone was against this in the past, perhaps, perhaps even me :)
But if it wasn't me we should CC them.
