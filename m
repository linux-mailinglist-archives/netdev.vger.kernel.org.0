Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093C166C05B
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbjAPN4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjAPN4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:56:13 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2104.outbound.protection.outlook.com [40.107.237.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CC42B0BE;
        Mon, 16 Jan 2023 05:53:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgxVnWXOEA5THPuLkVyztG/SYlH3t520bezP0xXSqE3NoCPYH8JHUzBcD11iHRX/up9y7EXRhQoI9s9138deMG2CTM0Bnjx/YnkY04ASqtKzJanJcBS7cWRDjtEFlppRglrIFr63rrKIk3cviJhNUlROFD42Cyf1t3zHFc/8tttho5T7pnhTe3I8STUkHGO08HazBPdicNll/8abr6ylJafuUPbh5SQuIeOUFsArv/E4Px0dfN8IIrM9etUiD4ADyYu+bwq/G/QVsY6R0f56Ke3/b9bbw+TpUmnx8ZoMEKNOcdt9Fxmww7YHoS4I/EtCJu5CigDqyLNrlMp6wDFioA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q6qP2GHSimGhtfsb/rmH5ZS0cyo6sBQVLQNPIDkvFEo=;
 b=fG6OGneApb8B1Lhm2+IbNiILi1pDjAT2tZilAzjV6uqf+rLRQJ8deE3+VF9C2C3yo91tM69NL0zprjQYjJpsdG4zTcV5/dvq7xWHM7wI1ARFM/0yw0Sq1u7i/6rMBj6GggaIIj6KhycNrCiaundheFyWKf7SJlrThHAsW/hL1Chjj3Vm6fPp+EbYAZRRIgivHhy0O5OcZryBWHcQ4fQnM1Yt8CzsccSEycieGUTzkU/KDjSBqaUKFI6b2mLh/vcj0XlnuV/q2Qlzw8fQsDjIoEVa3Q7XY4S+gulmbbt0Kvjx0aZQjqKNBx1bkPn8C0/B7qseDQq49CeEHo9Wi6iDRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6qP2GHSimGhtfsb/rmH5ZS0cyo6sBQVLQNPIDkvFEo=;
 b=nldTxUrl2GkbK6ndb5Y+Wxdbqb7RwUHdZH64ODVgXlxy2wNq8lvF0Zurg0tJWQtLjd83dGJ+zlsFGUjyHhmLd5aiVNs6C8JfT7aByhXMrc1nXCOhZlkuFh2Ll3Wgil8DIywRf34FldzFwPWB2CwakWvJ1vgslrgEELoSS2bPrlo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by CH0PR13MB5201.namprd13.prod.outlook.com (2603:10b6:610:ea::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 13:53:02 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::1cd0:5238:2916:882]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::1cd0:5238:2916:882%5]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 13:53:02 +0000
Date:   Mon, 16 Jan 2023 14:52:55 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Pierluigi Passaro <pierluigi.p@variscite.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Matityahu <eran.m@variscite.com>,
        Nate Drude <Nate.D@variscite.com>,
        Francesco Ferraro <francesco.f@variscite.com>,
        "pierluigi.passaro@gmail.com" <pierluigi.passaro@gmail.com>
Subject: Re: [PATCH v2] net: mdio: force deassert MDIO reset signal
Message-ID: <Y8VWty171tDo+m0/@corigine.com>
References: <20230115213746.26601-1-pierluigi.p@variscite.com>
 <Y8UwrzenvgGw8dns@corigine.com>
 <AM6PR08MB43764E8EB99B48897327CFCCFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <Y8VS0Wlpg7TGXk2d@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8VS0Wlpg7TGXk2d@shell.armlinux.org.uk>
