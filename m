Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 594F6AB67B
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 12:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391698AbfIFK4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 06:56:45 -0400
Received: from correo.us.es ([193.147.175.20]:43732 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732554AbfIFK4o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 06:56:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7125D303D17
        for <netdev@vger.kernel.org>; Fri,  6 Sep 2019 12:56:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 63841A7E0F
        for <netdev@vger.kernel.org>; Fri,  6 Sep 2019 12:56:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5DEEBA7E28; Fri,  6 Sep 2019 12:56:39 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A52DA7E18;
        Fri,  6 Sep 2019 12:56:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Sep 2019 12:56:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D24BE41E4800;
        Fri,  6 Sep 2019 12:56:36 +0200 (CEST)
Date:   Fri, 6 Sep 2019 12:56:38 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        jiri@resnulli.us, saeedm@mellanox.com, vishal@chelsio.com,
        vladbu@mellanox.com
Subject: Re: [PATCH net-next,v3 0/4] flow_offload: update mangle action
 representation
Message-ID: <20190906105638.hylw6quhk7t3wff2@salvia>
References: <20190906000403.3701-1-pablo@netfilter.org>
 <679ced4b-8bcd-5479-2773-7c75452c2a32@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <679ced4b-8bcd-5479-2773-7c75452c2a32@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 11:02:18AM +0100, Edward Cree wrote:
> On 06/09/2019 01:03, Pablo Neira Ayuso wrote:
> > This patch updates the mangle action representation:
> >
> > Patch 1) Undo bitwise NOT operation on the mangle mask (coming from tc
> >          pedit userspace).
> >
> > Patch 2) mangle value &= mask from the front-end side.
> >
> > Patch 3) adjust offset, length and coalesce consecutive pedit keys into
> >          one single action.
> >
> > Patch 4) add support for payload mangling for netfilter.
> >
> > After this patchset:
> >
> > * Offset to payload does not need to be on the 32-bits boundaries anymore.
> >   This patchset adds front-end code to adjust the offset and length coming
> >   from the tc pedit representation, so drivers get an exact header field
> >   offset and length.
> >
> > * This new front-end code coalesces consecutive pedit actions into one
> >   single action, so drivers can mangle IPv6 and ethernet address fields
> >   in one go, instead once for each 32-bit word.
> >
> > On the driver side, diffstat -t shows that drivers code to deal with
> > payload mangling gets simplified:
> >
> >         INSERTED,DELETED,MODIFIED,FILENAME
> >         46,116,0,drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c (-70 LOC)
> >         12,28,0,drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h (-16 LOC)
> > 	26,54,0,drivers/net/ethernet/mellanox/mlx5/core/en_tc.c (-27 LOC)
> >         89,111,0,drivers/net/ethernet/netronome/nfp/flower/action.c (-17 LOC)
> >
> > While, on the front-end side the balance is the following:
> >
> >         123,22,0,net/sched/cls_api.c (+101 LOC)
> >
> > Changes since v2:
> >
> > * Fix is_action_keys_supported() breakage in mlx5 reported by Vlad Buslov.
>
> Still NAK for the same reasons as three versions ago (when it was called
>  "netfilter: payload mangling offload support"), you've never managed to
>  explain why this extra API complexity is useful.  (Reducing LOC does not
>  mean you've reduced complexity.)

Oh well...

Patch 1) Mask is inverted for no reason, just because tc pedit needs
this in this way. All drivers reverse this mask.

Patch 2) All drivers mask out meaningless fields in the value field.

Patch 3) Without this patchset, offsets are on the 32-bit boundary.
Drivers need to play with the 32-bit mask to infer what field they are
supposed to mangle... eg. with 32-bit offset alignment, checking if
the use want to alter the ttl/hop_limit need for helper structures to
check the 32-bit mask. Mangling a IPv6 address comes with one single
action...
