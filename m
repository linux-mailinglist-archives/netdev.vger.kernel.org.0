Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CADA612AEF1
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 22:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfLZVfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 16:35:14 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42086 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZVfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 16:35:13 -0500
Received: by mail-pg1-f193.google.com with SMTP id s64so13429635pgb.9
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 13:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=MqdVJXTPmCXvOtrNw0sbl5bcies2uBGSLulDw8x2+Fs=;
        b=riD+4QvsEBsa7xObDcpaltgMGemZdk2Sa7ozZWDajl3dIXnG+pTO6qE2DIA8iSVVpv
         v/VYd6GJlj+CSksVqc1oqeYqN7CHCOW0dUvYX5tkNJ4hbCDNO31SYpFnA+qsvKzDxZ+3
         LrQmxwwIRGR8FGlQtvcmjC/lx3XRRBBlfBiqGVLJFUSI3TXzcD612ThEo/HC6CmcQIqZ
         cV8R9viIlczoN++9pHrqppQvwiS5ueiOtkvLvvlHWWwyET20qeXA77S8IR55Oax75RHB
         HgXa61/of0FE6LqK3tji17Vm8zBydhUxtfwjBMDSNDU81dC8lVowRyF3vh1Ru4TL5YPE
         znSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MqdVJXTPmCXvOtrNw0sbl5bcies2uBGSLulDw8x2+Fs=;
        b=Y+hzazlB/EurWhYTVA5XRT4Hd6qw/nDhHj9FQ4aCOhJnln3yOmseYMuxxpQp8y4GeY
         fBZe8rudL6b9SiUydBCiHqZoCqd6Kg4n6N53MvQ7gHakgAhvEryAi15aanASMb8eh0UL
         BSfpvy8TLy/I58FtUoRa25RcKFyo9CSUN4LXwsOrRoIXKHlRQD/a1f57Q5DyV+4Malqk
         HGG8K9ZIm31uboxZhffuZuGe97OirY9/uo10dpGMpwjV70FRODK2q1vaO5zGyyj9UP7t
         jMYCDffVmEEUC9mPMhoTNA8/kgrkLSU0UwxUPzA0rkSZpATnSmdMkUGXmUt6W4BkzvKI
         cslA==
X-Gm-Message-State: APjAAAXecNgzoh3kIL+Wf2Pb2Qnjz9fP0c9klp5PGZeyK7tlPat/c8k/
        277BXv7oZsikV8EQDBPotJAwIczv4eE=
X-Google-Smtp-Source: APXvYqw6oS5FNthHnDN0htNMMmiR4vDgGf+wKeKdV8KtK0Nutp8CSsOMOwqMcG6XXiM8wdzMPhCMsA==
X-Received: by 2002:aa7:9290:: with SMTP id j16mr17881906pfa.30.1577396113045;
        Thu, 26 Dec 2019 13:35:13 -0800 (PST)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id q6sm37996662pfh.127.2019.12.26.13.35.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 26 Dec 2019 13:35:12 -0800 (PST)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [PATCH net-next 0/2] net: Warning for protocol specific transmit checksum
Date:   Thu, 26 Dec 2019 13:34:57 -0800
Message-Id: <1577396099-3831-1-git-send-email-tom@herbertland.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apparently, not everyone got the message of "Less Is More" with regards
to checksum offload (https://www.youtube.com/watch?v=6VgmazGwL_Y). Some
vendors are still using the deprecated versions of checksum offload in
new devices. As more complex protocol combinations are commonly used and
supported, continued use of protocol specific checksum offloads is not
sustainable-- it needs complex driver code, gives limited functionality,
and is hard to make robust and to test all the edge cases for
correctness. This is particularly true for protocol specific transmit
checksum offload.

Consider for instance, that when a segment routing header is inserted in
a packet after the IPv6 header and before the a TCP header, if the
offloading device attempts to compute the checksum over the pseudo
header then the calculated value would likely be incorrect since the IP
destination address is not the same as the final address for termination
of TCP. The upshot is that if a device supports protocol specific
checksum offload then the driver has to ensure that the packet only
contains protocol that the device will understand; in the worst case
scenario of protocol specific transmit offloads this degenerates to the
driver having to parse the TX packet just to see if the device will be
able to handle it (i40 driver for example).

This patch set adds a warning message for using NETIF_F_IP_CSUM or
NETIF_F_IPV6_CSUM. Documentation/networking/netdev-features.txt is also
modified with more detail about converting legacy drivers to use
NETIF_F_HW_CSUM (that is, use the protocol generic API even if the
device only support protocol specific checksum offload). Once all
drivers have been converted to  NETIF_F_HW_CSUM then NETIF_F_IP_CSUM
and NETIF_F_IPV6_CSUM can be removed.

Tom Herbert (2):
  net: Documentation about deprecating NETIF_F_IP{V6}_CSUM
  net: Warning about use of deprecated TX checksum offload

 Documentation/networking/netdev-features.txt | 7 ++++++-
 net/core/dev.c                               | 4 ++++
 2 files changed, 10 insertions(+), 1 deletion(-)

-- 
2.7.4

