Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED9D4C188B
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 17:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242773AbiBWQYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 11:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241930AbiBWQX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 11:23:57 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2093.outbound.protection.outlook.com [40.107.223.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B23C5D80
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 08:23:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CCBF8VMfcrwUYRqKHjmiCj54unzy4EvSilgae+RfC3jfmS3cZltNOdtC61pd4iI75fo8AiOZmdaqHBfuVgf9G7AYt1ew2IQn3WhPqTKs6rXc5BNrFziAhenfDCArd/AohuQ7c8AYT4b/BX+H8r3YYTn6gxsk7s84o4L6YVQWdh65XD51auxsxeszJgycWnLKjhZP510pl1/zt5275xGyeA7Cy8ofLHAdFJY2MdDM/WTZdAwi7vj34LLGW9dg2uq0R8qPifaGZV8M1ocRyeoUv8XD7W+9khJvSZNtDftK9ebb2oDnCIW8cDEa8Q/WalYIBWoXVacPgoJuGT8XHHXwDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GjIf6542QanFRnLEunBHjprq3lcfsA/de8gdCg0RS2I=;
 b=OYycZM36nYnT5KwP+X4Wwzp/oz4q/Nr28kaf3j0ciobUe8BXOXnHGWT0eUT170fM9dK+aP6jVMTPPIAz8ymUaF0IWU4IOFwe7+NlzZZg++ZJ5/X5ePkJI23VECI0XIkLvDA5BnLrAvMEe6exqRtPNDiwGg2x3XpebAeWC2GO6oLzZ80aIK5+zssSMUih5wuigNgxGjZy3Njg5iTIVggrNmbPCZWn5P3Ne63gZtAC1OeDiL5fwF1wW6cWp0rJraY97a+ehGaurBMFpoDszNghNYzFTYhqsegkyjw/tye8+pFJClIAvN/qAuxvV7S0tIkz3rdfp6s5aGrd2BTCi0vnWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GjIf6542QanFRnLEunBHjprq3lcfsA/de8gdCg0RS2I=;
 b=KKF465p6NXmNdeLNVlF9ig3DAc243vO+Va3NfwStIiDmFt9qJ1cUd6sIlwgcri8lgP3gj64NBwTq8sgior+bV7e3zeCjwpHh6boqa3T6HNnvFBS3pi3bgIUMZWS4RiEYNDC7JtAyq7qFQeDQqB8NmD3qixiamkrRpciL6NngLAA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MWHPR13MB1757.namprd13.prod.outlook.com (2603:10b6:300:132::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 16:23:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%6]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 16:23:22 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 0/6] nfp: flow-independent tc action hardware offload
