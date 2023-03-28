Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0531C6CCA1A
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 20:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjC1SiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 14:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjC1SiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 14:38:02 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2112.outbound.protection.outlook.com [40.107.223.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1221BC5;
        Tue, 28 Mar 2023 11:38:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFmBwse45/yPV8K8khN2j8Je5OtTNZ5OJDWeEq4+5y0OjVQqcqJEmU23EwZ3o8vkAx/9ifk3KCKyUo6EaSKNfPoGZM6g9sYKjWPFy1fVfTHhIqVPVnP52ZzcfuU51x4aDPSn9ftUWgGiNdajLeoDdeWocTACh08CjhIqlC19H7+DoeMib8RJzM+jgW6pz93ZOiKBP24+vqzD8PrazOmWkQkpQ1hCupzlD8w7IUcEQLnq+nu+5F1Vad1D36O5Bl38QfDb/oHY3SBl7toCZ43KH04Ok+QBL3MFQFhWBDYI101JCpmSbupC9VAQB3K+/wmJI89PH44JCLXLIWbuj3816A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gbQ1orJsWaQqaiiBueVscm1QEI+OeAjs2S7X38ZJnhs=;
 b=Gl0u86rUXhqFlIPW5YRFQ4iaMFBcFD9qWsy3zzezOqKMAzmaMUvoz/aZYCrRp8NOA5qsDMblI0sUsRA1Jc3fKP5yty8STUTM8LcIAPDAvRw07tCJZa84tN/H6vb2eOQlLho0sOWv4xD8xNTuLgK7dn1LsJ9DtYPFqjMMv7YxOLBewOGzJm2QI/UMi9HPYCnJw90XW8UbLBDtz2UDc8dzzIEh7vwUj2co8jTnh31BkmYKoMOewmfgVSkYBZEkxRRTogKlELamwo7HW6kLU8NZji7+/JraN4OXWiMRWL/QXqzp1T4a6BC9LASMVMsy217J8Z0v7TKK4mZP9gY4mOYm/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbQ1orJsWaQqaiiBueVscm1QEI+OeAjs2S7X38ZJnhs=;
 b=acLEqam0pfzGDJpr3qbU3MLdZALMVgs49CQMRljTnOqY1ogpHTUTDOjMEE2MyZiZVjrdHp2+Uj00BLcMj6KasTLZfsZY5NYUwhfDlzx0vlE0NAQ81dO04x3iydLE0r80mU07dIxcRecazacpcJu4cmERGO4SBQK9XkcYg0PWTl0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5747.namprd13.prod.outlook.com (2603:10b6:510:122::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 18:37:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Tue, 28 Mar 2023
 18:37:59 +0000
Date:   Tue, 28 Mar 2023 20:37:51 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Manish Mandlik <mmandlik@google.com>
Cc:     marcel@holtmann.org, luiz.dentz@gmail.com,
        chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v9 1/4] Bluetooth: Add support for hci devcoredump
Message-ID: <ZCMz/7L8GdMzDDT4@corigine.com>
References: <20230327181825.v9.1.I9b4e4818bab450657b19cda3497d363c9baa616e@changeid>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327181825.v9.1.I9b4e4818bab450657b19cda3497d363c9baa616e@changeid>
X-ClientProxiedBy: AM0PR02CA0189.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5747:EE_
X-MS-Office365-Filtering-Correlation-Id: 67707171-e57d-466e-8c9f-08db2fbb8dcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D4NVwt+uqLziQyYWSMUBonqNuX9UXjph8DzIjCLpvOvxZ4Spy6JBH7oLwtflDJ2KwHKjubTHFcG2nVKjExxeKyI1On2aCcjrFxPpIKGqxrXlaFY5Tg2GliGkY3NZNU5RN0z2YuMq17CNA8Le7f8S9B2zBn9wc7/sOIFlXuQe05gVhiK0qyc40thuqzf2zdysPOcsZ39BP/RIuPJUSGCAcTHJw4sJTp9rt/uBA9JVJFciavy9KH/O0TAqiSJYLKVatwOK5O98zpDxzWPVbVArIXyh0uGRRlfqpbzG/Egiwl1nayyKn3Kd3G+eCg+9RyepybqqIMoaAgGuPx2bcv+NBzaRQZH7tlbzqbbf5KyLNQa+M3XECbiOhK4iXEbdNfVfrQPhl5rCdbJYsVMX4BsULAbzyaUe8hsNYblMC/lvjAHU93n26jhCrrcEBSFZe9zC5EaPFTnwVIM3rEruPskfn0cX6Gj+CNCg7KKqVLYFy5t1SRamqURWIZ2+ifTSbD4MzlD8ArHP6IK/jpJFD72g5I63o3K+2pVsVGCjy8wYfTo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39830400003)(376002)(136003)(346002)(396003)(451199021)(8676002)(66556008)(66476007)(66946007)(6916009)(316002)(4326008)(5660300002)(8936002)(7416002)(41300700001)(44832011)(6506007)(186003)(2616005)(6512007)(966005)(478600001)(6486002)(6666004)(38100700002)(54906003)(86362001)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2aKd4bAPouCeVSgavstHL+9zUgu9rRWJ+P4JZBlitNQZ3D5vtkKon23cDBdY?=
 =?us-ascii?Q?OC9uR7bp05Irg/uNfeCsUi/2UzV8qN/e7dxg4Z00VPyUjVE5CJFez9iaA3Ya?=
 =?us-ascii?Q?Fvhe4jIR9JIqnA9TUk9Z8ZuOlk+mzPB30Cwfn6OYPe6RqIxjcO6IYpXUUfGe?=
 =?us-ascii?Q?oOXj9dptPDLAGK01nUS4w/8BYNcoDTGcU/+LXIxXB2v5EHE6G2BlpGTCudDm?=
 =?us-ascii?Q?SDuWaa3V++cYwFTTqlIGaLskN/Alu2/uHcjwsEX1VeKzn9EqOUv/Gji2ZwHC?=
 =?us-ascii?Q?Wda5Q0Q1IW3EC+ay68sbb21vlVvUElxgPbu1IaeN1aKDwwysa41ehNwwqi2m?=
 =?us-ascii?Q?c0wUOwYaQopG9Vwr3hPAvvAKmvRyOyC7ueIAEd2oIn63Hmkjo3K/iCHH979u?=
 =?us-ascii?Q?6r1rNZofJdDVIdm0xW3oeLc2817TB7F2Xx1VhGDHbVHk/tVGSYP2c/i6rZkS?=
 =?us-ascii?Q?ObY6YuVcBxN2SF97ZgiqG1Y+OVBYv/ahZnRsetIw+nwKB58aVBvWboM11gX1?=
 =?us-ascii?Q?k24qkZmj7aCkhFmPyMkvALf31vDYvF+jm3T9LCq5+YG/rOBWxzBgnbLitkTy?=
 =?us-ascii?Q?rOgOG4lJ3gm4zR2rMbqIrTEZsaKMq+T8yWmIr5JMwZCTxO6+QGmGEiYH1Vko?=
 =?us-ascii?Q?m+JAuq/+BJnZnlrMwXkYYdxHdsc8KXKnqy29Ie7tHyjpbBhobdPX3FGQZAYd?=
 =?us-ascii?Q?ksc7e0BObi+3s9iTCz5p/3ZuFr3FyW6gBOm8AS9HwO3NNHpn6rjOsuVDQRzg?=
 =?us-ascii?Q?mWyps5Sopv19YRGqRWyfNYN+hfhj/00pUwuKW0alqtm4jaQ1EVdYap6RCMZA?=
 =?us-ascii?Q?eaZtQcEeTGGOf+5ewrPeUbobhKWrYXsZ5/MtFudgvT0HJ7En88OQqMaSwGmp?=
 =?us-ascii?Q?jd6x3ccNcpv3O5TOr3g4X6w67PvaJEjqg55aaSH/zxav7OaNh/biMKxSRSqW?=
 =?us-ascii?Q?Saw8h7DmNiiQGLcBaqrWkRfIdDGZ9K0XZkLI+u1caEouAVCr8RuIA0Drbew1?=
 =?us-ascii?Q?hmNviFtLXbG89qfHPovhp+KLDa1JvjB3kPQg24vOG4Aan4of4Z+QYSDbwoub?=
 =?us-ascii?Q?yqWDmZ7opiu5eUf0KFp0nL3TOMN1oivlLYS+JEwtnt0zBDPwnseuP7zZmZMJ?=
 =?us-ascii?Q?1EHDCc/JOmfVoBlnnu3uNA1vlRIHqzoYZTfU6qg0jWjunGoz264724KhlyJh?=
 =?us-ascii?Q?RYA8468AoFXdanzDEJiChstHlkp+VuziRRx7ZDB+MOwQfpqbLORUiJZh+jhm?=
 =?us-ascii?Q?BD5J7r9pd7qgwVc0KUdEYX1K6G67p/KdqExeW8bxUJpMIwj4jLm0s/nkTBu2?=
 =?us-ascii?Q?+gLbdMGQdYPx2yvv/VGN13aEMSgCfDdi0ZrzhPXpPeoFyVokCh2k50rHZCJw?=
 =?us-ascii?Q?u8RXtLmH/a1ZMmXXlDCcicL2ora3Qre64SQ4+kBKXFkI5uLMJCiCFk0Qpc3m?=
 =?us-ascii?Q?A+/g3WosXzya64LZEPhJL9GbwSd7Iql41/bPINZ7552i38LXWx73Utelpkf7?=
 =?us-ascii?Q?ejbHNncnER4cONWyzIVevrZWJexXnVWJCrltAE0PDZkKoyDIGNT0Psz85i9q?=
 =?us-ascii?Q?QFeKhO1qHbCu2fVi6Rsm6KNQNogOsFd/Ikg/CkMQe0czV4esZ75OVI5Scsuy?=
 =?us-ascii?Q?vYWNEVydMPxS0HVptvUW3QgJfLw6+SKo9NdhyzJ9hmmawU5houkJvWL8vF0j?=
 =?us-ascii?Q?uOOf/A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67707171-e57d-466e-8c9f-08db2fbb8dcb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 18:37:59.0087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uiSQW7jUYvvFh/Yfdw6LvW4Id3HslTpA4KhndKTyA77uvvtCTovhrLywMJEQBlEf/29gt3CZI7SMolG+tES/e7t2ppx6aDTee2/260xrHdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5747
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 06:18:54PM -0700, Manish Mandlik wrote:
> From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> 
> Add devcoredump APIs to hci core so that drivers only have to provide
> the dump skbs instead of managing the synchronization and timeouts.
> 
> The devcoredump APIs should be used in the following manner:
>  - hci_devcoredump_init is called to allocate the dump.
>  - hci_devcoredump_append is called to append any skbs with dump data
>    OR hci_devcoredump_append_pattern is called to insert a pattern.
>  - hci_devcoredump_complete is called when all dump packets have been
>    sent OR hci_devcoredump_abort is called to indicate an error and
>    cancel an ongoing dump collection.
> 
> The high level APIs just prepare some skbs with the appropriate data and
> queue it for the dump to process. Packets part of the crashdump can be
> intercepted in the driver in interrupt context and forwarded directly to
> the devcoredump APIs.
> 
> Internally, there are 5 states for the dump: idle, active, complete,
> abort and timeout. A devcoredump will only be in active state after it
> has been initialized. Once active, it accepts data to be appended,
> patterns to be inserted (i.e. memset) and a completion event or an abort
> event to generate a devcoredump. The timeout is initialized at the same
> time the dump is initialized (defaulting to 10s) and will be cleared
> either when the timeout occurs or the dump is complete or aborted.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

As it looks like you'll need to respin [1]

[1] https://lore.kernel.org/oe-kbuild-all/202303281102.Wu5F8pYw-lkp@intel.com/

> +void hci_devcd_handle_pkt_pattern(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	struct hci_devcoredump_skb_pattern *pattern;
> +
> +	if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
> +		DBG_UNEXPECTED_STATE();
> +		return;
> +	}
> +
> +	if (skb->len != sizeof(*pattern)) {
> +		bt_dev_dbg(hdev, "Invalid pattern skb");
> +		return;
> +	}
> +
> +	pattern = skb_pull_data(skb, sizeof(*pattern));;

nit: s/;;/;/


> +
> +	if (!hci_devcd_memset(hdev, pattern->pattern, pattern->len))
> +		bt_dev_dbg(hdev, "Failed to set pattern");
> +}

...
