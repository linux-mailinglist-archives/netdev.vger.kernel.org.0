Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 898F9F2676
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 05:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733107AbfKGEQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 23:16:57 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:33035 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733172AbfKGEQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 23:16:57 -0500
Received: by mail-vs1-f68.google.com with SMTP id c25so413551vsp.0
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 20:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LzF6jJl50QUKrzPAcp1BtDAHHTNuNTHTqpvlK0Y3t24=;
        b=If1p9UVVHbMT3OMrRjX6TZFEEaZIstvxpkIGc+J3eG+t7D9eaOQd+EJ9TUQR5C/SDf
         yj7ert6J1aSel7bNYUWjAQwAzESIRkq+ogInQv/yiqKAweakTEn811k3YMwfeOwOYKL7
         ZGWYtHxByLb/c9z1Vi/rBi0wJgfh1LUnYhR34=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LzF6jJl50QUKrzPAcp1BtDAHHTNuNTHTqpvlK0Y3t24=;
        b=KJMMoxJ+kHAGX+tvI16ggIZAapcK8ymS4mJt5Fa25QMzb2ma38VB/Mi4WVdHyoV5wv
         fpZ2JIDeHqAfnshGKQl7PxrpQqo9dDSiXfjZmOY+uMZYhAbLuM+MFA4VI0ijQUghT73l
         C5kAKwRVFkhcOw0GK515mRjipzd/hqsrLZLj7ZjJJ9i87ub4Iko5wQyzvfGKjuxEO5na
         ZypoMXnCh7gxD/PSJo/7qC1yiKI6CjDCmyrNoxlcewmwaufTf/MECyxBUdi1AsBZZcKu
         P664vpdSqW0Sq+T0QNsqFJqeWwdosgByOQIld/fHRfwXQRQNJgYFcVsOHJDkCx5GzHik
         /Qwg==
X-Gm-Message-State: APjAAAWIDWusI9k7sDwk6StLL4vtxevoZnDRkhjbbKXZKC3bTC2NRZlg
        gqFKL6HbPUAEaI1BeRw+zGMdGfQ8dr+X5u8WcD1lfZqYp2E=
X-Google-Smtp-Source: APXvYqyWoK9jREMyy8vyY43cMb0kasmyVW+I0hWsxZz0YGbqht5M4oAStGMyGw23UCirgUqEvwgbjD/YfpkA627rwok=
X-Received: by 2002:a67:edce:: with SMTP id e14mr1297463vsp.182.1573100216052;
 Wed, 06 Nov 2019 20:16:56 -0800 (PST)
MIME-Version: 1.0
References: <20191101054035.42101-1-ikjn@chromium.org> <87y2ws3lvh.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87y2ws3lvh.fsf@kamboji.qca.qualcomm.com>
From:   Ikjoon Jang <ikjn@chromium.org>
Date:   Thu, 7 Nov 2019 12:16:45 +0800
Message-ID: <CAATdQgDhYWgHkujo9m1iUrhSu1Bt9A4C8eS82TD=W22_eaF80g@mail.gmail.com>
Subject: Re: [PATCH] ath10k: disable cpuidle during downloading firmware.
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 2:23 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Ikjoon Jang <ikjn@chromium.org> writes:
>
> > Downloading ath10k firmware needs a large number of IOs and
> > cpuidle's miss predictions make it worse. In the worst case,
> > resume time can be three times longer than the average on sdio.
> >
> > This patch disables cpuidle during firmware downloading by
> > applying PM_QOS_CPU_DMA_LATENCY in ath10k_download_fw().
> >
> > Signed-off-by: Ikjoon Jang <ikjn@chromium.org>
>
> On what hardware and firmware versions did you test this? I'll add that
> to the commit log.
>
> https://wireless.wiki.kernel.org/en/users/drivers/ath10k/submittingpatches#guidelines

Thank you for sharing it.
It's QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00029
on ARMv8 multi cluster platform.

>
> --
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
