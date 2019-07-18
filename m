Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1EA6D44F
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 21:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbfGRTBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 15:01:16 -0400
Received: from mail.us.es ([193.147.175.20]:45604 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391011AbfGRTBP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 15:01:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C1C9D1022B0
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 21:01:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B2DE711510C
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 21:01:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A2513115103; Thu, 18 Jul 2019 21:01:13 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 802B2D2F98;
        Thu, 18 Jul 2019 21:01:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 18 Jul 2019 21:01:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4BCCE4265A31;
        Thu, 18 Jul 2019 21:01:11 +0200 (CEST)
Date:   Thu, 18 Jul 2019 21:01:10 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>, wenxu <wenxu@ucloud.cn>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net-next] netfilter: bridge: make NF_TABLES_BRIDGE
 tristate
Message-ID: <20190718190110.akn54iwb2mui72cd@salvia>
References: <20190710080835.296696-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710080835.296696-1-arnd@arndb.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 10:08:20AM +0200, Arnd Bergmann wrote:
> The new nft_meta_bridge code fails to link as built-in when NF_TABLES
> is a loadable module.
> 
> net/bridge/netfilter/nft_meta_bridge.o: In function `nft_meta_bridge_get_eval':
> nft_meta_bridge.c:(.text+0x1e8): undefined reference to `nft_meta_get_eval'
> net/bridge/netfilter/nft_meta_bridge.o: In function `nft_meta_bridge_get_init':
> nft_meta_bridge.c:(.text+0x468): undefined reference to `nft_meta_get_init'
> nft_meta_bridge.c:(.text+0x49c): undefined reference to `nft_parse_register'
> nft_meta_bridge.c:(.text+0x4cc): undefined reference to `nft_validate_register_store'
> net/bridge/netfilter/nft_meta_bridge.o: In function `nft_meta_bridge_module_exit':
> nft_meta_bridge.c:(.exit.text+0x14): undefined reference to `nft_unregister_expr'
> net/bridge/netfilter/nft_meta_bridge.o: In function `nft_meta_bridge_module_init':
> nft_meta_bridge.c:(.init.text+0x14): undefined reference to `nft_register_expr'
> net/bridge/netfilter/nft_meta_bridge.o:(.rodata+0x60): undefined reference to `nft_meta_get_dump'
> net/bridge/netfilter/nft_meta_bridge.o:(.rodata+0x88): undefined reference to `nft_meta_set_eval'
> 
> This can happen because the NF_TABLES_BRIDGE dependency itself is just a
> 'bool'.  Make the symbol a 'tristate' instead so Kconfig can propagate the
> dependencies correctly.

Hm. Something breaks here. Investigating. Looks like bridge support is
gone after this, nft fails to register the filter chain type:

# nft add table bridge x
# nft add chain bridge x y { type filter hook input priority 0\; }
Error: Could not process rule: No such file or directory
