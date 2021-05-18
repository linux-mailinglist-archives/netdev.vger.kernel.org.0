Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8FE387EED
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 19:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351370AbhERRuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 13:50:16 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:44551 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345469AbhERRuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 13:50:15 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621360137; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=3YWst4AdCVXIc6w9Pje9d25FR37N7LqTf27SEUIDspw=; b=KRkcOGabloeR0mTai8wVPbqeJZXwO2V4gs3Ad0fxcY3XgC9olcc6q9QS1MS8nUZXtHRbKcfe
 FM5CY2sSaHjLvocE+xH3WQoLKHOGVe5C6zwyZUHf2ryITWJNtgnGgHwG5x54P4lcHrl8wuuR
 f06dSchGVDhHYM+XdnzJjNtAuEs=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 60a3fdfc1449805ea2aa92a5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 18 May 2021 17:48:44
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A49E7C4323A; Tue, 18 May 2021 17:48:44 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DBD93C433F1;
        Tue, 18 May 2021 17:48:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DBD93C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] b43legacy: don't save dentries for debugfs
References: <20210518163309.3702100-1-gregkh@linuxfoundation.org>
Date:   Tue, 18 May 2021 20:48:39 +0300
In-Reply-To: <20210518163309.3702100-1-gregkh@linuxfoundation.org> (Greg
        Kroah-Hartman's message of "Tue, 18 May 2021 18:33:09 +0200")
Message-ID: <87zgwsgcg8.fsf@codeaurora.org>
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
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: b43-dev@lists.infradead.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  .../net/wireless/broadcom/b43legacy/debugfs.c | 29 ++++---------------
>  .../net/wireless/broadcom/b43legacy/debugfs.h |  3 --
>  2 files changed, 5 insertions(+), 27 deletions(-)
>
> Note, I can take this through my debugfs tree if wanted, that way I can
> clean up the debugfs_create_bool() api at the same time.  Otherwise it's
> fine, I can wait until next -rc1 for that to happen.

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
