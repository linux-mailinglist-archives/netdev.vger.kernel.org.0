Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232196C6D11
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbjCWQMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjCWQMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:12:34 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2118.outbound.protection.outlook.com [40.107.92.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE5134F4B;
        Thu, 23 Mar 2023 09:12:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X13rsFxKU2cq/qJHSfRAyu0t2CV0J7u+1WW5gCjgosW3CR8StpsD0vPHnfcr62LbyA7b/D3Eogaykf0cYj3lo0swq8O44cmkSYVRgD3Hp5gmPrKjvYbS3Vz8L7T/a7SP7Zss0DMZRA5QtMZhbfwI7dxZCTx2XlQUrJep8rP3mkdO06ddPXoo2AQP78kTrnG4NTNNYcIpNALErHosQJUoDWN2qXq8EZTTSAGUf7lelAjlx3YC4Q/ZAqg2doObE0xppKjQN6VPI0FOO4kqWq6GW3IdrJau6Vi0Em2UWfD9YCBiAVynt86XwIm0lzV7gmB3iHxWQP2fAlNVTIIDnE8/ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sIKg6XYbFZckrKvQV/GXahp3IN5l43P7tbwr+6c5tZo=;
 b=TrBG4dG1oOuB8AxRzCLYQBFcZfDk4wp+yvjpI/MjTqqYdSklYCS+r2begemtwAPBhzJWFBeeRcMM8YgkUEdTswfMa+4yIfh/pV8mZuEh7fmssgsWrYnCWADcXwp1nRGVNfIW6FeowtpqfVNMk1+cFIoccGLi3mTHOzqslXpFhRf+gxF9cK08ZvW+Ohx5PS1OAOyPy5bgURGuyk/L0zDAULvRT4l2nPvZXFGYMcjU235w0DLJoWnA6BmySa8Anwqy1mTbGyqh1wpruH/ajqGJATbypD4faTNmQfrJkf3bEFToEO8w+bP9I3X/FZJI2uI5m8m21NLI17iaxO4f0/9m4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIKg6XYbFZckrKvQV/GXahp3IN5l43P7tbwr+6c5tZo=;
 b=wdHCrDKtj8xZ4NDXoZ2TIIy7VNgskEppLEi4CP8uvHCJ5tjI7t4BMAorsrn478B7uk5xs+COsiEETMv7SEE5htVy61skl50wyB5+VuRsDh2Y/mtxuXQEhO3CGZRs64Z2pJ+HUDkbdPnAJT3+1GQcaqXtNOkawpFDpxyjm99Mc8E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4654.namprd13.prod.outlook.com (2603:10b6:5:3a0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 16:12:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 16:12:05 +0000
Date:   Thu, 23 Mar 2023 17:11:58 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 6/9] net: dsa: tag_sja1105: don't rely on
 skb_mac_header() in TX paths
Message-ID: <ZBx6TkdSJmXmwcqw@corigine.com>
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <20230322233823.1806736-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322233823.1806736-7-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM0PR03CA0100.eurprd03.prod.outlook.com
 (2603:10a6:208:69::41) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4654:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ab8baff-2e56-412c-f532-08db2bb957f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CGTGJG3gPnjtOXgHB5DIJRM6yYosnyZJ6BY9veUfgNxK1KjyeXRtNwr4kQxQdtQOClFthe+guP9GxtsEAzIi1l2ms6w1V8eTE2M8kBW3aOgIyPY2t7zcDUv932zBrdt95i7R98VBuHRt0WD2opuy2696jCrZygk5JT0GErngs/0OeilwUNwOt5RrsVWp7Hnm6TemPDsbShPi8HQvFWT1usHYU5qddgt7kb1LJsEblaeUDvFjBMk7ZlkhDG7F3UTY0ElCL/vVuY38/Zlqwe20vuvlGa59BvAAfmfniyBcQSIGMRvhPNxNL090P1SOjVwU84PQg2oSuhk/0P3LtfakGkb7y8Z0cazHCs+yX0LtjXDDHab31hpwAmqGO4P4Dni3CsnRivOt0PM9ZbNn+udo/ix5Qn7HhGEBniGnp7PtLWokqkBcUY63fsEYjY7A0EwhGpECAwjOgoaghOKbE7iK8/3SRh/Tt69VpHsLno+v+OvgWyn5O4rytC6OoSmhYPVwfLLbNXYSQbtL/NeMhjs0KP/JIMlECEPoHbbqr+ud/QZHd7bdrOF3XfOCeIS/A3cnvFoQTO0fP63vRJhXzQKyg4ZlPcrAGjuGETAxkQgd+tlUpWeN2CzfQSvRiJm35aCgryJvL3QxxsIFER5OZZODAakFZ945Q6MpstLQrgzt2IIU6+unQ0fe3Ud5zfZb9hra
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(396003)(39840400004)(136003)(451199018)(38100700002)(2906002)(478600001)(6486002)(2616005)(316002)(186003)(36756003)(86362001)(54906003)(4744005)(8676002)(66556008)(66476007)(6916009)(4326008)(66946007)(6666004)(8936002)(6512007)(6506007)(5660300002)(44832011)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aRYuBuj4uISLJhRnGWeEixHLGA/fn8uZZPAXAcxMVkbUPymFP6MTwNbXSZWc?=
 =?us-ascii?Q?uEm60CryGZ3UcFvXcHqmgIE40/2O694vm0vXLxAcQ/iDCeW1+4Ubnvcw63n3?=
 =?us-ascii?Q?jbCePt7+z7sXP3lSc5rzx5WmP6u5L3GEXKNTC5g6gzRAExVtbmdoym7vCu7t?=
 =?us-ascii?Q?oBlvivOuwFfuZP/vk3mN15XqVpX8R+LlvzRp0GX4oyi4ggc6ywTpKumZVQKR?=
 =?us-ascii?Q?LJWDu+zb/13PISMiqU+YHU+/ax0HWrU7ruKjeSxhNt8DRurDiRtmrnpS3dfx?=
 =?us-ascii?Q?09aPUVV9jegXWNUtuM9fdQ04gpV3L8cH7kAwHVjK1ckuk0qMeMOMnKs1e6+g?=
 =?us-ascii?Q?xjSdkh18MFGDYJYae0SWYgV7xU6rM7av5YoI4UWwnFYUWjG/4TL4yU3AxPFU?=
 =?us-ascii?Q?vUSg5lNlcZYwKUxG4cosCqgRlNI/GTNg2izp7rWWIX26R98g/JAwEbxWnZdl?=
 =?us-ascii?Q?aqY0ioj/h5XOXukEFfCFDh/xsy14oBC1tZl9KH87BtRu9krgEfCkZfX+UemP?=
 =?us-ascii?Q?ao21q9q342L2wg/JjBq03N3ysqfVIp+cOnjxf5c4qcd2foHaMl7MmMZ8cuky?=
 =?us-ascii?Q?4nd11M3pcA3Bc0UH/XmnGvpnvZ1c1GejUw0V+fX+d7ou5ivE67t23EBb3bQD?=
 =?us-ascii?Q?L5VEsY5zzjWS/8hABSfCZiRWgNhU2FW5/TeNzQ40UWa/SASHkoGNkJ9VYBi/?=
 =?us-ascii?Q?+4nn5SWLWENr6lVaC4oREXJAbI5m8DBvTKBQWgIe0SZTcgSAWAHi8+zL+FhS?=
 =?us-ascii?Q?cbwHIugegohlSqxWFwpXcCXRjfCtTiCmTQL0n7A1FTR6tHd/7IOxKOEORt40?=
 =?us-ascii?Q?J+hOjAO+I6arWolvvfXCPJnVkATNjM5mS6xgDHAnYj+APtkRpjA6PuYSmqId?=
 =?us-ascii?Q?uqzJhs6nBhcAFeFfutvUUOC17T90gx8S+0NmZczDNcZ+Bp2J7h30kHZFm0kh?=
 =?us-ascii?Q?O6giKqJjB8esnfG4q9l8vwSH/PGMEN1pygMcNr/Kn5+0HgJlwFN2E4MCGvQI?=
 =?us-ascii?Q?iIh8pKdLDWwE4lL9lGQHJR2U9Nt0zOUQUsh8aCaoQLa1RDMW9t6jo1OrHkVN?=
 =?us-ascii?Q?Fb+eIfc4ucwGT1I5560j+poOcHDi6FeesY94ps5bVqXpFdGUKtAPWXk/4sAh?=
 =?us-ascii?Q?DryzGT8sWTTgLtoivP1FE2ljURav9A6Uq0W+1ykHR86b4iYAcfDTwsjCA+iC?=
 =?us-ascii?Q?2oKnWbSIfTuanC0ZFRuAeYETJUgxerS/XZc9PXosDJAHeXuzvDaTmX4DyaqZ?=
 =?us-ascii?Q?kfuhcov55NL1iXJQvtrk8U4AVLmUTwH3sQra1x4ZtK2LooZwfS1dheLPsJ9d?=
 =?us-ascii?Q?DoVbBlclgv1wdT5Yk8g+ilEBVB+Dusz2lakeIlHF3cgcTRQIPYyXrMOOyCZI?=
 =?us-ascii?Q?mL8Mq6+TB7med+xDPDApcXuPFPIV/GJFURPGmtZ7v1dUMi2b5n2X4MWxKh0M?=
 =?us-ascii?Q?S5RmMRsbEQPodsTRbWYbqY87WUvByVguOIsnD6vdBm+96wl7APwguaQ/krSM?=
 =?us-ascii?Q?KZx4kuZTwpcIx67zjEv+nHEqfbBdmpeAN4KGTOTpfoDD18WgbHg0Fs7nBGtD?=
 =?us-ascii?Q?0FS7IHDVw0s3JIA4GjACRmrWZCTWKNSkILK8OGoLbliGGwwat2e1cVNfz1LU?=
 =?us-ascii?Q?rkAjdqOrP9XADyDNi2tsX91tPaS9nxgt/PSNCb49/la+CAaqvswNhaBwJnjz?=
 =?us-ascii?Q?9ZlxDA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ab8baff-2e56-412c-f532-08db2bb957f7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 16:12:05.0837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SZfgHxQ01rrrypRX9+EWhYD8vIKz3p9ujPOrHASfPu68xqRFtWi4pXU9nGS7RFYpTfzsGqoeG9fWxGvkAHFOW/y/jBGmstkrDEG701NQ8uE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4654
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 01:38:20AM +0200, Vladimir Oltean wrote:
> skb_mac_header() will no longer be available in the TX path when
> reverting commit 6d1ccff62780 ("net: reset mac header in
> dev_start_xmit()"). As preparation for that, let's use
> skb_vlan_eth_hdr() to get to the VLAN header instead, which assumes it's
> located at skb->data (assumption which holds true here).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

