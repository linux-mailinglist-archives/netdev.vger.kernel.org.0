Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475DB50AEA2
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 05:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443829AbiDVDxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 23:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236246AbiDVDxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 23:53:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A18F4755A
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 20:50:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3344DB828C8
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC602C385A0;
        Fri, 22 Apr 2022 03:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650599450;
        bh=fbwG8LVJqfrl++SEEjt5Aqsc4VlqkDKGl6tEUtHuGPU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jvQWcNfz5So/HzL/eSFwDfCpjK1+o0HbAQ30svgDXnxoQZJ94n8DzJXNsJZGv7AZ0
         5wYghuShOde4F3YOv8UZyA3h4ubxeH5AwoIJ3kADfH39z4drC4FTIMNNK1Bfy8Ly9l
         xNuxJlHVnDQt5SoDVy/XKdsx5PrZk889L2zPYTgxWusqT113A07aEYdBZDjTZd/W3d
         /lvkBjva86ggXHxSr6z5DD0r2goYs168+xep64QVA18O2yLqkEbMCNtrEVjdd41hv0
         gYWJQahGqR5IxeL+eNHvCEJIe603EVP5yGHEHPocYCLAat5dULOds9kvGsngh3OJOy
         bmx2EA/EMPqNw==
Date:   Thu, 21 Apr 2022 20:50:49 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        edumazet@google.com, Brian Baboch <brian.baboch@wifirst.fr>
Subject: Re: [PATCH v3 net-next 4/4] rtnetlink: return EINVAL when request
 cannot succeed
Message-ID: <20220422035049.lkdmvfhznfbwk7jw@sx1>
References: <20220405134237.16533-1-florent.fourcot@wifirst.fr>
 <20220405134237.16533-4-florent.fourcot@wifirst.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220405134237.16533-4-florent.fourcot@wifirst.fr>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05 Apr 15:42, Florent Fourcot wrote:
>A request without interface name/interface index/interface group cannot
>work. We should return EINVAL
>
>Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
>Signed-off-by: Brian Baboch <brian.baboch@wifirst.fr>
>---
> net/core/rtnetlink.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>index e93f4058cf08..690324479cf5 100644
>--- a/net/core/rtnetlink.c
>+++ b/net/core/rtnetlink.c
>@@ -3420,7 +3420,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
> 			return rtnl_group_changelink(skb, net,
> 						nla_get_u32(tb[IFLA_GROUP]),
> 						ifm, extack, tb);
>-		return -ENODEV;
>+		return -EINVAL;
> 	}

This introduced a regression iproute2->iplink_have_newlink() checks this
return value to determine if newlink is supported by kernel, if the
returned value is -EINVAL iproute2 falls back to ioctl mode, any value
other than -EINVAL or -EOPNOTSUPP should be ok here to not break compatibility
with iproute2.

