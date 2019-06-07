Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E9E384A1
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 08:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfFGG5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 02:57:10 -0400
Received: from mail-it1-f170.google.com ([209.85.166.170]:54888 "EHLO
        mail-it1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbfFGG5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 02:57:10 -0400
Received: by mail-it1-f170.google.com with SMTP id h20so1181937itk.4
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 23:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Dw7OsVO+Tdq8I5EYVlT8h376PBosDMHoK2XuQKsVqVc=;
        b=mYYMgNhcPH/g11joV+cySveX9C5MtjIYBz3wcOu8QYIFljHHlz0nXt1fyw1Eu8OW1w
         bFqSgtTihiNd0z2vgPgqXSK8chzegtnBcjtzQyM7OjjoEYhJ1RohIBvH2WkNiAw0lzwd
         NZoFS9wM6M7cosGPGgwSys7C7eY1lDKImOxdRYeX6/zKY12v/DE6IR6e5lmJ5/nzDVVK
         +ow6Wx3zKu1/yCpQJ3IAZm98hqEkJc5uX00iFWyR0kE8f08BmBP40+mYs7vKbA+bq/Ii
         O8m5zWdP74GdqMpAAH3Iq/Z6OaJLqJFUNQUnLB80+/Rq5q4r2UC8eyyVUymBOYZ1bVXN
         s1Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Dw7OsVO+Tdq8I5EYVlT8h376PBosDMHoK2XuQKsVqVc=;
        b=AXUcNX038RDEwpBYOSZv3iU5KayVMZSobsg26p2HRu+pH9SAoajPXR2xjluuZ48iCt
         LbFpcqsn9glv7Zs06OWrGppVW/NpLU/tupC2sXdRvDfL7iQHxfNXRukYWHCDQXmiOCSK
         bfMYdaQhAGbAZQJRDo0U5D2+39jI+gcPFZdWyr/xNDJio8AS5cPXRCq6E3xi1paltFtm
         ZlEcQmd2nnuEZ9sRDX5CY5G7amRU0SNdAWWLM92z7I5KdtsRly4PNGhlgn1zH5G6B//1
         GeoG19uuVQgy4XswKKcFjIl8fS82Wv3QxUDI31M5g185dsWmPlnSGYLq76Ko5sob210b
         nzrA==
X-Gm-Message-State: APjAAAUYSKCIU3S9vPBtgT1CWNTlsGNvThMC4LgzeriknpsqTc8BlQJy
        JbgtETAKipFKTcJ3ppznnja/WHrsg4DYncqfidEZEerK
X-Google-Smtp-Source: APXvYqwfFiwMln2KDGyWNViLGX9LRcShUXWH5jbv0qLMWqYUHbWn0X0Icm3382dFkQibzJixwVCcw8fmX4sTvLUFrGc=
X-Received: by 2002:a24:da83:: with SMTP id z125mr3343535itg.126.1559890629569;
 Thu, 06 Jun 2019 23:57:09 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?7JaR7Jyg7ISd?= <ileixe@gmail.com>
Date:   Fri, 7 Jun 2019 15:56:48 +0900
Message-ID: <CAFAx9ab=Wys2QU+nsh-O_XyOKw9T1ACziphzRW4ARYAwA30xEw@mail.gmail.com>
Subject: How net_device feature flag of 'tx-udp_tnl-segmetnation' is decided?
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev!

I'm kernel newbie and I'm not sure it's right place to ask though, if
not please let me know the right place. :)

I sent this mail to ask about net_device interface feature called
'tx-udp_tnl-segmentation'. Ethtool does not appear correct status of
offloading, even if the vxlan offloading is enabled. Ethtool show like
below for vxlan interface.

deploy@krane-pg1-com1000:~$ ethtool --show-offload vxlan100
Features for vxlan100:
tx-udp_tnl-segmentation: off [fixed]

deploy@krane-pg1-com1000:~$ ethtool --show-offload eth0
Features for eth0:
tx-udp_tnl-csum-segmentation: on

Tcpdumping show offload is correctly applied in vxlan interface, so I
wonder this is bug for vxlan implementation. I found
drivers/net/vxlan.c does not set the feature SKB_GSO_UDP_TUNNEL, just
applying the flag at creation time. Is it bug or something that I
misunderstood?

Thanks in advance!

Best regards

Yang Youseok
