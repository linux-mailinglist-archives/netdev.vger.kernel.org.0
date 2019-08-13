Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB6CF8C1AC
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 21:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfHMTvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 15:51:31 -0400
Received: from correo.us.es ([193.147.175.20]:41384 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbfHMTvb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 15:51:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B873FB6333
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 21:51:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AAB24512D2
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 21:51:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A04FFDA7B9; Tue, 13 Aug 2019 21:51:28 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96263DA7B9;
        Tue, 13 Aug 2019 21:51:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 21:51:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 67E464265A2F;
        Tue, 13 Aug 2019 21:51:26 +0200 (CEST)
Date:   Tue, 13 Aug 2019 21:51:26 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next,v4 08/12] drivers: net: use flow block API
Message-ID: <20190813195126.ilwtoljk2csco73m@salvia>
References: <20190709205550.3160-1-pablo@netfilter.org>
 <20190709205550.3160-9-pablo@netfilter.org>
 <75eec70e-60de-e33b-aea0-be595ca625f4@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <75eec70e-60de-e33b-aea0-be595ca625f4@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 06:50:09PM +0100, Edward Cree wrote:
> On 09/07/2019 21:55, Pablo Neira Ayuso wrote:
> > This patch updates flow_block_cb_setup_simple() to use the flow block API.
> > Several drivers are also adjusted to use it.
> >
> > This patch introduces the per-driver list of flow blocks to account for
> > blocks that are already in use.
> >
> > Remove tc_block_offload alias.
> >
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v4: fix typo in list in nfp driver - Jakub Kicinski.
> >     Move driver_list handling to the driver code, this list is transitional,
> >     until drivers are updated to support multiple subsystems. No more
> >     driver_list handling from core.
> 
> Pablo, can you explain (because this commit message doesn't) why these per-
>  driver lists are needed, and what the information/state is that has module
>  (rather than, say, netdevice) scope?

The idea is to update drivers to support one flow_block per subsystem,
one for ethtool, one for tc, and so on. So far, existing drivers only
allow for binding one single flow_block to one of the existing
subsystems. So this limitation applies at driver level.
