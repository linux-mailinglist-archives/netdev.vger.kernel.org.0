Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBAF393ECC
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 10:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbhE1Ig1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 04:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhE1IgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 04:36:23 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9B8C061574;
        Fri, 28 May 2021 01:34:48 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id o27so3336250qkj.9;
        Fri, 28 May 2021 01:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=n3Y5rFOY8ng6rR4eh1BMeunvKaj0igaUH7MDrp3oilc=;
        b=f/ZJsRF5hw88ZRTfvA1+FLom/3aGv09nXjj+qwvw1e6vplaVKiSmsGM1WhiUj0/4fD
         +bpnAIWxbyiGYHsu+LxeAMGgYVuqtvkigo8rbYNAlesaBf3c5vB/1DudHnahX/e42j7v
         oIxq+VElOF2bzN3BZKuHMmQF1axyS/Vxt7Np+vJL+WhS7WmkISq8QmO84pV5kxGnu168
         C/vd6Hq2dQ8qpVJNt/IZjj7QS4v7iNm2Y+dkUmXN7LQqyDDOrTUkVLCW5DMVKkrMX65O
         diE7pyj5omGcpHCcn6Bkv1+TMViWH8kW4fyuKEP8CC3XU9NvdKu77EURsba8aFTGXLJe
         QE2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=n3Y5rFOY8ng6rR4eh1BMeunvKaj0igaUH7MDrp3oilc=;
        b=L5ZB/7BPIqfES6tCYP285ENn60oAg5yCbC9cyG4l9SfA4SdJBs0VYRQJQtnJ99jq3c
         aBsdwq29p7qrZgjJ6j7oOSrAmZ6leq/nqy72bCCHPw6QUAXcJrV/MawPQZtfQUPaLeVC
         Fi8BqFUsXjAN47f0O5xyjghoKlKezF+WZo3pp+aNrGFydQ3xJNFolaCnWPDZRnfX0iC7
         F8dw+5kzMxpu4bkIRY7pO/7h7MNGTXlYQRbRfXFX0R9Dy4miH/5ZAvkE3JnYZwt7sNv0
         xeEvOP75qOaU90h1QTa6Nhgk8e5uAJnPY89ijpmLgT+uul99EkQpOMcmXgNPXiitDcJp
         W4Xg==
X-Gm-Message-State: AOAM531I3wPsZi2Dp/cf6CvZOyv6p0wMZzCGL5RkLNtlKNzFo+K91jmg
        LfLKkpVX7vTyMYR37uJT+tKtMWyueI8fzD+IjTH4rOisxVLz
X-Google-Smtp-Source: ABdhPJy1sgepE6y6npW74EZRB/c8OoUq10EoDRIx+J11VZOrYgj0HUAf9EnrDBE1VWiTedJwCYjWXohIIfD720bpVrQ=
X-Received: by 2002:a05:620a:1126:: with SMTP id p6mr2894546qkk.120.1622190886995;
 Fri, 28 May 2021 01:34:46 -0700 (PDT)
MIME-Version: 1.0
From:   Jussi Maki <joamaki@gmail.com>
Date:   Fri, 28 May 2021 10:34:36 +0200
Message-ID: <CAHn8xckNXci+X_Eb2WMv4uVYjO2331UWB2JLtXr_58z0Av8+8A@mail.gmail.com>
Subject: Regression 5.12.0-rc4 net: ice: significant throughput drop
To:     netdev@vger.kernel.org, robin.murphy@arm.com, jroedel@suse.de
Cc:     bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
        intel-wired-lan@lists.osuosl.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

While measuring the impact of a kernel patch on our lab machines I stumbled upon
a performance regression affecting the 100Gbit ICE nic and bisected it
from range v5.11.1..v5.13-rc3 to the commit:
a250c23f15c2 iommu: remove DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE

Both recent bpf-next (d6a6a55518) and linux-stable (c4681547bc) are
affected by the issue.

The regression shows as a significant drop in throughput as measured
with "super_netperf" [0],
with measured bandwidth of ~95Gbps before and ~35Gbps after:

commit 3189713a1b84 (a250c23^):
$ ./super_netperf 32 -H 172.18.0.2 -l 10
97379.8

commit a250c23f15c2:
$ ./super_netperf 32 -H 172.18.0.2 -l 10
34097.5

The pair of test machines have this hardware:
CPU: AMD Ryzen 9 3950X 16-Core Processor
MB: X570 AORUS MASTER
0a:00.0 Ethernet controller [0200]: Intel Corporation Ethernet
Controller E810-C for QSFP [8086:1592] (rev 02)
Kernel config: https://gist.github.com/joamaki/9ee11294c78a8dd2776041f67e5620e7

[0] https://github.com/borkmann/stuff/blob/master/super_netperf
