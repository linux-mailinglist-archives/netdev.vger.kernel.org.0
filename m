Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F7511BF91
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfLKWE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:04:27 -0500
Received: from correo.us.es ([193.147.175.20]:35110 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbfLKWE0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 17:04:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DE84C505554
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 23:04:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D184EDA70C
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 23:04:23 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C6A7EDA715; Wed, 11 Dec 2019 23:04:23 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45B99DA703;
        Wed, 11 Dec 2019 23:04:21 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Dec 2019 23:04:21 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1405042EE38F;
        Wed, 11 Dec 2019 23:04:21 +0100 (CET)
Date:   Wed, 11 Dec 2019 23:04:21 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>, wenxu <wenxu@ucloud.cn>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_flow_table: fix big-endian integer overflow
Message-ID: <20191211220421.jrirqeyogry4pnlw@salvia>
References: <20191210202443.2226043-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210202443.2226043-1-arnd@arndb.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On Tue, Dec 10, 2019 at 09:24:28PM +0100, Arnd Bergmann wrote:
> In some configurations, gcc reports an integer overflow:
> 
> net/netfilter/nf_flow_table_offload.c: In function 'nf_flow_rule_match':
> net/netfilter/nf_flow_table_offload.c:80:21: error: unsigned conversion from 'int' to '__be16' {aka 'short unsigned int'} changes value from '327680' to '0' [-Werror=overflow]
>    mask->tcp.flags = TCP_FLAG_RST | TCP_FLAG_FIN;
>                      ^~~~~~~~~~~~
> 
> From what I can tell, we want the upper 16 bits of these constants,
> so they need to be shifted in cpu-endian mode.
> 
> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I'm not sure if this is the correct fix, please check carefully

Thanks. I posted this one:

https://patchwork.ozlabs.org/patch/1206384/

The flow dissector matching on tcp flags seems also broken on big-endian.
