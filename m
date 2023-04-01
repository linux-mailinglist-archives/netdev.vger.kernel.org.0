Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630486D2F29
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 11:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjDAJE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 05:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDAJE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 05:04:57 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2109.outbound.protection.outlook.com [40.107.93.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361CB6E99
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 02:04:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W01WWfwwuaMaLHjhfLKMg5fmoW1sDbWdlnQJNqhtaWy2aicMYkaWyJdRxAC2zZyhL72p7rhNjILeaZZGq/NHXk3fZOj/HNpSN2hDcUw0nYffeQw/M/LlWUp85kKmo8kShx3p+zSPd+u9RKYFVIk6nUhrA/akKtACM9FA8ltkzPre9daTvCnUecrN+H/pMxMPer0ayk7k/C9cqJoCjK0suBRgzEJDKRvbATzEeKefEx5IQjw+FvqpKE8uMvhawODDuOIzF/Z+qtV/hwfls32Pdn1Iq5bLUlfM16xiivHoGxkznWgimGQfRPhpyp5QTQVAyyyWqNNw35cF/tc8ytR1tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZWpD6AKWKrHdkQx4MoLXt5MP7rB1GAG8wsEkUTtZGpI=;
 b=NfHNwwmM3oDaEf6iI7ZENR2mpiNUfPQW7zX4D+3yv0MaTXbDTEYiHPGULqr94K/JlpjlKE0lQdgQs+9QBFSJEl3h4XRavemAgLkWaHGlKFC7k7htNu+Rw28FUkDfTXP8HS0dsZ6jnIWy0e0TnNcGVSClJY4X+UHJfEN1Nx4TqKo+rWYT/769hOyH1eZ502Vfhl6UAykLk6S9eznhb+GcVhAQioOc1fCgyOT8tBiKR702K+cvqZPGg6OkTKxAHSuhUBiC2UfMutdvk9USlU53sf90afUkasaViDkRbEAm/3pOb6Byeq0RN16ZBRIVtkmHP3YFo1eNY6bnFvgredqSNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWpD6AKWKrHdkQx4MoLXt5MP7rB1GAG8wsEkUTtZGpI=;
 b=puhR6oSA+3BCDSSLU+wY5Cuu4iMgyrQNkoqPgFjEjetPiGgaygxnhC8osEi9DnxBIyPEW8fgPwCwXGVkJ8d5/EZW5chH0XKvoI8EiqbDd3OJllhywY+q65dKRQDQXURvx3MdIGOcjlg7YrcFJ7HXMfvLzk2E+2NpA76q1BdQ6hw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4720.namprd13.prod.outlook.com (2603:10b6:5:3a0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Sat, 1 Apr
 2023 09:04:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Sat, 1 Apr 2023
 09:04:54 +0000
Date:   Sat, 1 Apr 2023 11:04:49 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        wojciech.drewek@intel.com, piotr.raczynski@intel.com
Subject: Re: [PATCH net-next 4/4] ice: use src VSI instead of src MAC in
 slow-path
Message-ID: <ZCfzsSmsrbRIBtsy@corigine.com>
References: <20230331105747.89612-1-michal.swiatkowski@linux.intel.com>
 <20230331105747.89612-5-michal.swiatkowski@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331105747.89612-5-michal.swiatkowski@linux.intel.com>
X-ClientProxiedBy: AM3PR07CA0079.eurprd07.prod.outlook.com
 (2603:10a6:207:6::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4720:EE_
X-MS-Office365-Filtering-Correlation-Id: 518e6728-621e-4482-1898-08db329028ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qWFKlW+pHtnqQBlfs/lI5q9BJOjBQaZnt5/64crMUd+RdTzy5YPqfLVe+f8W1wef237b2vtvZeoVazYzDGhxoiLtCAuyPk9CGotu3yrYeHZSqvBY11b9hGzGnlX0+k11jVCYUShT4dOlvvengOj0kaMiBZIAOHRib0Ly4gi4ESEwbCTnjcIsc2RFqBRSUphs0vfs8b5boxPaCTaGkVwvs+awnD7aRQleQa6XEbRXFPUX3sfhtrpiS8F6kcdBZMqplq2+EwVM2sRCIMHrLmgYKDs8yQSu2YQTYXkXaVkN9Cb7F2UbJQFbO0MEukfjLcE0HN5LdWgjXT7e4zQ/EfkkqBbL1jJSrwRMtTTO69S4uaX1/gUs5cs3o1KmzgzdkkjyiUWzydPRLcDkiO1jlEqBvdoO+o8YiZMOUK9mHlYju0Sa0+TLz3kkLJGdsvHjiWzGR0/p8poVGLSdRTqbhFPbFt3/dEsek99vwHeUppkGzjml2EmCFnxknzjbDEHWFrPY2Dj9Nhz2pHZgSecyZn6iVd3uNljd9b/Y23JZIquBoZQ7WHd1Yv4SjvViFQDvXyfP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39830400003)(346002)(136003)(366004)(376002)(451199021)(6486002)(44832011)(8936002)(5660300002)(8676002)(6506007)(6512007)(2616005)(36756003)(186003)(38100700002)(86362001)(41300700001)(478600001)(66946007)(316002)(6916009)(66556008)(66476007)(2906002)(4326008)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nuMfD9l9PMSHymEYwpf2UKpYyn31lx2NtTOcnp7a8olQgSAr4CF5/+xZj11r?=
 =?us-ascii?Q?zUE10oBQ5S5FruGzOd96r3xYWRcKWfcI3+boh/n08XCSJ7t7Of+kIAZprs5+?=
 =?us-ascii?Q?+Gx5AggE54HHsQ4/OFJJdeonj75delJ9yWa7++WIXpSmg+iAhwzVDeuHqlUs?=
 =?us-ascii?Q?Ro118E5LV/YGH7go6t3jnlRQ/PnKo8CfyBjjSRYnKeDlqlmOxmmSyZGTHZ5k?=
 =?us-ascii?Q?0lo0iRmqdMeIqhaj7jFcq0YUwVAiyiUDl0Pu97+CVj1FK2aRzGKBg+8kAr5n?=
 =?us-ascii?Q?FbaaqchAgvbYQ0xLCs301+fg/zcAriTAkYCsgUlgUVbuhBRtgBJXO2CafcvU?=
 =?us-ascii?Q?ct0st2LGHH/LJDCyG/5LkITQRSeOUDv6qWT8T8LuOlBeYi2StQQ4Y7pjq0QH?=
 =?us-ascii?Q?gqM2brSK9gCo96SSKQZvtPqilDPkWH7ZQefVJSnIbNr9FRDomrPB9Pu2PzIk?=
 =?us-ascii?Q?giQQVokfwoLE3LGXC6fQoBW99dC9KxXAus/08IjY8RIqgi8GaokQnDHPdO1U?=
 =?us-ascii?Q?H2CIJ1dAMnTTVt6sXxitgKOb5k2Asnx+DqqsJ3oipvnuB6xlxVzSyd/qkLvd?=
 =?us-ascii?Q?wx4i2P0n55ZficgnSTZQh6wAzGq0PnzKQsd8+V3bpjchPXSMZGAt4wVmr7/M?=
 =?us-ascii?Q?Gai5CC4HqVxeyA4NnNfzGlK1kcVtKumZrWsbWqRtL5Z6Nn0W+h9iEgSgL504?=
 =?us-ascii?Q?eRT810+P7khIl4v6q68dVB6HpDwCW1mrTW5bCySVrA3kMw/wdIm30yl9UCCr?=
 =?us-ascii?Q?/ZK76+u4bwKoZP3lKydwselVkdKmIY2Ziu/3PxpcvMKU8/7BnlUDOIItbOoN?=
 =?us-ascii?Q?weCAeGMXzec0uSeRvJ6V7O6ap4H7nXy9RHvox4xtliu4EXkaWvVaEccHYLCR?=
 =?us-ascii?Q?EKjvxw6LuBmPc48yrjvpYRhqhlfWnJDKQ3NNeiccjGqHs/WR3Oi2EFyQejIE?=
 =?us-ascii?Q?bbkfFQyMcsAaOCl9TUD6xMR2yzZhVZulCLuu501qMzDD34FCN76EQnTinUZi?=
 =?us-ascii?Q?TQV+1rDVt5lHWsKOS/uWViFQ+MB7Kt9/XxSfxoilHzbIs01yWurj5EyCAV1t?=
 =?us-ascii?Q?MxLPtJkLlDh5tn8WXArOXWgi/RNTxjgOL/lqtuUHlIIOp+DCvYfIt/ty41+N?=
 =?us-ascii?Q?gzHhfnlGX8z7kwOCHt8N8Gwdgut29HRgriT0zxfDdvfy9Z72LKlGKG7Cttln?=
 =?us-ascii?Q?ziUxSmOYUXjdbSQ1eKDsmFwcvI0V9lT1+G8rNszIVQpkRUNUnUBSmJRSU7Zt?=
 =?us-ascii?Q?txo67zS5sdZicG3cUOqrEofcQN72yeYHauUb27U7U4EahL54jf/3ZuSNLu9l?=
 =?us-ascii?Q?JAwQc2KXGRqS+Pwip8at0DulixVGsS07uiQ1gAAUPHqexrNBGu81CeTsQhx/?=
 =?us-ascii?Q?by+y4B7WDOmwb6xHQ82a8pc4d73lMEHCdjlttDhe1C5Q5MZLaZpGGYqO6Tln?=
 =?us-ascii?Q?mk7c+wTwYxa8DKzrNfy3dxmwIz3ik/ElgtGHMVt+EC01RpChcJs3DOWR6GiY?=
 =?us-ascii?Q?kmrkpdt/JKXqdezn2ic8GLA7+XOFS+X5rvLy2QRkFCHEOwHSGlNOWR7/IjHl?=
 =?us-ascii?Q?uoymtx1OLy4HSXcE/XUn/GxOjb2jylYMwle5IE2/R0BmluWiB2dlEQsgEKM/?=
 =?us-ascii?Q?DwBIWwXHyEW+QjbqI08gfc1g2QvIqX5aRzzENA42yFbAmSTZ7Ri7hr1Ur7Bu?=
 =?us-ascii?Q?OyY2jg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 518e6728-621e-4482-1898-08db329028ab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 09:04:54.3373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 36+5dcHDpofn86oxPIY8kHRmUsDiWhwMPjBl7dqczwz38qIy6kzeYm/7Q3ps0eSf5PDUofsqGvBbuEdaY9EIhH4gw4r/sMHbkyyiUJqKwMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4720
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 12:57:47PM +0200, Michal Swiatkowski wrote:
> The use of a source  MAC to direct packets from the VF to the
> corresponding port representor is only ok if there is only one
> MAC on a VF. To support this functionality when the number
> of MACs on a VF is greater, it is necessary to match a source
> VSI instead of a source MAC.
> 
> Let's use the new switch API that allows matching on metadata.
> 
> If MAC isn't used in match criteria there is no need to handle adding
> rule after virtchnl command. Instead add new rule while port representor
> is being configured.
> 
> Remove rule_added field, checking for sp_rule can be used instead.
> Remove also checking for switchdev running in deleting rule as it can be
> call from unroll context when running flag isn't set. Checking for
> sp_rule cover both context (with and without running flag).
> 
> Rules are added in eswitch configuration flow, so there is no need to
> have replay function.
> 
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
> index 20f66be9ba5f..1b739e096d27 100644
> --- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
> +++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
> @@ -256,7 +256,9 @@ struct ice_nvgre_hdr {
>   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>   *
>   * Source VSI = Source VSI of packet loopbacked in switch (for egress) (10b).
> - *
> + */
> +#define ICE_MDID_SOURCE_VSI_MASK 0x3ff

nit: GENMASK might be appropriate here.

> +/*
>   * MDID 20
>   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>   * |A|B|C|D|E|F|R|R|G|H|I|J|K|L|M|N|

...
