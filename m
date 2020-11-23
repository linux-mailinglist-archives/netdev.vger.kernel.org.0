Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1178E2BFFE2
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 07:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgKWGSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 01:18:15 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:41501 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgKWGSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 01:18:15 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kh5Av-0005Mz-SP; Mon, 23 Nov 2020 07:18:09 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kh5Au-0005Mn-OT; Mon, 23 Nov 2020 07:18:08 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 50DED240041;
        Mon, 23 Nov 2020 07:18:08 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id E4FAA240040;
        Mon, 23 Nov 2020 07:18:07 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 72EE020624;
        Mon, 23 Nov 2020 07:18:07 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 23 Nov 2020 07:18:07 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5] net/tun: Call netdev notifiers
Organization: TDT AG
In-Reply-To: <20201120102827.6b432dc5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201118063919.29485-1-ms@dev.tdt.de>
 <20201120102827.6b432dc5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <a00d2725bce23f451cd030b9e621a764@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-type: clean
X-purgate-ID: 151534::1606112289-000074F7-130D8890/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-20 19:28, Jakub Kicinski wrote:
> On Wed, 18 Nov 2020 07:39:19 +0100 Martin Schiller wrote:
>> Call netdev notifiers before and after changing the device type.
>> 
>> Signed-off-by: Martin Schiller <ms@dev.tdt.de>
> 
> This is a fix, right? Can you give an example of something that goes
> wrong without this patch?

This change is related to my latest patches to the X.25 Subsystem:
https://patchwork.kernel.org/project/netdevbpf/list/?series=388087

I use a tun interface in a XoT (X.25 over TCP) application and use the
TUNSETLINK ioctl to change the device type to ARPHRD_X25.
As the default device type is ARPHRD_NONE the initial NETDEV_REGISTER
event won't be catched by the X.25 Stack.

Therefore I have to use the NETDEV_POST_TYPE_CHANGE to make sure that
the corresponding neighbour structure is created.

I could imagine that other protocols have similar requirements.

Whether this is a fix or a functional extension is hard to say.

Some time ago there was also a corresponding patch for the WAN/HDLC
subsystem:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit?id=2f8364a291e8
