Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F29254302
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgH0KBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:01:00 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:54249 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728303AbgH0KA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 06:00:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598522456; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=g0YFy2eE4lE9AZIT/otbyOAVrUNfiz3bBfsoL1KFWMg=;
 b=lOH6fqEugmTTkRtzLjirNxsh2cnQ4+7dk+bA1aWzzWRO0fDyxIrFTIiWBp8BEYQfYjaVdHXE
 U6lyxKE8KDIaHrCBV08XQIwnwqCJgSn5OfD6oVDRpGkFLnmVRIwcC2k8gX5eY36hWQhSta6/
 iSbSx4YSNzNm71MkYNnVWWc3kn0=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5f4784281d69e438cb14ff36 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 Aug 2020 10:00:08
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3FF13C433B1; Thu, 27 Aug 2020 10:00:06 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 328F9C433CA;
        Thu, 27 Aug 2020 10:00:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 328F9C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] mwifiex: don't call del_timer_sync() on uninitialized
 timer
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200821082720.7716-1-penguin-kernel@I-love.SAKURA.ne.jp>
References: <20200821082720.7716-1-penguin-kernel@I-love.SAKURA.ne.jp>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Brian Norris <briannorris@chromium.org>, amitkarwar@gmail.com,
        andreyknvl@google.com, davem@davemloft.net, dvyukov@google.com,
        huxinming820@gmail.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, nishants@marvell.com,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+373e6719b49912399d21@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200827100007.3FF13C433B1@smtp.codeaurora.org>
Date:   Thu, 27 Aug 2020 10:00:06 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> syzbot is reporting that del_timer_sync() is called from
> mwifiex_usb_cleanup_tx_aggr() from mwifiex_unregister_dev() without
> checking timer_setup() from mwifiex_usb_tx_init() was called [1].
> 
> Ganapathi Bhat proposed a possibly cleaner fix, but it seems that
> that fix was forgotten [2].
> 
> "grep -FrB1 'del_timer' drivers/ | grep -FA1 '.function)'" says that
> currently there are 28 locations which call del_timer[_sync]() only if
> that timer's function field was initialized (because timer_setup() sets
> that timer's function field). Therefore, let's use same approach here.
> 
> [1] https://syzkaller.appspot.com/bug?id=26525f643f454dd7be0078423e3cdb0d57744959
> [2] https://lkml.kernel.org/r/CA+ASDXMHt2gq9Hy+iP_BYkWXsSreWdp3_bAfMkNcuqJ3K+-jbQ@mail.gmail.com
> 
> Reported-by: syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>
> Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
> Cc: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Acked-by: Ganapathi Bhat <ganapathi.bhat@nxp.com>

Patch applied to wireless-drivers-next.git, thanks.

621a3a8b1c0e mwifiex: don't call del_timer_sync() on uninitialized timer

-- 
https://patchwork.kernel.org/patch/11728607/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

