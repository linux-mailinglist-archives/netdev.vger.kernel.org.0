Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D457D6C8DCE
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 13:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjCYMFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 08:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjCYMFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 08:05:48 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2115.outbound.protection.outlook.com [40.107.237.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21193AB4
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 05:05:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BuZppIbu8kdbQpH2/XPex7fg7iiAv6f8OXfT++ZX4R89KFHMPx1eRvXn/Q2SBEv5uelmdFs/Xn2sfk5i9yr6YJIT7709+LyO/EMxz8SBNfbf4B38o52RVXs3FsGLAqbZORosIZLMYsJKeLGG0EdLdhkUY4uG+qTajfn3y8gRhZbxXNzTrE6wKViPl6ZksweppAbvmjBnVD5J9/iGhm2MCRAS4MTNV53iJXGXQ6snGEAKiRHGyUJxY8alN+wIS23PycS5Dt1nwUMf8a+UT0uBYeK/gM7VDUmYWIlYn5pJH3Xx6TPlo255P8Nb8mLFLpevH8WJSjd6YiZA7hUgsvSSmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q02yFHp6xYQsQyADzF27UTCQLO60H0mriP+MgFg6Yks=;
 b=hbAN2gMrjL9DRpkBnTT7qQAtnkjH13h5MpLNZYRyvP7YgtqpoKVioNzHJT9u9apk9dzEKEarIUyiNKYKi0MWu9fL+sWV4oPdHZ9OrYlOTexpm2c4duPbGiLPtfYKTrpAZ1FLrbwcTPQSNfQ+OMKZyS9o+ty6SHNcpSUsjQ/MwdP0icDSMvLBQH69Rl+WO32eQOsKUV6yRWboV2YoC6kAF8Oe0iquAtZgg8zS4y75bZ2JBLb5SWxOTbZ/oUMUqelA5YNdaDIc0cM4RzpRYcai9nqUK2ywN1fNZ8C1hRkJfOSIFuQ2wqMBAEFEL7dGqswE0+ybMgT8alDVtvcw8NrB+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q02yFHp6xYQsQyADzF27UTCQLO60H0mriP+MgFg6Yks=;
 b=finYf+sGx5xA0mjpKRspughgKEd4PZrtoTGxd60Z7fmjm1zhzhY14MEPhjLtmOeIMrkgWRKHCXilXKk+wLZLEyi3yTm8fOezFbIvrNi3B1twJF4c9sIShbXkvySeupY1DPP0GxGSKHvuje/VzM/nhnyIz9vRowSkwrUDPA8W/Jc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3938.namprd13.prod.outlook.com (2603:10b6:5:2af::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Sat, 25 Mar
 2023 12:05:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.041; Sat, 25 Mar 2023
 12:05:45 +0000
Date:   Sat, 25 Mar 2023 13:05:38 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, michal.swiatkowski@linux.intel.com
Subject: Re: [PATCH net-next v2 1/6] sfc: document TC-to-EF100-MAE action
 translation concepts
Message-ID: <ZB7jksvQSC3OXFgQ@corigine.com>
References: <cover.1679603051.git.ecree.xilinx@gmail.com>
 <6d89d6a33c33e5353c3c431f1f4957bf293269e7.1679603051.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d89d6a33c33e5353c3c431f1f4957bf293269e7.1679603051.git.ecree.xilinx@gmail.com>
X-ClientProxiedBy: AM0PR01CA0088.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3938:EE_
X-MS-Office365-Filtering-Correlation-Id: 57a265c0-8316-409f-4d91-08db2d294334
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k/yWVOx9o9T733CiWYIJEy1FfweVH8jGGhXeuhRxQ5QYtx23ipOQgdtPfvSaxJgMWGlF6qpgWGyBhTsxLUPgckQQIuGXpUSX7ZoyEPgtONFPL8Ry1WW0CfpUTDNTwJ5Jfo+XtrZOLopzhR0t2p7ARFgbiYfxgOHtliNMWzt8t3y1CIBT88rTjRo1Qfyupaw10/fvRy7SQayLpykh6o4M9ay9ElYm6yT/M2Ow8boILf154pcCLK9V/Ev12WWZyhiOSFbInjQDPV5NzSVKMYdnKZkDZiOPGxAjCJlEZlbhk6nk6GmMQMmEzloUDlSOTXfBpf8lo08nJ6o+S3Gdw96yWU9c1gEXkW0rWPVV+zkr0FkavACvzZWuh9pPaXupS/vv7McsXEl8G0Ttjz9VX7Hmnd1WUI3lnkBJ3P0LfKRZyQvm12AfWcajsr2q5Bqr7LH8iwj09kyux7Cc3F7/DDld+T21a4hdLY1zKFNIpDsGVy4sEQlyuXqSgBfmhlMyAzC45Xf2EggH5AhHwd1K24IxIPGXfjgWxYQn0zt/Vc+WmpuCTWDERjLlvXxP1sFVfxyw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39830400003)(136003)(366004)(396003)(451199021)(186003)(6666004)(36756003)(7416002)(558084003)(2906002)(38100700002)(66556008)(8676002)(6512007)(4326008)(6486002)(6916009)(6506007)(66946007)(478600001)(316002)(66476007)(8936002)(5660300002)(41300700001)(86362001)(44832011)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XViSebSsGM9j3DjXCX8094SdrCutwB/MY8zelFfTe2NJUO5Yye4gY2fyAtsJ?=
 =?us-ascii?Q?/PIfNaBrS+lR0c8ZUnkIiTfkOQ9R3aIzA3YRWiKUMDW1rGBCIk/5f79ppcdO?=
 =?us-ascii?Q?PIUwtBz13kTS1RauQCr1Qvm6ipzZ1ZMlFeux0J7oyzcRMksmy8o0uc7HhvER?=
 =?us-ascii?Q?llld4lTTMxPycpuNbTLhRmjBobwP7zIo2QpXoQ6rHiTbrfYSHgjPXYaTydx5?=
 =?us-ascii?Q?oC2Q0baBdMdwIjfZQrLMytU4rZ6y8+i88eS0WbEZQp0QErSDVdbb9NPX0TZN?=
 =?us-ascii?Q?oZ1Lls9DRLEK1gI5W4uAUFKESgJZ9vjO0l1ee8piOv20Kzd+ZQsZ/73msWwS?=
 =?us-ascii?Q?XjD5pnh9Ng/wjznTFvzG9RWEBObQCWNSkCok97EiLb1EVN3GQOWTcPPPtA2B?=
 =?us-ascii?Q?h6GVAfHjyscj6gz7myNLuzOlMzrSUlX1MI8flUanX5iPbWnDUxcVKraTlHED?=
 =?us-ascii?Q?n4ciGIYLhyADHnT1PK34na0QBulaeasPMUz5RGBgFkfXsE+3pTbvfJ6sowqA?=
 =?us-ascii?Q?jrm3GHPOrPkukQf2ylDAxmi7620G3jjTOY5wiB+h3WxsXrZxsA62LozyoDop?=
 =?us-ascii?Q?2ZoAQh3kW4WTzioCEvOt6vNOmTKq4zWRfJZ2IV55bRCf81eFpi+C8IGxqnmS?=
 =?us-ascii?Q?eLBx+zge05mfOqkm3acPdUkSVYJvDckVQvhHr4bEQHVMY0yeheaXrCg5hGwM?=
 =?us-ascii?Q?Rhl3pCr9OYzMFUI3FDEB5lqZWT8rBF8RzIXUGywsprxsrb9khQ1mMfDvpv1s?=
 =?us-ascii?Q?5loSzmpirIJ9zztjhvX8Hz/MV/XSpUTvkvNylpm9iRE3h8u0aN4aeJU0y+Ps?=
 =?us-ascii?Q?NUTt86YHm23svh6evCSPAmjygKG4k9SbQkKMuPg2eHG6tck2fGcV7vCGV4b+?=
 =?us-ascii?Q?aa8PCPq78Pu4wIU0y6LPLTOhHytPiB1YjaYsr4XXK2efyYjIKnVA94Sw4k31?=
 =?us-ascii?Q?KaCD8Xs2iH6rpY6pKdcD5+zgQCkraNl3DIqnzsTq3OHVRafjXsbBkUr28Ws4?=
 =?us-ascii?Q?znXsPpTjBetiXTKNMXolkAr724ZJuWzARByR5BJ9HBO9DmcLsefCTGih9dnh?=
 =?us-ascii?Q?FjuOss0iiYwsjYFKynPW12t4j7t0/C7aUwcAVLgxilKCeInlRFqiRcL0yJ2i?=
 =?us-ascii?Q?ACMb6dfQK6EcvIECy0zs+Zo8nDfdoHlM2Okk3yWFEzvbU98SI5KQftsjD3ep?=
 =?us-ascii?Q?1uruObbHNpNHpOhjkfLF7ypn0ja6q3lxvGt6e+itWhKK1MTdXRhVcQZpeelf?=
 =?us-ascii?Q?rbnh+7EH0C8FrjUUXcTbxGr6BtWQLsKEJr/ZabDAa2xWzyuELC3wv0L13upc?=
 =?us-ascii?Q?SUtJxmZrEvNqb52e/pCjPLsJt5sjqxuuBAg8AK1uHTHUrZfR09IpXZFG+lpu?=
 =?us-ascii?Q?8CAC4NWdcxSgeIFeSaLz5wi+Hsx13tfiKOQATrv7BMNF1M4Ev0ov1FdVUh3b?=
 =?us-ascii?Q?tNFv6+R1pUARESw9tIXSa+AU7eiaawKHZsXRXig27MfUgK6wvKtuqIyS7Dab?=
 =?us-ascii?Q?02C9X9+Nvhxi9f2rOFsLzkTYOTXl76D1uCH5n+BuFGtrUdKdYuhWyb1rB0HK?=
 =?us-ascii?Q?IWCDxq1DQzIES8ZUxpxQE98WfRdXeaf5aVDX30SmnjFOeBHJSwJ++stdphk/?=
 =?us-ascii?Q?pQNw20lN15KsDctG1h1fcCKfX1tiHI0ZvspeRDZ24AYifCAjcpJ7gAVBBC1X?=
 =?us-ascii?Q?qAcSTQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57a265c0-8316-409f-4d91-08db2d294334
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 12:05:44.9029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /BLLqiK3Z7cPmCcZ8eTUuYYAw/CifdC8Dn/S765WvfH9aC+NYPMlW39+jWNyPZiBcnkAlqcI5g5FqzcuH6cBLRqQQN5Fd2GCENqwc7PQMCU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3938
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 08:45:09PM +0000, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Includes an explanation of the lifetime of the 'cursor' action-set `act`.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
