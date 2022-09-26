Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E115EB5BC
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 01:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiIZX1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 19:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiIZX1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 19:27:44 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328F96EF32
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 16:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664234864; x=1695770864;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=B5Yg2idHOkhfeyKnOqdWAauDKv7lxxhtXBCixX+H1Hc=;
  b=d2IVe2q7SNG9056NpFG4ibLhYZi3mzPYfU9pvhZ8SIXk62SibFwVz2Qk
   nWEqS8jDhW3lOqS8v6pJOB2o67jiOAR0fxXcsbxgAi/q/iefjZqV1G94M
   cCOZY9AT3S7FybKa8uwh4gb6C1WT4+WvOZRFWWyvhonKq4RGjUeIr3jnP
   jAiPsO1B6+BwO81E2nde2xMAIOIlfi0v5pfkEoQwPzo6vixdQoE4UryAF
   NDqw3tp5yggUlDFN1BOVA426GtkbzxG+Hnl0QEm7mJ2BQ+jWG2vj0dwPj
   ktWj3ukezrXjoxpLKwwzNAheOtkRm8katP62bAGq+6ZxX3Uin3Lx/Zfzf
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="280890864"
X-IronPort-AV: E=Sophos;i="5.93,347,1654585200"; 
   d="scan'208";a="280890864"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 16:27:43 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="572424284"
X-IronPort-AV: E=Sophos;i="5.93,347,1654585200"; 
   d="scan'208";a="572424284"
Received: from sankarka-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.3.132])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 16:27:43 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dmytro@shytyi.net,
        benjamin.hesmans@tessares.net, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/4] mptcp: MPTCP support for TCP_FASTOPEN_CONNECT
Date:   Mon, 26 Sep 2022 16:27:35 -0700
Message-Id: <20220926232739.76317-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC 8684 appendix B describes how to use TCP Fast Open with MPTCP. This
series allows TFO use with MPTCP using the TCP_FASTOPEN_CONNECT socket
option. The scope here is limited to the initiator of the connection -
support for MSG_FASTOPEN and the listener side of the connection will be
in a separate series. The preexisting TCP fastopen code does most of the
work, so these changes mostly involve plumbing MPTCP through to those
TCP functions.

Patch 1 changes the MPTCP socket option code to pass the
TCP_FASTOPEN_CONNECT option through to the initial unconnected subflow.

Patch 2 exports the existing tcp_sendmsg_fastopen() function from tcp.c

Patch 3 adds the call to tcp_sendmsg_fastopen() from the MPTCP send
function.

Patch 4 modifies mptcp_poll() to handle the deferred TFO connection.


Benjamin Hesmans (3):
  mptcp: add TCP_FASTOPEN_CONNECT socket option
  tcp: export tcp_sendmsg_fastopen
  mptcp: poll allow write call before actual connect

Dmytro Shytyi (1):
  mptcp: handle defer connect in mptcp_sendmsg

 include/net/tcp.h    |  2 ++
 net/ipv4/tcp.c       |  5 ++---
 net/mptcp/protocol.c | 26 ++++++++++++++++++++++++++
 net/mptcp/sockopt.c  | 19 ++++++++++++++++++-
 4 files changed, 48 insertions(+), 4 deletions(-)


base-commit: 4991931223e3b909aa4931face285e4658927824
-- 
2.37.3

