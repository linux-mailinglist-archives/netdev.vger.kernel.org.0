Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B833603B31
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 10:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiJSINJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 04:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiJSINH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 04:13:07 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D4B5466D
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 01:13:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuTHuhUGPnaO9q5GbdJ7/3f+pdxdTv3A3G/IKxLJlIx5KX2rJ2EfabhAr1QyEH+Sg2AJ3b3CFOQ22S4IL/g8OXmWlcVwqwUEGh7HldPCPQihJ62itAOnYibUvWxeGxXsG42WrG/4wOdotpaFNGqJDMYReMTLGOFER6YW+E8Dc04zydVydcuUH99ILnwX6k+/kqpiQt27z4SDAStHCWB2Uw40UEKqIJMxcdkCO5yonQByeiWX9MAw1ECNrcKqAdaF8BCMz/ZmlTe9zZOIKqKEuxaUBUMvSJHDmQzgypjEUoR1Kivf8XK+oZAXjrKEg8jbN9mGeeU9zPMTbPs6pI4MBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tGAydw5VOS1FBY9AAZ8CkNC2rEBurJzQWm8Z2BcfyDg=;
 b=fo4y1qrfR8QZxivpPwE809HbrbmXcHJdiLvt/dYDsdk29gEow89vzjhkptqhRVh8TrcQAL6al7VXOTYyaAbB8eYMs4uSVIef1f+YBUHCILAtCdy2/L1V0fNVnZT6AwJ60gTqyy7dcqV/0MVK2eQ/+lETrqaIF0uQam84lPEpJ31XKMJausoWCtQNlgow6NoCyeGS4GdzYxVp/XFKUKlgY4XJQ2oDeNKyAD92JEevB9CPjrN7HckwTV41XUGA5KqcVHd9gkUjoMUfIiXQLb6DXqEN5DqEHwch6s9XUyTIkHZ220DZ778UlX0Xki3RmzBzBI8oNmaTNYQIXYOZn0qIdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGAydw5VOS1FBY9AAZ8CkNC2rEBurJzQWm8Z2BcfyDg=;
 b=eZll+bWuGs/apJGyjt3ouCYcvdby3Pz/pystgANqVWfbgrvHVTL24r2/2KUzzWiB1uTyp4yxuBF+QvVt2dZgkGiEM0b0hYq7WYSfakTDCEGu6QbSqoAASAnRI1QRq1x+mfjlnjL8WxkAyrYwZtcmjKWylqrVT66owbxqJ+BkdHo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5811.namprd13.prod.outlook.com (2603:10b6:806:21b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.19; Wed, 19 Oct
 2022 08:13:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3a35:112e:34eb:6161]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3a35:112e:34eb:6161%6]) with mapi id 15.20.5746.016; Wed, 19 Oct 2022
 08:13:01 +0000
Date:   Wed, 19 Oct 2022 09:12:55 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Ilya Maximets <i.maximets@ovn.org>,
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
Message-ID: <Y0+xh2V7KUMRPaUI@corigine.com>
References: <00D45065-3D74-4C4C-8988-BFE0CEB3BE2F@redhat.com>
 <fe0cd650-0d4a-d871-5c0b-b1c831c8d0cc@ovn.org>
 <CALnP8ZYcGvtP_BV=2gy0v3TtSfD=3nO-uzbG8E1UvjoDYD2+7A@mail.gmail.com>
 <CAKa-r6sn1oZNn0vrnrthzq_XsxpdHGWyxw_T9b9ND0=DJk64yQ@mail.gmail.com>
 <CALnP8ZaZ5zGD4sP3=SSvC=RBmVOOcc9MdA=aaYRQctaBOhmHfQ@mail.gmail.com>
 <CAM0EoM=zWBzivTkEG7uBJepZ0=OZmiuqDF3RmgdWA=FgznRF6g@mail.gmail.com>
 <CALnP8ZY2M3+m_qrg4ox5pjGJ__CAMKfshD+=OxTHCWc=EutapQ@mail.gmail.com>
 <CAM0EoM=5wqbsOL-ZPkuhQXTJh3pTGqhdDDXuEqsjxEoAapApdQ@mail.gmail.com>
 <b9e25530-e618-421c-922e-b9f2380bc19f@ovn.org>
 <CAM0EoMkFhGtT5t0103V=h0YVddBrkwiAngP7BZY-vStijUVvtw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMkFhGtT5t0103V=h0YVddBrkwiAngP7BZY-vStijUVvtw@mail.gmail.com>
