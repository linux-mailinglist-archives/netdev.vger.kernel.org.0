Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1CBFAC8A6
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 20:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389562AbfIGSIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 14:08:01 -0400
Received: from correo.us.es ([193.147.175.20]:40074 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731471AbfIGSIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Sep 2019 14:08:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2B41C11EB27
        for <netdev@vger.kernel.org>; Sat,  7 Sep 2019 20:07:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D6CFFF6E0
        for <netdev@vger.kernel.org>; Sat,  7 Sep 2019 20:07:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0A4D7FF2C8; Sat,  7 Sep 2019 20:07:55 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C82DAB8004;
        Sat,  7 Sep 2019 20:07:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 07 Sep 2019 20:07:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 99FD04265A5A;
        Sat,  7 Sep 2019 20:07:52 +0200 (CEST)
Date:   Sat, 7 Sep 2019 20:07:54 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        wenxu <wenxu@ucloud.cn>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: nf_tables: avoid excessive stack
 usage
Message-ID: <20190907180754.dz7gstqfj7djlbrs@salvia>
References: <20190906151242.1115282-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lclypf5uqwm62nbj"
Content-Disposition: inline
In-Reply-To: <20190906151242.1115282-1-arnd@arndb.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lclypf5uqwm62nbj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Arnd,

On Fri, Sep 06, 2019 at 05:12:30PM +0200, Arnd Bergmann wrote:
> The nft_offload_ctx structure is much too large to put on the
> stack:
> 
> net/netfilter/nf_tables_offload.c:31:23: error: stack frame size of 1200 bytes in function 'nft_flow_rule_create' [-Werror,-Wframe-larger-than=]
> 
> Use dynamic allocation here, as we do elsewhere in the same
> function.
>
> Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Since we only really care about two members of the structure, an
> alternative would be a larger rewrite, but that is probably too
> late for v5.4.

Thanks for this patch.

I'm attaching a patch to reduce this structure size a bit. Do you
think this alternative patch is ok until this alternative rewrite
happens? Anyway I agree we should to get this structure away from the
stack, even after this is still large, so your patch (or a variant of
it) will be useful sooner than later I think.

--lclypf5uqwm62nbj
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index db104665a9e4..cc44d29e9fd7 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -5,10 +5,10 @@
 #include <net/netfilter/nf_tables.h>
 
 struct nft_offload_reg {
-	u32		key;
-	u32		len;
-	u32		base_offset;
-	u32		offset;
+	u8		key;
+	u8		len;
+	u8		base_offset;
+	u8		offset;
 	struct nft_data data;
 	struct nft_data	mask;
 };

--lclypf5uqwm62nbj--
