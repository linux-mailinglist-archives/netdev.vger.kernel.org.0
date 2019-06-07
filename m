Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9409138A01
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 14:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbfFGMSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 08:18:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727693AbfFGMSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 08:18:46 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CA55E44BC6;
        Fri,  7 Jun 2019 12:18:40 +0000 (UTC)
Received: from ovpn-204-179.brq.redhat.com (ovpn-204-179.brq.redhat.com [10.40.204.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 666DE7A503;
        Fri,  7 Jun 2019 12:18:34 +0000 (UTC)
Message-ID: <66ee49271b9ecc89cd2ee7b9fbffd298ae219d14.camel@redhat.com>
Subject: Re: [RFC PATCH net-next 1/1] tc-testing: Restore original
 behaviour for namespaces in tdc
From:   Davide Caratti <dcaratti@redhat.com>
To:     Lucas Bates <lucasb@mojatatu.com>, netdev@vger.kernel.org
Cc:     nicolas.dichtel@6wind.com, davem@davemloft.net, jhs@mojatatu.com,
        kernel@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        mleitner@redhat.com, vladbu@mellanox.com,
        Hangbin Liu <haliu@redhat.com>
In-Reply-To: <1559768882-12628-1-git-send-email-lucasb@mojatatu.com>
References: <1559768882-12628-1-git-send-email-lucasb@mojatatu.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 07 Jun 2019 14:18:33 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 07 Jun 2019 12:18:46 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-06-05 at 17:08 -0400, Lucas Bates wrote:
> Apologies for the delay in getting this out. I've been busy
> with other things and this change was a little trickier than
> I expected.
> 
> This patch restores the original behaviour for tdc prior to the
> introduction of the plugin system, where the network namespace
> functionality was split from the main script.
> 
> It introduces the concept of required plugins for testcases,
> and will automatically load any plugin that isn't already
> enabled when said plugin is required by even one testcase.
> 
> Additionally, the -n option for the nsPlugin is deprecated
> so the default action is to make use of the namespaces.
> Instead, we introduce -N to not use them, but still create
> the veth pair.
> 
> Comments welcome!
> ---

hello Lucas,

thanks for the patch, I tested it and verified it successfully on some
items belonging to the 'filter' category.

From what I see, it is a fix for the reported problem (e.g. tests failing
because of 'nsPlugin' uninstalled). And, I want to followup fixing the
bpf.json in tc-actions, so that

# ./tdc.py  -l -c bpf | grep eBPF
 e939: (actions, bpf) Add eBPF action with valid object-file
 282d: (actions, bpf) Add eBPF action with invalid object-file
 
require the buildebpfPlugin (unless anybody disagrees, I will also revert
the meaning of '-B' also, like you did for '-n')

few comments after a preliminary test:
1) the patch still does not cover the two categories that use $DEV2 (i.e.
flower and concurrency still fail in my environment)

2) I've been reported, and reproduced with latest fedora, a problem in
nsPlugin.py. All tests in the 'filter' category still fail, unless I do

# sed -i "s#ip#/sbin/ip#g" nsPlugin.py

otherwise, the 'prepare' stage fails:

# ./tdc.py  -e  5339
 -- ns/SubPlugin.__init__
Test 5339: Del entire fw filter

-----> prepare stage *** Could not execute: "$TC qdisc add dev $DEV1 ingress"

-----> prepare stage *** Error message: "/bin/sh: ip: command not found
"
returncode 127; expected [0]

-----> prepare stage *** Aborting test run.

(maybe we should use a variable for that, instead of hardcoded command
name, like we do for $TC ?)

-- 
davide

