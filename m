Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EDD396EAF
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbhFAITY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 04:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbhFAITX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 04:19:23 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175A2C061574
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 01:17:41 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id v9so14328555ion.11
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 01:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=YbAy7u1ieBaLf63PO/2LkCEz5Re1c9EXeyaJCJMYNCA=;
        b=YWkZynTeCPqDYJYZgVz4HM08IaGdNqq4WUczzmdoPfru4CCnJJvpDW9s6DfUsG26Rr
         1sFVB4Kg6RVnZJ/8Zqm4obSutZXLY0V8cUrrbXuvoaKlRuJA8XqiW+gEgS9LdDvNAZ5/
         +SL4+gD9Nziw86uVr76PXhXguXuSY+FmWREtigB67mPDyQ8NG6qIP9ftKdgSOByi0egB
         my+QKB2C+6+IsxRKVNZhivnGa6Z9N2wwDWRwv7AXnE+gAnpit8mqP/1c+jGw97NNHybH
         vBe+58FwrH2BhQcvHW0FFEVHJjncGOJ4WLiPS+eFcRF2D8iiJwbtwG9P7ZN4YsOmLr1p
         tGHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=YbAy7u1ieBaLf63PO/2LkCEz5Re1c9EXeyaJCJMYNCA=;
        b=hPtVCtnVnYY0e45wcBnNcB3mopkEOSkoOV8DuNLLs5QtmFiRX1IdDS1XC7vHb6V8Pw
         ceHkFyS54KHZpnDBPpQHzDzb9JT9P2NOs9o6JCVv5L5Ew7m8g2kpjaQ/Ox/aSwhRpOAI
         vT6ws3Xi2meMJSYS7KjBZKKR4CzHtXeNmI8PJ1gnPJIZLDpf6cdphxeRIxnDnjYZOSRG
         UF+knxXA6SkxYsBFOC+Lvv+e7PZtHFcVAiVzZJjkWq52L1YIZwJGNNVxNoXYdaq8o3hN
         GAxDtFvlANujX1N3VArPPRnWA8pQUdaFjGUkS3tIyQUyqLM4/uATBUhwlPENfTrFtogM
         OBNg==
X-Gm-Message-State: AOAM530irkhkPjmqZnYnpRE51bsZ0eFJ4xkmtlPTXB/c0bdX8m/6tPVN
        aEhvCISDPc+pDuQ8+YHbHF5lJHXFxTzJ8XmvQSg=
X-Google-Smtp-Source: ABdhPJwYcKCqySi4k5SY89vrdU7tnY9VMmcqHjxXnjAWvYq2esa8zrSDDK5FHaV9IlgrbLpQs1Kau7DbTYQ/EqwW7fc=
X-Received: by 2002:a6b:e00a:: with SMTP id z10mr20448417iog.109.1622535460491;
 Tue, 01 Jun 2021 01:17:40 -0700 (PDT)
MIME-Version: 1.0
From:   tianyu zhou <tyjoe.linux@gmail.com>
Date:   Tue, 1 Jun 2021 16:17:29 +0800
Message-ID: <CAM6ytZoLkndXUaBxDDk36y_QW3JfNwtksQm3XAdUk+GLr28rEw@mail.gmail.com>
Subject: CAP_NET_ADMIN check in tc_ctl_action() makes it not allowed for user
 ns root
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, from commit "net: Allow tc changes in user
namespaces"(SHA:4e8bbb819d1594a01f91b1de83321f68d3e6e245) I learned
that "root in a user namespace may set tc rules inside that
namespace".

I do see the CAP_NET_ADMIN check in tc_* functions has changed from
capable() to ns_capable() (which is now in term of
netlink_ns_capable())

However, in function tc_ctl_action(), the check for CAP_NET_ADMIN is
still netlink_capable which does not allow user ns root to pass this
check.

static int tc_ctl_action(struct sk_buff *skb, struct nlmsghdr *n,
             struct netlink_ext_ack *extack)
{
    ...
    if ((n->nlmsg_type != RTM_GETACTION) &&
        !netlink_capable(skb, CAP_NET_ADMIN))
        return -EPERM;
    ...
}

So is this a check missing changing for user ns?

Thanks!

Best regards,
Tianyu
