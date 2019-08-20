Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A7195357
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 03:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbfHTBZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 21:25:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39260 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728647AbfHTBZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 21:25:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20A0014051854;
        Mon, 19 Aug 2019 18:25:23 -0700 (PDT)
Date:   Mon, 19 Aug 2019 18:25:22 -0700 (PDT)
Message-Id: <20190819.182522.414877916903078544.davem@davemloft.net>
To:     yangyingliang@huawei.com
Cc:     netdev@vger.kernel.org, jasowang@redhat.com,
        eric.dumazet@gmail.com, xiyou.wangcong@gmail.com,
        weiyongjun1@huawei.com
Subject: Re: [PATCH v3] tun: fix use-after-free when register netdev failed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566221479-16094-1-git-send-email-yangyingliang@huawei.com>
References: <1566221479-16094-1-git-send-email-yangyingliang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Aug 2019 18:25:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>
Date: Mon, 19 Aug 2019 21:31:19 +0800

> Call tun_attach() after register_netdevice() to make sure tfile->tun
> is not published until the netdevice is registered. So the read/write
> thread can not use the tun pointer that may freed by free_netdev().
> (The tun and dev pointer are allocated by alloc_netdev_mqs(), they can
> be freed by netdev_freemem().)

register_netdevice() must always be the last operation in the order of
network device setup.

At the point register_netdevice() is called, the device is visible globally
and therefore all of it's software state must be fully initialized and
ready for us.

You're going to have to find another solution to these problems.
