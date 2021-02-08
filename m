Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8FA312F3E
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 11:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbhBHKlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 05:41:37 -0500
Received: from so15.mailgun.net ([198.61.254.15]:31797 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232449AbhBHKj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 05:39:27 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612780742; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=gHHW9t8XRWnujhHiEyRdWOS3KbhDsL4evfJXjkWAVR8=;
 b=Mwwlb7ZAV1HghKyThoM09/4hMthQmFqU7U/z7BQY3OgH4yHopFlYFaQZwLWuDy7atsItarwP
 7NyhiruVmSPw673B6kfSYfwYOFxAF7BK5gSunxLzaZ7u3YafcS3j3R/ugS7pniI6k5Cc9vjj
 9TCtvQRkkOGxZ/TN8yhaDlCoRMs=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 602114a981f6c45dce6ab819 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Feb 2021 10:38:33
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EE4E3C433ED; Mon,  8 Feb 2021 10:38:32 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DF897C433C6;
        Mon,  8 Feb 2021 10:38:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DF897C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: rtlwifi: use tasklet_setup to initialize rx_work_tasklet
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210126171550.3066-1-kernel@esmil.dk>
References: <20210126171550.3066-1-kernel@esmil.dk>
To:     Emil Renner Berthing <kernel@esmil.dk>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Emil Renner Berthing <kernel@esmil.dk>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210208103832.EE4E3C433ED@smtp.codeaurora.org>
Date:   Mon,  8 Feb 2021 10:38:32 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Emil Renner Berthing <kernel@esmil.dk> wrote:

> In commit d3ccc14dfe95 most of the tasklets in this driver was
> updated to the new API. However for the rx_work_tasklet only the
> type of the callback was changed from
>   void _rtl_rx_work(unsigned long data)
> to
>   void _rtl_rx_work(struct tasklet_struct *t).
> 
> The initialization of rx_work_tasklet was still open-coded and the
> function pointer just cast into the old type, and hence nothing sets
> rx_work_tasklet.use_callback = true and the callback was still called as
> 
>   t->func(t->data);
> 
> with uninitialized/zero t->data.
> 
> Commit 6b8c7574a5f8 changed the casting of _rtl_rx_work a bit and
> initialized t->data to a pointer to the tasklet cast to an unsigned
> long.
> 
> This way calling t->func(t->data) might actually work through all the
> casting, but it still doesn't update the code to use the new tasklet
> API.
> 
> Let's use the new tasklet_setup to initialize rx_work_tasklet properly
> and set rx_work_tasklet.use_callback = true so that the callback is
> called as
> 
>   t->callback(t);
> 
> without all the casting.
> 
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> Acked-by: Willem de Bruijn <willemb@google.com>

Patch applied to wireless-drivers-next.git, thanks.

ca04217add8e rtlwifi: use tasklet_setup to initialize rx_work_tasklet

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210126171550.3066-1-kernel@esmil.dk/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

