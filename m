Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9594E1B8238
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 00:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgDXWvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 18:51:11 -0400
Received: from bert.scottdial.com ([104.237.142.221]:50476 "EHLO
        bert.scottdial.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgDXWvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 18:51:10 -0400
Received: from mail.scottdial.com (mail.scottdial.com [10.8.0.6])
        by bert.scottdial.com (Postfix) with ESMTP id A254D57189B
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 18:51:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.scottdial.com (Postfix) with ESMTP id 494E21111605
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 18:51:09 -0400 (EDT)
Received: from mail.scottdial.com ([127.0.0.1])
        by localhost (mail.scottdial.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id o8qjQmzvU-Sg for <netdev@vger.kernel.org>;
        Fri, 24 Apr 2020 18:51:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.scottdial.com (Postfix) with ESMTP id 486161111606
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 18:51:08 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.scottdial.com 486161111606
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scottdial.com;
        s=24B7B964-7506-11E8-A7D6-CF6FBF8C6FCF; t=1587768668;
        bh=cOkjeDgSn0IZpvq4yuZyE8b2PyETBgwgfX9nMn6TvSo=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=fEUKyTUhPqhWqYnExofTshpk4TV9mFIkbEb13qk0VbvMrubaGa9kH7oMQEBYenF6o
         e6SIdKqGVfOlIu78GC9vWbAS8MhL67dEYdzRZATMl7zOkIXt8qHJmfh5ZV+pNUvdHI
         yfOcibbvxIB7h4Rl18Kw1xEZGL8uuJ5Ls1toOrJPvVbas9O+DLlZtI3j+MGQq4yKj1
         SEIM1jE8041VbdR45dV0O8NWuglSGnSkYxusrqWMYyxGgRyYPs5jdM79ASyosM/Mon
         1dFRM3/ptRQtsQbTx8CmdaRk5lGUZrKyYU/FOR/FkZ/UT/JsJ5B/rHTEvd4uTTIj/J
         fIMCzk6+sjArA==
X-Virus-Scanned: amavisd-new at scottdial.com
Received: from mail.scottdial.com ([127.0.0.1])
        by localhost (mail.scottdial.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id s7GFFyUN2ZXs for <netdev@vger.kernel.org>;
        Fri, 24 Apr 2020 18:51:08 -0400 (EDT)
Received: from bruno.home.scottdial.com.home.scottdial.com (bruno.scottdial.com [172.17.1.8])
        by mail.scottdial.com (Postfix) with ESMTP id 242C11111605
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 18:51:08 -0400 (EDT)
From:   Scott Dial <scott@scottdial.com>
To:     netdev@vger.kernel.org
Subject: [PATCH net] net: macsec: preserve ingress frame ordering
Date:   Fri, 24 Apr 2020 18:51:08 -0400
Message-Id: <20200424225108.956252-1-scott@scottdial.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MACsec decryption always occurs in a softirq context. Since
the FPU may not be usable in the softirq context, the call to
decrypt may be scheduled on the cryptd work queue. The cryptd
work queue does not provide ordering guarantees. Therefore,
preserving order requires masking out ASYNC implementations
of gcm(aes).

For instance, an Intel CPU with AES-NI makes available the
generic-gcm-aesni driver from the aesni_intel module to
implement gcm(aes). However, this implementation requires
the FPU, so it is not always available to use from a softirq
context, and will fallback to the cryptd work queue, which
does not preserve frame ordering. With this change, such a
system would select gcm_base(ctr(aes-aesni),ghash-generic).
While the aes-aesni implementation prefers to use the FPU, it
will fallback to the aes-asm implementation if unavailable.

By using a synchronous version of gcm(aes), the decryption
will complete before returning from crypto_aead_decrypt().
Therefore, the macsec_decrypt_done() callback will be called
before returning from macsec_decrypt(). Thus, the order of
calls to macsec_post_decrypt() for the frames is preserved.

While it's presumable that the pure AES-NI version of gcm(aes)
is more performant, the hybrid solution is capable of gigabit
speeds on modest hardware. Regardless, preserving the order
of frames is paramount for many network protocols (e.g.,
triggering TCP retries). Within the MACsec driver itself, the
replay protection is tripped by the out-of-order frames, and
can cause frames to be dropped.

This bug has been present in this code since it was added in
v4.6, however it may not have been noticed since not all CPUs
have FPU offload available. Additionally, the bug manifests
as occasional out-of-order packets that are easily
misattributed to other network phenomena.

When this code was added in v4.6, the crypto/gcm.c code did
not restrict selection of the ghash function based on the
ASYNC flag. For instance, x86 CPUs with PCLMULQDQ would
select the ghash-clmulni driver instead of ghash-generic,
which submits to the cryptd work queue if the FPU is busy.
However, this bug was was corrected in v4.8 by commit
b30bdfa86431afbafe15284a3ad5ac19b49b88e3, and was backported
all the way back to the v3.14 stable branch, so this patch
should be applicable back to the v4.6 stable branch.

Signed-off-by: Scott Dial <scott@scottdial.com>
---
 drivers/net/macsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index a183250ff66a..bce8b8fde400 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1305,7 +1305,8 @@ static struct crypto_aead *macsec_alloc_tfm(char *k=
ey, int key_len, int icv_len)
 	struct crypto_aead *tfm;
 	int ret;
=20
-	tfm =3D crypto_alloc_aead("gcm(aes)", 0, 0);
+	/* Pick a sync gcm(aes) cipher to ensure order is preserved. */
+	tfm =3D crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);
=20
 	if (IS_ERR(tfm))
 		return tfm;
--=20
2.26.2

