Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E22915D663
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 20:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfGBSm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 14:42:28 -0400
Received: from mail-qk1-f182.google.com ([209.85.222.182]:42549 "EHLO
        mail-qk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfGBSm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 14:42:27 -0400
Received: by mail-qk1-f182.google.com with SMTP id b18so15099529qkc.9
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 11:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=bAsutEjynubnQ09AN9meg7cgRf40lhQFM8fx/J1t3SQ=;
        b=a+MU1xUIGy8Ot9A+HMJCvhBGhShUDRf++TJMF9h9nmVFFpJuBxWOYhyeSDn9DlEXrK
         gsS+7Y9LhiIZ77JQAcGLz/LWt2VJ+KtpOGWnGhQYm4PS81+OiZeA3ADd71Gwr5/MtSAH
         32JyzRjhmYdoe/TqYfW40H0IBDgPkP39Y/GoQ+gjh3wZ3B3cIAsOn65vshcrQjxkvxaM
         FclKznd580TiTAjqkFUO8o6Qt9eBP9dvaijryJ+X2Lmd6f82pmvy7vNA0BFMiN7qLWy/
         c0Gfa3EIdEnw9WiWsZaxnPWoMjLMpQQ3MtkVKRYYTGSnQLgsTesbxADXRwPuXypQzA01
         SaJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=bAsutEjynubnQ09AN9meg7cgRf40lhQFM8fx/J1t3SQ=;
        b=Wu15nHZf2QbH3fCY8pU8i2LWkBLijVPCMosRr3rmoST2bXMSipeY40QModScXehOew
         SVFFg0Fi93EOem107lcXszD2rhfYG6QDbemvtqhN8ZkDSnejPT8KsDmSEosofZnLPxwu
         UN3VQu7dp/a4mcgHno8hwPdKpOtMdWWP4pe6d76QRgTtYeNavuihpJhWTPxxQhp8NOXF
         1VL9RTpbtuM6JXfN92V9Ydg5R2Bi2TeKvnxM21gK75Ml8IyU2ldnuMhRkYA9Xu/kFk6f
         ZsK6ENoe6SqKBg5jeaXHgULnDwgdhDlBtuujnMdKID4oqRYUmHgG77YhXiQyw33388Vl
         OinQ==
X-Gm-Message-State: APjAAAWUy8T8LbAihDosEeqjO1dm8ZIFc88KqGkZtCw1CgkVHwH5gZ2w
        a22DWquc0A28BYflQhqHG0JCwqVGhz3CY+e6oa/Y/6RAnQ==
X-Google-Smtp-Source: APXvYqyIS8blLshS1IJ9t6y2VHmUMntbFKKkKHf5l+g+PCQZTEvNeuxjjG3WYVhCEIJ/ncUOM/G7nrQUFlr9hjvL2RU=
X-Received: by 2002:a05:620a:1661:: with SMTP id d1mr27004272qko.192.1562092946450;
 Tue, 02 Jul 2019 11:42:26 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?Wm9sdMOhbiBFbGVr?= <elek.zoltan.dev@gmail.com>
Date:   Tue, 2 Jul 2019 20:42:15 +0200
Message-ID: <CANsP1a4HCthstZP16k-ABajni1m75+VKT+mgLPF=4yGJ-H_ONQ@mail.gmail.com>
Subject: veth pair ping fail if one of them enslaved into a VRF
To:     netdev@vger.kernel.org, dsa@cumulusnetworks.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

I have a simple scenario, with a veth pair, IP addresses assigned from
the same subnet. They can ping eachother. But when I put one of them
into a VRF (in the example below, I put veth in-vrf into the test-vrf
VRF) the ping fails. My first question: that is the expected behavior?
And my second question: is there any way to overcome this?

Here are my test commands:
ip link add out-of-vrf type veth peer name in-vrf
ip link set dev out-of-vrf up
ip link set dev in-vrf up
ip link add test-vrf type vrf table 10
ip link set dev test-vrf up
ip -4 addr add 100.127.253.2/24 dev in-vrf
ip -4 addr add 100.127.253.1/24 dev out-of-vrf

Then ping works as expected:
ping -c1 -I 100.127.253.1 100.127.253.2

After I put the in-vrf into test-vrf, ping fails:
ip link set in-vrf vrf test-vrf up

Thanks,
Zoltan Elek,
VI1
