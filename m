Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034D26AE521
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjCGPnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjCGPno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:43:44 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2121.outbound.protection.outlook.com [40.107.93.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCC04C6EF
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 07:43:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JlW62pksPKkUFA/OhjqqM+wbScQiml+N4/a4KxqJ7C9ItgrI473NMet5TV1nDKxUnjJwZMxI5z9y8hrX4YB7R4cdL0k1dmC7Sk/Q389CLNa3gXn6ykDiH7nTPRvvxl2FWnwR94tgB97QTTFRS7KjG61Cxu3jfyWWgCorl3kb2iNeKxuzm7DRoSRX4o1lnN3hNFuNtcjtaRZLdFrbLqUiPr0WSyyO8dw4u5bQgsbmiGK/ShPVe9sciiI7gMmxjTEHcrjn6d4VOtIJSroxnLu75H8x5dpPESRaDDQPQP68MxFVwR4idFwNWe6ydKjtraWQeeJl+yyIMbG9WsLWRewyzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Brf9VSrStiL+nau111g32fEbZIMOmBxZXkh0XmHAPzI=;
 b=DoB2XdZC8AMFAsEfWpc7QW+bRFki2qZJzOkj+3W8ezhWqkgLItOTbvTUuGw5YWEPt5KXLHVVxWLt94nPmZxV1Mc55g0IFLHzrr8xcNsntlS4ZAQb3PCzXePGZFLaFChRzC4dvmVJGa/b94SoFro0D84ePdFDKhia3nh3h9rRkPazyOjeQpR8KkwghMJv8+9qZAbWJ3CKqWy6dyvhpGE4N18s2WaVc2koo6+Rk7e7rveFF8sE+Y8LEgm0Cb83s2kL70kgyLrQXtoARqk/z0dcnmPoE5mizn16PV5sdQD8XA6eXVrO9wibpXRdGwcd2acByNpRRRTOtP1nerJP0Cq/3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Brf9VSrStiL+nau111g32fEbZIMOmBxZXkh0XmHAPzI=;
 b=jkO6Pnw2JaNiTlEsfYR6iSF/1FhvGICY4PjkV00d86ADSKOUsMf22cGXipJ25lH/84R97ZC67s6XqiG9HTBN3STcJu9CZfSVosF2GRAxmaUQpDkIVzhmOTNAWlbiJAQtaZkFFEp3X8kh+UzZEc8PXAKt4lRJ8ORozWXNEuzggHQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5324.namprd13.prod.outlook.com (2603:10b6:303:14b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 15:42:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 15:42:53 +0000
Date:   Tue, 7 Mar 2023 16:42:47 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: improve phy_read_poll_timeout
Message-ID: <ZAdbd5NLQMkCZrk1@corigine.com>
References: <6d8274ac-4344-23b4-d9a3-cad4c39517d4@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d8274ac-4344-23b4-d9a3-cad4c39517d4@gmail.com>
X-ClientProxiedBy: AS4P191CA0006.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5324:EE_
X-MS-Office365-Filtering-Correlation-Id: 57a592c2-f3dc-400c-dc94-08db1f229d12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WXx6i1rjWjChyeZLjBNU+kYWe/3zizk7Rcg/CgVt72zb3anZwlNAeKwoqd45uGYV3Dv8PRQkLibBABdfwZ9TsY7gcYNmTLle2Z9aAkLkkK3nR9w12gFcvggzf6f8F+nWKHNsGgEE9K+OwS5YONCrUymwDsDRv4Ud0Q4R4mmnSVkFDVHippbwvxqz5Mmij4LPwIN40DttIZkf6Q/CRRjlVCqVNOfhpFryevGvq/w5CbGg9VXQnd73HaVJZ/vSz3+IP+guiRlWtBABosxY8GHFmuybE6BwxgOMZuOQmS6sXnyXxEDgFcMc8StzGM6MrQ3CqCtbw3x2MPgDR0t6GXzVDku3nZqSfQBGGBc4bUiAGimrepZg/hE21loeTFmYccdL4AcsjojMu0QqfZYoRBuTuYA6nuWGzwX97Zy4UisuG8TPRHc+abafo+rlTOVsUTlBuzImIyXbjCIVcQ3C6+ZcYiXDc1G9YesuiKUBfuUCZyK57feimciNEQYY8paMfKIX8d72APQrPM1Mho8UGE1azx/2Rd4rymsZLJJAbQ+YNP09p5CvNI+ax/v3KGy27+PIcPAwsFs0W+Clcq/JtVYFwLg2lOMuF+pAVnlf1lBhCQ1MlqpH1WHYpLO1dALKwzbT8hbG8cX4VnhOwC0R8SE0fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(39840400004)(366004)(396003)(346002)(451199018)(54906003)(316002)(86362001)(6512007)(186003)(6506007)(6666004)(2616005)(83380400001)(478600001)(36756003)(38100700002)(6486002)(44832011)(2906002)(41300700001)(8936002)(4744005)(66946007)(6916009)(8676002)(66556008)(4326008)(66476007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7O6dUKCkVSY0C4lt8dmSDSRoUotapf5alxUXxud3PPD6XRBIAa27p5Zwv9OC?=
 =?us-ascii?Q?BDTcUGF8VgtRiRAfo65ERfg1SuW2BoPd6mXfSmVgRZyVcIRKYA2j0Oasqwtc?=
 =?us-ascii?Q?fg25FlIBwlXqzVRIPCB3vwPDkDljwMxNbZQKbModIaIdYk3N8aCDoBHfwtKu?=
 =?us-ascii?Q?HI6GN9gTvyE1HoAFFs1JncawfCmxeNZMYpqBD7wqAMuaSCmXju4U2xJeoMjP?=
 =?us-ascii?Q?BCVy+BiGrLE4Gywvr2jshE0MtbgTdPFhhVV46+k3qEnPoQvcK0ywi1pZ8+WZ?=
 =?us-ascii?Q?q+SxgjjL6tcZwHPcz45aPw6DcYK+aZ73rtNH0hEbn/8+koeXkYvXJv/m/PLV?=
 =?us-ascii?Q?8G6RPmOQpqP3AYQTVYRKVcmmfQ7bkeUKUk8ad7wWfTc6qzy+zc0qlhHc0ybN?=
 =?us-ascii?Q?YQDSR/8hy3iZWpFdzCIKKB6WDP8egm5987WT5WWHWTBHjwJ83Us9unQ2KIUe?=
 =?us-ascii?Q?gfP0mwygMeNebvYaCYM6JYvGk4ZcbC4juscg89tMjc+GRLv2o9/dT74FkikC?=
 =?us-ascii?Q?7lIirIJGW3tnTzs2oJntqOu8EQQz84ofaxH6gYpncLkbNXfNnwvCnnROBIMg?=
 =?us-ascii?Q?S2dr3sD3tnEdZmwqzZFsXlvwzjPBXWepB3BN9/HQnss9lo0hVU75gOnO5Eky?=
 =?us-ascii?Q?eXho56N35md7ifJP+JxoKHLMneNm8TtvzTJhjzvk1vr4VPjOBdYELh5prrq5?=
 =?us-ascii?Q?yjwepYX2St2zh6CxFRClniI1GbxCRPAviGr95Yb13ancCoPB/4a6DwPr6Gun?=
 =?us-ascii?Q?EOhgKqDRiu/ENv8ESgv9TsjTZ5H/690iZorbIAgU67cqFVafaIuNbAoVRawc?=
 =?us-ascii?Q?k9IdnesFLPxnD4TUH9EXm4KZyUPFhLkILCpu9S1p7snVYI5JkzkM9jgsTIQD?=
 =?us-ascii?Q?yLA+jD1JV7NqhxKlnXQC5QkYZoTSjHY5EjBFGmhSdoKyGWSNo3hn9XvCnzkw?=
 =?us-ascii?Q?43nLdx9yJShG+oU5QRwynxla9b+u2H+AHwEaRYiqSVyqpoSjVpvar2ffpxQN?=
 =?us-ascii?Q?t8TYHkHIYpFwcq/Z/dyYqWukkN6HiGhl84x4Bx87TM7nReIZhb+2/Pdxb/F3?=
 =?us-ascii?Q?bWpnm+Nw5Kpzrwv9j2L0fCXtcgvUu7x4TvYHk0uyoip9khZOMsYy2xYbKrs3?=
 =?us-ascii?Q?HAColH4+jwtbe37cB6vooo3/u3KVGN/2FyOtsz8HgxV5kmbUOruNukpL5Jqk?=
 =?us-ascii?Q?9rvXXuzha2+R/MC6SQaOn5oW1mhenv7QdUio3rTY2uJQA1aXzIk3s4Dm7NxG?=
 =?us-ascii?Q?VuBw0AJGqhrsu0k/Qjg9V7tEMJwKewSVVu1q8oS/sulSdquNwIuzWZvaIdmL?=
 =?us-ascii?Q?7WvLeILxI6cCQaelubxPFjEtJd+2qPh8GNsTf+eJavhPCtsF0aisRQKXHAQU?=
 =?us-ascii?Q?TETP1XDOc44ZNMinjW9Nd5GC3tFlS2D3VIioFKJlCuJdTr3xcUT2IC2hqOsV?=
 =?us-ascii?Q?gukpDXCrOdqaPGwi+AUl4m+kAOYK521p06DuuDBYQsHwAzppVpg0ocZT1uEW?=
 =?us-ascii?Q?mEZjZOw2x+Vt/h9AhW3SpPZbhbrBlf8f8WgrCvBUwDDDO/QADyzmfWCIi+VV?=
 =?us-ascii?Q?srpabWBQ1Q70uldLFhr/gqJmYftkEVQvBmIBz268aJd/3DhZ140E9kfZG3T1?=
 =?us-ascii?Q?MwriG+/t/jjg9B+IfJ1lhl7y8C191O2W71Dili5O2PUOWKBiDVBglU8kv3z6?=
 =?us-ascii?Q?BKEceA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57a592c2-f3dc-400c-dc94-08db1f229d12
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 15:42:53.1427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4mfbnvteZjlIZ7ricJl6zKmkZHrAf3oi7EzIfEjXfUecVM8W3zaxK6SAmcakewZbk1rDBhYP1vDPzoMDYBsZeb9ezRCQZ1DOLYAFQhu13V4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5324
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 10:51:35PM +0100, Heiner Kallweit wrote:
> cond sometimes is (val & MASK) what may result in a false positive
> if val is a negative errno. We shouldn't evaluate cond if val < 0.
> This has no functional impact here, but it's not nice.
> Therefore switch order of the checks.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
