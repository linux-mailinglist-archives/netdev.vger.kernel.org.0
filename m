Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E116553D807
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 19:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239159AbiFDR1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 13:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234420AbiFDR1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 13:27:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7214418363
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 10:27:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB350B803F7
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 17:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D628AC385B8;
        Sat,  4 Jun 2022 17:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654363632;
        bh=LIdNAf4iNmCJBN3uADaV47A/5g2yKhzc0dOSqhxVMe0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V8DavfTmS5XYh0MHpry2rwpXF0WagTQdGX8YxOeIB5XgoTkIu+mmDO9jJTc8ZTUyE
         +olOWD+DGljC+tlIVV2qC2U7Qh/qaUeqDHp3lBsJ/5R9cnapDXv5kSwg+Ax1ycdwAZ
         5/XsEECsH37lbf+8M0jiT9uzgjoBh95+1EVlov6g=
Date:   Sat, 4 Jun 2022 19:27:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Petr Vorel <pvorel@suse.cz>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [RFC] Backporting "add second dif to raw, inet{6,}, udp,
 multicast sockets" to LTS 4.9
Message-ID: <YpuV7QnQNf3C2m3j@kroah.com>
References: <YppqNtTmqjeR5cZV@pevik>
 <YpsvAludRUxuK22U@kroah.com>
 <d33dbbe6-57b0-85a1-83f8-435dd0a7c8c9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d33dbbe6-57b0-85a1-83f8-435dd0a7c8c9@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 04, 2022 at 10:55:12AM -0600, David Ahern wrote:
> On 6/4/22 4:08 AM, Greg Kroah-Hartman wrote:
> > On Fri, Jun 03, 2022 at 10:08:22PM +0200, Petr Vorel wrote:
> >> Hi all,
> >>
> >> David (both), would it be possible to backport your commits from merge
> >> 9bcb5a572fd6 ("Merge branch 'net-l3mdev-Support-for-sockets-bound-to-enslaved-device'")
> >> from v4.14-rc1 to LTS 4.9?
> >>
> >> These commits added second dif to raw, inet{6,}, udp, multicast sockets.
> >> The change is not a fix but a feature - significant change, therefore I
> >> understand if you're aginast backporting it.
> >>
> >> My motivation is to get backported to LTS 4.9 these fixes from v5.17 (which
> >> has been backported to all newer stable/LTS trees):
> >> 2afc3b5a31f9 ("ping: fix the sk_bound_dev_if match in ping_lookup")
> >> 35a79e64de29 ("ping: fix the dif and sdif check in ping_lookup")
> >> cd33bdcbead8 ("ping: remove pr_err from ping_lookup")
> >>
> >> which fix small issue with IPv6 in ICMP datagram socket ("ping" socket).
> >>
> >> These 3 commits depend on 9bcb5a572fd6, particularly on:
> >> 3fa6f616a7a4d ("net: ipv4: add second dif to inet socket lookups")
> >> 4297a0ef08572 ("net: ipv6: add second dif to inet6 socket lookups")
> > 
> > Can't the fixes be backported without the larger api changes needed?
> > 
> > If not, how many commits are you trying to backport here?  And there's
> > no need for David to do this work if you need/want these fixes merged.
> > 
> 
> I think you will find it is a non-trivial amount of work to backport the
> listed patches and their dependencies to 4.9. That said, the test cases
> exist in selftests to give someone confidence that it works properly
> (you will have to remove tests that are not relevant for the
> capabilities in 4.9).

And 4.9.y is only going to be supported for 6 more months.  Why not just
move to 4.14 or newer?  Peter, what is preventing you from doing that if
you want this issue resolved on your systems?

thanks,

greg k-h