Date:   Wed, 23 Feb 2022 17:22:56 +0100
Message-Id: <20220223162302.97609-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0125.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6914a31e-2aa3-49f3-0621-08d9f6e8cf19
X-MS-TrafficTypeDiagnostic: MWHPR13MB1757:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB17574D2A2E52762C72A851D4E83C9@MWHPR13MB1757.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AJ1bA+Z3MOuioLAOXPlRDG/ML1Pg1pV2k8SocvOCMJwkdT2bWBM5C4pwnj4tRiVav6piC72E+vwhwaRhEH9i/L0uuHUxcy+J+1sTtELWY6rtTno+FWDUfqCzQ2Nf5yKeiDqqgxXpd9quuMzssulzLzPkHfXSfMZdlMxffbgyHlSBjBRdMd2Z+b2qMLdh9RbvfxuFJl7Sf4uvhLqhjfhoiFLALKoKGsO9CWjwZXiV5XUEOd2ooIw9qcFc5gXwyQrYm5u06LO48KKfIbgoLjXWMJTjFT5KoocEQqj3+Et6BFODYLDIaOd827iT1Wc9TCuRUyudVtiGQ7U1S/Nhv3dhPsFFbEDo11LAhn1xVDX8XhaILbfhNaN/A8owkNt8GgCPf68xGa8fbsM6YsOhrp/xCcN0USaR7NMfYThSOerI5DDBkzF42eKEYTFRtTUfpPdXA3MVeAb/52qXToRiasMAHl5Hooo+NMOrOoWWSUsNJ6jnG81R7nJJVMRpGua8bnrSE2UDxhcJ8dUYds+39A/WQa12l2CG8+gXrmsDb0mXkmzLLAFtC9DFE5Dv3zvj9Z0UcwaeDQCT78YA1hq0J8IGN2wnOe8hJd/TGJagesOLj4s3O/Dl64/Be+lbtxJA6UKZRo7tVZwAHY6LvpNBcOnUPQWbvskwzoD8mkWa7y9hbR62dAunzudZbSbC9Smg14iS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(136003)(366004)(396003)(39830400003)(8936002)(6506007)(86362001)(508600001)(52116002)(6486002)(36756003)(44832011)(2906002)(5660300002)(54906003)(110136005)(83380400001)(66476007)(1076003)(66556008)(8676002)(2616005)(316002)(66946007)(186003)(38100700002)(107886003)(6512007)(6666004)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2XLZhuHEILU6dNp+MsUX+NhWkRsLyVbEvEWqdHrCmfLlZ+In5PEC3NUiwnNH?=
 =?us-ascii?Q?ScbKODDJ96t59w8c4tY49Wio+cH4G5kKpYUAVsXNf2uQeInaog6nYKl/2ByE?=
 =?us-ascii?Q?Mo4AFpD9RhbwDBJN0EGP5qMor2MtH6m4YS60T6gVJfCRVsMTMLfuP6QmpiAZ?=
 =?us-ascii?Q?8FH2ezdmUWcct6Z1rbzC8imJqZdjUMHtiyH+Sd0xJxLfJICgscie300xvpWf?=
 =?us-ascii?Q?S07Wbp48/ZsRQSnuBujBu6EsZdw9mIkL1JCfqC//revigPz12XWAJEy8/zid?=
 =?us-ascii?Q?Jz10T/tZNU1Lrwqy2izVVCAkx1EcnfzpN39Tyr93m6aWel9NKte+ZbwbKnsq?=
 =?us-ascii?Q?b3iKUR8OEyUbqjihUMNjFTHeNEaAUhOIyVsTyVyP29UADA/uVEuO68QVO3dp?=
 =?us-ascii?Q?O6WGnBG8Z0VFqoeVURH/AMnZ6CtIXqmKUZOxttimDQ84yTa5HcoUEQRvtKq4?=
 =?us-ascii?Q?2mm7PD3yDXPX+TReI5FAQrLEP0kf8duRvabBCzVz/WScbNU43cFIaWQeWKBn?=
 =?us-ascii?Q?xaIW8LpHFugXHIFa9CyGMg5EGAC5KLFpuyXSOLzmYroUY7GkpcNe6ZyV1ymR?=
 =?us-ascii?Q?mqASNHpbRPq3TIiPoYGrulW0hryTdPu+QZtJ03prOwD7tpikgdd38uPwj3Wm?=
 =?us-ascii?Q?GsG0XzMcIux8ApLvQ1XnjKPJyeoERb9NuIZGwb5EdSGxCyKFjUhDTJ7Ch06P?=
 =?us-ascii?Q?9ERr3aG3aOZVsWnOxmnE06QzjIp6lmLj1ota60ggR+LGyQyO7qmOS5DEgvmN?=
 =?us-ascii?Q?k86jJtS28lo/s74hpYPxxBS4vZAeYJpUAKMH+Br8hFTbihhGIonnJIHGGSSu?=
 =?us-ascii?Q?Ltqlfgpz61DJHcQ5Z0IVWWQe1/sWbUS3fEP/I40v5BpbkG8T+JTDoChQ1WSZ?=
 =?us-ascii?Q?/W1Gy8wverSo8a8gLQVo9OyR6ee4bW9VlE0Q+RLnK9G+OoexgHtYvhzfriYl?=
 =?us-ascii?Q?9N3tTKWJ8WT+KyqHLBxgmiqJlG5ArqBI1xd6idIPzx1KbWnZplu5tTZRyhoj?=
 =?us-ascii?Q?c6hAZGChAzQAO9J7XM1ee5WLqc4DkLawnTZCLV71KOmrtyU+pXIbhu0BmRYc?=
 =?us-ascii?Q?NzYHt++amyl+qSt1ROnOI1Jx3Yjym0oONx4HqDMtyb7YM0aHHOXCA096WbNf?=
 =?us-ascii?Q?N2DYND4I95H3av4R9bsqsCqBjpuWeQnWCzitMwjm6VAw6PN4MLhg2KY45YJb?=
 =?us-ascii?Q?xiKvwLoxp23uZVX8zvDjy/yBo8MDNuPXYNW0B+nWMNKSPzyhYQTezkOCtHTl?=
 =?us-ascii?Q?CB7bTUSy5NZOiJFLMHQncw1WkUbgPIBS9qHfVDOlNEXmmWrtLwzm/GIQrcVX?=
 =?us-ascii?Q?HhR2bPE7vw/8L9Jc5y4xqaU5e+wzJVyIzo0KWEgcGrT5tCO4VYrNZ2dKL/fR?=
 =?us-ascii?Q?7VF7765+7pLfnk7A2nhxlXjRjZClL5b71RxghcjLkr9DA5Ts60p9JQDFc5gj?=
 =?us-ascii?Q?TGp8Dbq4YGautyVwHSA9BJRerJsWT74IfqH/fxISxvhikMgqEvytF305Ko/2?=
 =?us-ascii?Q?l8iIyyMdJjB4Zz/DH1S/Aa4Tn/BwkKUZWOiqa1mkhN2bWvefGpFuJb49/1UI?=
 =?us-ascii?Q?Z7QG4LEKAVvO4ZZG+T1FzROb/qtzYEwaYjvDx6pTltzH3DGLBod6/eIicbV2?=
 =?us-ascii?Q?2Ii5n0NXDjkUkmgD+TNtvo6FIe7/u5T5tPvqEkEOiP+3MzAw4/TUoUmU1hC6?=
 =?us-ascii?Q?S2j9w1P/eLMs9t3RK7/YoVsSP2BP70iwS/x2ymmIK/v4Kb2UnuglVDPkD0pj?=
 =?us-ascii?Q?rwr9cngqHw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6914a31e-2aa3-49f3-0621-08d9f6e8cf19
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 16:23:22.0611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pw9xfwy7SEnin8lTVX/m9rZPb1L4gR3/XbS2jE9M9l4z8L0UU7UfCyH6h9O3sronETdp2m3BmrEpIf1Hgx8CiY2wgXtVGxez+nAhNG7o5GQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1757
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Baowen Zheng says:

