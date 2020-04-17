Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20711ADBB9
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 12:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730119AbgDQK5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 06:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729568AbgDQK5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 06:57:53 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF6AC061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 03:57:52 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id c63so1923819qke.2
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 03:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=af06dVXGk4x+as+Hj/TUUAlqR4g3a7HMmtDknGMmX+8=;
        b=K8lvZjw7A8xflUUvJ953gcFTboWmQEsJZ5kkQbMTUrGkzzZ2fqAmwiY1jlY9ZTcfHX
         XObDst0JYiAv1neO2hF9JJ/sHE0K8ekEkuxAGYHixL6CJ/pCDxhQLToSh2O+MkJms4bY
         VeLrgJUlvA3Z3xhN5h5mKNirTDJ13Jw0IUMczeOUGe/EVNnFStWxzfrNDX59YA3gmzkd
         hbHxVqIoxkiTidZ9/kZQp79TU0WQtvqX+yxkaI6lNOSsrcSU3R05zbclJzDgoKFGzGM8
         LF5O9PEdOb9EoQX6VpHhSSoeHeXVq3x7dvORpIEvnkl0hYqYcyzY7IY/3yxJbCJUeHss
         o1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=af06dVXGk4x+as+Hj/TUUAlqR4g3a7HMmtDknGMmX+8=;
        b=C2g5X3iYGxS84uvKDdQc8bX2SNG8fVdmj/lXhG7dV2Cb+FrbOxbvgtNelBpg8sK1Si
         3A4D3RDCUG9ZFcgOrXNFQgHABky63XoNKp2FSR0VqeHx9qYCyys/hatyizjUstjTJ7qh
         KDGLZjafIGPbS3LhHPwa3VNzecYsW1HTy3Y+qtih55v2duLiGc8KxjUY7CA3Yshh7p4H
         PtWtE7SjihRHfloVS/iZlDb5TQZ9g6e1a37mBvx0IJJSUU+RKQhJDp5On+xSKtRJ3RU+
         K5ApNNUWjdW7lJ10XSGt2c6vwDucR1h8sNmQWdtk2i/bg1L9slbnPiSNUPpjD0Sr71nC
         MLhQ==
X-Gm-Message-State: AGi0PuaXfSV+xiQZYg6Gbb9vmeTlu5mNNG+hG3V56wohYkGTQOjmABnV
        09ovocOx0y15WuInRdn/RosGDNAUSxmMmjiv4so=
X-Google-Smtp-Source: APiQypLwxzcCiZZg4O+XwhsIz7J0qmuJCm3eY8MHHEs0hcB6DQf20fNyUI2whMDOavakvaCxSe0b0bHvJNBAehe6d28=
X-Received: by 2002:a05:620a:1647:: with SMTP id c7mr2532403qko.473.1587121071699;
 Fri, 17 Apr 2020 03:57:51 -0700 (PDT)
MIME-Version: 1.0
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Fri, 17 Apr 2020 18:57:15 +0800
Message-ID: <CAMDZJNWm5Vu-G4_het+CyxdbZYPJuidihUPK0ZhPC1HfKXsM2A@mail.gmail.com>
Subject: discussion mlx5e vlan forwarding
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saeed and maintainers

In one case, I want to push vlan and forward the packets to one VF. Tc
command shown as below
$ tc filter add dev $PF0_REP0 parent ffff: protocol ip prio 1 chain 0 \
    flower src_mac 0a:47:da:d6:40:04 dst_mac 00:11:22:33:44:66 \
    action vlan push id 200 pipe action mirred egress redirect dev $PF_REP1

dmesg:
mlx5_core 0000:82:00.0: mlx5_cmd_check:756:(pid 10735):
SET_FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed, status bad
parameter(0x3), syndrome (0xa9c090)

So do we support that forwarding ?

kernel version: 5.6.0-rc7+ [OFED 5.0 has that issue too]
firmware-version: 16.27.1016
NIC: Mellanox Technologies MT27800 Family [ConnectX-5]
-- 
Best regards, Tonghao
