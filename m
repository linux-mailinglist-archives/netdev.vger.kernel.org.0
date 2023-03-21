Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7846C373D
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 17:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjCUQog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 12:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjCUQoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 12:44:34 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2109.outbound.protection.outlook.com [40.107.92.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE29052F7C
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 09:44:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=egaqznXSW4IHg4mZP/eFX+2p2fPwUfyALK02ohg6oV0LzZcFzt4v3OWQcCtyaQvOLXiYmFgjyut2AqOhtP91RlZ/K+hVdX6l744gor5lZ4W993ViZQszwvk4OQvU+yxjulkC/2ZTp17gbrys3UhTYDAnrkOFDhf6k2Tgr479UyEmE69au2KWeg6u4e/A6Rc/S/iczyuwInFoZR+dm1QnhPA6h18EM0cX6YJGRoryA5V3M1qIdqviO23/RbZvrD+Pjd1PVyQZm9pyZeEll7QWTCL+TMjN03LkExjw1mdY0McTCTnQcqmWl4M7IozsqLb7iGeY6anoT0xoUAjZAdwF2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vvcxnl7lwoDrDxgsvGqIaGA/trimND6LIHYoiuUQeB4=;
 b=mWJ2+27xSemUWltsNVQUMQvw5An9Oe+WfjX5nDAcodUqwGptV1Tg7j3U0aMEV0owIHUPrVWyuohGcw7CCu8QglWu3MEtcM+31eFtZl5xOsHOdYVAqWfuRBQm2NCW9qsmy9AlMQ91v9rRPh4S3UT4BrdBU+X/P/ya3k+uflCmJQjTr3ER1RqmqxG+XWwrWftfA0cPC27evy7h55xbGfCQbTZIcS73Gkk6V09jtCV9ZwTIsverwSm8nlwneODjwkZj2vdS1jmCjBoItIvF1+otMfECSldN/kibmooviGyDPuGqy54LLHD0jGIEDGO5M406Uz3MyYVsTudK9rOkJP7I4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvcxnl7lwoDrDxgsvGqIaGA/trimND6LIHYoiuUQeB4=;
 b=rGKXdh61E422abq7Q7GwKaqNqjirbdo7v9eXE/fCJTxLXpLkb7qDqqsQl91rCm5HnYNHF7lBhmQhKVXMEh506NSflMnHpdKLwM07r8p5mBpDkAP4C96JhsQzWmTxUvw0PlF/5v6VaWc1JDjmEClSn34FYfSMH5l0Jv6lcLEl6i8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5316.namprd13.prod.outlook.com (2603:10b6:510:fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 16:44:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 16:44:05 +0000
Date:   Tue, 21 Mar 2023 17:43:58 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: Re: [PATCH net] mlxsw: spectrum_fid: Fix incorrect local port type
Message-ID: <ZBneztl7Q2srQzYT@corigine.com>
References: <eace1f9d96545ab8a2775db857cb7e291a9b166b.1679398549.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eace1f9d96545ab8a2775db857cb7e291a9b166b.1679398549.git.petrm@nvidia.com>
X-ClientProxiedBy: AM3PR05CA0101.eurprd05.prod.outlook.com
 (2603:10a6:207:1::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5316:EE_
X-MS-Office365-Filtering-Correlation-Id: 94fa917a-46d3-4d09-924e-08db2a2b7c05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zBw6hmlX4sHEdbjAZJbSLKtwXWpCaH0CWmmr7HzWSQ9L2MAaM8RFgmcIksj4JgKc0bENFRvMi02KOc6BIrJO/O4qnyGI0EgobAb/x/RbG0X5MiHE3MgdgaULOwQqYfB80MXW0H6iE+xVBSesKlgFk9qvTBA8BnYzoxjtqHDlIMrqeclmqHabpOnclaTASNvRdDE8ZAB0v9VDbt4kKbr7DjHHtuEak+Y7Uz0JDp7MA4dLbqOffZgpg8aVQV2hAG4sdGVkfBll6Xf1iOlPKsNzLpIJrf+DvJ2AsMBtgy4Ehb+PDBPIFJvGT8fiu6QAMJnwx1ZtwCLAnVQSqSnNKAcWH9ZXs3BmbsI3fzIBjX63qHqNHbLcwQGbbKE5ij+ibbR3O7pqXrGAXk6780TKc0TPd6pxHPoSs+In6nkMpxN1F4wgc1/FgMpPLLIFMRL1HCnAvrjsQchUlFGQyoa66t3YrWP4SqJVOTsT+stfVnn0/VdZMJaVW4nq6+E0IK4p/askwMErWhDXKRINEGlZq+KgyESabktXK0Z2zH91BSZyMH81JamfGu+uSGTtdTjDupExZc0qJniW9VWx7G4R/QmPwt5ei9BYlYApkEGt789v6RU2E5qDsuStbGmaf79z/XdO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(39840400004)(366004)(396003)(451199018)(66946007)(66556008)(4744005)(8676002)(66476007)(4326008)(6916009)(44832011)(6486002)(8936002)(7416002)(2616005)(5660300002)(186003)(2906002)(6512007)(41300700001)(86362001)(316002)(54906003)(6506007)(38100700002)(36756003)(6666004)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ag/0UKOyC0PmFv43fMUif6h1jJjVZ3YgmZtD8uGFkE0qnolAeuQyZXTdRp8I?=
 =?us-ascii?Q?T3DWU1T9/mUrlKX4tWny5L383kIE2oqtmwZj+ahZlumrI6O43N+z+lG7malu?=
 =?us-ascii?Q?89fFU0ajGPbqdhZwj1OISww4hKoT4fxUtdDf7G50wR3Ov62OdlCW0OpnkCAk?=
 =?us-ascii?Q?NBwJpvzOGKW0QUQTmJq9aFni8Twcm1ZQ1RmF45attlIUU4DVL4zJ52p2QjgJ?=
 =?us-ascii?Q?w7BxwHDUvOkqU/VJh3ec3KvOJXGSsxuJdf8Eg2c20T/BqoL6IqxypAtVUBc2?=
 =?us-ascii?Q?4ONE9vGtPzcFV8Tyz6AAyC0POmozKr+v4oev4lcb0W/QD2ZaXRB9bfsIsP4Q?=
 =?us-ascii?Q?i//e6RLRInO2g8n7G60HpxBEUySP8PTB+1NGXEy2NpJ1BP+bCbpbgNvPFijj?=
 =?us-ascii?Q?molF4CMNSSeItR5Cj8KNo3MuY+Cupf1HhqwtmPOdRuhrLB+VCR6w49X+82+2?=
 =?us-ascii?Q?OoUFjDYZw+tlrJd5mZofzdnu8tlOr4rwH/7rYZ7yukDfu2PS3qVvLg3yKxUI?=
 =?us-ascii?Q?id2dd9n/MMspQESDNlaU05iMTYz32OeC03nbSJvOzphXcakHVrLYIzf2NLFz?=
 =?us-ascii?Q?Eqmf2dUmEREiU+Mt/jSpKA72vGEnihNDJXAMjl1V7sPshudNEOvCeAg7AnE6?=
 =?us-ascii?Q?KoIaiE6MsNYgWPDaKdmXL5ojb4jZvG6COBLCoRdL8iUb3itcURwSsCdeQtn4?=
 =?us-ascii?Q?WRC9UTBjdgQfBUZAlx2D5TJ90/QHnaNsltUn/LIQhtjhGX0pHk8t3saPRyLP?=
 =?us-ascii?Q?moApQ0/EmRAV+mNjMgoOE5ccLiqkch2r5DNvVycyPUCSMoK4dfwzB1nRS+Fs?=
 =?us-ascii?Q?rriHyO8SryyoJjbMv+6fhhIGZP4qavK8260L8M1TpKoEuwWa3pf9CLFz+V19?=
 =?us-ascii?Q?B/w4j7kL4Xp/NymKPqgw07cSg8ZdRobFRK4Wr9/UAhN9PaSoEawisf7AH4q7?=
 =?us-ascii?Q?VQ4n57HXlyHn+ufKEvrGX3JrAl6ql9DSYtzVpi0oEpb62AKK5cdFERjnBzJS?=
 =?us-ascii?Q?fo7myVn7IYrWrUlqhRmB6TLBktQXqlgCN1TtP2fbo5ZfXn1Rj8WiXl9DOTDc?=
 =?us-ascii?Q?QnnaiOdlFRqqAtNoVXWoFHGQ2OlYWFMqCiY6oHbk2nkj6EJkyx9K7v0YhR1A?=
 =?us-ascii?Q?f3BvAeEIVoqaZ0W4porCPuBKU7VE6v4DHYu1aYO9mkQpa9Ot2SrbZGc5WmD2?=
 =?us-ascii?Q?f/dJWqMY+2C3awfU8cshOZyZLfIhqX27Vg07P5RHAbsSk2ylnbI4cfy7HmH3?=
 =?us-ascii?Q?7bjIH+ByU1qMqpZRez3RlDTMySdabOTL3ozyPGXsy8wJGmzVd1cOuQ89sESo?=
 =?us-ascii?Q?rdyUbwKhlQFU5uBO7MSnI6FHQCcjtUPeXPV+zQDUrR7fHYb3/Nf7A3Di8EgS?=
 =?us-ascii?Q?dF7ZmmgPLXUAFD/xFtaWTQd3Nzx2Er++d0bPd8A7osK+Wl6RexbkrU02Vbi+?=
 =?us-ascii?Q?V17LC76TCIVX/8pg1NVaTwxTX1QGI2BiJpEjuu1zJskRdR3t4Qu4saSvTixP?=
 =?us-ascii?Q?JYLRb1BMeKmhCHPup/Wj88Y808ESTSwPxhrrYrhG0QpEgv5aPs7Ppnm+PUSQ?=
 =?us-ascii?Q?3z6nR2yxen9UxNalobhtLg8HpD1mxC2gSCYKoZso4N+ovpX/1VdF2yznA5oT?=
 =?us-ascii?Q?N/xgFVconoj1/Z/bUPwzi4LMt2cZ2aF9EVmL5Jl7bCSX9TEekJBxSRsIxtUK?=
 =?us-ascii?Q?XjEUUw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94fa917a-46d3-4d09-924e-08db2a2b7c05
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 16:44:05.8256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KhUgglFPkT2J5zwkG+4zoUQAx3+rlgnidjUPg8rW7CMNES/U8wa9fR9/DHLndMRU7FScsPFLYgfnGr+6/R7N2niWyrI1hAfDIWpWBdhl5m0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5316
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 12:42:00PM +0100, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Local port is a 10-bit number, but it was mistakenly stored in a u8,
> resulting in firmware errors when using a netdev corresponding to a
> local port higher than 255.
> 
> Fix by storing the local port in u16, as is done in the rest of the
> code.
> 
> Fixes: bf73904f5fba ("mlxsw: Add support for 802.1Q FID family")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Danielle Ratson <danieller@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

