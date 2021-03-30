Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E85434E7B7
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhC3Moy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Mar 2021 08:44:54 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:51259 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231794AbhC3Moc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 08:44:32 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuchunmei@linux.alibaba.com;NM=1;PH=DS;RN=1;SR=0;TI=SMTPD_---0UTrf.W9_1617108270;
Received: from 30.225.32.40(mailfrom:xuchunmei@linux.alibaba.com fp:SMTPD_---0UTrf.W9_1617108270)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 30 Mar 2021 20:44:30 +0800
From:   xuchunmei <xuchunmei@linux.alibaba.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: ip-nexthop does not support flush by id
Message-Id: <C2B7C7DB-B613-41BB-9D5F-EF162181988C@linux.alibaba.com>
Date:   Tue, 30 Mar 2021 20:44:30 +0800
To:     netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I use iproute-5.10 with kernel-5.10.6, I found that ip-nexthop does not support flush by id, is it by design?

Reproduce steps:
# ip netns add me
# ip -netns me addr add 127.0.0.1/8 dev lo
# ip -netns me link set lo up
# ip -netns me nexthop add id 105 blackhole proto 99
# ip -netns me nexthop flush id 105
id 105 blackhole proto 99
# ip -netns me nexthop ls
id 105 blackhole proto 99

while use flush without any args, flush will success.
# ip -netns me nexthop flush
Flushed 1 nexthops

I find the function ipnh_list_flush implemented in ipnexthop.c:

else if (!strcmp(*argv, "id")) {
			__u32 id;

			NEXT_ARG();
			if (get_unsigned(&id, *argv, 0))
				invarg("invalid id value", *argv);
			return ipnh_get_id(id);
		} 

When args is “id”, just return the related info of “id”, so I want to known is it by design ?
