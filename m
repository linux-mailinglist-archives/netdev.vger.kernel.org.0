Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F100338287
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhCLAp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhCLApQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 19:45:16 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4BDC061574;
        Thu, 11 Mar 2021 16:45:16 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id n9so13795496pgi.7;
        Thu, 11 Mar 2021 16:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0VniSqsA256OUrkx3vcukcQM7jVhEtt/XxMhMo4uMl0=;
        b=RmR4Bkn/IqjMTtbVn4ObCQigj380uoZ4GxTrebSbHhm9bT2hgdd95ZkDV3Geakr+RP
         bIdNBkzshOF/xaU1VlUY1Rc72T8wuN1dXqtPAVopAvkT7gR5LcvwNLbVoHIB+vm4auUl
         Axy4sHmxDO39YYR1pqdRtKoSMUR1GSLG01fXerbIVys6Es7LlIJREMMGTwN9tYcAKLZ3
         uhXBAu5hzuM5AAlpECpRNB3xDtJHn9ougWHaUNDcogrc81frEoKB+YBnvMyN5bJADNSp
         thFzNuDpVudMpLcZVfrjvHoDmsn2GwZWdquCsABqhMPTF9IHpWbTeN/rSoLTTzjJWeJn
         CYjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0VniSqsA256OUrkx3vcukcQM7jVhEtt/XxMhMo4uMl0=;
        b=DXj/jYz6qbnIkMj+0djU5qxjE7bGN3SGUOuVptjlwipBxaoNsy04kCxltHnBLZQ5wQ
         1u8qYtODpyJw7YRI7GYWdXEWUF8h0x3JP9c6pX0jSlVWzTa3yGD3HrasX5+7DxmMvaka
         SRRti8Y6Exh0t76eSgpgZCOlWnKys3lIib65s2+t99J5UWDq+ub7mXfbHhxmHwat5pAy
         w71/FnozIkFbILFwbT05oJHW+UnpyE0QEdHZOyIhoxO3j2ts+sClzJAkUl4Gr1K+gauW
         PNUQOgTt84jXXX8AuS8cRF7l4MqxEEkKY6GXwpqqrYA85qHj2NsPVn/pl5d3fRTXURJP
         TMcw==
X-Gm-Message-State: AOAM533cBSRqP9l0OJy2l21TSIeNVT7YEK7YJFgmZ3Dk5IkNTxuuwT5Q
        vfPJ/YuOgKx4WtxJEVEClo0JOtIstO13Grkg8/k=
X-Google-Smtp-Source: ABdhPJx4N2DdN0UaTnIMhQKrgyzCZ7iWwQWudBHHvzzG4Qlpg3rcc0qWHXO+zFDOiUXNvLvraZpAx6w14T7yE0N7+kI=
X-Received: by 2002:a63:e109:: with SMTP id z9mr9329224pgh.5.1615509916055;
 Thu, 11 Mar 2021 16:45:16 -0800 (PST)
MIME-Version: 1.0
References: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
 <20210310053222.41371-3-xiyou.wangcong@gmail.com> <871rcm3p6m.fsf@cloudflare.com>
In-Reply-To: <871rcm3p6m.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 11 Mar 2021 16:45:05 -0800
Message-ID: <CAM_iQpUcZxsL7cKoSGFbHtei+ad6j2xWyJzviOoOcGH6jGxisw@mail.gmail.com>
Subject: Re: [Patch bpf-next v4 02/11] skmsg: introduce a spinlock to protect ingress_msg
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 3:28 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> > +
> > +static inline struct sk_msg *sk_psock_deque_msg(struct sk_psock *psock)
>
> Should be sk_psock_deque*ue*_msg()?

Right, it is better and less confusing to use "dequeue".

Thanks.
