Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B61257338
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 06:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgHaE6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 00:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgHaE6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 00:58:17 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526CFC061573
        for <netdev@vger.kernel.org>; Sun, 30 Aug 2020 21:58:17 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id d20so2299265qka.5
        for <netdev@vger.kernel.org>; Sun, 30 Aug 2020 21:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=raGEY0z/wUD8YTB/6zbPBNpqxdjR7ahxKQxZZ1qoUCc=;
        b=XrfIrMCGlwUo7hp0AyzGWeHjSCcAQsR6xS4nX0VBSl9LKvLFAQ1B5OJ4OKT7VjvMTL
         p6lqNwOxgQV1tjcNJ8iynMhpqakzyv8Sa+hC3QRzw/Mr165b2u6EJI5gPUuopQnNM9cD
         4UFBlK8HI0fBSjwaO/kTWnSEqteNYW3QOsDNk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=raGEY0z/wUD8YTB/6zbPBNpqxdjR7ahxKQxZZ1qoUCc=;
        b=G+5l0eAKUcc0KbPXQC9rtFJ9kSpTsiXnrWSLpW42SjwoN12irf1XUYX8dtQcP9KOqF
         qDecEa+8peWf8u7TwL1XNDTWF96Ry+xOEfqN7qDH5aLzTGsize8nHQeI6+Jx6zJWXAQe
         7PErCTvMonsnJ+xEu4mGvGsz5MJig/oMaPchoBmtGTMTluI0oB33LMfDciIeWpCf7P+9
         /E4PlAHEVWkfIndpUvNlczjjv+43oGuuaOE/8yprDCWb4rR/ocP6yQvfZW4UeHUgIGHh
         WGRGL5kinBJvv7YhELvCE2lBIFFCVnAL9iTt9YtH9aVrNYbKNfoaLiw9WymkBl6bXDjE
         Lsqw==
X-Gm-Message-State: AOAM5334FYWeiv/GBcDRtdUxzgOcs9cKRUbJy1QUnAu4mavn1gR7dCIC
        ++Uglq4KRa+io8+B2VGIQ/095Jjq9tbZjLFq3TXTig==
X-Google-Smtp-Source: ABdhPJzeUb6i8GDgDgLz56XIP5StBmsjFvDuNsNvCsWTeGbZ56OB/3eUKZRL80becaNx89AX737hgqjA7xQjJDNCEo4=
X-Received: by 2002:a37:bcc:: with SMTP id 195mr9140026qkl.287.1598849896387;
 Sun, 30 Aug 2020 21:58:16 -0700 (PDT)
MIME-Version: 1.0
References: <CABb8VeGOUfXOjVcoHkMZhwOoafLH5L-cY_yvrYz1a+zMQPwLsg@mail.gmail.com>
In-Reply-To: <CABb8VeGOUfXOjVcoHkMZhwOoafLH5L-cY_yvrYz1a+zMQPwLsg@mail.gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Sun, 30 Aug 2020 21:58:04 -0700
Message-ID: <CACKFLin0kKuckRf2b7CmoAM3UyzOQZo7fRUg0-9jT5p_LLAhTA@mail.gmail.com>
Subject: Re: rtnl_lock deadlock with tg3 driver
To:     Baptiste Covolato <baptiste@arista.com>
Cc:     David Christensen <drc@linux.vnet.ibm.com>,
        Michael Chan <mchan@broadcom.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Netdev <netdev@vger.kernel.org>, Daniel Stodden <dns@arista.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 28, 2020 at 5:40 PM Baptiste Covolato <baptiste@arista.com> wrote:
>
> Hi David, Michael,
>
> I am contacting you because I'm experiencing an issue that seems to be
> awfully close to what David attempted to fix related to the tg3 driver
> infinite sleep while holding rtnl_lock
> (https://lkml.org/lkml/2020/6/15/1122).

David's remaining issue was tg3_reset_task() returning failure due to
some hardware error.  This would leave the driver in a limbo state
with netif_running() still true, but NAPI not enabled.  This can
easily lead to a soft lockup with rtnl held when it tries to disable
NAPI again.

I think the proper fix is to close the device when tg3_reset_task()
fails to bring it to a consistent state.  I haven't heard back from
David in a while, so I will propose a patch to do this in the next
day.

Let's see if this patch will also work for you.  Thanks.
