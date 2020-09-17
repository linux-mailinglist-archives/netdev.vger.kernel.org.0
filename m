Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A82E26E65C
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgIQUM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgIQUM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:12:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B94C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:12:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 32DAB135EBB70;
        Thu, 17 Sep 2020 12:55:37 -0700 (PDT)
Date:   Thu, 17 Sep 2020 13:12:23 -0700 (PDT)
Message-Id: <20200917.131223.1581791862348029357.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     shayagr@amazon.com, netdev@vger.kernel.org, dwmw@amazon.com,
        zorik@amazon.com, matua@amazon.com, saeedb@amazon.com,
        msw@amazon.com, aliguori@amazon.com, nafea@amazon.com,
        gtzalik@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, akiyano@amazon.com, sameehj@amazon.com,
        ndagan@amazon.com, amitbern@amazon.com
Subject: Re: [PATCH V1 net-next 2/8] net: ena: Add device distinct log
 prefix to files
From:   David Miller <davem@davemloft.net>
In-Reply-To: <339bb56eebdddbefb5da87d4f97b7bbe74e9f4b4.camel@kernel.org>
References: <20200913.143022.1949357995189636518.davem@davemloft.net>
        <pj41zlk0wsdyy7.fsf@u68c7b5b1d2d758.ant.amazon.com>
        <339bb56eebdddbefb5da87d4f97b7bbe74e9f4b4.camel@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 12:55:37 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeed@kernel.org>
Date: Thu, 17 Sep 2020 12:38:28 -0700

> allocated but unregistered netdevices also do not help much as the name
> of the netdev is not assigned yet.
> 
> why don't use dev_info(pci_dev) macors  for low level functions when
> netdev is not available or not allocated yet.

The problem in this case is that they have this huge suite of
functions that operate on a specific ena sub-object.  Most of the time
the associated netdev is fully realized, but in the few calls made
during early probe it is not.

To me it is a serious loss that just because a small number of times
the interface lacks a fully realized netdev object, we can't use the
netdev_*() routines.

Most users aren't going to understand that an error message for PCI
device XyZ means eth0 is having problems.
