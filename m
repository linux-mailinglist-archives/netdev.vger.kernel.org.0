Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8CC262530
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 04:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgIIC25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 22:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgIIC25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 22:28:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3135C061573;
        Tue,  8 Sep 2020 19:28:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 087B411E3E4C2;
        Tue,  8 Sep 2020 19:12:00 -0700 (PDT)
Date:   Tue, 08 Sep 2020 19:28:45 -0700 (PDT)
Message-Id: <20200908.192845.1191873689940729972.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, vigneshr@ti.com,
        m-karicheri2@ti.com, nsekhar@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/9] net: ethernet: ti: ale: add static
 configuration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200907143143.13735-3-grygorii.strashko@ti.com>
References: <20200907143143.13735-1-grygorii.strashko@ti.com>
        <20200907143143.13735-3-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 19:12:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Mon, 7 Sep 2020 17:31:36 +0300

> +	ale_dev_id = cpsw_ale_match_id(cpsw_ale_id_match, params->dev_id);
> +	if (ale_dev_id) {
> +		params->ale_entries = ale_dev_id->tbl_entries;
> +		params->major_ver_mask = ale_dev_id->major_ver_mask;
...
> -	if (!ale->params.major_ver_mask)
> -		ale->params.major_ver_mask = 0xff;

This is exactly the kind of change that causes regressions.

The default for the mask if no dev_id is found is now zero, whereas
before the default mask would be 0xff.

Please don't make changes like this, they are very risky.

In every step of these changes, existing behavior should be maintained
as precisely as possible.  Be as conservative as possible.

