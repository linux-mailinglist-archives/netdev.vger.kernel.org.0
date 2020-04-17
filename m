Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BD51ADC33
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 13:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgDQLbo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Apr 2020 07:31:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:55428 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730236AbgDQLbo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 07:31:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4A696ABEF;
        Fri, 17 Apr 2020 11:31:40 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Chuck Lever <chuck.lever@oracle.com>,
        David Howells <dhowells@redhat.com>
Cc:     Florian Weimer <fweimer@redhat.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, keyrings@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: What's a good default TTL for DNS keys in the kernel
In-Reply-To: <8DC44895-E904-4155-B7B8-B109A777F23C@oracle.com>
References: <874ktl2ide.fsf@oldenburg2.str.redhat.com>
 <3865908.1586874010@warthog.procyon.org.uk>
 <128769.1587032833@warthog.procyon.org.uk>
 <8DC44895-E904-4155-B7B8-B109A777F23C@oracle.com>
Date:   Fri, 17 Apr 2020 13:31:39 +0200
Message-ID: <87sgh22vs4.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chuck Lever <chuck.lever@oracle.com> writes:
> The Linux NFS client won't connect to a new server when the server's
> DNS information changes. A fresh mount operation would be needed for
> the client to recognize and make use of it.
>
> There are mechanisms in the NFSv4 protocol to collect server IP addresses
> from the server itself (fs_locations) and then try those locations if the
> current server fails to respond. But currently that is not implemented in
> Linux (and servers would need to be ready to provide that kind of update).

We have a very similar system in CIFS. Failover can be handled in 2 ways
(technically both can be used at the same time):

a) with DFS, the mount can have a list of possible location to connect
   to, sort of like cross-server symlinks with multiple possible
   targets. Note that the target value uses hostnames.
b) the domain controler can notice the server is down and automatically
   switch the server hostname DNS entry to a backup one with a different IP.

>> CIFS also doesn't make direct use of the TTL, and again this may be because it
>> uses the server address as part of the primary key for the superblock (see
>> cifs_match_super()).

When we try to reconnect after a failure (using (a) or just reconnecting
to same server) we resolve the host again to try to use any new IP (in
case (b) happened). This is done via upcalling using the request_key()
API.

The cifs.upcall prog (from cifs-utils) calls getaddrinfo() and sets a
key with a default TTL of 10mn [2][3] but if the system uses DNS caching
via nscd[1] there's no way to tell how long the old IP will remain in
use...

1: https://linux.die.net/man/8/nscd
2: https://github.com/piastry/cifs-utils/blob/9a8c21ad9e4510a83a3a41f7a04f763a4fe9ec09/cifs.upcall.c#L66
3: https://github.com/piastry/cifs-utils/blob/9a8c21ad9e4510a83a3a41f7a04f763a4fe9ec09/cifs.upcall.c#L783

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
