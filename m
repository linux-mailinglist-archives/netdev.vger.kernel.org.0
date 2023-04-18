Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021B36E61FC
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 14:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbjDRM3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 08:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbjDRM2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 08:28:54 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2109.outbound.protection.outlook.com [40.107.220.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5600CC65C;
        Tue, 18 Apr 2023 05:28:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXUWjQD7Cq5EPOl4K/CP7IOG/RgOUsIJROu11wLx0vd2q22vYvu5IHSrybqwCx+dzp9tJ++Miae8bk2rMQmsnGyhS2D5sMQBZgn/DFx2ZELKFDPLBWjxT2cd20U/lqIg0dSEN0CdriI0fL34AmbiqDbYtZdtt/xNf1CtsCVtHVfr5ZKvcozyEyY9SjRoXtWm+87yOMk7d8tAkR+KVz/BradxtjTk832pvLseyQ04EXL3uIiYK/2OI3IpfSkb7OPr0aRCChOQQdTVAukM2BHU5Vq6S29AxtJaBkn/iLGeNPqpNpRB0kH9b/ewd5J+16t3b+JjQ4anfH55AzzffFNlNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVTQcAxoo3HkYDbiLygUdyD0IC6qk5+7RXVQxRaT9i8=;
 b=MitjotzvM8cnM3EalDdW1jKg2e1vP0AO38wSvR7vzYpZAHNwXIRU8XbbnAVrVVwPFSEwrLlRmlLZLF6u/zP4GdrTS2U6Dz1P08RiCsbzWX7iut0QiSKUBLvJAYztgYOQzUvP5khpvY9cLHBGsXfdmvOlo6/oAWFMWFu7j6Tsb/JHYL2uMOZzfRF9Asyi4ii+23SRAtJ2cZDsL94dAZVydgp+3me8nBqJOW5B5kmMIkdctWy47TOurqxwUSvxpLS9P3jItUVhWakVFszfJXqpQ1t6se5AyKxq9bKBxWwyGvrRSFFQKmr++F0/OLyUbOBATzag9/J39qpNPTovdV8lTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVTQcAxoo3HkYDbiLygUdyD0IC6qk5+7RXVQxRaT9i8=;
 b=crcYj9teFGO1R+FZBiqBvoo/U9lYiZRtoZsfLap8vIFILbUNMQJk+l6k5XJq0/kzfK+1ushubHKoKqYE5y9DCVimPsuwW6fxqzwQgtMeU7RE72Jr71pp989a/5AR8zXkoPPDumm/7BKSB9ErRUNvYkVIDZNXMSIBaYznXNUufZs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5790.namprd13.prod.outlook.com (2603:10b6:806:219::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 12:28:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 12:28:25 +0000
Date:   Tue, 18 Apr 2023 14:28:16 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <error27@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/6] crypto: api - Add crypto_clone_tfm
Message-ID: <ZD6M4DHz0e9Ag3XU@corigine.com>
References: <ZDefxOq6Ax0JeTRH@gondor.apana.org.au>
 <E1pmqNV-00FNVI-Fs@formenos.hmeau.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pmqNV-00FNVI-Fs@formenos.hmeau.com>
X-ClientProxiedBy: AM4PR0302CA0029.eurprd03.prod.outlook.com
 (2603:10a6:205:2::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5790:EE_
X-MS-Office365-Filtering-Correlation-Id: b629d65f-feb7-47cf-a81d-08db400867c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ucjnzbjENEI6yAyd1pmW0NfoZzsp0pB1+OVPpdE+mvL+4h47CvLWZdUVxcUV/rM4+f8s8qsEEZY8ukcbsNryu93Y4bonSJi1PtbFJSs0HO4aktYP0VplphS7V/xpKQPK5WE72AbVvh0n5kXQYIAH7nSIRfPdUBxsq2J+AUP18Y0Ik64HPFrNIl+3ZKDtlrKB0K+TJFNF9VkLD+EJdfwFiAAngMXdTrDYX1E4m4ToSa+tolyagC3oqApUEyaklPK8it3NWy1GqB1lD+dxEXnj+hejFABBtbCL5m1kpSr9jUoO52t0eaSuQdlegZ1T4H3RUvrqA0oN+4giKs4Hq9jXS3h1rip8qluEjaMKQ0R+DXq2PXagSAlnv7rAwREpMn2P9zC7Ds/fqisUW5sDiHubFuZGKSfzX+KvxFLnLNrvkP8nu8I9v8aR0UNmCr6YpGh4iiSr836t9bfPn0FNNdEmT7Tt+uya1t5YSOv8bWeakL17wzfoot6I1ddFH6Cvl7v6ixSqpMGOw2KmXufX2fC+LCDr7K7KcFC2TdbLyU2byppMsTIqBTMsVxZczS8mEJd2gkpT89jXh5yW/O94lgYIcu6AvmW8VW9/gezmVqwf2I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(39840400004)(376002)(451199021)(7416002)(5660300002)(44832011)(86362001)(2616005)(6512007)(186003)(6506007)(38100700002)(8676002)(8936002)(478600001)(54906003)(6486002)(6666004)(316002)(41300700001)(36756003)(66476007)(66556008)(4326008)(6916009)(66946007)(2906002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tpXIBdeqzNK9/YecKZlf+7J7PfY7uFv0pUOn50n7O6Cjj5mjgQLCpoJMz+Wq?=
 =?us-ascii?Q?wyYHVB3qqmItCyHEc8dr5OyPJ5mFRUoiNuGLBhNTZVIYkV09DAo5UO8HAtje?=
 =?us-ascii?Q?nugSJCsdusOv8NlQla4XgdLy1iapq0zwd7kw1ZZXyEtHCz4R2fcaNObVQ+Cn?=
 =?us-ascii?Q?2fn987YIHw1ooXY0wJ98Q6LhFidDSMvQZWCzX1+v8fhSBu9uGseCh2FUXFwv?=
 =?us-ascii?Q?r372Tp8x2pSOBHys4Sm1Z0SqtJK5cTZF1oeWQJonX7H40/5H76SHyRWZif2p?=
 =?us-ascii?Q?EMDkMHwCmqEfhjy8+SlR1FQ0H1L70fu4oiA76bu2Ra2Blft54M5moM9Sqt5V?=
 =?us-ascii?Q?NggKSQ7AxHtgW2QR9p9SrxVCuTEEjrKaWD/C/N24NMCIVT9TZDAW32qL7jeQ?=
 =?us-ascii?Q?YZsfI/2qyO3FNejOeafUwpfF22qEW6lEIwPzmN/vbMWwD7B5HnvW3dgQOQQs?=
 =?us-ascii?Q?AmQGOsPzRelU5ojtH2bsa+yIJnOSBq7YtxRxibjEvc309Yy2MoSwSAfKkDNs?=
 =?us-ascii?Q?aFsHzOcoQs818YL9KY2w6EAkIes67sXra+SRlBYC07LtdZ2PuaLKfHn68UTj?=
 =?us-ascii?Q?GIEeVV5UyCnX/BiKq+URO1z15A2RjpFKNdQHoDg1AFdzHTZokNii0rrT+BOS?=
 =?us-ascii?Q?IfbO81BODl9prsdlvZhInr64rcIC/QQJeoBv2Gw/v9qF9gm5YOcV2YT3xAAk?=
 =?us-ascii?Q?0JJFAKVxtrLFsjZWo6jlk4mYxOvJsjh692YKf0NgUGnq3DqDT/Ec0gAGuj00?=
 =?us-ascii?Q?gXEc2LyToTbuWfP0RqLWOcjjQr2l+kJ7JYyRpxl+uYWPmbZz68z5YkZfyFMA?=
 =?us-ascii?Q?tVppmvt6ieq5nB0JmYpgmzP58X8wBEl8t+HzANK2pVr28+K/nMpecqcbWu4E?=
 =?us-ascii?Q?h1kwe4Xy18MoxDhBVgcXh9juWzGLSBtm7kVGg9UzjbmNZGA0VJ5/KRGtQAZc?=
 =?us-ascii?Q?QjeBRzFVcbh/HogSiqa3tZZr+cFsg7Fmeo5zKzgYCHUsV5UhsZjm2VGGLWgv?=
 =?us-ascii?Q?r+OpOzVYPOmgsZtf5gboWubAN6EBj85mnr+nnJoTmkdIJxlAUbL+96L24MU/?=
 =?us-ascii?Q?skr6KpPFOItlPlz1CjFo+cuv+AKRzOogGo3V716Wq2UEaZLKGXJ4AfWF6xrR?=
 =?us-ascii?Q?iBcZRRfooHfwawqfdpk/Typ20VRR5BsFp77sP/juCwTwqFVzJBRc6sKGnb/j?=
 =?us-ascii?Q?/PtWjMZnH0tUpmgj8UJ5CVqheXb4IRMTc++fDeV+j2qSXTBtEV+YDcIL/QBj?=
 =?us-ascii?Q?t83pLrZKf4yn8bqXNUi+WkfOyX2vWFWWB6dtpSnpiWLty9pfCCeLCtGYnAjj?=
 =?us-ascii?Q?DH4MLJe2xoi6hC4Z467I6RT33H1TXcmFDUDMwZp6Knq3e4TRu+vXnlOmTIL1?=
 =?us-ascii?Q?FCrLRSYXC/Imp3hJ1xLLHGX3MbablmeRODx3bX5K1ucrQKtmQ1yvGawnML8s?=
 =?us-ascii?Q?U9DDDfkDKvNd5jCJykrHpDgk5RICMdbFtRI/bx/ylsrbOzhecmK+67qlFXWK?=
 =?us-ascii?Q?5OgrH3DEbDUmOxn5goosn7MfEkYLdgVSGZSPKk30LlJwUB0rLkPsHrOBONO4?=
 =?us-ascii?Q?vUeEgOxkN4D4j9IwopCkna0Y7OCoK27Yf6S44UOeMQDxoAPoC5NzKE0x05GY?=
 =?us-ascii?Q?ua8ow/eii86pcTvEDDivO99etDub09ZHCXR6G1Iau/AZu1xF2t2AlCu/9teg?=
 =?us-ascii?Q?kBDuyQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b629d65f-feb7-47cf-a81d-08db400867c3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 12:28:25.0399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BvMS1tSARObhTPzGEl3qZ8Tgs9q3DQk2pnMQMbbXVvLQrg8Xht9SLB4dkebqDJivect3mz180uaKEvy6euKmCpFBLoJWfjpNMvGolsabNgw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5790
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 02:24:17PM +0800, Herbert Xu wrote:
> This patch adds the helper crypto_clone_tfm.  The purpose is to
> allocate a tfm object with GFP_ATOMIC.  As we cannot sleep, the
> object has to be cloned from an existing tfm object.
> 
> This allows code paths that cannot otherwise allocate a crypto_tfm
> object to do so.  Once a new tfm has been obtained its key could
> then be changed without impacting other users.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

