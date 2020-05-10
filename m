Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766911CCE42
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 23:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbgEJVsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 17:48:33 -0400
Received: from correo.us.es ([193.147.175.20]:59080 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729240AbgEJVsd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 17:48:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B9328FB451
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 23:48:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AAD15115416
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 23:48:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9BFB9961FF; Sun, 10 May 2020 23:48:31 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8FC092040D;
        Sun, 10 May 2020 23:48:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 10 May 2020 23:48:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5D88842EF4E1;
        Sun, 10 May 2020 23:48:29 +0200 (CEST)
Date:   Sun, 10 May 2020 23:48:29 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        Li RongQing <lirongqing@baidu.com>,
        Joe Perches <joe@perches.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jules Irenge <jbi.octave@gmail.com>,
        Dirk Morris <dmorris@metaloft.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 06/15] netfilter: conntrack: avoid gcc-10
 zero-length-bounds warning
Message-ID: <20200510214829.GA9032@salvia>
References: <20200430213101.135134-1-arnd@arndb.de>
 <20200430213101.135134-7-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430213101.135134-7-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 11:30:48PM +0200, Arnd Bergmann wrote:
> gcc-10 warns around a suspicious access to an empty struct member:
> 
> net/netfilter/nf_conntrack_core.c: In function '__nf_conntrack_alloc':
> net/netfilter/nf_conntrack_core.c:1522:9: warning: array subscript 0 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[0]'} [-Wzero-length-bounds]
>  1522 |  memset(&ct->__nfct_init_offset[0], 0,
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from net/netfilter/nf_conntrack_core.c:37:
> include/net/netfilter/nf_conntrack.h:90:5: note: while referencing '__nfct_init_offset'
>    90 |  u8 __nfct_init_offset[0];
>       |     ^~~~~~~~~~~~~~~~~~
> 
> The code is correct but a bit unusual. Rework it slightly in a way that
> does not trigger the warning, using an empty struct instead of an empty
> array. There are probably more elegant ways to do this, but this is the
> smallest change.

Applied, thanks.
