Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F23181182D
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 13:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfEBLb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 07:31:57 -0400
Received: from mail.us.es ([193.147.175.20]:54770 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbfEBLb5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 07:31:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DDD579D3DC
        for <netdev@vger.kernel.org>; Thu,  2 May 2019 13:31:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C8834DA720
        for <netdev@vger.kernel.org>; Thu,  2 May 2019 13:31:53 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BDCB7DA710; Thu,  2 May 2019 13:31:53 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 914FCDA701;
        Thu,  2 May 2019 13:31:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 02 May 2019 13:31:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6DB6640705C0;
        Thu,  2 May 2019 13:31:51 +0200 (CEST)
Date:   Thu, 2 May 2019 13:31:51 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH 07/31] netfilter: ctnetlink: Support L3 protocol-filter
 on flush
Message-ID: <20190502113151.xcnutl2eedjkftsb@salvia>
References: <20181008230125.2330-1-pablo@netfilter.org>
 <20181008230125.2330-8-pablo@netfilter.org>
 <33d60747-7550-1fba-a068-9b78aaedbc26@6wind.com>
 <CAKfDRXjY9J1yHz1px6-gbmrEYJi9P9+16Mez+qzqhYLr9MtCQg@mail.gmail.com>
 <51b7d27b-a67e-e3c6-c574-01f50a860a5c@6wind.com>
 <20190502074642.ph64t7uax73xuxeo@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502074642.ph64t7uax73xuxeo@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 02, 2019 at 09:46:42AM +0200, Florian Westphal wrote:
> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> > I understand your point, but this is a regression. Ignoring a field/attribute of
> > a netlink message is part of the uAPI. This field exists for more than a decade
> > (probably two), so you cannot just use it because nobody was using it. Just see
> > all discussions about strict validation of netlink messages.
> > Moreover, the conntrack tool exists also for ages and is an official tool.
> 
> FWIW I agree with Nicolas, we should restore old behaviour and flush
> everything when AF_INET is given.  We can add new netlink attr to
> restrict this.

Let's use nfgenmsg->version for this. This is so far set to zero. We
can just update userspace to set it to 1, so family is used.

The version field in the kernel size is ignored so far, so this should
be enough. So we avoid that extract netlink attribute.
