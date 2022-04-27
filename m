Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8F5510D05
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 02:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356309AbiD0AGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 20:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356297AbiD0AGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 20:06:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FE9177CB9;
        Tue, 26 Apr 2022 17:03:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62BA5B823EB;
        Wed, 27 Apr 2022 00:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A68C385A4;
        Wed, 27 Apr 2022 00:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651017816;
        bh=t0zawJnlOyXwzS6WK1c2yglNRvFTH/XaDhjC3G/cH0U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UJPV/z8jzqRLnklprH9L/Jwnm39U4CizfBZ0c4Z3BZbNdwNnIstnX8wMb91JanmsQ
         Ytcvpg38EFUfZjIb86PFIdAyfXXFKimzD7vLv3698oCFMqB8JoV1YjmlJSbEy1+JrI
         QMBcMpJR5O3vDRJhfRdPykZGx60YPhX1dyOmJt7GZqvrGweohyhqFBLSI0bZbvZr5h
         y++QVEpjNWy8+ioJBvifR0EbZ5IEvHPQvMwITWeEJfvXj8NE19INresRfLChWBAPMp
         A7Jip0KdZL6OCNHPMYhh2DbLlZ4IjVTWWVOP83S91lHcv8eAEOTEDRwKglOYRh6kT3
         DUamUXmWnJdGA==
Date:   Tue, 26 Apr 2022 17:03:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Chuck Lever <chuck.lever@oracle.com>, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS
 handshake listener)
Message-ID: <20220426170334.3781cd0e@kernel.org>
In-Reply-To: <40bc060f-f359-081d-9ba7-fae531cf2cd6@suse.de>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
        <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
        <20220425101459.15484d17@kernel.org>
        <66077b73-c1a4-d2ae-c8e4-3e19e9053171@suse.de>
        <1fca2eda-83e4-fe39-13c8-0e5e7553689b@grimberg.me>
        <20220426080247.19bbb64e@kernel.org>
        <40bc060f-f359-081d-9ba7-fae531cf2cd6@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Apr 2022 17:58:39 +0200 Hannes Reinecke wrote:
> > Plus there are more protocols being actively worked on (QUIC, PSP etc.)
> > Having per ULP special sauce to invoke a user space helper is not the
> > paradigm we chose, and the time as inopportune as ever to change that.  
> 
> Which is precisely what we hope to discuss at LSF.
> (Yes, I know, probably not the best venue to discuss network stuff ...)

Indeed.

> Each approach has its drawbacks:
> 
> - Establishing sockets from userspace will cause issues during 
> reconnection, as then someone (aka the kernel) will have to inform 
> userspace that a new connection will need to be established.
> (And that has to happen while the root filesystem is potentially 
> inaccessible, so you can't just call arbitrary commands here)
> (Especially call_usermodehelper() is out of the game)

Indeed, we may need _some_ form of a notification mechanism and that's
okay. Can be a (more generic) socket, can be something based on existing
network storage APIs (IDK what you have there).

My thinking was that establishing the session in user space would be
easiest. We wouldn't need all the special getsockopt()s which AFAIU
work around part of the handshake being done in the kernel, and which,
I hope we can agree, are not beautiful.

> - Having ULP helpers (as with this design) mitigates that problem 
> somewhat in the sense that you can mlock() that daemon and having it 
> polling on an intermediate socket; that solves the notification problem.
> But you have to have ULP special sauce here to make it work.

TBH I don't see how this is much different to option 1 in terms of
constraints & requirements on the user space agent. We can implement
option 1 over a socket-like interface, too, and that'll carry
notifications all the same.

> - Moving everything in kernel is ... possible. But then you have yet 
> another security-relevant piece of code in the kernel which needs to be 
> audited, CVEd etc. Not to mention the usual policy discussion whether it 
> really belongs into the kernel.

Yeah, if that gets posted it'd be great if it includes removing me from
the TLS maintainers 'cause I want to sleep at night ;)

> So I don't really see any obvious way to go; best we can do is to pick 
> the least ugly :-(

True, I'm sure we can find some middle ground between 1 and 2.
Preferably implemented in a way where the mechanism is separated 
from the fact it's carrying TLS handshake requests, so that it can
carry something else tomorrow.
