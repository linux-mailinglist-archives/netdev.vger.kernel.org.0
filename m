Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE9FA88139
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 19:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407373AbfHIRcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 13:32:20 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:32856 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726157AbfHIRcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 13:32:18 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 914AD98007A;
        Fri,  9 Aug 2019 17:32:11 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 9 Aug
 2019 10:32:04 -0700
Subject: Re: [PATCH v3 net-next 0/3] net: batched receive in GRO path
To:     Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
CC:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "linux-net-drivers@solarflare.com" <linux-net-drivers@solarflare.com>
References: <c6e2474e-2c8a-5881-86bf-59c66bdfc34f@solarflare.com>
 <AM0PR04MB4994C1A8F32FB6C9A7EE057E94D60@AM0PR04MB4994.eurprd04.prod.outlook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <a6faf533-6dd3-d7d7-9464-1fe87d0ac7fc@solarflare.com>
Date:   Fri, 9 Aug 2019 18:32:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <AM0PR04MB4994C1A8F32FB6C9A7EE057E94D60@AM0PR04MB4994.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24836.003
X-TM-AS-Result: No-2.112500-4.000000-10
X-TMASE-MatchedRID: scwq2vQP8OHmLzc6AOD8DfHkpkyUphL9+IfriO3cV8RE6qvV2uOcub8g
        3TlUXOF7nbLB5zXDLB2q3CLfAyeEI2cPPLBO2A0bN19PjPJahlJ6i696PjRPiPkuQv9PIVnN10d
        pxFjKl75/MmgtAHVjaLr7cyh+G7QMNO5dlFRJNAYr+fETfhSxIzYj3YEUmwiMYxGZfkM2VceUR6
        6C6i5v8zNL/d/R0RZNNhTrvE0YItIrP1wc0Kr8faHXpVd0THLOfS0Ip2eEHnzWRN8STJpl3PoLR
        4+zsDTt9VPDReA7LdprPSROiqR4dyNZ+CCPkCIO0HD7n31YzE6vuDUKMZ4pUhXduck8JbqKqE+b
        /qlJMMZjEVwCkbftjhxxume6OboREoCMXu4zsQhR029mOM6P0LrcE8xytxC5d5hZXZFoB8PxWx9
        3BSYyycC+ksT6a9fy
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.112500-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24836.003
X-MDID: 1565371935-oWOmd0fVaxvo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/08/2019 18:14, Ioana Ciocoi Radulescu wrote:
> Hi Edward,
>
> I'm probably missing a lot of context here, but is there a reason
> this change targets only the napi_gro_frags() path and not the
> napi_gro_receive() one?
> I'm trying to understand what drivers that don't call napi_gro_frags()
> should do in order to benefit from this batching feature.
The sfc driver (which is what I have lots of hardware for, so I can
 test it) uses napi_gro_frags().
It should be possible to do a similar patch to napi_gro_receive(),
 if someone wants to put in the effort of writing and testing it.
However, there are many more callers, so more effort required to
 make sure none of them care whether the return value is GRO_DROP
 or GRO_NORMAL (since the listified version cannot give that
 indication).
Also, the guidance from Eric is that drivers seeking high performance
 should use napi_gro_frags(), as this allows GRO to recycle the SKB.

All of this together means I don't plan to submit such a patch; I
 would however be happy to review a patch if someone else writes one.

HTH,
-Ed
