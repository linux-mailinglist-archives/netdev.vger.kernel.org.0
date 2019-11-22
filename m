Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A808F106688
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfKVGh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:37:57 -0500
Received: from mail-il1-f180.google.com ([209.85.166.180]:45441 "EHLO
        mail-il1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfKVGh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 01:37:57 -0500
Received: by mail-il1-f180.google.com with SMTP id o18so5797680ils.12
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 22:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=3H5aDDvJqdmHR/kaZwacv7KD+dnySaNyhkUrdyHR280=;
        b=pALV13sNcUbP+jgywPaexS4WUKbAgVaDwrsl+k4A3VLD/HSh7LToqu6KecrChSeub0
         oSfLw29MqyuQlArkMNYOIKbYsyM4XliR63hJjgveWHOuN3gAi6lhf9gP/Z2hTqirxILn
         Eua23cK9EGQL0JcCMLkox1/N4TSMvJlfj7iyCWEMIiYQLSn+VZhcuxZdQeuzcVv6Z+1I
         pWoPIg3lXha+MujoacwS8E9gkJ3hZoTfNY/vUQYnTpfm1vpx1obQaHJdxbT6Co76p1NW
         2amKbZgZF7Ef+z8lU20A2AgaWPZK5CzOmIUcft97FcLN2g0HUPO0jcueSL2q7n12Sm6B
         qzGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=3H5aDDvJqdmHR/kaZwacv7KD+dnySaNyhkUrdyHR280=;
        b=b9D+N3gnpjQYA71gtDWqurXMkXRQuOG5tBoiGHpOvuTl/NhvtLAtiBLwTD9o6pFKyZ
         jgSVLc6PasqYO9oGY8zVBUO/yRHKDv68gSVyupNLgxRcgy6G4A/B3RESNtyZoq3FSEXZ
         McFrBS6K+M+uHcjo8ett7ec5Vv3+mVVNzI/6WfjuUyFQvXoh/5TQCvOlAWLUziaY1y6p
         05sRlS6a2SN4xE6F3k4OiaiAv/Fi+N3fJs1l/NdUFPigwnYNO6aCft4+N6NPppo664wZ
         LxttOX/TCnuGFPclMoaGWaGxWVDF0Tiun9ka96VZdwziJyLGXxHd5yGly1dkLAn99hmc
         vMeA==
X-Gm-Message-State: APjAAAWakhKwJjOuTH+XBVndGG7p3CYUWqQeT/J3krDxEiSyBgcI7RRv
        ZDb9CntM/YIczbtB5TwD+LFBlcro4i/s5o7lQ63YEO8q
X-Google-Smtp-Source: APXvYqzlJ9KVy3tK5CLu+DcOHpxEgVXKTIA6TL7zJp0BwKtEi23dxM0KrPkYXn+zrrD7/UpJA2A3zCpHdpyvs2gBz7I=
X-Received: by 2002:a92:6802:: with SMTP id d2mr569249ilc.173.1574404675993;
 Thu, 21 Nov 2019 22:37:55 -0800 (PST)
MIME-Version: 1.0
From:   Mohan R <mohan43u@gmail.com>
Date:   Fri, 22 Nov 2019 12:07:45 +0530
Message-ID: <CAFYqD2pjwCBd5TxNP0wXxKvwYLnr20cYDjK3S0rHM=Fx6si6-Q@mail.gmail.com>
Subject: how udp source address gets selected when default gateway is
 configured with multipath-routing
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I have a simple multipath-routing setup,

default
        nexthop via 192.168.15.1 dev enp4s0 weight 1
        nexthop via 10.0.1.1 dev wlp2s0 weight 1
10.0.1.0/24 dev wlp2s0 proto kernel scope link src 10.0.1.251
10.0.3.0/24 dev wlp0s29u1u2 proto kernel scope link src 10.0.3.1
10.3.1.0/24 dev wg9000 proto kernel scope link src 10.3.1.2
192.168.0.0/16 dev enp4s0 proto kernel scope link src 192.168.15.251

here enp4s0 (192.168.0.0/16) and wlp2s0 (10.0.1.0/24) are connected to
two different ISPs.

DNS works fine when I access internet through my internal subnet
(10.0.3.0/24), but  when I try 'ping google.com' in this machine, the
DNS request to 1.1.1.1 (which is my nameserver in resolv.conf) to
resolve 'google.com' is sent through enp4s0 interface but the source
address in that DNS request contains 10.0.1.251 (wlp2s0's local ip
address).

If I have single nexthop in default route, everything works fine.

How can I make sure that kernel picks the correct source ip for the dns request?

Thanks,
Mohan R
