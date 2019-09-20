Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B056BB88D0
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 03:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403915AbfITBFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 21:05:39 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33419 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389293AbfITBFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 21:05:38 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so3425384pfl.0
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 18:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HQDqVmbcAXZN+2Zdc9W+E5scvkeq1ZzF9slV6LakCOs=;
        b=Z0Xe1v6d4NALdvCSHd5wZJNcipg9Cs7akCpm/Go1OlRnqOko/rFmdXEqO2W+9F9JCD
         IIKnMHFIq5A3ZYBY+Yh/3iZH7f5os6SL19ZXJZ7Hl4V3+0RbOdADG3nPTfT2Oma0kbFa
         wrB9MHvNtu7DXmp50eVdRXVIyG0Ef7WZj3dkRntgPiWSaRHG+beiJE+ToTHTh4bLBZ7X
         BzLZ16tel4DoU7+T1WavMcdDjTF2wXWC4X+SAqUnqWWLusVOf59WyXhVnkDQTcR7BzdL
         puy/GutJpvIPxLm6MqvXFgHS5Iu6r4pen9p6l2MbecAQgWJq6CfakiOwfP/Rvv4VI077
         0KEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HQDqVmbcAXZN+2Zdc9W+E5scvkeq1ZzF9slV6LakCOs=;
        b=e0lCb/YEA3vXuqPGddHd5HwD/vH8KeH3G8/DwzMsOCd7Op/7ZUK9BL7Hwu+d+8mp+4
         UwwV88a+ZJax0aev51Uz414U7B0j7f5I6yhCtncB7vKTJUpqMPP34k6C+TvSWMZes6OS
         bGo3MVmrs3Tl/U7f1cZBMeziDJ+1GpKdRLiERSpESiFvY6FMBELisieJgHgQCoyG5C5Q
         7a11qNpMz0ijT3Quw7FnbUHxP/KYorC+JRuGkFtde+o7+X9942rlZ2hpP6jFWYw2bf09
         E4q8c4QZ9EKLqSNVJ4WYa7IZEDfThTagG6zBq7TCStqIlATUKEe/2yRF6V+QMQfvTpxe
         5aKQ==
X-Gm-Message-State: APjAAAUR/VvvPlcfeIAaoJgIAbeCSpmK/l7E8oBuRWrklGA5Y1EXjvG9
        cRGtYxkQCE+T/ysYGK1IjZKy8fAWrgVsRta7p10=
X-Google-Smtp-Source: APXvYqwsaAfBHvuV6/wbofiy+sFBmtOT6QZD0QdFYSbh4DTQpQEGay+JUho6A1pPp7uUt5PzYjOB5v4RiN9zvtLYEPI=
X-Received: by 2002:a65:404b:: with SMTP id h11mr12030375pgp.237.1568941537880;
 Thu, 19 Sep 2019 18:05:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190919201438.2383-1-vladbu@mellanox.com> <20190919201438.2383-2-vladbu@mellanox.com>
In-Reply-To: <20190919201438.2383-2-vladbu@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 19 Sep 2019 18:05:26 -0700
Message-ID: <CAM_iQpWREfLQX6VSqLw_xTm8WkNBZ8_adGWE5PpTnVQVDBWPvw@mail.gmail.com>
Subject: Re: [PATCH net v2 1/3] net: sched: sch_htb: don't call qdisc_put()
 while holding tree lock
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 1:14 PM Vlad Buslov <vladbu@mellanox.com> wrote:
> Notes:
>     Changes V1 -> V2:
>
>     - Extend sch API with new qdisc_put_empty() function that has same
>       implementation as regular qdisc_put() but skips parts that reset qdisc
>       and free all packet buffers from gso_skb and skb_bad_txq queues.

I don't understand why you need a new API here, as long as qdisc_reset()
gets called before releasing sch tree lock, the ->reset() inside qdisc_put(),
after releasing sch tree lock, should be a nop, right?
