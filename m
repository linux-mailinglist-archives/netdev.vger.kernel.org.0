Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123693C19F6
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 21:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbhGHTlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 15:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhGHTle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 15:41:34 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA28C061574;
        Thu,  8 Jul 2021 12:38:51 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ie21so4377637pjb.0;
        Thu, 08 Jul 2021 12:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HEnWv7IGu0HtSK3XxPSRHi3prPm/smZKLsp7ziczGIE=;
        b=UVPDHuxeP9EZ0wOBSxJk2IRxUBwEaymnZdwNwU25WiogOZqKOPe4+x6tfxb4EeNIFe
         8keTEz0IfET86FMc8kgadUdq0zWOh0GQa2HYA2C9TEIXJM6ShCNkWWoTqOU9SotU64AT
         3JR6ZwA+caJV2hdgtiyVk9OiMpmutNTVpXHYbqzc7359YEU0LQyulGwgiW+zxS4ar9nE
         HwT44rU7wRRSLI7vnfVFFnfDr9+1lcv1WPrAuaqserYiwrXTvelw+qBC6Xc6EN0VdhNq
         1isfUdPjNeCFKxqkWP1uEQAFMgfXxruSyBs6KryQbXAx51m1dZFcJjPPp5bP5SRW8VIc
         6X/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HEnWv7IGu0HtSK3XxPSRHi3prPm/smZKLsp7ziczGIE=;
        b=akyvo7ffPfzYeVizrnIgl3BoV3Gev4AvkcQBcJSG+Ld+aDVcsprFy4xE+pccBLL59R
         hZ6F41dsC2NMw+kmQBy7LZpK+LVecPyRH7tFSoeHQ7oIaH4DxtTljdbOjJU4MV/7z2Gv
         zmbi4VP5ccRjOd/7BhsDqDsz/WryuB33NKjR0BdLKb+4xnHKaF7OPt0QN/uaVDx6aVEW
         ITuegdlSnb13DkAyGjQlSxmSDe3RguwpfY3kEq8mMVY7v5XgpvMEhAngeYytJ1T8JJN5
         bUw5VCG8OTsSxQHlB5plsUompff5cjPW1EhtmB3eJ55uxecaRX+nty15ku71tpM7UoQv
         JBfw==
X-Gm-Message-State: AOAM531FjhEaMxX9LaPmWkCSVE0jAb2FSZXWk/YaZwldvAHdCcEWkqUf
        0DJMs0D78CH1aa0NZ9HwdGYpP/MddX0a0cQQ3sE=
X-Google-Smtp-Source: ABdhPJzD/ue07JAuFdrTSZLf90HnbyOJHZ0RO/RGSuLWTEZfXYOsrNhCj4pSpekVrA+Q3PGJchhGtGN4Qdo0raxIx34=
X-Received: by 2002:a17:902:e801:b029:129:478c:4b3c with SMTP id
 u1-20020a170902e801b0290129478c4b3cmr27562867plg.64.1625773131490; Thu, 08
 Jul 2021 12:38:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210706163150.112591-1-john.fastabend@gmail.com> <20210706163150.112591-2-john.fastabend@gmail.com>
In-Reply-To: <20210706163150.112591-2-john.fastabend@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 8 Jul 2021 12:38:40 -0700
Message-ID: <CAM_iQpWXDY=YeNS_Kn6eWZc-0MHF3Cr0fwFzGESYvtOJt0eD0A@mail.gmail.com>
Subject: Re: [PATCH bpf v3 1/2] bpf, sockmap: fix potential memory leak on
 unlikely error case
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 6, 2021 at 9:31 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> If skb_linearize is needed and fails we could leak a msg on the error
> handling. To fix ensure we kfree the msg block before returning error.
> Found during code review.

sk_psock_skb_ingress_self() also needs the same fix, right?
Other than this, it looks good to me.

Thanks.
