Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3097E2E940F
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 12:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbhADLZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 06:25:21 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:51137 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbhADLZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 06:25:21 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UKhJwum_1609759479;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UKhJwum_1609759479)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 04 Jan 2021 19:24:39 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Date:   Mon, 04 Jan 2021 18:59:58 +0800
Message-Id: <1609757998.875103-1-xuanzhuo@linux.alibaba.com>
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: mlx5 error when the skb linear space is empty
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi

In the process of developing xdp socket, we tried to directly use page to
construct skb directly, to avoid data copy. And the MAC information is also in
the page, which caused the linear space of skb to be empty. In this case, I
encountered a problem :

mlx5_core 0000:3b:00.1 eth1: Error cqe on cqn 0x817, ci 0x8, qn 0x1dbb, opcode 0xd, syndrome 0x1, vendor syndrome 0x68
00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000030: 00 00 00 00 60 10 68 01 0a 00 1d bb 00 0f 9f d2
WQE DUMP: WQ size 1024 WQ cur size 0, WQE index 0xf, len: 64
00000000: 00 00 0f 0a 00 1d bb 03 00 00 00 08 00 00 00 00
00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000020: 00 00 00 2b 00 08 00 00 00 00 00 05 9e e3 08 00
00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
mlx5_core 0000:3b:00.1 eth1: ERR CQE on SQ: 0x1dbb


And when I try to copy only the mac address into the linear space of skb, the
other parts are still placed in the page. When constructing skb in this way, I
found that although the data can be sent successfully, the sending performance
is relatively poor!!

I would like to ask, is there any way to solve this problem?

dev info:
    driver: mlx5_core
    version: 5.10.0+
    firmware-version: 14.21.2328 (MT_2470112034)
    expansion-rom-version:
    bus-info: 0000:3b:00.0
    supports-statistics: yes
    supports-test: yes
    supports-eeprom-access: no
    supports-register-dump: no
    supports-priv-flags: yes




