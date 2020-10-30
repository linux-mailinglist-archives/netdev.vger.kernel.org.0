Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABCDD2A0B75
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgJ3Qmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:42:37 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.49]:37204 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725808AbgJ3Qmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 12:42:37 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id ADEE060101;
        Fri, 30 Oct 2020 16:42:36 +0000 (UTC)
Received: from us4-mdac16-74.ut7.mdlocal (unknown [10.7.64.193])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A9C5D200A4;
        Fri, 30 Oct 2020 16:42:36 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.176])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3B0C822004D;
        Fri, 30 Oct 2020 16:42:36 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D03AD680080;
        Fri, 30 Oct 2020 16:42:35 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 30 Oct
 2020 16:42:30 +0000
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
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <e1765f12-daa4-feb3-28e1-7d360830026d@solarflare.com>
Date:   Fri, 30 Oct 2020 16:42:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CA+FuTSdk-UZ92VdpWTAx87xnzhsDKcWfVOOwG_B16HdAuP7PQA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25756.003
X-TM-AS-Result: No-5.081400-8.000000-10
X-TMASE-MatchedRID: oTBA/+sdKaajtIQ3octbWfZvT2zYoYOwC/ExpXrHizzbUorR2XNnultK
        ptFhGFqywulAfYsADoCfFfHNM+QugwHmMMvi0m/TtKR5FXfbysywwzZDy8WY9oxAiQFTbDvUFfQ
        L8ZvDsiNYvX1Pgu68D0wEOB12w9KNUnj7o6RqbPSqNnzrkU+2muHCwRwMNQUW1R/ptYWR8C7Tuk
        OXFW3zJx+vK5AYtD6wS2Al/URJMHSvvxILmKK/HDl/1fD/GopdnCGS1WQEGtDGr09tQ7Cw/1BIV
        svVu9ABec3QM3secWa0qwBerSjL6y/1MtKSkQ/ynm+iNX1bS5CfsfYuKOhsLTNzBXdPV2nWlExl
        QIQeRG0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.081400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25756.003
X-MDID: 1604076156-PWAMpWatHVRK
X-PPE-DISP: 1604076156;PWAMpWatHVRK
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/10/2020 16:26, Willem de Bruijn wrote:
> Then you could (as follow-up) advertise without GSO_PARTIAL and avoid
> the whole transition through the gso layer?

The thing is, non-PARTIAL offload only supports tunnels that the NIC
 understands (single-layer UDP tunnels), but AIUI GSO_PARTIAL can
 support all sorts of other things, such as gretaps (though we'd need
 some more advertised features, I haven't figured out quite which
 ones yet but when I do and can test it I'll send a follow-up) and
 nested tunnels (as long as we don't need to edit the 'middle' IP ID,
 e.g. if it's DF or IPv6).  So we definitely want to advertise
 GSO_PARTIAL support.
But possibly I don't need to have NETIF_F_GSO_UDP_TUNNEL[_CSUM] in
 net_dev->gso_partial_features?

-ed
