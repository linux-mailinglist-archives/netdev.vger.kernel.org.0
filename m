Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA9BF280D6
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 17:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730961AbfEWPR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 11:17:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730756AbfEWPR5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 11:17:57 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7AFBB63162;
        Thu, 23 May 2019 15:17:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-121-142.rdu2.redhat.com [10.10.121.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9CDA1001E82;
        Thu, 23 May 2019 15:17:48 +0000 (UTC)
Subject: [PATCH 0/9] keys: Namespacing [ver #3]
From:   David Howells <dhowells@redhat.com>
To:     ebiederm@xmission.com
Cc:     linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        Jann Horn <jannh@google.com>, dhowells@redhat.com,
        dwalsh@redhat.com, vgoyal@redhat.com, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 23 May 2019 16:17:47 +0100
Message-ID: <155862466770.15244.16038372267332150004.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 23 May 2019 15:17:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are some patches to make keys and keyrings more namespace aware.  Note
that the branch is dependent on security/next-general.

Firstly some miscellaneous patches to make the process easier:

 (1) Simplify key index_key handling so that the word-sized chunks
     assoc_array requires don't have to be shifted about, making it easier
     to add more bits into the key.

 (2) Cache the hash value in the key so that we don't have to calculate on
     every key we examine during a search (it involves a bunch of
     multiplications).

 (3) Allow keying_search() to search non-recursively.

Then the main patches:

 (4) Make it so that keyring names are per-user_namespace from the point of
     view of KEYCTL_JOIN_SESSION_KEYRING so that they're not accessible
     cross-user_namespace.

 (5) Move the user and user-session keyrings to the user_namespace rather
     than the user_struct.  This prevents them propagating directly across
     user_namespaces boundaries (ie. the KEY_SPEC_* flags will only pick
     from the current user_namespace).

 (6) Make it possible to include the target namespace in which the key shall
     operate in the index_key.  This will allow the possibility of multiple
     keys with the same description, but different target domains to be held
     in the same keyring.

 (7) Make it so that keys are implicitly invalidated by removal of a domain
     tag, causing them to be garbage collected.

 (8) Institute a network namespace domain tag that allows keys to be
     differentiated by the network namespace in which they operate.  New keys
     that are of a type marked 'KEY_TYPE_NET_DOMAIN' are assigned the network
     domain in force when they are created.

 (9) Make it so that the desired network namespace can be handed down into the
     request_key() mechanism.  This allows AFS, NFS, etc. to request keys
     specific to the network namespace of the superblock.

     This also means that the keys in the DNS record cache are thenceforth
     namespaced, provided network filesystems pass the appropriate network
     namespace down into dns_query().

     For DNS, AFS and NFS are good; CIFS and Ceph are not.  Other cache
     keyrings, such as idmapper keyrings, also need to set the domain tag -
     for which they need access to the network namespace of the superblock.

The patches can be found on the following branch:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-namespace

David
---
David Howells (9):
      keys: Simplify key description management
      keys: Cache the hash value to avoid lots of recalculation
      keys: Add a 'recurse' flag for keyring searches
      keys: Namespace keyring names
      keys: Move the user and user-session keyrings to the user_namespace
      keys: Include target namespace in match criteria
      keys: Garbage collect keys for which the domain has been removed
      keys: Network namespace domain tag
      keys: Pass the network namespace into request_key mechanism


 Documentation/security/keys/core.rst        |   38 +++-
 Documentation/security/keys/request-key.rst |   29 ++-
 certs/blacklist.c                           |    2 
 crypto/asymmetric_keys/asymmetric_type.c    |    2 
 fs/afs/addr_list.c                          |    4 
 fs/afs/dynroot.c                            |    8 +
 fs/cifs/dns_resolve.c                       |    3 
 fs/nfs/dns_resolve.c                        |    3 
 fs/nfs/nfs4idmap.c                          |    2 
 include/linux/dns_resolver.h                |    3 
 include/linux/key-type.h                    |    3 
 include/linux/key.h                         |   81 ++++++++
 include/linux/sched/user.h                  |   14 -
 include/linux/user_namespace.h              |   12 +
 include/net/net_namespace.h                 |    3 
 kernel/user.c                               |    8 -
 kernel/user_namespace.c                     |    9 -
 lib/digsig.c                                |    2 
 net/ceph/messenger.c                        |    3 
 net/core/net_namespace.c                    |   19 ++
 net/dns_resolver/dns_key.c                  |    1 
 net/dns_resolver/dns_query.c                |    7 +
 net/rxrpc/key.c                             |    6 -
 net/rxrpc/security.c                        |    2 
 security/integrity/digsig_asymmetric.c      |    4 
 security/keys/gc.c                          |    2 
 security/keys/internal.h                    |   10 +
 security/keys/key.c                         |    5 -
 security/keys/keyctl.c                      |    4 
 security/keys/keyring.c                     |  263 +++++++++++++++------------
 security/keys/persistent.c                  |   10 +
 security/keys/proc.c                        |    3 
 security/keys/process_keys.c                |  262 +++++++++++++++++----------
 security/keys/request_key.c                 |   62 ++++--
 security/keys/request_key_auth.c            |    3 
 35 files changed, 583 insertions(+), 309 deletions(-)

