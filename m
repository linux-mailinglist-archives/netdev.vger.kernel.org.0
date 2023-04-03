Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B386D51A2
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 21:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbjDCTyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 15:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbjDCTyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 15:54:41 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2123.outbound.protection.outlook.com [40.107.101.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA04530DA
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 12:54:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EdHvhgFwULQVGhcfUu38ikCPLN6GqcSchRZSREvtmhvceAaKjeylTicgA/GkRcsDvadSLTi9ewXLTeGKAlt6/8gzIrPUX2hXHwLqnMgYOcdn37hvYwgGYm/IlP0beEPYKZzntwtXsTcsogYID3xXdoDZpUkY2GhcJlifuOsvi4GdFKjJTmIWBRFTDoRCUBDOL601qIsb9dlkbf3J8/Uurr3/X+Jcmj5pyV42KgMDiVgo0xWWVePch47WchbGw1b2pRgznFhMa+egxQgYZFkVrLZhPhJNBiXzMfCn5wZQUcklv1VJeg/pMR8opPP5mePAf/luIArD8bPJo36gnp2p1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r0N0EUrJbH9b8vofqh1qHzgW6vEwgxA2Ez5bCxYIEC4=;
 b=oRcDUKLL0+glUJpYzMlADaxvkFVJV49PKeeDpCdbyi4C4tHz7JmBzrTFfc9q/E2+vJThOL0EcqFuydm9+JJ4+In+2mNn+GPEhfZhbfP3UxpaOOhIZ7w5DWNccYWr1cGxbd6DJZcCXFUsHUrX1RK5cwUiiZUR6dRP1xBcTAWQHmscysY/ffDrPCksi9czXnNeYmG6Zcy89l70Cguq+tZu4YQpABChvWdzupIEbn7M8nPJZre0QG9T5AHPC7lsEvK1d+USvqp/zuVoXWQWtN/EzKC3x1nHlU4f9mEiEs2Ut3VvnsDjnF4dVgHoyOF2Hs/bZEwMXJZV6PUikPUOeWCYlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0N0EUrJbH9b8vofqh1qHzgW6vEwgxA2Ez5bCxYIEC4=;
 b=nuDAeQ203/EU5OVUU7xD4SArySp0WdJTyVik9nr15jEZqMSy8pNpgxci7oTPeY9KdKd8oxt/4Qtj0bmZfIy7DvWlvunYrEhAKa8DssBzX5exymMg8d8LNe3qlBROg2hGUhyfpUTnyZy69qid8Rsd7ARQ+657AFYO+1Kly168//w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4787.namprd13.prod.outlook.com (2603:10b6:a03:357::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 19:54:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 19:54:34 +0000
Date:   Mon, 3 Apr 2023 21:54:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Chris Healy <cphealy@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next] net: phy: meson-gxl: enable edpd tunable
 support for G12A internal PHY
