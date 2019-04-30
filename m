Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E284E10283
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 00:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfD3Wj0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Apr 2019 18:39:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58638 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbfD3WjZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 18:39:25 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 237C2308A9E2;
        Tue, 30 Apr 2019 22:39:25 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-61.rdu2.redhat.com [10.10.120.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 669F317244;
        Tue, 30 Apr 2019 22:39:21 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     jmorris@namei.org
cc:     dhowells@redhat.com, dwalsh@redhat.com, vgoyal@redhat.com,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [GIT PULL] keys: Namespacing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <560.1556663960.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date:   Tue, 30 Apr 2019 23:39:20 +0100
Message-ID: <561.1556663960@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 30 Apr 2019 22:39:25 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi James,

Can you pull this set of patches into the security tree and pass them along
to Linus in the next merge window?  The primary thrust is to add
namespacing to keyrings.

One miscellaneous and four prerequisite patches start:

 (1) Use invalidation to kill off request_key authentication tokens more
     quickly than revoking them.

 (2) Remove request_key_async{,_with_auxdata} - I would need to add extra
     arguments, but they're not currently used.

 (3), (4) Simplify the key description management and cache the hash value
     to avoid the need for constant recalculation during a search.  This
     makes it easier to add namespace info to a key's index key.

 (5) Make it possible for keyring_search() to do searches that don't
     recurse down into and search keyrings linked to from the starting
     keyring.

Then the rest are about namespacing:

 (6) Replace the global list of keyring names with per-user_namespace lists
     and exclude certain internal keyrings from being added to the lists.

 (7) Move the user and user-session keyrings from the user_struct, and
     store them instead in a "user keyring register" in the user_namespace.
     This prevents KEY_SPEC_* specifiers from picking keyrings from the
     wrong namespace.  Note that it also means that uids that share a
     user_struct will not see the same user keyrings inside and outside a
     user_namespace.

     This has been tested by Dan Walsh in a Fedora environment, though the
     patch was modified from the one here.

 (8) Provide the ability to add a domain tag to a key's index key, so that
     a keyring can hold keys of the same type and description, but
     different target namespace/domain.

 (9) Make the garbage collector remove keys for which the target domain tag
     has been removed.

(10) Provide a domain tag for each network namespace.

(11) Tag DNS resolver keys and rxrpc/afs keys so that keys for different
     domains can coexist in the same keyrings.

In the future, hopefully, it will be possible to use the domain tags in
ACLs to grant permissions to namespaces for containerisation.

David
---
The following changes since commit 6beff00b79ca0b5caf0ce6fb8e11f57311bd95f8:

  seccomp: fix up grammar in comment (2019-04-23 16:21:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-namespace-20190430

for you to fetch changes up to ccedc142360bd68fdaf444671d67d42fa306398b:

  keys: Pass the network namespace into request_key mechanism (2019-04-25 13:10:25 +0100)

----------------------------------------------------------------
Keyrings namespacing

----------------------------------------------------------------
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

 Documentation/security/keys/core.rst     |  10 +-
 certs/blacklist.c                        |   2 +-
 crypto/asymmetric_keys/asymmetric_type.c |   2 +-
 fs/afs/addr_list.c                       |   4 +-
 fs/afs/dynroot.c                         |   7 +-
 fs/cifs/dns_resolve.c                    |   3 +-
 fs/nfs/dns_resolve.c                     |   2 +-
 include/linux/dns_resolver.h             |   3 +-
 include/linux/key-type.h                 |   3 +
 include/linux/key.h                      |  50 ++++--
 include/linux/sched/user.h               |  14 --
 include/linux/user_namespace.h           |  12 +-
 include/net/net_namespace.h              |   4 +
 kernel/user.c                            |  10 +-
 kernel/user_namespace.c                  |   9 +-
 lib/digsig.c                             |   2 +-
 net/ceph/messenger.c                     |   3 +-
 net/core/net_namespace.c                 |  19 +++
 net/dns_resolver/dns_key.c               |   1 +
 net/dns_resolver/dns_query.c             |   6 +-
 net/rxrpc/key.c                          |   6 +-
 net/rxrpc/security.c                     |   2 +-
 security/integrity/digsig_asymmetric.c   |   4 +-
 security/keys/gc.c                       |   2 +-
 security/keys/internal.h                 |  10 +-
 security/keys/key.c                      |   9 +-
 security/keys/keyctl.c                   |   4 +-
 security/keys/keyring.c                  | 263 +++++++++++++++++--------------
 security/keys/persistent.c               |  10 +-
 security/keys/proc.c                     |   3 +-
 security/keys/process_keys.c             | 252 ++++++++++++++++++-----------
 security/keys/request_key.c              | 113 ++++++-------
 security/keys/request_key_auth.c         |   3 +-
 33 files changed, 508 insertions(+), 339 deletions(-)
