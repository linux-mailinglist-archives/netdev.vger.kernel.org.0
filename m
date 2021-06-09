Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB953A1B32
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 18:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhFIQuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 12:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229504AbhFIQuO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 12:50:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E22D613C7;
        Wed,  9 Jun 2021 16:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623257299;
        bh=hHxaS0PsHl0aV79Af27WsPfXn9a5Kv7gST9ycrsXUy8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MYEcht6K+HpkclU45W88qEiWG3ymrqGxG9fB3rG5YgdwGPSIHs6bSLlO8zzK26lAi
         yFnBgsAB9xrUUjgUQ4jcfdVK7aXOAEQYYaAwaQ4o3A8PogZTgVfjgNuYwd252KRco5
         szUagbD5RS9IZBOirQ7jSbM+420RzuJiFZd135UL0L8e90iodAvDjkTw/qpkf3SfnR
         Qlj/dEH6XrqJkNMO8n6XJw8K2pq5/IEi3arUJghERuoT31R5+7xe91D6b2Mb411JDv
         V5aMRhEckyipSQhFxEk7+G5je1W5wijrZngpajK8+CbsnhG08S74KjY+ZXiAVPW3/8
         rSHtKOQYrMgJg==
Date:   Wed, 9 Jun 2021 09:48:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>,
        =?UTF-8?B?QXVyw6ls?= =?UTF-8?B?aWVu?= Aptel <aaptel@suse.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Leif Sahlberg <lsahlber@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: quic in-kernel implementation?
Message-ID: <20210609094818.7aaf21bd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210608153349.0f02ba71@hermes.local>
References: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
        <87pmwxsjxm.fsf@suse.com>
        <CAH2r5msMBZ5AYQcfK=-xrOASzVC0SgoHdPnyqEPRcfd-tzUstw@mail.gmail.com>
        <35352ef0-86ed-aaa5-4a49-b2b08dc3674d@samba.org>
        <CAK-6q+g3_9g++wQGbhzBhk2cp=0fb3aVL9GoAoYNPq6M4QnCdQ@mail.gmail.com>
        <20210608153349.0f02ba71@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Jun 2021 15:33:49 -0700 Stephen Hemminger wrote:
> On Tue, 8 Jun 2021 17:03:16 -0400
> > > With having the fuse-like socket before it should be trivial to switch
> > > between the implementations.    
> > 
> > So a good starting point would be to have such a "fuse-like socket"
> > component? What about having a simple example for that at first
> > without having quic involved. The kernel calls some POSIX-like socket
> > interface which triggers a communication to a user space application.
> > This user space application will then map everything to a user space
> > generated socket. This would be a map from socket struct
> > "proto/proto_ops" to user space and vice versa. The kernel application
> > probably can use the kernel_FOO() (e.g. kernel_recvmsg()) socket api
> > directly then. Exactly like "fuse" as you mentioned just for sockets.
> > 
> > I think two veth interfaces can help to test something like that,
> > either with a "fuse-like socket" on the other end or an user space
> > application. Just doing a ping-pong example.
> > 
> > Afterwards we can look at how to replace the user generated socket
> > application with any $LIBQUIC e.g. msquic implementation as second
> > step.
> 
> Socket state management is complex and timers etc in userspace are hard.

+1 seeing the struggles fuse causes in storage land "fuse for sockets"
is not an exciting temporary solution IMHO..
