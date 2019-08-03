Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92D2F804F6
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 09:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfHCHJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 03:09:04 -0400
Received: from correo.us.es ([193.147.175.20]:59566 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727206AbfHCHJB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Aug 2019 03:09:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 183BEDC9B1
        for <netdev@vger.kernel.org>; Sat,  3 Aug 2019 09:08:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08128115111
        for <netdev@vger.kernel.org>; Sat,  3 Aug 2019 09:08:59 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EF389115105; Sat,  3 Aug 2019 09:08:58 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 02474DA704;
        Sat,  3 Aug 2019 09:08:57 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 03 Aug 2019 09:08:57 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.211.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A5C874265A31;
        Sat,  3 Aug 2019 09:08:56 +0200 (CEST)
Date:   Sat, 3 Aug 2019 09:08:54 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        jiri@resnulli.us, wenxu@ucloud.cn, saeedm@mellanox.com,
        paulb@mellanox.com, gerlitz.or@gmail.com
Subject: Re: [PATCH net 0/2] flow_offload hardware priority fixes
Message-ID: <20190803070854.zb3nvwj4ubx2mzy6@salvia>
References: <20190801112817.24976-1-pablo@netfilter.org>
 <20190801172014.314a9d01@cakuba.netronome.com>
 <20190802110023.udfcxowe3vmihduq@salvia>
 <20190802134738.328691b4@cakuba.netronome.com>
 <20190802220409.klwdkcvjgegz6hj2@salvia>
 <20190802152549.357784a7@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802152549.357784a7@cakuba.netronome.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Aug 02, 2019 at 03:25:49PM -0700, Jakub Kicinski wrote:
> On Sat, 3 Aug 2019 00:04:09 +0200, Pablo Neira Ayuso wrote:
> > That patch removed the reference to tcf_auto_prio() already, please
> > let me know if you have any more specific update you would like to see
> > on that patch.
> 
> Please explain why the artificial priorities are needed at all.
> Hardware should order tables based on table type - ethtool, TC, nft.
> As I mentioned in the first email, and unless you can make a strong 
> case against that.
> Within those tables we should follow the same ordering rules as we 
> do in software (modulo ethtool but ordering is pretty clear there).

The idea is that every subsystem (ethtool, tc, nf) sets up/binds its
own flow_block object. And each flow_block object has its own priority
range space. So whatever priority the user specifies only applies to
the specific subsystem. Drivers still need to be updated to support
for more than one flow_block/subsystem binding at this stage though.
