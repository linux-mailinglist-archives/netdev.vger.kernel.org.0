Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E186D22B0
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbjCaObY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbjCaObV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:31:21 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on20718.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::718])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085C520C01
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 07:30:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNhxw24iOBZ5xm5jqB7ctKXbuj3d6FxeOcKjtAOb4qt0Tm2ehTpWvNaquMe9bQVIE4me1W3nmXzRQzOrte3yk/DymzD8mALRX7WFUM31oNsH7FMA2HJboRMXUOQDAoW8xxhRKj+C+V0kNjf7uA7u+dlhJ4bwbJ0CSeR3AKv86u7rBcwad1ycY2lJQpgNBn4KEtPP9lZy/KaSW2eq8I6LIt8BJENL5jclO+jhUGQ6YWd3+Rz9OlUajmhft/Ft98G5TeN+4oEoY0HQJ9/3d9icB0UZP4fipdfDGxz0Ry0hPiS4DVBi5fmJNKvow5fJ0Z7Q4LeG6BChzvmwUiBGI8qBAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5G+cq/rCp2GqJ4VMc+ejYrG6MHU6gfIbXr42vAFEH8Y=;
 b=Nf6dK3Bd7P8IXZp9QN2LtlrCGRgJ/5ouzcqc8V2HcPATt3cABecx9VnquF7stiJ7Mg1IaUcPxxdw0KFcdSS54PJ8f2DsJqwIsy5iIzP31X9mxj1/6OZvZu7ihsEMBtsiB3UcWHAuEhphge27VMSnlsAT2NyOucWZdVagHmuSx582qOw2TFeANWpujBMiuEgwuNk/zKukTfiGBcbzMJZzNzga0mts2yhDrTwpyoWyfQgk6eCGuUebc7xxkuMWdBNNtB7oBQw8IuKAXHW5igdxdTtjkypvrwb6/im/yfwnGlR4Ij+8Dgq/fIRy6Na5J7L/9JCzmCov3NxqSWTGRAZlBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5G+cq/rCp2GqJ4VMc+ejYrG6MHU6gfIbXr42vAFEH8Y=;
 b=eUGi83XSOYDpgASOesmIiGokrpxdR80pkNMldtH60Rb2FWM5MjaxU+IHy9tZiCe5GhqBauUbkQxstL0GrgC2ZiJxfV8ZLS+m/jWsueYm06XFfM5rfFS/CBSilBzacDY9LsDJKuT+sWRDiwqrQF0rCGxLoCz9X7U/YQsiVjHx6S8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB4455.namprd13.prod.outlook.com (2603:10b6:a03:1d4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Fri, 31 Mar
 2023 14:29:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 14:29:41 +0000
Date:   Fri, 31 Mar 2023 16:29:34 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net-next 1/1] i40e: Add support for VF to specify its
 primary MAC address
