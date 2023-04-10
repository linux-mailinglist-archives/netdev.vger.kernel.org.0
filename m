Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEE96DC874
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 17:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjDJPYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 11:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjDJPYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 11:24:42 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2078.outbound.protection.outlook.com [40.107.104.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB178A48
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 08:24:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYv1H2H4/r/SVpuX7bVy43FX6CtzYsZTsal09QnjVd5cez4YOB9LUXzokngAJ9XDe6h+ku5/OjsLaDSN0eEzW4fYjTFNaYK3XdidB2vg/B/jSpOp+bbK+wPEQRUQAYqPG/1bhqayw9OwPgOtjwpMPx8+Ulq9Eny7ybtqEP5aoEbvZ5WRFkENzg2FznJeFW5j7R7ZhIZk9txgNegMINAe3gq387GAzG4bCdd4pTiKZwLFo0hir8Ixu/F2w5jF5faSd+7ria2qtqglOO8TyeAUCduCdrYYZBD1Pzr5wJkyXHXwl99z4gcNLYN747zBrqMo3yUqHAyjGOEN6YP/c90w5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZYpVo1AvRkX9GD51/ZNzgDiP5uzPidY2fmnBZK6BAmw=;
 b=HY/0TY9GREdhA/T5cDEQINvQ2FDT/vS933ql1BILTqvh2yyRxKtHLSgXInQHgzYe35QKMrz/RQN/dThyQhayhqIlVRsgq5N7aC5SebeGUhqGPezDiOu8TydfkpuEcpi+mfREtY9Jp93ScymRZrS+vUk8GvO/W54i8wVt0GX48/DL3i7GYvGDZwozZ9beXsD/GygAKjMTc9n/+qD/8SAsjPhbFjnE1E5Z3UVM2ydvBLjd8jkpu4dwjA9F00bY5xivmLZovsXyCt4evSY6txPiyhwntCKvHhjvTZ0WINb1Rz65zC5f1PNeBbhRUaS6BwcoGIcVY+dZuN8KLoyaCNv6RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZYpVo1AvRkX9GD51/ZNzgDiP5uzPidY2fmnBZK6BAmw=;
 b=Ncf5G+qf+m362CKxUI76HLjfg+bwQqYV30A1HBO7CIvtNJklV8R4IpHIg+r9C7fDQ1UpkVw8q0D+fNPVvV3tDDPvXMQ1tGU/kEoudZtMnb6kw2YmiRuVc5FCs45TX4UR862wWdTRoPqXsG/9NLRya8QEL9oJWOGQmkxRSM8KiYQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VE1PR04MB7296.eurprd04.prod.outlook.com (2603:10a6:800:1aa::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Mon, 10 Apr
 2023 15:24:38 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Mon, 10 Apr 2023
 15:24:37 +0000
Date:   Mon, 10 Apr 2023 18:24:34 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, shawnguo@kernel.org,
        s.hauer@pengutronix.de, arm-soc <arm@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] ARM: dts: imx51: ZII: Add missing phy-mode
Message-ID: <20230410152434.vafp4t6a3qdo3od7@skbuf>
References: <20230407152503.2320741-1-andrew@lunn.ch>
 <20230407152503.2320741-2-andrew@lunn.ch>
 <20230407154159.upribliycphlol5u@skbuf>
 <b5e96d31-6290-44e5-b829-737e40f0ef35@lunn.ch>
 <20230410100012.esudvvyik3ck7urr@skbuf>
 <ZDPm28C7xXulpG1L@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDPm28C7xXulpG1L@shell.armlinux.org.uk>
X-ClientProxiedBy: FR0P281CA0087.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::12) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VE1PR04MB7296:EE_
X-MS-Office365-Filtering-Correlation-Id: bf35afbe-9f79-4815-6388-08db39d7b25a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FtxrcCdKnKPxgY7A0y4yiBzfgD1cHGeRddZIkZ5/iPktG7NQBj1nWYZbY60ZgrT3tJ4E6ZvKWKh3xBfgNf6AxinO0kUzT/xMJ+meHVFcgCTMYnJVwrKwyccH0OUx5qRQXN2ZU5NADeMthIDzGvjaRQMYaDc4JqC4YnFDZ+ksV+9qNxzyCFpYbFagOfy5/SBZDbvpBEL4Vvtd05SnQA3Kd/JhSNCQtvvg76sckbvZqXfL9rhMOA+SSkR2xkAHIZuusGVDuXzVQs2C44vKSmO1KiUGWnyCLzkysRDUgDVam2MXEW+/3B5LQ9GqDOzE4RjFpXGhjUnAxC+3V1+XuKscW/v2peCv7zCHW1pKjD36BYSjcslGGexAdb/DZoF5HbCAxncnS8xColmLiOQ6K9Lw1/7vmigazOPE0jlgArN9NCIfuKNlG/AWMh88EHiQaOhFnKvfzD9OYlJx8WHMlYBO2oMBdFXFrKzr30BdF/4CCNccSrK2PbCgTOXKldamXHc6U1iim6nzNkFCpUzYKDmKmqVfATGTqVL6ko/8Et2pnnk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(396003)(376002)(136003)(366004)(39860400002)(346002)(451199021)(6486002)(44832011)(8676002)(66946007)(4326008)(66556008)(66476007)(316002)(6916009)(966005)(4744005)(5660300002)(41300700001)(54906003)(8936002)(6506007)(6512007)(186003)(1076003)(6666004)(26005)(9686003)(2906002)(478600001)(38100700002)(33716001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ajp8A4IRukAD5c0GACVTVLKIRn6MnNVOZYq1XOy2rWr5YSjTlI/a1lekDXCm?=
 =?us-ascii?Q?klktpEh7KN3rLHombH1bglYf2FO6SIDjI+clL/H5QTDTogOLlm1LEX/reg/L?=
 =?us-ascii?Q?1IYNqLm8wLKouTQySotdS9WUBN85XaN/RqfDw736pd6Q8bLRGbMlgYtqKOzw?=
 =?us-ascii?Q?HKwGA5JfAPj/ETaxsUGfVCQVqnfMZNt+fK9xZc+FSAFlWDUAbgzjpT1IjwJb?=
 =?us-ascii?Q?4M5fqG4tOg3y2Vssi7xhqG8mSZugQFLeY3qUes/g202LR3gq/vBrIX7jNyuA?=
 =?us-ascii?Q?j8d7vQRrbaGmxW4Lm+1ewPsHQZC42ZZUIxud34QaOhKKfDQ43JIDz0BV24i4?=
 =?us-ascii?Q?R9naja1Aps7Vx1lH14s1WpJlDXe9OP60uMrtE232U5yijdFZD5haX3rYMd45?=
 =?us-ascii?Q?NE7K0gmLVHE0uOEVlQnCVAOiLKXCG0B9zJnPiitR+/t5lBLFjHDyRPNPICPa?=
 =?us-ascii?Q?k7Hsi/G1R+zpyZBAiEpbJBByKeL/LT8iTuTF9hJ2sYWYPbEufSzFtTyIaiis?=
 =?us-ascii?Q?FAdwhg686813TI4MWqVtkT3MlC/wzJdSPU99IOS23K5EEFmW5EaGLz1/9BXU?=
 =?us-ascii?Q?MqF5rMu3LZ50uBVwWfc6LYN4ECCL0gFPEHpz8Mj7U6PZdBudd9kuiqq9ezzf?=
 =?us-ascii?Q?MV1q0t9Fzg98UuD1TgnPGN9fXSbKH+AWp/M2wpfjogvcgz5Rdjt1eRt3oEZQ?=
 =?us-ascii?Q?EJa542vnTlnHNkg9nEn7r6BBRNX1fCx1stTm7XGGIdhN0RUgE8dcDKCsTV8F?=
 =?us-ascii?Q?/CVXdm1JaKuoBwG79G/qr9efe8GBWpMvtX779AIfa15IS7UzclVBf158Bn9w?=
 =?us-ascii?Q?dVgoswb8EWn61mfGW2BIZuWDGd6Pdtdfju0jxUbepiACh7x+rcBeB9Ucu1En?=
 =?us-ascii?Q?YOP/f7RFTxeHdj9zSJrM9L/YVqKWeCOadKOPgCB5fEa/rzjitZ2MbOvtQRjE?=
 =?us-ascii?Q?eJ0eMjDkCnnkqygOF0kamLesyfH3JrrxY7AxHsDShMIVyuHerYdl1ZZ5gIhy?=
 =?us-ascii?Q?vBXjmMFSkrsNf1ihV7CxORuBjlssasV2fj9gzW6Da1DhfTBQzcPEX6wv8ILd?=
 =?us-ascii?Q?uV8WpF1FMkxWjW2wnkIbfcp//xB2T7FC7lfnLxX3TW5bzdZ3IdxxJ3uWk2tS?=
 =?us-ascii?Q?F6Q4Oz7sOcyKs03Ijdg2ReAG/FFI04vq7q2nLvE6PSm4+z8xqxkD9QC6toXm?=
 =?us-ascii?Q?SVxOkNG1p1tLmQwB3zX0bhsiD/E1jJunPW7vglSCVK/6lEp3zU/JbXfXknXr?=
 =?us-ascii?Q?2eyU27zhigH9UYvSqabCdkpoZCHvJ2AraOZO120brVGMhKXi2QaKgQBMIrD1?=
 =?us-ascii?Q?CweH7mJnonoFX3fpATwvwQNL3iZHjrUC7m71vRkUJNwaFU1YNIzGfe5s3BTB?=
 =?us-ascii?Q?w6+ez0fFwRGi2szw6xNnWXc/3pN4ibqMMbGO8CyXVH+CQvGxqoOvM0GDZk86?=
 =?us-ascii?Q?hhlLvQu0VHK6zLtPNaXLkhZ9tJ6HrFK2xqCE2AB+0yPszWYN2nLpUbB3Y7SE?=
 =?us-ascii?Q?rYWjuYXiYTG31RNaVYZE4m6G3RL41NdYbCmCC5v+RXZ1sS9ysA3QO//asHAN?=
 =?us-ascii?Q?M26ki1ZYErRtRnmKsdj1vz/Ap7/IBaLvsZvzX5abnyp4GghO1cgrKaYQDN64?=
 =?us-ascii?Q?SA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf35afbe-9f79-4815-6388-08db39d7b25a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 15:24:37.7789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yHB/cSF0aQFQciECfVmsKJxe3g7A5lyFzofN+ttS06yVTaR1ebjKgJSDUSwwRe4WdrpfTUT9QQGm0Fb/3fgI/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7296
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 11:37:15AM +0100, Russell King (Oracle) wrote:
> It is entirely possible that some are wrong, especially as we don't
> document what the various PHY_INTERFACE_MODE_* mean in the kernel
> (remember that I started doing that).

include/linux/phy.h does give a small hint about what is expected:

 * @PHY_INTERFACE_MODE_REVRMII: Reduced Media Independent Interface in PHY role

and the commit which added that mode does reference, in its description,
the conversation that led to its creation:
https://lore.kernel.org/netdev/20210201214515.cx6ivvme2tlquge2@skbuf/
