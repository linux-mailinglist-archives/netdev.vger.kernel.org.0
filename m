Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC1BAC1273
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 01:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbfI1X1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 19:27:36 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36750 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728834AbfI1X1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 19:27:36 -0400
Received: by mail-ot1-f68.google.com with SMTP id 67so5382410oto.3
        for <netdev@vger.kernel.org>; Sat, 28 Sep 2019 16:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=1cFBRQANYsp0gQrHnyPxu00m133KQxr04TleEPqLfdU=;
        b=ODQZ7gwJSfYQNlmx/4fjYxDU7Ez1JCrqPs2Zisjcjgs0Ycjr5htjetATWM7QRYqRN+
         vb4xrA+RseIpnvXiiELIhy79JPURfUnnk9cQHfoPxSa0DvJ9ckwx95s1kr0C5zzD+7i9
         Fz49L8cvTVf9KPoINlDWNXL5cnXiYOWKkZ1C6F8Yi1c0iPPUITJ9bg+FOanIGCgHlihm
         bfStmGuqBIz5KUuUsUfZicilUYNZrwJgssAB1nN9tEBaY2U+Y55cUJOJsFtFQvsmCkRe
         WmsmED/YDTlU8tEu1yedkUvzb3H4krN9HT9u/hTVKXJWC2+8pR6gZyrKfBX2PL0cOIKA
         D+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=1cFBRQANYsp0gQrHnyPxu00m133KQxr04TleEPqLfdU=;
        b=Q+xKf+G/bLr/hA/qqtqvQh2vi8bgTm5oFcW2oHIOMOlgRTCp/LfzRiAPr0ssXW09OQ
         l+k3C99V9ISaldwgyOM1UxFwnvZHY+u8Omm+wAuaVE0Ea8kta4VYRnS6u3QWJ8qI6DLa
         EX1Ft65oXG8IK3Azzes2Cfl6Mw2Q+pHGPxvDICJzfBfvm3Zdm2WDlKwsp0X5hkLCl3+w
         zj9ZlHIyGLisyx71Z5LBQOK2N1Gi5VenMkeeKBUnZq/3Xu6MrY55+Y3BYQ4zOJUbUoTU
         zA7WdEHdPJfLDe3Z3Mnf8fLTy2s3dQ1UGBVoPqNf7kJWLJrc1h8NNCB1xwTC0YAJ0ldQ
         pN+Q==
X-Gm-Message-State: APjAAAVf4x5Kzwv1ghcoPU6d1Yufh+hxeN+uLygGIMsjH2q7EXP/nqzz
        2ZclcBiDCBaHHC2rsE9g5U5EhtTjWLHPerPszyiS9S5FStg=
X-Google-Smtp-Source: APXvYqxEiAbHr5PjWcQ7FUb4m+5a6rPH4bcMEELqbsc7FdZhn3K2OgiksZXNLLM40iFS3Y78izuJaCw3xd2C98PElss=
X-Received: by 2002:a05:6830:443:: with SMTP id d3mr8625236otc.93.1569713253336;
 Sat, 28 Sep 2019 16:27:33 -0700 (PDT)
MIME-Version: 1.0
From:   Mario Rugiero <mrugiero@gmail.com>
Date:   Sat, 28 Sep 2019 20:30:15 -0300
Message-ID: <CAKKQwLR+Hk6H_SMi7QuPf4S_iR21ojboL1783fOH4ofBSjVZ7A@mail.gmail.com>
Subject: [RFC] rx_missed_errors statistics support in several drivers
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Working on an IDS product using libpcap, I stumbled upon a problem
with packet loss statistics: libpcap would report as dropped at the
interface level packets that were actually seen by the product.
Because of that, I noticed it used the rx_dropped stat from
/proc/net/dev, which is wrong, as it counts layer 2+ drops.
The straightforward solution is to use rx_missed_errors +
rx_fifo_errors from sysfs.
However, there are many drivers not implementing this interface, and
accounting loss directly on rx_dropped.
I believe (any pointers for this would be super useful) ethtool
provides the means to query if this stat is supported by the device
driver. On the other hand, it would make sense for the drivers to
implement this counter anyway. If this happens, then it can be
considered a safe bet for libpcap to just look at these counters
without the extra code talking to ethtool.
I intend to update these remaining drivers gradually.
Sadly, I don't have the hardware for each and every device.
So, is there any way to distribute the testing? Alternatively, could
the change be considered trivial and only be build-tested (as well as
the static analysis tools provided by the usual toolchain).
An example of what I expect the changes to look like is this:
https://github.com/torvalds/linux/commit/ecf7130b087a9bd1b9d03dbf452630243210d22e

Besides this, are these kind of changes likely to make it to LTS
kernels? Likewise, I'd like to make an attempt for my changes on
libpcap to be compatible with the oldest supported kernels.

Regards and thanks for your time,
Mario.