Message-ID: <ZCsu8gPrheh2NHPh@corigine.com>
References: <8d309575-067c-7321-33cf-6ffac11f7c8d@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d309575-067c-7321-33cf-6ffac11f7c8d@gmail.com>
X-ClientProxiedBy: AM9P250CA0005.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4787:EE_
X-MS-Office365-Filtering-Correlation-Id: 65d525d2-4f2b-415a-34bc-08db347d3f51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y14gbTSQqe7q0VcPGD306jQ5K5P4Drjjm/Yyri0gfsA9EyalDqdixJqL2QF7DMRX5zUp/P197o7MXPZwnqo0XJYJs+va8XzvQypHSQeWnbX5hAK/laq7Wksmd2W8MrGEIu2yVIoBA44Xqd8205UM0Ow/njr3msN3IDYJIA/4CFyCLuyRt3gjAt6TkaEns94+U/xRom0DE79COFOpivkNYuyYq5oJr4xswFi+GN2ZrPaTNUYEBQeWmB+VwpFA3JyiM+7ohgAHDOtKYuf+Qd6gBDOFl4BIQn8J6gej2Thgh6i97S+o26XAXmjK1BWK/qaDdaym2EyPh/DBaO5n2QgB9teWasm285cWFGfgmmY5G8r6ch1EKL8oSUwFELSegGhIBn6hAb1ev1NkK+zYvEOC3PnLzwYi4Ou/0vvet0PPpnNF6ZsCYmJtTDrmbBmdsAvQFISdb49JL7Z657Op6/vRvndTNfFunDp381YWl8t3/4RcQDSKA5uX1l7JJ3zAf2h84IIxuWoKVUBYa7i+vtbf+sHBzF6LTjojxVM/v2JgjLOoPI8j2LzlzYX5voqTo2vcJooZ2vZ/kIc+QeMTauYhHeMGS7f8ggxxY+HZcWNFR4w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(396003)(376002)(366004)(346002)(451199021)(86362001)(36756003)(2906002)(2616005)(6486002)(83380400001)(186003)(6666004)(6506007)(6512007)(4326008)(8676002)(66476007)(316002)(478600001)(66556008)(66946007)(6916009)(41300700001)(38100700002)(44832011)(5660300002)(7416002)(8936002)(54906003)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bkUVNMoPkR/oVF8OQow62WTbv8zT2vT1DT0MbjvFcR+/8zGTFA4RijensGPm?=
 =?us-ascii?Q?FX7kt7cBkzYppYLpx9TA2jgd7p+yNzRbuEoOBXvlFhyWQEngLtbggp873Oxj?=
 =?us-ascii?Q?2K0sLuR50fUgXC+Tan68cGpNNbHMS4feNBX+K/K7pjWB+ctvhT2pmb+Y3LMe?=
 =?us-ascii?Q?r909HKfQY+c4T/5DhqDTcmgzcm2J9BMpjl90QNAJ9I13JrRpIvYwS8zpkEx6?=
 =?us-ascii?Q?T8uxC7Q4w+LN2+7rmLlQJXfdzkM1/kqF3PnX6L9gzFa9ifbq73JtvmfGHuG+?=
 =?us-ascii?Q?w0vB8GaU0AqSt8P5orjRNXmrghF4c6YSs5ZEH0Ih9tXRIk7yrm3Iy398BbkP?=
 =?us-ascii?Q?rm2iNsuQOTpwAYx8fGvK3ZdlzUlXJgvh5r6E6twb4RdDJ5WHPhx/PnoOfdlV?=
 =?us-ascii?Q?AcIHXYh3ZJ6dtuaE3E/4pvDBBq7wpbqTmoC4vhDpqM+hAcZmqx1gl4ihWIti?=
 =?us-ascii?Q?rCIesIqUhykV78rnFUzMuno1qa4wUYyiJD9QymRTTcqeVZk3C47UOVCwYrp4?=
 =?us-ascii?Q?S2H113xydv7O6qp6xz5fhJlnMDOXyY6qSyUiWhnU4K5+CwtwUjwWzrW17pmA?=
 =?us-ascii?Q?U8TRN5M5B6G689n95TV5JY9kwx8R0jNhbEizkW0YcQP4LbiXqCGZKo43g4eb?=
 =?us-ascii?Q?CMC9jYXRfy63GYAMATJkwbrJLVEHOp4tfKYUfYH6NQb+SrMEPykXHOJdzZNo?=
 =?us-ascii?Q?B/P0vwFyQ5iqxT5CjUbtpG/fgkl0lb4G9gGfNU1nmgu0Cwpgv5ji/dSXVMaj?=
 =?us-ascii?Q?uo6B0GsuhEFeSiwguwmGUfSkNkdDMLpAZhvsYVuo3z0KfjfnVsbK+L3dlsEo?=
 =?us-ascii?Q?OomPAZs5OaUJJNk5+U3pS9m0btdAAqTjwmZXl++Cg27ncS6/2wIAFt6PbY/n?=
 =?us-ascii?Q?F7Fx0NYeylBTela6M7hwHiwGQPLfvctGA2ZvkQa0aUL5goV3RYltNmLUtJ/Z?=
 =?us-ascii?Q?TrjNvlmd22B3IurYIstJBGhnY8NW/X9vpon5+iW94/jjtr86cKlaB+5krdpn?=
 =?us-ascii?Q?+pooYSMMvzDBEkHruMGB4sXSH5K/c9dsEtBLGr5erFp7hglk2m2MjeE7kfFR?=
 =?us-ascii?Q?H1d0EdSlDGtktCKQxbBkYyUHogMd6wbOuG0WnUCCATSaTy/YSYTgBs+kkJFB?=
 =?us-ascii?Q?D4oI8ulFdxZMI3v5VYwMaT5JH7o+8bb+kd42AvSDRP6qlCjFklC52ENxfD1l?=
 =?us-ascii?Q?BsCB/d3mvLrMgwy2OJhJlN0iTm6cJOZpKcHVLnVcC1sqkb7KFJukVwSCyyB9?=
 =?us-ascii?Q?6Nr2R0GimgpKCeoQKQrMr8mQjFWnnAzTTEPGkCt62JaG7t8/PibpdZUaHkd4?=
 =?us-ascii?Q?PgBzVL+QnAchSPwnRpiN+sTWmE6Z2BDwH+VoPLEBmELWrVWmiZBJATUa84py?=
 =?us-ascii?Q?v4aA4kA9E+giCrJALADV/5BwgRS8M70iimC6/X+wc9jlc3DBkbRxIUL5lg5h?=
 =?us-ascii?Q?3WCwJjNwoHkJJ85yJUvDBci2nSx/4nxyoGFvYNoXt/t6vqNIgy/APsZ+1qp8?=
 =?us-ascii?Q?OS4TS/WiDniRD1zBwdeOcCPalIlCJy77dp6NTUEJP6FgVKqRjaBgUc8zklrI?=
 =?us-ascii?Q?F6ULO5LS58Kkuq0JsPNoNMf/oUowtS6TC02w8IJMUljII12e4HK2bwIsNUr1?=
 =?us-ascii?Q?iwsVc9VTQISK7nQBnWnlJg0ip1TqZWiY3lhBqIeEe6ksK12Q0mXeK5I42P8N?=
 =?us-ascii?Q?H51M5g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d525d2-4f2b-415a-34bc-08db347d3f51
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 19:54:34.3896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZJSKL1mLVqeLhmAIq8ku81FHfmCpmMq6F175IDciGBq6RQNKFLmwu5Hz1wSeJGKuDiOaHyd0z2aLXbO5J9Gt3HI7BW2oqlenOmNOKJ6f3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4787
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 09:35:46PM +0200, Heiner Kallweit wrote:
> Enable EDPD PHY tunable support for the G12A internal PHY, reusing the
> recently added tunable support in the smsc driver.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

