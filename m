Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE9C1D0C76
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 11:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732385AbgEMJjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 05:39:55 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:39352 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728224AbgEMJjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 05:39:55 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B6E226006B;
        Wed, 13 May 2020 09:39:54 +0000 (UTC)
Received: from us4-mdac16-14.ut7.mdlocal (unknown [10.7.65.238])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B4A712009A;
        Wed, 13 May 2020 09:39:54 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.35])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 487931C004F;
        Wed, 13 May 2020 09:39:54 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CB35D48005F;
        Wed, 13 May 2020 09:39:53 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 13 May
 2020 10:39:47 +0100
Subject: Re: [PATCH][next] sfc: fix dereference of table before it is null
 checked
To:     Colin King <colin.king@canonical.com>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200512171355.221810-1-colin.king@canonical.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <680245f9-e26d-87e1-6e52-138302950e06@solarflare.com>
Date:   Wed, 13 May 2020 10:39:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200512171355.221810-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25416.003
X-TM-AS-Result: No-3.998300-8.000000-10
X-TMASE-MatchedRID: +c13yJDs902Q0e+Zbzl6QvZvT2zYoYOwC/ExpXrHizzalJpeFb3A2AzC
        4kGpAim5MfxNln1FsCZEM+a80Fik2m0EKIw8Yc1pmvnKSb020hxXjjsM2/DfxsbJavo8UnfR9WX
        m+yhJKyhrLBQyc0DNWpGTpe1iiCJq71zr0FZRMbCWlioo2ZbGwdmzcdRxL+xwKrauXd3MZDVu4X
        ahMwgGvMSZYRZ6lSrPRIFUqxkBLlV8Z3pE9vTn43HN0Hf8/0hAYa6zuRJ7MeptVPWBZvQASn3zG
        QdUBqY5Ut3qL8UMiT/ktbyhRJHSSQbEQIfFpkwHBtlgFh29qnpKzBwu5JpklnOUuoTXM7r4Qwym
        txuJ6y0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.998300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25416.003
X-MDID: 1589362794-1a_JcRE-r6Ol
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/05/2020 18:13, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Currently pointer table is being dereferenced on a null check of
> table->must_restore_filters before it is being null checked, leading
> to a potential null pointer dereference issue.  Fix this by null
> checking table before dereferencing it when checking for a null
> table->must_restore_filters.
>
> Addresses-Coverity: ("Dereference before null check")
> Fixes: e4fe938cff04 ("sfc: move 'must restore' flags out of ef10-specific nic_data")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Edward Cree <ecree@solarflare.com>
