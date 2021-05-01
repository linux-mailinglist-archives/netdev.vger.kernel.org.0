Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E843C3707E9
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 18:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhEAQis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 12:38:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22644 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230195AbhEAQis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 12:38:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619887077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tAaAngf+gDad2nQ9tOb2/jsMhQgqXV0Q/WN1X+tGXvs=;
        b=SXEj7CXz0CiMSnx76zZAq+/5Px7nPrsbYA6NKI3xncdIscq0tBpixYt8pHvuAAU93FxJgw
        EtFHREVARGx8BAKFAuWoyqeB9xOKkvQGqkifkKnidkK5HgGWBdYZLZ5GOmya5MAgds5q6X
        9lGINlbqNdZpPRjzy52vlqhdzBWx1CM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500--syRrDQXOKaFpv2pZx8Pqg-1; Sat, 01 May 2021 12:37:56 -0400
X-MC-Unique: -syRrDQXOKaFpv2pZx8Pqg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 429CF189829D;
        Sat,  1 May 2021 16:37:55 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-28.ams2.redhat.com [10.36.112.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71B6350C0B;
        Sat,  1 May 2021 16:37:54 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 2/2] tipc: bail out if key is abnormally long
Date:   Sat,  1 May 2021 18:32:30 +0200
Message-Id: <9df1a85dd34faf5377ee67598c76d39db32c699e.1619886329.git.aclaudi@redhat.com>
In-Reply-To: <cover.1619886329.git.aclaudi@redhat.com>
References: <cover.1619886329.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tipc segfaults when called with an abnormally long key:

$ tipc node set key 0123456789abcdef0123456789abcdef0123456789abcdef
*** buffer overflow detected ***: terminated

Fix this returning an error if key length is longer than
TIPC_AEAD_KEYLEN_MAX.

Fixes: 24bee3bf9752 ("tipc: add new commands to set TIPC AEAD key")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 tipc/misc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tipc/misc.c b/tipc/misc.c
index 1daf3072..909975d8 100644
--- a/tipc/misc.c
+++ b/tipc/misc.c
@@ -113,6 +113,9 @@ int str2key(char *str, struct tipc_aead_key *key)
 	    }
 	}
 
+	if (len > TIPC_AEAD_KEYLEN_MAX)
+		return -1;
+
 	/* Obtain key: */
 	if (!ishex) {
 		key->keylen = len;
-- 
2.30.2

