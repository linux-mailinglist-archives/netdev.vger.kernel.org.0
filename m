Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58238175612
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 09:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbgCBIhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 03:37:11 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]:45924 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbgCBIhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 03:37:11 -0500
Received: by mail-wr1-f52.google.com with SMTP id v2so11279728wrp.12
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 00:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=fi95Ss0wvAjDSNzPG+vj3mL6BEi90B+Kfu3eCNujXy4=;
        b=PDiUafwuZpVj52bWiAdwNbFpFzK8926pycEZKmlLWkm+bbRnTgXJ705JRxN8hdY3E3
         w6oE6aELWEIEqya1HGp5BTbOmXSgU7AcOZb+tyEUDr2FK+xmIqFEolEPriOLFar5VrDr
         qHYF9vcNPCIOHhYDGClsdBHv1lLQjmDPOu2L0Gs0Ko/h5jQbdTzBfHSXrQB2HqeEYgvk
         BihghY6wzFTXOSgB/vNJV6vGK+/hyYhf2HatxRIXev6mt/KkvF+JcUzaZm1zlrApvu5V
         UF/ltF8SiitwUYfRGDlWUTAoaVjwt3Qr3xnrd6yVrq/q+cNSUTEkeSvlh7aX5/rJfdlY
         ACng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=fi95Ss0wvAjDSNzPG+vj3mL6BEi90B+Kfu3eCNujXy4=;
        b=j/JZaS/yXcUhKHNqgNXLDol07FBMBiXZtVom1cJbXHsEg+j+MLH9V6cw50h/LlLZir
         45UX6/ojP72xjhozPBrH8MCIejNBbAl+1LgIXcCVJf4a4vwFpVtAmkuwH1bsZSS5nNKv
         5gYbhmIO4tGx0CTwC8QeYz1lM4Bt2ON8Ek+0jYFk+g1y1C6uL1Fq7/sQFqXeffKRs+nc
         h4joeHzE4aIJ05RFNmO2MtaDLKRSFa43kfIrqvBH32mg7GPNM+WZ2HsbhqLHeBmjj5C0
         XrZ4oY27ZwF586zZOHPcvVeSPNiud8wi4P8+UOPhZUN5tqu0uBgjg/MrprR4BKWsMwI3
         zxJg==
X-Gm-Message-State: APjAAAXvB9Y+9Fsu9NWKKg1qydnA/eHSfszNVduuh5Gek9Evnv14jY+9
        O6igI8LgE3aQdzNyfJZ9tznrgbRWzxQo11XVdCs/Kx2z
X-Google-Smtp-Source: APXvYqx94zcmmoVRf7pFXmiQi/La462HqpmdTztP8JDap/3mlkBCL/L101dzpdW0m9r3JxH07D4za2isEmjbs5xU2ZM=
X-Received: by 2002:adf:fa43:: with SMTP id y3mr20719298wrr.404.1583138229144;
 Mon, 02 Mar 2020 00:37:09 -0800 (PST)
MIME-Version: 1.0
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 2 Mar 2020 16:38:59 +0800
Message-ID: <CADvbK_evghCnfNkePFkkLbaamXPaCOu-mSsSDKXuGSt65DSivw@mail.gmail.com>
Subject: route: an issue caused by local and main table's merge
To:     network dev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, davem <davem@davemloft.net>,
        mmhatre@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, David A.

Mithil reported an issue, which can be reproduced by:

  # ip link  add dummy0 type dummy
  # ip link  set dummy0 up
  # ip route add to broadcast 192.168.122.1 dev dummy0 <--- broadcast
  # ip route add 192.168.122.1 dev dummy0   <--- unicast
  # ip route add 1.1.1.1 via 192.168.122.1  <--- [A]
  Error: Nexthop has invalid gateway.
  # ip rule  add from 2.2.2.2
  # ip route add 1.1.1.1 via 192.168.122.1  <--- [B]

cmd [A] failed , as in fib_check_nh_v4_gw():

    if (table)
            tbl = fib_get_table(net, table);

    if (tbl)
            err = fib_table_lookup_2(tbl, &fl4, &res,
                                   FIB_LOOKUP_IGNORE_LINKSTATE |
                                   FIB_LOOKUP_NOREF);

    if (res.type != RTN_UNICAST && res.type != RTN_LOCAL) { <--- [a]
            NL_SET_ERR_MSG(extack, "Nexthop has invalid gateway");
            goto out;  <--[a]
    }

It gets the route for '192.168.122.1' from the merged (main/local)
table, and the broadcast one returns, and it fails the check [a].

But the same cmd [B] will work after one rule is added, by which
main table and local table get separated, it gets the route from
the main table (the same table for this route), and the unicast
one returns, and it will pass the check [a].

Any idea on how to fix this, and keep it consistent before and
after a rule added?

Thanks.
