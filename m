Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82F49968A4
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 20:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730119AbfHTSfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 14:35:40 -0400
Received: from correo.us.es ([193.147.175.20]:42396 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729639AbfHTSfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 14:35:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A3986DA72B
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 20:35:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94805CE17F
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 20:35:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 83751DA72F; Tue, 20 Aug 2019 20:35:36 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7DB6FDA8E8;
        Tue, 20 Aug 2019 20:35:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 20 Aug 2019 20:35:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.43.0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 40B0D4265A2F;
        Tue, 20 Aug 2019 20:35:34 +0200 (CEST)
Date:   Tue, 20 Aug 2019 20:35:33 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        jiri@resnulli.us, vladbu@mellanox.com
Subject: Re: [PATCH net-next 1/2] net: flow_offload: mangle 128-bit packet
 field with one action
Message-ID: <20190820183533.ykh7mnurpmegxb27@salvia>
References: <20190820105225.13943-1-pablo@netfilter.org>
 <f18d8369-f87d-5b9a-6c9d-daf48a3b95f1@solarflare.com>
 <20190820144453.ckme6oj2c4hmofhu@salvia>
 <c8a00a98-74eb-9f8d-660f-c2ea159dec91@solarflare.com>
 <20190820173344.3nrzfjboyztz3lji@salvia>
 <f4cf8a97-3322-d982-6068-d4c0ce997b1c@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f4cf8a97-3322-d982-6068-d4c0ce997b1c@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 07:15:10PM +0100, Edward Cree wrote:
> On 20/08/2019 18:33, Pablo Neira Ayuso wrote:
> > I can update tc pedit to generate one single action for offset
> > consecutive packet editions, if that is the concern, I'll send a v2.
> IMHO the fix belongs in TC userland (i.e. iproute2), to turn a
> single action on the commandline for an ipv6 addr into four pedit
> actions before the kernel ever sees it.
> Similarly if nftables wants to use this it should generate four
> separate pedit actions, probably in the kernel netfilter code as (I
> assume) your uAPI talks in terms of named fields rather than the
> u32ish offsets and masks of tc pedit.

The driver flow_offload API does not necessarily need to map 1:1 to
the netlink control plane / UAPI. The driver flow_offload API is
detached from UAPI and it is internal to drivers.

> The TC (well, flow_offload now I suppose) API should be kept narrow,
> not widened for things that can already be expressed adequately. 
> Your array of words inside a pedit action looks like a kind of loop
> unrolling but for data structures, which doesn't look sensible to
> me.

With one action that says "mangle an IPv6 at offset ip6 daddr field"
the driver has more global view on what is going on, rather than
having four actions to mangle four 32-bit words at some offset.

If this patch adds some loops here is because I did not want to make
too smart changes on the drivers.

The only reason I can find why mangling is restricted to 32-bits word
is tc pedit. The existing flow_offload API was modeled after tc
actions, which was exposing tc pedit implementation details to
hardware.

Please, allow for incremental updates on the flow_offload API to get
it better now. Later we'll have way more drivers it will become harder
to update this.
