Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D7A2C15FF
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 21:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732147AbgKWUKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 15:10:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36803 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731841AbgKWUKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 15:10:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606162217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yF0ZgG5gfvBMinJ8fmkA3gGQJduwO3KEDhw25MZdbVA=;
        b=VHMnbxXGG+8/EiUu3JFTEpSHNKt7wUPtNJFn/LgoxzX/Ro+5JB1isEhes5nDf1ZfOM5c3j
        Ya8CzrrNhqToeSMlbhZkC0HsOFIJD8rVQJih8RtsaNV6ED23Mv+D8jFUxaL2Rw6twUO3T+
        fjDb+yESzqfkrMc3WWD/1fHXwciSbuk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-Conk2TlzPvSShJsSutIxHg-1; Mon, 23 Nov 2020 15:10:14 -0500
X-MC-Unique: Conk2TlzPvSShJsSutIxHg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6169964142;
        Mon, 23 Nov 2020 20:10:13 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-111.rdu2.redhat.com [10.10.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 955809CA0;
        Mon, 23 Nov 2020 20:10:11 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 01/17] keys: Provide the original description to the
 key preparser
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 23 Nov 2020 20:10:10 +0000
Message-ID: <160616221094.830164.17345499997649438443.stgit@warthog.procyon.org.uk>
In-Reply-To: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
References: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide the proposed description (add key) or the original description
(update/instantiate key) when preparsing a key so that the key type can
validate it against the data.

This is important for rxrpc server keys as we need to check that they have
the right amount of key material present - and it's better to do that when
the key is loaded rather than deep in trying to process a response packet.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
cc: keyrings@vger.kernel.org
---

 include/linux/key-type.h |    1 +
 security/keys/key.c      |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/key-type.h b/include/linux/key-type.h
index 2ab2d6d6aeab..7d985a1dfe4a 100644
--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -29,6 +29,7 @@ struct kernel_pkey_params;
  * clear the contents.
  */
 struct key_preparsed_payload {
+	const char	*orig_description; /* Actual or proposed description (maybe NULL) */
 	char		*description;	/* Proposed key description (or NULL) */
 	union key_payload payload;	/* Proposed payload */
 	const void	*data;		/* Raw data */
diff --git a/security/keys/key.c b/security/keys/key.c
index e282c6179b21..ebe752b137aa 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -504,6 +504,7 @@ int key_instantiate_and_link(struct key *key,
 	int ret;
 
 	memset(&prep, 0, sizeof(prep));
+	prep.orig_description = key->description;
 	prep.data = data;
 	prep.datalen = datalen;
 	prep.quotalen = key->type->def_datalen;
@@ -854,6 +855,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 		goto error_put_type;
 
 	memset(&prep, 0, sizeof(prep));
+	prep.orig_description = description;
 	prep.data = payload;
 	prep.datalen = plen;
 	prep.quotalen = index_key.type->def_datalen;


