Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E141CD605
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 12:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgEKKJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 06:09:55 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:55818 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725983AbgEKKJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 06:09:55 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B87356004F;
        Mon, 11 May 2020 10:09:54 +0000 (UTC)
Received: from us4-mdac16-49.ut7.mdlocal (unknown [10.7.66.16])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B6D742009B;
        Mon, 11 May 2020 10:09:54 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.174])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3CAC022004D;
        Mon, 11 May 2020 10:09:54 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id AF4851C007E;
        Mon, 11 May 2020 10:09:53 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 11 May
 2020 11:09:47 +0100
Subject: Re: [RFC PATCH net] net: flow_offload: simplify hw stats check
 handling
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <netfilter-devel@vger.kernel.org>
References: <49176c41-3696-86d9-f0eb-c20207cd6d23@solarflare.com>
 <20200507153231.GA10250@salvia>
 <9000b990-9a25-936e-6063-0034429256f0@solarflare.com>
 <20200507164643.GA10994@salvia>
 <20200507164820.0f48c36b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200511053359.GC2245@nanopsycho>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <cc715ede-ce75-39ca-4887-4c1d208b4c1f@solarflare.com>
Date:   Mon, 11 May 2020 11:09:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200511053359.GC2245@nanopsycho>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25412.003
X-TM-AS-Result: No-5.616200-8.000000-10
X-TMASE-MatchedRID: cgbqQT5W8he8rRvefcjeTfZvT2zYoYOwC/ExpXrHizzWtEi2QPdTa7SJ
        tSo+0vIaEzA6FLfmziHJADt1ASJDUpa5OOPdqTS1A9lly13c/gE0AJe3B5qfBhEYLStbyrVdeHI
        3R7yfiGd16l6K/mgYgLRKB9HFkk/Js08SNE87w/sYkAMBsEcZTCwJt7jDqzeemyiLZetSf8kir3
        kOMJmHTBQabjOuIvShC24oEZ6SpSkj80Za3RRg8OtOy+Pm9+CG3XX0k0ote7O/1bnNDiuFNqxkR
        3fS3wCki5f+zHkN9Oc=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.616200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25412.003
X-MDID: 1589191794-arpRoAS6J3vX
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/05/2020 06:33, Jiri Pirko wrote:
> Fri, May 08, 2020 at 01:48:20AM CEST, kuba@kernel.org wrote:
>> On Thu, 7 May 2020 18:46:43 +0200 Pablo Neira Ayuso wrote:
>>> Jiri said Disabled means: bail out if you cannot disable it.
>> That's in TC uAPI Jiri chose... doesn't mean we have to do the same
>> internally.
> Yeah, but if TC user says "disabled", please don't assign counter or
> fail.
Right, that's what happens with my proposal: TC "disabled" gets
 mapped to internal "disabled (and no other bits)", which means
 "disable or fail".  In exactly the same way that TC "immediate"
 gets mapped to internal "immediate (and no other bits)" which
 means "immediate or fail".
As Jakub says, "What could be simpler?"

-ed
