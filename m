Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B600FD18C
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 00:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfKNX1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 18:27:09 -0500
Received: from correo.us.es ([193.147.175.20]:52978 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbfKNX1J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 18:27:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 341B2191912
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 00:27:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 283E2A8F1
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 00:27:05 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1A691CA0F3; Fri, 15 Nov 2019 00:27:05 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E16EDA4D0;
        Fri, 15 Nov 2019 00:27:03 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 15 Nov 2019 00:27:03 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id EC8B8426CCBA;
        Fri, 15 Nov 2019 00:27:02 +0100 (CET)
Date:   Fri, 15 Nov 2019 00:27:04 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     davem@davemloft.net, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] netfilter: nf_tables: Fix check the err for
 FLOW_BLOCK_BIND setup call
Message-ID: <20191114232704.475ucjd6hsk4mpqd@salvia>
References: <1573620402-10318-1-git-send-email-wenxu@ucloud.cn>
 <1573620402-10318-4-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="il5uwdqck2k2kdz4"
Content-Disposition: inline
In-Reply-To: <1573620402-10318-4-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--il5uwdqck2k2kdz4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This one is incomplete, right? I'm attaching an alternative patch.

On Wed, Nov 13, 2019 at 12:46:41PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  net/netfilter/nf_tables_api.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 2dc636f..0a00812 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -5995,8 +5995,12 @@ static int nft_register_flowtable_net_hooks(struct net *net,
>  			}
>  		}
>  
> -		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
> -					    FLOW_BLOCK_BIND);
> +		err = flowtable->data.type->setup(&flowtable->data,
> +						  hook->ops.dev,
> +						  FLOW_BLOCK_BIND);
> +		if (err < 0)
> +			goto err_unregister_net_hooks;
> +
>  		err = nf_register_net_hook(net, &hook->ops);
>  		if (err < 0)
>  			goto err_unregister_net_hooks;
> -- 
> 1.8.3.1
> 

--il5uwdqck2k2kdz4
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nf_tables-unbind-callbacks-if-flowtable-ho.patch"

From a6e05e56907673e21948c6ae53f45494b25fc0aa Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 15 Nov 2019 00:22:55 +0100
Subject: [PATCH] netfilter: nf_tables: unbind callbacks if flowtable hook
 registration fails

Undo the callback binding before unregistering the existing hooks.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Reported-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2dc636faa322..ad3882e14e82 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5998,8 +5998,12 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
 					    FLOW_BLOCK_BIND);
 		err = nf_register_net_hook(net, &hook->ops);
-		if (err < 0)
+		if (err < 0) {
+			flowtable->data.type->setup(&flowtable->data,
+						    hook->ops.dev,
+						    FLOW_BLOCK_UNBIND);
 			goto err_unregister_net_hooks;
+		}
 
 		i++;
 	}
-- 
2.11.0


--il5uwdqck2k2kdz4--
