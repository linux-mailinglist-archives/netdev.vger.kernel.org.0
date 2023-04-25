Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B0B6EDEBF
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 11:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbjDYJIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 05:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjDYJIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 05:08:38 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901F746B0
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 02:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682413715; x=1713949715;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=R+WciIeRCotMxtqNjJfS1NcECi3LJA1rdQhQPa1LXJw=;
  b=iYSdpWj10Jy89EGeDwUhbNY9PdH2uCmbAxkoiKyzfd1LnsMRh7rpKAza
   kz8tgtdED4HZWDx4JoyRphFsBQZ+Wr3lTMhIdjR4TpiuUwf1WgCe/yCoY
   vfsCmRrtwf1pjMNh8pPs77V/JqZ0zgirTG4E/9953yKLxWjx7DKS5IfSQ
   smnLRI0WKBJfaZxPs9AAlVUuYDTv2rlgUx002j3X2ea9CbTyzr0K2U3Bt
   x1+LF3FrHMBUJFcmzatNB4dl6eSba2g1Rd/nDnmDLQNtuR5PXQrQ6ktxD
   cW1evmQesvsuE4IQorT5NPtBmHd9bwzEIkt1/SAxw8Fhx6zx4/ewAKvIe
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="345460553"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="scan'208";a="345460553"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 02:08:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="758030946"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="scan'208";a="758030946"
Received: from gkomc17.igk.intel.com ([10.88.115.23])
  by fmsmga008.fm.intel.com with ESMTP; 25 Apr 2023 02:08:33 -0700
From:   Krzysztof Richert <krzysztof.richert@intel.com>
To:     jk@codeconstruct.com.au, matt@codeconstruct.com.au
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        krzysztof.richert@intel.com
Subject: [RFC PATCH v1 0/1] net: mctp: MCTP VDM extension
Date:   Tue, 25 Apr 2023 11:07:47 +0200
Message-Id: <20230425090748.2380222-1-krzysztof.richert@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

According to vendor needs it seems that supporting Vendor Define Messages
based on  PCI vendor ID (0x7e) or based on IANA number (0x7f) which are
described in DSP0236 will bring additional value to existing MCTP
susbsystem. Currently MCTP subsystem allows to register one specific
client for each MCTP message type.

Under MCTP type=0x7e we handle two different messages, one is handle by
user-space application and the other is handle by kernel-space driver.
Because each vendor may define, own, internal message format  that's why
we considered to extend sockaddr_mctp and allow for registration on MCTP
message types = 0x7e/0x7f with additional sub-type (up to 8 bytes), which
can be defined and use by each vendor to distinguish MCTP VDM packages.

 
union mctp_vendor_id {
	struct {
		__u32		resvd	: 16,
					data	: 16;
	} pci_vendor_id;

	struct {
		__u32		data;
	} iana_number;
};


struct mctp_vdm_data {
	union mctp_vendor_id		smctp_vendor;
	__u64			__smctp_pad0;
	__u64			smctp_sub_type;
};

struct sockaddr_mctp_vendor_ext {
	struct sockaddr_mctp_ext	smctp_ext;
	struct mctp_vdm_data smctp_vdm_data;
};

Please confirm if new uapi (above) looks fine for you.

 
#### Background and References
 
 https://www.dmtf.org/dsp/DSP0236
 
 https://github.com/openbmc/docs/blob/master/designs/mctp/mctp-kernel.md
 
 https://codeconstruct.com.au/docs/mctp-on-linux-introduction/
 

#### Requirements
 
1. Kernel shall allow to register many clients for MCTP VDM types(0x7e/0x7f)
   based on  additional sub-type field.
  
2. VDM extension shall be easy extendable for different vendors purposes.
  


Thanks in advance for your inputs/feedback.


Krzysztof Richert (1):
  net: mctp: MCTP VDM extension

 include/net/mctp.h        |  24 ++++++++
 include/uapi/linux/mctp.h |  23 ++++++++
 net/mctp/af_mctp.c        | 114 +++++++++++++++++++++++++++++++++++++-
 net/mctp/route.c          |   9 +++
 4 files changed, 169 insertions(+), 1 deletion(-)

-- 
2.25.1

