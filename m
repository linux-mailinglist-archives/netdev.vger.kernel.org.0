Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913802DA09D
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 20:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441051AbgLNTer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 14:34:47 -0500
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:3996 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440528AbgLNTer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 14:34:47 -0500
Received: from pps.filterd (m0170389.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BEJWdYk014438;
        Mon, 14 Dec 2020 14:34:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=smtpout1; bh=XQHrgcJou8h3R2llFW4QtmfG1DAkcwj76rbIAXVzWVI=;
 b=DVHdwuqFJC+LNmx5GZMPw2SARyAWGO+6/vVjF1VEA3yg39/CPFmFBU9ALC98uJ2JQ2wI
 kY081FfnUEFHI1KesTl8vOMNt6j3vSWO0sTLOXuPx5qLdplLzqDLV0W2nMADTBuJfQAW
 vDhJccB4ubhNC87X3YNhrwxlcJPXXkcsXCTE6SZvNsq6hvLmuKcg7LjYeAIV8IJfs54v
 egjS+K3igCd7doAgH7nHoqzVWNChB0iemJuKx+Apx5aObF4nrFVLTOmfhhsMkcg3k9jf
 kA3IFjzOl3Hmavwz8qDMJ5hrsN7/WtoxhIjJBtPxJlAQ71/70KEih4c0AiRr03woUR9d 2w== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0a-00154904.pphosted.com with ESMTP id 35ctrqxja5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 14:34:06 -0500
Received: from pps.filterd (m0134746.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BEJY6Pw182661;
        Mon, 14 Dec 2020 14:34:06 -0500
Received: from ausxippc110.us.dell.com (AUSXIPPC110.us.dell.com [143.166.85.200])
        by mx0a-00154901.pphosted.com with ESMTP id 35e5emsm0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 14:34:05 -0500
X-LoopCount0: from 10.173.37.130
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.78,420,1599541200"; 
   d="scan'208";a="1020795048"
From:   Mario Limonciello <mario.limonciello@dell.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        anthony.wong@canonical.com, Hans de Goede <hdegoede@redhat.com>,
        Mario Limonciello <mario.limonciello@dell.com>
Subject: [PATCH v5 0/4] Improve s0ix flows for systems i219LM
Date:   Mon, 14 Dec 2020 13:29:31 -0600
Message-Id: <20201214192935.895174-1-mario.limonciello@dell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_10:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=948 malwarescore=0 suspectscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140129
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
disabled s0ix flows for systems that have various incarnations of the
i219-LM ethernet controller.  This was done because of some regressions
caused by an earlier
commit 632fbd5eb5b0e ("e1000e: fix S0ix flows for cable connected case")
with i219-LM controller.

Per discussion with Intel architecture team this direction should be changed and
allow S0ix flows to be used by default.  This patch series includes directional
changes for their conclusions in https://lkml.org/lkml/2020/12/13/15.

Changes from v4 to v5:
 - If setting S0ix to enabled in ethtool examine the hardware generation.
   If running on hardware older than Cannon Point return an error.
 - Increase ULP timeout to 2.5 seconds, but show a warning after 1 second.
Changes from v3 to v4:
 - Drop patch 1 for proper s0i3.2 entry, it was separated and is now merged in kernel
 - Add patch to only run S0ix flows if shutdown succeeded which was suggested in
   thread
 - Adjust series for guidance from https://lkml.org/lkml/2020/12/13/15
   * Revert i219-LM disallow-list.
   * Drop all patches for systems tested by Dell in an allow list
   * Increase ULP timeout to 1000ms
Changes from v2 to v3:
 - Correct some grammar and spelling issues caught by Bjorn H.
   * s/s0ix/S0ix/ in all commit messages
   * Fix a typo in commit message
   * Fix capitalization of proper nouns
 - Add more pre-release systems that pass
 - Re-order the series to add systems only at the end of the series
 - Add Fixes tag to a patch in series.

Changes from v1 to v2:
 - Directly incorporate Vitaly's dependency patch in the series
 - Split out s0ix code into it's own file
 - Adjust from DMI matching to PCI subsystem vendor ID/device matching
 - Remove module parameter and sysfs, use ethtool flag instead.
 - Export s0ix flag to ethtool private flags
 - Include more people and lists directly in this submission chain.


Mario Limonciello (4):
  e1000e: Only run S0ix flows if shutdown succeeded
  e1000e: bump up timeout to wait when ME un-configures ULP mode
  Revert "e1000e: disable s0ix entry and exit flows for ME systems"
  e1000e: Export S0ix flags to ethtool

 drivers/net/ethernet/intel/e1000e/e1000.h   |  1 +
 drivers/net/ethernet/intel/e1000e/ethtool.c | 46 ++++++++++++++++
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 16 ++++--
 drivers/net/ethernet/intel/e1000e/netdev.c  | 59 ++++-----------------
 4 files changed, 70 insertions(+), 52 deletions(-)

--
2.25.1

