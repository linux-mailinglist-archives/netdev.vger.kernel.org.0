Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465D4154E41
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 22:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbgBFVos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 16:44:48 -0500
Received: from mga04.intel.com ([192.55.52.120]:55693 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbgBFVos (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 16:44:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 13:44:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,411,1574150400"; 
   d="scan'208";a="225156046"
Received: from vcostago-desk1.jf.intel.com ([10.54.70.26])
  by orsmga008.jf.intel.com with ESMTP; 06 Feb 2020 13:44:47 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: [PATCH net v4 0/5] taprio: Some fixes
Date:   Thu,  6 Feb 2020 13:46:05 -0800
Message-Id: <20200206214610.1307191-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Changes from v3:
  - Replaced ENOTSUPP error code with EOPNOTSUPP (Jakub Kicinski);
  - Added the missing policy validation for the flags netlink argument
    (Jakub Kicinski);
  - Fixed the destroy() flow to also destroy the priority to traffic
    class mapping (David Miller);
  - Fixed dropping packets when taprio offloading is used together
    with ETF offloading (more on this below);

Changes from v2:
  - Squashed commits 2/3 and 3/3 into a single one (I think a single
    commit is going to be easier to review);
  - Removed an "improvement" that was causing changes in user visible
    behavior;

Changes from v1:
  - Fixed ignoring the 'flags' argument when adding a new
    instance (Vladimir Oltean);
  - Changed the order of commits;

Updated cover letter:

One bit that might need some attention is the fix for not dropping all
packets when taprio and ETF offloading are used, patch 5/5. The
behavior when the fix is applied is that packets that have a 'txtime'
that would fall outside of their transmission window are now dropped
by taprio. The question that might be raised is: should taprio be
responsible for dropping these packets, or should it be handled lower
in the stack?

My opinion is: taprio has all the information, and it's able to give
feeback to the user. Lower in the stack, those packets might go into
the void, and the only feedback could be a hard to find counter
increasing.

Patch 1/5: Reported by Po Liu, is more of a improvement of usability for
drivers implementing offloading features, now they can rely on the
value of dev->num_tc, instead of going through some hops to get this
value.

Patch 2/5: Use 'q->flags' as the source of truth for the offloading
flags. Tries to solidify the current behavior, while avoiding going
into invalid states, one of which was causing a "rcu stall" (more
information in the commit message).

Patch 3/5: Adds the missing netlink attribute validation for
TCA_TAPRIO_ATTR_FLAGS.

Patch 4/5: Replaces the usage of netdev_set_num_tc() with
netdev_reset_tc() in taprio_destroy(), taprio_destroy() is called when
applying a configuration fails, making sure that the device traffic
class configuration goes back to the default state.

@Vladimir: If possible, I would appreciate your Ack on patch 2/5. I
have been looking at this code for so long that I might have missed
something obvious (and my growing dislike for the word 'flags' may be
affecting my judgement :-).


Vinicius Costa Gomes (5):
  taprio: Fix enabling offload with wrong number of traffic classes
  taprio: Fix still allowing changing the flags during runtime
  taprio: Add missing policy validation for flags
  taprio: Use taprio_reset_tc() to reset Traffic Classes configuration
  taprio: Fix dropping packets when using taprio + ETF offloading

 net/sched/sch_taprio.c | 92 ++++++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 35 deletions(-)

-- 
2.25.0

