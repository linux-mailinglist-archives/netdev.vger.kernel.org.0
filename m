Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA67425EB71
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 00:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbgIEWZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 18:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728505AbgIEWZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 18:25:08 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E4FC061244;
        Sat,  5 Sep 2020 15:25:08 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t7so1680356pjd.3;
        Sat, 05 Sep 2020 15:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=WON81VLGtQZQqv9hG6fzDWwJXml3JZpcAh4/UYpmRoA=;
        b=iHOvYO9aQsjmyox9xj8OpqsMyAbnBSCkr8AsP8mxp85LELoRB2VvZT3Uq53FSoUMk1
         yI0veowfW0d8k6RFsmMjDwbQ39UnXhfuJabZSWj6iZyqDo5eU4Q5M3BzYnBJlTuJ6haA
         gNtZjKMn7eE11KYb5Fcr3XYVQHm+IEuoptenN1oWEMQuImL2uWrIaDwfti4K8zBuwLw+
         MekobRxeSwEECWg+1p6SkzZsGApF0Se/tekhTBFV4u7xXZOdS0ZvILrDomN0wpqlbC1d
         nUmsezEvEHqpdHdFvIBiQ0y1CrEOpqlZWxFk3oZYGQgQx76JGq7EbEjKsRxBQ5pvzcMp
         xKQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=WON81VLGtQZQqv9hG6fzDWwJXml3JZpcAh4/UYpmRoA=;
        b=jqnuURsSCyFixuSegOMwdcNj64Ec5bYKHVaAtdebiZQBamS3ZKIdCvz8hUFWTRJ1cI
         aP/T/lXVLDYiwoDfz3IU2nhoJ1MQ25zxNWPMc5DyDrAjHzqXjbYwKCmOPwQqw0rQEGFZ
         WWTnCg0B0mFzyTqLsan6PwAVLkIGsk/3clwVK/0R23btuS9s9J/P+0lxLYv0+Z7MpsfJ
         quZSK+hjF8PFdHV9hgjttmcvwpl64Xdl9H1jR78ORKV9Xl2shthMbwY7h9Fdxd+5HiMu
         W8KYh5DG82jNQkpkNzzB5jHgEaHLbrNzW3+G1c+Xl0ckIwlNsUtOoGFwqWVPjWnrIi8V
         qmYQ==
X-Gm-Message-State: AOAM531VzJlGLgAzeli3uhL+71I5+E/xtEHFV31POp6Otf55Dfyr543E
        s+Yay9bv0RhkbT2pR5RhAXqW1T9hYBa+87mTBHE=
X-Google-Smtp-Source: ABdhPJzvBf1kgKpzf6XURCvMq2WTUnvr+hEvyKK3zKPM+5ZwtErWlvq7pxIDPSkC0mqAIjmrOR0nnv9+GKRHsbjaUb8=
X-Received: by 2002:a17:90a:aa90:: with SMTP id l16mr13696842pjq.210.1599344705857;
 Sat, 05 Sep 2020 15:25:05 -0700 (PDT)
MIME-Version: 1.0
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 5 Sep 2020 15:24:54 -0700
Message-ID: <CAJht_EOu8GKvdTAeF_rHsaKu7iYOmW8C64bQA21bgKuiANE5Zw@mail.gmail.com>
Subject: Question about dev_validate_header used in af_packet.c
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

I have a question about the function dev_validate_header used in
af_packet.c. Can you help me? Thanks!

I see when the length of the data is smaller than hard_header_len, and
when the user is "capable" enough, the function will accept it and pad
it with 0s, without validating the header with header_ops->validate.

But I think if the driver is able to accept variable-length LL
headers, shouldn't we just pass the data to header_ops->validate and
let it check the header's validity, and then just pass the validated
data to the driver for transmission?

Why when the user is "capable" enough, can it bypass the
header_ops->validate check? And why do we need to pad the data with
0s? Won't this make the driver confused about the real length of the
data?

Thank you for your help!

Xie
