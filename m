Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A441632D08A
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 11:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238373AbhCDKRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 05:17:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40237 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238359AbhCDKQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 05:16:44 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lHl1X-0006ek-BG; Thu, 04 Mar 2021 10:16:03 +0000
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Colin Ian King <colin.king@canonical.com>
Subject: net: mscc: ocelot: issue with uninitialized pointer read in
 ocelot_flower_parse_key
Message-ID: <0a0ebc62-4703-d3df-8f06-48ef50b20555@canonical.com>
Date:   Thu, 4 Mar 2021 10:16:02 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Static analysis with Coverity had detected an uninitialized pointer read
in function ocelot_flower_parse_key in
drivers/net/ethernet/mscc/ocelot_flower.c introduced by commit:

commit 75944fda1dfe836fdd406bef6cb3cc8a80f7af83
Author: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Date:   Fri Oct 2 15:02:23 2020 +0300

    net: mscc: ocelot: offload ingress skbedit and vlan actions to VCAP IS1

The analysis is as follows:

531

   10. Condition flow_rule_match_key(rule,
FLOW_DISSECTOR_KEY_IPV4_ADDRS), taking true branch.
   11. Condition proto == 2048, taking true branch.

532        if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS) &&
533            proto == ETH_P_IP) {

   12. var_decl: Declaring variable match without initializer.

534                struct flow_match_ipv4_addrs match;
535                u8 *tmp;
536

   13. Condition filter->block_id == VCAP_ES0, taking false branch.

537                if (filter->block_id == VCAP_ES0) {
538                        NL_SET_ERR_MSG_MOD(extack,
539                                           "VCAP ES0 cannot match on
IP address");
540                        return -EOPNOTSUPP;
541                }
542

   14. Condition filter->block_id == VCAP_IS1, taking true branch.
   Uninitialized pointer read (UNINIT)
   15. uninit_use: Using uninitialized value match.mask.

543                if (filter->block_id == VCAP_IS1 && *(u32
*)&match.mask->dst) {
544                        NL_SET_ERR_MSG_MOD(extack,
545                                           "Key type S1_NORMAL cannot
match on destination IP");
546                        return -EOPNOTSUPP;
547                }

match is declared in line 534 and is not initialized and the
uninitialized match.mask is being dereferenced on line 543. Not sure
what intent was on this and how to fix, hence I'm reporting this issue.

Colin
