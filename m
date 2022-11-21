Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F21632C78
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiKUS6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiKUS6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:58:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA5CC72F2
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:58:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B5E46142D
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47959C433D6;
        Mon, 21 Nov 2022 18:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669057122;
        bh=QjNzKdbTsJioXsSph0J6Yn94Lp4d8+3kVhp8nY6a8RM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t+YRR7SBhRW9T+t5FpdUQrrrFjVOGk0QF63tr7bt0PJ0qsse50sDwlYcViR8vQEmY
         uHjTg925445bxWI+zbVM/8BKcGrmgxv7pXfQ79lE+nVweZ6Y6fFv19wZ01gxhFCtlk
         yET3RnJUER5OczuDTwiKY9tMyEh3Q4El7HnasgcgPFIIGLohQpL2CIsx6JBDOIlQQf
         bEZViGwv6QD+w1zCbNApAWNW86p59rj4V9zQKx8JUxS9qeN2kDv0xb4RFJwDL9ssmn
         VD1wi7qDgl+obxMjFdbnzZ+sTInkNcIxfgBE/YTVXr3YoIYnvcdXWpP03IPBQSvWXQ
         Bi/URHIgzD6ng==
Date:   Mon, 21 Nov 2022 10:58:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next v3] ethtool: add netlink based get rss support
Message-ID: <20221121105841.214ce8e2@kernel.org>
In-Reply-To: <20221120210217.zcdmr47r6ck33cf4@lion.mk-sys.cz>
References: <20221116232554.310466-1-sudheer.mogilappagari@intel.com>
        <Y3dgpNASNn6pvT05@electric-eye.fr.zoreil.com>
        <IA1PR11MB6266E62A4F46CCE62C053451E40B9@IA1PR11MB6266.namprd11.prod.outlook.com>
        <20221120210217.zcdmr47r6ck33cf4@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Nov 2022 22:02:17 +0100 Michal Kubecek wrote:
> That would leave us with two questions:

Here's my 2 cents:

> 1. What to do with ETHTOOL_GRXRING? Can we use ETHTOOL_MSG_RINGS_GET as
> it is? (I.e. should the count be always equal to rx + combined?) If not,
> should we extend it or put the count into ETHTOOL_MSG_RSS_GET?

That'd be great.. but there are drivers out there for which 
rx + combined is incorrect.

Maybe we need to add an attr to ETHTOOL_MSG_RINGS_GET which core will
fill in by default to rx + combined but broken drivers can correct it
to whatever is right for them?

We can either create that attr already or wait for someone to complain?
The same info is needed to size AF_XDP tables, which was a bit of a
unifying force to do the right thing (i.e. make rx + combined correct).

I'm torn, because I'm happy for the driver authors who got this wrong
to suffer and get complaints. But that implies that users also suffer
which is not cool :(

> 2. What would be the best way to handle creation and deletion of RSS
> contexts? I guess either a separate message type or combining the
> functionality into ETHTOOL_MSG_RSS_SET somehow (but surely not via some
> magic values like it's done in ioctl).

Explicit RSS_CTX_ADD / RSS_CTX_DEL seems reasonable. And we should have
the core keep an explicit list of the contexts while at it :/
