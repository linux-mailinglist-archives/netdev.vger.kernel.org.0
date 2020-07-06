Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC6C215F4C
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgGFT02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgGFT02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 15:26:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B673C061755;
        Mon,  6 Jul 2020 12:26:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A8B21277D626;
        Mon,  6 Jul 2020 12:26:27 -0700 (PDT)
Date:   Mon, 06 Jul 2020 12:26:26 -0700 (PDT)
Message-Id: <20200706.122626.2248567362397969247.davem@davemloft.net>
To:     horatiu.vultur@microchip.com
Cc:     nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        kuba@kernel.org, jiri@resnulli.us, ivecera@redhat.com,
        andrew@lunn.ch, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 01/12] switchdev: mrp: Extend switchdev API
 for MRP Interconnect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200706091842.3324565-2-horatiu.vultur@microchip.com>
References: <20200706091842.3324565-1-horatiu.vultur@microchip.com>
        <20200706091842.3324565-2-horatiu.vultur@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jul 2020 12:26:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Mon, 6 Jul 2020 11:18:31 +0200

> +/* SWITCHDEV_OBJ_ID_IN_TEST_MRP */
> +struct switchdev_obj_in_test_mrp {
> +	struct switchdev_obj obj;
> +	/* The value is in us and a value of 0 represents to stop */
> +	u32 interval;
> +	u8 max_miss;
> +	u32 in_id;
> +	u32 period;
> +};
 ...
> +#define SWITCHDEV_OBJ_IN_TEST_MRP(OBJ) \
> +	container_of((OBJ), struct switchdev_obj_in_test_mrp, obj)
> +
> +/* SWICHDEV_OBJ_ID_IN_ROLE_MRP */
> +struct switchdev_obj_in_role_mrp {
> +	struct switchdev_obj obj;
> +	u16 in_id;
> +	u32 ring_id;
> +	u8 in_role;
> +	struct net_device *i_port;
> +};
 ...
> +#define SWITCHDEV_OBJ_IN_ROLE_MRP(OBJ) \
> +	container_of((OBJ), struct switchdev_obj_in_role_mrp, obj)
> +
> +struct switchdev_obj_in_state_mrp {
> +	struct switchdev_obj obj;
> +	u8 in_state;
> +	u32 in_id;
> +};

Please arrange these structure members in a more optimal order so that
the resulting object is denser.  For example, in switchdev_obj_in_role_mrp
if you order it such that:

> +	u32 ring_id;
> +	u16 in_id;
> +	u8 in_role;

You'll have less wasted space from padding.

Use 'pahole' or similar tools to guide you.
