Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D212A0AE1
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbgJ3QNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:13:39 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.49]:35468 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727286AbgJ3QNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 12:13:38 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6C7AA600F1;
        Fri, 30 Oct 2020 16:13:37 +0000 (UTC)
Received: from us4-mdac16-37.ut7.mdlocal (unknown [10.7.66.156])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 67ED7200A3;
        Fri, 30 Oct 2020 16:13:37 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.38])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F1C271C0054;
        Fri, 30 Oct 2020 16:13:36 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 88A60800056;
        Fri, 30 Oct 2020 16:13:36 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 30 Oct
 2020 16:13:30 +0000
Subject: Re: [PATCH net-next 2/4] sfc: implement encap TSO on EF100
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     <linux-net-drivers@solarflare.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <6e1ea05f-faeb-18df-91ef-572445691d89@solarflare.com>
 <94ca05ca-2871-3da6-e14f-0a9cb48ed2a5@solarflare.com>
 <CA+FuTSdaPV_ZsU=YfT6vAx-ScGWu1O1Ji1ubNmgxe4PZYYNfZw@mail.gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <ca372399-fecb-2e5a-ae92-dca7275be7ab@solarflare.com>
Date:   Fri, 30 Oct 2020 16:13:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CA+FuTSdaPV_ZsU=YfT6vAx-ScGWu1O1Ji1ubNmgxe4PZYYNfZw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25756.003
X-TM-AS-Result: No-4.395800-8.000000-10
X-TMASE-MatchedRID: oTBA/+sdKaajtIQ3octbWfZvT2zYoYOwC/ExpXrHizzlrNLt5KWkaHG9
        F+cXkyliiN0smgshM5SCaN+xuKdzF/DE/ruk94vOzNIobH2DzGGpvf+jmz45w+ZAlRR6AIJ7PHx
        PHi4pd17mrlz+BDx1SP+I5msuDduqsj0iE9pOpuSL6q5RsNhv5PiH64jt3FfEGUs9b7xvtJpz1l
        g2O4UkldFChERArRPnzovv2J8uw90YB2fOueQzjzl/1fD/GopdnCGS1WQEGtDGr09tQ7Cw/1BIV
        svVu9ABWBd6ltyXuvuROO6YYUcFJi4npa2/vnE5uOlwAwikwNgjdx5lITBMFo5XoNU5ufJI3QdC
        2D3o3LVjSYA/oRc+RNS5FAO+W/DXFJS1VJhdvC3wHX5+Q8jjw1wuriZ3P6dErIJZJbQfMXRqaM5
        LmpUkwzunJXJz8X1QftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.395800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25756.003
X-MDID: 1604074417-HdRhvI0XiYSm
X-PPE-DISP: 1604074417;HdRhvI0XiYSm
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/10/2020 15:49, Willem de Bruijn wrote:
> On Wed, Oct 28, 2020 at 9:39 PM Edward Cree <ecree@solarflare.com> wrote:
>> +                             ESF_GZ_TX_TSO_ED_OUTER_UDP_LEN, encap && !gso_partial,
> 
> This is a boolean field to signal whether the NIC needs to fix up the
> udp length field ?
Yes.

> Which in the case of GSO_PARTIAL has already been resolved by the gso
> layer (in __skb_udp_tunnel_segment).
Indeed.

> Just curious, is this ever expected to be true? Not based on current
> advertised features, right?
As I mentioned in the patch description and cover letter, I'm not
 entirely certain.  I don't _think_ the stack will ever give us an
 encap skb without GSO_PARTIAL with the features we've advertised,
 but since the hardware supports it I thought it better to handle
 that case anyway, just in case I'm mistaken.

-ed
