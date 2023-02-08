Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0DC768EE88
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 13:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjBHMIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 07:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBHMII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 07:08:08 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2115.outbound.protection.outlook.com [40.107.212.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140B9271C
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 04:08:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bCyvZjFuM/4mc7ocRspziphBJoxirVIAh7HA7fEn/wezrBzbBItl8bMASDHDCrSxDFteZtB4YcYs0J938/9o7mvigxl3Vah+6uNjEQE4nq3hQqUUUWcFMXvIlBH8TgSwhQQNKf8BunZemBw3sdhkXhLBrvBdDYZXQK9r93duUBwb+K6yapoaTu1z7XmIw8+mzsG+bW/Tf0H2gDrXTkCrOurawoSk53k0uyoPeZJDg5B8Gnop4zVtNqgQObndb6KVXeZ1UATs33Ez1xzrbWQ2efXer3hUo3sn/SEXtMtdIokX+3BKsD7hT8snem7PiLkBH38rxnkxHQnB/ciBqGjoig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=goscJxvP8w7tbW3gJRfnNNOJtfYjeOvLnzrUcNGQ10g=;
 b=d6sVNeagEzVtb4DunjzaS4dNvpVIQBhzB0H/BMi5ugmfZ2L7euzHJwriu2cx9/edn7ZHrYvMUZg7d6VaL/QigvjLrqlOLCF2ky+mAxMj3qcdYk5jyvI8TkpzfZ549lTI9+8IPY1b0H2mwRiDM+YG7ZraXvBNCzFURsa5ffGIcwBKKajSERY7SWbVrcipTq9YcoEsFLIU3SKGwNoTCX7sNrvASPYGF33thmZBAfQSkiIA3ueST0e1iyMDiFUwWVvxpkNR+A9RkchlMqV1HyNaKk+C4HK5sOu4PWHYrIp/rf23IgaxXvhBlyHtS5rknMPAHP5+89mFesvWAmiv1vin+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=goscJxvP8w7tbW3gJRfnNNOJtfYjeOvLnzrUcNGQ10g=;
 b=Hmn89cgBiVbfpxIsBsNam3veS6q3QoDcefQ6zIjQaUPcv56GwNePFEWvMyDE17m+sJxv/hoXXc7AOq/W7J74gLUhNLQ3wZN4i7nGawaQNRP/cG00JAqYD4D2Lx1zjYAi+VpLlGHTmsC2CAkrF1v8hyTj4FDhSN4odB0bhBIbjyc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4640.namprd13.prod.outlook.com (2603:10b6:5:38f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Wed, 8 Feb
 2023 12:08:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 12:08:02 +0000
Date:   Wed, 8 Feb 2023 13:07:54 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Message-ID: <Y+OQmjJFeQeF2kJx@corigine.com>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
 <20230206153603.2801791-2-simon.horman@corigine.com>
 <Y+OKPYua5jm7kHz8@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y+OKPYua5jm7kHz8@nanopsycho>
X-ClientProxiedBy: AS4P192CA0005.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4640:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cea9038-2d7f-4588-d31c-08db09cd20a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aT6NK5kQEcXRE9PIpmjm4Hus1LO4Yc1PXS0f1nRwgTbhnjxqD11n1ER+XboTG5n078su4zrwoKQuLoNjEBnAgUqVnnSi9cH/FHfrfLfl651bNlixqdWzap1cbPS2GVVBVZcE+4Pe2QpstHlLQdjIzPTcp0uaC1o/7rLs7SJfQfEIsIFbd3vkMjHFySWqgyl7KdCoR3IoPimpON2kWfORhJvHbMHrr9DVb3XPKe8mdG4lGQNcUpNc2FFik+khI7wjbPtuO27GH8zir40EScZfaW02B0TGQCHp76Iri8Y508CBv5nQXCRPoojsSepz0cRR0arLvoTdrNhhvEpw2q0uQINccGZT/b7hUVrpKgLCRbnEnBK48tzY56zVppCyL8OPKm9+BdkBpNh5LWTiHVBpeB/wS3yTaaUvRexDN++JnwPulZRn03B/XGtZuVsKKrnBkNbO/rzw8eo4uTPNmt59NWAnRqB/RfPtrDM2mk9koVZIjVuZmh5t0zPycb3dJo2oCh+czeFG+Wsac+cgmhGcAkA+61wnc4Vj/S9J98Nx18vC0I2JyBCemy6lyt7t0Zj08Iw32d1nrmbQfXsA81cRCaDISUT3j9X0b5hhnwp6m3f0LI/w4kijiQKKWumWV0dDIu4r+Uck6gef3Agg2VjaL6Vw2J4N8baJ8ba9/UFFljFB3T4OBkDvcswCVn3O63io
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39840400004)(396003)(346002)(136003)(451199018)(7416002)(44832011)(6506007)(54906003)(8676002)(6512007)(38100700002)(316002)(186003)(86362001)(6666004)(107886003)(6486002)(478600001)(8936002)(41300700001)(83380400001)(5660300002)(36756003)(4326008)(2616005)(66476007)(66946007)(66556008)(6916009)(2906002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eTBRZ2d2YkxQTTdQNitSYTBNUVNVZWkwVEc4TEIvaERVeWg2UVV2aUdObnha?=
 =?utf-8?B?SS9SUGhOcVJIeFRZeERTR3hDb1VrT0RvYWljN0Z0SVloMlVheHVqR3JKcnFz?=
 =?utf-8?B?VUUrVTBPVUZ3Ky9BaVNqcWIxSjh4WElFSk9Ka1c0Szg1WERrVy9ab1E5cTJG?=
 =?utf-8?B?UlBMbWY5emlHeEczbHFLaXQ4amVYN2NDeVhJS0R5dkp1VkhOVjFTZ3o4WnBl?=
 =?utf-8?B?MzcwV0xONFJOWDZVMnZqeGduSnRzR21xMDV6MnhkZ1ZXZUE2Q3BITXNDeGJD?=
 =?utf-8?B?OWFyWjMzOW5TaGhlSVAxaStRUXJXSDV3b1J0R3JNYnJ6andMRGRxcmdkNmx1?=
 =?utf-8?B?Mlo4ZFNHVjRVWEp3SmdOTUZxNlpOcW90ZFh6aGs1U2pMa1lVU2FpbEgyVnVx?=
 =?utf-8?B?NkRoRW5QZUNYUXVsalQ4Z2dTYktKREk0V1N1TFdreWMxdTBSNTMvV0xWa0Fj?=
 =?utf-8?B?UktiWU9oWjg2ZTVIeThsa2xCU3l2RzlqbmJJV3B0SFlzRkhoam9ybnhDUXRz?=
 =?utf-8?B?aUx3Q3ZKSFVtMG1SdjNHZ1BKQXdTN2hIeTVra01TN0I5WWt6aFNjUHVZem9j?=
 =?utf-8?B?QWN4TkRBQmx0akNuUXl6dVR3ZlFCcGFkMU1xTFpydWtVTSt3a0V0M1M0Q3Zo?=
 =?utf-8?B?M2x6TlVpTThwNzZvUmJoNCtIUmVSb2FNWTNxTHZHNVN2Si9YcHJEajRDaFBG?=
 =?utf-8?B?anMxR1NIdGRZYjhpZ2NaaDcwZWg0ZXFBbWdhVCsrZGRaWHV1RkF0U005YWdm?=
 =?utf-8?B?YnhjMkE1TitpRHMyNlpnUmY1WjdKUDRFK1EvbjZYUWxMRDJCNnNhL2xRQ3JT?=
 =?utf-8?B?Z2xoaU9mNW82ZGcvRU4rMEFVcnlPaXV6dDdsTHZxWE5vK2IwS2FwbWQxT1Jw?=
 =?utf-8?B?YnVLVlhPQ3RBU1VSQloveTF6bWNPSkwyb3VxdWhFOTE0TUlqbVd0Y01ZNng1?=
 =?utf-8?B?L3lHYkxxVTBTbHNadjRxU0tNeHVxaTV5enVsUlNYNjVNdlk5cCtHeU5hSStD?=
 =?utf-8?B?anAwWS9qWk82d2tEaTJBaStjT2pqSHhxajU4V3ErdHhZTVJobDN5N09jTFNF?=
 =?utf-8?B?TVJhaVAxQnlDN2UvWnlDNFBKMHhya1BUdllwRmRxSFQ0cUdEaDh0MWcrbWgz?=
 =?utf-8?B?Y3o2ZDBrYUFYMDBMVy9iN25YR2VqZEVEWUhhOTZkUTg2YjAyc09WUGpmaGhD?=
 =?utf-8?B?NnBzQW9xZnF0c0JsM05KLzVRRDJOaWs0Tk5RVTR3YnpsMU10bGZEMmtweTg4?=
 =?utf-8?B?Ty8vWERGNlJlbC9sTVp2SVJBQ3FmczVxQnVWZHJlYjQwZTNVbXFRa0cxSFpq?=
 =?utf-8?B?VERpQTNuNzFMZnZhMWRGMy82YmlMdWZmRTNtMzRHNWtTTnhUUTJSRWl2VTJ5?=
 =?utf-8?B?S25EZ0lsMG84Z3JpU08xNUtmdTN4NzZLZWV0Z1lpSnlGUkVQMmtKQnRyMnhI?=
 =?utf-8?B?UDlGb0FkVVFjaTBBUytoWFVlY3IxWnlRNytUN2FmSTFwajVnZlZNWXNMR21l?=
 =?utf-8?B?WmhnUVZTVHZjN0pLM2RnT2tITXVmSGJXRW5oR2p3aVFObE9PYUliL2x1UjlW?=
 =?utf-8?B?YjBpSTJOdEU5cWNWbTU0WUxjV0pzZ3dQdkM5WGNMNEhidklGYS9rWndGcTBU?=
 =?utf-8?B?VGZQaGlreTlUclJteVVZNndjVHpJbzFjTHAvSDhGVSs1dkUvWmpQcmFWZnd2?=
 =?utf-8?B?YWxSNFRqRVVtNmhXUDJ5aWtjYi9SUXVsaUpjNmI0ckwrR0FhdFpBOFZRbzVV?=
 =?utf-8?B?N0RENVJFYlVQR0x2QnZaM0pxWnAxZDdwUXZLU0NOQjU0TG5CVTRIVk5DNktX?=
 =?utf-8?B?WGE1STRkWFFTeFljeE9nTDc3b0RFRE9vMFg4SkZEdUMvZ3dOQTI4RlJpK3Rp?=
 =?utf-8?B?NXlyZFgwcjhkZ2ZneUU0RlpOdzVJS0VxZ1RPeFlYUVhSZmp6NCsycFZhakZx?=
 =?utf-8?B?T3A0MFcyWmhuQ21TSE1ZdnNBRkw1Z3FVZ0NDbk1yMUI1LzF0MEg3a0M5T0xl?=
 =?utf-8?B?WGZOSmJ1cUgvSEF6L2pDd21aR1JTdFZ3L2tDb0JJdlRnUXdXOHg1ajV1TGh1?=
 =?utf-8?B?bm1mMndzNThmZUdPSWVsclFodHhPTm1TdjE0UG9TZ21kbUppejk5MHBDb3pZ?=
 =?utf-8?B?ZFF3NXJTOWpIaGdzWkZGL1JNVWVaazU4SE5INmFtY2R1QlpjRjdKdVlIdDcv?=
 =?utf-8?B?L2VSV2tQU0ZIeEFuemZPRVRBZDVCamV2WTJLU0FXeTJ2WDRCZGowdmhiaklC?=
 =?utf-8?B?UURlRk5WbEE0bklyaERZc25tSHZBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cea9038-2d7f-4588-d31c-08db09cd20a7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 12:08:02.5434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hwsNDNcTtJ+8FlgH8kUOIHM2viF1WZO1apNDfG16lA1HY17R+zoX+sqLNDYSocgPsJVya7qvNNIROKHCbq6NWzAbPbyv6ej3+/6KLLRyFkg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4640
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 12:40:45PM +0100, Jiri Pirko wrote:
> Mon, Feb 06, 2023 at 04:36:02PM CET, simon.horman@corigine.com wrote:
> >From: Fei Qin <fei.qin@corigine.com>
> >
> >Multiple physical ports of the same NIC may share the single
> >PCI address. In some cases, assigning VFs to different physical
> >ports can be demanded, especially under high-traffic scenario.
> >Load balancing can be realized in virtualised use¬cases through
> >distributing packets between different physical ports with LAGs
> >of VFs which are assigned to those physical ports.
> >
> >This patch adds new attribute "vf_count" to 'devlink port function'
> >API which only can be shown and configured under devlink ports
> >with flavor "DEVLINK_PORT_FLAVOUR_PHYSICAL".
> 
> I have to be missing something. That is the meaning of "assigning VF"
> to a physical port? Why there should be any relationship between
> physical port and VF other than configured forwarding (using TC for
> example)?
> 
> This seems very wrong. Preliminary NAK.

Of course if TC is involved, then we have flexibility.

What we are talking about here is primarily legacy mode.
And the behaviour described would, when enabled allow NFP based NICs
to behave more like most other multi-port NICs.

That is, we can envisage a VEB with some VFs and one physical port.
And anther with other VFs and another physical port.

This is as opposed to a single VEB with all VFs, as is currently
the case on NFP based NICs (but not most other multi-port NICs).

