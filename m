Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6E66D7C30
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 14:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237266AbjDEMGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 08:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjDEMGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 08:06:41 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2052.outbound.protection.outlook.com [40.107.8.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130CD3C38
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 05:06:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ka+PetT+zhIgOtJf8GUSTr3Me+wCfdC9jZOooCZKVPoRmxmcuNHjxD436TU3Cqjp7/X2wJrarAdIW3q6SMWMHoSIZ6hDsdKdQVT4u7F0ftjdKkznD9Y/j5TH1cfV73xPJrqebBsWfpmWXv32Pg2Mtr93cuFh3y/UOUBAr2z60/04phbalC8o3+ZUbWafZWaV2q1jkvKU6d8QGXx4H8AmCk2Yg1tFI1+2RSz/TL5uP1Ttt8R21AQThJQfhKl1IsuiLPJ0A+peZ52h4oCdR9qLGo2lY8zXBzkYr1ylHCUA8Kd9580jf5lov8zoneYQ696QIU3Q5jYcCHNt4ObnByEIAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6t1WjPhMqxfBfFu5WuRfWejS6uynV74V5Jict5UKHlw=;
 b=lJA5T3eYFYHCp+TEpLcDbZ+Oap1C4o9Fy/eA1Hr1VwqNaFtzG7dxvoejfUNT68yd/E+7wuEoMbONIU09b4UONK6lvUn75B+PUq6C5SxFytUYhw3fXRPBKmqxO6ptektN3jK55i2OZDKES4kO6r7FdZQlLpUpkxmGuAgkV5XeYCycdISyjiv+03mPnedBsG9vzrM271+P6pvhuHWW2A5omU6i8HoQTwwJ8wHUhdr4qeelr5UFQ3DItXZ07RHHfIEUnSy3pKx3FtYf5eNWikD1ScuUZLWkwbs205NnMdfA8t+bCL+ucy4q4tO03OcAMiSiP6XFCOoqgs7Y1zqRRyOBpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6t1WjPhMqxfBfFu5WuRfWejS6uynV74V5Jict5UKHlw=;
 b=ReHsXxCHd8SBSq7VpB2CM5sXdeIMlfNOIzfQwQTai0hR4o0ODPgMuuxTwz3Gx1Imc1TqHmeyd4Kn5yo8UJ7pEFPsuVITG1xJSG4dEV9vodSc0nGNtD4azciTzx0nxu5uA1ulSSrZHlDW6WK+dMNnOeIigTgSEBX3mfzpA+ELWTM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DBBPR04MB7659.eurprd04.prod.outlook.com (2603:10a6:10:209::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.29; Wed, 5 Apr
 2023 12:06:36 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Wed, 5 Apr 2023
 12:06:36 +0000
Date:   Wed, 5 Apr 2023 15:06:32 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Max Georgiev <glipus@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Richard Cochran <richardcochran@gmail.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: Re: [PATCH net-next RFC v2] Add NDOs for hardware timestamp get/set
Message-ID: <20230405120632.b7pfceyrtxwidyef@skbuf>
References: <20230402142435.47105-1-glipus@gmail.com>
 <20230403122622.ixpiy2o7irxb3xpp@skbuf>
 <CAP5jrPExLX5nF7BWSSc1LeE_HOSWsDNLiGB52U0dzxfXFKb+Lw@mail.gmail.com>
 <20230404123015.wzv5l5owgkppoarr@skbuf>
 <20230404162551.1d45d031@kernel.org>
 <CAP5jrPGwyyLMTNpriOA71sMH4fRAefV5Bbe=X=2v_ML9JJdwdw@mail.gmail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP5jrPGwyyLMTNpriOA71sMH4fRAefV5Bbe=X=2v_ML9JJdwdw@mail.gmail.com>
X-ClientProxiedBy: FR3P281CA0178.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DBBPR04MB7659:EE_
X-MS-Office365-Filtering-Correlation-Id: 541c451f-50ef-4c12-a0ad-08db35ce345e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fbx2H8RwxeGK+xtyLRSwKe8wJXJCMIER7IQllEQZI7yYqwXI4T/iAe0NqkG/MccBsffW0Xy28+5GBUqxXZ541qK9HBycGPwzq5+h8C7gswdDq/3leNlWaAZJJTq4QaXzTLRjX44fKK2kjgabXYMxRSp8RzUmU5zMUIrcMliXytqthZC181m5D9XvdW20d0LPoSPX1des7KLy+GcgSQpQEzMj2JZwv1BIHcrPj3oXaTJz6ueZNV4TXW+Hs3icJpC1nfSB+kb+nYASE5NY6Ee++98UG7bVLHjxVX1zxF6cVBXp/3pKoQ1Nr92skBacrGJeD133HYyhgJIvrMDWPAKgRMoACozR1uqP6w/5+fAgxGlCsMrCjTY9jXvLgOxhbyUUXMEBAt0NBG5HLaoKn2s0HmeE9fb+UStv/14yCRUdL6O6A7OU3qsGhpLmWZjOq5Nki9ZLVrNvjxIFJqjbv6O+WbrEldTNfTAch448guxYLJPndlFxleDT337/gKvWKgthiO7/95WspqGB95H/IaTbCIprcCgnBV6aFsNUeyGOQW3kZeiQ7cVkiDB9AoqX8rx0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(136003)(39860400002)(366004)(396003)(346002)(376002)(451199021)(33716001)(38100700002)(86362001)(4744005)(6666004)(44832011)(6486002)(5660300002)(26005)(1076003)(9686003)(2906002)(6512007)(6506007)(186003)(66946007)(6916009)(66476007)(4326008)(478600001)(8676002)(316002)(66556008)(54906003)(8936002)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?QFp4SBviLWMPqNOHPRJXBKkxax5K2dzw4Q1g+svh8XvttpLNV10SbkWZwH?=
 =?iso-8859-1?Q?rZC+tH97m5qT8r6khzcxsx/+mJigDkf49TEgCYMF62yPfnI1dWGALyZaUo?=
 =?iso-8859-1?Q?EA44c4eIehXvQqNUUlrFCNpI7YU9dr/9XyvNbW54PJoPtZ5Q5ycL6uVA4D?=
 =?iso-8859-1?Q?PE3YJK7x+ziFjLrsoyHXHFrFdKT/xaNVTlyP9fX+Jin7ERTI/e01yES9aR?=
 =?iso-8859-1?Q?6sWdGkbrAjbeEShX7s/K0PYcYvrIYrmXPh0WpjTKJQyOSb1V12GO9JjCpG?=
 =?iso-8859-1?Q?GhnOcmeECj1Eu25I5iLTg+kouzhbHuwDyEu1LTnTOarYg/0qHPcyQadQ64?=
 =?iso-8859-1?Q?0zmkZPVNZWZayUC8b8ZQGQLSpDHfC1tSLXPtbSYqf+BCS+CBLKWkJhKoEE?=
 =?iso-8859-1?Q?hLCQvg/f3HZtq2zIWX8Sw8IU7ynp2k7/gTjSKQs1HFeIa5kiC83WOKlkRp?=
 =?iso-8859-1?Q?M9efCyFH15svqs84EH1t5h43Z8MlHe/RVSyYu58n8vL+XWOAw8mkhvtOZ+?=
 =?iso-8859-1?Q?0Os7a4CavaPld4y1TGMGWOFC1Uj17mWaAp2YIlCY07f1ykCrlmU+N5ymj4?=
 =?iso-8859-1?Q?H1y6xqD2PN2BmZJqOIAIo1XYRyUFeQ/a7DjEm5L/bDnbfZduYcODctfY2d?=
 =?iso-8859-1?Q?we2RFItuFpcMt1RKaGZo3W2Xqyrht4hW02HWhq/auEdYLmUh3Q0wjH3MAg?=
 =?iso-8859-1?Q?Q3ptVGIgawL4Vxhc6bwVGqtvun3MMrCIRUp/doOOCxUVh0IWTJxx5ImS4B?=
 =?iso-8859-1?Q?KE8SN42KFxVpYVpT/GCbElysi4tdEJJ1tUEZCQm2hm3aBnejmJZVRdIltX?=
 =?iso-8859-1?Q?/GqO+I/12m593uvQYP+gr96P+h/AUtrGO/EKNFSnlYRxbk1xrQTcJgkFTe?=
 =?iso-8859-1?Q?mAQzsfNlQ2XDhi+UE6JfLZx8GEB0HxfIzRp/7d0IlNsomtOggXa7WwcZ5P?=
 =?iso-8859-1?Q?vc/TvW6F6B1PXnAtX9vVsmXDO+1dymRE52SnsNfBf69WW3UALHf2S03/Ib?=
 =?iso-8859-1?Q?Vyug3cojv9q1GZQGKOfbChmkGdGXhr31BgurgXmwRZebnPnZIu8Pd5+/DH?=
 =?iso-8859-1?Q?8KMt+lw2/NDFNeOGrOWaLolw1tc2LslZR5XY4YMAbJC6U8MFl6kUb8AXnm?=
 =?iso-8859-1?Q?adXDAjggoz9rEABv1P5QzgZyX9jQs1ZnCb6+JLQNSs2NTtHrD0av+plyM5?=
 =?iso-8859-1?Q?ueHQdcK4X4wnx8WjCpRySBecsy6pOcd1KmTpY9FJkZw5kLVS0j1PWbAQX1?=
 =?iso-8859-1?Q?vnmFZbqI6nZ2DXvxt3Lz9RdI3Upd1MWqq+pyN3PUTqp2ruS9+yybSJ9tc6?=
 =?iso-8859-1?Q?rRlTiX4/WiR4QxBDetTEvmI6ojUBjqjhWAq3pOJ24uH6Uxd747prcfWRRY?=
 =?iso-8859-1?Q?49SNlxlXccFRdlbTehhwlHLCPrjOFhQVDfSH/SV9yhh1WjApu+SwOzv0Dv?=
 =?iso-8859-1?Q?3lZ5zx2nrZ6by73mwktx6ygeZ3k5tghcGIbDxPFmbXe/+xtyv8C/L6iVWO?=
 =?iso-8859-1?Q?IN+HxZiF7khzt00zZa/RWZU7YOQ9y6XY0h6eVCawqBBr2wcyw6t4f1Q2xb?=
 =?iso-8859-1?Q?96Kk7EaT9q+iBPr5DLf1PdjHiRXdUpesfpxXHCWyA6f5E6aP5YnZ65Rg03?=
 =?iso-8859-1?Q?0VhDUXtsB2aROMd+32QNKrqInHV58Vh40ONUZmmDilRIyWiHNNPYWZyA?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 541c451f-50ef-4c12-a0ad-08db35ce345e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 12:06:36.3506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iKlPYW1FXo28nvCml7pRGEkfK13VaEgMIcJMUgx4ywcx+MuZj/uSB3IS+75jlCFuBil9vKF6ygven4aR+QFu8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7659
X-Spam-Status: No, score=0.2 required=5.0 tests=DKIM_INVALID,DKIM_SIGNED,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 12:42:28AM -0600, Max Georgiev wrote:
> Thank you for the comments!
> 
> I've sent out v3 of the RFC stack to let the comment flow, and to
> potentially unblock Köry.
> I've added patches to insert ifr pointer into struct
> kernel_hwtstamp_config as Jakub suggested, but no code is relying on
> this new field yet.
> I also added a patch which is supposed to fix the VLAN code path. I
> can implement ndo_hwtstamp_get/set in VLAN as well - please comment if
> it would be a good idea.
> I haven't fixed bond_eth_ioctl() yet - will add it in the next
> version. More driver conversion patches are planned as was discussed.

macvlan_eth_ioctl() needs changing too.
