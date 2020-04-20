Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB441B1454
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgDTSVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:21:37 -0400
Received: from mx.cjr.nz ([51.158.111.142]:21034 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727980AbgDTSVd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 14:21:33 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 701BB7FCFC;
        Mon, 20 Apr 2020 18:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1587406891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XLtiuMGzfer0pae2SDTC3iJPxGcLgbM+htJ0fXQblHE=;
        b=JeY6U99PmBoc7K2kOj51HYcjWJeX3//jnLGabU3mmTwXpybaIMRJQSxLX8x/+7gxTOCSTr
        Hv9mwFQRIWgFkU0lT98JLFFXxsnrL4qfqJunWNNOnIL/KrXOyC5lZOjKcC3YlFTbGDQtU6
        xiDiGgZdH4R3VvQD3aMCGUX/PVZDmGHawAflJgUTW+n36YLIYoSEEDxOfqo/4tk0toZJoJ
        QvV5XbHnd5OBz63WIKMLqBxjEsMaOct1YcZv5TRbzGMxha3OUejx3dbWx7r5NQRWS/QhUO
        DPFmdQUzLUwfD0GPDW+5vaZskSiTqXTNvqVn7Ckm/7Bq1RKQO5JmzPsQb+bzrA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     David Howells <dhowells@redhat.com>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, keyrings@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, fweimer@redhat.com
Subject: Re: What's a good default TTL for DNS keys in the kernel
In-Reply-To: <1136024.1587388420@warthog.procyon.org.uk>
References: <87imhvj7m6.fsf@cjr.nz>
 <CAH2r5mv5p=WJQu2SbTn53FeTsXyN6ke_CgEjVARQ3fX8QAtK_w@mail.gmail.com>
 <3865908.1586874010@warthog.procyon.org.uk>
 <927453.1587285472@warthog.procyon.org.uk>
 <1136024.1587388420@warthog.procyon.org.uk>
Date:   Mon, 20 Apr 2020 15:21:23 -0300
Message-ID: <878siq587w.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Paulo Alcantara <pc@cjr.nz> wrote:
>
>> >> For SMB3/CIFS mounts, Paulo added support last year for automatic
>> >> reconnect if the IP address of the server changes.  It also is helpful
>> >> when DFS (global name space) addresses change.
>> >
>> > What happens if the IP address the superblock is going to changes, then
>> > another mount is made back to the original IP address?  Does the second mount
>> > just pick the original superblock?
>> 
>> It is going to transparently reconnect to the new ip address, SMB share,
>> and cifs superblock is kept unchanged.  We, however, update internal
>> TCP_Server_Info structure to reflect new destination ip address.
>> 
>> For the second mount, since the hostname (extracted out of the UNC path
>> at mount time) resolves to a new ip address and that address was saved earlier
>> in TCP_Server_Info structure during reconnect, we will end up
>> reusing same cifs superblock as per fs/cifs/connect.c:cifs_match_super().
>
> Would that be a bug?

Probably.

I'm not sure how that code is supposed to work, TBH.
