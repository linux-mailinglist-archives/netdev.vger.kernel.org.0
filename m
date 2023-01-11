Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B838666281
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbjAKSI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235523AbjAKSIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:08:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19AE1CB13
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673460439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=yxfvzi7ko8kdyYzY9LacDIBfrhli3maSflL+CABqguA=;
        b=OaUSaK6qVz8P+fon7zZMAk8eLjCCulITFVIyw5SSJJLe5Idqygh34gwISF4OFBM3MuUFut
        2Em1LHd/y5Y+aic3l4wYZFOmjqpYwlUUMP5dX9ubd27THYvDyjg2RYPNZxOJSKr8uAc42Y
        Wg/+U54XCoUp53P8bWH8pBocCI4eulk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-e480U5-6Pzagq-cn2QxsPw-1; Wed, 11 Jan 2023 13:07:17 -0500
X-MC-Unique: e480U5-6Pzagq-cn2QxsPw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 380FA1C0040B;
        Wed, 11 Jan 2023 18:07:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3BC3A4078904;
        Wed, 11 Jan 2023 18:07:16 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
cc:     dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
        Dan Carpenter <error27@gmail.com>,
        kernel test robot <lkp@intel.com>,
        syzbot+4bb6356bb29d6299360e@syzkaller.appspotmail.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] rxrpc: Fix wrong error return in rxrpc_connect_call()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2438404.1673460435.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 11 Jan 2023 18:07:15 +0000
Message-ID: <2438405.1673460435@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    =

Fix rxrpc_connect_call() to return -ENOMEM rather than 0 if it fails to
look up a peer.

This generated a smatch warning:
        net/rxrpc/call_object.c:303 rxrpc_connect_call() warn: missing err=
or code 'ret'

I think this also fixes a syzbot-found bug:

        rxrpc: Assertion failed - 1(0x1) =3D=3D 11(0xb) is false
        ------------[ cut here ]------------
        kernel BUG at net/rxrpc/call_object.c:645!

where the call being put is in the wrong state - as would be the case if w=
e
failed to clear up correctly after the error in rxrpc_connect_call().

Fixes: 9d35d880e0e4 ("rxrpc: Move client call connection to the I/O thread=
")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Reported-and-tested-by: syzbot+4bb6356bb29d6299360e@syzkaller.appspotmail.=
com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/202301111153.9eZRYLf1-lkp@intel.com/
---
 net/rxrpc/call_object.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 3ded5a24627c..f3c9f0201c15 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -294,7 +294,7 @@ static void rxrpc_put_call_slot(struct rxrpc_call *cal=
l)
 static int rxrpc_connect_call(struct rxrpc_call *call, gfp_t gfp)
 {
 	struct rxrpc_local *local =3D call->local;
-	int ret =3D 0;
+	int ret =3D -ENOMEM;
 =

 	_enter("{%d,%lx},", call->debug_id, call->user_call_ID);
 =

