Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2843215A230
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 08:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgBLHhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 02:37:43 -0500
Received: from mail-yw1-f50.google.com ([209.85.161.50]:42793 "EHLO
        mail-yw1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbgBLHhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 02:37:43 -0500
Received: by mail-yw1-f50.google.com with SMTP id b81so461216ywe.9
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 23:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=4ROfydOr//biHawDUASlxcC18gN0KdrILqKKFK/CYBQ=;
        b=AW9z0jAPinWBx2YW0CbnWxjXZ3lqdrDnDXj5Y1GAn/1LSSqftIIW204s7epwnG/xFz
         DtsslGQUqn4kWTWkjlmIWVhwF895yifynXkAGsu2e+xBj6xSuLT0wA6jrc2z0WSNMA2j
         TMmaxANmsxTaERGzFeyWrqSfMO3DoPzLcoRo+F0JcmWlzJKyiT0tz+ziKK6Y9T5daQon
         GmAS8AuflKcv+aRIzGgG9ti2fTlfBfjbHlg2o2+qACcfb0QU29B1RuM1lj//Hrm59k88
         AGHcTLrk6LcEHt3KjYjx3li+tlmdnWSBU508dj+SfhZiizaIH7QuN492fdgGiD3Fv21S
         sK/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=4ROfydOr//biHawDUASlxcC18gN0KdrILqKKFK/CYBQ=;
        b=pALZslx/UlcBCLNusJSbCleEUBhUfzYlhjFCV2G/aU/bwao0qxvVgxCWw5VltvDpfQ
         v6huOnVBlDuGH0FbmcGe59jFmuNiErWWBQeQCUwkT1oKR9/pAQxH/oH01GVVZeQ0YaVX
         mBcXnZk923Un17xCbHUnJB8y/1Mcyfkfs8bSVVDXvBy9oMpTD9TNpBwrkN3uit0XOsRB
         LWqKsxe9mfjX5dsq3RvV/eVnAI5lx/b6WA372UyOB1FFHNuMCa+bSqUxJGctB6gR+iYs
         TIPptj1k66a2zYxdKUzrjbO11DcJJYFsH7EHX2RoB1mksVOZkoqTJgIHoMWDXRuYjMGO
         YFGQ==
X-Gm-Message-State: APjAAAVUhWNkP33Muju4MQwKgcoTBhAhekFeAdsbhfgMOBx2YM084V5f
        s0gRv4+XjZmWRVp4uErELq3/54eV4OFqp3H0fCEPrvWt
X-Google-Smtp-Source: APXvYqyoBzUVJnmbXsYI4dDyqzvjOvO3PkGrj5wV0vNFurbwKO/aRKaCHIFKPTIySMWWHTBHS5nisZQFcXSE09KfnBo=
X-Received: by 2002:a81:a486:: with SMTP id b128mr9355740ywh.255.1581493062208;
 Tue, 11 Feb 2020 23:37:42 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Wed, 12 Feb 2020 08:37:31 +0100
Message-ID: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
Subject: Regression: net/ipv6/mld running system out of memory (not a leak)
To:     Network Development <netdev@vger.kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, I need some help with my devices running out of memory. I've
debugging skills but I don't know net subsystem.

I run Linux based OpenWrt distribution on home wireless devices (ARM
routers and access points with brcmfmac wireless driver). I noticed
that using wireless monitor mode interface results in my devices (128
MiB RAM) running out of memory in about 2 days. This is NOT a memory
leak as putting wireless down brings back all the memory.

Interestingly this memory drain requires at least one of:
net.ipv6.conf.default.forwarding=3D1
net.ipv6.conf.all.forwarding=3D1
to be set. OpenWrt happens to use both by default.

This regression was introduced by the commit 1666d49e1d41 ("mld: do
not remove mld souce list info when set link down") - first appeared
in 4.10 and then backported. This bug exists in 4.9.14 and 4.14.169.
Reverting that commit from 4.9.14 and 4.14.169 /fixes/ the problem.

Can you look at possible cause/fix of this problem, please? Is there
anything I can test or is there more info I can provide?

I'm not sure why this issue appears only when using monitor mode.
Using wireless __ap mode interface (with hostapd) won't expose this
issue. I guess it may be a matter of monitor interfaces not being
bridged?

--=20
Rafa=C5=82
