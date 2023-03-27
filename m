Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B956C9EA0
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbjC0IxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbjC0Iw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:52:29 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2133.outbound.protection.outlook.com [40.107.244.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DB259DC
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 01:48:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bwe1uYUV/vM2tLS6I4eJ44IGA+3n3e6asvScAh6sISECsypUcg3ePsu0Wqakzh5++wyPdb+yJV4tIDG4gaOmUlfR6BUI0dhGsPwoNJdemr9mKzZTMlIH0hgzdJRTuPeHV/pGBhgAqXSP2psE3e291ciZ8JN8It394pg2qWjYb6rFiRcDes8+4TXX612MB1bkBRYSXKTW8tVilCLTlEZgUVucyA45xL8aiWbwPruu78BUT9Z1k8AEwHDK03NuITZca2flcdpPAMGG5UguC4MK3M02ezg9wPAw08cllhjzEwBDlw+rpXqUimwIpEqGjob+zl3Ngd95gVTW+I0a+0gU+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jR+WFrhqpRtNdtuO0b8QjEzlAMMMoq+B4VANNVvYWQ4=;
 b=Ll5BhrnB4pfrfHBxFRbZ/kH/ZHh6ycTBGoVI+hatMJsKAOFIMRh/tLtSMFAvasbQ41ADF2yQlImiNMO8JK21ewgQ0xZ6gXz2Zr8IwCSqiRvsDURuL9zkr6x49S0rcEGiK5/XCE5kHotytxrhxkuZ9IjcZ9lW2Q4odfIdD2HjybZ2b/dDFVCA8UdNuYusqEF1I34gqgioTFxb3eP+7T0cAHRSIQYF7gEj7wPbF2OkyRLzLr3ip4yuewF8xrIrjSWFBZMeNXCS669BZwE5NRbaePH+inSPGrw2WYwhWYhej/MYTPT9ZjadI2wc0dSGmT1t975bHHUHZwV3TVtQcuzegQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jR+WFrhqpRtNdtuO0b8QjEzlAMMMoq+B4VANNVvYWQ4=;
 b=oDG1xv8eWzeu74usy3CCAke4pPwW4z5PkueAcm6X9R+aito1pZ1hnvjl1u6LaaPrgpbYtb0WOwZP9eH8z6fq0Z/YnsEUZtiaa6U8A5s7JN5oOoL/nhCyjVmX9VX8dEOfj2VSP/TtwSuBGBFNh4MWY2VCnErr9kWVB44rK3MbxjA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5843.namprd13.prod.outlook.com (2603:10b6:510:151::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 08:48:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Mon, 27 Mar 2023
 08:48:17 +0000
Date:   Mon, 27 Mar 2023 10:48:10 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     edward.cree@amd.com, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, michal.swiatkowski@linux.intel.com
Subject: Re: [PATCH net-next v2 4/6] sfc: add functions to insert encap
 matches into the MAE
Message-ID: <ZCFYSpw5mOj2pJIB@corigine.com>
References: <cover.1679603051.git.ecree.xilinx@gmail.com>
 <b9798c4b1f176257cb9b690d350f3a3c66c1b401.1679603051.git.ecree.xilinx@gmail.com>
 <ZB7jadqopcv250l2@corigine.com>
 <66d1c67b-ecda-69a5-a8be-feddeee4a5d0@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66d1c67b-ecda-69a5-a8be-feddeee4a5d0@gmail.com>
X-ClientProxiedBy: AM0PR01CA0135.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::40) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5843:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f50663a-50b3-4fda-9155-08db2ea00293
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ffO+RdczpxCvQgPwrQ5vfZ9z6GqraSLowIjlCBPIfyq8e40NJ9kAeK6fZLwNQOTi4N4JsMl+pTDUvm76YPZNBW5msSLPj2VKORsJcB2eBtvskoliYiFNyYJmzvm69FD5Moo5WTpN3XLQv1xay20E8GDTIU4VvLZXg3stJ81DZXY34u8L9i8a+oKUyYNSb1qmmvdNa1OdHlKk0OTF3b0YIecvW5ztbUPmi1Z2BrMWlb+zC+zILFUITKeQEG98wTSZYXzkDmHsTHnj0j5lPkoq9PDg4VzJqFLTKfj2JSqRaKsfJOt5CxaDEZDxUSUZ8khUOX3bsYI2MT6sJRiteyMCQIqjEibo+X9YeOJs25GAjc45jeBjI6SvT8uQk7NQJSUcLeHkgy6kV7/tLebsrE5vblxTB3zCxa3hcpFh5gqexugQddX6Fq5YQQR3HVJNfKU98NvFV8KhT1b5fHyYobySK71UKNr3avA0llC9tNXlSHFCB21Vd3YGOorofri80JAO5HjSWRx5Gaen1nTSg1LnbFWraENtHvXBesJ3HRvlKi7fL6ZMeMKiCs330JGINgun
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(366004)(136003)(346002)(376002)(451199021)(5660300002)(66556008)(478600001)(7416002)(6916009)(66946007)(8936002)(44832011)(316002)(6486002)(41300700001)(4326008)(66476007)(8676002)(6512007)(53546011)(2906002)(186003)(6666004)(2616005)(6506007)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VBZygYlRF+SLnyUkCz+j6uLwrUva/tzceU25wbq/uTZuaJTvKfBr/uYn+wWa?=
 =?us-ascii?Q?hoBmsLofmPLLbn6EVZ958NKoZz6QxUZgLS1U8gK2lnNXtEqsxFh65g5EbIRi?=
 =?us-ascii?Q?j4E7snWuDGZ4CyR5N5LXK0GmDVXj5XozzWQhskLAt2JQwLvyVuVXAe/RLw+h?=
 =?us-ascii?Q?RuIXkumFrHGL5fLUxGmzDmUHroiROR+SgaZ8hhVmnhUckrjozIvaP8U3kLcd?=
 =?us-ascii?Q?BMRsvOqkDp0OUKhxLryflLJBvST1YEubmlek7uxiEEfiwnhR4ZpePGBD7TeQ?=
 =?us-ascii?Q?pysb2HcQvjQ9pawY3w8c+eR95SDl6CB8ajcRHEkp56Pm7pqvFK3L2Lb8hAxT?=
 =?us-ascii?Q?tBKbbfPZmep/HC2TdqtfCxH3RClDWxW3G0BMd/nGqZPZaItv6zuAb6af37oC?=
 =?us-ascii?Q?ALEMOejnJRyr/IJBcWuB5z4Tr73lsaFmv3wvmkLOUkKHIU6eyB+4KmLM8+9y?=
 =?us-ascii?Q?OgsHIiB411nHHa/V4WQZlapx4mVydapih0gO+eqXN9QVU8XxnsMwVdU7+vJS?=
 =?us-ascii?Q?3e2mrKO38v5k4PlhYxFNhYi1ic8FNwh/38SRmqmIkcXSGEZ2DsPP2g4uxrNM?=
 =?us-ascii?Q?loHU6UE3vfoPzDP/8acLGUmYJN2GFauVvAPOFgibP1mBAtWTP6aYVOtx9J4J?=
 =?us-ascii?Q?T1W9OTKMFiLoA0jFuFvdIFIo5vDXCAXbiTl9+Kjjr5o+Sjfg5DkaVohYuqFW?=
 =?us-ascii?Q?pSOZwDG7XkhUZygn5Z1ppY9Gd1+RKKzLbuPCEb8XizWw8tPpzIb8sxfCf1Et?=
 =?us-ascii?Q?xRPQ2gjFGSsG2KEEBU7oDPVMoUeRF0H63eiIumlCwH8q5CP+d1u31flgkLMf?=
 =?us-ascii?Q?2ibmGmw4t+Q7xhTNxDRQDelTlq195Sm1Y7HNgdOE+1+1lCEtTOzS7bQ4SR5O?=
 =?us-ascii?Q?FJ+4vk2ZAWpDXrXuMi7KsjIBfJujIsZZMIB0rj2kMCaRspCeiXtTGNJ88mwV?=
 =?us-ascii?Q?Jyos4aC/1KFFOMzXohY4+odDubA9fEe2bR2Q0kGZms71niUiY1/QQs6rCbJ6?=
 =?us-ascii?Q?KgQklVemv97qqYH9NSUR39UjTMW17MCTzsjrMFn+cIMnq8c1Ehl0ODIOGfkZ?=
 =?us-ascii?Q?4YFj5yaD3EUr01iV0zFkHvZAlYbCrhMX16zgHpql1mvh/0DTdWS6AJje5W6v?=
 =?us-ascii?Q?5LpnEbYGJvNLJF2klPWFdNjQzLTkaqc+WiwfFDAtVqJgfK8BaPMQLTGqQP7+?=
 =?us-ascii?Q?HwndQxTiBMbAbfs2dnPqEdk+EjEol/YtO6A3eedwTrRXDa437HXiTF+FBsQE?=
 =?us-ascii?Q?+Mr5EncmYTGAgypRbLmW26xYlKEqzOd1MxMJoxXMpz5RBFxFiZHG7Z+bE7Wd?=
 =?us-ascii?Q?u/xK8dsUR+VH7L3fiXQV79iIptPa8Yqr5A2sebO2yPXxiBLCNwub0Fy1tBeT?=
 =?us-ascii?Q?BBmgCIrrFa4YAaLUKj0bctrfBv1Zn6PCp1jFskCIxWpCTHVuK/JGjqSQy02m?=
 =?us-ascii?Q?I9E3n0MHZRnWMLjCpef0sgeUcZ92pmeqULzJtYspRDeczCUPTjkJenxn14+x?=
 =?us-ascii?Q?9CsMW5mj7Vl6ioJjuJSusR620r/oeVR2ZkQXoIVBcIA9H22+KycIz4h3q4Qu?=
 =?us-ascii?Q?1k4+Kv8hXoZ/fBtIrbIBdRrr1s7TaJhtSBpLh9TsrkGT8Pjtzx1088Nau71P?=
 =?us-ascii?Q?y7rqb49ngdlxvB+Sfe/+CsL5tejsecd6MjWmutbuh1o3X1U2KEDKr0VRhBwL?=
 =?us-ascii?Q?1XXLQw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f50663a-50b3-4fda-9155-08db2ea00293
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 08:48:17.7351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mkV4wFwESWG/5gvlDiaDcnJoZaNKUbHZf/RmtvOZxRXMTLcL2OkQuMVVik+/hqsl/A76Xy9f/zvq3xPcFCZPxu4ugc1TQNdjOwSCcOjTxj0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5843
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 09:28:57AM +0100, Edward Cree wrote:
> On 25/03/2023 12:04, Simon Horman wrote:
> > On Thu, Mar 23, 2023 at 08:45:12PM +0000, edward.cree@amd.com wrote:
> >> diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
> >> index c1485679507c..19782c9a4354 100644
> >> --- a/drivers/net/ethernet/sfc/tc.h
> >> +++ b/drivers/net/ethernet/sfc/tc.h
> >> @@ -70,6 +70,7 @@ struct efx_tc_encap_match {
> >>  	__be32 src_ip, dst_ip;
> >>  	struct in6_addr src_ip6, dst_ip6;
> >>  	__be16 udp_dport;
> >> +	u16 tun_type; /* enum efx_encap_type */
> > 
> > nit: maybe the type of tyn_type can be enum efx_encap_type.
> 
> Yeah, it probably should.  Looking at my git history I think the
>  initial reason was for struct-packing reasons (enums are int-sized
>  at minimum, which is excessive for a field whose largest value is
>  3), but with the rhash_head that later appears between these two
>  fields, using the narrower type doesn't actually avoid a 16-bit
>  hole like it appears to here.
> Will change in v3.

Thanks.
