Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB30E6276EC
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236058AbiKNIAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235949AbiKNIA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:00:29 -0500
X-Greylist: delayed 99 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Nov 2022 00:00:28 PST
Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538CB1AD
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 00:00:27 -0800 (PST)
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AE6TOYN023027;
        Mon, 14 Nov 2022 08:58:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=12052020; bh=UWMHjPe+6Uf3zl27icZgrS4/jRvc2p/b5sGMI7uvJXI=;
 b=jVHiXWWcKfwosPnZibCCvIkklQDvAitxgtHvmPqh1wrQBQLXBf8JUT4L8Pz4BMAzUwqj
 yZbOjRG9r6QgziCSfOQKYxeAxWCJ3AfguHa9blVj+0H3yolWtRfJYoXvMGT3i1klFBe4
 9tBfOVysiIMb63j4PVkzFBrPcWC0Lc5hePHmdw364gJ0U7HnXN9i66fbxw0g7mDL6cHc
 wrw75AKv7/wct3nsyXIH6F1SaFKch5Z7JKF+fz4lHHmP/vXdIu1DLr8kSxL8tx6r1YyK
 2DmK/1q99YtyJJlCYUScT6pHxedaDGm+k5W0lvjuOmMddSC+BZmzC0kFG7IyPY8e4gJJ Gg== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3kt0qh1xq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 14 Nov 2022 08:58:46 +0100
Received: from jacques-work.labs.westermo.se (192.168.131.77) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Mon, 14 Nov 2022 08:58:44 +0100
From:   Jacques de Laval <Jacques.De.Laval@westermo.com>
To:     <netdev@vger.kernel.org>
CC:     Nikolay Aleksandrov <razor@blackwall.org>,
        Jacques de Laval <Jacques.De.Laval@westermo.com>
Subject: Asymmetric br_mdb_notify calls when handling IGMPv3 joins/leaves
Date:   Mon, 14 Nov 2022 08:58:17 +0100
Message-ID: <20221114075817.11214-1-Jacques.De.Laval@westermo.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [192.168.131.77]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-GUID: UKxQbxcGwA4dm53f9qdouUBxVcG7AiAc
X-Proofpoint-ORIG-GUID: UKxQbxcGwA4dm53f9qdouUBxVcG7AiAc
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

While testing the IGMP support in Linux I have observed that under certain
circumstances I can get an inconsistent state between the bridge mdb and
our Address Translation Unit (ATU). The root cause seems to be that the
bridge can issue more than one RTM_NEWMDB notification while handling a
single IGMP join (for a one port and group). When a later IGMP leave
is received for the same port and group it will not lead to more than one
RTM_DELMDB. The dsa layer however expects mdb notifications about added
and deleted entries to be symmetrical, ie. one DSA_NOTIFIER_MDB_DEL
received for a port should be preceded by no more than one
DSA_NOTIFIER_MDB_ADD for that port. If the notifications received are not
symmetrical, the reference counter for `struct dsa_mac_addr` might never
reach zero and the group will never be considered deleted in the
dsa layer.

The reason for the asymmetry in the bridge layer seems to be that
br_ip4_multicast_igmp3_report will potentially issue two RTM_NEWMDB
notifications when an IGMP join is received on an interface - one when
adding the group (via br_ip4_multicast_add_group) and then another one at
the end of the loop. An IGMP leave will only lead to one RTM_DELMDB (via
br_ip4_multicast_leave_group). I believe the same problem might exist
in br_ip6_multicast_mld2_report but I haven't tested that.

I don't feel that I grasp the logic in br_ip4_multicast_igmp3_report well
enough to be able to come up with a clean patch myself, does anyone else
have any idea? Am I right in my assumption that the bridge is at fault and
that the dsa layer should expect "symmetrical" adds and deletes?

Tested with a recent (e29edc4) net-next build.

Regards,
Jacques de Laval
