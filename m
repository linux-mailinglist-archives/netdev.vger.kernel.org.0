Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E148631D0A9
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 20:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhBPTF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 14:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbhBPTFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 14:05:54 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A23C06174A;
        Tue, 16 Feb 2021 11:05:14 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id gx20so6567326pjb.1;
        Tue, 16 Feb 2021 11:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pfgdjjFnzWT6nIXYea4eb2LxWJE9z91Xa9+Wh/cdXH8=;
        b=ZC3gMrescLMP5wYUdc3qyaQfGBodRCwh+6wc2zGjUmxE0nQKYV1MzOrfTJL31d/AWf
         0XqLwhQAXhEupz6BEj24nIcDWSRUDST2k1ozDAREtI9qV2AO925qzIc2dvf5CdbHnRhJ
         KKIbgvMwGTPbkSsExDnXMXLOgagGhK+uWJ4Igbx8zCV5rANwknSco1oo9+Po3dcvRki7
         P9Y4YpapShaR9P7WK32QSkXqAMdpzR0UFYA3eUiwF9H7ls4jxacxJbah2pLzqw2wJkva
         QwDj+k9MX5xLHJxGhYu0OKi01/+fw37WlrzglkuASugW5jfT30laFMQlVcspQ87diVm1
         NIqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pfgdjjFnzWT6nIXYea4eb2LxWJE9z91Xa9+Wh/cdXH8=;
        b=qq5xikB8KD4w396KXuXygaB6KbYXy/AwKZwwmNp0MsNTo4C6cFCWKsS8y61bGF9Px1
         m1mMnqjkMdVAjJS+37uVneU7wpAIYm9+b2k+y2lEDT1KDCVw0f/7NZleOwflPxseZdFe
         Zi7eHPMFrMR/lrv/p9cBonQFPukLTvU9C7rilpRvZyrSi+3eFxWYMkAmyWkVQ5HNlSOd
         2lJ9ATqQOe0j+axnpR89XePUEGn+moEcYK77ShCm6ptwNcvVj9g3IY3dC4YnDitMTSzb
         Gjct9rnfyGqTmbDRVweOc3Lkgx4g9ImxpUO+jwldRaixeX211VsW54tfmqo76qqeDwzl
         uQQg==
X-Gm-Message-State: AOAM5329iO/X2jcUwaKSll//1vCCj/Cuw8qPmhLPFymU/0knIf/XzO51
        KUipOMwlIZq7By9944D/wnpKZJV8lEGOmFlhbrk=
X-Google-Smtp-Source: ABdhPJx6GbjOEQyVyCEWTP1mtRBKa++tQMTh5uh3ntZ0rR01SKZY0EszWjghrcWaHFewmqexInqaVEDsyos2EmhxHlc=
X-Received: by 2002:a17:902:c155:b029:e3:7396:ec41 with SMTP id
 21-20020a170902c155b02900e37396ec41mr4336335plj.10.1613502314183; Tue, 16 Feb
 2021 11:05:14 -0800 (PST)
MIME-Version: 1.0
References: <CAM_iQpVEZiOca0po6N5Hcp67LV98k_PhbEXogCJFjpOR0AbGwg@mail.gmail.com>
 <20210216162200.1834139-1-vladbu@nvidia.com>
In-Reply-To: <20210216162200.1834139-1-vladbu@nvidia.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 16 Feb 2021 11:05:03 -0800
Message-ID: <CAM_iQpWqFgi8BqSN3QnJUNVO5Y+B+LpcnKymPgqPo4LUM=F8VQ@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: fix police ext initialization
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     syzbot <syzbot+151e3e714d34ae4ce7e8@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 8:22 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>
> When police action is created by cls API tcf_exts_validate() first
> conditional that calls tcf_action_init_1() directly, the action idr is not
> updated according to latest changes in action API that require caller to
> commit newly created action to idr with tcf_idr_insert_many(). This results
> such action not being accessible through act API and causes crash reported
> by syzbot:

Good catch!

This certainly makes sense to me, and I feed it to syzbot too, it is happy
with this patch, so:

Reported-and-tested-by: syzbot+151e3e714d34ae4ce7e8@syzkaller.appspotmail.com
Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
