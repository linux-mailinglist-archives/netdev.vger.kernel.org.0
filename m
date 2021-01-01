Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4222E8541
	for <lists+netdev@lfdr.de>; Fri,  1 Jan 2021 19:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbhAASLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jan 2021 13:11:18 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:24359 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbhAASLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jan 2021 13:11:18 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1609524653; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=yyyMB/WS7c/a7ThU2IK9RmFurJaiAwC+fwP/BuHmIOc=; b=YqrqRkJCjW9A8241eINGOMDy6qzXQuT2IAgHI43hax0ysnRON6xbzCEkmqWccvrhXv+QtbJv
 0nkFD/CDvllM4jPdRvWzRZRAT7l0Wj3CBFNPNonrIauLDAEfE7CN3pFzO4JSCUZOqtcyu6NP
 wS3b8lijubOh9IdNusUWeZIRTrY=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5fef658fcf8ceaa9eed1aaf0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 01 Jan 2021 18:10:23
 GMT
Sender: chinagar=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D167EC433CA; Fri,  1 Jan 2021 18:10:22 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from chinagar-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chinagar)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 56330C433C6;
        Fri,  1 Jan 2021 18:10:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 56330C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=chinagar@codeaurora.org
Date:   Fri, 1 Jan 2021 23:40:10 +0530
From:   Chinmay Agarwal <chinagar@codeaurora.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Race Condition Observed in ARP Processing.
Message-ID: <20210101181009.GA17374@chinagar-linux.qualcomm.com>
References: <20201229160447.GA3156@chinagar-linux.qualcomm.com>
 <CAM_iQpUFCnmu36L0hwrK+xv9gBWKtcq44nOVGNEyR=o9QDx7Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUFCnmu36L0hwrK+xv9gBWKtcq44nOVGNEyR=o9QDx7Pg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sure, will raise a patch post testing.

On Thu, Dec 31, 2020 at 10:53:59AM -0800, Cong Wang wrote:
> On Tue, Dec 29, 2020 at 8:06 AM Chinmay Agarwal <chinagar@codeaurora.org> wrote:
> >
> > Hi All,
> >
> > We found a crash while performing some automated stress tests on a 5.4 kernel based device.
> >
> > We found out that it there is a freed neighbour address which was still part of the gc_list and was leading to crash.
> > Upon adding some debugs and checking neigh_put/neigh_hold/neigh_destroy calls stacks, looks like there is a possibility of a Race condition happening in the code.
> [...]
> > The crash may have been due to out of order ARP replies.
> > As neighbour is marked dead should we go ahead with updating our ARP Tables?
> 
> I think you are probably right, we should just do unlock and return
> in __neigh_update() when hitting if (neigh->dead) branch. Something
> like below:
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 9500d28a43b0..0ce592f585c8 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1250,6 +1250,7 @@ static int __neigh_update(struct neighbour
> *neigh, const u8 *lladdr,
>                 goto out;
>         if (neigh->dead) {
>                 NL_SET_ERR_MSG(extack, "Neighbor entry is now dead");
> +               new = old;
>                 goto out;
>         }
> 
> But given the old state probably contains NUD_PERMANENT, I guess
> you hit the following branch instead:
> 
>         if (!(flags & NEIGH_UPDATE_F_ADMIN) &&
>             (old & (NUD_NOARP | NUD_PERMANENT)))
>                 goto out;
> 
> So we may have to check ->dead before this. Please double check.
> 
> This bug is probably introduced by commit 9c29a2f55ec05cc8b525ee.
> Can you make a patch and send it out formally after testing?
> 
> Thanks!
