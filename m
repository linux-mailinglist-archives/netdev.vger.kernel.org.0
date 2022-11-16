Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3CFC62CE18
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 23:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbiKPWzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 17:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbiKPWzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 17:55:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07516829A;
        Wed, 16 Nov 2022 14:55:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 19FD9CE1CB6;
        Wed, 16 Nov 2022 22:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE787C433C1;
        Wed, 16 Nov 2022 22:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668639313;
        bh=XizNiSjp3B35oeU+BjEgfF3IZslow0qbi0aTDe+NPl0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CJglNzJfwlcZsPggiwgGVpQIX19M9BHcR87QFtCKY+hLzMRPNvtzHJ2010RFJw92i
         mDTGEfbH2ox69i7XY5UsvU1Gm/DPWt7jdlLxC7+E4u3j7/OP5gxnjzGXaP2p27L79c
         JW5Lcfwn1tkmtTXcB1Z/b0F+vsS74izzGqQ1mrnPgJ/wohtwymYdLj0nUSnteAMsf5
         jqHcIckv3OKBX9Zk6eBnT4LXKF05QN7KA3JSTGW3rPw/JwFY542MuJeYqwpqweXgvo
         Er8YxUvaxkHNrA4SQfRTHF2+mTOtDGWm24+AJEo6OoERravBYI8Ho//s+zipvGKdT2
         VNxbMx3Mrek4w==
Date:   Wed, 16 Nov 2022 14:55:12 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Daniil Tatianin <d-tatianin@yandex-team.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Marco Bonelli <marco@mebeim.net>, Tom Rix <trix@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org, yc-core@yandex-team.ru
Subject: Re: [PATCH v1] net/ethtool/ioctl: ensure that we have phy ops before
 using them
Message-ID: <Y3VqUBUXdMrt4iAC@x130.lan>
References: <20221114081532.3475625-1-d-tatianin@yandex-team.ru>
 <20221114210705.216996a9@kernel.org>
 <Y3Oy14CNVEttEI7T@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y3Oy14CNVEttEI7T@lunn.ch>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Nov 16:40, Andrew Lunn wrote:
>On Mon, Nov 14, 2022 at 09:07:05PM -0800, Jakub Kicinski wrote:
>> On Mon, 14 Nov 2022 11:15:32 +0300 Daniil Tatianin wrote:
>> > +	if (!(phydev && phy_ops && phy_ops->get_stats) &&
>> > +	    !ops->get_ethtool_phy_stats)
>>
>> This condition is still complicated.
>>
>> > +		return -EOPNOTSUPP;
>>
>> The only way this crash can happen is if driver incorrectly returns
>> non-zero stats count but doesn't have a callback to read the stats.
>> So WARN_ON() would be in order here.
>
>Hi Daniil
>
>I'm missing the patch itself, and b4 does not return it. Please

same! I only see Jakub's reply, maybe the patch didn't make it through to
netdev ML ? 

