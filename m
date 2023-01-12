Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1719667147
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 12:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbjALLvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 06:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjALLvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 06:51:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE9C18B3F;
        Thu, 12 Jan 2023 03:40:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6603062015;
        Thu, 12 Jan 2023 11:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BEEC433EF;
        Thu, 12 Jan 2023 11:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673523652;
        bh=2tx5v7AAONozVAirkomQrh2CmhT+HtyfG5InFeBthBw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qk7VBO6XwJC52EIeTVWvLDnAqT4I3WQXxaP6zk/Gbihm0+OK+mvQDlrICv4JnTzbH
         0itfBVv77HLIOx2/V1Mdg6P7HgYhfTqniLLd7m6S1eIz9aEuJh3ZG1cto0IgH0z05I
         b6lapY4ckaKpZrIV/QaRpzFFurov1t9HaUFGSa2s=
Date:   Thu, 12 Jan 2023 12:40:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paul Holzinger <pholzing@redhat.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        netdev@vger.kernel.org
Subject: Re: [Regression] 6.0.16-6.0.18 kernel no longer return EADDRINUSE
 from bind
Message-ID: <Y7/xwk9lmaNwrDwo@kroah.com>
References: <CAFsF8vL4CGFzWMb38_XviiEgxoKX0GYup=JiUFXUOmagdk9CRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFsF8vL4CGFzWMb38_XviiEgxoKX0GYup=JiUFXUOmagdk9CRg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 04:52:21PM +0100, Paul Holzinger wrote:
> Hi all,
> 
> Since updating to 6.0.16 the bind() system call no longer fails with
> EADDRINUSE when the address is already in use.
> Instead bind() returns 1 in such a case, which is not a valid return
> value for this system call.
> 
> It works with the 6.0.15 kernel and earlier, 6.1.4 and 6.2-rc3 also
> seem to work.
> 
> Fedora bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2159066
> 
> To reproduce you can just run `ncat -l 5000` two times, the second one
> should fail. However it just uses a random port instead.
> 
> As far as I can tell this problem is caused by
> https://lore.kernel.org/stable/20221228144337.512799851@linuxfoundation.org/
> which did not backport commit 7a7160edf1bf properly.
> The line `int ret = -EADDRINUSE, port = snum, l3mdev;` is missing in
> net/ipv4/inet_connection_sock.c.
> This is the working 6.1 patch:
> https://lore.kernel.org/all/20221228144339.969733443@linuxfoundation.org/

As 6.0.y is now end-of-life, is there anything keeping you on that
kernel tree?  If you send a fix-up patch for this, I'll gladly apply it
and push out one more 6.0 release with it.

thanks,
g
reg k-h