Message-ID: <ZCbuTjZKWHjVuoab@corigine.com>
References: <20230330170022.2503673-1-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330170022.2503673-1-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: AM0PR02CA0127.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB4455:EE_
X-MS-Office365-Filtering-Correlation-Id: d6a66187-575b-402d-ff67-08db31f45d9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: veN0LKDtxO01aVSixey4XHtD5tZrbudimfVOyJHSdy24qYr8ArmRz/eu7NbWp8+QmZ58UsKqZjqOcbvqL1GKLX2JJn65RwUN+iEXClp7IzGZafB06A8Gj0b/Z0/HfkEhnFQVNJUklk1mxsE+1CsQiT0F1zGWmww9jElvLYByDG2BKmXcixq6VCVjzpB57hTKeCESagtRKrpJwz6uZm8ifhr8w/Z/B3/bu9AnzHi+siiN/ENcNfDYBjnENiiIJzNgLiX2DlMoimU9gKa3RRlMuoEsMi1D1N4gykTvvmESNki00scXwCsPV9FPlLiZ5VzQ/Vh3hXe0LElJEs+3+okF1vKUKSWTRnG2ejip2aj7Cfxqz3YiP60hZI90kUeZe6FFuD/kQoqztfPRP/6w9/Ok8Fdx6e0HD15VBNAt/A15xbE3rMsYhsS7w8cxwiuimSAdpbPIaQtVT8dvW5YAyn+f3N7thpG+4Az7s7g33pIH6jQqZmBNd0ZQ/mMG5gUs8yz16geBb3I1k2DqsagSXa9EE9VKrNRGAw8wh8iCs8ynV+aykEf3tWaMYXoM5/qSagJO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(136003)(39830400003)(376002)(451199021)(6486002)(478600001)(83380400001)(2616005)(186003)(36756003)(6512007)(6506007)(38100700002)(86362001)(5660300002)(66556008)(6666004)(66476007)(66946007)(4326008)(2906002)(6916009)(8676002)(44832011)(8936002)(41300700001)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p3R/c+gzI8VBpnzAa/WIQ+PlfcHX5f0Q4PivRDaUDPq0i3/H6e93VUYXbGGM?=
 =?us-ascii?Q?ah3AXcBm5PpK0G9BO2k4FxghMVdoQK/dq8ypfFJ5NY7CAxCE3LJdl9R4VnPa?=
 =?us-ascii?Q?HgcRwriV5f3WPoSAl9KbVvPLj/MUnMXwxvCPYH3G9v4tHUsDnz3cy3aZQ73Q?=
 =?us-ascii?Q?wu6MqYSmcmaZ0++aSR5Hi2yuGrJg8Mhw+RrU8IXDGI9Lm6a3cjOTimvnm/KQ?=
 =?us-ascii?Q?RwyGPQkLFWLVIFbWUzKr65ui3H5kcb30zML2kLuxjoXq0zRa/6P+QbRzcD9K?=
 =?us-ascii?Q?wijDgcAQTRP6ZxesuI90AiIRe8hPgBgLo3YVatkmMbn21AoAKoW8qEvpLAQK?=
 =?us-ascii?Q?FDEAijskMJjYSWiFoZvLT/X3aJTPKmpoLq/yj+LQd4wHHaTZrH32lTUJINos?=
 =?us-ascii?Q?sR03xqPYxyG1my9Z+17Nc5Lq/rnqzMS+nLL1dW+0JG9RZZ3qvXL6EQXsVTWx?=
 =?us-ascii?Q?p7N9mKDGilyDPcl4I7Qv1e02GLzia//yJvIKgZqQYINWojQrm6pRZGxjUqVd?=
 =?us-ascii?Q?XbqvxyqDIAKhpjIv9jdVxde1mnpTgqZj/EXvO1nnRERvuSg+fA2Uj57ZJJOB?=
 =?us-ascii?Q?7AgPRNwyl5YYHrkUjxSVcnhe40KNKb+Vh1Z5CIVZatTOPC6ZBr44PGJzriPB?=
 =?us-ascii?Q?BliWYSeWKsvYXvLskZPqir+Ogbu57RD5qi7yeByEJVJu3yPw7jIISAuGB1tT?=
 =?us-ascii?Q?6cAK8sKtvxLDo9mn9skJhUpaezoFodics3zpzlLppS95NFcVggCNCU+VDcIF?=
 =?us-ascii?Q?2okR4u3zF0KAiwJvUdXMvSdIPtMCteO9E0DMzyylfJyhfpGO3BWAkUMMC/KI?=
 =?us-ascii?Q?QsUWtFZdwKAc2vpwgE9PGK4n92V3ik6kB53pPDLbbldy7dDo4f0l++RJHvtx?=
 =?us-ascii?Q?XlnipYP98t2/8XDWxH3t3imvzEA72bw+jgcaz4NfOLPx2mJoKV3nlgyFtdYQ?=
 =?us-ascii?Q?grX2rv2vy6Rq65by4liKhWF4SFWr5oQEmS8/fYsOxK0aXsbtAtRY97DR/0AI?=
 =?us-ascii?Q?dIYFrMnvO7mPbVNj6OtO9kD8FVYx2smy28waAFSEZPRkk2t3xpO5uhoiLLpP?=
 =?us-ascii?Q?wg/WA5LW0z0fmYQKq/uEeuBqXJETEb2DZLfP0qg/SS6u9m2VE0snoayAYk2z?=
 =?us-ascii?Q?Wuzo7goukpkNsiaE8wZ8jTUMgBQ2IAd+yABHbxSPm1uXuFwn7mggZVOUSjZ5?=
 =?us-ascii?Q?Xl0tqNSb+cAerattyRPolAJ90uBsTgnPO3t9XbJX6npUMK3YKuYno74TibB4?=
 =?us-ascii?Q?b207cWAIvFlL5bhL66BjiHKBPifH0WvfY+RVvbwGUeJA8eYdt4tlK2VzhZ6b?=
 =?us-ascii?Q?smtod9szUmO1gBnpGLGcU6AS+zPZPJOfNqEX4jqf77CA+4PzHGz+swCoAolw?=
 =?us-ascii?Q?i9bDtbNr1h3iBY5ekNNLkbP6GIAzic1oa8O8Mb3r2aC+fTso4GyQTTx2AMlQ?=
 =?us-ascii?Q?hg++QR778dQh9ncojFDhKTw0iISTWQ7CwF84RzojpkmdnE5DjJ0Am+Wue8vx?=
 =?us-ascii?Q?XsmrGBXX6zB9YDYTgNdAwpVhLuz08T5ksy3T2Knc7K4PehlKzJhKsL2HAwhd?=
 =?us-ascii?Q?MgDc/B6IO8pbo5iVuc5RHK4d3FyEFA3lNVWGC3UZAxQT4hBkUYNz2EXgcaly?=
 =?us-ascii?Q?Fko7XinBR0cDiyfJ1LFoSjBdY0/3Cg6gqlj6BGmU9UQUBRVBPzOyni12nwOt?=
 =?us-ascii?Q?G2TVbA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6a66187-575b-402d-ff67-08db31f45d9a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 14:29:41.7461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V64KNClQ/MjzEgk+4v0gm1eHVkX+l2uPbBZ6Hchn5VgKy6aNaZrw6SqgNw39f9Ga30d2Y0BCJOdQGjYV9mPe4Gc7ScozKxrWU9w78SMxX2g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB4455
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 10:00:22AM -0700, Tony Nguyen wrote:
> From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
> 
> Currently in the i40e driver there is no implementation of different
> MAC address handling depending on whether it is a legacy or primary.
> Introduce new checks for VF to be able to specify its primary MAC
> address based on the VIRTCHNL_ETHER_ADDR_PRIMARY type.
> 
> Primary MAC address are treated differently compared to legacy
> ones in a scenario where:
> 1. If a unicast MAC is being added and it's specified as
> VIRTCHNL_ETHER_ADDR_PRIMARY, then replace the current
> default_lan_addr.addr.
> 2. If a unicast MAC is being deleted and it's type
> is specified as VIRTCHNL_ETHER_ADDR_PRIMARY, then zero the
> hw_lan_addr.addr.
> 
> Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
> Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> +/**
> + * i40e_update_vf_mac_addr
> + * @vf: VF to update
> + * @vc_ether_addr: structure from VIRTCHNL with MAC to add
> + *
> + * update the VF's cached hardware MAC if allowed
> + **/
> +static void
> +i40e_update_vf_mac_addr(struct i40e_vf *vf,
> +			struct virtchnl_ether_addr *vc_ether_addr)
> +{
> +	u8 *mac_addr = vc_ether_addr->addr;
> +
> +	if (!is_valid_ether_addr(mac_addr))
> +		return;
> +
> +	/* If request to add MAC filter is a primary request update its default
> +	 * MAC address with the requested one. If it is a legacy request then
> +	 * check if current default is empty if so update the default MAC
> +	 */
> +	if (i40e_is_vc_addr_primary(vc_ether_addr)) {
> +		ether_addr_copy(vf->default_lan_addr.addr, mac_addr);
> +	} else if (i40e_is_vc_addr_legacy(vc_ether_addr)) {
> +		if (is_zero_ether_addr(vf->default_lan_addr.addr))
> +			ether_addr_copy(vf->default_lan_addr.addr, mac_addr);
> +	}

FWIIW, I would have gone for something like this.
Though, TBH, I'm not sure it is any easier on the eyes.
(*Compile tested only!*)

        if (i40e_is_vc_addr_primary(vc_ether_addr) ||
            (i40e_is_vc_addr_legacy(vc_ether_addr) &&
             is_zero_ether_addr(vf->default_lan_addr.addr)))
                ether_addr_copy(vf->default_lan_addr.addr, mac_addr);

....
