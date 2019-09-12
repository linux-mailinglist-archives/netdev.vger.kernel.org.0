Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB556B064B
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 02:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbfILAuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 20:50:14 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:35745 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728635AbfILAuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 20:50:14 -0400
Received: by mail-ot1-f66.google.com with SMTP id t6so11198453otp.2
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 17:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jBuwKfPWS97eqadXQTiWuQEBpm2jfqWFYrr+X2k1sgg=;
        b=WH60mGYObp8VaoD1CSfrn5CpE2t8TCA/Pi4FB06QRUtopb/hzHLchaIa0hC4dlmNXQ
         smoX3sGkAioGtYcrabQkMGGZ1AwO/HTB0RzkhoTQ7rqiQM27Wka9bE7zGzca+EvACNkB
         H04KxbtCZE8/TZEL/5ovYm5eLBmphZEzw8yJmrz6V/xorSuKvzWWT5HwSQXHEl+H03i2
         I4W5U35xBE08EgtSjKvCiGwslDVCSWxJbVbcAXFtBmVf0ooSrm3FN88soSkl2eOecHQf
         ccy7v50fM8Bcc+aClAOmuKYf42r39VUE2qhJ7W902IHT4aI8lRlkhvgQq8bpoY5O+a1/
         rwzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jBuwKfPWS97eqadXQTiWuQEBpm2jfqWFYrr+X2k1sgg=;
        b=KQj1o8LTiQUN+R6MwSjJvvIvC0AsIdb3MHYmPRyGboRTs45gK5BUZqOZGg4vk1XagH
         iYDt1xQSIB/FQ+F82eIE0BgwtO8dChSNwFzvbDVadA4hryVnb9L1oObalvWZwz0s4TpO
         oC6RvatT1RoqYEP9Th58mXxDi8uSSu7cRNZ+NkUie6d//YvEGahmyT+heV9owthwQhLw
         V7Bx3GpVSKYSvuA0A2+oq4k0OUkGZUc/rA86/1hsPPtgJ7b7O1+WUtRBgeOlsNtZahSw
         eLz5qcyIDpEXT8aJ26I6iJnHHwir4v2+RPjC7SqZveky8Jp9bvC84aNkV0evpSSxc3Ch
         d/hQ==
X-Gm-Message-State: APjAAAWH51YRMjnP4HbRFqsKtneFon+fM0/YOmLXxJn/+ysTTvYlJQQA
        +a1F5y6413iTU9qET/xvyr6goiSbDQjYs1V9IUFN6A==
X-Google-Smtp-Source: APXvYqxlRhuAbI6Nbd3c9yrHfE2WdPDhpeNiNSJ71L5Pk6eF4zSujOAZPvJWfKBKvtlDQWeMi8XNLM+dK5pMxDVdHuE=
X-Received: by 2002:a9d:6190:: with SMTP id g16mr10749060otk.302.1568249412961;
 Wed, 11 Sep 2019 17:50:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190911223148.89808-1-tph@fb.com> <20190911223148.89808-2-tph@fb.com>
In-Reply-To: <20190911223148.89808-2-tph@fb.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 11 Sep 2019 20:49:56 -0400
Message-ID: <CADVnQynNiTEAmA-++JL7kMeht+dzfh2b==R_UJnEdnX3W=3k8g@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] tcp: Add rcv_wnd to TCP_INFO
To:     Thomas Higdon <tph@fb.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 6:32 PM Thomas Higdon <tph@fb.com> wrote:
>
> Neal Cardwell mentioned that rcv_wnd would be useful for helping
> diagnose whether a flow is receive-window-limited at a given instant.
>
> This serves the purpose of adding an additional __u32 to avoid the
> would-be hole caused by the addition of the tcpi_rcvi_ooopack field.
>
> Signed-off-by: Thomas Higdon <tph@fb.com>
> ---

Thanks, Thomas.

I know that when I mentioned this before I mentioned the idea of both
tp->snd_wnd (send-side receive window) and tp->rcv_wnd (receive-side
receive window) in tcp_info, and did not express a preference between
the two. Now that we are faced with a decision between the two,
personally I think it would be a little more useful to start with
tp->snd_wnd. :-)

Two main reasons:

(1) Usually when we're diagnosing TCP performance problems, we do so
from the sender, since the sender makes most of the
performance-critical decisions (cwnd, pacing, TSO size, TSQ, etc).
From the sender-side the thing that would be most useful is to see
tp->snd_wnd, the receive window that the receiver has advertised to
the sender.

(2) From the receiver side, "ss" can already show a fair amount of
info about receive-side buffer/window limits, like:
info->tcpi_rcv_ssthresh, info->tcpi_rcv_space,
skmeminfo[SK_MEMINFO_RMEM_ALLOC], skmeminfo[SK_MEMINFO_RCVBUF]. Often
the rwin can be approximated by combining those.

Hopefully Eric, Yuchung, and Soheil can weigh in on the question of
snd_wnd vs rcv_wnd. Or we can perhaps think of another field, and add
the tcpi_rcvi_ooopack, snd_wnd, rcv_wnd, and that final field, all
together.

thanks,
neal
