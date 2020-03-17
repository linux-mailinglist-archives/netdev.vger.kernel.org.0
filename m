Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59C31188E24
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 20:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgCQTmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 15:42:44 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:51716 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726682AbgCQTmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 15:42:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584474162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=1fFQOEoei54nx8OzjJR+NcuP/thiJUDry70cCne9lJ0=;
        b=DuT4cgBaZ4idPEoRtqF62j5aIjXyuJpyQQ8atuBQkC1KrTKZKdHwQNGHwv4NOhvpwzLAhu
        K23P6aqEiDFfkOQcQ8IL8PqfmPUaD+QDuO+0uSQcHiMsvy/w0FtO3XGxxS+fqk0i+2rYyT
        Y1V5BRaZ6GD8KZCAa2j6Ibu17QDSYUs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-x4VM4dJDOzCifI5d55Tjjg-1; Tue, 17 Mar 2020 15:42:38 -0400
X-MC-Unique: x4VM4dJDOzCifI5d55Tjjg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A4F6107ACCA;
        Tue, 17 Mar 2020 19:42:36 +0000 (UTC)
Received: from llong.com (ovpn-115-15.rdu2.redhat.com [10.10.115.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70EDD10002AB;
        Tue, 17 Mar 2020 19:42:26 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, Sumit Garg <sumit.garg@linaro.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Eric Biggers <ebiggers@google.com>,
        Chris von Recklinghausen <crecklin@redhat.com>,
        Waiman Long <longman@redhat.com>
Subject: [PATCH v4 0/4] KEYS: Read keys to internal buffer & then copy to userspace
Date:   Tue, 17 Mar 2020 15:41:36 -0400
Message-Id: <20200317194140.6031-1-longman@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v4:
 - Remove the __user annotation from big_key_read() and user_read() in
   patch 1.
 - Add a new patch 2 to remove __user annotation from rxrpc_read().
 - Add a new patch 3 to remove __user annotation from dns_resolver_read().
 - Merge the original patches 2 and 3 into a single patch 4 and refactor
   it as suggested by Jarkko and Eric.

v3:
 - Reorganize the keyctl_read_key() code to make it more readable as
   suggested by Jarkko Sakkinen.
 - Add patch 3 to use kvmalloc() for safer large buffer allocation as
   suggested by David Howells.

v2:
 - Handle NULL buffer and buflen properly in patch 1.
 - Fix a bug in big_key.c.
 - Add patch 2 to handle arbitrary large user-supplied buflen.

The current security key read methods are called with the key semaphore
held.  The methods then copy out the key data to userspace which is
subjected to page fault and may acquire the mmap semaphore. That can
result in circular lock dependency and hence a chance to get into
deadlock.

To avoid such a deadlock, an internal buffer is now allocated for getting
out the necessary data first. After releasing the key semaphore, the
key data are then copied out to userspace sidestepping the circular
lock dependency.

The keyutils test suite was run and the test passed with these patchset
applied without any falure.

Waiman Long (4):
  KEYS: Don't write out to userspace while holding key semaphore
  KEYS: Remove __user annotation from rxrpc_read()
  KEYS: Remove __user annotation from dns_resolver_read()
  KEYS: Avoid false positive ENOMEM error on key read

 include/keys/big_key-type.h               |  2 +-
 include/keys/user-type.h                  |  3 +-
 include/linux/key-type.h                  |  2 +-
 net/dns_resolver/dns_key.c                |  2 +-
 net/rxrpc/key.c                           | 27 +++----
 security/keys/big_key.c                   | 11 ++-
 security/keys/encrypted-keys/encrypted.c  |  7 +-
 security/keys/internal.h                  | 12 ++++
 security/keys/keyctl.c                    | 86 ++++++++++++++++++++---
 security/keys/keyring.c                   |  6 +-
 security/keys/request_key_auth.c          |  7 +-
 security/keys/trusted-keys/trusted_tpm1.c | 14 +---
 security/keys/user_defined.c              |  5 +-
 13 files changed, 116 insertions(+), 68 deletions(-)

-- 
2.18.1

