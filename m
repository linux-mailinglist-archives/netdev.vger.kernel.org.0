Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77859204446
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 01:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731423AbgFVXHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 19:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgFVXHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 19:07:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44563C061573;
        Mon, 22 Jun 2020 16:07:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B1BDA1296E6DB;
        Mon, 22 Jun 2020 16:07:13 -0700 (PDT)
Date:   Mon, 22 Jun 2020 16:07:12 -0700 (PDT)
Message-Id: <20200622.160712.2300967026610181117.davem@davemloft.net>
To:     horatiu.vultur@microchip.com
Cc:     nikolay@cumulusnetworks.com, UNGLinuxDriver@microchip.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Resend PATCH net] bridge: uapi: mrp: Fix MRP_PORT_ROLE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200620131403.2680293-1-horatiu.vultur@microchip.com>
References: <20200620131403.2680293-1-horatiu.vultur@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 16:07:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Sat, 20 Jun 2020 15:14:03 +0200

> Currently the MRP_PORT_ROLE_NONE has the value 0x2 but this is in conflict
> with the IEC 62439-2 standard. The standard defines the following port
> roles: primary (0x0), secondary(0x1), interconnect(0x2).
> Therefore remove the port role none.
> 
> Fixes: 4714d13791f831 ("bridge: uapi: mrp: Add mrp attributes.")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

The code accepts arbitrary 32-bit values for the role in a configuration
but only PRIMARY and SECONDARY seem to be valid.

There is no validation that the value used makes sense.

In the future if we handle type interconnect, and we add checks, it will
break any existing applications.  Because they can validly pass any
non-zero valid and the code treats that as SECONDARY currently.

So you really can't just remove NONE, you have to add validation code
too so we don't run into problem in the future.

Thanks.
