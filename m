Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E9490657
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 19:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbfHPRAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 13:00:42 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:58380 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726097AbfHPRAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 13:00:42 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0C2B3A40086;
        Fri, 16 Aug 2019 17:00:40 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 16 Aug
 2019 10:00:37 -0700
Subject: Re: [PATCH net-next,v4 08/12] drivers: net: use flow block API
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
References: <20190709205550.3160-1-pablo@netfilter.org>
 <20190709205550.3160-9-pablo@netfilter.org>
 <75eec70e-60de-e33b-aea0-be595ca625f4@solarflare.com>
 <20190813195126.ilwtoljk2csco73m@salvia>
 <b3232864-3800-e2a4-9ee3-2cfcf222a148@solarflare.com>
 <20190816010421.if6mbyl2n3fsujy4@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <cb418901-2f09-3c0e-c87a-83d97f222179@solarflare.com>
Date:   Fri, 16 Aug 2019 18:00:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190816010421.if6mbyl2n3fsujy4@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24850.005
X-TM-AS-Result: No-17.631200-4.000000-10
X-TMASE-MatchedRID: vbSD0OnL8/IbF9xF7zzuNfZvT2zYoYOwC/ExpXrHizxQKAQSutQYXKUT
        uBQ/WRv/Rmq6mybPcBr/9pPsp96lqXiIda1vG1h51TY/cLrxiVC/CiKQLeaSpGmycYYiBYyZILq
        t4bmdQTtN7UiX+gj8LbII776sEiWuv6wwCZk9Fh3M0ihsfYPMYQeCHewokHM/UjFJwpdmcrQst6
        tMNaxmZmex7oMSouhbrsrGNSvpRG/gErZj0q1t0ksh+mzT1Unb+ZfOn+32vrCiaaypnafKT+zCD
        xuJUSyYq2qzz7SL4uIYGx31AH7WFezhkZcJwPyQwtE16arXsSIYgyDj5TiRtdDxDdXabYEQdDtz
        +zUSeR/GRm8c+FYCvOsya+QbLx9hJFTEHHYFNqmdONTJNTrm6VsP0tBwe3qDniNY8Fl2niPtGy4
        6TELGyOfOVcxjDhcwAYt5KiTiutkLbigRnpKlKSPzRlrdFGDw4fEP9CRM1HIM47kgokJV0Ep/wR
        2UqiAzSxbygo6SCJooIsuzl5ygNg==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--17.631200-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24850.005
X-MDID: 1565974841-ghlOeUhOYh2E
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/08/2019 02:04, Pablo Neira Ayuso wrote:
> On Wed, Aug 14, 2019 at 05:17:20PM +0100, Edward Cree wrote:
>> TBH I'm still not clear why you need a flow_block per subsystem, rather than
>>  just having multiple subsystems feed their offload requests through the same
>>  flow_block but with different enum tc_setup_type or enum tc_fl_command or
>>  some other indication that this is "netfilter" rather than "tc" asking for a
>>  tc_cls_flower_offload.
> In tc, the flow_block is set up by when the ingress qdisc is
> registered. The usual scenario for most drivers is to have one single
> flow_block per registered ingress qdisc, this makes a 1:1 mapping
> between ingress qdisc and flow_block.
>
> Still, you can register two or more ingress qdiscs to make them share
> the same policy via 'tc block'. In that case all those qdiscs use one
> single flow_block. This makes a N:1 mapping between these qdisc
> ingress and the flow_block. This policy applies to all ingress qdiscs
> that are part of the same tc block. By 'tc block', I'm refering to the
> tcf_block structure.
>
> In netfilter, there are ingress basechains that are registered per
> device. Each basechain gets a flow_block by when the basechain is
> registered. Shared blocks as in tcf_block are not yet supported, but
> it should not be hard to extend it to make this work.
>
> To reuse the same flow_block as entry point for all subsystems as your
> propose - assuming offloads for two or more subsystems are in place -
> then all of them would need to have the same block sharing
> configuration, which might not be the case, ie. tc ingress might have
> a eth0 and eth1 use the same policy via flow_block, while netfilter
> might have one basechain for eth0 and another for eth1 (no policy
> sharing).
Thank you, that's very helpful.

>> This really needs a design document explaining what all the bits are, how
>>  they fit together, and why they need to be like that.
> I did not design this flow_block abstraction, this concept was already
> in place under a different name and extend it so the ethtool/netfilter
> subsystems to avoid driver code duplication for offloads.
It's more the new implementation that you've created as part of this
 extension that I was asking about, although I agree that the
 abstraction that already existed is in need of documentation too.
