Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1DE76B2894
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 16:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbjCIPU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 10:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbjCIPUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 10:20:23 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FF9E9CE6;
        Thu,  9 Mar 2023 07:20:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSVxUYMYiFLFVpJROEf7k6LSrJZU9cl/Xf5F6S1Z7JeFK+ETtDj0GwLzJxYuX4ZABJ8AK3t8KtC8MljjwNOX0hBotOxGDTFUVjHDY+MgDx2d862CaukhLgq80EsJmByTGEFL/fJvsaQDjvXEmBGv3pxMLcQy37EJtYDUyxZTiaIZ2bHvP8JRy4NS7dmqp3Ocjd+GAfArGPFvbZ6Zhx/JvUSi5qaakzm2y9AhDyLYhMl7VUvSmTSeZT2WmbYhxJ7sZK61vyv+7AhTtlSXf5OdtvW6FxZIGk3AHDz7PgnocZHOam0ng/vkl1UCMUTkN67+5BxyNkLBdwAre8c/T/jmkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGc9DL7SYAtSy/rlPKLz/skaH7q33DJ3V2q4JDxmeF4=;
 b=MIHYH67s/FhvUc/aiwhFng7UVYTrBU7Pfox5i5CPmmzJk5zG0pPdZiLggQfXf2JxmexgbI9lY7fRHdxRZ6O7bxyTls2STpcfYGj1kUKAZP5RA+9Ccu2dqusv5txXy/+0VfnwnRtkcdcr8sLEoy74rZIBT/bon5kU+6rhAGCz3TJTGDy9UVuyPSK0bVbQA+FJfuaKO+cUM5tAP4p2Pr5UemWbTEBYxlpq8sPUwpUFbnz1Yw788uIfw+reYZBGaqzpX2aX1ToJWHer86igC6KzH/odDSTFcx7GF4Z8u9sJx7elHR14djDCTAb0vJLGC4RZyymBV9jX4qNM1ysu+mWxDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGc9DL7SYAtSy/rlPKLz/skaH7q33DJ3V2q4JDxmeF4=;
 b=Ehke1VLNjwfycn7Qvi9fhRLS82uwyma7WjYIgdna7u/a6UB0tM5oHrucgoCHdH8nTw1fTAoProSJT0MX+o5hIFXxAs88iiur/a3ERSFfcm79WLg82DDLvqVszM3Pn+AGPZ73/0iAFTOVmAxQimAELq6ezTX8NpZNTNySq+2R6Qk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5230.namprd13.prod.outlook.com (2603:10b6:408:159::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Thu, 9 Mar
 2023 15:20:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 15:20:13 +0000
Date:   Thu, 9 Mar 2023 16:19:55 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Vincent Mailhol <vincent.mailhol@gmail.com>
Subject: Re: [PATCH] can: rcar_canfd: Print mnemotechnic error codes
Message-ID: <ZAn5G4zNnHIgyJS/@corigine.com>
References: <8a39f99fc28967134826dff141b51a5df824b034.1678349267.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a39f99fc28967134826dff141b51a5df824b034.1678349267.git.geert+renesas@glider.be>
X-ClientProxiedBy: AM0PR04CA0011.eurprd04.prod.outlook.com
 (2603:10a6:208:122::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5230:EE_
X-MS-Office365-Filtering-Correlation-Id: 4edc4584-e827-41e5-1d8a-08db20b1c779
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ShycOKqUDTPLhWPB3Qe8QVBOJIPgS0r1k0mOQ+RWBRPAdNSCFG0wHzsuoVs2aJLQ1j8Oji0mF6tfCukAlp6b2YcOdf3wDksp6uhCQpEWdHGWJlW1yKfkqwocMbwGb6Suo8aGF6+sd4kwkeU/BjlfikmTIp0U+61XN/dvywPY3a0P7dB/Ik9MIrhD3PvBXTJOSKpx0FAnpn4t+DYea5FOSGWl8+DFjREkiHZj9sOiX3n8Mxrzc2Rc97hn8QwevtdkVmc/WLgfcd7L/DcANi4Kn49KGnTAwaUhtWRRryokG09e0I18NPsAS9QQ9VEiOFLjUxCoLLMJo8K++tlPR7lojjdaI866ZMYjdKESOPI+4wJm8GJeIqNTB6pe2E6l16is81DuMauVtSAqUZy4ZT3B0O80dFjA6b86VVS8zi2vKbLQ9JCbms5RGVhMfDroX1dtmOWArV+ouUobIH1w/2VPrU+mcesiS7OgjwLEdVv8BZFVsCeHoCzsDSoUw57VUAX2G/JSKud4NLUWeWoiQoOrbQLBTcmZa/+8KhScX3fDGAz8smtC0L0DJDAYMm8wiUk8xZGKKMIUGTIG5w8EM0RrisnxEV1en66ff5axVzGssvh6FQ8Ka6H1rP8btwE0LA/UDtpkhmKhXyYSDrJjGgFE9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39840400004)(346002)(136003)(376002)(366004)(451199018)(86362001)(54906003)(6512007)(186003)(6486002)(36756003)(6506007)(2616005)(83380400001)(478600001)(2906002)(44832011)(4744005)(5660300002)(6666004)(8936002)(38100700002)(41300700001)(66556008)(4326008)(316002)(8676002)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7wiys24GM5EtLck8wxwF9d6Jq56mCV6xiKcaXUemqORJqk6t6Jh241uJBTzE?=
 =?us-ascii?Q?nSV5S2WVL4vFdxMPB5ZvLYS7AOGAmrWSVBQWectGeu88YQ4c3sYLbEGukyN1?=
 =?us-ascii?Q?80qfX3mUvXeTsERzgGDQXF+t1qf1McbA0BdDzwXh18jhzT9mbCfuh64fYVLA?=
 =?us-ascii?Q?q7GGRkHdx4nRCa4T9Q147Ji1ODynunw96btuxtGN+fKZ6St/Wd2qDjAGtU/J?=
 =?us-ascii?Q?G5HyTvIdEVgH1MoGIj+eIf1NYPqPFrUxTJ3CzfAR6qz4ky14IAOs80536pBh?=
 =?us-ascii?Q?J4uzJUgpMngJXgNv+oLWE7aPF7Hz4r+mZcZRBIh7NaOVJMaSdExFBSCYnPN+?=
 =?us-ascii?Q?evO2x9nn7POQ5IykJ+An6K58QJipNuLcdAzWsNWYz9bvkR7N0iKszIssMH+Z?=
 =?us-ascii?Q?p27DmnfkScStCqbnSEdBlKtZ84iWHlIbeANp9WBhUB1pfYdCYiouyE1Ek7cl?=
 =?us-ascii?Q?NejWo1ip9DoUqNP5bji4SSS8MGqQ2vCU1bdCwH9y1hgBJMEGKZ1bgc+iZs3G?=
 =?us-ascii?Q?oENA6fYkUjDR7Qrl45iTH7hMupv3hgD3FtD9nKkVnbqekIKqzmgD3zQvK+J/?=
 =?us-ascii?Q?Jv/z2wRFRVEVJr3U/Enp+y2FB1tOb+wMsTDW4gqWQp06/F9a3H5xBFtpB6VJ?=
 =?us-ascii?Q?HOtYYi023L3HfprzsjaU3+SYnC9J4eIdQoBMKwK1ziqs6//Aa2nrKeYS5BQe?=
 =?us-ascii?Q?oSTP9Bow8oOi5sUWcYrRT1UabcJ039N0/lSvg54mP1sXcUahnSW31Cmczip2?=
 =?us-ascii?Q?gjGggMlJ6Eq4Ac2W78Kkq4wGhh9MAL3s3KD9g6wosDT+adbmpMnqJnFfnCf/?=
 =?us-ascii?Q?FIEu22E03emFLy3GZ6St0lIhGru0Dz3mg1oIWHwz7LDKoSjSqD9fts9aWwRX?=
 =?us-ascii?Q?fMqtxQDv70gDyaezTxVfsmnPZxsJKOcFKLKo4Jmk6gpHaUkUXl36NjxSuC9V?=
 =?us-ascii?Q?2ewjPp61m40wGquOh6kW6Xwjpwet/b1jurD5sUCq0sMGqgIjWifWEJpdktPd?=
 =?us-ascii?Q?hXm5ZEdXLQI297VeJAkxMOjNe3zFBXw5YDTmt8w0awoDSvCe0jd9V0Jj1gt2?=
 =?us-ascii?Q?dYIC6t9SJl4lgENlR8hE30D77wB1VOuZGtpzHc+cFYU/+W4yPgnlDANAYFeq?=
 =?us-ascii?Q?xJv6/s8onII3JikZNXpb2e7dAUmSW2qVOp1evLKxeUzJkDjlMTv7eLXoCnCW?=
 =?us-ascii?Q?VViaBja6d9pzfW1AMW37DgLRQboCyJhs2q/qJ7a2Isq4ycW4IZG5J+pScQ3c?=
 =?us-ascii?Q?12IDxvEem9aYmElG54yf6VLwX4j5XxCK04TU3djbH47nh72kq+Jyig5Z9vMB?=
 =?us-ascii?Q?2x3v5yspJLqHjczrDHJgbhpE7AlHjqlk/9zzNmKsJmPsgSkgwYR7D+Hp/sUO?=
 =?us-ascii?Q?KGvAYWZsxRC4pZw+xgo11JuEjSqnETEMumtvcgi/lIZARw1/8w000hy/0jFH?=
 =?us-ascii?Q?Cs9nEeTv5VyP8TTlYiFdqhtmOb0MXGGOHtaE6npIGKWvTFkFS3ApeFnGhMq6?=
 =?us-ascii?Q?rRZcW3/oZK9BCB1TMYXXLp8QTBSzXNguYkte01M+guBb55XTvvkxNUp2OiqH?=
 =?us-ascii?Q?T1Jk9jpBwBFl+NdXqiXwAFxsSH0TFImZlGED0xkldIwKJOF3f+wAg4kjAj5w?=
 =?us-ascii?Q?aUsTEAsyUYpoB0curHZMLxalGL1baK5WI1S9JIdHhW33f9QFlEz7Um97XRzy?=
 =?us-ascii?Q?O3eCTA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4edc4584-e827-41e5-1d8a-08db20b1c779
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 15:20:13.4566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QnTPkNHRDT+ITnMeayZGd5BEX/sTK26QR57KZIcby1vPKva0pj4ihW2Tw8Lps7HwtL8kgoEebIPaa1G4TJgRerCWaY7Wp5MVZldAHGTO3Ic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5230
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 09:10:22AM +0100, Geert Uytterhoeven wrote:
> Replace printed numerical error codes by mnemotechnic error codes, to
> improve the user experience in case of errors.
> 
> While at it, drop printing of an error message in case of out-of-memory,
> as the core memory allocation code already takes care of this.
> 
> Suggested-by: Vincent Mailhol <vincent.mailhol@gmail.com>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
