Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2128B52535E
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 19:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356744AbiELRRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 13:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346013AbiELRRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 13:17:19 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A688266041;
        Thu, 12 May 2022 10:17:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBO7szdfKU5fu1WI3S/pipslelbCfjBSF810b/nhkbPKATv6YC1vbrHynccRRfvflDEzyHtd3p4YUblLhSSYVAT0lUA1bnAMHuJv7uOhD6D8h7Q5BStuyauZz3RKH1/2OT471ef8ne75SRKX4MRHKsDALHBvsBlemUrYgeFECMEafnxEpz2NwACHRqZ/qrT53iDqPwlVePXzX9unBzLQqMZHHN3fTuYLoGx1lb0ZkVz54LpXo8XdIN1B1W4uH9FV4qxMNIi5ouFINghf5h34cjlk82v13Sv9FirXgaMlFVDhAFmqFiVEUXoAvo9hicM7ncK36V0NnMtOtgg0rsZGhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oQpYRO1+6eFq0KppbJfNxPGOqDRB8zRvxncEAqpl1Wc=;
 b=lWvPi+1s7vHmtzMLG47od8dIlpfvSTKXINn7aMbgULHq5zuDffjBLvWq/tVv5E+Lpr47vbvbE05JqW9UxvtXWgSnvQmSmzsCRP3QMMqJZ5TkvUCSM/SxBc9Jxr2hWTpozNKHGLVYqPKBsL1Ft96LzusnMKSySO/SkDJjGBUd6g5EA7tZx/kr3h4Mz+CYV2lbS7amAa/aS8tIcA6L4IziY0val98YusjcosIZxnrAyJTMkpA3vcKTg+K4T2g7SdFHPBkLrZyVqrfL9+eNQI+vt8KCg7EfDQ8/KDI3AQg5fHWMSgklaG8T02dYObM7VB4Thw7H3ve3nnDzd0BHf3TmMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oQpYRO1+6eFq0KppbJfNxPGOqDRB8zRvxncEAqpl1Wc=;
 b=gQ4ja7fE+BYWfCJ36Jni1QjGkCAgLTxelDV+RSpJ2p3FW05e70bw3xQypjPJWswdCljvZ0MfOk25S8KHwom8z6qvB1YQN2tX25hTKnbpyFDuj7jR98UX109j5a773jelQdZBLLDwBkoAUDSvwUHzXVspOtogYQIzUhPF5r0ny409bunHqWbyCaKVooKOzySbpy50RrVw8TxeA4fI1q0WUc9XfxIlTThggiU6jrZvdjnKouygTmCQSPhNgCkce9ldvld778+InkKsfGao8JWmxrz7eLsfKbrVVwvJuKh9hJ2pezFQQ89AjpM2r800w3tv7S7Qj4cRGM8/s239QG38gg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by CY4PR1201MB2548.namprd12.prod.outlook.com (2603:10b6:903:d8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Thu, 12 May
 2022 17:17:17 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::ede1:a4f9:5bf5:c3a0]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::ede1:a4f9:5bf5:c3a0%4]) with mapi id 15.20.5250.013; Thu, 12 May 2022
 17:17:17 +0000
Message-ID: <c6b41db9-78e7-e752-3945-29c70a3d8cb4@nvidia.com>
Date:   Thu, 12 May 2022 10:17:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v7 2/2] net: vxlan: Add extack support to
 vxlan_fdb_delete
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>,
        netdev@vger.kernel.org, outreachy@lists.linux.dev,
        jdenham@redhat.com, sbrivio@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, pabeni@redhat.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, shshaikh@marvell.com,
        manishc@marvell.com, razor@blackwall.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, GR-Linux-NIC-Dev@marvell.com,
        bridge@lists.linux-foundation.org
