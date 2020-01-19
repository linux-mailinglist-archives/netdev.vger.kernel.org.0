Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6AE141CDF
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 08:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgASHmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 02:42:47 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38965 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgASHmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 02:42:47 -0500
Received: by mail-wm1-f65.google.com with SMTP id 20so11555137wmj.4
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 23:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+E2Ol2PMuGFvjvPgU+sj5hYUgO5mOOF5GaJZebgsDRY=;
        b=BMjQIry9xXWE+Edht9YG5WIzGtJRwA/UCjfGC9drQyRCYqifP33ZKG3v/63lOounoP
         tTEvpLIx/CmkCARN6NSDV7lDcht9wg6a3K7pLVKVm6YIorH7rMP/gaZ3QFWn5ljyDlIW
         wLg+RDNK7Y3yasaQlnkaf/QnvZVjdvGPEGaBYri5OhljOgg7xQEC6zkTCGpwRmwGh61g
         l705D50J8kyhXb1oREHLrxSWTuCQDlFf+khrhUSG0SqVwhHfzkp8tSZaxlZdw4eE37Cl
         2Ftn065W7vnErUkVnEYEF1hMtdZAThkUvD2BzDLhxNrIFfnse6x6+wgcinWvRdha8edh
         sG4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+E2Ol2PMuGFvjvPgU+sj5hYUgO5mOOF5GaJZebgsDRY=;
        b=t0UrBgPrcKEzjP+ZSm5VIQkGQUAFebaFp3jvdRUMfd4vK1emobulg+CMIrbHIsTAHa
         xlo46kv+XRlxVLo7c3cVbsO3daaPVQ7r4OYtvkijzYNVS6v+yN+rXW/i0GqJQ/sI2WX/
         4/7vMAjhegI372BVrH1X4lce+sCQm1ajCDtwqevHtq52iOBKvn4OmE6VLahcl2Y+nWnH
         eB0GT1363uke8CjK07/ZKRvnGrRv0K7N7Rkgbr09oYGWo6AZoZQWdmYmgJvG8sefBKjS
         B88Q07RNsS4iZWUqq5STvCn/YEXqx8zXXRpfuwy1E45miQo/9hNO79oZzI/e3Kemt/RP
         eodA==
X-Gm-Message-State: APjAAAUg2gPUKvand2SeH/kEzBAXbXWBvvRf8y+64RXBobLCzsYkyHEH
        Tp2LkYwVD11bDJ2iO2niyedwghb2Mwrr6cAPXJU=
X-Google-Smtp-Source: APXvYqzy6Ftrc96m/1nAe6qW0fmoQaEb0p9a/6uwhqGYT9S0VYNonnbnvtDOeknJPc7PyjH7zpXI2WQIyDKPhxvXVJA=
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr13671258wmk.50.1579419765297;
 Sat, 18 Jan 2020 23:42:45 -0800 (PST)
MIME-Version: 1.0
References: <20200116155701.6636-1-lesliemonis@gmail.com> <263a272f-770e-6757-916b-49f1036a8954@gmail.com>
In-Reply-To: <263a272f-770e-6757-916b-49f1036a8954@gmail.com>
From:   Leslie Monis <lesliemonis@gmail.com>
Date:   Sun, 19 Jan 2020 13:12:09 +0530
Message-ID: <CAHv+uoEYa=xNQDLz+-fxnSReSLYX8-ELY8wi4u9Gaa8Qm3h=4w@mail.gmail.com>
Subject: Re: [PATCH] tc: parse attributes with NLA_F_NESTED flag
To:     David Ahern <dsahern@gmail.com>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 19, 2020 at 3:31 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/16/20 8:57 AM, Leslie Monis wrote:
>
> > diff --git a/tc/tc_class.c b/tc/tc_class.c
> > index c7e3cfdf..39bea971 100644
> > --- a/tc/tc_class.c
> > +++ b/tc/tc_class.c
> > @@ -246,8 +246,8 @@ static void graph_cls_show(FILE *fp, char *buf, struct hlist_head *root_list,
> >                        "+---(%s)", cls_id_str);
> >               strcat(buf, str);
> >
> > -             parse_rtattr(tb, TCA_MAX, (struct rtattr *)cls->data,
> > -                             cls->data_len);
> > +             parse_rtattr_flags(tb, TCA_MAX, (struct rtattr *)cls->data,
> > +                                cls->data_len, NLA_F_NESTED);
>
> Petr recently sent a patch to update parse_rtattr_nested to add the
> NESTED flag. Can you update this patch to use parse_rtattr_nested?

Yes, will do.
