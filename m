Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D68B1B0954
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 14:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgDTM2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 08:28:40 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:49888 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726020AbgDTM2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 08:28:40 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E513B200AE;
        Mon, 20 Apr 2020 12:28:38 +0000 (UTC)
Received: from us4-mdac16-48.at1.mdlocal (unknown [10.110.50.131])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E3CAF8009B;
        Mon, 20 Apr 2020 12:28:38 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.107])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8DB8E40080;
        Mon, 20 Apr 2020 12:28:37 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 489BF28007E;
        Mon, 20 Apr 2020 12:28:37 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 20 Apr
 2020 13:28:31 +0100
Subject: Re: [PATCH net] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DISABLED
To:     Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>
References: <20200419115338.659487-1-pablo@netfilter.org>
 <20200420080200.GA6581@nanopsycho.orion>
 <20200420090505.pr6wsunozfh7afaj@salvia>
 <20200420091302.GB6581@nanopsycho.orion>
 <20200420100341.6qehcgz66wq4ysax@salvia>
 <20200420115210.GE6581@nanopsycho.orion>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <3980eea4-18d8-5e62-2d6d-fce0a7e7ed4c@solarflare.com>
Date:   Mon, 20 Apr 2020 13:28:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200420115210.GE6581@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25366.003
X-TM-AS-Result: No-2.203900-8.000000-10
X-TMASE-MatchedRID: +c13yJDs9028rRvefcjeTfZvT2zYoYOwC/ExpXrHizxpsnGGIgWMmSKT
        myMMsRKAY/oWqqR/Eysk6Hc578lOBfrj/vKOcVHzHC7hAz/oKnJgh0pLCpbWY3c925yOJXmF166
        Xb3/Hw4N1wnSkRUaBiYZP3XbRhM01r78SC5iivxyDGx/OQ1GV8mrz/G/ZSbVq+gtHj7OwNO1YN8
        MGeZojK5/hRU+lyB17bkXiGQVf14FtguaTVkm/7JSEJCK/UpOe8B1+fkPI48NcLq4mdz+nRKyCW
        SW0HzF0amjOS5qVJMM/FLpz8Py0KJ6oP1a0mRIj
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-2.203900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25366.003
X-MDID: 1587385718-xMQyLuTefCbI
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/04/2020 12:52, Jiri Pirko wrote:
> However for TC, when user specifies "HW_STATS_DISABLED", the driver
> should not do stats.
What should a driver do if the user specifies DISABLED, but the stats
 are still needed for internal bookkeeping (e.g. to prod an ARP entry
 that's in use for encapsulation offload, so that it doesn't get
 expired out of the cache)?  Enable the stats on the HW anyway but
 not report them to FLOW_CLS_STATS?  Or return an error?

-ed
