Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78D46CA088
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 11:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbjC0Jxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 05:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjC0Jxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 05:53:44 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2104.outbound.protection.outlook.com [40.107.243.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA23A49E9
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 02:53:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZlLsRReBH/80Xq7RfGifAlY5W5/SH1K8m2cqOEQIV4LhjEzIsm0NwuowVQwOJb16fCgGQsVOw+BFAiswTRKOKp+ZrhNl/qNeKE/fwK5q75Mf1+6DKc41WLuJSQFymsVuRvLV4zrM0/e+VZ5l+r+zJUFl7Rdst9r6jQ6NQ3OhC9NrKLQzr08KaFsr6xTHZ19E/RYAvXTv6qdQkP7kxTx8yP770txHiFAej2YC8FKRyg2THUXdYDqF81xWhpJUHvMuZJJc0Rq9V9F1evfKDPSIdGyEbxIeNc4CR98aAkZItNTJbHFmIwBwrthqq24W9GWRb40Oithnb5f6EJcelhvrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8WncfpI9TH++Yt10cQ5aiv/eIzqhDZTlfA0BJjDps+U=;
 b=aX8mpMFF81LZivvO2GOUXNnXH9+MRHZxug6Skh9kAcYtnjosQUlJWLC8E/JWyBwIoGpqQ7YSotDLlDRjq4+u4RdSxBFeeJa4yXK+bZJ8TrRERFprZg+KfNJmNen3TdEZcH+0e1IPSbCz8P9dgKLnYwbEBaEHZt/IhzGv4/c/Jsr7aCN1+uoT+LBgobrJ/PI0sfStl8UYSUOAlGQpuqGGz6fyMNlbHMbDBQrQNvAJ5WaNIOhYOIuYdyUcObg0B++Up5lwOoHjJ4bEq/eqoEdJ8447/GS0GgC247RiH5ecSjBajPDYXLS/5trWUS9JtdJti3AhriBd1/LkvGj1hamVMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8WncfpI9TH++Yt10cQ5aiv/eIzqhDZTlfA0BJjDps+U=;
 b=niH1FKc10KkGYx3OgyWSr3k8LJtuleEDT+2cRBy/COTm+bbjCxvl6fvov1HnJn0X03zKK55b33OrOf8ZWIoiclhWqHrTEFYswu7DQ9in5JLqWlgYxtZAsR7J/CeiafijvKt2dATOT/WQZnDMQBR0xqVOtA4TlQv+tlxG2sxEIKU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6090.namprd13.prod.outlook.com (2603:10b6:510:2bd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Mon, 27 Mar
 2023 09:53:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Mon, 27 Mar 2023
 09:53:40 +0000
Date:   Mon, 27 Mar 2023 11:53:34 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 2/6] mlxsw: reg: Add Management Capabilities
 Mask Register
Message-ID: <ZCFnntC6T026tfFv@corigine.com>
References: <cover.1679502371.git.petrm@nvidia.com>
 <21a273b68773c4cbc47dbc4521cbc7dedc3391c4.1679502371.git.petrm@nvidia.com>
 <ZCBQcoypD44Upn9w@corigine.com>
 <87jzz2o7hu.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jzz2o7hu.fsf@nvidia.com>
X-ClientProxiedBy: AM4PR05CA0003.eurprd05.prod.outlook.com (2603:10a6:205::16)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6090:EE_
X-MS-Office365-Filtering-Correlation-Id: 7937bcb1-764a-4ad6-d45e-08db2ea924ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PyUSWia747h4jP/Fb3cfBQFr53Jh+csQsjW8b2VYO3/zr7u1Q1JH8sUDO6jfIOt7gF3aObfqpo/6eVy/ygwlxrkIAW0H4waCTAj7UMHAbQshCQHMojppFtzxNjP/k9wt8+EEWSlEGy0PGRRv+R68vrCC7XCDYqxxVZRMAklD52ydT6RtWqOPaGpz15sZ5D6HVIuArQ+IUwBkZlte0bhtLuAE8Gjev7KtlIvFqTW7DTHtreNKJmqOvq6FUtQcF4FCn4Z+cHKqqnC9LAVCGnaLPka9VsBYHAVeugn2iZ/gmyTUfQmgQ+Fn8M0iWJYGdltmL1ZGy9/UdAJAj7D+vlDpwsu5gD3kZjsXy/BQR3zEdIbWU2kMf6zudxzZHqWioFXIoRWXPq8kSxUfVRzJXhvNnme86FOvO/os30lFt3axt0v7l1jcdPUU+jEoM0s1KOQVP6QoTivwy3XSXz5ZdRLc4rcdLT3GQyIUAIH450RxRgBYYJ2Cu6kadPCh3AZ43aQIf1xRUB6R+vQDto6c+wpUKQe6dvX77RMuk/EfaC7MtFF5jdEq/l9zu2qwI26wPjNk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(376002)(39840400004)(136003)(451199021)(6506007)(6666004)(186003)(66899021)(66946007)(38100700002)(36756003)(54906003)(6486002)(41300700001)(316002)(8676002)(86362001)(66476007)(8936002)(478600001)(66556008)(2906002)(6916009)(2616005)(44832011)(4326008)(5660300002)(6512007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PK32U2rSV7awnmaRAW8dsO6UXgYM/EOojz8NKmGj4j1piIHNq9LcX1byNbjA?=
 =?us-ascii?Q?N0647yab7OOKqhE2ySaIQqi2+bKM5R8XLiurkvdahmRj1lsnSgfGSLqRcWCp?=
 =?us-ascii?Q?EkhPylgQgqGVHP2wJCGqhUdcJXb+SApJSK/Ds4y/RcsuGC/iWa19gy6oNBOt?=
 =?us-ascii?Q?YL+O7rW+4Raoi8KCky3yd3AnNYE1I2I90GKQefzVOPLww61VJpChrO6RGtZL?=
 =?us-ascii?Q?TOjRIk07PJ3KiXiWuLV+70NaBcwkVEr8DauLDW3yeepWPlZQCVtGzcfMSjcO?=
 =?us-ascii?Q?4nTSM0+fq1lTS79+mTDSydYX+ZBHoxu/ebL8AmdwSFBeySzFzjjgldIVbUWP?=
 =?us-ascii?Q?Pg/0TKFObWymqVWMj6zdmml4NPYJDZcNWI42jZkC8nINuMcQmdbRFTu1U29/?=
 =?us-ascii?Q?4M2wJDTF8H0W2aoyckQB9o+1tJdrQUb7XGda+dIaD3961l8A9ZpwsK2xFGxS?=
 =?us-ascii?Q?wyeabncBEqMmZvnPg+hoLiyZtYyIm2er4702c+SxCK5jwvwatUI/7xsDp8/N?=
 =?us-ascii?Q?ewSdJQg8cnSCqEC2USBXvPZi2OpjrOmNDWmj6Qv7g+aSQnit3QaITqMB/bsq?=
 =?us-ascii?Q?/kwsI077Vx17rYkszRSDxTkyvdzSHN/cioC1FsQ1GBvF7/WvFaKnYVUy8SA1?=
 =?us-ascii?Q?AwIsflecMmsjjEHrwkOGXuTIDoCBeuhv6jiNmdqEk7aS0g41pB2Cf/HAbH7I?=
 =?us-ascii?Q?eNfFCe5ajHcraYA9RSRCrRoR2PHoo6sa1RoGd1k+zAAMtemOBDZ0pP2E2XDY?=
 =?us-ascii?Q?PD7hz0EsiXcobY46KaggcREvFTtb/uXII0q/iFgU04D2pifmrrUe2Wtj4MAl?=
 =?us-ascii?Q?8z2MS0tGz3VsC1hlemJlo0d2edgRaeJXsc7LwQ05t3bldmG9wzSBSsm1r+el?=
 =?us-ascii?Q?WYgv6uGnh4uRV+fIO/pcJsjmV4JxlrJR+fOvblinny0bo85jkzZFwFgRmhAu?=
 =?us-ascii?Q?q7IxMGkR6bxgerJmtdS9E201Azia8QXtZUnxiEnbMJ9/2qGn1+D2s9RdlSwn?=
 =?us-ascii?Q?QqrOlZT+/34SQfhr/jdmiOPmJWbdP7ujSJZGpUciTWKSmLddMtpG+HEK2F24?=
 =?us-ascii?Q?jTFDtex0nSBdGS2dn5FwoHEzZ/2je1ZjkuOoPJ5DTf5aady1r8KhKdFP2A/o?=
 =?us-ascii?Q?bycCXksz1usPgzhGZo0WEk8YCxqwk7DdZBv+I/W0Tfj77d65v/I/k5o375IP?=
 =?us-ascii?Q?LxoHtjXBQldLdvCITjGR+blKjj87izVAt3TosdP2pVOzGpaKSxrog5qVTq2p?=
 =?us-ascii?Q?U2+lRCWHx3P3J8Rb87qWjjFvb9a2Jswrsaj3dgjGgUQ+OLWzbti69hCI23Ju?=
 =?us-ascii?Q?MaCKNrau4DP3aSdLtf4DI6zxdoizQIVN8NvgT/IkeOx+ATy+vXp0OQ/bSKI2?=
 =?us-ascii?Q?hT9aPwx02/BpawKm3lCwijkZYBiV6vkD1+8fgDFdLzPAgOE8PWjRUQNaBZV+?=
 =?us-ascii?Q?sq/dJA6vokZ7CbYmXrcWRwn3tFqWItAjIBO79jrUJjetkojDnCaXE2opHnWZ?=
 =?us-ascii?Q?vzFWHVb/wCRq9djPeL+sw8qQxj9Sj3OctWkosb9gQN69O/tYfPGpZrlMkiSS?=
 =?us-ascii?Q?38FnytzQ/6JRceZXDUi6CHgBCqOLdkWad3C+CYUgagDaUuK42ujaaEtAimUE?=
 =?us-ascii?Q?qPH5+TxdVR9C7zOaZXjogW0pol1zGsgmI/jRpniZGBFYrq1UvanG46lqZAqm?=
 =?us-ascii?Q?nLLAPg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7937bcb1-764a-4ad6-d45e-08db2ea924ae
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 09:53:40.4930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U1SDwRL+ryhW24tSUAUApLd9AFCQoLZpjepqPMIMMHjQ8mIVOfKYJd5+/Dy0te3bla9ZlHRGhjAsG1wv9e5LNV2Bw4HqQBZG0Y7EmS6IhIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6090
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 11:35:24AM +0200, Petr Machata wrote:
> 
> Simon Horman <simon.horman@corigine.com> writes:
> 
> > On Wed, Mar 22, 2023 at 05:49:31PM +0100, Petr Machata wrote:
> >> From: Amit Cohen <amcohen@nvidia.com>
> >> 
> >> MCAM register reports the device supported management features. Querying
> >> this register exposes if features are supported with the current firmware
> >> version in the current ASIC. Then, the drive can separate between different
> >> implementations dynamically.
> >> 
> >> MCAM register supports querying whether a new reset flow (which includes
> >> PCI reset) is supported or not. Add support for the register as preparation
> >> for support of the new reset flow.
> >> 
> >> Note that the access to the bits in the field 'mng_feature_cap_mask' is
> >> not same to other mask fields in other registers. In most of the cases
> >> bit #0 is the first one in the last dword, in MCAM register, bits #0-#31
> >> are in the first dword and so on. Declare the mask field using bits arrays
> >> per dword to simplify the access.
> >> 
> >> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> >> Reviewed-by: Petr Machata <petrm@nvidia.com>
> >> Signed-off-by: Petr Machata <petrm@nvidia.com>
> >
> > I'm fine with this patch, and offered a Reviewed-by tag in another email.
> > But when sending that I forgot the minor nit below.
> > Please regard it as informational only.
> >
> >> ---
> >>  drivers/net/ethernet/mellanox/mlxsw/reg.h | 74 +++++++++++++++++++++++
> >>  1 file changed, 74 insertions(+)
> >> 
> >> diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
> >> index 0d7d5e28945a..c4446085ebc5 100644
> >> --- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
> >> +++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
> >
> > ...
> >
> >> +static inline void
> >> +mlxsw_reg_mcam_unpack(char *payload,
> >> +		      enum mlxsw_reg_mcam_mng_feature_cap_mask_bits bit,
> >> +		      bool *p_mng_feature_cap_val)
> >> +{
> >> +	int offset = bit % (MLXSW_REG_BYTES_PER_DWORD * BITS_PER_BYTE);
> >> +	int dword = bit / (MLXSW_REG_BYTES_PER_DWORD * BITS_PER_BYTE);
> >
> > nit: checkpatch seems mildly upset that there is no blank line here.
> 
> Yes, thanks for pointing this out. I saw that, too. The complaint is
> that there should be a blank line after the declaration block, but the
> next line is still a part of the declaration block.

Yes, right you are.
Sorry for missing that.

> 
> >> +	u8 (*getters[])(const char *, u16) = {
> >> +		mlxsw_reg_mcam_mng_feature_cap_mask_dw0_get,
> >> +		mlxsw_reg_mcam_mng_feature_cap_mask_dw1_get,
> >> +		mlxsw_reg_mcam_mng_feature_cap_mask_dw2_get,
> >> +		mlxsw_reg_mcam_mng_feature_cap_mask_dw3_get,
> >> +	};
> 
