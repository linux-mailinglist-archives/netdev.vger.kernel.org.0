Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E896B2AEA
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjCIQh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjCIQhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:37:45 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2136.outbound.protection.outlook.com [40.107.94.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A8E6701C
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 08:28:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQkNIdyApgr/Qvu47KkYpAGAkPEVrXpZazzdTERNeFUhppIf4GY6+Q5k5bk5FSXNrPTpEnL5RiFGNWSY4a4IJ7nwaX3zHXyBClsTZIPeeikVF2kj3u8nZi8Pk/RluptMv/wkAGd3pFT9RrP/1t/Cj0zGlf+3JrLx00TwnyTSdXtE36KBFLyZez+Gv4ZVKkNSjHqT27eauEoBWjmISMQ+rUqXI4fFYrz5D6g0b/WxPZatXt3Wt6wkt7XBfiS5kwgon0HVG/4znONumY1P2xHiNvkDSnOTKV7feWDmLu61DVxgd97BJ9/BgBEx+ZhU856FNW8uZt0t9321IFI368oaew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WjaPDAq+QcdLFaFqY4ye6y1ZZVzTBLogHWrkS0tcEoY=;
 b=Nd2SPT60dxqJjF9kYxiDBvcZp/JLHaAAjXJQ9le7hzrIT4UfbiPOEi2h4RRl/9uDA4GJ1qTKwMUhy3BdWo5y/3A6e5aP2KlEHRzJxLjCi92QQsn2pxkzuQBrj5o03QgnYjMb4U9rADRkVRvvjaFAnEtbI6/RZPiH9XhPw9HG5wUG7iILvDqXZ+DMOEAONE7GQRo8u6Euwcvv74ZLPbWPXNWDsTwhuSHc+DHT707HUEHw4uiNv8Z0IoMP9R5sH1RKf9JUnBB6r+P4CH/XdOG5ktFHp9D9yNJGTVaAtm99U6/trO38ffffaHUW0xPdvGA5bF9ah765zrfIa1CgEgMELg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WjaPDAq+QcdLFaFqY4ye6y1ZZVzTBLogHWrkS0tcEoY=;
 b=CmVClmByWxH/P0/OaSJ5TJ5l9uL0qqLxzdZCypuMuUiYCMZBiOQIZbXw5TkS5VAmzMk0clWJs/zet+iXXHllZd+LiZ/R3r7mMT3T8TxlsqctgNT/mjPmAVdKaynkTkaz7iY4Uibm8Vb/TIdPBLJ2Ha1yAV2iJqoi+DVmJ/mkY5c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5037.namprd13.prod.outlook.com (2603:10b6:806:1aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 16:28:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 16:28:10 +0000
Date:   Thu, 9 Mar 2023 17:28:01 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH v4 net-next 2/5] net: ena: Make few cosmetic preparations
 to support large LLQ
Message-ID: <ZAoJEWH0oi3M7Zse@corigine.com>
References: <20230309131319.2531008-1-shayagr@amazon.com>
 <20230309131319.2531008-3-shayagr@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309131319.2531008-3-shayagr@amazon.com>
X-ClientProxiedBy: AM3PR07CA0096.eurprd07.prod.outlook.com
 (2603:10a6:207:6::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5037:EE_
X-MS-Office365-Filtering-Correlation-Id: da163d6e-6309-4a78-b1f7-08db20bb4579
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ytBKwinkbY234fU2A+BlQKSaxqKLnZzQnS4O/WHyxL4Zt3aO+1wLg/1f0e9V3JGUwcNQgRWzbrTZx/aqz3yhG4cC+SqxV3nPVp7IEXzIcHpzuGk+WV0asCSjchwQZY0MK+pJHJTWfeYwbQgywTm7P4XXdK8vkQbn08kF4Z28OB3rNcsXoX6t3EV7lC+tBj+6nF2m3D7kHkTqpZm+Q2rZbs7m1LBECpIV1O8B2MVy+v4TNXSLz4HUadQl/HqLxBRE7wJYADdT2OsRkvrW2gi7mIqw5z02P1gXxuYShOoMdtOI5EcEleUEIW8GlCjJEDug2csaPBPuadUY/SINhpEcLLK8C6zlPLNNIlBR2Hgul8Rw9F3cm2Z4+0vj51T/T79/9F1X2nS5m9oUBvx51/GNDVWxbww6IIpTLrf4vf/81+SD6AU0ljReN0tQkkXRoLNlw1BmcSjzukFUDhrYVApGGivwfWLZx6s91VMvvukj4+KCrtvw7kYvtW2a1J/hGTI4dqyOp9bM4pcSlJYHkpfFw+PqzXUx/SA8Wg5NkhP0ruJETcAB2sAKKTKAfI3d5WSuCvfzfzyOJGNBzL5Td0yjMtRJVM7UhR2FhdSdGuIYOBTKkgKdxTw2HBIIeroMEXx73L55JhUpt6WDGUIgabALnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(376002)(136003)(346002)(396003)(451199018)(66476007)(66556008)(66946007)(316002)(41300700001)(83380400001)(8676002)(4326008)(54906003)(36756003)(38100700002)(8936002)(6916009)(2616005)(186003)(478600001)(5660300002)(2906002)(4744005)(44832011)(7416002)(6666004)(86362001)(6512007)(6486002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tI0Y4jqCdSdLVPp0Ogk+WJ55GFCofp2FsKm1C+wwHs7PvF8PZunCCRVocPoK?=
 =?us-ascii?Q?I7BoNwpHJukf03rEFO5g315Bno0wtXQruOwMUIW/21oY6FQXU/uK+MMMpbfu?=
 =?us-ascii?Q?SaOADIiNOxGPI+0M5jzWAHCo/Md1raXSBLAiSBVSTAMT6gZIMhGWq/8jrBhZ?=
 =?us-ascii?Q?aTQNajTFhBSvuQnIwTtLn8lAS/6czK8m5VpHWJio1P46BSyhWefTCVCw/PIp?=
 =?us-ascii?Q?GoUYDjhQcW4lkIiOegUuNlO429OMlLaiBbUUc40wUjCpU19jkzIJL6J0ULZ5?=
 =?us-ascii?Q?CujW/G4eguU0ir3TIIt3KYq4iQSnSRubloUVOFxKvQfY+gURj0oVcd3AwpCh?=
 =?us-ascii?Q?dytYq8/f8fzAf0ftekhddYAZzx+Ziui91fJZ32FS6qXxKwwCF+9p+hMGJcrE?=
 =?us-ascii?Q?nNiZxzQIbrIXx+3a98n9JdUbewTtjNAHFz+zbsKNfS45ux7uD7A2t4btVaVE?=
 =?us-ascii?Q?et9zwGl3quVpxZqVokXBpSwH7SzjsF7Ppp40zMPX3pZ0xY19V8tPhi8XtbMF?=
 =?us-ascii?Q?H5cLiNjZSfCQfWVeQ9D0+E1nJmtbc/fiUOQnfF0i2pqE0/QFhZAi+7g9P+JB?=
 =?us-ascii?Q?dtFsNyuZpBJqXZegPJEiVLoqlmC1apZFHmPfJZrAGw3TFcaPSQ7ZYITskF93?=
 =?us-ascii?Q?Edj88zXIaLkycyBPn00riRcAcBVU0kUxqav6a7sbFhMryg7sJ2lbXXR2LYAp?=
 =?us-ascii?Q?9rDtCU+L61CiNLoUsjmAEazZuboi5a5Y4c3uQtCayo8bTykcS8vy9CDhdx1d?=
 =?us-ascii?Q?f7A092ewOmc4bIG+iBmpr7+tf+pyu9DDz+1KjAm1zrZ59nt/g8+lGjCHjfwI?=
 =?us-ascii?Q?koFLH8Lg4g2WND1XSsP5g+ot9gQ9e1W8DDKauUpR9pKpPI3h5vyTIVwuXESS?=
 =?us-ascii?Q?cJnNNcB6csiWUhpJ9eM+DR8TpeDnhn2vZCvSengz6e9GgR7OKDEPc2LOFarn?=
 =?us-ascii?Q?XCcmgOmXyZWKalILLac8AwiCukJog0LekyI2hDYvVuKbCimkWyR6MXcQl1q4?=
 =?us-ascii?Q?4+ay5NuLJ+JFGyXXQCcscpip/fXvfjo9FqGiGAThD9p+Js6sW1zZPdrvJHEB?=
 =?us-ascii?Q?jFTSo445zsIvQ0I5GQhMbPGiP+2hPTl6Iirh9LIrHs0b/vlIPJF117UbYDfM?=
 =?us-ascii?Q?64fYU9KRg91INp4x03wThaL0Mv/MzB4k5Sw3j20jI7yXksIXxg+vGg6lgCfo?=
 =?us-ascii?Q?M0WZjUJlXwnTyu7WWakbNlYvOpnbO/P85FINSoMZ/xeIXRw7dMPw9zf6hzpX?=
 =?us-ascii?Q?ZbCiNmMa47jl1b9gcueVtQLIB2fuQYP4Ik5b4uDDyHtlHQMI3Uqt2rN0MYQe?=
 =?us-ascii?Q?smCpbhdXs6x9WqUOrRUv9CAslzKTECopfpk9YitCo1UiT2oKB8jI4goqYfpc?=
 =?us-ascii?Q?cBlk1d3D4TeD8UM+jO7yc/UW2AjJF6spXOPOyYw7KFKE6FnYC4Knay/TwNv0?=
 =?us-ascii?Q?l9VhCguP76HyXOw67kO18MfI0r4q5CldTkEKe+zQ1PbNgjpTF6tP821NgmiL?=
 =?us-ascii?Q?dVUix2cgzPKp1ibHnv/zxlYJWx0pdhuLIiCAJv4hd4LzNsVGAfJKVKfdxFA+?=
 =?us-ascii?Q?135WTQVVA5nrGokCzHeBV0R+6Gn6XPau0glRa50V/Ev7Snrvyt9miPGDCYqG?=
 =?us-ascii?Q?UkWg13lEBkB1kvkWJy9d8h8Z0WODlTtPg/lj5fP6mkj9i/xZbAqg9zbKcIHS?=
 =?us-ascii?Q?GPdTfw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da163d6e-6309-4a78-b1f7-08db20bb4579
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 16:28:10.1820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vXLW+toN/vtB8ce1+QZEEuhjk8kwfwIkvzzl7UAqRS3xVo6olxvfmnBuSaN7YOMXzMcPBw5t1tUJ+Szj4qxRNpFssoRmTasSmlt4PvqYZs8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5037
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 03:13:16PM +0200, Shay Agroskin wrote:
> Move ena_calc_io_queue_size() implementation closer to the file's
> beginning so that it can be later called from ena_device_init()
> function without adding a function declaration.
> 
> Also add an empty line at some spots to separate logical blocks in
> funcitons.
> 
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