X-ClientProxiedBy: AS4P195CA0030.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::17) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|CH0PR13MB5201:EE_
X-MS-Office365-Filtering-Correlation-Id: 59128f33-77a2-4390-2ad9-08daf7c8fc5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cMmIRCNMYK41lH99QU3JdWm8AXRaOJSU01lnVm7a7zNi00RABMwlpCiDWWSds5T5Gd44Qt2UgGH5hC5e+ghsvQpc1n1nDTF0M0wJrJiAbGLWxig5x2w65PGpGgR6zXjoZQrFSJ0HXwRz7pogfdk4OzW3zuKT7FFA6aH3w7/SJkK68Sn1VyDkH84EDAleEkMYgGsLLiQbnUsSAFeuZZoaeK1f18EqQI4mMZ/agsL6YVPzMkLxnrFZY/iFgiNZUp12xn0Fk5YZoM6JGjDhllzqaXNvZXt5LtiC1mXSqRAdx7epXi/06BfjIJClYsSa1L6TMWAXCHG6LzjJsiScbzPaUdPERO+gbnTbr3uu9teBHJz1itMq5EFffGAmsHzYRXJXd8ua/RC5OOt65VLzlFnPz1yNskXKCMeodDGY8MiRoLNg42szdtm/OTuPlKaOKNlAACrk7OsQECOxQ4CdwSDygHBlQR1DCRoJ2qBlPKmd+I44iXYlrWY5TdyQva2TSMdOc8WXzF4j2Ozdotu2vpyNwvAPxret2rhsTsUHjCfYpEhrDEsB0pTID2am39EsL818ce2EQKLgM/8kYdllCbtBE9reIrqyrvaQaV1Ujh/TqLO5TMF2mtNEdd1/RETdjhmLKk/JYzCXAR693161kz4Cj7boZaQKmvgNPHy+N0gVOBU/JKE7bMmEyaVxWkZPtuOv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(376002)(39840400004)(366004)(451199015)(2906002)(4326008)(6916009)(66946007)(36756003)(8676002)(66556008)(66476007)(41300700001)(186003)(6512007)(6666004)(6506007)(2616005)(83380400001)(86362001)(316002)(54906003)(38100700002)(478600001)(6486002)(4744005)(8936002)(5660300002)(44832011)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xNlt+lcGMbeVhFXjGyHD3IV5Eyq8PpsxDwIqdW4JaLvRgskdgnkuTPWySbW4?=
 =?us-ascii?Q?Cml2fnFHbfhkeKV4pB7CIPzM9lrJnkHDR+2outssmhhFC6n708YwnGz1GwMC?=
 =?us-ascii?Q?EXiVwuGm01EJqVRJe8T3LBWbNsIQ0ks/a2MqXfq6G0oNUSNPKc/4Usr3xIV2?=
 =?us-ascii?Q?9JDDVTE2E8rWTXbb66+oUraRSp4RREq0lOqL3agd4Uf8YSBEmWm/1ALUGoTL?=
 =?us-ascii?Q?5LG2aO05R9AKZJOnoP+1KeNULlyTvTM3mRbSboEvYjXPIpdQJ9l7eaqD5HN3?=
 =?us-ascii?Q?8BJyFHFU1w1eluUVdbJ6xHwUkAlo6IVEq2zitEwyRAYKwPF4aDxFG9h3EKcc?=
 =?us-ascii?Q?nT8EiSjrwjKl8V8fxu1VEY+n3rPvmBXnF61FbesVxcgzwpMYbagCwj+LR7KR?=
 =?us-ascii?Q?h191NrDZKaXCr/kRktdSQESR5Iz6mvBY6c+DS5PWN7x1FotjbDs+OtMLXTg3?=
 =?us-ascii?Q?5tvDjTP3Hd7Bzi8uPL2AFB5OdO0c7/csBCsRSP6Rrnq89PtxXfWlDsbYliRv?=
 =?us-ascii?Q?nBX15dHvKoccOnOVWBXY6A32SXc6N8IOdPNEWfWQpHaqD/KEyCiTBF5QkqaR?=
 =?us-ascii?Q?BP4FIhm7P/qDsImc9odB2JonUl1i949m2rok2ilGsu14YrKjRRZmvDOQdPC3?=
 =?us-ascii?Q?/4l+7HXgRuUfYHx/Knic6Ti0w0B4qOprTxTQUiJLvN9Ip+PeiDVAyYcnusXB?=
 =?us-ascii?Q?d4ShSA6j/BUP1UEY76uBkyNMTb0k0w6QyBqTmWcBx4adl/nwRMTtYL2+sHfW?=
 =?us-ascii?Q?O/lSatk0C/uq+5nRB1Nj5XoMxLB2iu88nMiew0iK6SshLaBfMWeXd4QMOZGR?=
 =?us-ascii?Q?hH2jNzVneOMWxzR16JnHcmkNjZyTB26od4/RsMvDsDIGK6SqLYuU0a/flyc3?=
 =?us-ascii?Q?Ausxhe0FmEtDXUaFp354Tdhaoc0tRXn7QykMzlWtykZqZ2ZrDsDLCqgkPqgb?=
 =?us-ascii?Q?63yYtMfPnmWB8SvgEED6npCgyX1QoTc7+1JI/BsiWXnn60OMi44G/JIHOrKm?=
 =?us-ascii?Q?cAqRQ6SRl2WCq3jUvtCDU2rrrtjlGlI54HaQz5+dCz0gn9Le1DTtzi1ZpRe6?=
 =?us-ascii?Q?kYGpuyEm4Op6hswrEvvzzn/dVBAghIiAD6mENhw9XX+ligeUY7RipQMh7I2l?=
 =?us-ascii?Q?nAz6KjS6hrtbJrNfjqRcyAYiijG9CvXUvZvsz/sK9zNjWwjk0aa26TZc4C7h?=
 =?us-ascii?Q?pzEIGwAW456drAX2hhbsMZEes8qis9xD35SSfbewaLs6pZLcB87LlorhqSfm?=
 =?us-ascii?Q?DLBsghCar8HkwZJ4ZB0tefmpcKHJ5q452nT0UGOrQ4yVLdFYUSfJEpOpFnR4?=
 =?us-ascii?Q?Fs9QTZKdAMplt9vt8SwiPyYqpAOsNCZNCrCB9dXCmCOba4A1mf1EizmkstBR?=
 =?us-ascii?Q?5hNXX6nUmt2pNURMvc4bqXVYGMmQPyzYWINwx9JKDCAwZ+o6zA/lvHivX8c5?=
 =?us-ascii?Q?UZhSa+qebugIYoRN84rOtYhMDm9E9zvakZg8E4OWcrMR2y3ZRvFS6MRMycc/?=
 =?us-ascii?Q?C4+w0Ld8KSCVztiqjei1PHIcdr6oCraOiSKrI5QFXINbv3C/zLrDjSxiKLIH?=
 =?us-ascii?Q?QOGELiP/t2Xua4Gk4+MSKX5C2iIkiYV7fiJa77f5BAZbJ+1DIGX09+wTqDaS?=
 =?us-ascii?Q?0E1tiZTFLgcNRiCM2o+jzieNuSRbjie8YVAAmlqfqpEm6fe/F3bpUsSxlWi9?=
 =?us-ascii?Q?TVXCGw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59128f33-77a2-4390-2ad9-08daf7c8fc5a
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 13:53:02.7352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LCD7RINIaB7cNOKJStTFDi8M7yfQZKKejQw9T/s7QyZTl3cq5ESAz88xM0Jy6WKvLTa0l7nlFImAbSpxiW2f2f4a8lCb/Ky5yE74TrkOycg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5201
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 01:36:17PM +0000, Russell King (Oracle) wrote:
> On Mon, Jan 16, 2023 at 01:13:49PM +0000, Pierluigi Passaro wrote:
> > I'm worried I'm asking something stupid: what do you mean by
> > "reverse xmas tree" ?> ...
> 
> Ordering them so that the longest is first, followed by the next longest
> all the way down to the shortest.

Yes, something
a bit like
this.
