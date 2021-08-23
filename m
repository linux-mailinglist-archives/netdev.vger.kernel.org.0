Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF97A3F4EE6
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 19:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhHWRCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 13:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbhHWRB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 13:01:57 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCACC061575;
        Mon, 23 Aug 2021 10:01:15 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id q70so19195883ybg.11;
        Mon, 23 Aug 2021 10:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=9dChikHVgwG7d/711i1s9qvxIpLptusWO5nO6BvhLUo=;
        b=GNvXr/klOHZL1ZA7nzMMaAdqniR9VRCPwLZbRzG/fEQSpfufYJSJr5lJ24edEMOcE9
         K0Cx69cjOLgZBMYPX8TRt4nkvTuEPluJop8k4ZWnkYHP92Y6Z3dzFFj0YqMOvO4ZmVTv
         H3ye+UKtCJNWa6g+c4YWU4C989oXLnU13CF66wkyoiiJj27+rDglFyB2A+DV9G0EhrGp
         JSAnesh1wkhfCs8ZlRHpSs10N3FyR79whXGx+Xfv/lxq+5qePlGGsgCy65MKUnaxIrSQ
         IaE/5JzQfRsA7aGhqrpyK3tHWnwCw29BHv8FkuCDV3SJiBaUkRIOeSjqlwFKMjlcdjTr
         dvKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=9dChikHVgwG7d/711i1s9qvxIpLptusWO5nO6BvhLUo=;
        b=tadywR2tbaKN4kU4qG9LezqTh3XBlb8F3750atOjwe+S0rINSA3xRAvubOY+zeCtO7
         tXGxkrIfov+xxVbH7DS/+0hKANipoOXWHjXIyuewdxPjbk5E2Xu9dzbs9oorWAICIPAu
         g/AELc5XBf1E4nLBDJU6/JjpH4fkkqIbC95iactrv4L8uky4a3Bnu47Qc+SqDsSatPdr
         MilJ9oOrk/5AnSkAtzsTUFHDCk3qFwQKVdRAM4RoWm9aP42sHFhkCiwOaIpM37fOMW5i
         DOXVuz48nlWlMkUwxqCVX7OIoXugH7Qq6xzP58abfxTqvXpW8/jhjCYf+MqGOhz2QXzi
         GSzg==
X-Gm-Message-State: AOAM5327uLalMa4wosvymmFiMzEwuC0JkR+qAil6A5WPeogg2W1PA5xC
        biXQ4DBuae8H4cV7SOnGB1mAvwbM5dyBsH6fhw0=
X-Google-Smtp-Source: ABdhPJyGU4kMfCciHNO8O+6GnbLAOsGM06FQW5NNmI91xMkL9CZsZYi+5EsZKEYgTs/P3ictQHhhNTv4Y/wQPeiTDyc=
X-Received: by 2002:a25:505:: with SMTP id 5mr45360934ybf.157.1629738074248;
 Mon, 23 Aug 2021 10:01:14 -0700 (PDT)
MIME-Version: 1.0
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Mon, 23 Aug 2021 19:01:14 +0200
Message-ID: <CAKXUXMzdGdyQg9CXJ2AZStrBk3J10r5r=gyiAuU4WimnoQNyvA@mail.gmail.com>
Subject: Suspicious pattern for use of function xt_register_template()
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, coreteam@netfilter.org,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Florian, dear netfilter maintainers,

Commit fdacd57c79b ("netfilter: x_tables: never register tables by
default") on linux-next
introduces the function xt_register_template() and in all cases but
one, the calls to that function are followed by:

    if (ret < 0)
        return ret;

All these checks were also added with the commit above.

In the one case, for iptable_mangle_init() in
./net/ipv4/netfilter/iptable_mangle.c, this pattern was not followed.
This makes this ret assignment in this function a Dead Store and
hence, clang-analyzer warns about that.

Are we missing here an early return for a negative return value as
well, or is this case for iptable_mangle_init() in
./net/ipv4/netfilter/iptable_mangle.c special?


Best regards,

Lukas
