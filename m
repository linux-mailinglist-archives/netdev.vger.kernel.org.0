Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC94A6AE039
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 14:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjCGNUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 08:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjCGNT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 08:19:26 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20619.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::619])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EA0233C3;
        Tue,  7 Mar 2023 05:18:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dd+CnsGa0wWgn5Lusvh6+JG6ihuigCPXqJi22lf62fvzSST1HmrwQcWubANZzcHCjh5SW/Z3peusx8fYJq8EaJKfxVMI6fs5H8FE/2PyYSuA9OJRd713oS0bAlWosyHOUPRJBI4kOWt81bSHMPuojSGfoicIel3yeBDmVIZkkVY5t3zn5sKFUn6krAs24wODEzjgM/oZftItGr6ebrp8THupXPLaLKU1UW0ldu8/F2nZbleYmGtRIWyBdWSveWSWPwjOFh3GMl8i4Pp7PXZWPoFnK431QQCoBe9klwH7+MErvnnWI1lV+jigmdNSK5R4xGiaT8aFzXjjwwa1TJOI0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipaGR1WRCux9XxF5fzIrqvpJ74EovDM0tx8RPoj6els=;
 b=aLtu+FkP5AKG70FZK/gINYHa8hFfYQa4JAiEAhfYYyOL3ijxLjeGp8hZdxYt0vcrRfhvgGtIc5VMMxVWsFitJmnCqfEERUPEM46SO5QsD/BwKyYBQOQQpXfyBRsYUxQ6inFaklFsDm6MFMngbDr4lDySWit/Pm93cpYqtgTpC1PkI2qCaIJLd8dJFvya1svMk+Iw+ttGspn8pi8mKdsuqTuPybTHrSlXqGk2ECcjrAB2vd07z+WXamaZNmBV7qGUC+GfuB1MxjMonLrqTP5DxoW6bBYe0MH7H0h6gLKpTKQztiREXErSWsRVdj7B3OB9+vWtqRh76RqesiLAs40cPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipaGR1WRCux9XxF5fzIrqvpJ74EovDM0tx8RPoj6els=;
 b=dwIcTNFWp7gHt9IdzdfM1cgY0cayKyxJJMY6HDWBQF75N/q2vwbVPsUEZSrKVjUjP13wdM/sycj0qLBCGfhErPs5rZyI3cpmFwNV8HXKgAv3+6G5AAIM33WUuJgsNFtAOAPRHFuLNQt2N6upyJKYbKlK+yClVM2Dw6eEWQP2qJ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7624.eurprd04.prod.outlook.com (2603:10a6:20b:291::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 13:18:32 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 13:18:32 +0000
Date:   Tue, 7 Mar 2023 15:18:28 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Song, Xiongwei" <Xiongwei.Song@windriver.com>
Cc:     "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Response error to fragmented ICMP echo request
Message-ID: <20230307131828.ly5zudvllke2pe4j@skbuf>
References: <PH0PR11MB51923E3796E4D2420C700580ECB79@PH0PR11MB5192.namprd11.prod.outlook.com>
 <PH0PR11MB51923E3796E4D2420C700580ECB79@PH0PR11MB5192.namprd11.prod.outlook.com>
 <20230307123522.rtit24jseb5b2vep@skbuf>
 <PH0PR11MB519201AEC268247F6890157FECB79@PH0PR11MB5192.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB519201AEC268247F6890157FECB79@PH0PR11MB5192.namprd11.prod.outlook.com>
X-ClientProxiedBy: VI1PR0101CA0053.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::21) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7624:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f2311f6-f859-42cf-a5ea-08db1f0e72eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lCWB5ZXXxiC7PivrbaR2yQDQeTt3ogBpO5wzyxDGiznzAUliMVB2oWW3eUMYCkmPm73Wptsfqhg2l36Tt+TkNeCGCiXpJV68Cq7y9ICxSyA06GCk9X/BghGYPcADQDaw9m/vB6Y51IvYQpNgrEZtYu+g+f/qkrPTi7j+00zuUziNs0Pll0XKxPobs74jKTqXI5iARnIOkztb4FRy9rJpQ9UD2pReLnwPRm5Vv/u4a5wMcsIVF9bLm1KPbSt2vRj1K9FQDoe8XgiGoQFzIosUUgUrqWDPvI7B9d/8FrJp0zNX757plV2l5E9ifHDiw8e/UJT7ju1R6GyrQBOZvQi+kxu9xKJg2vc+9D1r9lyeTONaZEaYn08JF1POFXUMu+6KOvT5HyKO6Ki4DZV6YeUDW9YDUzvtP3fWRQ0oKuciN/qfXr/dRxR28uiPNlqaqVSgcsSoEMGfX9KzWWzND+K0NJopbU0SmYVRgw8aNMYBskSe2ZViztXgXcBd0ljLBocChPxZCB8sznhguUESZsqWHmys27E0v8qPqVo15NI6dd9+hPR+U7uum1Mj9VnOnv/V4XhenQG26noHXeFoOYIkqYZxyp9pZRNaUI5b4PCHr7MB5R5tNzIei9fXRcwE0ds4cW6IOxJMHoGa7wVKyBjNng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(39860400002)(346002)(396003)(366004)(136003)(376002)(451199018)(38100700002)(86362001)(4326008)(4744005)(44832011)(1076003)(2906002)(5660300002)(66556008)(6916009)(41300700001)(7416002)(66946007)(8936002)(8676002)(66476007)(33716001)(186003)(6512007)(26005)(9686003)(83380400001)(6506007)(54906003)(478600001)(6666004)(966005)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HmWFju5B9r/7LfBN0pxJlXdw1n/yUVTKbMEfO1JOn/+ScOn+ivRFZC76S8+q?=
 =?us-ascii?Q?BmHFBBQr5/SAe4YqWDNmGUpw/2nyRawo0scV80MG0xbvRCgu1RFhZeRQCAOU?=
 =?us-ascii?Q?VB+vW6BgoDwFYGnSf/a9NnPTpDC/uHLkEqlGDLccbTav4dhUP8hfMM5Rwj6I?=
 =?us-ascii?Q?VLG1BWilz95Gjja8gjCvRboejt1gzr6Dnjjv3OmlDAeU/bzbj9Dfmf2Wvq0t?=
 =?us-ascii?Q?TtzF8xndwKiXPZx9Hfso75viVC2Fm0EFIF6J/qlBTZvXRMUyT8jlpqCawWCt?=
 =?us-ascii?Q?iz1E/9D8wpmeDnMaUF0m9evYYukhdZ7iZn7v1ujqYC5dvol0dorAJgQ5Kv/W?=
 =?us-ascii?Q?EcWAv5CcTP9bDLgMKEcQPlkTV+B65jwnzpsHUs/wL1H5cMWLTTACZij1ll1G?=
 =?us-ascii?Q?zageoEMENz0c8J0faL8Ist6YmYBLwKmKe0ngQpZxMlOKGJXg6E/fsRstxUJx?=
 =?us-ascii?Q?FsEisAw1aAE9jYSL6IH2nWpqlUMOPE9LG8QyT2YWPxbpFMM2q3p5Q4fApH5o?=
 =?us-ascii?Q?wc+/cbD9Ec5AjFMAZ0geGnqeCEV3ZZC106DU5Xl7tYe4o68v3lRuAFFSHWT7?=
 =?us-ascii?Q?Avx9cMnJ7yYEasgP7DjzTLQL7P5B9b1dP/0Ru8ObF2xGCDaw3EH6VnrXaPEz?=
 =?us-ascii?Q?8V9KBhhh79rZ+gP75Z7WnVKCaaQdQY9NnjL6UjV/g2HnZKBtKfckSMNln8LR?=
 =?us-ascii?Q?/x0dmgQh/GNNb5ajidLdahaTzrSoP+jyQqs55qLU39TfA5MRcFDR10KcfHpP?=
 =?us-ascii?Q?JzHSRK6wp4wBeEF3HoMsdUTiLF8p4QUmzL77tuMItxbe63Xzzk+DhmfUHx4D?=
 =?us-ascii?Q?zj6OVCHndBFnwJotPcIxRiQabGD/CDvebQIOjPzltzx3JymQWc0o5xxpLcdO?=
 =?us-ascii?Q?qmyi6PcIBQ7sEjcIapOfSABpBh9okzsYY5qqj65v9corIqdTGd3NCGz3MBwy?=
 =?us-ascii?Q?3yr2wbZlE+cfigfibEtPMPRbqm2oylcMMeMd2IF+XJF7WRaRovUmlv8whz+I?=
 =?us-ascii?Q?hDxPjjwh6Bz8NvCrqlaMWp0e/Huvx5WgfH3ZKSuiqaPE9O3n9JvdfnTZNGTF?=
 =?us-ascii?Q?YC3FOCQHRulxkZH9sjuiG9y0BalPDYDn91shJL1YzcejMmJXageliy0n1DPa?=
 =?us-ascii?Q?iV8Q2NvwX8IhgRbjdDeDHo2Eg5xzMaxUADQ3eMyxDmQFZel+PU+ya5Kj/boS?=
 =?us-ascii?Q?RSXbo8lmbG8/Vt6hPpcOu3AgEZ7+9ZTh6EIzT5IYEILWEfShwvv/8FLr58fI?=
 =?us-ascii?Q?Q98VGb6DuFK83RH3Dvm5otipouyFwpICNU0MFml+7mjMa6ihKT1yacP4oaan?=
 =?us-ascii?Q?xf0q61XnkmjVnoe7JIazGx5t36aSZZqJmifajK0maaIyx8w8sO0us8/nauC6?=
 =?us-ascii?Q?2CZco7O9p5guP+BLi6pBmuMxwd0yrnArY9FVK4RrVDWlqDT8Lsc0Zm/s9NI9?=
 =?us-ascii?Q?1LS+rSTPw0MIsWErUslOMdj58NZGxEtQgrxvzoa6yyCiAjOtcx+x4Lwpvefg?=
 =?us-ascii?Q?bpvOeVfiUiLCYFmtxCCx2TC9BADM2iPTMGXWxQj65kARdw7EUHG7T/dw7JkO?=
 =?us-ascii?Q?eIxyJIczwFnnx8YGPv/hsZOVJis7sXAhrbV1rcJ5+j7hKpH6D3k8P/aZJ0r6?=
 =?us-ascii?Q?pA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f2311f6-f859-42cf-a5ea-08db1f0e72eb
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 13:18:32.3450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /JVP4wHrjHSVFnprDlox77aqosPDYO+87Cv6wEbOdWGqcVUBnsgBQtUET90HKS7vH5MivG/TllY9cveQPcxk6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7624
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 12:56:17PM +0000, Song, Xiongwei wrote:
> > Frames 3 and 4 are sent with DEI=1 and are dropped, frames 1 and 2 are
> > sent with DEI=0 and are not dropped. I'm not sure if varying the DEI
> > field is part of the intentions of the test? Is there any RFC which says
> > that IP fragments over VLAN should use DEI=1, or some other reason?
> 
> I didn't notice that. Let me check the test why set DEI=1. 

Ok. It would be good to have an answer to this, because one of the
assumptions of that patch was that whomever sets DEI=1 doesn't get to
complain that their packets are *actually* dropped :)

FWIW, if you do need to set up a reservation for traffic received on a
port, section 8.6.3.3.15 Buffer reservation watermarks (page 817) should
help with this:
https://www.nxp.com/docs/en/user-guide/LLDPUG_RevL5.15.71-2.2.0.pdf
