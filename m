Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADBCB68A928
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 10:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjBDJT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 04:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBDJT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 04:19:27 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2132.outbound.protection.outlook.com [40.107.94.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC3827D55;
        Sat,  4 Feb 2023 01:19:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jsRS64hu92wtEUNgxCnFxRHa5eOGrWkTiGsH6tQ0vtBVvSMuLr2/D1DVMggqBTuj3ZEFmDyIageLkqp85Z3wiYBWn7/zudZQcy2366d/+ci83qrs3Zb9bJ0PII2jMgxdiWJai7gD/pjPVuyM0UOnmkWuP7RHsMIuIdWftAWtVAXKjRgvvxFsTx7Q+J6ZkphnxWGp6uddlvQuM9X+uIoopAWo97KB9kDlGxxsWE2ch0ADY5vTd3QHgSYJw5PmiYYvBDS6rPFsP9bmQD2cBPZYeAnMm526mgdMRZ9uWu6CXXNWTEYbIy9k2BFDxaiQGfbB6QcJATkp4mb0SIn4bgnB5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bINlr4PVCiBjVh26E+1JCUxP/WHwR//Zhk8VbwwqMsU=;
 b=Nw0pP0Dc2BNmb0/WWLe44VUT8snOjRtH1P4IQWyK2QmMjDPBcXy0/qFTFc33j3jsgGuCQZYV+rYYywqAkw5udgnyOuWAZaByqxxG7skVYJ37k5/JVy9e5OllGFnD/xifMc59jedgpTVEV87mvpGySeHyQfGSnxcCQMeYPwWI2N0GnpJ/sJjVYuqY2Ib6giXAD8iGvVdom/jC2Y5uGl3HI4oiVKCn09hS3xxasXLBtCZNlr6OiJ9laeTKUSDq/7TRN6m8MGQxJdvyRyAmvZV9gFAmCtTEY/yxVKSIlvDDpaj/S7v7S7bkVoSrJ3UJvWoO4i4TTVJJ7jEOvyZpat7y3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bINlr4PVCiBjVh26E+1JCUxP/WHwR//Zhk8VbwwqMsU=;
 b=BV+Qj1VWtkR/t0bfY31zzmQlV9oR43T1QHLQA1HYlY0jpbqLinl2m166PnDr/OwQ6tidxItUKYwJ550X5TlVTEaUOv1vwUU0uTkWvR7gKRiacykhHwZgy8gHnFKMVuvqm8Mb8gx4YVY+EHisgeUYQV4URtapNtG2EmNuX/g5RAg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5759.namprd13.prod.outlook.com (2603:10b6:806:216::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Sat, 4 Feb
 2023 09:19:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 09:19:21 +0000
Date:   Sat, 4 Feb 2023 10:19:14 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Peter Delevoryas <peter@pjd.dev>
Cc:     sam@mendozajonas.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, joel@jms.id.au,
        gwshan@linux.vnet.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 1/1] net/ncsi: Fix netlink major/minor version
 numbers
Message-ID: <Y94jElt1s0vxBi8p@corigine.com>
References: <20230202175327.23429-1-peter@pjd.dev>
 <20230202175327.23429-2-peter@pjd.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202175327.23429-2-peter@pjd.dev>
X-ClientProxiedBy: AM0PR10CA0118.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5759:EE_
X-MS-Office365-Filtering-Correlation-Id: f003564f-66cd-442b-a615-08db0690e660
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lLJ5sAQ8azNbFm8so9NeOEjWmxQXQxOrud7uSLIHUdKUB6+pquS79wob+XElxo1LMaaS1yvM6r581Sx+3DfSa69OSFKW54iIM09wZgk/0K0MCVKEb2CLVlkwr7ZI9+/G2SPCqZNOMAdtdjyWhu8DZil7aTn0AU+biKykqDkuWp8sJxu5tclESZDhJQgfcK+xWP1MvWPpxsBavm0tZBiKqxSGKS/lYuhfaNRJvQX5yE1uDGwFx8f0V/3WYHkJmH2w4GZbsaNs0zdhmL+FeWupxP6wQV4mJgVJTM1K5wj+2Lssfv7SwsuiCcjACguhKcBQ2YcubuP9h4BbWyzogpyhVFHsF2RevxVkL5Q/rZIPwt0jr2rAXF3VPpeBX5UEsoLMEAn9HIVgiggi+/UlGAqfWnBo5IAGM51yRaG3MlVqxzvbk+lkMp6mQZzbpbnlWZWOf5OPkiUSMYdQebc+hM5F5nqp2ZP99BMgQ4mF4XYVZr/kXCRmOuVOlyr3d3GTY8TwOqE/lxkSHLNl5EDGlJNrSjWCsGpp6y8uuFIqE8oOwund6RW8qn7HBboN1geuQoFQOMqB+M+HDl/AoKQlebUQqC8tJbHqTJXXzIDgybJf3KAgBmsJPYdqEH/vG/xshBUp5tnW4qgUt6bO96fZubgG/30yBRTnZ5d9Kpvb3ioQ5hHR3YlPXw2d2leZDRKRJBDT2l5xoZOq9l922zkId/viCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39840400004)(396003)(366004)(136003)(451199018)(5660300002)(7416002)(2906002)(6512007)(186003)(83380400001)(8936002)(86362001)(41300700001)(44832011)(38100700002)(6506007)(36756003)(478600001)(316002)(6916009)(4326008)(8676002)(66556008)(66946007)(66476007)(2616005)(6486002)(966005)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gqGi5v7uUTwDcDNvo9HnzoYV+ttrtBsFbnA4p2LPPBRVASIKMlIq80acFKai?=
 =?us-ascii?Q?d0PlkXcomhbL619WDFEkmNeRQlr8l1MVhJsDkOEiJjLHH6myNiS4emA6VNWb?=
 =?us-ascii?Q?4jegri+ABo1oQ2Ts5fG1vs/XcYX+Ew4xQ8qfjDMD7577ViDKv55rgEOSPgL5?=
 =?us-ascii?Q?0JuQJzpl40YgGO9TDA9tYHr3XpL1r6GJgo9Y3NRnl9P3KFiK5Tru1wIZYMS8?=
 =?us-ascii?Q?UV+uzVngCeTAg6Dr0ADZy6+vaBwxYqYxhoqdRvG9letjsuosKAeRg7HIPdWp?=
 =?us-ascii?Q?kwyw+eXH64FhGlWLxjnb/SFIm3PlsOBI7GW1N9UbMpcfwFv+E72FuJhlSBji?=
 =?us-ascii?Q?9A1dgM0cQ55W8kd1kULoVNKjsxtBDpfHULQXeYOkqUvoJBICmuukXVLCCzRR?=
 =?us-ascii?Q?TReFVUSej8y/JEVwR5oz1l1pE9kNpHgRi2KGEtLfZ+P2SHZc2Noc0/qMjo0b?=
 =?us-ascii?Q?IUkN2y9x4s5W4A/qvevkz3uMlS6zZuUb05nDjXwn6y8mDOeJ0v8Bb0og7RMJ?=
 =?us-ascii?Q?IoaZG+OrMkYEhTEj7odFTKvvXZtIbqqreywu7Sy5d6IOZRfACKIuZkaG8WVE?=
 =?us-ascii?Q?HlQCUPAHz8UV36D8IVcctwqkMw6sbVGsfliBf/pyW8Nkehpb45hmc8+eMczU?=
 =?us-ascii?Q?pSZY3Qo1TZg5JwQwgCzryisM81uE42dfREnswx/CgpMTpmwxMhgqHLCWtp3n?=
 =?us-ascii?Q?5Y6W5jOIN7lNjYpcioNqcvF/BfP/ByA3IpEipCt598tyjImTzFY8iXCRp+F5?=
 =?us-ascii?Q?xEi0Ex8HSFLL86ZQpEQKkan0OK0o7I1fbJoyDVuTxVRaSsVc00zFzRoH0K0l?=
 =?us-ascii?Q?fYuLlDthZei9EMXpebfLmwjwZhpb257+Ey98v88rOW9dHPNqFwOLtmtsizaj?=
 =?us-ascii?Q?CIrLaJ4TGbyCvmwjmzWrfGP9d7tOY+cu/BTgltvrnOECsSFTrVcgMITtlDGg?=
 =?us-ascii?Q?f7kBF2IR82DIdAOMzLMVuP9xulQvzSSL2RZZISnWNeLFY/vwvdIZVepBUb5V?=
 =?us-ascii?Q?BBX9K9oXL18KxMHufYVUCzTuoFaS6w2PTzLp6PyTq0lDn44z2aLHr4WDgOEC?=
 =?us-ascii?Q?P9HsNHBJiK9TV0iJqSg8ffbw5Jmab6W7fhIjl7mgx7/aUPvW7PFyB4Aqds9K?=
 =?us-ascii?Q?QwtPdXyJ+XLtQjsteyLv2uXjDGQhSKAHBHvG1jz5amEvrVu5Fh4U4o4YpjCn?=
 =?us-ascii?Q?qh8QJ8M0fldEC29jndOHi7M1H8FxIuQKBFFCVMmtWlzCHDFfWT2uCFZWHAfI?=
 =?us-ascii?Q?QPb9Og8Bo2Ab6/PXtjPijed4a5Ab6n+IrRqIfMoL7suPrLt71RoT+6Q6h4hP?=
 =?us-ascii?Q?dO6ptqdGKgJtVgBAyN+Qwq1w3Ctwbc9KyFCy/Op/JchbaImfT2VFeO+w3AgH?=
 =?us-ascii?Q?dCp1VqHaUE2eRwHGI2ip2i1zJ8xCFAyA4/7Ah+oXOrBL4Cr5ptwMjZ8aEkCf?=
 =?us-ascii?Q?9VciOAPZTPN0/LI7ekCQVZ25/mQP6vWJN71p896IVefphAzWDgq1CPrAqWak?=
 =?us-ascii?Q?9MipSeHdv/4W2JNTMzWxZfuo1sNHiUw67utsU4RxEv83nXsAHscEfhgS5SHx?=
 =?us-ascii?Q?8abALVsrDTK6fK6HzhIS0gwyznjZmyA2HUhxpEjq5lJ1BQZi+ahfCMYWei/v?=
 =?us-ascii?Q?dIQY/Q5r23zHtiRGaCYjyS6IpeHVjUzkQ4L+mEKqbznlsC2RjDgQmkNwKJoi?=
 =?us-ascii?Q?7YTd8A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f003564f-66cd-442b-a615-08db0690e660
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 09:19:21.6332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WULmb+oies4E5ZNR7fx/adnr9LVpq/240G00wEIJ0d8ycbfmynvhI48D0pVns16Mv88UNPgqSyjNAYgpCuP7xv17R/FlMGslAvoct50hpOg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5759
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peter,

