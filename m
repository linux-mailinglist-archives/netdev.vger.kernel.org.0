Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E9A12BC29
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 02:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfL1BsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 20:48:11 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39949 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbfL1BsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 20:48:10 -0500
Received: by mail-ot1-f68.google.com with SMTP id w21so30641727otj.7;
        Fri, 27 Dec 2019 17:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BUwswIF58DB1KtJ+ICQ6+QTX6MPDBcPHFeXQK9tbzOo=;
        b=Qz9dvRXj5xcgAHNUogdzsS/jQFiXWvqDrC0UFX+jIRAuiUvIi02X585sT03KNfExmk
         ME8lkirSI3tdcOfDwt6g/v22cTkNnr3TgK7szL2haJoZBLWazRdPqJzpKr6KlEiUt8MC
         gXDJ+rL3pf9Y9VBdR33I5ziV/W1rmtlLBxHyXD/fVBT6pLyef2O2bFzGXAk8ZTuAReLa
         0NbxNNdHD1DKjy77hjk2Mc/sO9Hhq2flLFdz5wtfTyhL8fFAdQ78fcunm0AOpTa4wJPr
         sQUcm5Wc3YjdkVRbbU8mHPz2dK1S/UCd3rXfW6mnCOAkzOyhE+0mh0lJ7Qcaz6MpfeRp
         RDmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BUwswIF58DB1KtJ+ICQ6+QTX6MPDBcPHFeXQK9tbzOo=;
        b=o/fUGSY4wrJWNLxPYEfV316vW3hOwlCbU5gAQKM9eIqQv1EC2eq2BIgrdWaArkbldc
         hB8k3k6ZggVWhw9vZaB0puv8I6yZl97SfIPLQ6+14KIR3AI1Vi824dsM2M0QnRShYrDg
         hMAMr90aScA8iiiJigvGKsfY153gHrjmrjABPSP5F3LlwEaoqkB3mOLBFKXKdgg6v3jw
         O6C4ZesP7V5gcFlqfBwckVEGeewf5p9oCkS6GEcEsSANc+F6dyedqpoTY6fRYBkfjzDq
         NuYtUPRET1e7FujYpeV0kJwkGPw/UA64slJpR9+CRHz+qwFHcbvLGkuki5VOcKtMMgSG
         qk+A==
X-Gm-Message-State: APjAAAVxOYTVd/+YHQRsq3do60FB1Q5HkBjLg3N9Gf+c/u72hOvWhAo6
        oLup1Q/+QYjfuHMy9oFfL2VlDfPFsgQ6U9ujs/LxtaaBFsl/bA==
X-Google-Smtp-Source: APXvYqyotEoh+bvefljfUU8znWCWq/Ba+F6QeyxHQfB4vhuphKIJ17iG60Mlrf3hwMRsFAvCE64bmzO5z7MST6LPrH8=
X-Received: by 2002:a05:6830:159a:: with SMTP id i26mr60947634otr.3.1577497689532;
 Fri, 27 Dec 2019 17:48:09 -0800 (PST)
MIME-Version: 1.0
References: <20191227181435.7644-1-sashal@kernel.org> <20191227181435.7644-25-sashal@kernel.org>
In-Reply-To: <20191227181435.7644-25-sashal@kernel.org>
From:   Justin Capella <justincapella@gmail.com>
Date:   Fri, 27 Dec 2019 17:48:39 -0800
Message-ID: <CAMrEMU_QfP2fyh6HHf-QXAY=2GktQRaf1z0HPEX=TUcZQoY0Jw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.9 25/38] rfkill: Fix incorrect check to avoid
 NULL pointer dereference
To:     Sasha Levin <sashal@kernel.org>, Aditya Pakki <pakki001@umn.edu>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Should the mutex be held during this check? Do you know if any of the
users need changing to IS_ERR_OR_NULL or should the dev member also be
checked?

I'm not sure if this is true of the BUG_ON macros but I have seen
implementations of similar macros that are used in the conditional
avoiding the need for a 2nd check.

On Fri, Dec 27, 2019 at 10:18 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Aditya Pakki <pakki001@umn.edu>
>
> [ Upstream commit 6fc232db9e8cd50b9b83534de9cd91ace711b2d7 ]
>
> In rfkill_register, the struct rfkill pointer is first derefernced
> and then checked for NULL. This patch removes the BUG_ON and returns
> an error to the caller in case rfkill is NULL.
>
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> Link: https://lore.kernel.org/r/20191215153409.21696-1-pakki001@umn.edu
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/rfkill/core.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index 884027f62783..87c35844d7d9 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -940,10 +940,13 @@ static void rfkill_sync_work(struct work_struct *work)
>  int __must_check rfkill_register(struct rfkill *rfkill)
>  {
>         static unsigned long rfkill_no;
> -       struct device *dev = &rfkill->dev;
> +       struct device *dev;
>         int error;
>
> -       BUG_ON(!rfkill);
> +       if (!rfkill)
> +               return -EINVAL;
> +
> +       dev = &rfkill->dev;
>
>         mutex_lock(&rfkill_global_mutex);
>
> --
> 2.20.1
>
