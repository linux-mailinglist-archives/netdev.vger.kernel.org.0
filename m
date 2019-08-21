Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6FFE97252
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 08:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfHUGhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 02:37:08 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:43188 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727841AbfHUGhI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 02:37:08 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9F41020571;
        Wed, 21 Aug 2019 08:37:06 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4021cwcMpGel; Wed, 21 Aug 2019 08:37:05 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5029A200AC;
        Wed, 21 Aug 2019 08:37:05 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 21 Aug 2019
 08:37:05 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id E4FFE31827CE;
 Wed, 21 Aug 2019 08:37:04 +0200 (CEST)
Date:   Wed, 21 Aug 2019 08:37:04 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        syzbot <syzbot+6a9ff159672dfbb41c95@syzkaller.appspotmail.com>,
        <ast@kernel.org>, <aviadye@mellanox.com>, <borisp@mellanox.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davejwatson@fb.com>, <davem@davemloft.net>, <hdanton@sina.com>,
        <john.fastabend@gmail.com>, <netdev@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>, <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>
Subject: Re: INFO: task hung in tls_sw_release_resources_tx
Message-ID: <20190821063704.GM2879@gauss3.secunet.de>
References: <000000000000523ea3059025b11d@google.com>
 <000000000000e75f1805902bb919@google.com>
 <20190816190234.2aaab5b6@cakuba.netronome.com>
 <20190817054743.GE8209@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190817054743.GE8209@sol.localdomain>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 16, 2019 at 10:47:43PM -0700, Eric Biggers wrote:
> [+Steffen, who is the maintainer of pcrypt]
> 
> On Fri, Aug 16, 2019 at 07:02:34PM -0700, Jakub Kicinski wrote:
> > On Thu, 15 Aug 2019 11:06:00 -0700, syzbot wrote:
> > > syzbot has bisected this bug to:
> > > 
> > > commit 130b392c6cd6b2aed1b7eb32253d4920babb4891
> > > Author: Dave Watson <davejwatson@fb.com>
> > > Date:   Wed Jan 30 21:58:31 2019 +0000
> > > 
> > >      net: tls: Add tls 1.3 support
> > > 
> > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=118e8dee600000
> > > start commit:   6d5afe20 sctp: fix memleak in sctp_send_reset_streams
> > > git tree:       net
> > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=138e8dee600000
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=158e8dee600000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=a4c9e9f08e9e8960
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=6a9ff159672dfbb41c95
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17cb0502600000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14d5dc22600000
> > > 
> > > Reported-by: syzbot+6a9ff159672dfbb41c95@syzkaller.appspotmail.com
> > > Fixes: 130b392c6cd6 ("net: tls: Add tls 1.3 support")
> > > 
> > > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> > 
> > CC Herbert, linux-crypto
> > 
> > This is got to be something in the crypto code :S 
> > 
> > The test case opens a ktls socket and back log writes to it.
> > Then it opens a AF_ALG socket, binds "pcrypt(gcm(aes))" and dies.
> > 
> > The ktls socket upon close waits for async crypto callbacks, but they
> > never come. If I unset CRYPTO_USER_API_AEAD or change the alg to bind
> > to "gcm(aes)" the bug does not trigger.
> > 
> > Any suggestions?
> 
> Seeing as pcrypt is involved and this is a "task hung" bug, this is probably
> caused by the recursive pcrypt deadlock, which is yet to be fixed.
> 
> See the original thread for more info:
> 
> 	https://groups.google.com/forum/#!msg/syzkaller-bugs/1_CXUd3gBcg/BvsRLH0lAgAJ
> 
> And the syzbot dashboard link:
> 
> 	https://syzkaller.appspot.com/bug?id=178f2528d10720d563091fb51dceb4cb20f75525
> 
> Let's tell syzbot this is a duplicate:
> 
> #syz dup: INFO: task hung in aead_recvmsg
> 
> 
> Steffen, do you have any plan to fix this?

I've tried to use different padata instances for each pcrypt template,
but then each pcrypt template needs to expose its cpumask configuration
to a new file in /sys/kernel/pcrypt/. Currently we have one file
there for the encrytion and on for the decryption cpumask. If we have
more than these two files, we need some naming convention to now which
pcrypt template we want to configure. That would be a bit odd because
a such a nested pcrypt in pcrypt algorithm would not make sense at all.

I still think we should somehow forbid these nested configurations.
If I remember correct, the only objection to your original patch
was that it would still deadlock if an underlying algorithm uses
pcrypt as a fallback.

Maybe we can use your patch and also refuse instanitating if an
underlying algorithm needs a fallback.

The patch would look like this then:

Subject: [PATCH] crypto: pcrypt - forbid recursive instantiation

If the pcrypt template is used multiple times in an algorithm, then a
deadlock occurs because all pcrypt instances share the same
padata_instance, which completes requests in the order submitted.  That
is, the inner pcrypt request waits for the outer pcrypt request while
the outer request is already waiting for the inner.

Fix this by making pcrypt forbid instantiation if pcrypt appears in the
underlying ->cra_driver_name and if an underlying algorithm needs a
fallback.  This is somewhat of a hack, but it's a simple fix that should
be sufficient to prevent the deadlock.

Reproducer:

	#include <linux/if_alg.h>
	#include <sys/socket.h>
	#include <unistd.h>

	int main()
	{
		struct sockaddr_alg addr = {
			.salg_type = "aead",
			.salg_name = "pcrypt(pcrypt(rfc4106-gcm-aesni))"
		};
		int algfd, reqfd;
		char buf[32] = { 0 };

		algfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
		bind(algfd, (void *)&addr, sizeof(addr));
		setsockopt(algfd, SOL_ALG, ALG_SET_KEY, buf, 20);
		reqfd = accept(algfd, 0, 0);
		write(reqfd, buf, 32);
		read(reqfd, buf, 16);
	}

Reported-by: syzbot+56c7151cad94eec37c521f0e47d2eee53f9361c4@syzkaller.appspotmail.com
Fixes: 5068c7a883d1 ("crypto: pcrypt - Add pcrypt crypto parallelization wrapper")
Cc: <stable@vger.kernel.org> # v2.6.34+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/pcrypt.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 543792e0ebf0..932a77b61b47 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -198,6 +198,12 @@ static void pcrypt_free(struct aead_instance *inst)
 static int pcrypt_init_instance(struct crypto_instance *inst,
 				struct crypto_alg *alg)
 {
+	/* Recursive pcrypt deadlocks due to the shared padata_instance */
+	if (!strncmp(alg->cra_driver_name, "pcrypt(", 7) ||
+	    strstr(alg->cra_driver_name, "(pcrypt(") ||
+	    strstr(alg->cra_driver_name, ",pcrypt("))
+		return -EINVAL;
+
 	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "pcrypt(%s)", alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		return -ENAMETOOLONG;
@@ -236,7 +242,7 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
 	ctx = aead_instance_ctx(inst);
 	crypto_set_aead_spawn(&ctx->spawn, aead_crypto_instance(inst));
 
-	err = crypto_grab_aead(&ctx->spawn, name, 0, 0);
+	err = crypto_grab_aead(&ctx->spawn, name, 0, CRYPTO_ALG_NEED_FALLBACK);
 	if (err)
 		goto out_free_inst;
 
-- 
2.17.1

