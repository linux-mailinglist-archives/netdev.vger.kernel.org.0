Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BAF333545
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhCJFac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:30:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:60058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhCJFaX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 00:30:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E497A64FE7;
        Wed, 10 Mar 2021 05:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615354223;
        bh=Pec2Jjuy09XmF1pS9nRX8d5lHT7/lujDosVgXX5TB/0=;
        h=Date:From:To:Cc:Subject:From;
        b=FZMK6LhKETniSwjjrxFgdevLH7Qe1g6eOfhG/As6hLyoJw7vXZxrao5KZUNBmc+bu
         rlf6U/r/b07fkIio82Rn3NweGBsbFQCgOM8lOy1ZzAmC5jmZTx8geezOAfe+887a6h
         CwHz9GybsADJw32OYcitSmvB5bKQMDNVV2mlFHH/WUuYAriIT2BYlWaG3VQuHv9R7P
         duWQPdHpVUQGW5X8zCMatb1lFE6LJY8mt5005059cPewbM1rTJG74W5IwQG9guFN92
         dzT2Ig2mLFkRjPdOv7R+LnpB+2jhTCFDSjOXN3zI4IOGsmd5DW4z0+j6+SH8+ZHn/G
         s54l7rxMi2isg==
Date:   Tue, 9 Mar 2021 23:30:20 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] net: fddi: skfp: smt: Replace one-element array
 with flexible-array member
Message-ID: <20210310053020.GA285050@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Refactor the code according to the use of flexible-array members in
smt_sif_operation structure, instead of one-element arrays. Also, make
use of the struct_size() helper instead of the open-coded version
to calculate the size of the struct-with-flex-array. Additionally, make
use of the typeof operator to properly determine the object type to be
passed to macro smtod().

Also, this helps the ongoing efforts to enable -Warray-bounds by fixing
the following warnings:

  CC [M]  drivers/net/fddi/skfp/smt.o
drivers/net/fddi/skfp/smt.c: In function ‘smt_send_sif_operation’:
drivers/net/fddi/skfp/smt.c:1084:30: warning: array subscript 1 is above array bounds of ‘struct smt_p_lem[1]’ [-Warray-bounds]
 1084 |    smt_fill_lem(smc,&sif->lem[i],i) ;
      |                      ~~~~~~~~^~~
In file included from drivers/net/fddi/skfp/h/smc.h:42,
                 from drivers/net/fddi/skfp/smt.c:15:
drivers/net/fddi/skfp/h/smt.h:767:19: note: while referencing ‘lem’
  767 |  struct smt_p_lem lem[1] ; /* phy lem status */
      |                   ^~~
drivers/net/fddi/skfp/smt.c:1084:30: warning: array subscript 1 is above array bounds of ‘struct smt_p_lem[1]’ [-Warray-bounds]
 1084 |    smt_fill_lem(smc,&sif->lem[i],i) ;
      |                      ~~~~~~~~^~~
In file included from drivers/net/fddi/skfp/h/smc.h:42,
                 from drivers/net/fddi/skfp/smt.c:15:
drivers/net/fddi/skfp/h/smt.h:767:19: note: while referencing ‘lem’
  767 |  struct smt_p_lem lem[1] ; /* phy lem status */
      |                   ^~~
drivers/net/fddi/skfp/smt.c:1084:30: warning: array subscript 1 is above array bounds of ‘struct smt_p_lem[1]’ [-Warray-bounds]
 1084 |    smt_fill_lem(smc,&sif->lem[i],i) ;
      |                      ~~~~~~~~^~~
In file included from drivers/net/fddi/skfp/h/smc.h:42,
                 from drivers/net/fddi/skfp/smt.c:15:
drivers/net/fddi/skfp/h/smt.h:767:19: note: while referencing ‘lem’
  767 |  struct smt_p_lem lem[1] ; /* phy lem status */
      |                   ^~~
drivers/net/fddi/skfp/smt.c:1084:30: warning: array subscript 1 is above array bounds of ‘struct smt_p_lem[1]’ [-Warray-bounds]
 1084 |    smt_fill_lem(smc,&sif->lem[i],i) ;
      |                      ~~~~~~~~^~~
In file included from drivers/net/fddi/skfp/h/smc.h:42,
                 from drivers/net/fddi/skfp/smt.c:15:
drivers/net/fddi/skfp/h/smt.h:767:19: note: while referencing ‘lem’
  767 |  struct smt_p_lem lem[1] ; /* phy lem status */
      |                   ^~~
drivers/net/fddi/skfp/smt.c:1084:30: warning: array subscript 1 is above array bounds of ‘struct smt_p_lem[1]’ [-Warray-bounds]
 1084 |    smt_fill_lem(smc,&sif->lem[i],i) ;
      |                      ~~~~~~~~^~~
In file included from drivers/net/fddi/skfp/h/smc.h:42,
                 from drivers/net/fddi/skfp/smt.c:15:
drivers/net/fddi/skfp/h/smt.h:767:19: note: while referencing ‘lem’
  767 |  struct smt_p_lem lem[1] ; /* phy lem status */
      |                   ^~~
