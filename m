Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D9B52AE3C
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 00:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbiEQWdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 18:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiEQWdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 18:33:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727483EABD;
        Tue, 17 May 2022 15:33:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C93356132C;
        Tue, 17 May 2022 22:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E060AC385B8;
        Tue, 17 May 2022 22:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652826808;
        bh=fMWd8B6Azz1Yz4Q3JOgMXGVN+v5a30E1TxzHvyasM/E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ef8kauu7i4yL96jbmNJ8mid/7sgRdte2U9SyhJ5bRw/wbmgD6shB6YPtkZAwhJda8
         kWpfVmxQ/tGMgicfnMaqkXz0BG9a6U50A+Kc8UNDkr3tvKoJ18kv9fh9Fd0d7pzrzR
         KKB02cmMlYDKFukiBLCIrmoGs+YJhn6qPkeV2o6MjdnnrbfN/ljm6z2ecXCcgxfcsQ
         g4AF/UcVvryB9rTWbMzG6gW+ptOVJEs0YM68i2XRuZS+uO1CKCF8QLRL/5C/wmCUuf
         o+FpdZ4UJaQyLJGhqP83LlE0FhD/QxuCXZfgxHpazA5Y8D51KLXcFCGhaxKScObtUZ
         TJ4oWJB74GTSg==
Date:   Tue, 17 May 2022 15:33:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next] bonding: netlink error message support for
 options
Message-ID: <20220517153326.1fbbe2cc@kernel.org>
In-Reply-To: <2125.1652821874@famine>
References: <5a6ba6f14b0fad6d4ba077a5230ee71cbf970934.1652819479.git.jtoppins@redhat.com>
        <2125.1652821874@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 14:11:14 -0700 Jay Vosburgh wrote:
> 	If I'm reading the code correctly, rtnl isn't held that long.
> Once the ->doit() returns, rtnl is dropped, but the copy happens later:
> 
> rtnetlink_rcv()
> 	netlink_rcv_skb(skb, &rtnetlink_rcv_msg)
> 		rtnetlink_rcv_msg()	[ as cb(skb, nlh, &extack) ]
> 			rtnl_lock()
> 			link->doit()	[ rtnl_setlink, rtnl_newlink, et al ]
> 			rtnl_unlock()
> 		netlink_ack()
> 
> inside netlink_ack():
> 
>         if (nlk_has_extack && extack) {
>                 if (extack->_msg) {
>                         WARN_ON(nla_put_string(skb, NLMSGERR_ATTR_MSG,
>                                                extack->_msg));
>                 }

Indeed.

> 	Even if the strings have to be constant (via NL_SET_ERR_MSG),
> adding extack messages is likely still an improvement.

At a quick glance it seems like the major use of the printf here is to
point at a particular option. If options are carried in individual
attributes pointing at the right attribute with NL_SET_ERR_MSG_ATTR()
should also be helpful. Maybe that's stating the obvious.
