Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01FC2A0D2F
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 19:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgJ3SOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 14:14:38 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.48]:54540 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbgJ3SOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 14:14:38 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C602960096;
        Fri, 30 Oct 2020 18:14:37 +0000 (UTC)
Received: from us4-mdac16-69.ut7.mdlocal (unknown [10.7.64.188])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C2E2C200A0;
        Fri, 30 Oct 2020 18:14:37 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.32])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 381EE1C0059;
        Fri, 30 Oct 2020 18:14:37 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CB380B40066;
        Fri, 30 Oct 2020 18:14:36 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 30 Oct
 2020 18:14:30 +0000
Subject: Re: [PATCH net-next 2/4] sfc: implement encap TSO on EF100
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     <linux-net-drivers@solarflare.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <6e1ea05f-faeb-18df-91ef-572445691d89@solarflare.com>
 <94ca05ca-2871-3da6-e14f-0a9cb48ed2a5@solarflare.com>
 <CA+FuTSdaPV_ZsU=YfT6vAx-ScGWu1O1Ji1ubNmgxe4PZYYNfZw@mail.gmail.com>
 <ca372399-fecb-2e5a-ae92-dca7275be7ab@solarflare.com>
 <CA+FuTSdk-UZ92VdpWTAx87xnzhsDKcWfVOOwG_B16HdAuP7PQA@mail.gmail.com>
 <e1765f12-daa4-feb3-28e1-7d360830026d@solarflare.com>
 <CA+FuTSf1dGDmRexKR54p=FnEY0LSBCc+tzknfVFTsmX7gk+fpQ@mail.gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <1fa7b4c0-e019-bf84-307b-61a1152f5a04@solarflare.com>
Date:   Fri, 30 Oct 2020 18:14:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CA+FuTSf1dGDmRexKR54p=FnEY0LSBCc+tzknfVFTsmX7gk+fpQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25756.003
X-TM-AS-Result: No-3.281200-8.000000-10
X-TMASE-MatchedRID: oHOSwQSJZWijtIQ3octbWfZvT2zYoYOwC/ExpXrHizzlrNLt5KWkaBX0
        C/Gbw7IjIUkmlK3xSwhKHNQRF2gUBIqEDaEbYNOrp1I/J98PB1svKK/+8XMSRPJglQJx8UhBLPJ
        tWpbJjY0fyk9LT1rouulgrbBzVNV1GTwN+uN2F2KiVU7u7I4INdcC9FrS18kaOF0RIPSotdMx60
        3FJpmk9gen4o29UcIalIOlLMIyTectDbjO6ZAKcZ2icAsqCI284cLBHAw1BRZahAEL9o+TW8GZV
        QO4Voax52+k2aoDy6DsqaDZaErhCrKnTmo+3607iVJZi91I9JjFi3oiVvGfqTFBFiCLXfBC224u
        eXqtKLsotAlPUB5/hCZ1UzmLgiCB0665Oh56EW/yxz2hgoG97YvkwJz527bYaq7Dr1BRCsvFayY
        4VMjchhQ5T6KyKLqz8O/KjWIwBFRbVl6S7rrS0zdfT4zyWoZSDxIIGsB6XY2bKItl61J/yZkw8K
        dMzN86KrauXd3MZDX5iEYLIhby7nn+s+Fj/TNFg83UV5BZu2QrgtJYGq6qfU4owPb97iGb+wVBm
        gQsmNVquZCP56CQyEWvaElmbPdLo1KAzUCgClxiVC6qOgRmhQbEQIfFpkwHBtlgFh29qnpKzBwu
        5JpklnOUuoTXM7r4QwymtxuJ6y0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.281200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25756.003
X-MDID: 1604081677-m6WxdwedO4yH
X-PPE-DISP: 1604081677;m6WxdwedO4yH
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/10/2020 17:33, Willem de Bruijn wrote:
> On Fri, Oct 30, 2020 at 12:43 PM Edward Cree <ecree@solarflare.com> wrote:
>> But possibly I don't need to have NETIF_F_GSO_UDP_TUNNEL[_CSUM] in
>>  net_dev->gso_partial_features?
> If the device can handle fixing the odd last segment length, indeed.
It can, but...
I thought Linux didn't give drivers odd last segments any more.  At
 least I'm fairly sure that in the (non-PARTIAL) non-encap TSO tests
 I've done, the GSO skbs we've been given have all been a whole
 number of mss long.
Which means I haven't been able to test that the device gets it right.

> Until adding other tunnel types like NETIF_F_GSO_GRE_CSUM, for this
> device gso_partial_features would then be 0 and thus
> NETIF_F_GSO_PARTIAL is not needed at all?
Unless the kernel supports GSO_PARTIAL of nested tunnels.  The device
 will handle (say) VxLAN-in-VxLAN just fine, as long as you don't want
 it to update the middle IPID; and being able to cope with crazy
 things like that was (I thought) part of the point of GSO_PARTIAL.
Indeed, given that GSO_PARTIAL is supposed to be a non-protocol-
 ossified design, it seems a bit silly to me that we have to specify
 a list of other NETIF_F_GSO_foo, rather than just being able to say
 "I can handle anything of the form ETH-IP-gubbins-IP-TCP" and let
 the kernel put whatever it likes — VxLAN, GRE, fou-over-geneve with
 cherry and sprinkles — in the 'gubbins'.  Wasn't that what 'less is
 more' was supposed to be all about?

-ed
