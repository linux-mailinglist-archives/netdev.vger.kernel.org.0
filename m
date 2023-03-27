Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83146C9E99
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbjC0IwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbjC0Ivc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:51:32 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2133.outbound.protection.outlook.com [40.107.223.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB5B7A9D
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 01:47:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXeLv/mUbVpifKbxBpjchCS5OJCeWBiRlYzfLJGuU+F81zDtxgcFDgFq0SeoIABGYojuyaVYt8HzLgt+74BXhxl+PtaiuKLWc3VZAHAofYnYKq/2lcfRwJFwmQ/T1JOeHFZzJOxq9vrd5pnJoFHocN3euZvto6X01Yn2C7OnwgxgdZbv0VXXG5rI9V0UqSscz03IAmyGBp6fvb7ZurmRhFYX8YDlL6JHIPYpAcB82ZjxB29oOvIYhzqYGbAnIGgW0rk/KgSFyCDNZNn92J5021W31s26a+oyhS/QvLzYEfqpEYa/e6QYXypcudyXX5qZvXaRuIcc3Va+gL/EdOL2MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=obUz+sPhJLHMwtowdV26ODqnWf4qitVM/euSTMDaa4E=;
 b=N+llT2PIL1gtt453OV6q5W/AE8p6l87xRi4osA6I4w5sZIWT4E3svvLqNu8n/PJRAvnqZNl97In3IQHIWZqpvNtAQJckwL7Xt0YdTA4DIbUJkiwucDpUdwtQeaKHh/3kmrq1lkw95UVWUUt5sQWoYFo3jwvm0PdOOwVaqZrW7Khlk0zqWnfe7D7c89XdYZbbA/3wc6g/Cmu3zt64ED0HENLmve8x0OKaBCZHAGPR+ntoA7h6IeNk3gFp2dvzl0KUYnZYHC5f8SDJ3/pWp74Y6lAoalu1PRTWPD1KvVVMJRDlTrs4gL43fnJZ9bwMpr2zpaYGflOxZYGRdtXJY1wEIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=obUz+sPhJLHMwtowdV26ODqnWf4qitVM/euSTMDaa4E=;
 b=J08TumnebviwfPrn+3fw5TAXe3PubBmrMmpY2Oim1GAlOhd0saNQ/0GVDsCfat6TKQ0xqJPcBmlMf1SOkNmNbrS2Byvwtk5zB9o/cvgAOIH7JZdAldGPTsOykvQC4smuR90eLOSY/JrpBU4PcT9nDA+Cp8/yrylqGs1ShnINOb4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB3961.namprd13.prod.outlook.com (2603:10b6:303:2c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 08:47:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Mon, 27 Mar 2023
 08:47:07 +0000
Date:   Mon, 27 Mar 2023 10:47:01 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     edward.cree@amd.com, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, michal.swiatkowski@linux.intel.com
Subject: Re: [PATCH net-next v2 2/6] sfc: add notion of match on enc keys to
 MAE machinery
Message-ID: <ZCFYBQBJbVSRmWNc@corigine.com>
References: <cover.1679603051.git.ecree.xilinx@gmail.com>
 <fd5021315abf37e392e432021c6668c52da90dd1.1679603051.git.ecree.xilinx@gmail.com>
 <ZB7jApAGT9q3ntjL@corigine.com>
 <eeeda5b1-cd18-18ba-6018-a0772baf9948@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eeeda5b1-cd18-18ba-6018-a0772baf9948@gmail.com>
X-ClientProxiedBy: AM0PR02CA0152.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB3961:EE_
X-MS-Office365-Filtering-Correlation-Id: 1195ebea-3241-4ff3-a413-08db2e9fd8a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oLCglp7j00QX4bMEfI+y+BJL56teaopaZuW7JCvNpI/HITL8wA4O4/SsyUbZHAztGlm+var1eXtGKWWR8CULIQkiGmr6fZAax6eRMynwSryvSP2iJwPxSykYHAIGBmvTCA4fWFYi8RnlIVqsPtFubvaJYwjcYWQHrbEjEJtQrkBjuGfA/OSRg1aQyGQPddZ8j+HEd33hTyvjBbDnUjdaQHDxT7zYxyoNtXjNe4nAFRpWrB5rVe9fsWgaUglhRTC32HKR5i2Un1vWLRVkhU/T5bsNd5HNvy0TmQn0KaDfFS+/KER+thaQh8TOOgeJvGX2tJjy8t9Cwlql3NUWiXhgNiKH5lMCV3z0YCn5uNizfxiEsLJC1MfAh1gphrKZHIY/buQMSCPQOhyBCFMaj6p8X9JlmL6uRx33NGCLPDiQGckHJ/wraMFQWK/x2bs7oZghtwONb0t9QWQb+1/9M4RjNd0f00n7crYFPlt0PRGwgVsf+vwE7k940AIDNHSfMx0ps4powKuh+MdsjKWVcGNZYUOZeNcT0QuGy1wRkY9F2hdaSzBfTEl4KpHMzwxqjrXDaCHi0K57NDSUOGLxmN+7DshfOpmem5k/AHmFksfQFFQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(346002)(376002)(366004)(136003)(451199021)(36756003)(86362001)(6512007)(6506007)(53546011)(83380400001)(2616005)(44832011)(186003)(7416002)(5660300002)(6666004)(8936002)(41300700001)(6486002)(6916009)(4326008)(38100700002)(2906002)(66946007)(316002)(66556008)(8676002)(66476007)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C8nWlYqTa8QPRaUDgrggqoxxmawGvy4aVyJu66+wl8hi9Z3PpYI+mLNqm/FL?=
 =?us-ascii?Q?w/nal59f5e+xfqihV9JZ0v01R4Fo5bQc9V7vyomZFMBhEbUpO9g0gJUcB9H7?=
 =?us-ascii?Q?6+u4EMfcFgjxB9lOJdJuVI97uMLSWDgqBPnmPpt8qDBKHF0QAhrbk/nyM2XZ?=
 =?us-ascii?Q?FCRowGaCFVjkEzOA88gsUr/CjUBEt1EInUUmLSyhKT7bf6iS4FAfQiaSZ+uA?=
 =?us-ascii?Q?4WdWR8ZeRlDFrbUcpSKwr3jHRQmasmY4OtNlyxuiOXAJpGQNP6VBEKd0NFHR?=
 =?us-ascii?Q?bFdIoeTTO6/GJui3tm7N4dLRzMI/3K1YX90wVfi1IZ5lFWN7xjAHJgRWFOoP?=
 =?us-ascii?Q?VqODze11JmpYruPv/eeA/KypSUHmwZI7mPo2fk56Dc/fJbScBj74oiYyvLR+?=
 =?us-ascii?Q?V6QJVgKa8bjBYtD/XPRavCJP9NwzHTLlD4h/csSywWrA21nGOpv5do7oHHI/?=
 =?us-ascii?Q?CIWR5TEw5dCaGIfyD6h7p4YSscd0qzoVL7x4E2gPGnb0G5eUZQbJMFhtoK/U?=
 =?us-ascii?Q?/y/yb5lPU7i1b0OLDVCVCJpf71FJzLbTEL9GgTRfHh9vVrFiYcx0+v77eadJ?=
 =?us-ascii?Q?mdvqOjbOwZIpJYH81vVAiASShombYG3KXsU1fawdteWO4FKMKx7knFA5nnXV?=
 =?us-ascii?Q?L3mt1h44ekAMo+Msaof6n/gud48OiGpMLkjUHHAMjNU4mprrpGBNR2AlmpyE?=
 =?us-ascii?Q?ah/heuY/4C6FkRbKkk+bhO+Z6V8yDKF79KrKiFWrThz1VNNUK33jviBMvwGf?=
 =?us-ascii?Q?BmM/6YpDekG1jAL11B/CEkp8gzQ16uJlOF+8ZLiD7ifAVhP9PS9EOdgTZubd?=
 =?us-ascii?Q?fhx1zGAnS0d5aVYqsIjc9vEvVHQpL38XV/pp/ou0sa9zgldes2vYzdo8Nyiu?=
 =?us-ascii?Q?mErlKGngtwopADo4RlGT/JEf68V321fztAapiAJRwz9Pp2GXgKqSMBO2U/tJ?=
 =?us-ascii?Q?hyWNyMaBaZqnfDSc90vbstZ9xi6dAUuedLJ9Lv/YRck05IxQzXcCgKZTs8ev?=
 =?us-ascii?Q?RMO7ArG5E38VExWWny1ReJsMGp2cNknmx7TKWFTwWrPcD6ISpbV/cQG1wNWU?=
 =?us-ascii?Q?CtlJFpP/4rSIwguJ1/m9gILpY2Kt4FbDAc5QK2EX5yqRKsjG60Oz0olG5/WJ?=
 =?us-ascii?Q?NktFOwwnP6FDSa/ju76Ra0iGolK/pQ7Ol2/ILC+GL+Ws3F2+T+FKp1a9gjXC?=
 =?us-ascii?Q?KafG7s7ImpdEDt+TmkQHNwHHZoy9TOi+twKpZHwvpIDSUkLRttsKhYE7xxEU?=
 =?us-ascii?Q?pArVIcyLV6QR6zFq9MEe1JB3NkwwN9XjC64WJ9sBGVnj9EC+rFepTzl9P6Rl?=
 =?us-ascii?Q?KRMypyQTYbYeymCYrAD0pnMOYOQlZIf3padXSI71DbGeuLHyayGKkUZRgvv3?=
 =?us-ascii?Q?5mj2rTiORgDY1ZkD6cz4Xk8EmBxrkre8V51Y8AQ7IJJQrvb33sLW04xCpbBa?=
 =?us-ascii?Q?9TnWL1NWK69Kr1AwZpkKfklLoROOJu3D0gjIEdZisvT55dWjUmVcAJULOLxN?=
 =?us-ascii?Q?jR1QoQducsa6jqAC91pBRNvCdtobe+BevRsZ2qquBJ4u3JQR3CMU6dKQki5O?=
 =?us-ascii?Q?6kdW3Zve7q8BQ5IhQA2cDijAMYvCToVSNEp3NFccSYAyfknSWMpzxgpUwqx9?=
 =?us-ascii?Q?vfg11QUaomGDd9oIpLtsxAwLlv1eN9/a5uhndl8ifQ++IirInmM/kY0ZCzN4?=
 =?us-ascii?Q?ZFHD3w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1195ebea-3241-4ff3-a413-08db2e9fd8a0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 08:47:07.4212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RZ/nULwlrgTvLykjINxRbzRecICM0sn/bTjqzxTeA8S1kvgO+X+o6HgJbCRu59dV2RW9a5Nxj4g5hMl1QaM0si//034SX9e8J0wpra3zhnk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB3961
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 09:20:06AM +0100, Edward Cree wrote:
> On 25/03/2023 12:03, Simon Horman wrote:
> > Hi Edward,
> > 
> > Looks good to me.
> > A few minor comments inline.
> > 
> > On Thu, Mar 23, 2023 at 08:45:10PM +0000, edward.cree@amd.com wrote:
> >> From: Edward Cree <ecree.xilinx@gmail.com>
> >>
> >> Extend the MAE caps check to validate that the hardware supports used
> >>  outer-header matches.
> > 
> > s/used// ?
> 
> I think I meant it in the sense of "the outer-header matches which
>  are used by the driver"; I can definitely reword it to spell that
>  out better.

Thanks, I did have a bit of trouble parsing the text.

> >>  int efx_mae_allocate_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
> >>  {
> >>  	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_COUNTER_ALLOC_OUT_LEN(1));
> >> @@ -941,6 +1011,29 @@ static int efx_mae_populate_match_criteria(MCDI_DECLARE_STRUCT_PTR(match_crit),
> >>  				match->value.tcp_flags);
> >>  	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_TCP_FLAGS_BE_MASK,
> >>  				match->mask.tcp_flags);
> >> +	/* enc-keys are handled indirectly, through encap_match ID */
> >> +	if (match->encap) {
> >> +		MCDI_STRUCT_SET_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_OUTER_RULE_ID,
> >> +				      match->encap->fw_id);
> >> +		MCDI_STRUCT_SET_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_OUTER_RULE_ID_MASK,
> >> +				      U32_MAX);
> >> +		/* enc_keyid (VNI/VSID) is not part of the encap_match */
> >> +		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ENC_VNET_ID_BE,
> >> +					 match->value.enc_keyid);
> >> +		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ENC_VNET_ID_BE_MASK,
> >> +					 match->mask.enc_keyid);
> > 
> > Is it intentional that value.enc_keyid is used as the mask.
> 
> But it isn't.  mask.enc_keyid is.

Indeed it is :)
