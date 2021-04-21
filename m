Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A3736734F
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 21:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243423AbhDUTTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 15:19:17 -0400
Received: from mail-co1nam11on2087.outbound.protection.outlook.com ([40.107.220.87]:33257
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236152AbhDUTTQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 15:19:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WmHuskHoeo3Z8O8K8F1dudb0r2UKYi4T2T6xB24n+Db3whHtY3BkRNhLUJ4/BUJIkeLKggTxEvRL6RKkVixoS9lpe/U40aDnN4uDF9gIryXbraGwgdqVIsHSA5dEuh91ei5sQmIeIVqUriqwID8ntaPl22E/87PFRYkb5o4q682QWC1WxSQUfgE+FH8j1JS/De+zH2QV+DifDBTjb4fzzMOp7bVL96kGo89Sqwy42tnTj8wojIbNTTr5MrCYqMigJsyvV89px52aW7OgM16X2C2GDb4HtA/6v62DY0IOPnP2fqHPTsD8Hchr/XaBpsR0R0CSVH/1sjqbx4HUQHZSwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g76/qWgk9HzR9dyT0aVZRXu6UUpwpuF6CeVJOglnlFw=;
 b=ZR6BL94eL1bLu6uxSm6Nckcd6uiuIEUPWY3geJPVY7+B346rTBTbk74wXt1QMzhXTIViiHvYHG6Vrx/3ODvHJj639d5Cg8T4sPmDRgGVTJk1KhFvDqT6zrwi1T6b8RKgjNJjxTjcTlSL4JCIDACjlxVc6tr6auMYALdcxarK814rRvemUg8f1S5mrXDj3caZER0DyNsRzgpZR6c9Pbjdp86z/A/+snLEUdlosWJlXsPBaYIGJ1bOOUjUzrAz5JZrtrrckiyN6vwkxV/kdZ1y9QVxBetgHjbyhBPGtFmiHwwnP8aqMw6eIzPh675LZTnNKO3Av08zSGRd7mX8dwE0Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g76/qWgk9HzR9dyT0aVZRXu6UUpwpuF6CeVJOglnlFw=;
 b=SFofXgnhTFTt7D0QYsQ+cMxDv7FtwM11Lfl4xlaCMVKyfdr3u37Frhvqr19pUTYrGbLUVqP6ASa6Fd9mkCXDyLqL+pwnJ2ZHE3aVRgY9BTarF1z5op165f6UC7ozxYktBh4DqbchHEzKzfyobymLddzY8LGcmHLMxW07N1g7CixkZc1skeoKZJsSErmHIT5QDHevlTTHcc0eA6b0VtN/R8PtUZulTTeadrhTeVghiWZpfDVXBB0yGpc5p6pFCFS6HUg8gypquzkOIzKUi8XjxYKdeeRCY0pQwvikGK2gbin3zB2u0UZaRbntN2nJbVx9ynrwhtmhxQuw6pzN92Jukg==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM5PR12MB1211.namprd12.prod.outlook.com (2603:10b6:3:79::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 21 Apr
 2021 19:18:41 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::a1a4:912e:61ce:e393]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::a1a4:912e:61ce:e393%9]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 19:18:41 +0000
