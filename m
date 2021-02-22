Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE763321523
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 12:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhBVLaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 06:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbhBVL37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 06:29:59 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21741C06174A
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 03:29:19 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id p186so12566950ybg.2
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 03:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yDxxfIg/F5OBS0MpHwZd47tXmW9i50SkZAqlA6Fd1os=;
        b=q7Y11+MrUR0LEYt+Qjw/Z1FR6Es9dxMM+qfvyTas8aq4tFjA3B5kpduXTG4ZDG6P8k
         8azQ1+Kqasm1zOgrip5xC4GQ1JLe9t1BQumFHIrwApjxs2i3x6gfmXjJRTMxm0tyQHIL
         8kmybeJSZMqHiRQvtsu9wS1qawrlXQhBLqPBbYQG1gx1ThfL44bauaKvM4I2JxMkfpw4
         BdsSPAlCViTVkTDT12ptGozF4/JSwECBvRfDqNAXWj+clQwGAONBO8t7dRYjQvLrRe0p
         iVDjL69MujG7JyXXIx1A/iThz9AiS0Lc8DvVmStxzSOu20PefNya6yE66HvPmq9+87c8
         A7Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yDxxfIg/F5OBS0MpHwZd47tXmW9i50SkZAqlA6Fd1os=;
        b=e2+Qziytb/OcA0rIUiwnoTlzlzqrHlL+w0ZuMaUSixKs8efkQVyyNDTTbwnsFrGnyN
         AzNdznKlXd+SjPppKygimlnyeNwzHGrPhDAXhGQf77vHh4FcwVbxVQcuHBqrLA8LKZuE
         vFFRAU1FnzIOGQjpfN+Y2TGDCVYufXEi/w9I/91VEFts6wl3IWBkYSIQMCdt7p3vOJuX
         lkpgsdktXy3WM+qiYPrBtXJH0yXqOr3s7Es3RJFH1aLWQ7TE2OlbhSlrQ/7XnP9Exx1I
         02RSG0o1ffUBrqq/8OlmRfbo6+5lCdeh8MqZ4RbYy13PZNTm7cXnC1mGfDLWLf/vDpJZ
         rVfg==
X-Gm-Message-State: AOAM531V9/srgw6ZuiIF5z4O2ux3tqGhmT+DzeKEkKG/3rY7bLMvE7lC
        uRMDmYFUfUWe1MeS+s7TpvMj/2nqjKOxeWhCvBsdrGLrzRZyzw==
X-Google-Smtp-Source: ABdhPJx5tj3aqEvsy2hrwtWiEDsyq3mbsL8ivZjIgsAsx22EQ7pZ1LpEJO12tPdC3XVlp++n80RkkEAxDlPeLR+uqdU=
X-Received: by 2002:a25:fc3:: with SMTP id 186mr32309747ybp.452.1613993358045;
 Mon, 22 Feb 2021 03:29:18 -0800 (PST)
MIME-Version: 1.0
References: <20210220110356.84399-1-redsky110@gmail.com> <CANn89iKw_GCU6QeDHx31zcjFzqhzjaR2KrSNRON=KbohswHhmg@mail.gmail.com>
 <CA+kCZ7-AeEHrOo18DMzF1zOGC=b-GrP3XFj5QhPeOoM3U0j6Ow@mail.gmail.com>
In-Reply-To: <CA+kCZ7-AeEHrOo18DMzF1zOGC=b-GrP3XFj5QhPeOoM3U0j6Ow@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 22 Feb 2021 12:29:06 +0100
Message-ID: <CANn89i+mkQ31=dV+VcJNg-ChJrBOSC41L9+RqdO3Tkf_NtwSgA@mail.gmail.com>
Subject: Re: [PATCH] tcp: avoid unnecessary loop if even ports are used up
To:     Honglei Wang <redsky110@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 12:10 PM Honglei Wang <redsky110@gmail.com> wrote:

> Really? I just came to the latest 5.11 including Linus' tree and
> net-next, seems it's still here at line
> 725 of inet_hashtables.c.. Do I miss something?

5.11 is old already.  inet_hashtables.c has been changed for upcoming 5.12

You always must look at current trees before submitting a patch.

Read Documentation/networking/netdev-FAQ.rst for additional hints.
