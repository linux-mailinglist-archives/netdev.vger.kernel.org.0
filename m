Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C1B1A8C45
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 22:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632944AbgDNURO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 16:17:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2632793AbgDNUQK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 16:16:10 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CF082074D;
        Tue, 14 Apr 2020 20:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586895367;
        bh=4W3gIsYx8mNRm7hQccmDcfI7rVeS0PCbsqaEor2jO1A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=C4uL/J0pV22/gMFfSQyw7mxFz8RSAoHxrbABKat2YAnbqmLdyT1HH96qxNFf6MwZe
         lIYaRIqET3RZlaHuohQThMMnmG3sDfVZdwqkNMQvxZC4N7NbE8Z0K7NUQ1pCA/ZW6r
         0z3amCpYG+5IOToFbZUiDdjckJlO8mLeqbvDwegw=
Message-ID: <e751977dac616d93806d98f4ad3ce144bb1eb244.camel@kernel.org>
Subject: Re: What's a good default TTL for DNS keys in the kernel
From:   Jeff Layton <jlayton@kernel.org>
To:     David Howells <dhowells@redhat.com>, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org
Cc:     keyrings@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweimer@redhat.com
Date:   Tue, 14 Apr 2020 16:16:05 -0400
In-Reply-To: <3865908.1586874010@warthog.procyon.org.uk>
References: <3865908.1586874010@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-04-14 at 15:20 +0100, David Howells wrote:
> Since key.dns_resolver isn't given a TTL for the address information obtained
> for getaddrinfo(), no expiry is set on dns_resolver keys in the kernel for
> NFS, CIFS or Ceph.  AFS gets one if it looks up a cell SRV or AFSDB record
> because that is looked up in the DNS directly, but it doesn't look up A or
> AAAA records, so doesn't get an expiry for the addresses themselves.
> 
> I've previously asked the libc folks if there's a way to get this information
> exposed in struct addrinfo, but I don't think that ended up going anywhere -
> and, in any case, would take a few years to work through the system.
> 
> For the moment, I think I should put a default on any dns_resolver keys and
> have it applied either by the kernel (configurable with a /proc/sys/ setting)
> or by the key.dnf_resolver program (configurable with an /etc file).
> 
> Any suggestion as to the preferred default TTL?  10 minutes?
> 

Typical DNS TTL values are on the order of a day but it can vary widely.
There's really no correct answer for this, since you have no way to tell
how long the entry has been sitting in the DNS server's cache before you
queried for it.

So, you're probably down to just finding some value that doesn't hammer
the DNS server too much, but that allows you to get new entries in a
reasonable amount of time.

10 mins sounds like a reasonable default to me.
-- 
Jeff Layton <jlayton@kernel.org>

