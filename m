Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F43460BFA1
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 02:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiJYAdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 20:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiJYAdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 20:33:09 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3060820347;
        Mon, 24 Oct 2022 15:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666652281; x=1698188281;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/QFYcqzzhog465CEp7hJCINJC63rwNPJ/l0XxVVSM6g=;
  b=IphW3CK6tjTAbqJpyvEU5yD+tVjeukfE0aGA9BR5AnSK/KieuDcM1yT8
   5ebACnvzZEQ4A4odoBErIgAmiIuTzSLVj6oF28kClfGeOrIX39sYggBeZ
   tIP/09DEy6WgTrX29qzOIEi1GXRNgnP2x9u0ypx24JpCdddvoyhEfz9SJ
   MQ/Nc30R4B4Vz/x6Jfw8o1DtKcZvFGmLhrO7GmJNXdIVs8ugOpUy2ZZ+j
   pHTSvedNCrVFEYZ3yLIi2hXt/0dmT4SxE3L5dLyHxerecemflRhzJDEk5
   yjyDN6y4zwx7NzCftQUKAmVhb6f2IJfmpSfw9HgPmj9Y8ca7OrLfHtxOR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="308633271"
X-IronPort-AV: E=Sophos;i="5.95,210,1661842800"; 
   d="scan'208";a="308633271"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 15:57:56 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="609363400"
X-IronPort-AV: E=Sophos;i="5.95,210,1661842800"; 
   d="scan'208";a="609363400"
Received: from pkearns-mobl1.amr.corp.intel.com (HELO guptapa-desk.intel.com) ([10.252.131.64])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 15:57:55 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     scott.d.constable@intel.com, daniel.sneddon@linux.intel.com,
        Jakub Kicinski <kuba@kernel.org>, dave.hansen@intel.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Paolo Abeni <pabeni@redhat.com>,
        antonio.gomez.iglesias@linux.intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, gregkh@linuxfoundation.org, netdev@vger.kernel.org
Subject: [RFC PATCH 0/2] Branch Target Injection (BTI) gadget in minstrel
Date:   Mon, 24 Oct 2022 15:57:45 -0700
Message-Id: <cover.1666651511.git.pawan.kumar.gupta@linux.intel.com>
X-Mailer: git-send-email 2.37.3
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

There is a theoretical possibility of using
minstrel_ht_get_expected_throughput() as a disclosure gadget for Branch
History Injection (BHI)/Intra-mode Branch Target Injection (IMBTI) [1].
Requesting feedback on the couple of patches that mitigates this.

First patch adds a generic speculation barrier. Second patch uses the
speculation barrier to mitigate BHI/IMBTI.

The other goal of this series is to start a discussion on whether such
hard to exploit, but theoretical possible attacks deems to be mitigated.

In general Branch Target Injection class of attacks involves an adversary
controlling an indirect branch target to misspeculate to a disclosure gadget.
For a successful attack an adversary also needs to control the register
contents used by the disclosure gadget.

Assuming preconditions are met, a disclosure gadget would transiently do
below:

  1. Loads an attacker chosen data from memory.
  2. Based on the data, modifies cache state that is observable by an attacker.

Although both these operations are architecturally invisible, the cache state
changes could be used to infer the data.

Disclosure gadget is mitigated by adding a speculation barrier.

Thanks,
Pawan

[1] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html

Pawan Gupta (2):
  nospec: Add a generic barrier_nospec()
  minstrel_ht: Mitigate BTI gadget minstrel_ht_get_expected_throughput()

 include/linux/nospec.h             | 4 ++++
 net/mac80211/rc80211_minstrel_ht.c | 9 +++++++++
 2 files changed, 13 insertions(+)

-- 
2.37.3

