Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A466B847D
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjCMWIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjCMWIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:08:15 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7940F222DB;
        Mon, 13 Mar 2023 15:08:13 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id C6820C009; Mon, 13 Mar 2023 23:08:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1678745291; bh=+3hvHtxOKm+x6xuyu0609vnA9psaq5/XZ9w8PURWMRU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q+2XhhEmo/HDRno8AcK7DIjIlwDBBoI9AjEIliJyR3jmF+Tcrw/QNSnpg5zmoPyGs
         zgvmeDVWk4QBnDDbDxvMBvJyFR2ArH90Q0pL/xDLXD1c5i+ItneOwPw6ofzh13Abg5
         mmpc2ERt94S4gUIWMWTqG9d07BmqM5RZ7LorNsR/7J5u7D7tHy7ousQLhbG4xlfTr5
         83LG1XRtL9wEwDxxwwqT7tB2ygiBhAqP+hSWpU4XcauoFKk5+yehHhf19DWLsTDZ1+
         1wR6mQTd5x4WE0swSdMwBc6bwH9ZAMsrpRb4T7+/bGydM3WJ1/PtU5vqal1Up+yUyL
         DMfCjbo3U17gw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 8E47AC009;
        Mon, 13 Mar 2023 23:08:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1678745290; bh=+3hvHtxOKm+x6xuyu0609vnA9psaq5/XZ9w8PURWMRU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rcbznV7IIhDUoiRMQf+9vd8Sj3wcDKpZ+Cy0hZ3mqu41tU4AP6shdcIuZc/VTPKi4
         GG9CQ2i8yR8P5QwdHxsV50BSKxAM2aZnBEiWErmcj9XF387Nvg3HOOHa4Umow75y5o
         t3UF7DmTP1lARsf0T4cLPpRW7suxpSBcc1SixliJFc5gwo2MB9s8cHw/dHZ2AhspqS
         mR8hU62q1V3+MfSXLNfFmDaPiVOvbn8qzSOKaB/zrUIfC97rkHM3TlCkBdR8UqTPn7
         C6Y633Qb3S/UOxn5ZaUvUZVff+TtMbF8zsXDhomvmK0ANSmA9/knZaQFIJqnFNsKNm
         XJ8RD08WOMuYA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 86503e90;
        Mon, 13 Mar 2023 22:08:03 +0000 (UTC)
Date:   Tue, 14 Mar 2023 07:07:48 +0900
From:   asmadeus@codewreck.org
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Zheng Wang <zyytlz.wz@163.com>, ericvh@gmail.com,
        lucho@ionkov.net, linux_oss@crudebyte.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com
Subject: Re: [PATCH net v2] 9p/xen : Fix use after free bug in
 xen_9pfs_front_remove due  to race condition
Message-ID: <ZA+etMBFSw/999Aq@codewreck.org>
References: <20230313090002.3308025-1-zyytlz.wz@163.com>
 <ZA8rDCw+mJmyETEx@localhost.localdomain>
 <20230313143054.538565ac@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230313143054.538565ac@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote on Mon, Mar 13, 2023 at 02:30:54PM -0700:
> On Mon, 13 Mar 2023 14:54:20 +0100 Michal Swiatkowski wrote:
> > >  	for (i = 0; i < priv->num_rings; i++) {
> > > +		/*cancel work*/  
> > It isn't needed I think, the function cancel_work_sync() tells everything
> > here.
> 
> Note that 9p is more storage than networking, so this patch is likely
> to go via a different tree than us.

Any review done is useful anyway ;)

Either Eric or me will take the patch, but in the past such fixes have
sometimes also been taken into the net tree; honestly I wouldn't mind a
bit more "rule" here as it's a bit weird that some of our patches are Cc
to fsdevel@ (fs/ from fs/9p) and the other half netdev@ (net/ from
net/9p), but afaict the MAINTAINERS syntax doesn't have a way of
excluding e.g. net/9p from the `NETWORKING [GENERAL]` group so I guess
we just have to live with that.

There's little enough volume and netdev automation sends a mail when a
patch is picked up, so as long as there's no conflict (large majority of
the cases) such fixes can go either way as far as I'm concerned.

-- 
Dominique