Allow nfp NIC to offload tc actions independent of flows.

The motivation for this work is to offload tc actions independent of flows
for nfp NIC. We allow nfp driver to provide hardware offload of OVS
metering feature - which calls for policers that may be used by multiple
flows and whose lifecycle is independent of any flows that use them.

When nfp driver tries to offload a flow table using the independent action,
the driver will search if the action is already offloaded to the hardware.
If not, the flow table offload will fail.

When the nfp NIC successes to offload an action, the user can check
in_hw_count when dumping the tc action.

Tc cli command to offload and dump an action:

 # tc actions add action police rate 100mbit burst 10000k index 200 skip_sw

 # tc -s -d actions list action police

 total acts 1

      action order 0:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action reclassify
      overhead 0b linklayer ethernet
      ref 1 bind 0  installed 142 sec used 0 sec
      Action statistics:
      Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
      backlog 0b 0p requeues 0
      skip_sw in_hw in_hw_count 1
      used_hw_stats delayed

Changes between v1 and v2:
* Make some code-style changes based on review of v1
* Change the memory allocation way from GFP_ATOMIC to GFP_KERNEL.

Baowen Zheng (6):
  nfp: refactor policer config to support ingress/egress meter
  nfp: add support to offload tc action to hardware
  nfp: add hash table to store meter table
  nfp: add process to get action stats from hardware
  nfp: add support to offload police action from flower table
  nfp: add NFP_FL_FEATS_QOS_METER to host features to enable meter
    offload

 .../ethernet/netronome/nfp/flower/action.c    |  58 +++
 .../net/ethernet/netronome/nfp/flower/cmsg.h  |   7 +
 .../net/ethernet/netronome/nfp/flower/main.h  |  49 +-
 .../ethernet/netronome/nfp/flower/offload.c   |  16 +-
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 430 +++++++++++++++++-
 5 files changed, 534 insertions(+), 26 deletions(-)

-- 
2.30.2

