Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3101101C1
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 17:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfLCQDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 11:03:54 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60985 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726105AbfLCQDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 11:03:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575389033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=L/S9YEoC00wo/Of2441RPzayHTUYnY3vnFh0QpGH2VA=;
        b=dtYCn58+LwA3LmDHU2X/Nmo3uMCS2e2LbJXoYhdkLUNn+8OFMD5qQYLIB2zWsN0e/ZIh7h
        lgP1JeOBzKVbvFqSU1GSysX6BdNR7C8m8liMl9qVtEC0/tHQ/XAjVSMfmXnlHu7M1qxctk
        uiyGE0dEA25RXlNtHioQDAsdQliz3Zg=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-U7pw4k-fPDq0aQiDh-aBIg-1; Tue, 03 Dec 2019 11:03:49 -0500
Received: by mail-qk1-f198.google.com with SMTP id q125so2520846qka.1
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 08:03:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ilQ0+r0UBu4+GolSe7bf072ArjOFjAUnGKdJuleehSk=;
        b=ehtbCNkTRt+pAwMYc9JT22MM0TLNMwu2XmlN+/hwl6Hct09SoMZiib7oKBrPohOFn+
         L3rk9ULUow/1qyFr4Uq4/RMWqHFCGxe/zXRWhbDueArKIhlYOFOJod1vfNzcMTEQTWH3
         SCh4tK5QptAspAAOvnDx3idnYjQNMyc7ad0nEB8g+D11sRaY4VD2TREVo9HqJ6dStLne
         BfRDVOC6UnjXVFr1uxhcN6SwFek8ab4cJ+3Do9cfzKMUa6eZeIxvBo7LN6yhhfwasFyb
         8HlDz6vhm+GOHxe/RfOruUVz+B6i5k5aeMZOSnMLqXPyL5G8KrlapEJPcdlGS/e5f8yy
         3Q1Q==
X-Gm-Message-State: APjAAAWGuWz6LhfE9zj1GCBtdMEG3V214hfmOCjq61wq4mRUv5nFxhF5
        vFqn6hQSw2e5TCuOeDrXhdZYlGh+ipTkreCWQlxblM8Q5Nxo2zNm0/cjtqK3KRJQbG1s1gIgDWi
        FVJAElM7MFR4bSa8V
X-Received: by 2002:ac8:461a:: with SMTP id p26mr5490202qtn.317.1575389028708;
        Tue, 03 Dec 2019 08:03:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqw4fOIwDRRPp6l7y0lv2pBkxHBG2W7El3I1jqcWKz1A9rg9pHTFG2qYGS/ZbAA+/l6HxaYdUQ==
X-Received: by 2002:ac8:461a:: with SMTP id p26mr5490164qtn.317.1575389028362;
        Tue, 03 Dec 2019 08:03:48 -0800 (PST)
Received: from labbott-redhat.redhat.com (pool-96-235-39-235.pitbpa.fios.verizon.net. [96.235.39.235])
        by smtp.gmail.com with ESMTPSA id i19sm1930260qki.124.2019.12.03.08.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 08:03:47 -0800 (PST)
From:   Laura Abbott <labbott@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Laura Abbott <labbott@redhat.com>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH] netfilter: nf_flow_table_offload: Correct memcpy size for flow_overload_mangle
Date:   Tue,  3 Dec 2019 11:03:45 -0500
Message-Id: <20191203160345.24743-1-labbott@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-MC-Unique: U7pw4k-fPDq0aQiDh-aBIg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sizes for memcpy in flow_offload_mangle don't match
the source variables, leading to overflow errors on some
build configurations:

In function 'memcpy',
    inlined from 'flow_offload_mangle' at net/netfilter/nf_flow_table_offlo=
ad.c:112:2,
    inlined from 'flow_offload_port_dnat' at net/netfilter/nf_flow_table_of=
fload.c:373:2,
    inlined from 'nf_flow_rule_route_ipv4' at net/netfilter/nf_flow_table_o=
ffload.c:424:3:
./include/linux/string.h:376:4: error: call to '__read_overflow2' declared =
with attribute error: detected read beyond size of object passed as 2nd par=
ameter
  376 |    __read_overflow2();
      |    ^~~~~~~~~~~~~~~~~~
make[2]: *** [scripts/Makefile.build:266: net/netfilter/nf_flow_table_offlo=
ad.o] Error 1

Fix this by using the corresponding type.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Laura Abbott <labbott@redhat.com>
---
Seen on a Fedora powerpc little endian build with -O3 but it looks like
it is correctly catching an error with doing a memcpy outside the source
variable.
---
 net/netfilter/nf_flow_table_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_=
table_offload.c
index c54c9a6cc981..526f894d0bdb 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -108,8 +108,8 @@ static void flow_offload_mangle(struct flow_action_entr=
y *entry,
 =09entry->id =3D FLOW_ACTION_MANGLE;
 =09entry->mangle.htype =3D htype;
 =09entry->mangle.offset =3D offset;
-=09memcpy(&entry->mangle.mask, mask, sizeof(u32));
-=09memcpy(&entry->mangle.val, value, sizeof(u32));
+=09memcpy(&entry->mangle.mask, mask, sizeof(u8));
+=09memcpy(&entry->mangle.val, value, sizeof(u8));
 }
=20
 static inline struct flow_action_entry *
--=20
2.21.0

