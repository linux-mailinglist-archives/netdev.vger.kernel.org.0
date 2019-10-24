Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAF8E27FC
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 04:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436656AbfJXCNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 22:13:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40926 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436605AbfJXCNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 22:13:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::b7e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E5D8214B66DB9;
        Wed, 23 Oct 2019 19:13:23 -0700 (PDT)
Date:   Wed, 23 Oct 2019 19:13:20 -0700 (PDT)
Message-Id: <20191023.191320.2221170454789484606.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH net-next] net: of_get_phy_mode: Change API to solve
 int/unit warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191022011817.29183-1-andrew@lunn.ch>
References: <20191022011817.29183-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Oct 2019 19:13:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Tue, 22 Oct 2019 03:18:17 +0200

> Before this change of_get_phy_mode() returned an enum,
> phy_interface_t. On error, -ENODEV etc, is returned. If the result of
> the function is stored in a variable of type phy_interface_t, and the
> compiler has decided to represent this as an unsigned int, comparision
> with -ENODEV etc, is a signed vs unsigned comparision.
> 
> Fix this problem by changing the API. Make the function return an
> error, or 0 on success, and pass a pointer, of type phy_interface_t,
> where the phy mode should be stored.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

So now we have code that uses the 'interface' value without checking
the error return value which means it's potentially uninitialized.

There are also a bunch of reverse christmas tree violations created
by this patch as well :-) :-) :-)
