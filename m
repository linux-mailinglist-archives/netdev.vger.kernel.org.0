Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3916323A1
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiKUNcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiKUNci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:32:38 -0500
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72690267C
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:32:34 -0800 (PST)
Received: from [192.168.16.41] (helo=fisk.sw.ru)
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <nikolay.borisov@virtuozzo.com>)
        id 1ox6tg-0011Rq-8D;
        Mon, 21 Nov 2022 14:31:40 +0100
From:   Nikolay Borisov <nikolay.borisov@virtuozzo.com>
To:     nhorman@tuxdriver.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, den@virtuozzo.com, khorenko@virtuozzo.com,
        Nikolay Borisov <nikolay.borisov@virtuozzo.com>
Subject: [PATCH net-next 0/3] Add support for netnamespace filtering in drop monitor
Date:   Mon, 21 Nov 2022 15:31:29 +0200
Message-Id: <20221121133132.1837107-1-nikolay.borisov@virtuozzo.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for conveying as well as filtering based on the the
id of the net namespace where a particular event originated. This is especially
useful when dealing with systems hosting 10s or 100s of containers.

Currently software as well as devlink-originated drops are supported. There is
somewhat a "breaking" change since I had to modify the net_dm_drop_point struct
and this in turn broke wireshark's dissector of the net_dm protocol as a result
the existing 'Capturing active hardware drops' test fails. I tried understanding
what has to be changed in https://github.com/wireshark/wireshark/blob/master/epan/dissectors/packet-netlink-net_dm.c
in order to fix the dissector but couldn't figure it out, any help would be
appreciated.

I've also provided tests for the new functionality so it should be obvious how
it's supposed to be used.

Nikolay Borisov (3):
  drop_monitor: Implement namespace filtering/reporting for software
    drops
  drop_monitor: Add namespace filtering/reporting for hardware drops
  selftests: net: Add drop monitor tests for namespace filtering
    functionality

 include/uapi/linux/net_dropmon.h              |   3 +
 net/core/drop_monitor.c                       |  64 ++++++++-
 .../selftests/net/drop_monitor_tests.sh       | 127 +++++++++++++++---
 3 files changed, 171 insertions(+), 23 deletions(-)

--
2.34.1

