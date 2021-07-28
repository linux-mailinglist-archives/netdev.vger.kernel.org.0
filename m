Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0D03D8600
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 05:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbhG1DHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 23:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbhG1DG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 23:06:58 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F92EC061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 20:06:57 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id f13so1007033plj.2
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 20:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pejIH5+7yKrAyTqV4XSNocnONr/PoCDhuZqzyMXTrGQ=;
        b=a/FYXZG7THmkwc9n/hIY8ngHLGZJhVNxUCuiqQfnGHxzN/5eTRYfbO5r+uSdsul9oF
         hxO1f4Lf7+VQvYPDNDYzbe+TvW1GG0Cdq1GUIJRZj5w59LD0Rvv6FVG02qKXp30kwbtp
         qbGlZ0P0c0FyoQWbAa1y2jHM6aiwez9OcNCBN7UMEDOH7XWSQG4OIPdG5CsaRlPDxzSh
         FV515tjhu9WCh1+T1Ni0vaQelvUnz/xHClwm9lYclBq9dDEdmiTdDJvOMdRN/XFoMreb
         eHXGDC38kCfNW+oHftAdjks0DDdzmvGIpOJKNRDUULvKCM9EU05WdEuYhLgAx+GW6XvM
         3TvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pejIH5+7yKrAyTqV4XSNocnONr/PoCDhuZqzyMXTrGQ=;
        b=FB9oRFi9bwx+QK9yHq8jLMWaQddWfypP4fUPIpIltH6r4/rTVS3SokiuU+dJwVLONf
         Y86OI4TM9GFptWFlrGYTkmt4aK36uJ+OpGNT1ENekuZHmTANGkYgxdP7tbpg2wPe8ziR
         pakpiRLTe0vY9eTCxQ4d9AZ0qO2uh+TkVPRgcpUIABTguwwOS4byaX7teolvjTOkpNMS
         iVwblxB6DpnDujlMmsHtcof9L19ZK052WPjhByDfr3xirpJPozLIRPq4yTv/IyCV6vVd
         316CUlA/xUpIVlQRKTyWVsB4ZfZ5qWHksRaXbP+kJT+tOhskolce++9FgxUDAr78jngR
         qU6g==
X-Gm-Message-State: AOAM530bYITZfFqGLVQOISu1Uu4L6trmilq2D5XluGYJGxOCXqiq2yDI
        HIGBA2RirB3VjATb2QktqQ0Unnkb84J6nN+7NnE=
X-Google-Smtp-Source: ABdhPJzdS7MaWAZCC3ggxLAgis7WQFc+mgr4oBH6vEbdH1n5H3b1pHBBrVipsLDJy7f5aE7YavUE+wdT6TRjFeyzakA=
X-Received: by 2002:a17:902:728c:b029:12c:5423:54d8 with SMTP id
 d12-20020a170902728cb029012c542354d8mr2900564pll.70.1627441616993; Tue, 27
 Jul 2021 20:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210723183630.5088-1-xiyou.wangcong@gmail.com> <610030612aaa3_199a412083d@john-XPS-13-9370.notmuch>
In-Reply-To: <610030612aaa3_199a412083d@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 27 Jul 2021 20:06:45 -0700
Message-ID: <CAM_iQpWGyJcx2o=HUWoyB+E-7Z1y9LEwb362TTLGxrwuz9yULg@mail.gmail.com>
Subject: Re: [Patch bpf-next] unix_bpf: fix a potential deadlock in unix_dgram_bpf_recvmsg()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 9:12 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Is there a reason to grab the mutex_lock(u->iolock) above the
> skb_queue_emptyaand sk_psock_queue_empty checks?
>
> Could it be move here just above the msg_bytes_ready label?

The check of the receive queue is more accurate with lock.

Thanks.
