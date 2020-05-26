Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991191E31D9
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390997AbgEZV77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:59:59 -0400
Received: from correo.us.es ([193.147.175.20]:59810 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390918AbgEZV76 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 17:59:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1011D1C4383
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 23:59:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3203DA714
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 23:59:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E8149DA70E; Tue, 26 May 2020 23:59:55 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 040BADA701;
        Tue, 26 May 2020 23:59:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 26 May 2020 23:59:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CFE3942EF42A;
        Tue, 26 May 2020 23:59:53 +0200 (CEST)
Date:   Tue, 26 May 2020 23:59:53 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Cc:     netfilter-devel@vger.kernel.org,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        paulb@mellanox.com, Oz Shlomo <ozsh@mellanox.com>,
        vladbu@mellanox.com, jiri@resnulli.us, kuba@kernel.org,
        saeedm@mellanox.com, Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH 7/8 net] bnxt_tc: update indirect block support
Message-ID: <20200526215953.GA3089@salvia>
References: <20200513164140.7956-1-pablo@netfilter.org>
 <20200513164140.7956-8-pablo@netfilter.org>
 <CAHHeUGUZmM1Fvk2gbund1AhMEV=zeg_JbuPR9DQ1ovELH=iRKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHHeUGUZmM1Fvk2gbund1AhMEV=zeg_JbuPR9DQ1ovELH=iRKQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I overlook this email, sorry.

On Tue, May 19, 2020 at 02:23:54PM +0530, Sriharsha Basavapatna wrote:
[...]
> > @@ -2101,7 +2073,8 @@ void bnxt_shutdown_tc(struct bnxt *bp)
> >         if (!bnxt_tc_flower_enabled(bp))
> >                 return;
> >
> > -       unregister_netdevice_notifier(&bp->tc_netdev_nb);
> > +       flow_indr_dev_unregister(bnxt_tc_setup_indr_cb, bp,
> > +                                bnxt_tc_setup_indr_block_cb);
> 
> Why does the driver need to provide the "cb" again during unregister,
> since both "cb" and "cb_priv" are already provided during register() ?
> This interface could be simplified/improved if
> flow_indr_dev_register() returns an opaque handle to the object it
> creates (struct flow_indr_dev *) ?

Probably, at the expense to storing this in the netdev private area.

> The driver should just pass this
> handle during unregistration. Also, why do we need the extra (3rd)
> argument (flow_setup_cb_t / bnxt_tc_setup_indr_block_cb) during unreg
> ? It is handled internally by the driver as a part of FLOW_BLOCK_BIND
> / UNBIND ?

flow_indr_dev_unregister() needs bnxt_tc_setup_indr_block_cb to
identify what indirect flow_blocks need to be cleaned up before this
representor is gone.
