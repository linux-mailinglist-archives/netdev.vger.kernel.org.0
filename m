Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5DC6CB58E
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 06:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjC1ExF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 00:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjC1ExD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 00:53:03 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020016.outbound.protection.outlook.com [52.101.61.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B4E2114;
        Mon, 27 Mar 2023 21:53:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hGz5tU5FJjjFuWGZUlP9zm5EjV6Dlz7RZpGAAdMyOB7x3dWNeKb3SCfUxihuvo7ZihIfLo978Q//p8dw5X00sN6f7vv205PzsjXIHoVHbd0Wx8YZUWzoFbsPaAdEk+v5TpMJjGoYnPg/zO/WHdesQeJfkUxv6f3myZ5Yu5DHHB7AfxpZ2uququzrCDHGDY8c39eai/BwvgXcRAWqGjkORTO35VZLb93yQQrEalnIxxtYUt/+G7boOQwPvzdylxwQGOa/aybFO1UAWwLXY4+i4HNQZoD8HOQf5RqCzENin4I3KiLzlpxltk5ho6rgDFXBjdAfK2I58Qcn6zctF3pySQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wZy+tK8J9eDpzJ7Yshh9xR3a76dFwyAkawq9MNO5N1c=;
 b=UMFLfX9Qm5mwge0QztcQ18lXfrcObUKGX4Rq0Z0dvWUooH1eAuEICDQtIV5IMfqxkWQyl3XnKcks/Mhr7fy/dv+SQVZhCM0ZmoRn5h+2gl9HUHr6JWdEH6Rr0M9WcOIDd/sth8jIa2riNfWAKnSah7DTUSnij/79M2w0XUViiII3tN+tQbgp5hQffYD9A5WrHnFqqhMBZjsDY6xqcFrfFJe5KhAvrrsRcV5GP76P6jNFgm/OACQN0r7t+zohMSrpiEJixKsHJ/pR0fAOpEPp+kAas3WPYahASWZKdTCiONqf4f5bLkxc2stkJ+rVhO7w0sGTUQC8UK7nQUDX54wYZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZy+tK8J9eDpzJ7Yshh9xR3a76dFwyAkawq9MNO5N1c=;
 b=ibpaRq+yHqFqilFQfsxuV/Wr/r0wl5MRfti3fgHlSkiiu8vkD1A80cGfr85wzpO87pA7cRQf/0hS7NIw3PNqav4yBurNDC8z9Whw2TctguVIVOWK2hB/ESyIaAJIHlhPM0SswhEIi5sW9kLT3uB/JZTbuIhNBQW4x6PQolCCS0g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by IA1PR21MB3402.namprd21.prod.outlook.com
 (2603:10b6:208:3e1::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.6; Tue, 28 Mar
 2023 04:52:58 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7%6]) with mapi id 15.20.6277.005; Tue, 28 Mar 2023
 04:52:58 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     bhelgaas@google.com, davem@davemloft.net, decui@microsoft.com,
        edumazet@google.com, haiyangz@microsoft.com, jakeo@microsoft.com,
        kuba@kernel.org, kw@linux.com, kys@microsoft.com, leon@kernel.org,
        linux-pci@vger.kernel.org, lpieralisi@kernel.org,
        mikelley@microsoft.com, pabeni@redhat.com, robh@kernel.org,
        saeedm@nvidia.com, wei.liu@kernel.org, longli@microsoft.com,
        boqun.feng@gmail.com
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/6] pci-hyper: fix race condition bugs for fast device hotplug
Date:   Mon, 27 Mar 2023 21:51:16 -0700
Message-Id: <20230328045122.25850-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:303:8f::18) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|IA1PR21MB3402:EE_
X-MS-Office365-Filtering-Correlation-Id: 7399584d-aa1c-4959-56de-08db2f484c77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X3TawLQbXM539tbAUkvbmecmJ3kBdI+0kHQ4omMQfkdrjlbx5jzUy96eK99Mo5t26pS315CFdx4b3nobTPP/5V6SyyVAJks7anT8YbZ4N83bnW6zhR7feKFe2qoxVqXf+owOo+RNOgvtkX+nDB4uxc0m9ntSB+tqx+ntgKQB7mMO1dsAvvt2W0q0nTZWZxfocBoAnDrmp8rRMlqjy1hNFdIpLphPmqHQ3E+9/2J5wCFw+qg1ky+AU09hKDsq/dKbZT03Go68ed8vb9J+VLg5nJn/Fu9knZ8B90iFa09PqmEik/aBWp0ClsFEO6IABeOGyKOTw1Yq4gEFCyWragDB37EjmHbymZiYm5ZdtUBNQx949II8FFNWiNqxyA8mRgrNEHP+t4JV/zyAkUiCUSfTedK6G0f3rnsw9e3rwd1rHA1TgtyLQayuWX6mMzN56kCndHoSPQUq5OQYksA3ud6yh8RCof/NRLrk8m4N9q9KC1kvdV/4LohMhxhcxZnONd8cYke7ZUjCiRxQxY3RWVgVMvAzdu/rSH7b31oOZjDWDB1InNH5sUajOuXhfx/+SQf/th9dS++OVIWyPEZj25dXnt1XXQ/LHDUtksBe4RJSF86ZklXFFXEuF1zZAdM7J315mTCj5aF1yB5t8d685Frbcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199021)(478600001)(83380400001)(10290500003)(2906002)(1076003)(38100700002)(52116002)(7416002)(966005)(6486002)(6506007)(6512007)(921005)(2616005)(5660300002)(8936002)(6666004)(316002)(86362001)(82960400001)(82950400001)(186003)(41300700001)(66556008)(66476007)(4326008)(66946007)(8676002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SN1v0tAzOzr77Ti2HvT1/GyqASBP57CPyaxWgK9GEWv7LhLD54v+AjjZ8xVt?=
 =?us-ascii?Q?NIovg8kv1fvTVnYBDiJEfv5eiR5VsroSQkionudGdggJewBJrTOWRgzkRYd8?=
 =?us-ascii?Q?UbOJbyP+y7mxenR3PdlxZ1fXHtOTksAtTUxDrpGdJNdROYSqthx9azmMXLal?=
 =?us-ascii?Q?JEEtzaf4ZGqMHPTy2GelJde20NWY1qh1s4ncrLrcma6XlePdBK6KnUlwfjfc?=
 =?us-ascii?Q?c3zOmAXixAmDMSQZ6AR3nbOKqCD4US5Wu7i+TV2gkicKeWh91tAxEX0WSPRq?=
 =?us-ascii?Q?xdL3iIi0MNLjsp3Lo4gnE9dGecu3XClBpuBWFOE2E19lciVl5A5/3JkLYFeH?=
 =?us-ascii?Q?v6nktGLRB0tlYly9/Euq8qLIydeE3VgtHfFFeExp3GYOThjHthkT/A2ot8Xk?=
 =?us-ascii?Q?kuE3fydyOMY+7qH9MlVcGe50bFaZbmXfSr3vfd7RIiNbP6tILErdSZA41UXq?=
 =?us-ascii?Q?lZKQoKJQ5PbCTSfShcaR2jA6EJdJr2CXySurhhwjRASeegEEuZ65w8+KWdJX?=
 =?us-ascii?Q?0RvveUGX4fISfrYPzJ9jQm/7SIQiecFi7jy4ttCZg1wZIcI3bKb0sTOCZvOA?=
 =?us-ascii?Q?6AI8OC40yt/mXoAP+c1EFBiyBWZHQIKyhFLrGDQQu6ywHXYOS0ip9dljLC/n?=
 =?us-ascii?Q?YiNhtGQBLzyXy9fj3XK+nDJPPs1bS0QzxLpUr1ectj64ZmpBYH/Bn6pJaFFH?=
 =?us-ascii?Q?WukibLVN/oCaaDOCY2Q+m14rrNG2/60LYQZFDO6CSJmGVbH/UqBj9+8DA+4G?=
 =?us-ascii?Q?znHOtycy7v4gGOCJEZmOOvwL1s6zYFb0yc8/oc+TOQbmVTkvnaVzAs1tCjJM?=
 =?us-ascii?Q?LLu4eovvHCp2uBC448iLMkYzwofsgp6AozBRuQ0NFYI4FKX4fOjlWsvAjLiU?=
 =?us-ascii?Q?cgVvMHkDrAg+c+/5zWKsWiAs6Pz/G1WZg1g70RMt1ep+U2OdqJ6WzT6WkqpF?=
 =?us-ascii?Q?Mb70lt+Px64Yi+SevRsbnRW0e77nbLJySdQeB8Pn7rNE3zRbPyx73mqGZXFO?=
 =?us-ascii?Q?wuos0nqwRwg9PuXlvErOzeLJjb97MuDZrDoUhaGxopYTSSf/5FgA7lOa2jqq?=
 =?us-ascii?Q?Zll2iQ0/2CVP1CU9FpLN2fdJ9aG7ySKbwSkmgfMeqnDQoGkQjQcneiaUPssD?=
 =?us-ascii?Q?qs9xevyIFV5aQMENqCFvG21NgQiKTkiKwMOEv9H+r/17RqS9wu5bWvzqrtSw?=
 =?us-ascii?Q?VhMRKMdHUPIbKIwfqkpgIySQkbjGhN1BLYYlN7zokd4WF4gEqsCNJUaLnhRY?=
 =?us-ascii?Q?LF05mPthEYESGVeiHeabB3Sa7XX5EpqtoksUVGXeV4zY7KBIXuFmc2CgYN2x?=
 =?us-ascii?Q?Jzat2N8pXjNpiK1fMfzjuLYIyP+4OLrY+/Pq27UKs/QBGRFYa0PK6U5/Jw9y?=
 =?us-ascii?Q?Kc/ZhxOht6lq5OUtOZ+7aXqy4rQFlKELaMRHjldd3/7yJwT53MqlyPiknerf?=
 =?us-ascii?Q?JaZl9Bl9rys9mpk1FM9EqGtCbofP+OP9lMxMgr8DQdg2tt21tTb9gV3qZ25y?=
 =?us-ascii?Q?ifhCknkgjojsmiAXZF6kyQcxkGlOMuq6eCVb4XqIUcw6I/EJb1dBuIOB6TkA?=
 =?us-ascii?Q?wuiZm6oFbdjBSMtRthm+2k5RDVtYwSopv0R2X0bpRIlUhBEKnxnGIAO/kVnL?=
 =?us-ascii?Q?lRM5cMk0uCJt9N8ce3+pPecedyDy5AA/WB3hRt/5Tl9S?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7399584d-aa1c-4959-56de-08db2f484c77
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 04:52:57.6625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ix80xTd+eX7WjAEOHuh4hyufGUxW+knHOM2fneXoAl/8oJ1n8tuafZiCYOTmKL/f3B8ZGUAg+ePkpXVVR8rdDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR21MB3402
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before the guest finishes probing a device, the host may be already starting
to remove the device. Currently there are multiple race condition bugs in the
pci-hyperv driver, which can cause the guest to panic.  The patchset fixes
the crashes.

The patchset also does some cleanup work: patch 3 removes the useless
hv_pcichild_state, and patch 4 reverts an old patch which is not really
useful (without patch 4, it would be hard to make patch 5 clean).

Patch 6 removes the use of a global mutex lock, and enables async-probing
to allow concurrent device probing for faster boot.

The patchset is also availsble in my github branch:
https://github.com/dcui/tdx/commits/decui/vpci/v6.3-rc3-v1

Please review. Thanks!

Dexuan Cui (6):
  PCI: hv: fix a race condition bug in hv_pci_query_relations()
  PCI: hv: Fix a race condition in hv_irq_unmask() that can cause panic
  PCI: hv: Remove the useless hv_pcichild_state from struct hv_pci_dev
  Revert "PCI: hv: Fix a timing issue which causes kdump to fail
    occasionally"
  PCI: hv: Add a per-bus mutex state_lock
  PCI: hv: Use async probing to reduce boot time

 drivers/pci/controller/pci-hyperv.c | 143 +++++++++++++++++-----------
 1 file changed, 85 insertions(+), 58 deletions(-)

-- 
2.25.1

