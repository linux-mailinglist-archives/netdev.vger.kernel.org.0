Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0371D6405
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 22:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgEPUfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 16:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726460AbgEPUfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 16:35:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2321DC061A0C;
        Sat, 16 May 2020 13:35:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F4081194478D;
        Sat, 16 May 2020 13:35:09 -0700 (PDT)
Date:   Sat, 16 May 2020 13:35:08 -0700 (PDT)
Message-Id: <20200516.133508.2302524641917348540.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com
Subject: Re: [PATCH net-next v1] hinic: add set_channels ethtool_ops support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200515194212.10381-1-luobin9@huawei.com>
References: <20200515194212.10381-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 May 2020 13:35:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Fri, 15 May 2020 19:42:12 +0000

> add support to change TX/RX queue number with ethtool -L
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

I don't think you are properly following the semantics of this
ethtool command with your changes.

In fact, you are breaking the hinic_get_channels() function which
is properly advertising the ->max_* values currently.  Now it will
return zero.

Whatever is advertised in ->max_* should be the driver's maximum
capabilities.

This means that the user can request anything in the range from '1'
to these max values.

Whatever the user asks for in ->combined_count and elsewhere, you
_MUST_ provide or return an error.

That is not what hinic_set_channels() is doing.  It is using
combined_count as a "limit" rather than the value to use.
