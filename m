Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB263631BD
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 20:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236965AbhDQSCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 14:02:49 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:56526 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236807AbhDQSCr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 14:02:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618682541; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=C3QnJoRSnhvDwC+6O1+r8DxZ/vXB9t7O2U1Bylb6Rkc=;
 b=hK6qhkqh0RAw9nb1Qm1rXvz8rz0BHpJ8MXHQ7AWQMQiV63whbm2oZuUJ48pTSDW282yRiHPJ
 BEnH9KpCMbQmv+AgiP6mXS9RQoXVg52FbOAQRfjiGjqi5Yq1CLoPemiaYJ/KMhQU2CskxZXS
 D8oaPk1RgYiKd23Csly/wgCBgiw=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 607b22ab215b831afb35509d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 17 Apr 2021 18:02:19
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6A4D0C43460; Sat, 17 Apr 2021 18:02:19 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 786E1C433F1;
        Sat, 17 Apr 2021 18:02:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 786E1C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next] wlcore: fix overlapping snprintf arguments in
 debugfs
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210323125723.1961432-1-arnd@kernel.org>
References: <20210323125723.1961432-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210417180219.6A4D0C43460@smtp.codeaurora.org>
Date:   Sat, 17 Apr 2021 18:02:19 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc complains about undefined behavior in calling snprintf()
> with the same buffer as input and output:
> 
> drivers/net/wireless/ti/wl18xx/debugfs.c: In function 'diversity_num_of_packets_per_ant_read':
> drivers/net/wireless/ti/wl18xx/../wlcore/debugfs.h:86:3: error: 'snprintf' argument 4 overlaps destination object 'buf' [-Werror=restrict]
>    86 |   snprintf(buf, sizeof(buf), "%s[%d] = %d\n",  \
>       |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    87 |     buf, i, stats->sub.name[i]);   \
>       |     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ti/wl18xx/debugfs.c:24:2: note: in expansion of macro 'DEBUGFS_FWSTATS_FILE_ARRAY'
>    24 |  DEBUGFS_FWSTATS_FILE_ARRAY(a, b, c, wl18xx_acx_statistics)
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ti/wl18xx/debugfs.c:159:1: note: in expansion of macro 'WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY'
>   159 | WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY(diversity, num_of_packets_per_ant,
> 
> There are probably other ways of handling the debugfs file, without
> using on-stack buffers, but a simple workaround here is to remember the
> current position in the buffer and just keep printing in there.
> 
> Fixes: bcca1bbdd412 ("wlcore: add debugfs macro to help print fw statistics arrays")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-drivers-next.git, thanks.

7b0e2c4f6be3 wlcore: fix overlapping snprintf arguments in debugfs

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210323125723.1961432-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