A very interesting patch. My review below is based on the information
in it, and the references you've provided (thanks for those!). My prior
knowledge of this specific topic is, however, limited.


First, regarding the subject. I see your reasoning in the cover-letter.
But this is perhaps not really a netlink issue, so perhaps:

[PATCH net-next] net/ncsi: correct version decoding

On Thu, Feb 02, 2023 at 09:53:27AM -0800, Peter Delevoryas wrote:
> The netlink interface for major and minor version numbers doesn't actually
> return the major and minor version numbers.
> 
> It reports a u32 that contains the (major, minor, update, alpha1)
> components as the major version number, and then alpha2 as the minor
> version number.
> 
> For whatever reason, the u32 byte order was reversed (ntohl): maybe it was
> assumed that the encoded value was a single big-endian u32, and alpha2 was
> the minor version.
> 
> The correct way to get the supported NC-SI version from the network
> controller is to parse the Get Version ID response as described in 8.4.44
> of the NC-SI spec[1].
> 
>     Get Version ID Response Packet Format
> 
>               Bits
>             +--------+--------+--------+--------+
>      Bytes  | 31..24 | 23..16 | 15..8  | 7..0   |
>     +-------+--------+--------+--------+--------+
>     | 0..15 | NC-SI Header                      |
>     +-------+--------+--------+--------+--------+
>     | 16..19| Response code   | Reason code     |
>     +-------+--------+--------+--------+--------+
>     |20..23 | Major  | Minor  | Update | Alpha1 |
>     +-------+--------+--------+--------+--------+
>     |24..27 |         reserved         | Alpha2 |
>     +-------+--------+--------+--------+--------+
>     |            .... other stuff ....          |
> 
> The major, minor, and update fields are all binary-coded decimal (BCD)
> encoded [2]. The spec provides examples below the Get Version ID response
> format in section 8.4.44.1, but for practical purposes, this is an example
> from a live network card:
> 
>     root@bmc:~# ncsi-util 0x15
>     NC-SI Command Response:
>     cmd: GET_VERSION_ID(0x15)
>     Response: COMMAND_COMPLETED(0x0000)  Reason: NO_ERROR(0x0000)
>     Payload length = 40
> 
>     20: 0xf1 0xf1 0xf0 0x00 <<<<<<<<< (major, minor, update, alpha1)
>     24: 0x00 0x00 0x00 0x00 <<<<<<<<< (_, _, _, alpha2)
> 
>     28: 0x6d 0x6c 0x78 0x30
>     32: 0x2e 0x31 0x00 0x00
>     36: 0x00 0x00 0x00 0x00
>     40: 0x16 0x1d 0x07 0xd2
>     44: 0x10 0x1d 0x15 0xb3
>     48: 0x00 0x17 0x15 0xb3
>     52: 0x00 0x00 0x81 0x19
> 
> This should be parsed as "1.1.0".
> 
> "f" in the upper-nibble means to ignore it, contributing zero.
> 
> If both nibbles are "f", I think the whole field is supposed to be ignored.
> Major and minor are "required", meaning they're not supposed to be "ff",
> but the update field is "optional" so I think it can be ff.