X-ClientProxiedBy: AS4P250CA0018.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5811:EE_
X-MS-Office365-Filtering-Correlation-Id: a6f6af2e-bc21-416c-46d7-08dab1a9bd6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PMq/9BQUXkNW1p8jzMC80A/UVRotwDBvqUP1PWQkH+KWz/50ECruZexClXFnvLIKejeEdp2I/Kc1lVDNzUR2MMseHOQgitdiCxRiIg25ImlXWj5s2jdHLzq2Dx3HIQp8phhkqc6ZVDVsgqsGGjPozmyPQR+DOcFdE6pKjXoIlgJxhpkViuBsL/IS5Uw6byzIm4EZbmcYJbhBqZ5rZaqB3tbwYXRjlSgBrNN8dUXplgLp25BhXHWUXAqS4/9RYOs9D1XB1gNgw6BmAlAPRiTkBnQj6Pbo8juHXEVsMehgrt0mbBUhjSvB56SNqxYyHE8+nwJ3GBNEpBej+8Q9pBboOHtUfckSzqAgeLBlr4vl0SLEb47UxTGt0i4pLmBeqYsggeY7zleoEasSqxAngxxXqNI9S+BZ69U/OQez6jTr3xQUEqTWi2AZREYpYYwd5tfvOyXMw4IEasHK+9ZslFeE46pvKAziEEYHBhO5ECtfvfNEMJtF/0lRCmQ5PDdYn3fs49pH/R/7AimNSjyRgkwihP4ZNgtZse8nV7xqmuZ5+d3QuP4/EGtoLUdUWdM6tXZ7I2pkA1H9pA3ISPnvJ08JzTtSjXETBecvwSbyXUBcHR2PKDa1Uezf6YBgu9+YQ9vyq06ZkMaPXk0Axo+otwYFhAwJn/EmViFA7H5AqfqapM1++9lgf6yxpfym41ZXZ7xAnlN58Q2zoeMDTuDAj6s/C70sxAz5dzAMXwgvq6FQpHAfpCDPRSJTVc6t1pYyVdhoj3/96AWfETolh4krldGz4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39840400004)(366004)(396003)(346002)(376002)(136003)(451199015)(44832011)(86362001)(66556008)(41300700001)(8936002)(7416002)(66476007)(4326008)(36756003)(8676002)(2906002)(52116002)(38100700002)(6512007)(478600001)(53546011)(6486002)(83380400001)(66946007)(6916009)(316002)(186003)(6666004)(54906003)(6506007)(2616005)(5660300002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZsVOPZ+yNv4/mn+Ega98WrQkLoqVcOcSPEaK8kSuYX366/ynUbncAomMlhwf?=
 =?us-ascii?Q?3MvF6i7RtXLm6F8VJ6QlpsN+hZuGHRNrgn0/sheqxtluaHcc9EucBbLVbxWs?=
 =?us-ascii?Q?kXz0RyTnDGRBMGCU5DAlx0JlEoAmwcZUjrmi34R2caGyEx83y1bCNahhN+Ux?=
 =?us-ascii?Q?oFp6vXqTqhlh2grUnnD6SGOtsepT3ap46W9CnXmIS0eB6CFyt9CrnHafWf6D?=
 =?us-ascii?Q?wM+WN+CThigowXXaUOYvY3p+9HjmJF9rCFQSDLLAwOvRIK053Ef/zmSaxUEk?=
 =?us-ascii?Q?FknYNekXUPmNSq129F3mjhBMDXxzFlTS//Dgrcw3VpJ0itnU3FjDNtvqNxSA?=
 =?us-ascii?Q?GsBu8XPViiAwARiNNbratLAXfPwSB7j4FcFrntqUbNM67nyQD/dOqDnoFWsr?=
 =?us-ascii?Q?DizaHWij/A3SLUL47tdiBwIaTiSa6PwvbPSmyK4KozVNdjJhUhtusf8Ne3Gt?=
 =?us-ascii?Q?/W+GN9fEGejEguqjTRNGctVVM7Rsp4s0V/xCwKXSlKvZr20i7ZseZ1u5LiNU?=
 =?us-ascii?Q?CJjDUSC343hjV82bFf0uwbvEs2S7pGv89eeyNVe9VTZRkf1bvdzhuzftt0Rn?=
 =?us-ascii?Q?G1DylK/HkpChjF49cLuSsrl8H83889zS/Pm2Iq3yTD8StppYYAqnJOT0A32w?=
 =?us-ascii?Q?DwVRzCjeL4yb96FlCzzrF2nNNIjv+zgGcVVRjlkwG4n8eAJjX4qgyFeoDLMA?=
 =?us-ascii?Q?Y5B0daUWLEPNnRcaJAMw7pQUSVyeYw+Gf0oVLud8GqZNuNAFZjb9bWNIu3Y1?=
 =?us-ascii?Q?UdVN2IXMPGFEpf+evoH20o95N6Scc6JrDxU/wo2ibfqO9JhSMwr2hSXyH0uZ?=
 =?us-ascii?Q?r8rS9rf81mw9Ui1amx35STojoeJNm3MQe12zTpH3aPZQM8y4Tp0b8F6D1nti?=
 =?us-ascii?Q?DwdymCm+3bU/cyGHkdmFCK0qnaBwJp/l8PT8YAvVmPQ1SS4TSfTij9jrJqlu?=
 =?us-ascii?Q?YBSXUMyruGsqa78IMbSNmCuP0GE0+FaEYHO1/I8VDADmqS4Ebmjhab21T2Y8?=
 =?us-ascii?Q?qALtHkZMt2t799xVN2iuu14rFPY0mXIkOehgxg8Usa9M227E0C3RPaYzrnOp?=
 =?us-ascii?Q?lE4T/KNd4UMSQvxUi78t+7DG2qZGGYG/7/v6rQoFcXXYZDaDyPRXIxre7DVr?=
 =?us-ascii?Q?vpinRrsOXq/jtlRnK/jYQGifOvgjyrvtwl09cRAgs1vfAtgZdDLwRhEpLnQ1?=
 =?us-ascii?Q?Kyd7o50slWgyKn9AifeqgXHpScHp64SJUK4LapBJtsPzkjAZN7hGQtMy/lmp?=
 =?us-ascii?Q?Naxg5d/jpO8jkdAUVH0hFTZVqepvNFlpmeL7wbKARGXNFU2LVUczvGw2FXp3?=
 =?us-ascii?Q?avW2N6JN1L2LpXVmIGFywvrc6AE+SKYsNu02keMJNRUH7Xjlq4rspuM3zKYU?=
 =?us-ascii?Q?Z6X3b6mqc8pT/mluCBYRKxv3y7FhI1BaQldoA5+pMzcv6zxWljmSzmyHsr3a?=
 =?us-ascii?Q?EyCrUDIBCYpP7e1UNOHp2qJT9yL6tThxNsXmvb0MGl/Oc25xX5gnLNY1vXzQ?=
 =?us-ascii?Q?FiCLDiRHhNki9W41bGSJXdA7qVysdHjwU1aIvyzWgwDtNN3ewuvt0Eku3pzh?=
 =?us-ascii?Q?CVx7Ma9IIgRon1o76gi/nuW1/wQbEqSGIp5ZYtVyfC5iN7E1GiRgM3gqPMuQ?=
 =?us-ascii?Q?gyHqNHzwIUI3zyXnPq6PqU3AYK9QH5d5be3FyfqietcIwq6qDPRkoAje0jau?=
 =?us-ascii?Q?O7HtZg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6f6af2e-bc21-416c-46d7-08dab1a9bd6e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 08:13:01.3306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aKX6OXBSfwg47nDzy49aPMPuZoWkflMV7LEh+h6FjyWpKWaZHIDtlVU6fxhqeDmgdutD4AasrnjgMMSCV65X1EQJiidpd8YOaZTJS0X0FVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5811
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 10:40:30AM -0400, Jamal Hadi Salim wrote:
> On Fri, Oct 14, 2022 at 9:00 AM Ilya Maximets <i.maximets@ovn.org> wrote:
> >
> 
> [..]
> > > I thought it was pipe but maybe it is OK(in my opinion that is a bad code
> > > for just "count"). We have some (at least NIC) hardware folks on the list.
> >
> > IIRC, 'OK' action will stop the processing for the packet, so it can
> > only be used as a last action in the list.  But we need to count packets
> > as a very first action in the list.  So, that doesn't help.
> >
> 
> That's why i said it is a bad code - but i believe it's what some of
> the hardware
> people are doing. Note: it's only bad if you have more actions after because
> it aborts the processing pipeline.
> 
> > > Note: we could create an alias to PIPE and call it COUNT if it helps.
> >
> > Will that help with offloading of that action?  Why the PIPE is not
> > offloadable in the first place and will COUNT be offloadable?
> 
> Offloadable is just a semantic choice in this case. If someone is
> using OK to count  today - they could should be able to use PIPE
> instead (their driver needs to do some transformation of course).

FWIIW, yes, that is my thinking too.
