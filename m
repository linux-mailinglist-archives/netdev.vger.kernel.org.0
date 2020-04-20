Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053BC1AFF63
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 03:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgDTBGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 21:06:10 -0400
Received: from mx.cjr.nz ([51.158.111.142]:30162 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725949AbgDTBGJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 21:06:09 -0400
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Apr 2020 21:06:08 EDT
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 4D1BC7FCFC;
        Mon, 20 Apr 2020 00:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1587344312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UAr7dQ1lkh5Q0MOSA+C5E6a/FibwZsB/6txDi0hUANQ=;
        b=NDBi3jMq9coPi8YRdzSeQB0Y1zLZ5hA6rcD82Eutcxbaudjs5HacYYdLbi6/XFiHiW6JRa
        xjQLgknfdLihkIdqkp0WpVPftqBnWUtiIIxrPn+F+Wf/3dMwavyxXObm3+jjxI+Va6Hhvh
        U2FQE/cL0C4A+YZJnwXe0GMtk/HbCTg5XJ9hqhj1QketlwCv9ANViPQF66gOvZD3Nli1Kj
        EcyM3gGEZ6JHL0qzfei5TjQ73DVLh5pQJ0Z6OLuCUogsIsjcILpPR2vJzOlNqnIkpewArk
        TuiohUvQfc08jNbN9FPzp2dA5vcdK/vskwY+ueQhovb/36hVqlUgPs1IKPmm1Q==
From:   Paulo Alcantara <pc@cjr.nz>
To:     David Howells <dhowells@redhat.com>,
        Steve French <smfrench@gmail.com>
Cc:     dhowells@redhat.com, linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, keyrings@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, fweimer@redhat.com
Subject: Re: What's a good default TTL for DNS keys in the kernel
In-Reply-To: <927453.1587285472@warthog.procyon.org.uk>
References: <CAH2r5mv5p=WJQu2SbTn53FeTsXyN6ke_CgEjVARQ3fX8QAtK_w@mail.gmail.com>
 <3865908.1586874010@warthog.procyon.org.uk>
 <927453.1587285472@warthog.procyon.org.uk>
Date:   Sun, 19 Apr 2020 21:58:25 -0300
Message-ID: <87imhvj7m6.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Steve French <smfrench@gmail.com> wrote:
>
>> For SMB3/CIFS mounts, Paulo added support last year for automatic
>> reconnect if the IP address of the server changes.  It also is helpful
>> when DFS (global name space) addresses change.
>
> What happens if the IP address the superblock is going to changes, then
> another mount is made back to the original IP address?  Does the second mount
> just pick the original superblock?

It is going to transparently reconnect to the new ip address, SMB share,
and cifs superblock is kept unchanged.  We, however, update internal
TCP_Server_Info structure to reflect new destination ip address.

For the second mount, since the hostname (extracted out of the UNC path
at mount time) resolves to a new ip address and that address was saved earlier
in TCP_Server_Info structure during reconnect, we will end up
reusing same cifs superblock as per fs/cifs/connect.c:cifs_match_super().