DSP0222 1.1.1 [4], section 8.4.44.1, is somewhat more informative on this
than DSP0222 1.0.0 [1]. And, yes, I think you are correct.

> I think the
> simplest thing to do is just set the major and minor to zero instead of
> juggling some conditional logic or something.
> 
> bcd2bin() from "include/linux/bcd.h" seems to assume both nibbles are 0-9,
> so I've provided a custom BCD decoding function.
> 
> Alpha1 and alpha2 are ISO/IEC 8859-1 encoded, which just means ASCII
> characters as far as I can tell, although the full encoding table for
> non-alphabetic characters is slightly different (I think).

Yes, that seems to be the case. Where 'slightly' is doing a lot of work
above. F.e. the example in DSP0222 1.1.1 uses 'a' = 0x41 and 'b' = 0x42.
But in ASCII those code-points are 'A' and 'B'.

> I imagine the alpha fields are just supposed to be alphabetic characters,
> but I haven't seen any network cards actually report a non-zero value for
> either.

Yes, this corresponds to the explanation in DSP0222 1.1.1.

> If people wrote software against this netlink behavior, and were parsing
> the major and minor versions themselves from the u32, then this would
> definitely break their code.

This is my main concern with this patch. How did it ever work?
If people are using this, then, as you say, there may well be trouble.
But, OTOH, as per your explanation, it seems very wrong.