Subject: Re: [PATCH net-next] net: bridge: fix error in br_multicast_add_port
 when CONFIG_NET_SWITCHDEV=n
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210421184420.1584100-1-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <7b52da08-4137-2c33-012a-b45262360bdd@nvidia.com>
Date:   Wed, 21 Apr 2021 22:18:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210421184420.1584100-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0060.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::11) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.215] (213.179.129.39) by ZR0P278CA0060.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 19:18:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a0c520d-67a3-4cd4-116e-08d904fa4605
X-MS-TrafficTypeDiagnostic: DM5PR12MB1211:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB121137F4418CA3563EE7B41BDF479@DM5PR12MB1211.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KtmldeA4ahrENQUpXQu4WnK6PPnmnpps1hwEyYr/D4Jgze2F4Zz5nLyVnYoHUcFMZRSqD0xyd2UPwpp8dWowsQ4YHOV8WYx7RWDcMJB6rsfHe9UgkJCOcf4TilYzQrkSneguLtNRewSny/fp4m3wBO14Lab17Xeg/gES9nMD+O84ICdBvcamZt1tSqHDf2eeFKai5Pr8yj+kNeYa6tExIquD+9tTfgGlBvFvYZH3Go7eQvS2xjGex3DQ/1nutH5g3PBNV4iI7p39s1RyuVSV2FVVxqV8UzCW9MOvN/F1NZuaY7O1nDo81l0bXvw34eovTf2CpN+gpEvMJbka7rxGvFIn8dk1nJcOTcqdoK8zMjRMfeeTu7Bor/m04LwHh0WBPh8Df1GZj/1Jgy1adtX4WPhj7NMc5bhhhLWxuwJPLpdYfsh5NNG0KZGJGkbCMfz+LocDYXRoJQI8/ujCAgQJj7KY1EWfte+DtIE5q+AlNYofw/1KFdDRfr4CbHK7mp5om+fRmDwjJS8boJaVBIOJgjBoqcIGl5prGfbv5WQW7vT9GPsVNtyJQYhyp/S3ZaXfRD4NA2rab1Gre6FjM1SoDFz9HEAhqHy0rIekqbE+GO6Ux+MmZiIsksgg0C8cB9Qm/b7MolS2ezsW4lnT0sWQx5GkENVO+qykvGn/4saLnhMX6OQ+voWZHXGuozEJD2Tw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(2616005)(956004)(86362001)(8676002)(316002)(186003)(31686004)(54906003)(31696002)(6486002)(53546011)(7416002)(6666004)(16576012)(66946007)(83380400001)(2906002)(36756003)(5660300002)(66476007)(16526019)(478600001)(4326008)(8936002)(110136005)(66556008)(38100700002)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZU9KZlBKYU0rbGd3UkNGZDBKMVFzOXdrSEFIcExLeWt6ZGJvL3FIWEZ6cllR?=
 =?utf-8?B?QUY3OW1XTVBjd3Njejk1WUpwYWVuTmptTVIrT3hMZHUwRG1lM0hHOWMyL0k5?=
 =?utf-8?B?VXZJa0EzSkY3M2RhcU1zNHArai9CYUpDcThwZk15Q1d4TTUzSDRCMk1FOGtT?=
 =?utf-8?B?RTdWRHBoSVM3R1lWN2RaVi9KUVQ0dkt0UkZ4ZHNXMFRpc3pTNjVEZW11ZTlr?=
 =?utf-8?B?ZTg5dVRzQ1oxYmk0OTh5YUJNQUlKcExGczJEcTJVL3Z0VEVnYXIvY1NqbGpH?=
 =?utf-8?B?Qk43YnpEb1ZFa3UxbkpHeXhvU2srWnp2VUNmOVp4M01zL09uU3FzUmNCcEJZ?=
 =?utf-8?B?RFhjK282OVBOMERGei9ZeVBuRDJ3NUdnaDFrL2VNNEIzMmpHTzRIYmo5V2ll?=
 =?utf-8?B?UFJVMlkzY2tLL1JMSkEzYnlpTUt0Qlk5Nk4wd1V6ZFMvenFvK20zR1pjdlg2?=
 =?utf-8?B?VzVsRy9NbFh4R05wbjZsUm44d21udjFabkJrcG1SdkFEQ1duVWtBL01ZT09Z?=
 =?utf-8?B?dDNoMXZvdHVDVWZOaW5lN1JWNlljUU1DUU5WWEZNeGNHNzNqWEJTYTNFbnhv?=
 =?utf-8?B?SDgxb2p3cDc0dTlmdk0rOHpDUFBGeVhLQWsvWENSUzM3Sk1kRTc3V3pjd1Vm?=
 =?utf-8?B?ZlBLME9XN0tNbG0rTzdZRGNtV1htZVl5TzVzVUhvbWw5Y3Y1eEc4Z0hTSWdX?=
 =?utf-8?B?YVg2ckN0cVRRVlBLazdXbG5sUGRlNnlKNTY3amhnYmt3bTYvK0tjL3RQdkdo?=
 =?utf-8?B?cU1KMlNobmNUa0pidjZWL2pYK2piRFZZa2NEQW53TlJOcFg4cStkRjVia2pw?=
 =?utf-8?B?TUJJODFTdXhmSzVscVFIdFp2Kyt6NHhHOVI5OWlQamtHY0ZHdlZEZmpOS2ls?=
 =?utf-8?B?VnBOME1oZTdqRGJvK0RPR1ZDU0dBTm9GQWVyV2Y1WktIeHRnOXJqVkdFUWRm?=
 =?utf-8?B?SjdOM25ZMVp4M3M2MHBvUmtqRDJLQThrM2ZRdmRMcWJMSHdVRGJocmVLQUFn?=
 =?utf-8?B?eFVrYjZqQmYzM0JDU001WFY3Uzl0aFNFNDlMN3pzaUxZalN5a3J6Vjkwdndm?=
 =?utf-8?B?c1ZGa3JnQ29aZXV1Z2IyN2VkMnlEd0NYRVE2S3J5V1ZMQjFROW0xM25EOXJ2?=
 =?utf-8?B?OWNSeGxSa0ZBcC94Zis5NFllUmpXWG9uU2dmYTFMS3hXa0lCZWZsYTZSSlh4?=
 =?utf-8?B?R3BHVG5NcVQvWTBvK0tLQWViRW9veGp1Y0Frc2VpUkl0RTQxNTlGMWkrVEMv?=
 =?utf-8?B?d1BQMFZUTGQxdkZscXlkK0ZFMEhWSTJKQkFSLy9kTVVQUEhvaFBNamtOL0Ri?=
 =?utf-8?B?a1ZTcExxTUFIREVOOGFCeGg2eHpKYWRkNmZtTUhnVE5KT1R2SkdxeUdrbEtD?=
 =?utf-8?B?R1pISjk0RG1pd3IvaUdBNy9zSi84WFZzMjZQOTFLMHFZZkNsRFZyZXZIOVVV?=
 =?utf-8?B?aDloM280L2dFL3VaVUFkL3A2dFBoZCtYSjFJNktaVFRJenZZSDlxOE5xS01S?=
 =?utf-8?B?RGIwdjJpSExHa1AySHpobGxsaTgrbncwa3NzOVptUE1Eb21XM1cxQ3RuK0tS?=
 =?utf-8?B?bGdlUHQ1VnY0U2NMM2NxK09kWTNOek5WR2xrTFBTV3pZQm9uc1pTRnROR0Fh?=
 =?utf-8?B?ZnovYzRLVHVzR0NraElUVkY1THkvVVBSNDN6Ky8yL0MxbStoVHdQNWhzVXZ3?=
 =?utf-8?B?L1pKNUNQYXB5cHlOL25wcTJJTHJSeXFRTE9Ua0ZWODZQWnBaRlVIeDdNVWg4?=
 =?utf-8?Q?7LC0M+i+yBq/ofkn6Rw7IFwiJSF6ugL6mUCVyZv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a0c520d-67a3-4cd4-116e-08d904fa4605
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 19:18:41.4878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J8f1kY/p0v2MsCvwzmLpA1shNzwD5Q+Fe7J5KClXJxCxLzAnOPUtsS8XoWhpbfaFS+4JIJvVQrpUX+gY1QypFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1211
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/04/2021 21:44, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When CONFIG_NET_SWITCHDEV is disabled, the shim for switchdev_port_attr_set
> inside br_mc_disabled_update returns -EOPNOTSUPP. This is not caught,
> and propagated to the caller of br_multicast_add_port, preventing ports
> from joining the bridge.
> 
> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Fixes: ae1ea84b33da ("net: bridge: propagate error code and extack from br_mc_disabled_update")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_multicast.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 4daa95c913d0..2883601d5c8b 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -1625,7 +1625,7 @@ int br_multicast_add_port(struct net_bridge_port *port)
>  				    br_opt_get(port->br,
>  					       BROPT_MULTICAST_ENABLED),
>  				    NULL);
> -	if (err)
> +	if (err && err != -EOPNOTSUPP)
>  		return err;
>  
>  	port->mcast_stats = netdev_alloc_pcpu_stats(struct bridge_mcast_stats);
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

