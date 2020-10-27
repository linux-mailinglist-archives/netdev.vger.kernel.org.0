Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67E929AD35
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 14:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752114AbgJ0NYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 09:24:37 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:60914 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752084AbgJ0NYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 09:24:36 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id CA2EA200F1;
        Tue, 27 Oct 2020 13:24:33 +0000 (UTC)
Received: from us4-mdac16-62.at1.mdlocal (unknown [10.110.50.155])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C9F6B8009B;
        Tue, 27 Oct 2020 13:24:33 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.30])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7129C40076;
        Tue, 27 Oct 2020 13:24:33 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 34E9A140084;
        Tue, 27 Oct 2020 13:24:33 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Oct
 2020 13:24:28 +0000
Subject: Re: [PATCH AUTOSEL 5.9 054/147] sfc: add and use efx_tx_send_pending
 in tx.c
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
 <20201026234905.1022767-54-sashal@kernel.org>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <0507e2d9-6535-277c-bd9a-a009c11bf795@solarflare.com>
Date:   Tue, 27 Oct 2020 13:24:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20201026234905.1022767-54-sashal@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25750.003
X-TM-AS-Result: No-3.416600-8.000000-10
X-TMASE-MatchedRID: nVQUmLJJeyYzkUg+npt39/ZvT2zYoYOwC/ExpXrHizxBbp4JobErAt6A
        4kPymCgPML3vcSUM3Wkb0KUY0vR5eD6hJYir1MIcsFkCLeeufNuWGk93C/VnSvn6214PlHOFBLK
        k3SrDK2G7D2478TEKb2KYeZv05+HVbZ3DSPtWJmueAiCmPx4NwJwhktVkBBrQxq9PbUOwsP9QSF
        bL1bvQAd934/rDAK3zlGdyD+QE2h/ocXFe3KMWkQV7FJ+dRUhQbDBDo2E3xWW/Xk4A/H8q+aH7Y
        LicK6DQXBjoZeiEZtOsc5dLZie0RNvXgEiqEY/y218aHXkYIUyFcgJc+QNMwu8bJovJYm8FYupx
        0XjSQPLDOFVmKqGJ4WptqaeO5a/g
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.416600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25750.003
X-MDID: 1603805073-CgOOz7FiilPl
X-PPE-DISP: 1603805073;CgOOz7FiilPl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/10/2020 23:47, Sasha Levin wrote:
> From: Edward Cree <ecree@solarflare.com>
>
> [ Upstream commit 1c0544d24927e4fad04f858216b8ea767a3bd123 ]
>
> Instead of using efx_tx_queue_partner(), which relies on the assumption
>  that tx_queues_per_channel is 2, efx_tx_send_pending() iterates over
>  txqs with efx_for_each_channel_tx_queue().
That assumption was valid for the code as of v5.9; this change was only
 needed to support the extra queues that were added for encap offloads.
Thus, this patch shouldn't be backported, unless -stable is also planning
 to backport that feature (e.g. 0ce8df661456, 24b2c3751aa3), which I
 doubt (it's nearly 20 patches, and can't be considered a bugfix).

-ed