> 
> [1] https://www.dmtf.org/sites/default/files/standards/documents/DSP0222_1.0.0.pdf
> [2] https://en.wikipedia.org/wiki/Binary-coded_decimal
> [2] https://en.wikipedia.org/wiki/ISO/IEC_8859-1

[4] https://www.dmtf.org/sites/default/files/standards/documents/DSP0222_1.1.1.pdf

> Fixes: 138635cc27c9 ("net/ncsi: NCSI response packet handler")
> Signed-off-by: Peter Delevoryas <peter@pjd.dev>
> ---
>  net/ncsi/internal.h     |  7 +++++--
>  net/ncsi/ncsi-netlink.c |  4 ++--
>  net/ncsi/ncsi-pkt.h     |  7 +++++--
>  net/ncsi/ncsi-rsp.c     | 26 ++++++++++++++++++++++++--
>  4 files changed, 36 insertions(+), 8 deletions(-)
> 
> diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
> index 03757e76bb6b..374412ed780b 100644
> --- a/net/ncsi/internal.h
> +++ b/net/ncsi/internal.h
> @@ -105,8 +105,11 @@ enum {
>  
>  
>  struct ncsi_channel_version {
> -	u32 version;		/* Supported BCD encoded NCSI version */
> -	u32 alpha2;		/* Supported BCD encoded NCSI version */
> +	u8   major;		/* NCSI version major */
> +	u8   minor;		/* NCSI version minor */
> +	u8   update;		/* NCSI version update */
> +	char alpha1;		/* NCSI version alpha1 */
> +	char alpha2;		/* NCSI version alpha2 */

Splitting hairs here. But if char is for storing ASCII, and alpha1 and
alpha2 are ISO/IEC 8859-1, then perhaps u8 is a better type for those
fields?

>  	u8  fw_name[12];	/* Firmware name string                */
>  	u32 fw_version;		/* Firmware version                   */
>  	u16 pci_ids[4];		/* PCI identification                 */
> diff --git a/net/ncsi/ncsi-netlink.c b/net/ncsi/ncsi-netlink.c
> index d27f4eccce6d..fe681680b5d9 100644
> --- a/net/ncsi/ncsi-netlink.c
> +++ b/net/ncsi/ncsi-netlink.c
> @@ -71,8 +71,8 @@ static int ncsi_write_channel_info(struct sk_buff *skb,
>  	if (nc == nc->package->preferred_channel)
>  		nla_put_flag(skb, NCSI_CHANNEL_ATTR_FORCED);
>  
> -	nla_put_u32(skb, NCSI_CHANNEL_ATTR_VERSION_MAJOR, nc->version.version);
> -	nla_put_u32(skb, NCSI_CHANNEL_ATTR_VERSION_MINOR, nc->version.alpha2);
> +	nla_put_u32(skb, NCSI_CHANNEL_ATTR_VERSION_MAJOR, nc->version.major);
> +	nla_put_u32(skb, NCSI_CHANNEL_ATTR_VERSION_MINOR, nc->version.minor);

Maybe for backwards compatibility, NCSI_CHANNEL_ATTR_VERSION_MAJOR and
NCSI_CHANNEL_ATTR_VERSION_MINOR should continue to be used in the old,
broken way? Just a thought. Not sure if it is a good one.

In any case, I do wonder if all the extracted version fields, including,
update, alpha1 and alpha2 should be sent over netlink. I.e. using some
new (u8) attributes.

>  	nla_put_string(skb, NCSI_CHANNEL_ATTR_VERSION_STR, nc->version.fw_name);
>  
>  	vid_nest = nla_nest_start_noflag(skb, NCSI_CHANNEL_ATTR_VLAN_LIST);
> diff --git a/net/ncsi/ncsi-pkt.h b/net/ncsi/ncsi-pkt.h
> index ba66c7dc3a21..c9d1da34dc4d 100644
> --- a/net/ncsi/ncsi-pkt.h
> +++ b/net/ncsi/ncsi-pkt.h
> @@ -197,9 +197,12 @@ struct ncsi_rsp_gls_pkt {
>  /* Get Version ID */
>  struct ncsi_rsp_gvi_pkt {
>  	struct ncsi_rsp_pkt_hdr rsp;          /* Response header */
> -	__be32                  ncsi_version; /* NCSI version    */
> +	unsigned char           major;        /* NCSI version major */
> +	unsigned char           minor;        /* NCSI version minor */
> +	unsigned char           update;       /* NCSI version update */
> +	unsigned char           alpha1;       /* NCSI version alpha1 */
>  	unsigned char           reserved[3];  /* Reserved        */
> -	unsigned char           alpha2;       /* NCSI version    */
> +	unsigned char           alpha2;       /* NCSI version alpha2 */

Again, I wonder about u8 vs char here. But it's just splitting hairs.

>  	unsigned char           fw_name[12];  /* f/w name string */

Also, not strictly related to this patch, but in reading
DSP0222 1.1.1 [4], section 8.4.44.3 I note that the firmware name,
which I assume this field holds, is also ISO/IEC 8859-1 encoded
(as opposed to ASCII). I wonder if there are any oversights
in that area in the code.


>  	__be32                  fw_version;   /* f/w version     */
>  	__be16                  pci_ids[4];   /* PCI IDs         */
> diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
> index 6447a09932f5..7a805b86a12d 100644
> --- a/net/ncsi/ncsi-rsp.c
> +++ b/net/ncsi/ncsi-rsp.c
> @@ -19,6 +19,19 @@
>  #include "ncsi-pkt.h"
>  #include "ncsi-netlink.h"
>  
> +/* Nibbles within [0xA, 0xF] add zero "0" to the returned value.
> + * Optional fields (encoded as 0xFF) will default to zero.
> + */

I agree this makes sense. But did you find reference to this
being the BCD encoding for NC-SI versions? I feel that I'm missing
something obvious here.

The code below looks good to me: I think it matches your reasoning above :)

> +static u8 decode_bcd_u8(u8 x)
> +{
> +	int lo = x & 0xF;
> +	int hi = x >> 4;
> +
> +	lo = lo < 0xA ? lo : 0;
> +	hi = hi < 0xA ? hi : 0;
> +	return lo + hi * 10;
> +}
> +
>  static int ncsi_validate_rsp_pkt(struct ncsi_request *nr,
>  				 unsigned short payload)
>  {
> @@ -804,9 +817,18 @@ static int ncsi_rsp_handler_gvi(struct ncsi_request *nr)
>  	if (!nc)
>  		return -ENODEV;
>  
> -	/* Update to channel's version info */
> +	/* Update channel's version info
> +	 *
> +	 * Major, minor, and update fields are supposed to be
> +	 * unsigned integers encoded as packed BCD.
> +	 *
> +	 * Alpha1 and alpha2 are ISO/IEC 8859-1 characters.
> +	 */
>  	ncv = &nc->version;
> -	ncv->version = ntohl(rsp->ncsi_version);
> +	ncv->major = decode_bcd_u8(rsp->major);
> +	ncv->minor = decode_bcd_u8(rsp->minor);
> +	ncv->update = decode_bcd_u8(rsp->update);
> +	ncv->alpha1 = rsp->alpha1;
>  	ncv->alpha2 = rsp->alpha2;
>  	memcpy(ncv->fw_name, rsp->fw_name, 12);
>  	ncv->fw_version = ntohl(rsp->fw_version);
> -- 
> 2.30.2
> 
