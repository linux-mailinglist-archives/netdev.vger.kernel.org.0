Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A208962BB
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbfHTOpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:45:01 -0400
Received: from correo.us.es ([193.147.175.20]:33582 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729762AbfHTOpA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 10:45:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C58BAFB442
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 16:44:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7FC37E4C2
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 16:44:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AB967DA7B6; Tue, 20 Aug 2019 16:44:56 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1609D1DBB;
        Tue, 20 Aug 2019 16:44:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 20 Aug 2019 16:44:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.43.0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 678164265A2F;
        Tue, 20 Aug 2019 16:44:54 +0200 (CEST)
Date:   Tue, 20 Aug 2019 16:44:53 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        jiri@resnulli.us, vladbu@mellanox.com
Subject: Re: [PATCH net-next 1/2] net: flow_offload: mangle 128-bit packet
 field with one action
Message-ID: <20190820144453.ckme6oj2c4hmofhu@salvia>
References: <20190820105225.13943-1-pablo@netfilter.org>
 <f18d8369-f87d-5b9a-6c9d-daf48a3b95f1@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f18d8369-f87d-5b9a-6c9d-daf48a3b95f1@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 03:15:16PM +0100, Edward Cree wrote:
> On 20/08/2019 11:52, Pablo Neira Ayuso wrote:
> > The existing infrastructure needs the front-end to generate up to four
> > actions (one for each 32-bit word) to mangle an IPv6 address. This patch
> > allows you to mangle fields than are longer than 4-bytes with one single
> > action. Drivers have been adapted to this new representation following a
> > simple approach, that is, iterate over the array of words and configure
> > the hardware IR to make the packet mangling. FLOW_ACTION_MANGLE_MAX_WORDS
> > defines the maximum number of words from one given offset (currently 4
> > words).
> >
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>
> What's the point of this?
> Why do you need to be able to do this with a single action?  It doesn't
>  look like this extra 70 lines of code is actually buying you anything,
>  and it makes more work for any other drivers that want to implement the
>  offload API.

It looks to me this limitation is coming from tc pedit.

Four actions to mangle an IPv6 address consume more memory when making
the translation, and if you expect a lot of rules.

I think drivers can do more than one 32-bit word mangling in one go.