References: <cover.1652348961.git.eng.alaamohamedsoliman.am@gmail.com>
 <c6069fb695b25dc2f33e8017023ddd47c58caa8d.1652348962.git.eng.alaamohamedsoliman.am@gmail.com>
 <c5ec2677-3047-8a70-9769-d48a79703220@nvidia.com>
 <20220512094743.79f36d81@kernel.org>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220512094743.79f36d81@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::26) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 856180d5-008f-45c1-61b0-08da343b43a6
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2548:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB25487EC63266AA8C6AC301AECBCB9@CY4PR1201MB2548.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2tQxQEYHHhtTm6o/Dku8cYewN8aZes/M6x5FVbSaGcm1Ux52173yRYtWowopuoQPDckGt9oa6kKny1pSnXjPryuEYZmROX/uRpHWmJW6IXCPXyXvMnj5/rQi0B2z52hZmKSCH4o2qFFp93xf3oBQBabtKwdXfgdm96M66ZOwYuytN9koXPrZDJePRzoogGboGpOgJb+fO+ZmNmbDzVJKQxX/inxVd+mjit7qjzHuzdDcXqjeAD7KsdqpACbfcWMilVQf0/gz2JystP4fz9sNgLVSvCXri2KcEi5hhtJoaSSmT6m4qIVikuJmxyc5rNI2ViRVdkt9JiyEkfwlk0kgYpi6j9vY4PrcQULdj6E8bwvMubPq46N7HLyNHeSjjJN6Zuu5WvmnJ2hPG6KwWfK8QhYk/9p7QFfRSaZFwV/YNZXMEw2+Wx2VgTbNqvOOM2tjQvNKWHulV/xcwZTLxniLhhnoN5GLQMK/o6Sx2yRuGtOdMb3yLG9khx62fvcEhZa0d0zikLU4WvoErVO9Cf1UrqMdHnE2zP2fuacNDmguLC3u6jrMTPtFBlvn1imHkT6tkrpMa+pBepNd8a8peQazzK7y94c31S2E8zmLOlquvXj8+9UAFJrwF7BWR3vGW+QLUKycW8uwdmx5K+FYxI94vf0gaE/un5cqbxnhB7kxc9cOhsZgcsljleiMHxz1dL/aASi4W7+V2kZB7mDeOoi0K+CQGWcpXMciIKnW3EWD4/cWJ9ebv2EhVzJaLwgMZJkeowdn3Y3PWfJoSYEmKy3CS1tOGHYO2KErUM1JyIAE785S7JEUcpQRd0hOimrXVHdR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31686004)(7416002)(36756003)(508600001)(38100700002)(8936002)(4326008)(8676002)(66556008)(66476007)(66946007)(2906002)(6666004)(316002)(6512007)(26005)(6486002)(5660300002)(83380400001)(966005)(2616005)(86362001)(6506007)(53546011)(4744005)(31696002)(6916009)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWRqMlc3RytWWlBvZUlaUk5oT2FUMTE0WnFyNFRqdlJraEVrQkd2c1lMdjVT?=
 =?utf-8?B?ekxMTjJxQjIrd01zMXA1dGtTZ1VjMGhVOUxJSFRERXcrL0hCbU5BOFByY0xQ?=
 =?utf-8?B?NnVBMm1ycmh4VlhDTE1TZnJyRS9sdmRITnZ4QUt5U3lXYlRFUnhyZ2R2YUhS?=
 =?utf-8?B?OVpCL1ByL1VOY0h5RHZQU05oS3pVWEdVM3BOajhTMmtOK3RNZGUzRk8xUG9L?=
 =?utf-8?B?L0NFVzJ6clJ0ZTMxME8rRjJuLy9YN1I5aUwwMlZGRkE4eVdBSDJEU2NiTTVS?=
 =?utf-8?B?dUIvb1VXSmk0aTVYVDUwaU5MdGpGVng4RFFJQXdyUGdaV0ZJZThRcmV3YjJV?=
 =?utf-8?B?SGNJdnM4NGk2MGwybjQrT3BpM1BOVzZlRWQxdHdKdFNWUXZGNFgyVHplRWI5?=
 =?utf-8?B?dVMxMEJ6aEdiM1dvS2FGS21aNjBvbGV4UmhpT2phdzRJS1dUd2JIU2kyOG56?=
 =?utf-8?B?c29CUnN3Q2EwM2pzNW1uSTdYeWRLVDJ0bEIzVFp3UURzY0RHNlJQalN2Mzl4?=
 =?utf-8?B?disvQzJzcEFCOEdpSDhaWFVnYjNDSnMwSXFwR0hydGtueGNNaFY0VXVFRm80?=
 =?utf-8?B?YnplVXpySFFMdkJpa3RTN21yNWIzQ3JRM3hLckFiSVFwYXh2T0ExSFNveGZK?=
 =?utf-8?B?N2tKYkswVHk5NmRxZ1ZYemE2MnNyTHo1RnVyNm4zb1hkUzh0c2piU3lLalRR?=
 =?utf-8?B?c24xZUVRWDZKZzRBOTh3MnlSUUhwWkx2WG5wWi90UHNHckF0SEowYldBVy9Y?=
 =?utf-8?B?dWtmc2hlTnpyeGRuUHZSOTdnQ3BYRHFHcThZSUZxeTRvTk1XMlJibzFKR0U3?=
 =?utf-8?B?NGpYLzZjR3JHTkpFUFc4aEJESS9HU2NvcS94a2w4NkppM200c2dYaWppbzVE?=
 =?utf-8?B?dlMvVFZ0cEVZbWFPNjQzNG92N1BVSXJFdlRkV0VFMklQTEtqMnlOdjUzNW1R?=
 =?utf-8?B?UDl5b1lIWE83bWVmUFMxRm1HUEYzL3hZU2FWczZlSE95QkNIdTk5aHRKZzZU?=
 =?utf-8?B?SERxUUwxSTJDUEFUblJXQmpRYXFxdTg4YlJGS3F1S05waTIzaVBWTGhwNDBk?=
 =?utf-8?B?TlJPN3hML0NwRGF3VDJLVmpPSThpaUVYVlduK3l4NEFIZEVHclc2ZHd4eEtJ?=
 =?utf-8?B?N0o5TGpEbGo1ZkZJWkZMUzBPZmpWc0pIMndjN2VUTDNPUDM5TnBLYmFoNkZW?=
 =?utf-8?B?N25XaUNZb1lXSnl6RlZTVnFZb0phbFcwNHhHZFdQeFp2SFo4bmcyb01vN2tM?=
 =?utf-8?B?R1pTUUpBdzJ5amZod2FZTmc1Yy91bzlod3lteUZndEhqR1lJT1B1Sll3KzdP?=
 =?utf-8?B?M1hvUVpNb0NiMXZyeWw2aGxaYnZzQ3hHYngyRURzU0FETGtQc0pWaFlDZGlk?=
 =?utf-8?B?aTc4REVyc1d1aU1uK25jaXdZa2VsbSs5TmdrL05VVkgwUWkrNWFERGoxNUNm?=
 =?utf-8?B?WHh5Wi9tWU5xNFNjYmZRbmEzQ1R1a0lNOHM0cGd1Q2w0SEUwUEhoL1lHaUhK?=
 =?utf-8?B?TGxNOW5kY0labEtwZ090WTEzRlQ4TjZ6cFcvcmlYOSs1VGNzQi94by9vdmFk?=
 =?utf-8?B?SmUvaW9xcXVzNkNjb1d0WkdyOERycGtFZGd5SEJHUjF4M0JvZzlrVWFocUk1?=
 =?utf-8?B?NnlyRVFRNlNRbUFJWUR3YytTNkxjLzcxWjZlYzU4SnNSdVlxQnRMTWVDbDU0?=
 =?utf-8?B?ZDdtWDgzN1NwVUh6RWVKdmtiNjVqNitxR2Zod3pOanpJSGNhSzdKdWkyMFMy?=
 =?utf-8?B?ZGpKOVgwR1o2YXZQS3kvdnk3Ri9NckpVcUpDM0lBZVRDUjVkczJMclhVeXNC?=
 =?utf-8?B?NmlUYVVUQUdVVHhQd0paVGJHTUNjNjJwWkt3NDllMzNIUitOZ1ZCalpvMEJZ?=
 =?utf-8?B?Mk9ta3VTZlcveFg5dmZPdmdkZ1Y3UFlsWCsza1E4RC9PVWFMU2JxV2F2ODdv?=
 =?utf-8?B?eHRjeTdwK1NGVFBuZTZ4aEl3c3BQWjExWkVKcElNaXVyWDRtVTNybXQxY2FH?=
 =?utf-8?B?aGE5d2ZSWjBHUTBra0d4bnRBZFNrK2RybWJ0ZUJFd1czTUd4SDJtOXh4WFRi?=
 =?utf-8?B?R1JncG9zdXFxOERkSDFMTURMUDgxVXExZytHd0duQXpWVi9SWkZ2TnNzZ0JB?=
 =?utf-8?B?cFZIdnlac0NHV0hscnVyNmQ0cmlMQUNuTTNTUUl6UkZSTkZXaFpSR2dPaGdx?=
 =?utf-8?B?dmUvb3hqVVJmalo0UDcrV1pZcHArK0U5cVFETm9GaXlxQm5RWnJtbXNjaTRh?=
 =?utf-8?B?Nk9qcDlvZm9SWEhmS2ZKVEN4V2wvc0dGTHgzUHk0QkYrLzhLYTZBVUpaTVpN?=
 =?utf-8?B?Y3Fwd05NMDdJZWJXQ0JYVFJXNFEyajBLU3RGbk9pbmoxajFsQW1kQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 856180d5-008f-45c1-61b0-08da343b43a6
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 17:17:16.9976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ElsBEOHJx4V6Pm0eEpLDs1/A6A01hTzFgo8jveDxIV4VMHBYFJU01jWdadUdCq1VFr4WZH2Ygvrc73sUM3cGgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2548
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/12/22 09:47, Jakub Kicinski wrote:
> On Thu, 12 May 2022 09:22:17 -0700 Roopa Prabhu wrote:
>> On 5/12/22 02:55, Alaa Mohamed wrote:
>>> This patch adds extack msg support to vxlan_fdb_delete and vxlan_fdb_parse.
>>> extack is used to propagate meaningful error msgs to the user of vxlan
>>> fdb netlink api
>>>
>>> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
> Also the patches don't apply to net-next, again.

that's probably because the patches were already applied. Ido just told 
me abt it also

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=5dd6da25255a9d64622c693b99d7668da939a980

I have requested Alaa send an incremental fix (offline).

thanks

