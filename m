Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2256B5B3F
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 12:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjCKLmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 06:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjCKLmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 06:42:02 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2132.outbound.protection.outlook.com [40.107.223.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1E325E2C;
        Sat, 11 Mar 2023 03:42:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLeW3eRQsb2aoOR0MXOSdzZJD5HTdGDxmPO7AwoM/qdZyhXVbFxZwE/C9fUMpZuekl1Y0Ml/ilQkSu1J+fN0C1Wky2tGvvOxdXPxwmYcVMS65A/u4e5aJ8hEP94XoWaryiqrDhwM1zePg3gzyR4aRvgMnJ4C0HgswatRNcqk6uGrC1jx8KHk63HHUsXuiHyxfZ4kGDtpoXAMXwRgB2zJ1GYsQJt6vKnrrrKwueFYYxfvrOT6h9QsovMbhAWcYBjJrW9t+IVw/vAqg0xLcLviWlR7AwRJdpcWIUrMstAlJ4baKu5CPEBogspECIs66z1RWLIoXwZS0LPr6FiDVjaqbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iXJCMZt8cHTqbZCwe3WkNQoDvFOylbiv4oxV3ENJGfU=;
 b=AKg6ohiemzM+WfdzUmuhNlSDY8/BDoEBlXTCCJKnBO0sEJ2I9ocW079XmyU7fqe4CxqNpigSWH/rFGi2DU7w7TgjnGoGgQPmp1sFXHoNl9mS4hvQY0v2ppCaEU/7RjVy5A2ihyX1ftDX1ltHdWOcMgmItWjZjB2dY88ZtmETiSvsSjffZkeN03A3hW8m4FYO7YzB+9aDAp6sHat5v1WqL21HCGIH3t2Utcd5yAGT58TVrvp7ep3wLXyf2p/Tlm5amDy3lpCujn35jYIr8YIhjU3e2lMzwCogAFbaoDgUC0ih355aIwQxpLB0a+8UL9jemPKEBO63pQNl0rtqjeRtIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iXJCMZt8cHTqbZCwe3WkNQoDvFOylbiv4oxV3ENJGfU=;
 b=c+2+E9j+EMTeMFDEGCdM159B0P8w7Nl0yBB+jt7Ujo8CDDgzI/w9a61ODFjNddD+Vc1UO3i8U4/p9EaqPXZtroqmgQz1V/oGM23udYUMxDNsa4XpZPRPXxFQej5SVwJ8aPA0xxjEOFIhlVtyIHgR3F2AMGdIu3SElDI21QyKO4g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5552.namprd13.prod.outlook.com (2603:10b6:510:131::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Sat, 11 Mar
 2023 11:41:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.020; Sat, 11 Mar 2023
 11:41:58 +0000
Date:   Sat, 11 Mar 2023 12:41:51 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: mrvl: Use of_property_read_bool() for boolean
 properties
Message-ID: <ZAxo/8hosiQrcggr@corigine.com>
References: <20230310144718.1544283-1-robh@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310144718.1544283-1-robh@kernel.org>
X-ClientProxiedBy: AM9P250CA0022.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5552:EE_
X-MS-Office365-Filtering-Correlation-Id: 813ab3ed-7580-4ea6-d41e-08db22259ee4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/sbl4OAdL1GqPfaUgofZNQ00ljbqhdMoa6hniBaRyYM+eHdG4IX52sBztExvEzvpbVuUphmDtoLhwpmKsvuCYaxUCEaOLvNkOXVqLZv6+UnAB/GpdUwe917PWXAwYyj32r9OM3puzOsO1vnnoTMPxOG9L7nITqNaecrE4bIGbIjX0X46PXiMntwzc4aw5tn+kyV+QKaIeDSoL3MsRCyHOSkdPx5B3LxUEQtxqaW3B9G6QlFpyKgHBM/6CndeCbINWmIei/xGcez42nyPl4pYiAh7qfcYzYSrSbiJ8kLLVEP1TVtOAhu5+beOrKyrer2rproB3DnLJ25GizCnIQj5tV+nK2GCZBOZwhVvHNcq0WZ+Gi+K4tvFbA0n+JOlDsAoXTucLmigJgPsWOeYVMe5YqPG7Ahf8ATmeletd5RcgoenS/yaYK6X8SmuZAS3P2zDWlhld7K7sDn++LCxTeKjjNRmOl+jbwa45NklFZMEElpRXc8YR6Gz+uc4eqPUf7z3gGnY3luHjir5kt4yrrHSrdw0PzR/9vLAK64/T03HFKVhRa7MrbH/G1zy4SWW2+JgN8fql6f8oSc0z3yPdcOg3gzQq8N+UrhpOhvX2PXfJUOXekMxdP1GhuN49xQTSPHWUeO3OwWGT0yXwo/z6S52w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(346002)(366004)(39830400003)(451199018)(2906002)(44832011)(5660300002)(8936002)(36756003)(66946007)(66556008)(4326008)(6916009)(8676002)(66476007)(41300700001)(86362001)(316002)(478600001)(6486002)(38100700002)(6666004)(6512007)(6506007)(2616005)(83380400001)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2rgh/e88hTBxRVYqCzmRSHpGdAYDpV6oayy5uS8U2pKj3K+YQUnU71vzlx4G?=
 =?us-ascii?Q?yTkDXJb731I2kcYUHF4p2/XV0e1pDsBUjrXncUZH3wvQse5yvY1tqE9GPPq6?=
 =?us-ascii?Q?Q+rkKwkGQOK2Bg2EhFBkx2UelPljxcXH2RfFn6ieBLa7qvzSCqKLKSO8CG2R?=
 =?us-ascii?Q?D1mybLFep/49W8HboDqlNvNHmedPOSz0K1fqD6C93Tnoq+XaLY1R1Gqw8LES?=
 =?us-ascii?Q?om8jdSCQdrulrn6hdZWboF26Y6sQ+P6dFPZ6BoJrMePI+tMK3gI1z6CXJKq5?=
 =?us-ascii?Q?K6OrT+fAxoo934zEnB9NxRUgpV7NE/6JHRkLHOqApCq9JcLEzuenZMToGt4X?=
 =?us-ascii?Q?kZLKmsUHtq/qXYbK5qZZ8RJsFZ7V1yhnYh7Y2O02h69tpKmz6SeOile7r3As?=
 =?us-ascii?Q?nDHhREGZRjLEiq1MMa6/nW+gFByUS/yMgi9xWCVHgNwfYFOdOq7uy0DHAk8p?=
 =?us-ascii?Q?sF0V3ASo7uwkjXmfrr/mHYIa9xjZ85WwYAxbHtpAHPmxdFBkp37+QotkyGMi?=
 =?us-ascii?Q?pVa76UcdqXvMMjanYpdixyzCFQy5xfOjHqYYkP2dnRyEQt/V7k2C8Nf5Buj4?=
 =?us-ascii?Q?eb+YJCva3xF6SZr/yPOiuIMbt3TWM0oZIO0Kh06Ivuo2eywHwrvy0fJ+1BXu?=
 =?us-ascii?Q?VdW2I1qD8/ZKaZyXLfEsq+rdrcQPBjp6G0lsVz0goqrnJoN9J9T2bmP1byxQ?=
 =?us-ascii?Q?eO1LG37hLXxLdxpo7CjssvzLNxoL9lPfGjKBft9Kww7vxkN5sU/ZHmpnL57m?=
 =?us-ascii?Q?k+drc6JktkOfDmT9flEBLzUEOjY5zaK3MAfe7NfvmRajnnOR3QWsP8Zzbl9W?=
 =?us-ascii?Q?Nl/6j3OjlmKOj/xkz37qiLpDa0sJ9WCeL/0js++Cehu8Wvth6085kkW6rIvR?=
 =?us-ascii?Q?h5NbO8aiEnW0fsDZmSH85QF64s2uMVD/qG4dN2jIyuPzAQWdE3R4gW7s3U2D?=
 =?us-ascii?Q?C+gktnSWTy2XD5n0SUQWYWl6lkO+Foa+7ifXJaQoACvSp6MUVfSVI/cd7uRT?=
 =?us-ascii?Q?9VTHOGPhjW0Zpmq+TvMxRIm0FsvJbk4giRb7NKGL1qbFlbeai0ulCGstp7TU?=
 =?us-ascii?Q?dwU+G/NIlBnftyuPuyHnERW4oriT7GDO1+iOr/v5l9w6Lqdo2fDv6cPNCzwx?=
 =?us-ascii?Q?WXaJUhecxCu0ZPZpayBypv0MGs+TWK7piENhynFGitms7AaD6G/vZfvfttb3?=
 =?us-ascii?Q?SfT376k6lHLYVYOpAPyY1ek+N2cBN/kHDfYmseBNnJnVQ5ZMpXeD0S/bR90+?=
 =?us-ascii?Q?ooKkknfNpi+XJRXlOKt0VqKT+2Fu671f+3iSrjJUOOCrD91DZlZ7hhBnJZCh?=
 =?us-ascii?Q?4A+RJJLzw4Ik3sqZl3NzTAxkFtEHEiRnG57W0XsKQmfSPCVo84aGz1YyNCHh?=
 =?us-ascii?Q?oEdd8ECZt6fkJ2WSBcoYOyPIrZvlkOxRO1LbjObERGRTWjSiLQywtvJCIIb+?=
 =?us-ascii?Q?d7FpLBC0xD47e78Adqi5B4Amj/g3goowG7Yt3ghA7EgBZRAXpGJyOH9ihNCH?=
 =?us-ascii?Q?bYvQ8zF2Xs6YWwXIIUj0snw0DkubAxTc8yL6i9XN8ccshorsJFfcWdm/RDKa?=
 =?us-ascii?Q?fb27RNRrj0gA3rhBdEMEaabMfygQzjuR7Jsq6r/B1gWAMUXPqr/M+Hvg8L5S?=
 =?us-ascii?Q?MBqjklPx1skKJgosH7b1+4YUOGZ9r9g4mEefbDqUzyn0mPhwwdpgBnDK+INB?=
 =?us-ascii?Q?s/w2DA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 813ab3ed-7580-4ea6-d41e-08db22259ee4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2023 11:41:58.4092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DpgJGHMTF/pempTMfBUmzJLES25d3FOmvUbs5YrDCPWCy5NmYJG5eLpDzM6tKlPUCQ5PMDXTU8pFgYZCgdoYW8WTLxDw3bFHHl1dXWKkLF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5552
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 08:47:18AM -0600, Rob Herring wrote:
> It is preferred to use typed property access functions (i.e.
> of_property_read_<type> functions) rather than low-level
> of_get_property/of_find_property functions for reading properties.
> Convert reading boolean properties to to of_property_read_bool().
> 
> Signed-off-by: Rob Herring <robh@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/nfc/nfcmrvl/i2c.c  |  2 +-
>  drivers/nfc/nfcmrvl/main.c |  6 +-----
>  drivers/nfc/nfcmrvl/uart.c | 11 ++---------
>  3 files changed, 4 insertions(+), 15 deletions(-)

...

> diff --git a/drivers/nfc/nfcmrvl/main.c b/drivers/nfc/nfcmrvl/main.c
> index 1a5284de4341..141bc4b66dcb 100644
> --- a/drivers/nfc/nfcmrvl/main.c
> +++ b/drivers/nfc/nfcmrvl/main.c
> @@ -261,11 +261,7 @@ int nfcmrvl_parse_dt(struct device_node *node,
>  		return reset_n_io;
>  	}
>  	pdata->reset_n_io = reset_n_io;
> -
> -	if (of_find_property(node, "hci-muxed", NULL))
> -		pdata->hci_muxed = 1;
> -	else
> -		pdata->hci_muxed = 0;
> +	pdata->hci_muxed = of_property_read_bool(node, "hci-muxed");

FWIIW, I'm not entirely excited by assigning a bool value
to an integer variable. But I guess that is a challenge for another day.

>  
>  	return 0;
>  }
> diff --git a/drivers/nfc/nfcmrvl/uart.c b/drivers/nfc/nfcmrvl/uart.c
> index 9c92cbdc42f0..956ae92f7573 100644
> --- a/drivers/nfc/nfcmrvl/uart.c
> +++ b/drivers/nfc/nfcmrvl/uart.c
> @@ -76,15 +76,8 @@ static int nfcmrvl_uart_parse_dt(struct device_node *node,
>  		return ret;
>  	}
>  
> -	if (of_find_property(matched_node, "flow-control", NULL))
> -		pdata->flow_control = 1;
> -	else
> -		pdata->flow_control = 0;
> -
> -	if (of_find_property(matched_node, "break-control", NULL))
> -		pdata->break_control = 1;
> -	else
> -		pdata->break_control = 0;
> +	pdata->flow_control = of_property_read_bool(matched_node, "flow-control");
> +	pdata->break_control = of_property_read_bool(matched_node, "break-control");

Likewise, here.

>  	of_node_put(matched_node);
>  
> -- 
> 2.39.2
> 
