Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CE14AF0B3
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbiBIMDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiBIMDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:03:17 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2195C050CE7
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 03:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644407040; x=1675943040;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=9rGhYhuXA4MwqVBCxk0B3yOOkgj4GUGu6Cm2TW7ZtkI=;
  b=l9YPH8nNYICQEOasre5ebWC8gRMNOKlUgO8ea0QEYsCL5qE8AlIHSUo5
   OaEUOzBkmRXgYaHSXtjzXcXg3uzQjP1+rBrmFlNsozUQR0RsgluuSL1Pd
   LI/JphO7Bc+EaXFZ1EPyESyZmaAoUvl6RVDu5s/c2sEdMtPs/iS5Mg/40
   8ywZO5Wy8erRaD/bUbwnNRnHLEF//qKr1Y26615zHBUdVFKxoacNbkB5A
   KdcUBXtKmmX6NreVuQZ8jawSYeTRgMl6u3mJh+z4AtDi3gUFa8bWfhYZS
   81QnJTnaxjnlsgQSVds1HCgr48uZunT06R57iw8sz8U1er3QKRBdttwsQ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="312480445"
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="312480445"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 03:44:00 -0800
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="541059612"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 03:43:57 -0800
Date:   Wed, 9 Feb 2022 03:45:06 -0500
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     tparkin@katalix.com, jiri@resnulli.us, jhs@mojatatu.com,
        boris.sukholitko@broadcom.com, felipe@sipanda.io, tom@sipanda.io,
        sridhar.samudrala@intel.com, marcin.szycik@linux.intel.com,
        wojciech.drewek@intel.com, grzegorz.nitka@intel.com,
        michal.swiatkowski@intel.com
Subject: hw offload for new protocols
Message-ID: <YgN/EiV/di4vtzdE@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I would like to add matching on values from protocol that isn't yet
supported in kernel, but my hw has abilitty to offload it (session id
in pfcp for example).
What is a correct way to implement it in kernel? I was searching on ML
for threads about that but I didn't find answer to all my concerns.

I assume that for hw offload we should reuse tc flower, which already
has great ability to offload bunch of widely used protocols. To match on
my session id value I will for sure have to add another field in tc
(user and kernel part). Something like this:
#tc filter add dev $DEV protocol ip parent ffff: flower dst_ip $IP
session_id 0102030405060708 action drop

Should SW path be also supported? I think that yes, so, this will
need adding handling this new field in flow_dissector. I have read
thread with adding new field to it [1] and my feeling from it is: better
do not add new fields there :) . However, if it is fine to expand
flow_dissector, how to do it in this particular case? Can I check udp
port in flow dissector code and based on that dissect session id from
pfcp header? Won't this lead to a lot of new code for each different
protocols based on well known port numbers?

What about $DEV from tc command? In hw offload for example for VXLAN or
geneve based on this hw knows what type of flow should be offloaded. It
will be great to have the same ability for pfcp (in my case), to allow
adding rule without pfcp specific fileds:
#tc filter add dev $PFCP_DEV protocol ip parent ffff: flower dst_ip $IP
action drop
Or maybe in this kind of flows we should always add in tc flower correct
port number which will tell hw that this flow is pfcp?
#tc filter add dev $DEV protocol ip parent ffff: flower dst_ip $IP
enc_dst_port $well_know_pfcp action drop

If creating new netdev (pfcp in this case) is fine solution, how pfcp
driver should look like? Is code for receiving and xmit sufficient? Or
is there need to implement more pfcp features in the new driver? To not
have sth like dummy pfcp driver only to point to it in tc. There was
review with virtual netdev [2] - which drops every packet that returns from
classyfing (I assume not offloaded by hw). Maybe this solution is
better?

I have also seen panda (flower 2) [3]. It isn' available in kernel now.
Do we know timeline for this feature? From review discussion I don't
know if it allow offloading cases like my in hw which wasn't design to
support panda offload.

I feel like I can solve all my concerns using u32 classifier (but I can
be wrong). I thought about creating user space app that will translate
human readable command to u32. Hw will try to offload u32 command if
given flow can be offloaded, if not software path will work as usally. I
have seen that few drivers support u32 offload, but it looks like the
code is from before creation of flower classifier. Do You know if
someone try this combination (user app + u32 + hw offload)?

I am talking about pfcp, but there is few more protocols that hw can
offload, but lack of support in flow dissector is successfully
complicating hw offload.

Thanks for any comments about this topic,
Michal


[1] https://lore.kernel.org/netdev/20210830080800.18591-1-boris.sukholitko@broadcom.com/
[2] https://lore.kernel.org/netdev/20210929094514.15048-1-tparkin@katalix.com/
[3] https://lore.kernel.org/netdev/20210916200041.810-1-felipe@expertise.dev/
