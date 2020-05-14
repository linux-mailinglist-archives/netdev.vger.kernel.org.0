Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029EF1D4130
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbgENWgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 18:36:32 -0400
Received: from correo.us.es ([193.147.175.20]:38418 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728682AbgENWgc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 18:36:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4C76C127C85
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 00:36:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3FABFDA710
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 00:36:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 34782DA707; Fri, 15 May 2020 00:36:30 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DDBE9DA701;
        Fri, 15 May 2020 00:36:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 15 May 2020 00:36:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B89E241E4800;
        Fri, 15 May 2020 00:36:27 +0200 (CEST)
Date:   Fri, 15 May 2020 00:36:27 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, paulb@mellanox.com, ozsh@mellanox.com,
        vladbu@mellanox.com, jiri@resnulli.us, kuba@kernel.org,
        saeedm@mellanox.com, michael.chan@broadcom.com
Subject: Re: [PATCH 0/8 net] the indirect flow_block offload, revisited
Message-ID: <20200514223627.GA3170@salvia>
References: <20200513164140.7956-1-pablo@netfilter.org>
 <8f1a3b9a-6a60-f1b3-0fc1-f2361864c822@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8f1a3b9a-6a60-f1b3-0fc1-f2361864c822@solarflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 12:44:48PM +0100, Edward Cree wrote:
> On 13/05/2020 17:41, Pablo Neira Ayuso wrote:
> > Hi,
> >
> > This patchset fixes the indirect flow_block support for the tc CT action
> > offload. Please, note that this batch is probably slightly large for the
> > net tree, however, I could not find a simple incremental fix.
> >
> > = The problem
> >
> > The nf_flow_table_indr_block_cb() function provides the tunnel netdevice
> > and the indirect flow_block driver callback. From this tunnel netdevice,
> > it is not possible to obtain the tc CT flow_block. Note that tc qdisc
> > and netfilter backtrack from the tunnel netdevice to the tc block /
> > netfilter chain to reach the flow_block object. This allows them to
> > clean up the hardware offload rules if the tunnel device is removed.
> >
> > <snip>
> >
> > = About this patchset
> >
> > This patchset aims to address the existing TC CT problem while
> > simplifying the indirect flow_block infrastructure. Saving 300 LoC in
> > the flow_offload core and the drivers.
>
> This might be a dumb question, but: what is the actual bug being fixed,
>  that makes this patch series needed on net rather than net-next?

The TC CT action crashes the kernel with an indirect flow_block in place:

https://lore.kernel.org/netfilter-devel/db9dfe4f-62e7-241b-46a0-d878c89696a8@ucloud.cn/
