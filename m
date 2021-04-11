Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BCB35B2BE
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 11:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbhDKJaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 05:30:39 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:18524 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235251AbhDKJai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 05:30:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618133422; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=CZaQsurYXafEiO8zvG37h8CkGJKclLCmc8SRLDWNp7g=;
 b=oKDOhuG6yEWclw0Kp5xGkFwLlRO+wqfQrndXiFYXijnfp/uYiVY5SAkzqG2wM2/lkwOfa3qW
 YjbzggpbkZ2n8E30czKiOZ63lRHHDYoBNTYuVlI6R/aDOqDheXuSgE2aYPMUD8XM9Qd8ml14
 3DPP7/Py5Bn/dcckyI7Na8L/EpE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6072c1a39a9ff96d95c8e2b9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 11 Apr 2021 09:30:11
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D8C1BC433CA; Sun, 11 Apr 2021 09:30:11 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 70DC3C433C6;
        Sun, 11 Apr 2021 09:30:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 70DC3C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mt7601u: fix always true expression
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210225183241.1002129-1-colin.king@canonical.com>
References: <20210225183241.1002129-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Jakub Kicinski <kubakici@wp.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210411093011.D8C1BC433CA@smtp.codeaurora.org>
Date:   Sun, 11 Apr 2021 09:30:11 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the expression ~nic_conf1 is always true because nic_conf1
> is a u16 and according to 6.5.3.3 of the C standard the ~ operator
> promotes the u16 to an integer before flipping all the bits. Thus
> the top 16 bits of the integer result are all set so the expression
> is always true.  If the intention was to flip all the bits of nic_conf1
> then casting the integer result back to a u16 is a suitabel fix.
> 
> Interestingly static analyzers seem to thing a bitwise ! should be
> used instead of ~ for this scenario, so I think the original intent
> of the expression may need some extra consideration.
> 
> Addresses-Coverity: ("Logical vs. bitwise operator")
> Fixes: c869f77d6abb ("add mt7601u driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

Patch applied to wireless-drivers-next.git, thanks.

87fce88658ba mt7601u: fix always true expression

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210225183241.1002129-1-colin.king@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

