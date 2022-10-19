Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA6A6045A9
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 14:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbiJSMrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 08:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiJSMqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 08:46:43 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2110.outbound.protection.outlook.com [40.107.94.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693674E636
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 05:29:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cw1lcPJ5mKkOEy9BXlniPR7ICNRF/Wdo8cvBVND3Jq0aJAqfhq6Fc4T3WQQbO4y66P/3J4Pt1tjdhsePc7QgwKHOrtfyRwoU/60oUAVUdWj9lmBh5xxuLl2BFjwz2pJTSoPM4vympS1+Ui3r2E3mn+4YrSo/jYPrNuXpQX4JwMjq4sNQihyTm+2P8yX+nAglLHM3c8/3HWn2Uf7G5INxUUOYoQkrORIVBh1ZmaHCXI7/QrxOGZIfbn5z9/rv+h1tQskdxbOrhVOjoyjdo6vc0dRrLSy67LS/R1egHQ4mti+1optP3Srr/nYgfrqU0NhUG/ZaaN9/8VJbzT4wuN7bzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6rbkBZG4/4rMWmAz5j6Nl5m+2p75ofparNDOze3O6ok=;
 b=AMeX8vzIPA4twfoSmXI80xj+guLk/NvQAzhiB/L+u/BCFoD6Xo56rlRwveLdyw7CSqPFYx6ygTLk+hMC6IJk0dEXMmBmk8SbSyzjanSSYSHVgKesR1PYGF/YYC2lJQcDBAqQqfv4qPCvTDMzuyDrrQZ3+Rm22CE4jxat9hh8OuNvaM9a/2EZf/POX4Th6LrMuu/ZrSVfU5GcvTPZKogU/pjwlFpF3n5cCayJx8R47/DXTqXfewbEozJO/Fe6d2HyD8jO6pu3rUcCmmPWp6JCeZ/7cpBQgNB5+R5utCM2SOEQZIpQI64FMZbHHFjA5KBce2gq8oI2scHHMWlQ+gShkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6rbkBZG4/4rMWmAz5j6Nl5m+2p75ofparNDOze3O6ok=;
 b=CDqBzGQsY/SR0OxwxJnQaJM1YtkpFCd5ZGNcCL4Jb9SWVWkb/I1DLd+loFbboQHl7qMK6yKVeEnIuRlT0owUUBPG9j71LceihkMCTvinsTFVcU853MYkD6XO8wyqVMICU9/y9kU65V19vtkKvx15y7M1pG0OGn7AKvKwnLSe4ZM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5356.namprd13.prod.outlook.com (2603:10b6:303:14c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.20; Wed, 19 Oct
 2022 12:28:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3a35:112e:34eb:6161]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3a35:112e:34eb:6161%6]) with mapi id 15.20.5746.016; Wed, 19 Oct 2022
 12:28:35 +0000
Date:   Wed, 19 Oct 2022 14:28:29 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Tianyu Yuan <tianyu.yuan@corigine.com>, dev@openvswitch.org,
        oss-drivers <oss-drivers@corigine.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [ovs-dev] [PATCH] tests: fix reference output for meter offload
 stats
Message-ID: <Y0/tbYTy5Up9X1m4@corigine.com>
References: <CALnP8ZYcGvtP_BV=2gy0v3TtSfD=3nO-uzbG8E1UvjoDYD2+7A@mail.gmail.com>
 <CAKa-r6sn1oZNn0vrnrthzq_XsxpdHGWyxw_T9b9ND0=DJk64yQ@mail.gmail.com>
 <CALnP8ZaZ5zGD4sP3=SSvC=RBmVOOcc9MdA=aaYRQctaBOhmHfQ@mail.gmail.com>
 <CAM0EoM=zWBzivTkEG7uBJepZ0=OZmiuqDF3RmgdWA=FgznRF6g@mail.gmail.com>
 <CALnP8ZY2M3+m_qrg4ox5pjGJ__CAMKfshD+=OxTHCWc=EutapQ@mail.gmail.com>
 <CAM0EoM=5wqbsOL-ZPkuhQXTJh3pTGqhdDDXuEqsjxEoAapApdQ@mail.gmail.com>
 <b9e25530-e618-421c-922e-b9f2380bc19f@ovn.org>
 <CAM0EoMkFhGtT5t0103V=h0YVddBrkwiAngP7BZY-vStijUVvtw@mail.gmail.com>
 <Y0+xh2V7KUMRPaUI@corigine.com>
 <ef15dc87-7e70-55f5-7736-535b4e0a5d5c@ovn.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef15dc87-7e70-55f5-7736-535b4e0a5d5c@ovn.org>
