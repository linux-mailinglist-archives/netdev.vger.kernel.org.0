Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7631B193D
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 00:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgDTWOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 18:14:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21970 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726371AbgDTWOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 18:14:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587420886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MiSDbiTo+2+0bF+oftBWtRobU1R64CceTEeiiGvXzRk=;
        b=WeENLdUECtNUJblMqbb/nZmabXuDc+QE8ThLrx5QTdYx3eueUaDGnaS8dIJUB/6qUT7mOA
        U7Pad0ZTIfXupxjIKqa07/aeew6MN84qyGRt31t3xcGxZJCWdSaBBc2pY3HCeUW5R5fhng
        SRDZIFHRjrGcs6g9a97Nxyg/ggyTax0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-aoNIUofJN7OwJncvIaYdTg-1; Mon, 20 Apr 2020 18:14:44 -0400
X-MC-Unique: aoNIUofJN7OwJncvIaYdTg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 893061005509;
        Mon, 20 Apr 2020 22:14:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-129.rdu2.redhat.com [10.10.113.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8BB676E60;
        Mon, 20 Apr 2020 22:14:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <878siq587w.fsf@cjr.nz>
References: <878siq587w.fsf@cjr.nz> <87imhvj7m6.fsf@cjr.nz> <CAH2r5mv5p=WJQu2SbTn53FeTsXyN6ke_CgEjVARQ3fX8QAtK_w@mail.gmail.com> <3865908.1586874010@warthog.procyon.org.uk> <927453.1587285472@warthog.procyon.org.uk> <1136024.1587388420@warthog.procyon.org.uk>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     dhowells@redhat.com, viro@zeniv.linux.org.uk,
        Steve French <smfrench@gmail.com>, jlayton@redhat.com,
        linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, keyrings@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, fweimer@redhat.com
Subject: cifs - Race between IP address change and sget()?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1986039.1587420879.1@warthog.procyon.org.uk>
Date:   Mon, 20 Apr 2020 23:14:39 +0100
Message-ID: <1986040.1587420879@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paulo Alcantara <pc@cjr.nz> wrote:

> >> > What happens if the IP address the superblock is going to changes, then
> >> > another mount is made back to the original IP address?  Does the second
> >> > mount just pick the original superblock?
> >> 
> >> It is going to transparently reconnect to the new ip address, SMB share,
> >> and cifs superblock is kept unchanged.  We, however, update internal
> >> TCP_Server_Info structure to reflect new destination ip address.
> >> 
> >> For the second mount, since the hostname (extracted out of the UNC path
> >> at mount time) resolves to a new ip address and that address was saved
> >> earlier in TCP_Server_Info structure during reconnect, we will end up
> >> reusing same cifs superblock as per fs/cifs/connect.c:cifs_match_super().
> >
> > Would that be a bug?
> 
> Probably.
> 
> I'm not sure how that code is supposed to work, TBH.

Hmmm...  I think there may be a race here then - but I'm not sure it can be
avoided or if it matters.

Since the address is part of the primary key to sget() for cifs, changing the
IP address will change the primary key.  Jeff tells me that this is governed
by a spinlock taken by cifs_match_super().  However, sget() may be busy
attaching a new mount to the old superblock under the sb_lock core vfs lock,
having already found a match.

Should the change of parameters made by cifs be effected with sb_lock held to
try and avoid ending up using the wrong superblock?

However, because the TCP_Server_Info is apparently updated, it looks like my
original concern is not actually a problem (the idea that if a mounted server
changes its IP address and then a new server comes online at the old IP
address, it might end up sharing superblocks because the IP address is part of
the key).

David

