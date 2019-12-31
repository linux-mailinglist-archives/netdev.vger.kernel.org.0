Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAE712D71E
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 09:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfLaIfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 03:35:21 -0500
Received: from mail-lf1-f54.google.com ([209.85.167.54]:36209 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfLaIfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 03:35:21 -0500
Received: by mail-lf1-f54.google.com with SMTP id n12so26647006lfe.3
        for <netdev@vger.kernel.org>; Tue, 31 Dec 2019 00:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=+MNik0Ar7AfQC2urxgR9LbB15UWj0EA7iHm5MK454p4=;
        b=ASF0PldKNtGISdgSj5+M22JK283qlo73I+fQSEEmQBXVPjRhhpDWTcU+OW3IWzdwTC
         EwIKI0k4psYGMXzIyeL6i9czsHX4E6K5TkPR013F3AirEI6BnGVFZoLP0w9KXp2sMP53
         JoiIZSOCBOwKAvGTftjjlAFkNuh7BQFtPLbK+lK/+KIREFavt6pvkYvEEbnjxd5oEkkD
         bahITeNg4zD3OV0F3gH81EOijs9P/LlgkqOyA6v3ny8XeVlIoVj2f1FJt9vNL5cP6o0W
         TyNOR7cB4OzMvlu5NbEZP4Ziunk//a08CdjeteTAiiV3LSFGRUGy6h3yjL1EkM/yHDP9
         oV5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=+MNik0Ar7AfQC2urxgR9LbB15UWj0EA7iHm5MK454p4=;
        b=IiTPIC6Csp37/4SMjAAFrh3y3EOgjgrDiGJ6F23l0Tm2XHk+nrWW2UEkuaW4Sl5S+U
         LKq5v8wGxoyBHV2G5nqGcwO1iflbOqkqv4LcP3O+0c8HVIGvH1imjAYqghKdcmsnzVR9
         mNHHAeST6N0XB7EnfZ/6TAhWXuGNsE5q+8Q3lEN8THgLos+z3MLNrHHqEThII3e3dtlo
         ofvNnxtCebDl63jIOpvMi7441mQiY6L5CzSIcerZftG+EjZ5r9SwIwqCyXt2n6lROTyA
         S17V5lxYMaJiVu/Vkq886TBWnAp6f7fdJf/Khbjyl5W5jyX99MTFcXDOqN67vsmUa2Sp
         sMEA==
X-Gm-Message-State: APjAAAXUDi81A9fQAqtdV40NPO0l1yZfLxg1g0hrYgCOwcIdSTRYLF41
        6DHMJmMIWW8hhlkfWSYYRL+eWUfjKNw/JxFmLyA=
X-Google-Smtp-Source: APXvYqwUiC9zWpVtyU1Qob/ReGxD5W3G4PHzeAIUBXUKZ0Ra7So1d0MeQzS9y38cL8cb3AiyhqPE8WdnK5F3GA/XQd4=
X-Received: by 2002:ac2:50da:: with SMTP id h26mr18245562lfm.80.1577781319872;
 Tue, 31 Dec 2019 00:35:19 -0800 (PST)
MIME-Version: 1.0
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 31 Dec 2019 16:34:43 +0800
Message-ID: <CAMDZJNVLEEzAwCHZG_8D+CdWQRDRiTeL1N2zj1wQ0jh3vS67rA@mail.gmail.com>
Subject: mlx5e question about PF fwd packets to PF
To:     Saeed Mahameed <saeedm@dev.mellanox.co.il>,
        Roi Dayan <roid@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In one case, we want forward the packets from one PF to otter PF in
eswitchdev mode.

The tc flow can be installed, but it may not work.
tc filter add dev $PF0 protocol all parent ffff: prio 1 handle 1
flower action mirred egress redirect dev $PF1

# tc -d -s filter show dev $PF0 ingress
filter protocol all pref 1 flower chain 0
filter protocol all pref 1 flower chain 0 handle 0x1
  in_hw
action order 1: mirred (Egress Redirect to device enp130s0f1) stolen
  index 1 ref 1 bind 1 installed 19 sec used 0 sec
  Action statistics:
Sent 3206840 bytes 32723 pkt (dropped 0, overlimits 0 requeues 0)
backlog 0b 0p requeues 0

but I can't get packets with:
mlnx_perf -i $PF1

the kernel version is 5.4.0+, the nic is "MT27800 Family [ConnectX-5]".
