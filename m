Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038B84D7919
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 02:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbiCNBfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 21:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbiCNBfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 21:35:42 -0400
Received: from smtp.tom.com (smtprz02.163.net [106.3.154.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDDB325C66
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 18:34:33 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by vip-app02.163.net (Postfix) with ESMTP id 54B3C4400BE
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:34:32 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1647221672; bh=tCwCTuNV8vbPzPftdhc6YfcqI53uXHjpEfLiz8JtAFs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OtkTDZQB7oHyH2BgY2VnloBqnhOYt1Kp/0jAGjVujhMThs97WIUA5D+HpR21FJ6Qf
         wySmuuq/pld+/LxuUlW3eIdAdWGt6diH7YC7/Ngc7X6FqY7K2kWdJ3zEFKpVAgN3ml
         S35tZb17hrUsQmUBbsEg0egvFXxF8c5Lt622WvSg=
Received: from localhost (HELO smtp.tom.com) ([127.0.0.1])
          by localhost (TOM SMTP Server) with SMTP ID 631174632
          for <netdev@vger.kernel.org>;
          Mon, 14 Mar 2022 09:34:32 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at mxtest.tom.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1647221672; bh=tCwCTuNV8vbPzPftdhc6YfcqI53uXHjpEfLiz8JtAFs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OtkTDZQB7oHyH2BgY2VnloBqnhOYt1Kp/0jAGjVujhMThs97WIUA5D+HpR21FJ6Qf
         wySmuuq/pld+/LxuUlW3eIdAdWGt6diH7YC7/Ngc7X6FqY7K2kWdJ3zEFKpVAgN3ml
         S35tZb17hrUsQmUBbsEg0egvFXxF8c5Lt622WvSg=
Received: from localhost (unknown [101.93.196.13])
        by antispamvip.163.net (Postfix) with ESMTPA id 96EAA154146C;
        Mon, 14 Mar 2022 09:34:29 +0800 (CST)
Date:   Mon, 14 Mar 2022 09:34:29 +0800
From:   Mingbao Sun <sunmingbao@tom.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
Subject: Re: [PATCH v2 2/3] nvme-tcp: support specifying the
 congestion-control
Message-ID: <20220314093429.00005b95@tom.com>
In-Reply-To: <7121e4be-0e25-dd5f-9d29-0fb02cdbe8de@grimberg.me>
References: <20220311103414.8255-1-sunmingbao@tom.com>
        <20220311103414.8255-2-sunmingbao@tom.com>
        <7121e4be-0e25-dd5f-9d29-0fb02cdbe8de@grimberg.me>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before answering the questions, I=E2=80=99d like to address the motivation
behind this patchset.

You know, InfiniBand/RoCE provides NVMe-oF a lossless network
environment (that is zero packet loss), which is a great advantage
to performance.

In contrast, 'TCP/IP + ethernet' is often used as a lossy network
environment (packet dropping often occurs).=20
And once packet dropping occurs, timeout-retransmission would be
triggered. But once timeout-retransmission was triggered, bandwidth
would drop to 0 all of a sudden. This is great damage to performance.

So although NVMe/TCP may have a bandwidth competitive to that of
NVMe/RDMA, but the packet dropping of the former is a flaw to
its performance.

However, with the combination of the following conditions, NVMe/TCP
can become much more competitive to NVMe/RDMA in the data center.

  - Ethernet NICs supporting QoS configuration (support mapping TOS/DSCP
    in IP header into priority, supporting adjusting buffer size of each
    priority, support PFC)

  - Ethernet Switches supporting ECN marking, supporting adjusting
    buffer size of each priority.

  - NVMe/TCP supports specifying the tos for its TCP traffic
    (already implemented)

  - NVMe/TCP supports specifying dctcp as the congestion-control of its
    TCP sockets (the work of this feature)

So this feature is the last item from the software aspect to form up the
above combination.
