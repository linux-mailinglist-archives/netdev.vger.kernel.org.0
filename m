Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 470D03B478
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 14:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389819AbfFJMQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 08:16:45 -0400
Received: from forward400p.mail.yandex.net ([77.88.28.105]:58124 "EHLO
        forward400p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389573AbfFJMQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 08:16:45 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jun 2019 08:16:44 EDT
Received: from mxback15j.mail.yandex.net (mxback15j.mail.yandex.net [IPv6:2a02:6b8:0:1619::91])
        by forward400p.mail.yandex.net (Yandex) with ESMTP id 1EC721BC0E3B
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 15:10:24 +0300 (MSK)
Received: from localhost (localhost [::1])
        by mxback15j.mail.yandex.net (nwsmtp/Yandex) with ESMTP id ui4sYCk4uL-ANDqopn6;
        Mon, 10 Jun 2019 15:10:23 +0300
Received: by myt6-27270b78ac4f.qloud-c.yandex.net with HTTP;
        Mon, 10 Jun 2019 15:10:23 +0300
From:   iam@itaddict.ru
To:     netdev@vger.kernel.org
Subject: How long TCP state change from SYN_RECV to ESTABLISHED should take?
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date:   Mon, 10 Jun 2019 15:10:23 +0300
Message-Id: <7723811560168623@myt6-27270b78ac4f.qloud-c.yandex.net>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While playing with eBPF i tried tcpstates.py (https://github.com/iovisor/bcc/blob/master/tools/tcpstates.py) and noticed very low time for TCP state transition SYN_RECV -> ESTABLISHED

My numbers from tests:

SYN_RECV -> ESTABLISHED 0.015   
SYN_RECV -> ESTABLISHED 0.017   
SYN_RECV -> ESTABLISHED 0.051 

From handshake diagram (https://user-images.githubusercontent.com/1006307/58944706-0ffdb580-878b-11e9-95d3-8e7a4f85d8b0.png) it looks like that transition time from SYN_RECV to ESTABLISHED should be near RTT between hosts?

TCP Fast Open turned off on host.

OS: Ubuntu 18.10 (GNU/Linux 4.18.0-21-generic x86_64)

tcpdump -tttttv output

Receiver got SYN:
 00:00:00.000000 IP (tos 0x28, ttl 49, id 280, offset 0, flags [DF], proto TCP (6), length 60)
    dst_host > src_host: Flags [S], cksum 0x46ae (correct), seq 4063608731, win 29200, options [mss 1460,sackOK,TS val 332512899 ecr 0,nop,wscale 6], length 0

Receiver sent SYN+ACK:
 00:00:00.000071 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto TCP (6), length 60)
    src_host > dst_host: Flags [S.], cksum 0x84c2 (incorrect -> 0x3c01), seq 1516815880, ack 4063608732, win 28960, options [mss 1460,sackOK,TS val 2341429130 ecr 332512899,nop,wscale 7], length 0

Receiver got ACK:
 00:00:00.079183 IP (tos 0x28, ttl 49, id 281, offset 0, flags [DF], proto TCP (6), length 52)
    dst_host > src_host: Flags [.], cksum 0xda11 (correct), ack 1, win 457, options [nop,nop,TS val 332512918 ecr 2341429130], length 0

such low numbers are between syn_recv and syn+ack send, but between syn_recv and established it should be 00:00:00.079183

ping between hosts in this tcpdump is around 83ms

Is it bug or i'm wrong?
