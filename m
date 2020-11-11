Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1642AF78E
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 18:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgKKRsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 12:48:07 -0500
Received: from z5.mailgun.us ([104.130.96.5]:31040 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgKKRsF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 12:48:05 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605116885; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=7g87NZ0M/XFTxCuaZCnkFZZOqSYBdmIg4bjJcPXl19M=; b=FJFGLH5KqdGsNAsSl20eygc1U6AJ3XdO53Iy8CsBmodDqKZVFZwQPgk3/FFZTLIEe7VUCWcY
 iONkBSQiXtxp3+3fpBSlt33Nt+zTwUMV41xjWWNr0rY3N+BCHA/aqc00+zGvkuCudbci9Xsa
 YBzGFwwrODu0rw9wVy4x59qnMdw=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5fac1b7f34c4908d19e6864b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 11 Nov 2020 17:12:31
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 12E90C433A1; Wed, 11 Nov 2020 17:12:30 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C6DEEC433C6;
        Wed, 11 Nov 2020 17:12:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C6DEEC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?utf-8?Q?Bj?= =?utf-8?Q?=C3=B8rn?= Mork <bjorn@mork.no>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Oliver Neukum <oneukum@suse.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH net-next 3/5] qtnfmac: switch to core handling of rx/tx byte/packet counters
References: <5fbe3a1f-6625-eadc-b1c9-f76f78debb94@gmail.com>
        <4b22c155-6868-793f-ebfe-f797e16b9c40@gmail.com>
Date:   Wed, 11 Nov 2020 19:12:22 +0200
In-Reply-To: <4b22c155-6868-793f-ebfe-f797e16b9c40@gmail.com> (Heiner
        Kallweit's message of "Tue, 10 Nov 2020 20:48:54 +0100")
Message-ID: <87o8k34y2x.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner Kallweit <hkallweit1@gmail.com> writes:

> Use netdev->tstats instead of a member of qtnf_vif for storing a pointer
> to the per-cpu counters. This allows us to use core functionality for
> statistics handling.
> The driver sets netdev->needs_free_netdev, therefore freeing the per-cpu
> counters at the right point in time is a little bit tricky. Best option
> seems to be to use the ndo_init/ndo_uninit callbacks.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/wireless/quantenna/qtnfmac/core.c | 78 ++++---------------
>  drivers/net/wireless/quantenna/qtnfmac/core.h |  4 -
>  .../quantenna/qtnfmac/pcie/pearl_pcie.c       |  4 +-
>  .../quantenna/qtnfmac/pcie/topaz_pcie.c       |  4 +-
>  4 files changed, 20 insertions(+), 70 deletions(-)

Jakub, feel free to take this to net-next:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

But I can also take this to wireless-drivers-next, whichever you prefer.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
