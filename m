Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2AB214958
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 02:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgGEAot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 20:44:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:41576 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbgGEAot (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Jul 2020 20:44:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 954C8AB3D;
        Sun,  5 Jul 2020 00:44:47 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 19717604BB; Sun,  5 Jul 2020 02:44:47 +0200 (CEST)
Date:   Sun, 5 Jul 2020 02:44:47 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH ethtool v4 0/6] ethtool(1) cable test support
Message-ID: <20200705004447.ook7vkzffa5ejb2v@lion.mk-sys.cz>
References: <20200701010743.730606-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701010743.730606-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 03:07:37AM +0200, Andrew Lunn wrote:
> Add the user space side of the ethtool cable test.
> 
> The TDR output is most useful when fed to some other tool which can
> visualize the data. So add JSON support, by borrowing code from
> iproute2.
> 
> v2:
> man page fixes.
> 
> v3:
> More man page fixes.
> Use json_print from iproute2.
> 
> v4:
> checkpatch cleanup
> ethtool --cable-test dev
> Place breakout into cable_test_context
> Remove Pair: Pair output

Hello Andrew,

could you please test this update of netlink/desc-ethtool.c on top of
your series? The userspace messages look as expected but I'm not sure if
I have a device with cable test support available to test pretty
printing of kernel messages. (And even if I do, I almost certainly won't
have physical access to it.)

Thank you,
Michal

diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index 98b898e03255..54f057915d6d 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -206,6 +206,84 @@ static const struct pretty_nla_desc __tsinfo_desc[] = {
 	NLATTR_DESC_U32(ETHTOOL_A_TSINFO_PHC_INDEX),
 };
 
+static const struct pretty_nla_desc __cable_test_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_CABLE_TEST_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_CABLE_TEST_HEADER, header),
+};
+
+static const struct pretty_nla_desc __cable_test_result_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_CABLE_RESULT_UNSPEC),
+	NLATTR_DESC_U8(ETHTOOL_A_CABLE_RESULT_PAIR),
+	NLATTR_DESC_U8(ETHTOOL_A_CABLE_RESULT_CODE),
+};
+
+static const struct pretty_nla_desc __cable_test_flength_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_CABLE_FAULT_LENGTH_UNSPEC),
+	NLATTR_DESC_U8(ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR),
+	NLATTR_DESC_U32(ETHTOOL_A_CABLE_FAULT_LENGTH_CM),
+};
+
+static const struct pretty_nla_desc __cable_nest_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_CABLE_NEST_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_CABLE_NEST_RESULT, cable_test_result),
+	NLATTR_DESC_NESTED(ETHTOOL_A_CABLE_NEST_FAULT_LENGTH,
+			   cable_test_flength),
+};
+
+static const struct pretty_nla_desc __cable_test_ntf_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_CABLE_TEST_NTF_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_CABLE_TEST_NTF_HEADER, header),
+	NLATTR_DESC_U8(ETHTOOL_A_CABLE_TEST_NTF_STATUS),
+	NLATTR_DESC_NESTED(ETHTOOL_A_CABLE_TEST_NTF_NEST, cable_nest),
+};
+
+static const struct pretty_nla_desc __cable_test_tdr_cfg_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_CABLE_TEST_TDR_CFG_UNSPEC),
+	NLATTR_DESC_U32(ETHTOOL_A_CABLE_TEST_TDR_CFG_FIRST),
+	NLATTR_DESC_U32(ETHTOOL_A_CABLE_TEST_TDR_CFG_LAST),
+	NLATTR_DESC_U32(ETHTOOL_A_CABLE_TEST_TDR_CFG_STEP),
+	NLATTR_DESC_U8(ETHTOOL_A_CABLE_TEST_TDR_CFG_PAIR),
+};
+
+static const struct pretty_nla_desc __cable_test_tdr_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_CABLE_TEST_TDR_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_CABLE_TEST_TDR_HEADER, header),
+	NLATTR_DESC_NESTED(ETHTOOL_A_CABLE_TEST_TDR_CFG, cable_test_tdr_cfg),
+};
+
+static const struct pretty_nla_desc __cable_step_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_CABLE_STEP_UNSPEC),
+	NLATTR_DESC_U32(ETHTOOL_A_CABLE_STEP_FIRST_DISTANCE),
+	NLATTR_DESC_U32(ETHTOOL_A_CABLE_STEP_LAST_DISTANCE),
+	NLATTR_DESC_U32(ETHTOOL_A_CABLE_STEP_STEP_DISTANCE),
+};
+
+static const struct pretty_nla_desc __cable_amplitude_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_CABLE_AMPLITUDE_UNSPEC),
+	NLATTR_DESC_U8(ETHTOOL_A_CABLE_AMPLITUDE_PAIR),
+	NLATTR_DESC_S16(ETHTOOL_A_CABLE_AMPLITUDE_mV),
+};
+
+static const struct pretty_nla_desc __cable_pulse_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_CABLE_PULSE_UNSPEC),
+	NLATTR_DESC_S16(ETHTOOL_A_CABLE_PULSE_mV),
+};
+
+static const struct pretty_nla_desc __cable_test_tdr_nest_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_CABLE_TDR_NEST_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_CABLE_TDR_NEST_STEP, cable_step),
+	NLATTR_DESC_NESTED(ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE, cable_amplitude),
+	NLATTR_DESC_NESTED(ETHTOOL_A_CABLE_TDR_NEST_PULSE, cable_pulse),
+};
+
+static const struct pretty_nla_desc __cable_test_tdr_ntf_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_CABLE_TEST_TDR_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_CABLE_TEST_TDR_NTF_HEADER, header),
+	NLATTR_DESC_U8(ETHTOOL_A_CABLE_TEST_TDR_NTF_STATUS),
+	NLATTR_DESC_NESTED(ETHTOOL_A_CABLE_TEST_TDR_NTF_NEST,
+			   cable_test_tdr_nest),
+};
+
 const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC_INVALID(ETHTOOL_MSG_USER_NONE),
 	NLMSG_DESC(ETHTOOL_MSG_STRSET_GET, strset),
@@ -233,6 +311,8 @@ const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_EEE_GET, eee),
 	NLMSG_DESC(ETHTOOL_MSG_EEE_SET, eee),
 	NLMSG_DESC(ETHTOOL_MSG_TSINFO_GET, tsinfo),
+	NLMSG_DESC(ETHTOOL_MSG_CABLE_TEST_ACT, cable_test),
+	NLMSG_DESC(ETHTOOL_MSG_CABLE_TEST_TDR_ACT, cable_test_tdr),
 };
 
 const unsigned int ethnl_umsg_n_desc = ARRAY_SIZE(ethnl_umsg_desc);
@@ -265,6 +345,8 @@ const struct pretty_nlmsg_desc ethnl_kmsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_EEE_GET_REPLY, eee),
 	NLMSG_DESC(ETHTOOL_MSG_EEE_NTF, eee),
 	NLMSG_DESC(ETHTOOL_MSG_TSINFO_GET_REPLY, tsinfo),
+	NLMSG_DESC(ETHTOOL_MSG_CABLE_TEST_NTF, cable_test_ntf),
+	NLMSG_DESC(ETHTOOL_MSG_CABLE_TEST_TDR_NTF, cable_test_tdr_ntf),
 };
 
 const unsigned int ethnl_kmsg_n_desc = ARRAY_SIZE(ethnl_kmsg_desc);
