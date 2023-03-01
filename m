Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996196A6B16
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 11:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCAKwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 05:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjCAKwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 05:52:20 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2129.outbound.protection.outlook.com [40.107.92.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070B236459
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 02:52:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnEYA4VE7LHVnvGkSfmjia3HQefUYVkZwU+nU2EVtidoZ8FrduFXE/Pm8tigez+sVF8vB3Cf9LLtSkRFSr/FhumxVk/HyF3++vvjHfFH3L1jE/rLruVBzG5YH/e/BlIzs0Np5sslR9uEHIcjzls/di6pW6I86P/bRMkmyWPnIKW/fF+pY0xa9KFQqKkYT7glglo0suBfXsHTplJhejDVxy9gdD+ACAaUdkwoPsxF6RvMuF6Alu2Agce8c6OZph95aAZbqzigwFrcwhJNUUt9zb8TjNPG6piBKgWT6b06+8NQLAiUKm0R7u+iTWdlq7NRa5cn+xOeuFExc4G/lkFB0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YOfHqnMbCrqjxHCSo0V9L60ht7QHHMCIdV1V1W5w1r0=;
 b=P2XHgS+ncrcReKNZZyST3Pv9TMedc7LGNuYkw80XnjVHRkqYdKTAhcJRC0z/slZDqx/qZI0UuUqirY98WhOVJjmsQkN7N6rTO5XDeUSaiFcQxV8bdXrLu/hKAZumOa3NdUWm+U74Eh0qfjcspdM/BMdTioaI6YLW+h7T8iOwbmE+wsOv7ac8kd/Iug5hjo49Kvms9L8vNOsVfa9/y13GeWsrHHAUQE6hO41iHWMqsx03r/4ibdTMdgHDuKN0wJQzlMJQs+qzMnkLPTpEpGhiquJQWRFTEUVjKBe88OpYMZiCebPg4hi1eSiMlnFzMalCjT1ud6PTRoiSFIlqLr7ffA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOfHqnMbCrqjxHCSo0V9L60ht7QHHMCIdV1V1W5w1r0=;
 b=qani8A8J4966ZxV4LzsJ+D1TPCDRartBsn0M0Pxoy33/OslQwCvvlbGjZqoY+4OWCJYaBtE0Lq1mi0falPn9N/59vxdRTpmBOFy4c6kyKJxevtM4rMPpqPHk2s/yCBQke/Wah2Td5dVI/YciY/TRynK+TXyimDfHPRZK0mxZCLI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5527.namprd13.prod.outlook.com (2603:10b6:510:139::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Wed, 1 Mar
 2023 10:52:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.018; Wed, 1 Mar 2023
 10:52:16 +0000
Date:   Wed, 1 Mar 2023 11:52:09 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC 0/6] r8169: disable ASPM during NAPI poll
Message-ID: <Y/8uWeQNxteyH+gT@corigine.com>
References: <af076f1f-a034-82e5-8f76-f3ec32a14eaa@gmail.com>
 <CAAd53p6D7e=pSX0uEZfXiwt9Es9Pd+4s1N5k-8ob+Gb98e01Og@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p6D7e=pSX0uEZfXiwt9Es9Pd+4s1N5k-8ob+Gb98e01Og@mail.gmail.com>
X-ClientProxiedBy: AM0PR10CA0020.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5527:EE_
X-MS-Office365-Filtering-Correlation-Id: ada7daf6-d305-461a-3576-08db1a430543
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vjuhod5Ka3P09/EloxIknNezAXkDIEqsdMa5hKOiS8xC4NoUqqJjFlJKrOSSsvfVP0avex/5l1JMnbvCac4zLzln26mr2LVxjr4KyLkmSNh8aYoWy517SS+kyRcmEr4P/Q+xkgOU063YkAyVMM3+rT4P8FjLxKOBN9+UGS+PxQ3hznwKeRlY8OHnG5Rk0cmQLHqadaLhhE21tFu30uU5jMH2ST5CK1gIVsNF7ORgqvMM2/PYmNTUKELFAz2orzzXCfwneMPcs7U81iOO5pz2tT0oje/OWEtY3RzXnOeE+cwXYgArQFQUBupuY1N29iG5OAN9XkHqQi8wsmfILgt1IPyJNJAC1YhuPOTLXhAqbnnqfWpXcEyPzm+xrk22pxBcTkjolHIC2Bi+CxS7GrvMQOzfYifEszENnmSHBGOzPVKGiRZUky2M4/3d8hl2a8ZPFUmmkF1N+Isee0a6S0S7wRiVQlD/UEeBIggmP/9UH1/Ckh3TD8NKxSnWebvL3uppxVpt3Zr6NbKlSf+nC7qKCB3S9JPw8RkwQq9eGI7/a/MVECzI3L1DE4NWAo5GDj5hfNqJqIBPuCpohEt6o8ubdoY4LI7Ps6nvWP5ybn6aMx0ZZmev9hF3jtFjXK7vhIYziGJIyTqZFjKCEWaT9RT2Um+zqjEA+SOOR9Jy/ULW7jZqIT6ezSqz+7ry9/g8VVr8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(396003)(366004)(346002)(376002)(451199018)(316002)(2906002)(54906003)(4744005)(44832011)(5660300002)(36756003)(8936002)(86362001)(6506007)(6512007)(53546011)(66476007)(66556008)(66946007)(186003)(4326008)(6916009)(8676002)(38100700002)(41300700001)(2616005)(478600001)(83380400001)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hVyaAcwl4nhsEQdKm2hjZ/dqCOb2SaqAfnvp4Kdsw14NxDO8v9FHfAZY+XC6?=
 =?us-ascii?Q?tgaV3rCLuTapmaSnNjUUNljeHIxZbJ3b6sQYvsol4o0Ej9g8SFtjgu7fv7JY?=
 =?us-ascii?Q?/fcc11Y5A8ZTxacIChcDJYfrknsJDYNfNJGxNasdhvhRo+TiWp8GRMxuJ9Gt?=
 =?us-ascii?Q?Wvs5iaRsQysNN/2cnLChhWshr2atHnkZlZ/N20dq/pmn58CG7ipOrVPDSCom?=
 =?us-ascii?Q?s/9x+M5r8lmkNRTTbJ0hNGc4vQpdbKBijLzjX5HlrHuBk8ehaNz3AZePtK0N?=
 =?us-ascii?Q?EI01hKniuv4gnZ/NKEp0HhNp7uBb/I4VBfvxbkSlQkV0VrmyKSk29Id7do7K?=
 =?us-ascii?Q?1AeX8+3+YAXaOv1kq+529zbuQM/hShH7cjqqqQN6ZJe+TVS6kzuby1VF6N/8?=
 =?us-ascii?Q?y8JxsVq3ER4Vf303VIY+SVyOaQYy4ikn1E5Bn4Cp8aN3MUSu/SyDNeqg2LeD?=
 =?us-ascii?Q?Jr97PTo0e67cOs1SXcGK5R25RclXmPJZkz7XBbdiyZAf7k4Feqn4C3K4Effo?=
 =?us-ascii?Q?D9DNNMqVLZhXxM2eOY5lMDsGIpcSXj6A72Sqho/8C5oLruWroMbkHIH1QkF2?=
 =?us-ascii?Q?6Virq8VqM7inyG5q88lkJvHzm1dBMRM9PQZPLjK2wAW9nELkwNId593PKRY2?=
 =?us-ascii?Q?05HYvbbtE5SMkN4Oq8Mx/THx4r9QxaR66jsJ9cjui74NjLkskitTNZuvmnTe?=
 =?us-ascii?Q?0XqMlsITtNTD9cHjqdQvdAsA/qkQ0n2A3beHrKJA0CpVjRAdOPnfW9Eo3Eow?=
 =?us-ascii?Q?nUPcxzrSMxW5MPBxPbtfGm7TiJSrzHX4mWQKgwHtcW1g34HrQk7P9cpDaxJY?=
 =?us-ascii?Q?5ADPaZjG9tfE5irLsu6AifnGIfmzOtWFXP7oqeaNNsz3WNP0fqbRd8MYru+N?=
 =?us-ascii?Q?/POMz9XdZTSQ+6pYfX2nDeJW1PDUBS6lEon9j3jN99EHSaWMu3LgPqTxS5uI?=
 =?us-ascii?Q?Y1WGFWSqai8gzlY1sOVtYBVZESC2btbSqKY+xy15QwLh8AX23HJXk29dtcv+?=
 =?us-ascii?Q?80Bt75megmygZyBMfPAwq13PopIGvi0+17Ou0zMEnF6nQgZkGXvc2QnojFga?=
 =?us-ascii?Q?hRCHVWCZ/zC+hK7sZuBj0++rbFOCFqqL42gGSaDZE5eK/yAAT1e98SmaufOK?=
 =?us-ascii?Q?VDLOgkY2BbyCYDgx4AAAexllLj7cc5UPrP5xizDPV9JRIIZdy7Rzx6h6sC9x?=
 =?us-ascii?Q?Jh5aMfx7VIMQMAI/JD8PHO7zjtAgwFDtSe5RSX7rbAQRmV3lHb9fHw0Ohpok?=
 =?us-ascii?Q?5QM9BCfJ5ANQpJzOLsNfEgvaZpmjLOwuOq8AayfxtxlBzRGD3+5juozcBPWX?=
 =?us-ascii?Q?UfrU6lVpzk50NTOW9T111WoWllgdqAf9YMbTM08QwhfgLDRguSpPufk+/UPr?=
 =?us-ascii?Q?XjTVI8jwGl4TOh6I3zWX0CiaB2nILGj5LJ39PCMF1FKx0z8A9hsNYvhoI25U?=
 =?us-ascii?Q?zLmH50M+vsNfnuap4e86z0icDNg4kx1+fKmHFhbZ4GF8UrhPe6ocCMz/m4dl?=
 =?us-ascii?Q?gT3coalq0WClpeLPhiiDCcqsB69R/46wCehOlYaafv6RtrDcHcFRtXQ7+/sO?=
 =?us-ascii?Q?CZwJobKpi+9JaSQ/yCc8RXsWZ0Z71asZvwMIN3OtYhiJGOR7yyZ9odjiU7Ab?=
 =?us-ascii?Q?NHZnIeypaoDppzRryYhVck4UBdFu5v56KQtwqXsOeNfXysP/3eHIVPRmIqTA?=
 =?us-ascii?Q?h6bFmw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ada7daf6-d305-461a-3576-08db1a430543
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 10:52:15.8041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o0eMd8kAobd1xgvUAdeY36hs8O/VcqxtwCUhhpiCcTwvWpljWN3Ai2ghsnDKt3AgFNtHfiGohdtyIbhYtUf/E+9Jjkk0jR4OgvLN9uZLL1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5527
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 02:50:43PM +0800, Kai-Heng Feng wrote:
> On Sun, Feb 26, 2023 at 5:43 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >
> > This is a rework of ideas from Kai-Heng on how to avoid the known
> > ASPM issues whilst still allowing for a maximum of ASPM-related power
> > savings. As a prerequisite some locking is added first.
> >
> > This change affects a bigger number of supported chip versions,
> > therefore this series comes as RFC first for further testing.
> 
> Thanks for the series.
> 
> Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

FWIIW, I also looked over this series and it looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

