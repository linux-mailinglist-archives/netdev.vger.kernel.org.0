Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD7F9032C
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfHPNgr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 16 Aug 2019 09:36:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56118 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbfHPNgq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 09:36:46 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 335931108;
        Fri, 16 Aug 2019 13:36:46 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5ED0BA4FAC;
        Fri, 16 Aug 2019 13:36:43 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <1562814435.4014.11.camel@linux.ibm.com>
References: <1562814435.4014.11.camel@linux.ibm.com> <28477.1562362239@warthog.procyon.org.uk> <CAHk-=wjxoeMJfeBahnWH=9zShKp2bsVy527vo3_y8HfOdhwAAw@mail.gmail.com> <20190710194620.GA83443@gmail.com> <20190710201552.GB83443@gmail.com> <CAHk-=wiFti6=K2fyAYhx-PSX9ovQPJUNp0FMdV0pDaO_pSx9MQ@mail.gmail.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     dhowells@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>, keyrings@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-nfs@vger.kernel.org,
        CIFS <linux-cifs@vger.kernel.org>, linux-afs@lists.infradead.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Keys: Set 4 - Key ACLs for 5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date:   Fri, 16 Aug 2019 14:36:42 +0100
Message-ID: <23498.1565962602@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 16 Aug 2019 13:36:46 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mimi Zohar <zohar@linux.ibm.com> wrote:

> Sorry for the delay.  An exception is needed for loading builtin keys
> "KEY_ALLOC_BUILT_IN" onto a keyring that is not writable by userspace.
>  The following works, but probably is not how David would handle the
> exception.

I think the attached is the right way to fix it.

load_system_certificate_list(), for example, when it creates keys does this:

	key = key_create_or_update(make_key_ref(builtin_trusted_keys, 1),

marking the keyring as "possessed" in make_key_ref().  This allows the
possessor permits to be used - and that's the *only* way to use them for
internal keyrings like this because you can't link to them and you can't join
them.

David
---
diff --git a/certs/system_keyring.c b/certs/system_keyring.c
index 57be78b5fdfc..1f8f26f7bb05 100644
--- a/certs/system_keyring.c
+++ b/certs/system_keyring.c
@@ -99,7 +99,7 @@ static __init int system_trusted_keyring_init(void)
 	builtin_trusted_keys =
 		keyring_alloc(".builtin_trusted_keys",
 			      KUIDT_INIT(0), KGIDT_INIT(0), current_cred(),
-			      &internal_key_acl, KEY_ALLOC_NOT_IN_QUOTA,
+			      &internal_keyring_acl, KEY_ALLOC_NOT_IN_QUOTA,
 			      NULL, NULL);
 	if (IS_ERR(builtin_trusted_keys))
 		panic("Can't allocate builtin trusted keyring\n");
diff --git a/security/keys/permission.c b/security/keys/permission.c
index fc84d9ef6239..86efd3eaf083 100644
--- a/security/keys/permission.c
+++ b/security/keys/permission.c
@@ -47,7 +47,7 @@ struct key_acl internal_keyring_acl = {
 	.usage	= REFCOUNT_INIT(1),
 	.nr_ace	= 2,
 	.aces = {
-		KEY_POSSESSOR_ACE(KEY_ACE_SEARCH),
+		KEY_POSSESSOR_ACE(KEY_ACE_SEARCH | KEY_ACE_WRITE),
 		KEY_OWNER_ACE(KEY_ACE_VIEW | KEY_ACE_READ | KEY_ACE_SEARCH),
 	}
 };