X-ClientProxiedBy: AM0PR01CA0083.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5356:EE_
X-MS-Office365-Filtering-Correlation-Id: 86675b0c-8989-48a0-9086-08dab1cd7185
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iy3JV9CZlZlzvyC39mCNl6HdwuCDaqKSiOX+8hsiqzTeMVzGU38YBTHGNL3xEBwQr2M3pzAYD49HKad2gugkJDpMgNWTcCpeFAoSebcNyp7PhPNXSkoBfeBQYhe9YKw4TrXivt7TAyIV4/HvDjIYFxqmYhP6ymQQHW/CLgHxPBKoCGXPnYFsJ74RcjvYNzwD7f/E9EmNVCb6IJRQMebkkPoUrfnRQQngN77sktSyBSTet49LBZ2y1CdwB2V0knuO9g71nKRyYSVLLGkKi2/6lZTAu9yhfYOWQNFsFHwRngg/CoH9COHt6iwVpjFdz6g5Wr93QCQ7meHy1xffA361H+7EHxfaM1kHfwWG8tTKYjqc/8z/ENR5GTO3wBnktq2ux72FG9+nvCIZnuBuYXN6l7GST8o2VtYusmQhKNFwEaxDO/M9sFSchG5Y4wQzbqDnB/fk9lwqwmktbBPUHW3Y92rOspu+dDeby89Jyb7uooOtPotJQpA8itxVHXxj/T36/Meh23Dh1a2QEo8HqHjvEKfJbh2+/HNgAmcjZ+aSDI6QJf9tsQ8wMhgzkHEKkE1PWhVry0L5flCIyk2FEibAw/yqHM2ZUWstGVYFxT9Y1NnMri+m1BapAhHb7Z/0lsD6ozTycWyLnSM7XC6ZP4K6/c018yaQqM70gsuD+rbw8dcy/MGNTfX95YZVHlPwwZC8nlzn/gqvbSBtF/Qk5Fn2dg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(366004)(39840400004)(136003)(346002)(451199015)(38100700002)(5660300002)(7416002)(52116002)(6486002)(8676002)(66946007)(478600001)(6506007)(66556008)(53546011)(2616005)(66476007)(4326008)(6916009)(86362001)(54906003)(316002)(6512007)(2906002)(44832011)(186003)(8936002)(41300700001)(83380400001)(6666004)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ywGzZ2XE6KSYo3e7CLeZUwC/14CGqtwdcAN8+oxmNz5Ze8MAeHIgO4Cq99oK?=
 =?us-ascii?Q?NEn3nki9XoCo0QZvz5gcki2x8Dwl9cFjvjVopq4nigajypHPRuYqSDe8uCLo?=
 =?us-ascii?Q?GjZNQCUlMPY1lVgcuZepY6eM66IoM4OhJSMkMLzJXZgcw0QDdurBWfvyJQpW?=
 =?us-ascii?Q?q7/CquSYL4atACQ1GAiA2X1JMnHWEmQnz0KyPK3ih7+goBJcpSUOUSXZ6j0C?=
 =?us-ascii?Q?Yn5Wq5lW1mKb/CHO6azkJBEokAZc7ToU59IpZ2fsVxurbzA+B1R7hPYIRIOT?=
 =?us-ascii?Q?wxW4icpQ/AzOSeMuK+2hiahHt/dCmreAS5o/9UrwLU5ZWmviTN0Wn+THsnif?=
 =?us-ascii?Q?PkH7ISpyEdQqBfeiYGA3YeOgTHURwTpwog0qAvw+RBu4UcBKxXcovzlBLKo6?=
 =?us-ascii?Q?XY7QyI16WBHkNuu+rE0HFqWtawX6+Cydr7a9cAQzesU6FaiPTmFQzzhuJ01k?=
 =?us-ascii?Q?z1JTTiZm3M7W8I9YKpc//lLm/GAgfg9tpfgfIwB3aPLZsYg4sdiz1bxapieV?=
 =?us-ascii?Q?S4nw+tsiAnhcDLiuLh9XxQW5NzyZo8pa5CAXAp0T7fo06Vu0+b/lElh3g7uq?=
 =?us-ascii?Q?+kWMuVslJyK2kd1tn0Nb3TmllmNXSzxiin+eD509C5UtX+N4pKZlIFQ1Xz3i?=
 =?us-ascii?Q?RdzMpuSxliFlVPO3cT+FMG7e4aATXanf/epOooJWYreAkQETd56HhUIamii7?=
 =?us-ascii?Q?WwLcEe/gCke7YPFFMTexNJUh3Haczv+WVXTzuwZy4fCaK1EwAWFoC7ZSlLkK?=
 =?us-ascii?Q?jI122LsvF4FvHex+BHuFILhFlPL2klYf+ROr3lSayAJcTDVUKC8M4PgpZZ7D?=
 =?us-ascii?Q?s9MkSj7Ph29Od3oHTRBkyehQf1MKw56Ffv1svAKQJxs51KyrSW4KG9EzhvTx?=
 =?us-ascii?Q?KuE6xH6iPfgMj/yviH+XP+Ce44AtG0lJQlA2WT9irDXZB/dTyTewxvzHOeGZ?=
 =?us-ascii?Q?eAjNyqtMTaUGGrzz7S/tv5t9eq8Ja/4C5exOhJD48OLh0wGSOERStRZ6z3at?=
 =?us-ascii?Q?Kxj698FsA0FMIq4/cuC2JLvdcHmKRV12WXkHEuqdIBD0EL6NQiLLJzEEQvQo?=
 =?us-ascii?Q?gjPESljAoTquUm5Ji1HGZf0zWNed6gOx6BE0tIKtPhUxi6GyYJWDuI14skHQ?=
 =?us-ascii?Q?d71mTyinkBj7N6gEZ7MDPQZCC+V1bd27DjiZCLCs2XXHP/MYyn7U6SuqBDX7?=
 =?us-ascii?Q?Vn1bcUWMTTugJyXrtb7TBM5e7eRU5mVRO5LQ64UUsQTnhUnhkGNSY/mT3ndk?=
 =?us-ascii?Q?yclBOa9VP4WIWLN8Z8aw5eysYWSABgyR/1Qp8Oh6B5woGM2qJGP8aBsZViY9?=
 =?us-ascii?Q?KGl1Og/i1zL+5Uatxhc/TCzB7Fw6zKmvNWYvm106bmetg9E8zNTY8dyxlzAE?=
 =?us-ascii?Q?6QzTv8ZbuIkjd56HFnRPxcsfxXqAVKycOk0bqtFCSKu6YAQi5jA0oZGQj1D5?=
 =?us-ascii?Q?sOmtfypd0hOPgqcRAMVzWC5iJ9Bn0NblMnoGhgZmR/DujW0GH1r5J/MeC9NY?=
 =?us-ascii?Q?OPQ83wd60Qm4G78E8N081SoVxmRhmV0K1RTpWSOdLBS6aQmxajv2dS6F4n6a?=
 =?us-ascii?Q?NzV7tctwh83Z/mUkCAdlpBXSorsVWKPe/a60DBqqopMwukYkWbu+ej6sQ6NH?=
 =?us-ascii?Q?A+Auwq2+HFgBUbnAlArLCqcjq3cexzYIUKnjMPBQ5Y6VSR5xH3qdLZEkHDpg?=
 =?us-ascii?Q?w98h+w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86675b0c-8989-48a0-9086-08dab1cd7185
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 12:28:35.8587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eqvmZkG9x+s8Mxs+d9TbkTWRjT9Tq/QxZsJ2DeQEw4lZSUIM2FJd3YgPuU+dcuhiztbS9PirO4WYF09UwjKke4dgVZ+cz3a2oKNXzjwGb8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5356
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 02:17:42PM +0200, Ilya Maximets wrote:
> On 10/19/22 10:12, Simon Horman wrote:
> > On Fri, Oct 14, 2022 at 10:40:30AM -0400, Jamal Hadi Salim wrote:
> >> On Fri, Oct 14, 2022 at 9:00 AM Ilya Maximets <i.maximets@ovn.org> wrote:
> >>>
> >>
> >> [..]
> >>>> I thought it was pipe but maybe it is OK(in my opinion that is a bad code
> >>>> for just "count"). We have some (at least NIC) hardware folks on the list.
> >>>
> >>> IIRC, 'OK' action will stop the processing for the packet, so it can
> >>> only be used as a last action in the list.  But we need to count packets
> >>> as a very first action in the list.  So, that doesn't help.
> >>>
> >>
> >> That's why i said it is a bad code - but i believe it's what some of
> >> the hardware
> >> people are doing. Note: it's only bad if you have more actions after because
> >> it aborts the processing pipeline.
> >>
> >>>> Note: we could create an alias to PIPE and call it COUNT if it helps.
> >>>
> >>> Will that help with offloading of that action?  Why the PIPE is not
> >>> offloadable in the first place and will COUNT be offloadable?
> >>
> >> Offloadable is just a semantic choice in this case. If someone is
> >> using OK to count  today - they could should be able to use PIPE
> >> instead (their driver needs to do some transformation of course).
> > 
> > FWIIW, yes, that is my thinking too.
> 
> I don't know that code well, but I thought that tcf_gact_offload_act_setup()
> is a generic function.  And since it explicitly forbids offload of PIPE
> action, no drivers can actually offload it even if they want to.

Sure, but I would expect that can be changed.

> So it's not really a driver's choice in the current kernel code.  Or am I
> missing something?
>
> Best regards, Ilya Maximets.
