Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D71F53B44E
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 14:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389782AbfFJMAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 08:00:18 -0400
Received: from mail-ot1-f45.google.com ([209.85.210.45]:39987 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389255AbfFJMAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 08:00:17 -0400
Received: by mail-ot1-f45.google.com with SMTP id x24so8009269otp.7
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 05:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ugwSZK8IWm0ZxK3qV1Hh/3Z7Zq6uh6iqDFUEbHKId+8=;
        b=bmbjEqJfUnatH9POaD90xQqHoOWdJ5lRD6/wkYEPvbsUznvyh6gGxIqqli+2m9xkS2
         1KRpHmFcINtXEp9FYDzIWmz9ZE3s8GF/jpEzUevpjk1P66kr5DU2yNlycCydCv8+4XX0
         EpYyZrAgSFr11E37t6KzmTF9WbK+jn/xahuUOQQJxtl2/5R9UahS4o2WHhrXaMY1l8+o
         uLJEIbwpY7wZp3TV/w7h6weRaS7D1aDsq89m54m+d0EUVg5fBLbQN9fn7DIIELjerl4+
         12AgEFXO7bYFX/U5RnrzGcIhdh4/ulGrMzSoqbbiEJuQCLbMN8VdnbxpAKEUbxuBWJw4
         ofNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ugwSZK8IWm0ZxK3qV1Hh/3Z7Zq6uh6iqDFUEbHKId+8=;
        b=uQuCPDMy8ZEYBwwEZlrMeH0QNK1udUXIeCt0NVt8lNGP9v0Yw1YH01+xrRlt8a0lKU
         bDDS936IqBKxdKqsZoVLbTGCXowCQkorxKraOaEtmGh91QI48XuM11xQreHmpKAK4WSt
         kQZl6TVCS6A1U+u7H0DjHnLwnPqWL5Co31+hBXeAA3lCMTho2obiDvTvjE1qSz7KEsFV
         IgqkfvONZrfbaVUFjmscUwqcdoDitnZbIK9PlMeNXf1+yEM1+NZ9qnT6yfD++c/9YJc3
         8UFj0rmljthsupr7bvjsekHMtSxszT3rXuDnDb1o8Bj0yN2o6z0IXP4WBfg3Pb+LOT2u
         isWw==
X-Gm-Message-State: APjAAAVyKPgrMlKGx9EEzfy0Qtazjpwxpz2Q6K7Hr0hpEZLrvyaFc+bY
        fesISOGYf2/GwDAPwGrcYGLi1XTaSn+nr2vRxCTlLARM5ANe7g==
X-Google-Smtp-Source: APXvYqws8VmVkDJDmqvyLLnP/hqa0cq/mWfPols0M8JilBAv/RcgXZvdZXuP+SI3kG02Q7bFS03Zh20blVGsKHll4Ng=
X-Received: by 2002:a9d:7a8b:: with SMTP id l11mr26975473otn.247.1560168016517;
 Mon, 10 Jun 2019 05:00:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAHx7fy4nNq-iWVGF7CWuDi8W_BDRVLQg3QfS_R54eEO5bsXj3Q@mail.gmail.com>
In-Reply-To: <CAHx7fy4nNq-iWVGF7CWuDi8W_BDRVLQg3QfS_R54eEO5bsXj3Q@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 10 Jun 2019 08:00:00 -0400
Message-ID: <CADVnQymPcJJ-TnsNkZm-r+PrhxHjPLLLiDhf3GjeBjSTGJwbkw@mail.gmail.com>
Subject: Re: tp->copied_seq used before assignment in tcp_check_urg
To:     Zhongjie Wang <zwang048@ucr.edu>
Cc:     Netdev <netdev@vger.kernel.org>, Zhiyun Qian <zhiyunq@cs.ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 9, 2019 at 11:12 PM Zhongjie Wang <zwang048@ucr.edu> wrote:
...
> It compares tp->copied_seq with tcp->rcv_nxt.
> However, tp->copied_seq is only assigned to an appropriate sequence number when
> it copies data to user space. So here tp->copied_seq could be equal to 0,
> which is its initial value, if no data are copied yet.

I don't believe that's the case. As far as I can see, the
tp->copied_seq field is initialized to tp->rcv_nxt in the various
places where TCP connections are initialized:

  tp->copied_seq = tp->rcv_nxt;

> In this case, the condition becomes 0 != tp->rcv_nxt,
> and it renders this comparison ineffective.
>
> For example, if we send a SYN packet with initial sequence number 0xFF FF FF FF,
> and after receiving SYN/ACK response, then send a ACK packet with sequence
> number 0, it will bypass this if-then block.
>
> We are not sure how this would affect the TCP logic. Could you please confirm
> that tp->copied_seq should be assigned to a sequence number before its use?

Yes, the tp->copied_seq  ought to be assigned to a sequence number
before its use, and AFAICT it is. Can you identify a specific sequence
of code execution (and ideally construct a packetdrill script) where
tp->copied_seq is somehow read before it is initialized?

cheers,
neal
