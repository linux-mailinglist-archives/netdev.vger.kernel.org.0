Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCDF58B2CC
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 01:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241878AbiHEXmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 19:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241873AbiHEXmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 19:42:03 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C915C18E27
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 16:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659742922; x=1691278922;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2CggSbVU5QuQxncKXN9E4rdMkm0fwYXPcMP+bci8tPo=;
  b=Jb2i8H5IJleL/PSoAVyu1YdsoZ6yV+llJuq9QDajvADts10DP0k8eWyn
   yZrkojV5qDbTqZzUAVeLRGbXOr7PjfO5i/HD5oFKow1c7iceOAmhWW0tp
   SE9m55W+QH4IMV1UPTVWOgdFpRFnsuPds1Z0ODa0kjjkt/ya39SHxusF5
   D/xWoNOOR+CCPg3xoaO7x+49PZWcxDrBwek5ZKmakm+pMbFxf4IITreu+
   +LlHN3HrG2TSuvwQZQYbx4Sa1pEo9+i687hUQMFil8HerePqgpn0OjSLS
   IpZEVf+wvkfysl/m4jshSmr1mRL1GgbAKw6u2aMqCrlJKpT8UEauP3H/H
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="289072930"
X-IronPort-AV: E=Sophos;i="5.93,217,1654585200"; 
   d="scan'208";a="289072930"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 16:42:02 -0700
X-IronPort-AV: E=Sophos;i="5.93,217,1654585200"; 
   d="scan'208";a="931401645"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 16:42:02 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [RFC iproute2 0/6] devlink: add policy check for all attributes
Date:   Fri,  5 Aug 2022 16:41:49 -0700
Message-Id: <20220805234155.2878160-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.208.ge72d93e88cb2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements code to check the kernel policy for the devlink
commands to determine whether or not attributes are supported before adding
them to netlink messages.

It implements a new mnlu_gen_get_op_policy to extract the policy
information, and uses it to implement checks when parsing option arguments.
This is intended to eventually go along with improvements to the policy
reporting in devlink kernel code to report separate policy for each command.

I think checking every attribute makes sense and is easier to follow than
only checking specific attributes. This will help ensure that future
attributes don't accidentally get sent to commands when they aren't
supported (once the devlink kernel policy is improved to report correct
information for each command separately).

Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jiri Pirko <jiri@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org

Jacob Keller (6):
  mnlg: remove unnused mnlg_socket structure
  utils: extract CTRL_ATTR_MAXATTR and save it
  mnl_utils: add function to dump command policy
  devlink: use dl_no_arg instead of checking dl_argc == 0
  devlink: remove dl_argv_parse_put
  devlink: check attributes against policy

 devlink/devlink.c   | 846 ++++++++++++++++++++++++++++++--------------
 devlink/mnlg.c      |   8 -
 include/mnl_utils.h |  28 ++
 lib/mnl_utils.c     | 258 +++++++++++++-
 4 files changed, 858 insertions(+), 282 deletions(-)

-- 
2.37.1.208.ge72d93e88cb2

