Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED46AB95F
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 15:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405166AbfIFNhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 09:37:24 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:37442 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405160AbfIFNhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 09:37:24 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D1D1CB4005E;
        Fri,  6 Sep 2019 13:37:22 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 6 Sep
 2019 06:37:18 -0700
Subject: Re: [PATCH net-next,v3 0/4] flow_offload: update mangle action
 representation
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <jakub.kicinski@netronome.com>,
        <jiri@resnulli.us>, <saeedm@mellanox.com>, <vishal@chelsio.com>,
        <vladbu@mellanox.com>
References: <20190906000403.3701-1-pablo@netfilter.org>
 <679ced4b-8bcd-5479-2773-7c75452c2a32@solarflare.com>
 <20190906105638.hylw6quhk7t3wff2@salvia>
 <b8baf681-b808-4b83-d521-0353c3136516@solarflare.com>
 <20190906131457.7olkal45kkdtbevo@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <35ac21be-ff2f-a9cd-dd71-28bc37e8a51b@solarflare.com>
Date:   Fri, 6 Sep 2019 14:37:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190906131457.7olkal45kkdtbevo@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24892.005
X-TM-AS-Result: No-9.832800-4.000000-10
X-TMASE-MatchedRID: xcONGPdDH5oeimh1YYHcKB4ejJMDGBzF69aS+7/zbj+qvcIF1TcLYHQ7
        c/s1EnkfFjGWt2FXzm3YnvwuHYT0lueiDxJcK5MJi+quUbDYb+T2hUAowGKip63IiVD2OFIx6Za
        mopeZkvkka5MiZO1ulOdnr/in5DtFNKnO1vGWufXB7F9jxUX48iILdc+InEErVtYy28d/67qzmx
        F0dSgcd1kiL23zZNAA/KK6RVJ+KH17aKUoA0jAYf3HILfxLV/9GIMg4+U4kbWMUViaYYbK3L6Ue
        43fcLaGoFkD5GsQcO9OLZzWJ5+LBnILYce0M8j652cbj4/WmPv5l86f7fa+sKeTxVWlTUU2hoBN
        KnOJHc0/fW9ucJQpkmb8g1GpLkmum4dTYLUN4vdQv6U9dFo+qedppbZRNp/IUCgEErrUGFwsqIY
        Tiq6PrfjPC0ss9aZmjSl+i7OQ/1OR9GF2J2xqM4MbH85DUZXy3QfwsVk0UbuGrPnef/I+epJB7T
        T1BEfaj5Z39QXxMPBEBrR18Bo/jrXPphqL1vb8SUt3T068WM8=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.832800-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24892.005
X-MDID: 1567777043-CGUJjFT4lT3Z
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/09/2019 14:14, Pablo Neira Ayuso wrote:
> OK, I can document this semantics, I need just _time_ to write that
> documentation. I was expecting this patch description is enough by now
> until I can get to finish that documentation.
I think for two structs with apparently the same contents but different
 semantics (one has the mask bitwise complemented) it's best to hold up
 the code change until the comment is ready to come with it, because
 until then it's a dangerously confusing situation.

>> And you can't just coalesce all consecutive mangles, because if you
>>  mangle two consecutive fields (e.g. UDP sport and dport) the driver
>>  still needs to disentangle that if it works on a 'fields' (rather
>>  than 'u32s') level.
> This infrastructure is _not_ coalescing two consecutive field, e.g.
> UDP sport and dport is _not_ coalesced. The coalesce routine does
> _not_ handle multiple tc pedit ex actions.
So an IPv6 address mangle only comes as a single action if it's from
 netfilter, not if it's coming from TC pedit.  Therefore drivers still
 need to handle an IPv6 or MAC address mangle coming in multiple
 actions, therefore your driver simplifications are invalid.  No?

> The model you propose would still need this code for tc pedit to
> adjust offset/length and coalesce u32 fields.
Yes, but we don't add code/features to the kernel based on what we
 *could* use it for later; every submission has to be self-contained
 in providing something of demonstrable value.  So either implement
 "the model I propose" (which to be clear I'm *not* proposing, I want
 the u32 pedit left as it is; it's just that it's a better model than
 what you're implementing here), or leave well alone.

-Ed
