Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A159013DCA1
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbgAPNyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:54:46 -0500
Received: from correo.us.es ([193.147.175.20]:58932 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728982AbgAPNyK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 08:54:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 43DB5DA70F
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 14:54:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 344D7DA729
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 14:54:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2917CDA711; Thu, 16 Jan 2020 14:54:09 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 310ECDA714;
        Thu, 16 Jan 2020 14:54:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 14:54:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 14AD642EF9E0;
        Thu, 16 Jan 2020 14:54:07 +0100 (CET)
Date:   Thu, 16 Jan 2020 14:54:06 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org,
        syzbot+37a6804945a3a13b1572@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: fix flowtable list del
 corruption
Message-ID: <20200116135406.v66tcoxfk6z2xqkc@salvia>
References: <000000000000b3599c059c36db0d@google.com>
 <20200116110301.4875-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116110301.4875-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 12:03:01PM +0100, Florian Westphal wrote:
> syzbot reported following crash:
> 
>   list_del corruption, ffff88808c9bb000->prev is LIST_POISON2 (dead000000000122)
>   [..]
>   Call Trace:
>    __list_del_entry include/linux/list.h:131 [inline]
>    list_del_rcu include/linux/rculist.h:148 [inline]
>    nf_tables_commit+0x1068/0x3b30 net/netfilter/nf_tables_api.c:7183
>    [..]
> 
> The commit transaction list has:
> 
> NFT_MSG_NEWTABLE
> NFT_MSG_NEWFLOWTABLE
> NFT_MSG_DELFLOWTABLE
> NFT_MSG_DELTABLE
> 
> A missing generation check during DELTABLE processing causes it to queue
> the DELFLOWTABLE operation a second time, so we corrupt the list here:
> 
>   case NFT_MSG_DELFLOWTABLE:
>      list_del_rcu(&nft_trans_flowtable(trans)->list);
>      nf_tables_flowtable_notify(&trans->ctx,
> 
> because we have two different DELFLOWTABLE transactions for the same
> flowtable.  We then call list_del_rcu() twice for the same flowtable->list.
> 
> The object handling seems to suffer from the same bug so add a generation
> check too and only queue delete transactions for flowtables/objects that
> are still active in the next generation.

Applied, thanks.
