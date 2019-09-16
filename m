Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91866B3D17
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 17:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730546AbfIPPEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 11:04:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50315 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbfIPPEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 11:04:10 -0400
Received: from static-dcd-cqq-121001.business.bouyguestelecom.com ([212.194.121.1] helo=nyx.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1i9sXk-0003Vy-3Y; Mon, 16 Sep 2019 15:03:56 +0000
Received: by nyx.localdomain (Postfix, from userid 1000)
        id D01D5240611; Mon, 16 Sep 2019 17:03:55 +0200 (CEST)
Received: from nyx (localhost [127.0.0.1])
        by nyx.localdomain (Postfix) with ESMTP id C9F13289C50;
        Mon, 16 Sep 2019 17:03:55 +0200 (CEST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jiri Pirko <jiri@resnulli.us>
cc:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, vfalico@gmail.com, andy@greyhouse.net,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com
Subject: Re: [PATCH net v3 03/11] bonding: fix unexpected IFF_BONDING bit unset
In-reply-to: <20190916144930.GO2286@nanopsycho.orion>
References: <20190916134802.8252-1-ap420073@gmail.com> <20190916134802.8252-4-ap420073@gmail.com> <20190916144930.GO2286@nanopsycho.orion>
Comments: In-reply-to Jiri Pirko <jiri@resnulli.us>
   message dated "Mon, 16 Sep 2019 16:49:30 +0200."
X-Mailer: MH-E 8.5+bzr; nmh 1.7.1-RC3; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29227.1568646235.1@nyx>
Date:   Mon, 16 Sep 2019 17:03:55 +0200
Message-ID: <29228.1568646235@nyx>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Pirko <jiri@resnulli.us> wrote:

>Mon, Sep 16, 2019 at 03:47:54PM CEST, ap420073@gmail.com wrote:
>>The IFF_BONDING means bonding master or bonding slave device.
>>->ndo_add_slave() sets IFF_BONDING flag and ->ndo_del_slave() unsets
>>IFF_BONDING flag.
>>
>>bond0<--bond1
>>
>>Both bond0 and bond1 are bonding device and these should keep having
>>IFF_BONDING flag until they are removed.
>>But bond1 would lose IFF_BONDING at ->ndo_del_slave() because that routine
>>do not check whether the slave device is the bonding type or not.
>>This patch adds the interface type check routine before removing
>>IFF_BONDING flag.
>>
>>Test commands:
>>    ip link add bond0 type bond
>>    ip link add bond1 type bond
>>    ip link set bond1 master bond0
>>    ip link set bond1 nomaster
>>    ip link del bond1 type bond
>>    ip link add bond1 type bond
>
>Interesting. I wonder why bond-in-bond is not forbidden...

	I think mostly because nesting wasn't originally forbidden, and
there are apparently users of it out in the wild, judging from the
number of times I see configurations or queries about an active-backup
bond with two 802.3ad bonding slaves.  That particular configuration
doesn't have any advantage (802.3ad will internally manage that
situation), but I don't see that we can now forbid nesting bonds without
potentially breaking existing user space configurations.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
