Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69DE1D097C
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 09:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730085AbgEMHFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 03:05:18 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:42656 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730410AbgEMHFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 03:05:17 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589353517; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=5BY6ILWQbBBP5bzYtCeFue+FX7NC/WAICZFymNd3smM=; b=eJTTgKz27YhTwOVuo9thKdwawyFBqjwNNEGLGl1J5AFukyPYwhgIFsuvwukk7cOC0JnESLT/
 bGvB6YWXA8+OA90nYY6+GQyNh38OCdeQOf2k8voVBlO6i0XWE3oRm0qJzN5YwIIWHZfSBuNa
 4I0EPt0/iGujEP538IFizs+YXcQ=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ebb9c23.7f7e4566c3e8-smtp-out-n03;
 Wed, 13 May 2020 07:05:07 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CA574C432C2; Wed, 13 May 2020 07:05:06 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4317FC433D2;
        Wed, 13 May 2020 07:05:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4317FC433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>, emamd001@umn.edu,
        smccaman@umn.edu, Kangjie Lu <kjlu@umn.edu>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "\<netdev\@vger.kernel.org\>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath9k: release allocated buffer if timed out
References: <20190906185931.19288-1-navid.emamdoost@gmail.com>
        <CA+ASDXMnp-GTkrT7B5O+dtopJUmGBay=Tn=-nf1LW1MtaVOr+w@mail.gmail.com>
Date:   Wed, 13 May 2020 10:05:00 +0300
In-Reply-To: <CA+ASDXMnp-GTkrT7B5O+dtopJUmGBay=Tn=-nf1LW1MtaVOr+w@mail.gmail.com>
        (Brian Norris's message of "Tue, 12 May 2020 09:56:47 -0700")
Message-ID: <878shwtiw3.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> On Fri, Sep 6, 2019 at 11:59 AM Navid Emamdoost
> <navid.emamdoost@gmail.com> wrote:
>>
>> In ath9k_wmi_cmd, the allocated network buffer needs to be released
>> if timeout happens. Otherwise memory will be leaked.
>>
>> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
>
> I wonder, did you actually test your patches? I ask, because it seems
> that all your patches are of the same mechanical variety (produced by
> some sort of research project?), and if I look around a bit, I see
> several mistakes and regressions noted on your other patches. And
> recently, I see someone reporting a 5.4 kernel regression, which looks
> a lot like it was caused by this patch:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=207703#c1
>
> I'll propose a revert, if there's no evidence this was actually tested
> or otherwise confirmed to fix a real bug.

Actually it's already reverted in -next, nobody just realised that it's
a regression from commit 728c1e2a05e4:

ced21a4c726b ath9k: Fix use-after-free Read in htc_connect_service

v5.8-rc1 should be the first release having the fix.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
