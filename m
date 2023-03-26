Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C839F6C938E
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 11:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjCZJbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 05:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjCZJbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 05:31:32 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2097.outbound.protection.outlook.com [40.107.93.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC997EF0;
        Sun, 26 Mar 2023 02:31:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IE/wXck2rU2P6lVtV9DOkuBTcO3oj2ZX0HNclqrF725e0eOnivOUWeZVFCbOk615I1ACZJklJd1Zh7S4m3BMMvuHxxQecK78j2Jd8OlVYXR05Ut8OotsAxwI9AH6ivFDEBqykM6nA3M5Yt8txxSikajvv1aKE1CQdnsCOFC9SfjGiA69QrsA3fmxcTHV2P8iUH/9OiBDENnD2ZqVzlMdUzo49okSkUD3+yi6qTRSUrWAMUSlEUshtyGfHMfHOnrwTZaLKSq0I33Yw8YqkoxYetPjYFBA/9wpc9whcsY6Ndt3HU7LoSxZVKYXIM+HpQK4I+GG84SmNAFKLyzsceQ0sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vETz5EcxKSj+spgCxmITCDK8ytA/TxHrB7+Yax4XveA=;
 b=Qj1E1W202t9Mh2sDX2wd1zyaUvxs9W85sVYUTYOVDbL4/DxpUBoqyrj4h0OGttphZD9YeTqAKbR7zqfCcyAIWbZtB5HArm+DpoppLtnl8ZTOY8hbZFWLxAHDLp+SAaSadE9VdPM9ECkUDctWshLXj0DYUh0/165Yiyud1dr1v90eWDr+dmP7P2X5J9Laxn1mGuoeEPnLLSO4fAgf5r/OihB08P/V/KNbT8nnl0x8n+bhsNGhJ66Irqn1RboE7Ig8Xro6r+oKst6uZwLfK66FqBvj6NwQBNotIPOBwNWOde38Lm0b5jek6DwWvBzKttg6xb2cByfHMqHmGFlVvPJfxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vETz5EcxKSj+spgCxmITCDK8ytA/TxHrB7+Yax4XveA=;
 b=G9TzeZLFJyDZcwIgasv3V4erjWNprrrRQ4kRZc5hn/bVNuzMiV9ncTNWimTBfJHRJpzWq8cmYCyO+lJCg5L8LpE286jdL4ptFIpBGi3LG/+pTc24ygrSJIaWygIlH0pli3Ukzx3Ku6tqFLKt43WB28jofDCouB/PkICkg/7Czkg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5463.namprd13.prod.outlook.com (2603:10b6:303:196::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 09:31:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 09:31:23 +0000
Date:   Sun, 26 Mar 2023 11:31:16 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org
Subject: Re: [PATCH 3/5] wifi: ath12k: Remove redundant pci_clear_master
Message-ID: <ZCAQ5OV8s2p4kS9F@corigine.com>
References: <20230323112613.7550-1-cai.huoqing@linux.dev>
 <20230323112613.7550-3-cai.huoqing@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323112613.7550-3-cai.huoqing@linux.dev>
X-ClientProxiedBy: AM4PR05CA0017.eurprd05.prod.outlook.com (2603:10a6:205::30)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5463:EE_
X-MS-Office365-Filtering-Correlation-Id: d8f34958-4739-4698-4a7b-08db2ddcdd79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BEpPVvEl9A+zQPpBhb4xkh52j5cTvEAIJDhdxIjLcPHBN30WoR72fsH25NhUbRmZ/nNkMt/0XH/iKIrNLcHtW1gKIhmoExPmVPMtN/uDmH7oG3Qhs1s+NB7mU4gvSuYL7bpq3VU8clhyiAOv0jMLIJEYKwoO6aGgIpGLA2A2stqBn8GgyDSmK97eo4klocc/O8k3nKyX4WUZCj3B63XIkIsg6cYeM7NAup6y0F74q66oKqDcmHwYFtQurOgFtWGM2zhcPNK8/EoNj6X72T8Ry0xEBS6qCjG6CQ0HBqnSE7Lf8IjD1gZpEqur3ThYrW7xYX3Gj4rUdet/dYTUsEmd/nzZYVW8lwreSoli9Uan3nCDJswdqR9btwFnzHKdG+dFj5exjfW+6Bd9M1Vq69bWKqY5nQiGQEfIqOYC+Gvo87fCSLI3lj1TdrRpd3JiW4qKe/TJ71215LhxsBSJm6Xr44aGeLtJmtl98h8WidIUu186wO23A3O5L7LNO9VIqPbRyWxPLCCG8yFWk+MyowQzN49c6L4U1YjBPGrQjkOmeU5GSeYnmlauy/uydJnXiD9U
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(366004)(396003)(346002)(376002)(136003)(451199021)(478600001)(6486002)(38100700002)(66556008)(186003)(66476007)(66946007)(6666004)(6506007)(316002)(6512007)(54906003)(4744005)(7416002)(5660300002)(4326008)(8676002)(6916009)(2906002)(41300700001)(36756003)(86362001)(2616005)(8936002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ou2NCf2yC3JZhiNIBS8EkYLucugY4Jf9wB80b7f7fX5aBdVrVM3/WoHIotBc?=
 =?us-ascii?Q?SyNPHZrBpLEqufAaOKNVlBbmO2O408Y+5kkXErDVKwAl0igNYhBma+SSJ1j8?=
 =?us-ascii?Q?id1gWinCXkwccL+pz7rcZn/L6t1199wIcO39h3VNvZI4oPm5In5kq3HAcKJj?=
 =?us-ascii?Q?/C9JKoNZ3WU0Z3IrqfJiGnkV8jBrf1Mf4DFgsdjL3sewo8RFhOE1LUJt2my7?=
 =?us-ascii?Q?B+XhgamCc9uaJRFLFUASCPBDiP+jrbmyUWWbeIp7C6WoTysnsTKjmLGe7ZMw?=
 =?us-ascii?Q?nwpdet1KzbNM7bHiWsLoLSfJi8l1J4inDZQ8ckk/bg4W2DM5Yg2nVxWT2QWz?=
 =?us-ascii?Q?2AvOuKKGFvSsfZBV4Yu7Dvkk7TkNTw2DCyPIJsRFqw5awYLimwc8z9tIIYhr?=
 =?us-ascii?Q?QtwBUuagOKFg7yh+wjkEU8qsAwKeAu822XTHHfrFJ93cJuNwwIaL94QYeXvJ?=
 =?us-ascii?Q?3Zdk0LiYh68L0CWbw3KpttqlGMwub8/smye20/WUTliExaeoLeQha1Z73f5u?=
 =?us-ascii?Q?BYI3MfQnD4w3FvfpkdH+7xXFAvREXxN1NqbAR3h7O++bUwO851lv8sgGQhdu?=
 =?us-ascii?Q?UasmreVooJIeLj128iSNq1IkIxp3JXVFlbQ0eiAYV3mNm0WfGqCpznNYRPfF?=
 =?us-ascii?Q?J9QtHQVl2rJ8sGwMkJagY9/f24DjOpLsu0lwE8PfY9yRuQz++UyM3cdKei/Q?=
 =?us-ascii?Q?s3iCGREG3AduI+YlN/WRdm9AzAek3FasIaIs3dv6mR/qYW0Az6vsOAkBTPr7?=
 =?us-ascii?Q?0/OO672wBHcfBs0JyvzzvmRZ06u2PKWaSNcevnF0bQSBUDBVr+DCOaGaurq3?=
 =?us-ascii?Q?lv8pXmXEtCjYOIeD1jA2Npb7eXheWUsrsyK2/Oda6R2KN58NDOuxKnNJO8E5?=
 =?us-ascii?Q?I9KQVH2ict5fOF+d32B0WMtMNKK+IX8dFUH0G7xkGHiMyZvNFTR2+IQW6n2V?=
 =?us-ascii?Q?ifLLTnf6uKzV+93MNYtSnwVBKMwChKrAWT0646xfgZTSd2GXBRthCtiOZEe9?=
 =?us-ascii?Q?BgdRmegT4zpJNOIW479+yUDjkNgwTYCBcKaMSEUBc8zLGXmFqY12s932GB6C?=
 =?us-ascii?Q?oBAawXaT37qWO87F/M/JeCGD9SsJmw9Z2OMlijXqUFOncpC06Or8tKkXBvim?=
 =?us-ascii?Q?/SKc36Q0YapRb0/ylsBC5oLsgjGB531N2G/gUJfmTkV0MJObifT1AT9OfQck?=
 =?us-ascii?Q?f0XMgT/IvpcZyGjPCB85SQlO5MTml/jd9YNHhe//fT+hU1q5BEfSpjXwLwNY?=
 =?us-ascii?Q?L384+CMtHEBnuBNpJgvdNHmFriv9U0dL6BG+y2EAkVowGJXkeud2JTpBtA97?=
 =?us-ascii?Q?xBtJfEn/EtkeeGrbU/u9LkK+0AHaJmf2/xIQTk2AIPAjkyiVLJPYpKeAq5rw?=
 =?us-ascii?Q?P2flL5m5iIEaIJa2qHP1J6KeAUI3zWF/l4inK9vj6njZrzUdn5FQaaNeDlKQ?=
 =?us-ascii?Q?0+eAGkeegU1rYC7vX7XHsOScU0ipgDBZMLlNKXU9y2R9vUMHjC07hJg0rslJ?=
 =?us-ascii?Q?RrU47GFq6+86oSW0/QRW0ugJugwQINtHT9yDNRAaz/i2Cfuuuvs+ptNx6NFM?=
 =?us-ascii?Q?SQsbr6seZCmAnAbB+MidkoEfwaBxhplZ2BOiD0tsefV2G3R95Vx3gkXdTQvL?=
 =?us-ascii?Q?KnHGB0MyLvIUX3fcSPOEddn8XDb4lS9xAcuO2j+LvJZfECWi2m48gcPQI6c2?=
 =?us-ascii?Q?kDFrdw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8f34958-4739-4698-4a7b-08db2ddcdd79
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 09:31:23.6557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AR2dNbwmjYIdc4UIaKGMUOoXnl6o8BaChcnQrTOky5cUbHnbPLRjvz8fSdhKsLfFDc961sHLjwX3ng9ss92oQlkia8rQPuozQ2TvRuwbXMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5463
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 07:26:11PM +0800, Cai Huoqing wrote:
> Remove pci_clear_master to simplify the code,
> the bus-mastering is also cleared in do_pci_disable_device,
> like this:
> ./drivers/pci/pci.c:2197
> static void do_pci_disable_device(struct pci_dev *dev)
> {
> 	u16 pci_command;
> 
> 	pci_read_config_word(dev, PCI_COMMAND, &pci_command);
> 	if (pci_command & PCI_COMMAND_MASTER) {
> 		pci_command &= ~PCI_COMMAND_MASTER;
> 		pci_write_config_word(dev, PCI_COMMAND, pci_command);
> 	}
> 
> 	pcibios_disable_device(dev);
> }.
> And dev->is_busmaster is set to 0 in pci_disable_device.
> 
> Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

