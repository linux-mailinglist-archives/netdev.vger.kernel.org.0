Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4FF6B0311
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 10:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjCHJi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 04:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjCHJi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 04:38:56 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2111.outbound.protection.outlook.com [40.107.243.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D62CA2F0A;
        Wed,  8 Mar 2023 01:38:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ILk7pDkLQvSif/0+znAOPsxcIAulTqlsq/a0efRlgcdmiCUXFOJPi98LFrKEsPEKNXkAiFD8KyhwVmcW17ks/ckwjdwR85T53OY1ssDLteUlxLElos0Ut1bGJcca8Lfv9DPCVuJUDSD/qh7Q8/0Nje1nua8ZxXbj/2r7Oc8WQPRCpE2u6G2jsjEzhCdOMg0e6HCgAyCkDX22s/X+yQupQI1QiiNOIgMTnRRinwIo/n2evRSrzyJyijS6YCTNuxoE4uQI5wsqtA62pklYwByTy+gqqcmbd159h95pjuuLT2IpFPLRCOPmXdW4YBDb95sjQheaR0vd/Es5KVT1WIZrCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ki0waFVjL66O/2Q48eer0CX+WaarIlrefGzuGwPw5oE=;
 b=BiT4GQYV3Fpvn9Uqh9PQPf83s2g1EazVldfxkcuoxqv4aVukHaDwV7RWVZVOa0zfBh/IpaoK6NZ+Prws9818JMu6GVwQDOPcuyTNoFNn20xhtrWwV9CNrl8MxhAs44ej0iyWjYW5QeUL6ZJvvtmoG8nLYQ4Cx3iXH9hz3DEg3gqD8T3Bcr6wEHz05NZIx5V18vHsorrZsZDOHaxny6iq5zu7S7nzqMeBIkBZ/euiBAKo+krMsXCi113W37oA+6WdcQyhILhzWNuBU0s+Q8E2d6n9Ep9QWDJp/3f9xI5miK4fOpI0NEwQIwM1VGg6DdCcBSxXosyEBIBxIlL+4tJ7Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ki0waFVjL66O/2Q48eer0CX+WaarIlrefGzuGwPw5oE=;
 b=OddCB8hc41soh1Uvv68Wj6nikXmYnag4TBgmKPt12aMOGSw62AYyqm3rLaKMnp3EKrz2zrH5g2n2/TMplhOuelWDRpEOhlVHqwLrDkMG7VhnX2t2XbgBwoPxGwfaP0fDP+/YHhNlS5256ZKbd/1nm+tYYPgInJrZIk4k6ZrEJOg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5114.namprd13.prod.outlook.com (2603:10b6:610:113::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 09:38:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 09:38:49 +0000
Date:   Wed, 8 Mar 2023 10:38:42 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Aleksandr Nogikh <nogikh@google.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        syzbot <syzbot+bd85b31816913a32e473@syzkaller.appspotmail.com>,
        alex.aring@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [wpan?] general protection fault in
 nl802154_trigger_scan
Message-ID: <ZAhXoqIIDSn+MzDL@corigine.com>
References: <000000000000adec0205f5ffcaf4@google.com>
 <ZAISIS/h9UV6Ox+r@corigine.com>
 <20230303164456.603c2ebd@xps-13>
 <CANp29Y6aaCVVg+3ezNzaw1nqvMbZhHooZ_DQRvv5YPbOmeprag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANp29Y6aaCVVg+3ezNzaw1nqvMbZhHooZ_DQRvv5YPbOmeprag@mail.gmail.com>
X-ClientProxiedBy: AM4PR07CA0008.eurprd07.prod.outlook.com
 (2603:10a6:205:1::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5114:EE_
X-MS-Office365-Filtering-Correlation-Id: 3be0a007-5f30-49e9-bf99-08db1fb8ebb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: doSeJFVqILkLb5GaTzLZB2uL+dwfFlewJGQSFhLEQkyDbDUoDklDaJj5XfbRvPsJEC0VWlXWfJTl2PlGOVm9xXMw5MkCrDS6BOmf0UvEmE8rm4CBHw/0g5dPcql/ZYuk/8qhX5KpZsE7tmGQkbJCEzKGWqFM3OEMkenOQmU2LfGRJ/dm5SWdyrqw/nZJDec1ADPfX6N42Qw2FRc8+6S+5zlX1tXA88ALMKCW5z4Oobx6oBi4uV+Hn4TDGXYYaMpCPOD4p1k8HKH7nLxoZ4f8/Cn36KivbmGaYKiEgUgg9kFv+DMgW5esFtIBWqqFSoevSAqHzhNgYC62aHDZqYcQCnnIyF6IY2/gsmXfgHiNh+mgvl8PYmuCib3VMhlVbIlDyCuqzq5ApviG47h/ughejS7R3ZcIbFoRugk2MH1LBrhAl+eXpS+HUvCTeRaSypjSZ0FOWCDov2CKzy2Xct+2CyKydteMIPG01np85l/OyYbrwMg29Qb1B1vC7xj/p6WwOzrLJ0kQwyURXtu5HteOAA+UvXtArnc842NjwYGJ0oNIrdLrfeeIJzLFrPTcxk/AdYyZULAVksiOtNv0Z5I2+u5aZheT+K78b8qwlkxbVS3arle8VV0yT8lzvgjsUjUzsmgKAqRLIgD08c8uuUwlluxnpNUGpLCqFLndSqw/Z1E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(396003)(346002)(366004)(376002)(451199018)(2906002)(2616005)(83380400001)(66574015)(44832011)(66946007)(4744005)(4326008)(7416002)(66556008)(66476007)(6916009)(5660300002)(186003)(6512007)(8676002)(36756003)(41300700001)(53546011)(8936002)(6666004)(38100700002)(6506007)(6486002)(54906003)(86362001)(478600001)(966005)(316002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3RURndncXdvcEJtS282OXA4UmJJL3BxYnlabWpuOGdYSWNqZ2tCczBHNENN?=
 =?utf-8?B?V1QzVkFXYkZZa3lIWkVNTmNWYk1UY255UlIxOHdDZTR5SEdXcmxpZHlxSitv?=
 =?utf-8?B?bDV6aWZoMDhUZno3U21ncHJ4Z2pqMXUzKzB0cnlmQjVNTzV1SHhublBLdm1Z?=
 =?utf-8?B?Mkc4OEZLNkhGZVpEeExNY0lGTjk1SXdVT09mVG9xYXJTQ2lpdk1iMlNxQWsz?=
 =?utf-8?B?ZEFIOENMTnp2THhYVGNQZEp3RHhyQ2prek9aV3JVNG5YbzFuWjhtYXkzZTM0?=
 =?utf-8?B?Wml0MVZMcFZTYWNVemdyZENrZjRGTFNCZmhKRXg1UXVjQVpPNDlWOElsSnBi?=
 =?utf-8?B?QWpWUTNicW9yUEd5dFFOaWxpQXl6RVhwYzB2eGFJWGx0SVlvbXRrNVR4eTdP?=
 =?utf-8?B?Q1ljVCtVeUlGUkJySmJyL2JZN0VoYWxmaFFwVVhDamlhejZrUi9lYXgrcVZR?=
 =?utf-8?B?ZFFNTGNYTU8zbnQ1Nkd0dit3SEFJZkdmb3hzUXlhWkY2K1I2RmtzNkVaTjVQ?=
 =?utf-8?B?Vys0cDhxSTIrby9sOG04RUdsa0d6QndqajkwZEhTM2FxaEQraG5ueGdFdmNk?=
 =?utf-8?B?ME9QTEpoZUM1VG9JRkRPRGc3bHJUeXFmaEpUQVJ2eUpCeVNITVJtbmdTUHVn?=
 =?utf-8?B?elUwbG9rMGxaQ3RJc1FSUkJKUFltNGRlZDhDdXJqK3R5UG84UHlmdkZDWmNm?=
 =?utf-8?B?Q1NleUEyamJ1N1JzV2xQcTlmMGlkckhhNU1MMDVyRXpOS2JWamlxUjc3bi9h?=
 =?utf-8?B?eXVwUmlHMWtLVTY2Q1orS2Y1ekZGenBXYjEwYzZJZlozYktBalRNZ0wxZjBi?=
 =?utf-8?B?cUpTbFIyNHZjeTA4Z2x5TWJxYXV6Vlhtc1VFUW45QjdIeXBCdVp0L0NVWW91?=
 =?utf-8?B?Uk9HVjlVdHNOVi95V3pjMFQ1dmdxWGNmZE1GL1NMSjVPL1R3aDZLU2xNQWlo?=
 =?utf-8?B?VmJNQTNvVXJ2U0pySytmdWFxVTZNM1FBZ044aGRaSExkdzI5cDdsKytRaitp?=
 =?utf-8?B?dXhHb3Jmb0xpNE42dHQ5bzl3MjNzOVpUU3VONjFuOC8wY1hrY0NHWWE4elJE?=
 =?utf-8?B?WTNuWEoxb2l1TGNmYlo3M09oY09RL0o5T1ZSNjBaOUpVQktkeWI4cUY0cHNX?=
 =?utf-8?B?czN6Y3M3SUw4YWl6S1N4dEVjOWpZckdUdzVScXRDbTV6R0FoODgvc3M4N0Y1?=
 =?utf-8?B?QXZtNUEvS21SQldDUnRrQ1RNZStqL25SWTBsTDM4STk2UERmQnZLSmR2anV2?=
 =?utf-8?B?M2dLVFozbXhueHlBUFR0aDlyN0FmVlZ1Z25rNi80c3ZDNUwzMXVOSUMwMzF4?=
 =?utf-8?B?V25McUdpL3A2K2pQUlo5dk50cnlqYXpTaWNpVHdJSmFhYXV5MTJrSER2TmxS?=
 =?utf-8?B?Qzd3eEljZ1NhaElFcFl5dVo3VElIN1dKbnA0VGlzOGFUcUU1OUZPZFEwWFRC?=
 =?utf-8?B?eFZDYUVKeHFOdlJNb1diZ0dCSHpCb2x5bUdLTG94aFMyZ290RjE1bmc2a2dK?=
 =?utf-8?B?N0M2QnJQb2VJVUpOVnV1Uld0cVBPVmFDTUxwU0hZOE4zZjJ0R3Z6MGFtRlVl?=
 =?utf-8?B?bis1R1hPalRJL1N2L2d6WG9JeGdDRlRyVTArREx4SHlFUkRoWVVLbFpIREgz?=
 =?utf-8?B?YU1rSXdRVTdCbmZhUHZnRTlsWVR5RDdwWEJJdmVTOVdYOCtCNnZ4cmJBM1VJ?=
 =?utf-8?B?cVNUMUs4TGdpblY1L2RsN1U1Ums2KzlnanJpaVNvU094UXF2d0t1Ny9ncEpW?=
 =?utf-8?B?aDhiVUdzTytNbzFCNis2dXRrQnhDWmoycDJvUjRZemJheGZKc2NVbVBGSHdo?=
 =?utf-8?B?NExnTHYvTng0SWVNcm9EZ01IV2FrL0pHTzZvNFhIbFlrU0VCOUpUcTN3a2Uw?=
 =?utf-8?B?T3VBTE0wd1hTRzl5MzNTMnZoL2FsUnVYSUl6V1NORVRjZk9Ccnh6OFlpUHh2?=
 =?utf-8?B?cjF0Ris5dDBOM0hzMXJGWUsyNkxLMS9uaUg3aWFKbnRtVUltenMra3FSam9J?=
 =?utf-8?B?TTlHdWFnZHU2YzNMNk1JMWpOVWJDTTJjbTZnMlViMXpNcTVieFNDbUVSL0I1?=
 =?utf-8?B?QVNRU0tXV21ZYVRUZ0orQ1Vpd0J6dDlDVXAwZktwYzJCcFdSYStjTWVYT3lv?=
 =?utf-8?B?ZDBQS25CUUY1MmpHQ3J1eVlXVGFZSDM4Rk1VbkRnZUhLTEpPYjE2SnljSStN?=
 =?utf-8?B?TVpZYnZPWU5zL21MQzVsakp6OUlWN3hrN096aUZ5L0Qxa2k3U0svR2puK01w?=
 =?utf-8?B?QUVNemZxRjFuUXVqL2xQMVVRaWN3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3be0a007-5f30-49e9-bf99-08db1fb8ebb2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 09:38:49.4673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: McsTlgwWWxBzkBUJAQr4zYxVfPaApxfX98u+J1OG9sebgYadcJb1ooB17vg4gyk/DEQM4PrE1gGxh6toUUO+naXSeinEUGOqnQB+9THWwOg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5114
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 07:40:13PM +0100, Aleksandr Nogikh wrote:
> [You don't often get email from nogikh@google.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> On Sat, Mar 4, 2023 at 9:16 AM 'Miquel Raynal' via syzkaller-bugs
> <syzkaller-bugs@googlegroups.com> wrote:
> >
> > > I believe this is fixed here:
> > >
> > > - [PATCH net] ieee802154: Prevent user from crashing the host
> > >   https://lore.kernel.org/netdev/20230301154450.547716-1-miquel.raynal@bootlin.com/
> > >
> > > - pull-request: ieee802154 for net 2023-03-02
> > >   https://lore.kernel.org/netdev/20230302153032.1312755-1-stefan@datenfreihafen.org/
> >
> > Hopefully, yes :)
> >
> > Thanks,
> > Miquèl
> 
> Let's tell syzbot about the fix:
> 
> #syz fix: ieee802154: Prevent user from crashing the host

Thanks, I was wondering about that.
