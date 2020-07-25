Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49C522DA46
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 01:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgGYXH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 19:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgGYXH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 19:07:58 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB721C08C5C0
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 16:07:58 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id s23so9609910qtq.12
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 16:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Rq5a/HVUIQf+18sccieM0oKYfff+JxrLa7aUTo3W2MM=;
        b=iorc7YAY/RoMK4d4y5nd9rNinitsaZ/6TZDw46d0e42wdXbL9eRAHNPwBbX5bGVe/M
         c3zqd3AxcNmjYVUSijS2fUpcwX82PF4/E0flTSKNL5RKmUXcwLtGWQJEfd6/FgAMhV15
         +BETbj+GklwOnBIrDJ+PrPXqoMLSZMFw/aXFf0MZa1OFg9he1wgSXY4PaZ/OEikq9/sK
         wpoZTt64IchprliIKrb0AKQO4HHy97tK0IvwVEgqfSpvwAR/ddg2bXwxlKNPg2GrsgMD
         TeT5wa4/0mJ8IsKcIbCeBV6kEUrGHrc1y/GUblIBcrEbshdtMdsANpm8k792Or+tWf9I
         5c4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Rq5a/HVUIQf+18sccieM0oKYfff+JxrLa7aUTo3W2MM=;
        b=oYwKZHHXQqQx2edRIyjDmVfvVLV/ewU71NK7gxWBnk+Zrq/B/XdJIXIKVoeslgiXSY
         rja+upw6ui60XBLWxucU0SpzA1HlNRxNKIOYGGCMY6+t71Nh1myO5PNei2TBM/EoxA08
         jnPBZm5ir+WITq6GEwAvnp1Z9mm+h/eSGom2pUx+teZ8YaxtQZ8LW9Qc1imenhH2h0OJ
         A63wdnAG9flcyRB1qwJmUDFXhTX8wa5rviue7NF2n4HeXkzYybXrjNdFQ42b8SHLB1p8
         QO5i44oCzzXmAl4SAKLcxBmht0yqmFLUxErs0jNZ+8Zp3hcg3omjMd4EpIa7jQMvZbke
         ulWQ==
X-Gm-Message-State: AOAM5314UFJF6q0p7hpjsL/1rrpcUaHZ7AurNdLvcgNoEmzZKo57Q+5Y
        nfL5ZDVgx/PHMbTj2dkCIR8j/f3FMnr/KsMluWJghRK/lFw=
X-Google-Smtp-Source: ABdhPJxaTT3ofG5Z2/dhd+PZGBl7PS9rAvhdfzakK2nAzGbnc07NKRDvkj+mkHv1cwXer+tIzs2MOZ741ZzfJ8BqFlw=
X-Received: by 2002:ac8:6d21:: with SMTP id r1mr2357706qtu.212.1595718477566;
 Sat, 25 Jul 2020 16:07:57 -0700 (PDT)
MIME-Version: 1.0
From:   Han <keepsimple@gmail.com>
Date:   Sat, 25 Jul 2020 16:07:45 -0700
Message-ID: <CAEjGaqfhr=1RMavYUAyG0qMyQe44CQbuet04LWSC8YRM8FMpKA@mail.gmail.com>
Subject: question about using UDP GSO in Linux kernel 4.19
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My apologies if this is not the right place to ask this question.

I'm trying to use UDP GSO to improve the throughput. My testing shows
that UDP GSO works with the local server (i.e. loopback interface) but
fails with a remote server (in WLAN, via wlan0 interface).

My question is: do I need to explicitly enable UDP GSO for wlan0
interface? If yes, how do I do it? I searched online but could not
find a good answer.  I looked at "ethtool" but not clear which option
to use:

$ ethtool  --show-offload wlan0 | grep -i generic-segment
generic-segmentation-offload: off [requested on]

$ ethtool  --show-offload wlan0 | grep -i udp-segment
tx-udp-segmentation: off [fixed]

A quick try did not work:

$ sudo ethtool -K wlan0 gso on
Could not change any device features

My test hardware is Raspberry Pi 4, and the Linux kernel version is
4.19. My test program is in C.

Thanks.
Han
