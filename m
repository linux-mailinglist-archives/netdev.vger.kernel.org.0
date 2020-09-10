Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E848B264FE5
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgIJTy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgIJTwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:52:36 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222B1C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:42:56 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id q13so4064830vsj.13
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F9eieMJ6CYMZIOjB9Bds9/3wXmz4aaPN2w6eu5GswXQ=;
        b=kruuQBGPSRPh+b/5q5tRU4knpsVqkVL5bXLpQNuh9joi/pJVMfYcRxt+KJWD3fPnm9
         9Zeurqi1pX7eFF30X+gTAKit3DWxEZHDWLAKKJMVfbNi3dh1FreyWc5vros24c/UmMdf
         4MvEJT9UyJIRFPpOY2vZANgpsSID+yr73ijJK8pm4+ZtzdztFVf/bo5fmWgGvfBvyCnl
         qZAW0DPD0wxByOtCs72kSi6OazejV/BcKfS4EFRwxofqVxJmtE0mGBG3soOWIfMjXRwa
         EZeimhCvlI0VdgbDUWomITkEE4b3m/5nJ04dfTq12lcvSW3k+hqy6TwNqlNm6Wh7R3ZU
         Yp6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F9eieMJ6CYMZIOjB9Bds9/3wXmz4aaPN2w6eu5GswXQ=;
        b=dMRaiIqbGI2DZ16FXsSTZw4+aCPZRwhhlf+mOvUGq3Yb8wa2Za6Iqv6rlSoBuW9H1V
         Gfjy+R7XkmYe1uHs1OhqRMSDVpm76GOOi0r5Vuv1xoH4w2be0pyRua4ITlF0Hstubjgu
         aQFHehtpfRfDkocCSbfgAbaYQVtfZu0h3/jNpLkleHo1nhuGZMRymaRf9N078hD4BzIF
         KZ9tYOFh/gPINY/mpTiWPVhe8MeXQK/lbjFCcPo1V9/YBOBtqO8TbnvGp426Fzef3opg
         Ma2kbv4zdn8zCbTTHgdaWYYzA4ZG9MDr81MIuodnuWyH8xD12JNcJIBvz9qaFmvN47tq
         Epyw==
X-Gm-Message-State: AOAM533N9cFa+ZoRlMAM3zubV0OmheD3W3Rd7qKeqK7a1+Q6elBx7vfj
        PyWmXZg4WHeBm57NESWJbqIODoqu8BXI4ExrpaMoDw==
X-Google-Smtp-Source: ABdhPJwdfyjqBOkyi9B5wbHI6OYKnATOjW81IGhW8OiGCxJ9PavXuUc83kwv1aQRapF+Am9YB/lAf7/6YivCZdHfdD0=
X-Received: by 2002:a67:f307:: with SMTP id p7mr5285645vsf.9.1599766975054;
 Thu, 10 Sep 2020 12:42:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200910192053.2884884-1-ncardwell.kernel@gmail.com> <20200910192053.2884884-2-ncardwell.kernel@gmail.com>
In-Reply-To: <20200910192053.2884884-2-ncardwell.kernel@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 10 Sep 2020 15:42:38 -0400
Message-ID: <CADVnQynbGjWFoVxrqMOP7mGz_2suvpFe=+qfaoeK9Myaq=bC2A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/5] tcp: only init congestion control if not
 initialized already
To:     Neal Cardwell <ncardwell.kernel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 3:20 PM Neal Cardwell
<ncardwell.kernel@gmail.com> wrote:
>
> From: Neal Cardwell <ncardwell@google.com>
>
> Change tcp_init_transfer() to only initialize congestion control if it
> has not been initialized already.

Please ignore this v2 patch series.

My e-mails from ncardwell@google.com stopped being accepted at
netdev@vger.kernel.org mid-way through processing  the v2 patch series
(between patches 2 and 3), confusing patchwork about which patches
belonged to the v2 patch series. I tried resending the remaining
patches from gmail.com, but this confused patchwork about what patches
belonged to which series.

I have resubmitted the v2 patch series as patch series v3 entirely
sent from @gmail.com.

Here is v3; please use this one:
  https://patchwork.ozlabs.org/project/netdev/list/?series=200962

thanks!
neal
