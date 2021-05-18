Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4200B387EE8
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 19:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351364AbhERRtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 13:49:32 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:11123 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345084AbhERRta (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 13:49:30 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621360092; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=XmuA3B7GS6TkN5kLEy21D8OBDa8+e9kx9cJtWb8Qq7o=; b=ootCc5Tub+XxW++Yt9SAIdZBNth16c3Aowf732Przn6xIBWRcd2SyxGL9pqz43zzThpKm1IV
 lNgJsVpnnIFBdNKO6+qmf5Jxpfi0fMCm6GPsTUOE9JTVjKny6fV7kU0JgxCIVJKM4EftFhwd
 ZMNHcDVkvqu0g9vDtj/O8dplrT4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 60a3fdd31449805ea2aa2589 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 18 May 2021 17:48:03
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A0628C4360C; Tue, 18 May 2021 17:48:03 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3AC72C433F1;
        Tue, 18 May 2021 17:47:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3AC72C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Chao Yu <chao@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] b43: don't save dentries for debugfs
References: <20210518163304.3702015-1-gregkh@linuxfoundation.org>
Date:   Tue, 18 May 2021 20:47:58 +0300
In-Reply-To: <20210518163304.3702015-1-gregkh@linuxfoundation.org> (Greg
        Kroah-Hartman's message of "Tue, 18 May 2021 18:33:04 +0200")
Message-ID: <874kf0hr1t.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> There is no need to keep around the dentry pointers for the debugfs
> files as they will all be automatically removed when the subdir is
> removed.  So save the space and logic involved in keeping them around by
> just getting rid of them entirely.
>
> By doing this change, we remove one of the last in-kernel user that was
> storing the result of debugfs_create_bool(), so that api can be cleaned
> up.
>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Chao Yu <chao@kernel.org>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: b43-dev@lists.infradead.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/wireless/broadcom/b43/debugfs.c | 34 +++------------------
>  drivers/net/wireless/broadcom/b43/debugfs.h |  3 --
>  2 files changed, 5 insertions(+), 32 deletions(-)
>
> Note, I can take this through my debugfs tree if wanted, that way I can
> clean up the debugfs_create_bool() api at the same time.  Otherwise it's
> fine, I can wait until next -rc1 for that to happen.

Yeah, it's best that you take this via your tree.

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
