Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA129A3A9
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405597AbfHVXTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:19:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50442 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731662AbfHVXTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 19:19:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B84561539D813;
        Thu, 22 Aug 2019 16:19:13 -0700 (PDT)
Date:   Thu, 22 Aug 2019 16:19:13 -0700 (PDT)
Message-Id: <20190822.161913.326746900077543343.davem@davemloft.net>
To:     jeffv@google.com
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
Subject: Re: [PATCH 1/2] rtnetlink: gate MAC address with an LSM hook
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190821134547.96929-1-jeffv@google.com>
References: <20190821134547.96929-1-jeffv@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 16:19:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Vander Stoep <jeffv@google.com>
Date: Wed, 21 Aug 2019 15:45:47 +0200

> MAC addresses are often considered sensitive because they are
> usually unique and can be used to identify/track a device or
> user [1].
> 
> The MAC address is accessible via the RTM_NEWLINK message type of a
> netlink route socket[2]. Ideally we could grant/deny access to the
> MAC address on a case-by-case basis without blocking the entire
> RTM_NEWLINK message type which contains a lot of other useful
> information. This can be achieved using a new LSM hook on the netlink
> message receive path. Using this new hook, individual LSMs can select
> which processes are allowed access to the real MAC, otherwise a
> default value of zeros is returned. Offloading access control
> decisions like this to an LSM is convenient because it preserves the
> status quo for most Linux users while giving the various LSMs
> flexibility to make finer grained decisions on access to sensitive
> data based on policy.
> 
> [1] https://adamdrake.com/mac-addresses-udids-and-privacy.html
> [2] Other access vectors like ioctl(SIOCGIFHWADDR) are already covered
> by existing LSM hooks.
> 
> Signed-off-by: Jeff Vander Stoep <jeffv@google.com>

I'm sure the MAC address will escape into userspace via other means,
dumping pieces of networking config in other contexts, etc.  I mean,
if I can get a link dump, I can dump the neighbor table as well.

I kinda think this is all very silly whack-a-mole kind of stuff, to
be quite honest.

And like others have said, tomorrow you'll be like "oh crap, we should
block X too" and we'll get another hook, another config knob, another
rulset update, etc.
