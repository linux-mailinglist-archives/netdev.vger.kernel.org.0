Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86516E46FF
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjDQMAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjDQMAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:00:51 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::71e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0648A47
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:00:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h28extlfma0gH5veaVaJHzRD122Q6GegUmRu8ZwRTYr7q5mLg87nzGOEq9fTsbWeeo6V8vwXGxfSmshcP0eUlCf3gA2Ax4xFE9PF6BTWWxUsnXPGtQDahI9s/EhCS7jbtlJHD1bXnfobNNMYQgVzLugy3PDTICWfNTyJX0teA8yP9xYhws5D6HNSIMl61Ra4ZzddSgsneJj04VLnynTqNxpIx9IUibtgxdmeAtxKLA6ACF65RTfjh4ZQzOFTME3kYPlV4hNbzvTatNpHuPJNCQ/pCOUACC2Kt5Oa6OP8f7Vm4WDS0M+fKS6ThkCoQK6e5ggO/ZdOnnUL/26cTIjOuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GXYu9tPWB6Ntf0sZjhUEHIW2RCEIF2k2KLeuMaMsU3k=;
 b=XC6V3/UO59MRCqeQydOXmbKiqcy8yM76FlVWKO50YTr2epGFOcnwwuWlY7klSHu13c4QvRkrGlDPFbNU/DWgT1GcH87prpKGfNqfz5WwYCLt6fh0KzPeDRxlLBgBy4/q3AZbjyVq+gkwBJ3gKrRUESiOWtisPKxqBhI7vS3gId+TvZBH1gMYvvQUGrni1d3IQqKgzMsmBSUwea5iFV7tA+8NwsP74kU0DYxM+IlRk3R53ufgvd+g4nNonWdoNcbFxDNt8utudJoPlPOvd1mdT0Tfc6kT+qr3bv0PjXOGTNJdJ7aX4QosYyTZfqd7rayBon9PHyHVpvQZfLJNBYEfNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXYu9tPWB6Ntf0sZjhUEHIW2RCEIF2k2KLeuMaMsU3k=;
 b=doa8qsjd5TsO+wBpGm11aYSAjYaLPVzVLVia8lHgZ/RwPubvcxka84f5YgQrL8d7zFTPhKCxR2z0xsK13mRl5jR5Rds3ZPPxcP4Zsl9MhsdAoXwP4BIpne0sPMoayfCoqtotl0izHo9WbTB8jAHeKC7eiAhRU4p+k/LkhCU7o8U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4627.namprd13.prod.outlook.com (2603:10b6:208:330::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 11:58:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 11:58:26 +0000
Date:   Mon, 17 Apr 2023 13:58:21 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Michal Schmidt <mschmidt@redhat.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Petr Oros <poros@redhat.com>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 1/6] ice: do not busy-wait to read GNSS data
Message-ID: <ZD00Xc14zYPebWcO@corigine.com>
References: <20230412081929.173220-1-mschmidt@redhat.com>
 <20230412081929.173220-2-mschmidt@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412081929.173220-2-mschmidt@redhat.com>
