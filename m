Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCFA210DCB9
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 06:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbfK3FsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 00:48:23 -0500
Received: from mail-pl1-f178.google.com ([209.85.214.178]:46727 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfK3FsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 00:48:22 -0500
Received: by mail-pl1-f178.google.com with SMTP id k20so9318348pll.13
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 21:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zY/1/ZU86sRmNUKzAWwFiVg85KHdA/P4wW8xNevbrDU=;
        b=K8ZQeCTwHyM6QfD3b9jIfislyjiYUY6S7UPKLT/4TAFB08z41AvvsdUWarLphTehjE
         D1TVXCrwdhon6GAs9OttsmHFxjvl/e3l2NCbN9WcR2b3FXcSX7obxjuqLjpj2+bsBMB9
         byD3cRsKJs9GEychaTdGYX9FLco7ePiisSRnjYNviRPRSA3aRVOsp1X1JkR13gK4PT9U
         FbdaW+SCDBYHqMhYeTs775+b1789D9spxabkvCYePgXCVwEIwwoQuaxNWa/6OZcumL7Z
         7C/iw98JJSBtk2i1BhsvVuM/wr9vzk8KILeYiFZOsnylo4ctCJlar3PDWLrD65l45s/m
         ldHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zY/1/ZU86sRmNUKzAWwFiVg85KHdA/P4wW8xNevbrDU=;
        b=BWPuX2SK+kDbqLhwrgXblzwNncWIbCYvGWCpFguuYzCRnaeB16LeDRYQzW+JbbRB85
         l/dJZT3n4Vn4wPW2Yr3luc0he2Ep9WOV7y+2oDDoPeZu9BEy8Vs3nKbOi5a+xZAXrAhW
         hg5AV3N0Bw9tBmolgn/ZHIjJb7wy7QA9iFdKPxVNL+qQrcJ8ScyBnos9mQw3nF2gy5kp
         Bw8XppgnreO9XlsmHXiT9pozTR3vxZIhLr+tUXFwk2uOxrdTwQTH5PLCLCupNpDw1InC
         qJdiuzV0yhVgnPY3TD7LT/kbL0f7QERLLUg3suQF0O+oHQD+1/cZwWGgl2iBKCaktf2e
         HcFQ==
X-Gm-Message-State: APjAAAWODv754eduYiEB0H6b5XB0tnGL3Yt8At+grh1u67hrnVjDilhs
        8QrsDiYBgTZlLxBYaUu6Hm1odh8ufU76kuOPaFo=
X-Google-Smtp-Source: APXvYqwl+DOOJYqZb11oMFmf8yIKXM9oEwzC0zvLRIj8YH8+avjgF2fPyJ2PylkgVydAfxh1PEKMrfwraHexgr4Nyrw=
X-Received: by 2002:a17:90a:850c:: with SMTP id l12mr23483952pjn.16.1575092902287;
 Fri, 29 Nov 2019 21:48:22 -0800 (PST)
MIME-Version: 1.0
References: <20191128063107.91297-1-dust.li@linux.alibaba.com>
In-Reply-To: <20191128063107.91297-1-dust.li@linux.alibaba.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 29 Nov 2019 21:48:11 -0800
Message-ID: <CAM_iQpUt44esBeuDw6HJepP+KjJbCk8uYV1ofuZXfeRe52cGYA@mail.gmail.com>
Subject: Re: [PATCH] net: sched: fix wrong class stats dumping in sch_mqprio
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 10:31 PM Dust Li <dust.li@linux.alibaba.com> wrote:
>
> Actually, the stack variables bstats and qstats in
> mqprio_dump_class_stats() are not really used. As a result,
> 'tc -s class show' for the mqprio class always return 0 for
> both bstats and qstats. Use them to store the child qdisc's
> stats and add them up as the stats for the mqprio class.

This patch is on top of the previous one you sent, so please group
and number them as "Patch X/N", otherwise it is confusing.

Thanks.