drivers/net/fddi/skfp/smt.c:1084:30: warning: array subscript 1 is above array bounds of ‘struct smt_p_lem[1]’ [-Warray-bounds]
 1084 |    smt_fill_lem(smc,&sif->lem[i],i) ;
      |                      ~~~~~~~~^~~
In file included from drivers/net/fddi/skfp/h/smc.h:42,
                 from drivers/net/fddi/skfp/smt.c:15:
drivers/net/fddi/skfp/h/smt.h:767:19: note: while referencing ‘lem’
  767 |  struct smt_p_lem lem[1] ; /* phy lem status */
      |                   ^~~
drivers/net/fddi/skfp/smt.c:1084:30: warning: array subscript 1 is above array bounds of ‘struct smt_p_lem[1]’ [-Warray-bounds]
 1084 |    smt_fill_lem(smc,&sif->lem[i],i) ;
      |                      ~~~~~~~~^~~
In file included from drivers/net/fddi/skfp/h/smc.h:42,
                 from drivers/net/fddi/skfp/smt.c:15:
drivers/net/fddi/skfp/h/smt.h:767:19: note: while referencing ‘lem’
  767 |  struct smt_p_lem lem[1] ; /* phy lem status */
      |                   ^~~
drivers/net/fddi/skfp/smt.c:1084:30: warning: array subscript 1 is above array bounds of ‘struct smt_p_lem[1]’ [-Warray-bounds]
 1084 |    smt_fill_lem(smc,&sif->lem[i],i) ;
      |                      ~~~~~~~~^~~
In file included from drivers/net/fddi/skfp/h/smc.h:42,
                 from drivers/net/fddi/skfp/smt.c:15:
drivers/net/fddi/skfp/h/smt.h:767:19: note: while referencing ‘lem’
  767 |  struct smt_p_lem lem[1] ; /* phy lem status */
      |                   ^~~
drivers/net/fddi/skfp/smt.c:1084:30: warning: array subscript 1 is above array bounds of ‘struct smt_p_lem[1]’ [-Warray-bounds]
 1084 |    smt_fill_lem(smc,&sif->lem[i],i) ;
      |                      ~~~~~~~~^~~
In file included from drivers/net/fddi/skfp/h/smc.h:42,
                 from drivers/net/fddi/skfp/smt.c:15:
drivers/net/fddi/skfp/h/smt.h:767:19: note: while referencing ‘lem’
  767 |  struct smt_p_lem lem[1] ; /* phy lem status */
      |                   ^~~
drivers/net/fddi/skfp/smt.c:1084:30: warning: array subscript 1 is above array bounds of ‘struct smt_p_lem[1]’ [-Warray-bounds]
 1084 |    smt_fill_lem(smc,&sif->lem[i],i) ;
      |                      ~~~~~~~~^~~
In file included from drivers/net/fddi/skfp/h/smc.h:42,
                 from drivers/net/fddi/skfp/smt.c:15:
drivers/net/fddi/skfp/h/smt.h:767:19: note: while referencing ‘lem’
  767 |  struct smt_p_lem lem[1] ; /* phy lem status */

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 Changes in RESEND:
 - None. Resending now that net-next is open.

 drivers/net/fddi/skfp/h/smt.h | 4 +---
 drivers/net/fddi/skfp/smt.c   | 4 ++--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/fddi/skfp/h/smt.h b/drivers/net/fddi/skfp/h/smt.h
index a0dbc0f57a55..751b5bb87a9d 100644
--- a/drivers/net/fddi/skfp/h/smt.h
+++ b/drivers/net/fddi/skfp/h/smt.h
@@ -764,10 +764,8 @@ struct smt_sif_operation {
 	struct smt_p_setcount	setcount ;	 /* Set Count mandatory */
 #endif
 	/* must be last */
-	struct smt_p_lem	lem[1] ;	/* phy lem status */
+	struct smt_p_lem	lem[];		/* phy lem status */
 } ;
-#define SIZEOF_SMT_SIF_OPERATION	(sizeof(struct smt_sif_operation)- \
-					 sizeof(struct smt_p_lem))
 
 /*
  * ECF : echo frame
diff --git a/drivers/net/fddi/skfp/smt.c b/drivers/net/fddi/skfp/smt.c
index 774a6e3b0a67..6b68a53f1b38 100644
--- a/drivers/net/fddi/skfp/smt.c
+++ b/drivers/net/fddi/skfp/smt.c
@@ -1063,9 +1063,9 @@ static void smt_send_sif_operation(struct s_smc *smc, struct fddi_addr *dest,
 #endif
 
 	if (!(mb = smt_build_frame(smc,SMT_SIF_OPER,SMT_REPLY,
-		SIZEOF_SMT_SIF_OPERATION+ports*sizeof(struct smt_p_lem))))
+				   struct_size(sif, lem, ports))))
 		return ;
-	sif = smtod(mb, struct smt_sif_operation *) ;
+	sif = smtod(mb, typeof(sif));
 	smt_fill_timestamp(smc,&sif->ts) ;	/* set time stamp */
 	smt_fill_mac_status(smc,&sif->status) ; /* set mac status */
 	smt_fill_mac_counter(smc,&sif->mc) ; /* set mac counter field */
-- 
2.27.0

