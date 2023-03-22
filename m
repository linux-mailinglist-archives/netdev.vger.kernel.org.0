Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37576C4926
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 12:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjCVL0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 07:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbjCVL0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 07:26:41 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2090.outbound.protection.outlook.com [40.107.101.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E88B62B44
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 04:26:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gheckg+dH76VM1b6odKjszfFve0ClGgRrZ2KdIcV/8ZOPfEjwaqmPG+AETYgaT2geia4V/JIO0X/ER9hTam9wP2sv+a6r3D8tPJX5e/VwLI3b5yGsu8ER/iZ3/qqrcYrzQGahSOnpnsorsppk3V6ku/xR3U8XRdg1odkiKicHuH5qjUXfhI3jo9dL2JyVwpaGNfeU2HqS3ZUpKU8KbrARS8Ocw5jCVGkJdLIkEzaVSWu6iUb28TcbYhzfrELpmLC2syuPxlIIljzQWJuaXrjlwnzXBxksHuVdVcRZuZYOQCrL7iC/8OD1lB4IJVhp18qKx3rtoOtWlMt9KM9xTtmww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hmB03P0KEypGC8juG8VvbfyjsYxri+326vqg6eLIyIM=;
 b=XdCdTLw4IalAN4SDDYUMX+6IhU8g498LPVmcWkGO+PuRC8uk9KasfRzjpTN9FUg5DiMz+9mjPKE6jxC7H41qnh4cxmDy7OkvJZLvpY+z6js4txJrn2WssQHNcOE/+b2uAP/laCSrgLdYqZ6rwlIVFAHoTL/5T/yyHksbHVbq7XJsKPeMb9TvKeTqKxfuEZjqfWH787zoCBhXkg1SWnzpcYF7ayYRpK9wzdkaSaJziaNuJXLyalKrO2SPF6U63CXh7RZnx2jDmQfv5OXD8yptqN8qyKg7gJNpEEBRITZQl1s07HDlNRwatyNYa+CYAKMdYlOBp7MJFXSFHllSoGQFiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmB03P0KEypGC8juG8VvbfyjsYxri+326vqg6eLIyIM=;
 b=lD4TMNvJYPQgv8v9iAfTGxbsg7l4Af5UjFajIFtH4dAj2VdKTgZ+tEpwyeY2riN9SYpQhTO/v6Bw7PYL1YuZH2Tmk8rsNEO7JjfnBmsDdGI10lClAQgBt3l4UmzIo989nclBCaFaMcdM3h9+uWq3RvHZQLy8fUgQM1D6sUdI3Uk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB3948.namprd13.prod.outlook.com (2603:10b6:303:2e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 11:26:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 11:26:34 +0000
Date:   Wed, 22 Mar 2023 12:26:28 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 3/3] net/sched: remove two skb_mac_header() uses
Message-ID: <ZBrl5JOHjxC+wsUz@corigine.com>
References: <20230321164519.1286357-1-edumazet@google.com>
 <20230321164519.1286357-4-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321164519.1286357-4-edumazet@google.com>
X-ClientProxiedBy: AS4PR09CA0012.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB3948:EE_
X-MS-Office365-Filtering-Correlation-Id: 4893d33d-8b40-445e-2256-08db2ac84b26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ET6Hz2m9Rc6XstYIOarpKU27RVU6HO1M+x46relUMiHaLKVraeNWI/632MCYuDHmw9yZNU4dIx3u7HtqJbM7DVWxL9tntBNh9uplmQEkF+Ba5+NZ/lsFjErePSBNbe7GtIRzem500ad5tFI2ohPqx89VubzcshEDGf+zFrSyzg7lQ+rwkZYPSolGB2JVCtoSn2F4BNUA6/f90RnniNBSZxHlfFi8GLkqtZnBRC83eVJX/rPMvPgjc8hl6YRcNqX2pBudBlBRFfvDW5AGHwcwrki+qqzNmX5kzyb+t+OGQW6AB+pm+g/B01uFZD/DqfNPpeHEs4qv+01lj55TEBVTbDBmzbl8r6+Rx8Jh7aU86Sxlt9IFTBnHnKRk+N2Qd068NWKp50kzaFMyC0/TP7GVZ5d3bqwRuRYJcQkbrWm7sApQt1uQZ4OxjHVJRAl1c0AeHwHUv9TPsatgzF2VCWW3fGXVNxlC85PRk07pcCNfzr77yRExVPywn3WSM6E7euN2tET5XWhig6Zjpy+5iuVowbyPROpNoCzA+Ojv43d7k2ofO3Lbr5ftzbhltSYAd6djOnRv8qY78DFKHGleNaZAgjQvFNN9qPwbYCdT916LUw9t0zgeFCuwjOunwi5Pe6bY3z475rI1QylZdXmOY1yDxzmK3CbJuQcjh59fLyugYkW1CKCO2HjtaMTegMfmmO1MSk7A5Gg/rQXKXk/0tXtNxGOlu4NharhNxJXIIXcowE+MW7K+TzweC/SJEXfoubb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39840400004)(136003)(346002)(396003)(451199018)(478600001)(186003)(86362001)(5660300002)(6666004)(6512007)(6506007)(2906002)(66946007)(66476007)(6916009)(66556008)(54906003)(4326008)(41300700001)(316002)(8676002)(6486002)(36756003)(2616005)(38100700002)(44832011)(8936002)(558084003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r1y54PQn6FXb+MRVKz/xsz2Aedqc/ZlA4eV4vbT9BE5IjL5uHIru4yTkpfDG?=
 =?us-ascii?Q?012I2GD6s7ig9kP+oc2Ve+N8xGpo0Km2Oi7DGs0aSI7mQ/KMEYLTKlneaq8W?=
 =?us-ascii?Q?9YiRxKB5VG3CvLqzV218UCQjx3Tv0tN/5oTmKAaLIMq/9WyUoP1auYEf7aJD?=
 =?us-ascii?Q?EnT93xs4/5lkesyh5R4Ikxr690TT1fvXi0wXCOtR3NkXWa+4mxIU52I54E73?=
 =?us-ascii?Q?uIn7K2w5FHJo75kO5+T5tcP2BMmakWepGJXhFluTbD/3h6woeW4sqsULHSJx?=
 =?us-ascii?Q?pR+7k25SgJGP9fFcjFbk47Sj3GKMQVLKqiH1IfH9w6gYQvCVtg/HGA5sL68+?=
 =?us-ascii?Q?4vNlNrz9k1dgjRNYGXiMcGI3G/dmIZqSGNp49boqrclOOwNwifLgIJY3kYit?=
 =?us-ascii?Q?3uHeEQe+ED33aZQhjcABSS5g5+Hb/Xu/jY/H6Zu3rz5e1bk2gaD00UokMtTn?=
 =?us-ascii?Q?7sTrB2b40ZqCpvk9HhWrUz87gC3KfrmJ8IEL7s0OEmXmmGiR3cuUM/01IyBX?=
 =?us-ascii?Q?qAZj2OsMSBPzJ2tnYEoxtsqJiqlPN+1WQh1gYXKiVSytid/95cQcDrw2BBOJ?=
 =?us-ascii?Q?evriMm55M8kdIP39wWQ/WMFft6rrs61AW0UAvL2U8Y9ZNOkKas9V/JTswVOe?=
 =?us-ascii?Q?MJ0Wi/ParVHl3R9cOZX4Id9a7AgrjFnzsQZgWAWl4+GA55srBtPgHsUWMxms?=
 =?us-ascii?Q?qhLDTbHZDG/0k/+Oyhm5XfT0pOoS2ota5Yv6Dl2cM5n9Jp2XRRhJjnRv4PgS?=
 =?us-ascii?Q?weEmGegB9Qx8L7n+EQql/VWx7v2JevjHln4ETNJkyshI7TcC3BqFsKpQ1HiH?=
 =?us-ascii?Q?agpKlxEro8NzJ+9LeVRsF2SbVKWyMpvsb5Lb+SBGZU8jlI/fhNBSH8x5OaI8?=
 =?us-ascii?Q?tzdZvy6oTAgcuTffOxtRvSzK+Ek/NOZlNeQ45J7x8JACVl/k8e7UNSD7r86L?=
 =?us-ascii?Q?4D5PKhe2iGZtHTBErrBI7T6HwRJWrFJ4qIc5BRRQyh2Of+siNn8tPaR0sha6?=
 =?us-ascii?Q?374kqW1/WyqTrdp0aNUS+PCxLWcLlEeER4cDbh2YwQuTxaFfBe5dj2Lobl22?=
 =?us-ascii?Q?2zMc7K8QJl9s/5RMlTeRvYAudeVQiQgZGC6iVsKVX/qpUOEFFiKar9gynfIF?=
 =?us-ascii?Q?o4CdadR9Eekxfbhtdt6nKf8oKaWM9nPGdJLn+Vo10tEF2/PU7u565YBaf9Y/?=
 =?us-ascii?Q?nU/woPpyBhqSdWUHKhOVmM3NS6i9E5K0KZHVEchjLjaC7TCeGR1JbrRoIRsA?=
 =?us-ascii?Q?ROBOmx9s2wyaH+G8aEqVb1fLu5Mu9XWbBfz03l3urgAHol0lzVH7pD+fj68x?=
 =?us-ascii?Q?r/Ks1QOMiyWxGH6xHul8cI1mI8KV8WDbMQUD90WpSsvYwFmJ4lcFr+VuIJuj?=
 =?us-ascii?Q?ojOkmq27EzWBz7Zihax/iyXtyRopKGO/lNH7OH5cbyeZ665cRu/OBNsmv28w?=
 =?us-ascii?Q?2B2E0vPsqS2NdtD9n5oP04RbIB6Ta15KoJAycfpirM0iZUAExoWGCEAN4nfI?=
 =?us-ascii?Q?HKfFQY+eS1rqHMkOWo8Yrg1LZr/QpFlsIHhNrx7B9oQ58LfZv9czK4N4ubGc?=
 =?us-ascii?Q?8PJX+N+JheFqvQRxRNr+GvzABjCsZWNIyjHzDSqCAzrpk0FwNhitWO/Crj90?=
 =?us-ascii?Q?KHFyfxqgPZXAwUFHSOFZmeBMsT1n4L6gxf3Difr+8R1jb1U4sKKT4j3M0K//?=
 =?us-ascii?Q?RDwMyw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4893d33d-8b40-445e-2256-08db2ac84b26
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 11:26:34.6779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z/EA6wShXk+2nMPQUQw0hDUx0u5MaeK/ri3s+BfZajoZUrRe+ENQJ0obqNadvF/Q9Eo1ANjb3WHRCe2map21O3nRxu0WzVwwRgBMHHFN/6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB3948
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 04:45:19PM +0000, Eric Dumazet wrote:
> tcf_mirred_act() and tcf_mpls_act() can use skb_network_offset()
> instead of relying on skb_mac_header().
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

