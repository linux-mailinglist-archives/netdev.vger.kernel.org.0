Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE63A6C00
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 16:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbfICO4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 10:56:37 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:34772 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729083AbfICO4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 10:56:37 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BE7D3A40070;
        Tue,  3 Sep 2019 14:56:35 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 3 Sep
 2019 07:56:26 -0700
Subject: Re: [PATCH net-next v3] net: openvswitch: Set OvS recirc_id from tc
 chain index
To:     Paul Blakey <paulb@mellanox.com>,
        Pravin B Shelar <pshelar@ovn.org>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Justin Pettit" <jpettit@nicira.com>,
        Simon Horman <simon.horman@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>
CC:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        "Yossi Kuperman" <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
References: <1567517015-10778-1-git-send-email-paulb@mellanox.com>
 <1567517015-10778-2-git-send-email-paulb@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <6d2e1ef7-f859-32f4-584f-1f0f772edadf@solarflare.com>
Date:   Tue, 3 Sep 2019 15:56:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1567517015-10778-2-git-send-email-paulb@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24886.005
X-TM-AS-Result: No-6.761900-4.000000-10
X-TMASE-MatchedRID: 9zTThWtzImvmLzc6AOD8DfHkpkyUphL9IbOOW42tNMuRoQLwUmtov39v
        gq7iW97M2Vt6jneXAxGNT0huAYqCsxls7x5eGXm3ZdorcofH/GnM8zLNncnslcuSXx71bvSLEMj
        Dscz85YVjrNRspPVGhslBeRDxZMPWuqiZIj+FoTPGAzTlP3eD9u1lLt5eTung/zIkW73uAA7mxl
        PBgd8Ezl6c8x2gdhqGX7bicKxRIU2No+PRbWqfRLI7zVffJqTzaCwhMlkvgVANlWX5ZKNfRcLeW
        2iJjcdjedZdmwmJiLL9LJu/I3bQC37cGd19dSFd
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.761900-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24886.005
X-MDID: 1567522596-9OUjt9N0LBtv
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/09/2019 14:23, Paul Blakey wrote:
> Offloaded OvS datapath rules are translated one to one to tc rules,
> for example the following simplified OvS rule:
>
> recirc_id(0),in_port(dev1),eth_type(0x0800),ct_state(-trk) actions:ct(),recirc(2)
>
> Will be translated to the following tc rule:
>
> $ tc filter add dev dev1 ingress \
> 	    prio 1 chain 0 proto ip \
> 		flower tcp ct_state -trk \
> 		action ct pipe \
> 		action goto chain 2
>
> Received packets will first travel though tc, and if they aren't stolen
> by it, like in the above rule, they will continue to OvS datapath.
> Since we already did some actions (action ct in this case) which might
> modify the packets, and updated action stats, we would like to continue
> the proccessing with the correct recirc_id in OvS (here recirc_id(2))
> where we left off.
IMHO each offload (OvS -> tc, and tc -> hw) ought only take place for a rule
 if all sequelae of that rule are also offloaded, or if non-offloaded sequelae
 can be guaranteed to provide an unmodified packet so that the exception path
 can start from the beginning.  I don't like this idea of doing part of the
 processing in one place and then resuming the rest later in an entirely
 different piece of code.
