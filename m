Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B906F11D095
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 16:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbfLLPLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 10:11:32 -0500
Received: from mail-ot1-f50.google.com ([209.85.210.50]:39034 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbfLLPLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 10:11:32 -0500
Received: by mail-ot1-f50.google.com with SMTP id 77so2316582oty.6
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 07:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kIhIS2YRgmUMObqWxEWVGA4aACRsODuzv8jQKXYM0Rg=;
        b=KLHrpDMbmnM81Q4xUZEG5d3l2uH6WXOvotUm+GFFDLPgzTXjQcGWpSLwq/gBKO1nxC
         z050ENWHsjL9MnzFu+svtP7MvZI1D0Hnxzagle755XHKlgdAIc3Z/nC8SL0M7m9dU9AW
         BOgrfbmIWScHGcA88UbThBiFxJJLMKUYUbNGcEt9C8HTwOVM62sYL4fkzg98Pyr9JwBM
         RPdDhVzu5STJxJOBr1TDvEoPgFRxdhTFo43PEL57Vv6hp4Ps3fh87Kt+/UnyFkClbnWL
         Eincvd+SSSUiDRdk1peT+d4JFk8HyrcqAhOHKmP0BBl99JRFfsS0ZXO0YUWsR9r8/X0q
         Xc8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kIhIS2YRgmUMObqWxEWVGA4aACRsODuzv8jQKXYM0Rg=;
        b=cqKhE7nY/4RDXYEAAtRopHmz4KWVxTbGJfKUpIraL/x2KTIMxmHudpZHzENxFfvmDO
         YfEgqFHrMkbQ4qpOLnKx0nSJ/8UrptLGObV77p9e2ZqkHqLpkFPJNjCo6drETkpSn2Ta
         oeas1NAvB6EksIzWeFwR8MifcbudHeRX3jE0TjAvBF2+cVhHqNujBTSbLUC/XIg+x7zj
         DBnyd5gPVfcWEgbbyrf3Vh2exYjun+jFn4L3CuV9tOBRUO5szYRdioT7v57JUp//oW2N
         rY3idSdbeuIqtXdTejZuFdAdSjG/pB6VcXn3MlaNQ9kktL8shy2Rh+EVF4gK0W1eOKtz
         7RjQ==
X-Gm-Message-State: APjAAAXYDLrK/KQiu00otS9SMiYO7ksuw2uY+sZlFFR8alKUtfPpPKaH
        PELuO7tZ/bWIC26xfT7MpxNsbaulbTqDAXFNBaljsQ==
X-Google-Smtp-Source: APXvYqxy+6Sljwk7iFfOaKx/1+V4f5mtJq5yy/t6TSwXFxYoJS86rUxJqzrstDSC4Q6jeoGnMBriYVzN5yyFeM0koTU=
X-Received: by 2002:a9d:624e:: with SMTP id i14mr8755970otk.371.1576163491195;
 Thu, 12 Dec 2019 07:11:31 -0800 (PST)
MIME-Version: 1.0
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
In-Reply-To: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 12 Dec 2019 10:11:14 -0500
Message-ID: <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com>
Subject: Re: debugging TCP stalls on high-speed wifi
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 9:50 AM Johannes Berg <johannes@sipsolutions.net> wrote:
> If you have any thoughts on this, I'd appreciate it.

Thanks for the detailed report!

I was curious:

o What's the sender's qdisc configuration?

o Would you be able to log periodic dumps (e.g. every 50ms or 100ms)
of the test connection using a recent "ss" binary and "ss -tinm", to
hopefully get a sense of buffer parameters, and whether the flow in
these cases is being cwnd-limited, pacing-limited,
send-buffer-limited, or receive-window-limited?

o Would you be able to share a headers-only tcpdump pcap trace?

thanks,
neal
