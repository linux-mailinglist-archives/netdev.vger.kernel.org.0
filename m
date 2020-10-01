Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019EF2801C0
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732516AbgJAO5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:57:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732299AbgJAO5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:57:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yF0ZgG5gfvBMinJ8fmkA3gGQJduwO3KEDhw25MZdbVA=;
        b=ZK8nuNbEmxfSBK8cFkf4iDvSpXhr0bDnp+JWfjrC/8YBMsfL1A2V68m7CylOItG7V/P9LE
        7hT++cyiLG0YLyCgFxUgAln7n+PbPLoo06C4WfgBuWUnRm/M+bOhODUWjXG7UAz43oZpJf
        O2Hzjb122kIjBpduhS9oCMl09LKPP1c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342--y0ri1pkPlq_QWFRtz66Ow-1; Thu, 01 Oct 2020 10:56:53 -0400
X-MC-Unique: -y0ri1pkPlq_QWFRtz66Ow-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 532E41084C9D;
        Thu,  1 Oct 2020 14:56:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85AB460BFA;
        Thu,  1 Oct 2020 14:56:51 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 01/23] keys: Provide the original description to the
 key preparser
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:56:50 +0100
Message-ID: <160156421072.1728886.10480028356326248675.stgit@warthog.procyon.org.uk>
In-Reply-To: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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


