Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 049A8FE835
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 23:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfKOWn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 17:43:57 -0500
Received: from correo.us.es ([193.147.175.20]:49870 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbfKOWn5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 17:43:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ADDA4FB459
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 23:43:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A01D3FB362
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 23:43:53 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9596DCF8A2; Fri, 15 Nov 2019 23:43:53 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF1B9DA3A9;
        Fri, 15 Nov 2019 23:43:51 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 15 Nov 2019 23:43:51 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7B755426CCBA;
        Fri, 15 Nov 2019 23:43:51 +0100 (CET)
Date:   Fri, 15 Nov 2019 23:43:53 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     y2038@lists.linaro.org, Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 5/8] netfilter: xt_time: use time64_t
Message-ID: <20191115224353.hpoyzvwvawu3fq3c@salvia>
References: <20191108203435.112759-1-arnd@arndb.de>
 <20191108203435.112759-6-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108203435.112759-6-arnd@arndb.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 09:34:28PM +0100, Arnd Bergmann wrote:
> The current xt_time driver suffers from the y2038 overflow on 32-bit
> architectures, when the time of day calculations break.
> 
> Also, on both 32-bit and 64-bit architectures, there is a problem with
> info->date_start/stop, which is part of the user ABI and overflows in
> in 2106.
> 
> Fix the first issue by using time64_t and explicit calls to div_u64()
> and div_u64_rem(), and document the seconds issue.
> 
> The explicit 64-bit division is unfortunately slower on 32-bit
> architectures, but doing it as unsigned lets us use the optimized
> division-through-multiplication path in most configurations.  This should
> be fine, as the code already does not allow any negative time of day
> values.
> 
> Using u32 seconds values consistently would probably also work and
> be a little more efficient, but that doesn't feel right as it would
> propagate the y2106 overflow to more place rather than fewer.

Applied, thanks.
