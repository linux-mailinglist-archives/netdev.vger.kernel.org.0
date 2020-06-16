Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B879C1FA55E
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 03:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgFPBFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 21:05:24 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50594 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgFPBFY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 21:05:24 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jl02A-0005jD-Qw; Tue, 16 Jun 2020 11:05:03 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 16 Jun 2020 11:05:02 +1000
Date:   Tue, 16 Jun 2020 11:05:02 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: linux-next: build failures after merge of the vfs tree
Message-ID: <20200616010502.GA28834@gondor.apana.org.au>
References: <20200616103330.2df51a58@canb.auug.org.au>
 <20200616103440.35a80b4b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616103440.35a80b4b@canb.auug.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 10:34:40AM +1000, Stephen Rothwell wrote:
> [Just adding Herbert to cc]
> 
> On Tue, 16 Jun 2020 10:33:30 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Hi all,
> > 
> > After merging the vfs tree, today's linux-next build (x86_64 allmodconfig)
> > failed like this:

Thanks Stephen, here is an incremental patch to fix these up.

---8<---
Because linux/uio.h included crypto/hash.h a number of header
files that should have been included weren't.  This patch adds
linux/slab.h where kmalloc/kfree are used, as well as a forward
declaration in linux/socket.h for struct file.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 	f0187db056dc ("iov_iter: Move unnecessary inclusion of...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/dma/st_fdma.c b/drivers/dma/st_fdma.c
index 67087dbe2f9f..962b6e05287b 100644
--- a/drivers/dma/st_fdma.c
+++ b/drivers/dma/st_fdma.c
@@ -15,6 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/remoteproc.h>
+#include <linux/slab.h>
 
 #include "st_fdma.h"
 
diff --git a/drivers/dma/uniphier-xdmac.c b/drivers/dma/uniphier-xdmac.c
index 7b2f8a8c2d31..16b19654873d 100644
--- a/drivers/dma/uniphier-xdmac.c
+++ b/drivers/dma/uniphier-xdmac.c
@@ -12,6 +12,7 @@
 #include <linux/of.h>
 #include <linux/of_dma.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 
 #include "dmaengine.h"
 #include "virt-dma.h"
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 04d2bc97f497..e9cb30d8cbfb 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -10,6 +10,7 @@
 #include <linux/compiler.h>		/* __user			*/
 #include <uapi/linux/socket.h>
 
+struct file;
 struct pid;
 struct cred;
 struct socket;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