X-ClientProxiedBy: AM0PR10CA0019.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4627:EE_
X-MS-Office365-Filtering-Correlation-Id: 50da72b2-89a5-4172-d14d-08db3f3b0d84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oVL9rH3lywuyfXPsFIEwHjOF6y8oBU905XD9PaSFHfq8XH5Ki3vOuAlEEazA8lNlX7D3DahYOkqu3HB+figoLsK7cu4p9SEPtwZ1FMBIMBl2zT4HcFDf1x5fFReOnSeQmBloXQSd9t3yWSbnpizypnZi0BIsE58yG6hji4wiztQMPdmPUpLxYo3d2FAG4aGgRYdiv4zmvCemFUQSIgC+wPVJ081jMlykXHc4I4wtMVPTLu8kQZ+MXVO5m9AGpF+uDedwiMQJyYWc1moQmWBu+c/DXz5zQm59IvHZnTehw2mzLV0BXOhS+WR3yKc+DT9X3U9I7j1ly0Z7RfYp+roS15UglKVZkRbV36rFKDz36+NHZ0suhwR6mos75Q03/jtfGOiHZCI5iRIrqZrUVrmorpaUBrtlRnYKxxKpRUcueMiT5+uGn5o2SY/TEaeN6g5amznvz5lkPmCpsQpsHei61B0NufuSbBXxufeKZ3v43y4aO0Kz3jIqaJiN2j+B061qat9/TY+g5jtJzHHJF52QxagYScZ76HmAHWrMa2xsC9+97UEK8d1ktSIgwGalrZkAOZyb1rxsGsRhvbe1yG3R6RIcB9DPrM1mauPK35JHgTM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(346002)(136003)(396003)(366004)(376002)(451199021)(38100700002)(66899021)(8676002)(8936002)(44832011)(5660300002)(7416002)(2906002)(36756003)(86362001)(478600001)(6486002)(6666004)(54906003)(186003)(2616005)(6506007)(6512007)(66946007)(66476007)(316002)(41300700001)(4326008)(6916009)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5ldu6WutrgxLPeWyKfUXkqRmTkGGfv8pj/JyCPvwVUOYsLUT4wtojAudknNL?=
 =?us-ascii?Q?C1MsBM3Seb8dXx7hM9gKiKa2I/C0UV7nX0qchOQ0ukUfKvfHz15x7dRYEEKQ?=
 =?us-ascii?Q?ghLkg2OeMMn76uQDrUMlAYnC91YRZ+6h4RFCmTAZ+9OCB/AdQHCR3XuHxS94?=
 =?us-ascii?Q?5U9Tjnhe6JazdX98GhmPkxS5CAFhU2kdXkg2nqSO8vEG4AwpL8nt4xNJ2rvM?=
 =?us-ascii?Q?/KUgpNofPMx4JTJu2EZ7WoHP06NeAhkKt69P6z8RBnHxnSNdYcXvdOvXuzAY?=
 =?us-ascii?Q?C/NGsDhCmm5mow+lALyWgZFsPnXjzQ2VbpoZ6tuZbxu/rXY59YUkIFrrrTHZ?=
 =?us-ascii?Q?JOy6WI/mrxk0Wt9NnGjus+N0s3EaV4xTRsqDUrUfQKKMyYVLA7uP3/vbRZah?=
 =?us-ascii?Q?Zcgnb9blX38gqBavOgScUxBkcyor2M2vvP1e4IJDURPikdDsU8fbgF5FBlc0?=
 =?us-ascii?Q?JZ6faeOOEDLBQZquq936S0BwygD+cET5xRSxuM5g6JgtybTvyiAuHOB9fy2u?=
 =?us-ascii?Q?94rd+kF8RUYssMO8D3gzqMcFzRsS0yZyupDsoNaFBZWicW+w+v8ZmOP3Wcxm?=
 =?us-ascii?Q?1drRmhlITZSO/3CYbzEmHvP/z8odNw9rhzuZQVPkmZbv5FJjGeai3U5V8iho?=
 =?us-ascii?Q?vkeN3kgRHboTVIgRtrIdGlWbVZg+hV7eLA1xTnPHyqRE3lxkF/rZINUgsJze?=
 =?us-ascii?Q?sVrfpr2mRukulWX11HFdHLnSNoFryUW6P2cRLl0kRTe8ymYxPAKFkp6q7QMe?=
 =?us-ascii?Q?wD8kt92WNNK/dAkgpZvoiWaljsQQV3bD3zsm/wlXL+eXwJ8VCrbEyRlCePSJ?=
 =?us-ascii?Q?0bqIx1LY2zLCg0yFmsUpDJg4zsrMw+Tz5BKWq5cG1iHPnpqcYsQQXBnkyBu9?=
 =?us-ascii?Q?nlb68CMGBWfkXjLfVW6j8feyt/q5oPCu9120vDu9NahUQBXBp2wmEKoGkE0W?=
 =?us-ascii?Q?5YIpsTDYSnwN04Fj3CJFV7ARJD0glNNKsZF9q7RrqTqa5kbUIOYvMh/yNcNy?=
 =?us-ascii?Q?r9wCFQXnTHF6PGW+cdPyRXFGcsK4ED8QZ/qtF4ohImhgnTAfMTBK1CRNER+y?=
 =?us-ascii?Q?nx2/3E5YTNfteO4RGPeMl32ITy8QoeI/JfcVskpf0y2xJAqcwzv1jTOUk8Nq?=
 =?us-ascii?Q?SLIV2ftYGASHcPJG9r+SVrEXM7/FaoVWODIv9voFg0fCqnxZub74wwwjKy0A?=
 =?us-ascii?Q?hlOmRvNwdHpBvdsGd87IOtCKJ+8ZF+hnr2wt2wwW0nfH3HUpNxaupbkA5Sx+?=
 =?us-ascii?Q?tyLdhjK+5jc+FnZr35QA2u+RWLcsL0KBF4KQgfQV82F1kR9HSLmJ0k87qg8u?=
 =?us-ascii?Q?Iq+V0VyCQTWDH8G0/rIieuQMMzdFHVHJPWESBaZnp7R/8Tepaifi6/CCPFOg?=
 =?us-ascii?Q?I5tOdnij+Pogbu0XAc6diXmi3pgPkdFrPmvTwlLrl5XAFi4uFVeqIbjUsTVO?=
 =?us-ascii?Q?RQUbvFncC8URSI5B0rJzFmvqb1D+IA3tve4KsbR6X5cgJcFbv92XzMHQImJr?=
 =?us-ascii?Q?sAIcbgZ0rLY7LvXlk9XTpyLXyl9eV5kmfCOeylBdrZiAYsnqDinstEiI62mt?=
 =?us-ascii?Q?D+e0TgS8qway6ADpBVLyqo56MF6J70dgXfqAixA/9TiH29dBzG0cf+9LdJF1?=
 =?us-ascii?Q?pxe49mTZ30WHT5HDzdIgrU2Vra4c9AkihDpOl5Tvp8370xV2YqqIKRmrffrR?=
 =?us-ascii?Q?512zTg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50da72b2-89a5-4172-d14d-08db3f3b0d84
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 11:58:26.6704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jnjP0FmVo0hZcETJjsx7gXjMcdKUGq/tdhFe5fJFJBNLh0uF2or6d+xbIRGXB42B6K/UDbDEKhqL/zx9XYL2XlWUoXIi8ViwYGW4mdQVLCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4627
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 10:19:24AM +0200, Michal Schmidt wrote:
> The ice-gnss-<dev_name> kernel thread, which reads data from the u-blox
> GNSS module, keep a CPU core almost 100% busy. The main reason is that
> it busy-waits for data to become available.
> 
> A simple improvement would be to replace the "mdelay(10);" in
> ice_gnss_read() with sleeping. A better fix is to not do any waiting
> directly in the function and just requeue this delayed work as needed.
> The advantage is that canceling the work from ice_gnss_exit() becomes
> immediate, rather than taking up to ~2.5 seconds (ICE_MAX_UBX_READ_TRIES
> * 10 ms).
> 
> This lowers the CPU usage of the ice-gnss-<dev_name> thread on my system
> from ~90 % to ~8 %.
> 
> I am not sure if the larger 0.1 s pause after inserting data into the
> gnss subsystem is really necessary, but I'm keeping that as it was.
> 
> Of course, ideally the driver would not have to poll at all, but I don't
> know if the E810 can watch for GNSS data availability over the i2c bus
> by itself and notify the driver.
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

