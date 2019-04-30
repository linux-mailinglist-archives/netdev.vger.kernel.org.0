Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCFBFC31
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 17:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfD3PGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 11:06:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43850 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfD3PGi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 11:06:38 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 550DE83F3B;
        Tue, 30 Apr 2019 15:06:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-61.rdu2.redhat.com [10.10.120.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F006B600C2;
        Tue, 30 Apr 2019 15:06:32 +0000 (UTC)
Subject: [PATCH 00/11] keys: Namespacing [ver #2]
From:   David Howells <dhowells@redhat.com>
To:     ebiederm@xmission.com
Cc:     linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        Jann Horn <jannh@google.com>, keyrings@vger.kernel.org,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwalsh@redhat.com, vgoyal@redhat.com
Date:   Tue, 30 Apr 2019 16:06:31 +0100
Message-ID: <155663679069.31331.3777091898004242996.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 30 Apr 2019 15:06:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are some patches to make keys and keyrings more namespace aware.  Note
that the branch is dependent on security/next-general.

Firstly some miscellaneous patches to make the process easier:

 (1) Invalidate rather than revoke request_key() authentication keys to
     recycle them more quickly.

 (2) Remove request_key_async*() as they aren't used and would have to be
     namespaced.

 (3) Simplify key index_key handling so that the word-sized chunks
     assoc_array requires don't have to be shifted about, making it easier
     to add more bits into the key.

 (4) Cache the hash value so that we don't have to calculate on every key
     we examine during a search (it involves a bunch of multiplications).

 (5) Allow keying_search() to search non-recursively.

Then the main patches:

 (6) Make it so that keyring names are per-user_namespace from the point of
     view of KEYCTL_JOIN_SESSION_KEYRING so that they're not accessible
     cross-user_namespace.

 (7) Move the user and user-session keyrings to the user_namespace rather
     than the user_struct.  This prevents them propagating directly across
     user_namespaces boundaries (ie. the KEY_SPEC_* flags will only pick
     from the current user_namespace).

 (8) Make it possible to include the target namespace in which the key shall
     operate in the index_key.  This will allow the possibility of multiple
     keys with the same description, but different target domains to be held
     in the same keyring.

 (9) Make it so that keys are implicitly invalidated by removal of a domain
     tag, causing them to be garbage collected.

(10) Institute a network namespace domain tag that allows keys to be
     differentiated by the network namespace in which they operate.  New keys
     that are of a type marked 'KEY_TYPE_NET_DOMAIN' are assigned the network
     domain in force when they are created.

(11) Make it so that the desired network namespace can be handed down into the
     request_key() mechanism.  This allows AFS, NFS, etc. to request keys
     specific to the network namespace of the superblock.

     This also means that the keys in the DNS record cache are thenceforth
     namespaced, provided network filesystems pass the appropriate network
     namespace down into dns_query().

     For DNS, AFS and NFS are good; CIFS and Ceph are not.  Other cache
     keyrings, such as idmapper keyrings, also need to set the domain tag.


Changes:

V2 fixes:
 - Missing initialisation of net key_domain usage count.
 - Missing barriering on the keyring register pointer.
 - Use snprintf() rather than sprintf().
 - Incorrect error handling in search_my_process_keyrings().
 - Incorrect error handling in call_sbin_request_key().

The patches can be found on the following branch:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-namespace

David
---
David Howells (11):
      keys: Invalidate used request_key authentication keys
      keys: Kill off request_key_async{,_with_auxdata}
      keys: Simplify key description management
      keys: Cache the hash value to avoid lots of recalculation
      keys: Add a 'recurse' flag for keyring searches
      keys: Namespace keyring names
      keys: Move the user and user-session keyrings to the user_namespace
      keys: Include target namespace in match criteria
      keys: Garbage collect keys for which the domain has been removed
      keys: Network namespace domain tag
      keys: Pass the network namespace into request_key mechanism


 Documentation/security/keys/core.rst     |   10 +
 certs/blacklist.c                        |    2 
 crypto/asymmetric_keys/asymmetric_type.c |    2 
 fs/afs/addr_list.c                       |    4 
 fs/afs/dynroot.c                         |    7 -
 fs/cifs/dns_resolve.c                    |    3 
 fs/nfs/dns_resolve.c                     |    2 
 include/linux/dns_resolver.h             |    3 
 include/linux/key-type.h                 |    3 
 include/linux/key.h                      |   50 ++++--
 include/linux/sched/user.h               |   14 --
 include/linux/user_namespace.h           |   12 +
 include/net/net_namespace.h              |    4 
 kernel/user.c                            |   10 -
 kernel/user_namespace.c                  |    9 -
 lib/digsig.c                             |    2 
 net/ceph/messenger.c                     |    3 
 net/core/net_namespace.c                 |   19 ++
 net/dns_resolver/dns_key.c               |    1 
 net/dns_resolver/dns_query.c             |    6 -
 net/rxrpc/key.c                          |    6 -
 net/rxrpc/security.c                     |    2 
 security/integrity/digsig_asymmetric.c   |    4 
 security/keys/gc.c                       |    2 
 security/keys/internal.h                 |   10 +
 security/keys/key.c                      |    9 +
 security/keys/keyctl.c                   |    4 
 security/keys/keyring.c                  |  263 +++++++++++++++++-------------
 security/keys/persistent.c               |   10 +
 security/keys/proc.c                     |    3 
 security/keys/process_keys.c             |  252 ++++++++++++++++++-----------
 security/keys/request_key.c              |  113 +++++++------
 security/keys/request_key_auth.c         |    3 
 33 files changed, 508 insertions(+), 339 deletions(-)

