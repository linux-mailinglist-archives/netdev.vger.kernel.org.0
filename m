Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02CA6A96C3
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 12:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjCCLyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 06:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCCLyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 06:54:39 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2132.outbound.protection.outlook.com [40.107.93.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E8A1284C
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 03:54:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REnmMumeu3kwF0sKViuctC8WoyNUarqV0VHbzh9supqSiOj7+7dktCtxkJGuTWt4f9QtEvv+in89O9n8R8euUIhR2i/LqXBgnAiMu6Y+L3k0toWj3+9XoAWimSXlC3SxJnpr/eYsPwDKdX/lnrk3/r8i9Wp5xEE3mY3dJdsjtDAGVfp3Y0G+F/czrADSAMSP1MywMNahIY1H3RfeMroZvTucodtI4EvUE5y5JZstV4ZbKbo11wJwwnnoBx10cWmUfJH98AYiVgOLcR99GN55GmYgV9mhmNU5nDGWNSUmrWFkq+MaFnmZqkmX1XUaWVJeoV0FtKRp7lXJ8h/xgkC3ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bu/hRI6kSxAWrpyZjiSZLapL7kRWVpdoqx8z1rQMd94=;
 b=LB69g8LDnt91/ARjfUlJSvxyCSm3jSxyFNyrIp43JONUHf9q6rLjVert0QQU8/QlOmpvAmHKVXG59XeIvJve7aTKEVZ31Q8++CzQF//1QfW0chSy7xtPbdbJIwJxOo75Zm1H/Eqzw82R3s43OU9mb5cYOmdMQ3m1bqKln0A1xcFJ1LUja2PmpTsqBzn++ax/3fch5ivdVMSmrq8XuX5PmWF6oltwL8z86tiZHTSqlTmjz07iTwmncE+Z5TNJiCqrtx9p0Om9dAkgiPSgy9sSHKI4Jys2D4z6v+yEwyfHiq1aft6BCakLSEMMFyBwUfmP7OBNZmeOoKbWwRYU+68DEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bu/hRI6kSxAWrpyZjiSZLapL7kRWVpdoqx8z1rQMd94=;
 b=dkI56YIFRXHEhmQqfF1+82CuzEVMHnoLsEPEYXFmL7F2hBN5/LkozlpJGltdPKc4hHE8l5oMjNKyjtav0gfm+xkTlNRGfVB6QixCIN3KpDLDYRm1FP8+xxvBIuQBuGytZJ81wkOikZDymg1N6XBFxcIOjK9BtdupRypJI6eOwYw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5974.namprd13.prod.outlook.com (2603:10b6:510:16d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Fri, 3 Mar
 2023 11:54:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.021; Fri, 3 Mar 2023
 11:54:37 +0000
Date:   Fri, 3 Mar 2023 12:54:29 +0100
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
Subject: Re: [PATCH RFC v2 net-next 4/4] net: ena: Add support to changing
 tx_push_buf_len
Message-ID: <ZAHf9S1BggzVUodx@corigine.com>
References: <20230302203045.4101652-1-shayagr@amazon.com>
 <20230302203045.4101652-5-shayagr@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302203045.4101652-5-shayagr@amazon.com>
X-ClientProxiedBy: AS4PR09CA0024.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5974:EE_
X-MS-Office365-Filtering-Correlation-Id: fb7aac20-1b4c-4946-d7b9-08db1bde1001
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dKiAjybhDLOEPqrYpFEADybsx4NOnloSn4OtkGnTcRwNrglI6y00YD6zLzr3gMDCtNUyuVnr2hfrUGN1Chj2R3QAEDaBW6umCEyaimjPDZtbiNCab98JGy20R+bVD3sQtg3zbxJLiv6kL5JgXUcy7idNfsX82tWIFJjyo6ZyItXSPG+X4ez+NGDTX3Es6BgzmdneuzweXoQJekYqKKLaml9z8nMWOJxxcD2b4QYZqfv8ci8mvRn7k5d1H30FU9FKqGZH+XHf0sMvIeM8YvI7qK38dCfJKJe3QFjEoRSl1KddQDMzcNBOKqY684lRuDSaX68RRPWqubrg1pQmIqhkiXcXQI5syEt3B0SBKkWB8a5QHRfIj36AgAIczrELhSkLc9eRgTfVc5akAezN6Uke2uSPxxhSVE0Qyt/7rEI87gQnTsk0iRKRP66B2u6116lzvDFW/v9cmnlh1N587uLHLVWRWy55WQh9tGrEomEnEedLUOTv+sJoMwbgbx8B/KTPPYuqCvThRpWwSMzxqmXYycXdBGndXSA7vZLKGkhhs+e23tCnIIGjfUsxBeEwZuYps7u63N7EclP1OqUjFQwnEjPZq+9sdKEv31phSQ1iqEOYDZUAfOxPDpCsQyN5O6qUaHsUe9S8Vf9xPwf8unIe0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39840400004)(396003)(366004)(451199018)(86362001)(54906003)(36756003)(2616005)(66556008)(66476007)(186003)(66946007)(8936002)(41300700001)(8676002)(4326008)(6512007)(6486002)(6506007)(6666004)(316002)(5660300002)(38100700002)(478600001)(4744005)(6916009)(2906002)(7416002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QaTq8V6PVaL+MPVWWMSMvK8zJCejS4/sCFf/6KpdCTOytriubWm9bthk1ljj?=
 =?us-ascii?Q?768g9OIEsz7P/Pv5iRcZHpHjtLk6WLvM5ZAK0K+0NZY8XBh4E5zekg7E3k++?=
 =?us-ascii?Q?WkA/nskw4uB2/0kBcrHMkVM+hlv+HsX6ewJC6WY6D3w2bCrodzcTqoxAD2uC?=
 =?us-ascii?Q?xM2+FW/pVhnCU9jtc6skmyXmNgYgtuhKnBpif7jDSOkqGzPlE3814giW+BXA?=
 =?us-ascii?Q?5W68JmXdtXduhyvznXqZBAulcKPjg7L4rlRmaKYgNKo32adxDzN8RZAW2u8N?=
 =?us-ascii?Q?v/1ZXZjzoiblAxWVCuQY1kMom9/LteqpZxcbb8OlWBFQRfK/pHnobDT/KJEe?=
 =?us-ascii?Q?XAbiawji5+sHU8ugnxU/yCVs285Qya1DK6RZj8B56KSmCw3phx2DwKgeA3Eb?=
 =?us-ascii?Q?KRPN7vmP7il5A0pbLat6TEKEmSiZaNHHI5Bz3zpr6Eo8VzIk3UyW7ooyICKC?=
 =?us-ascii?Q?kctcR3fkix4Udl5SXKFuW8pu7WQAEhceP7teIPfp5aTI+4i1EU0LKjRgFPjq?=
 =?us-ascii?Q?K9l5fDX+hg9pO4itq/S85EMfYs8hOgppQxXFGMYzBucENy4yUQK+4QOfPRHg?=
 =?us-ascii?Q?aUGZVcM2FSSsU9GZShdpA/uojyIISgpQfM5Cu7JhfRxgyFmDdr2VB9Xmmyr8?=
 =?us-ascii?Q?6tle8fuN0CiOA76gLJyvrNil4JXnpVHbZAQLnT6Z7DcWAP4H1YTk1l1QgWSL?=
 =?us-ascii?Q?lkk5oFkaIDdono58hmqdejHHeEOYVcT6o5EU3bCNBUx6drimSH403fmK6ad8?=
 =?us-ascii?Q?sIWSuZioWZTym7pVvdnuhpB/QtLwryV2ahsjzj5mQScRCpMCdLo3McpRQTL6?=
 =?us-ascii?Q?5/lUQcwtb/l53ECB17riPjZdyYnoZQ2qdjht2h7R1HnQkWxrgFMronwQ8CKp?=
 =?us-ascii?Q?KhVfvygrufKVuhZzZBlRfD0lya7+7g5O+szmNuFsLb7XvpH1EZ4jqaal+EQ2?=
 =?us-ascii?Q?XVFiPYdhCVyVGCPJUsOoB+a02U77lh7Jso5ICJCFCwpmDJFVhbGM1kcdxsyt?=
 =?us-ascii?Q?la62rdzJLx5A3DEilwdUCoPXzovxdKt80vavBhzwI6Nq+jFs5uxs9Ju9hese?=
 =?us-ascii?Q?7HT9DHRRD5ZXu1r9ebIRvNKGnHElNtvZLN5cQ13fn0fn7ifVwS1UflksLle7?=
 =?us-ascii?Q?MqemriGiwn++T+D1BhcI1PQoB0JBR8A5nZ4M6ihRS88FoI8iQN0iE++rMZ9H?=
 =?us-ascii?Q?duO5eIlNSEZgAqes8IizU7mvd2zDD1CAn137CBdBUlWxxr0fQtWvF1mzDWDL?=
 =?us-ascii?Q?c/CoYhwVC53HmvS9FjFrowQsaJQpoETcBorE8GK2EHPL/XRmspMEiFRbiRqp?=
 =?us-ascii?Q?VqGi87tdA2X+oF/HUWhU2nHfb7rTcsG3QCINq/W047dsYAI3f4OSRT+5UmpO?=
 =?us-ascii?Q?1nr2klwVK5/ybnPapMtgndv2QtAePcBlaQeONmt3OgLHZU4UF9ObskqO2Dfh?=
 =?us-ascii?Q?JOzVgjzr3j/3KEtGKtb1M5hIxruBegfayoV/R3uyS9fiECaBYi1aYeev/Xyr?=
 =?us-ascii?Q?YVka+gUeP0hxVs++GVYEdWCDkU5dqkqvzAa6WGJWBVbG1z308szkLvqjFj9O?=
 =?us-ascii?Q?TbUPGfG/234RrIiFd6c3aTExqj6uKnp4ykMSkZxDuVMupVWW6fsZ9sQxabYC?=
 =?us-ascii?Q?rSzBbsFikVPBBNJQowwdVrEfg1oxKZndmtmIt2YP4ukFdIRLL0dne0JOrf5v?=
 =?us-ascii?Q?rOYLLA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb7aac20-1b4c-4946-d7b9-08db1bde1001
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 11:54:37.0334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FP6oKwIhMX87h7yS2r0PEBy4aVQHJ91h2vWect3IOe75TNeojLyf3vjtZkCSfyL2VkB03GJcjVBge1YL0Xx7O+0q4pdrUN8ZXqLyo+efkb8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5974
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 10:30:45PM +0200, Shay Agroskin wrote:
> The ENA driver allows for two distinct values for the number of bytes
> of the packet's payload that can be written directly to the device.
> 
> For a value of 224 the driver turns on Large LLQ Header mode in which
> the first 224 of the packet's payload are written to the LLQ.
> 
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

