Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2487D1FC7A3
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 09:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgFQHjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 03:39:03 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56894 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726915AbgFQHjC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 03:39:02 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jlSej-00040u-CZ; Wed, 17 Jun 2020 17:38:46 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 17 Jun 2020 17:38:45 +1000
Date:   Wed, 17 Jun 2020 17:38:45 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: linux-next: build failures after merge of the vfs tree
Message-ID: <20200617073845.GA20077@gondor.apana.org.au>
References: <20200616103330.2df51a58@canb.auug.org.au>
 <20200616103440.35a80b4b@canb.auug.org.au>
 <20200616010502.GA28834@gondor.apana.org.au>
 <20200616033849.GL23230@ZenIV.linux.org.uk>
 <20200616143807.GA1359@gondor.apana.org.au>
 <20200617165715.577aa76d@canb.auug.org.au>
 <20200617070316.GA30348@gondor.apana.org.au>
 <20200617173102.2b91c32d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617173102.2b91c32d@canb.auug.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 05:31:02PM +1000, Stephen Rothwell wrote:
> > > 
> > > Presumably another include needed:
> > > 
> > > arch/s390/lib/test_unwind.c:49:2: error: implicit declaration of function 'kmalloc' [-Werror=implicit-function-declaration]
> > > arch/s390/lib/test_unwind.c:99:2: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]  
> 
> And more (these are coming from other's builds):
> 
>   drivers/remoteproc/qcom_q6v5_mss.c:772:3: error: implicit declaration of function 'kfree' [-Werror,-Wimplicit-function-declaration]
>   drivers/remoteproc/qcom_q6v5_mss.c:808:2: error: implicit declaration of function 'kfree' [-Werror,-Wimplicit-function-declaration]
>   drivers/remoteproc/qcom_q6v5_mss.c:1195:2: error: implicit declaration of function 'kfree' [-Werror,-Wimplicit-function-declaration]
> 
> They may have other causes as they are full linux-next builds (not just
> after the merge of the vfs tree), but the timing is suspicious.

OK, here's a patch for both of these together:

diff --git a/arch/s390/lib/test_unwind.c b/arch/s390/lib/test_unwind.c
index 32b7a30b2485..eb382ceaa116 100644
--- a/arch/s390/lib/test_unwind.c
+++ b/arch/s390/lib/test_unwind.c
@@ -9,6 +9,7 @@
 #include <linux/kallsyms.h>
 #include <linux/kthread.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/kprobes.h>
 #include <linux/wait.h>
diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index feb70283b6a2..903b2bb97e12 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -26,6 +26,7 @@
 #include <linux/reset.h>
 #include <linux/soc/qcom/mdt_loader.h>
 #include <linux/iopoll.h>
+#include <linux/slab.h>
 
 #include "remoteproc_internal.h"
 #include "qcom_common.h"
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
