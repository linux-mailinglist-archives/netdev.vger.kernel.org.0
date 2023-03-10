Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CA26B4FE6
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 19:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjCJSS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 13:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjCJSSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 13:18:55 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20721.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::721])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014C7F6B40;
        Fri, 10 Mar 2023 10:18:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HC2nDV9z6t1FIq+Ib2VnfxNWeqvhFXrZRsF/ZGPwS19ASw884N2nkMwk4w8Ofy5ylmLSGJ52NrABcQOVoDyfvv6arEuwIX4qLfdIsucgpGnCWzlb0N60RmHjg8SqZFVTrHHbv73ynvOxyEGbXYOVuB8leVtlNAM2Wa6jgIZ03UP5MbAj6s/Jj7EcgA3Fnp2Zgg03wOcW5MdruaG+otJfkr4X5sk4ilAFDVIy4tm26G0yElKts2eNLe+05xLHDMe5hde8DhUeB37KItIJUJ/cljnCyT4EKUVvxelIQ/5fvPjLEx1fi9YazDG0AtsM0qNV22jKxGc2lQ5Fl/0E3XhjWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IItsG2DopOyVR2EhLh0oWEKnw1GHLQuOGMNbGjCloEc=;
 b=RJjZlCfpk++cGGLuH21poOO2ooZwrW6JSm3C6qm7SUeS2FoptiuSrT8LcoryR7g/D4xZUor+K2Fh1Sp798S1orfEH6ReaiQUpkp839d2AgK+ZHoSwtoseZJpxVSTSXjqmkvzYrcReK4ReU0ScUamjDVhV7z+vxHAWFwydleJmGcFVCW8BHDb+g/lUJr823YkFu2t/99LrJ9w1ZKI0nCj5gnnTEC7vNSNCZWnhohjrjNkEmdUq/ou7WWKBPZfLDdBMjJ2agmS7rPuSGZBqQcExGGst8T4oXxm5ERcJsXgyvzB2C+5yBQijc6ampMpxpsEFAin3SAq+LcQBrqWpxutFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IItsG2DopOyVR2EhLh0oWEKnw1GHLQuOGMNbGjCloEc=;
 b=jhiiDCrTcAwZQGDiIsIEMYO2I4g0yDLR8bG8tusNCtE3C+JPojfTB+zeqXJa3w1B165XdwFMwQSwIAUy1S0ZhsoXHOSmwGn8hJ8nP6dsEz7Sr4cwQDXPbeiQzadBGbz3ek/9gshm3hGy3MDAVq+qth2qkT2Osx+rZMT1W4SGwKM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4483.namprd13.prod.outlook.com (2603:10b6:208:1ce::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 18:18:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 18:18:49 +0000
Date:   Fri, 10 Mar 2023 19:18:42 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v5 1/1] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
Message-ID: <ZAt0gqmOifS65Z91@corigine.com>
References: <20230310163855.21757-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310163855.21757-1-andriy.shevchenko@linux.intel.com>
X-ClientProxiedBy: AM0PR10CA0020.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4483:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f1f7ffa-09f6-4f33-c18b-08db2193e52d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RX3kSso8q0OhEESGYXOKONe9qwQFjfD2on7iJnrIfNeLMPSysY8DVSA1xISLKk0oNV5F1RG5oqz9WYsWKgS2gxlcI/nQH1W8kHMiqKxd8jKZukXNHt5b4gR3IrivhJYuKsd003WaWjv3rTVPuQcnpS0Bstd+Cvzghirg/UomgueCTg+aREmKXmnRaEf58O80fN/Dgc1cYbrKEFQY8yxLMgX9ZwS/d5rDRVvMKTML/aHHLBq9LhVXaBGoaIQlslRej3La64zrUSkCrfXFmiuPNwTudWqKxg9vt0hK2EUehkb5h54vEZ9cBHLLBDYeYdQ9XKWgRlPDs9eHc8zvGJHyqHkqk9wB/rYM5vOE3bPIvCCfNC/DOS4EfaxgFa9z2TAwLJI2E4O9jejvVlQmD3aaiNa5iwOkI8yr9EhjvyA/GqB/HSF5/sfF49LqQQYH52/TZY+svHubDGxa9Sw5xPRM4MeeWC16APPqHCO/i8ri7vIlJmw9syBz53urbiUJu8UFPDfprSNk8dyMjVsDIjypIm4huEuslOYMg3x37qoaD5TwjYpDpBybnV4+A5KfZ5g/drtI9EJt1cltyKOcoEpAC4iuhDbl7CYJ1KezGhXdTEhJutuHlGNzLdYeR+dLMOIOkw3YKs3MGEAnlvB71viz5dEoPVNXEa1DCtr3KKuSLfko2JdO3apPXd6CCyNT/gdp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(376002)(366004)(136003)(396003)(346002)(451199018)(2906002)(83380400001)(44832011)(36756003)(7416002)(5660300002)(8676002)(66476007)(66556008)(66946007)(41300700001)(8936002)(478600001)(6916009)(4326008)(316002)(38100700002)(86362001)(54906003)(2616005)(6512007)(186003)(6666004)(6486002)(6506007)(26583001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6TaAWtb5PfJC4DZevRen3jhtJur1Z7XdRWEx3+ZjhT04CwcPa9T/KMykQYa+?=
 =?us-ascii?Q?XSLiiQuEo2d/v5fl4DNC+X2lEbiuK8hb07zCe+Cg0dZLh8Wa8K74nXJbrVCE?=
 =?us-ascii?Q?RxwUjXGGEsrnl2kiz0gQEoUmzifKA0fkIRvgomPFIH9GCI2yqMJyl+iq3PXw?=
 =?us-ascii?Q?Q73TNuYq+E+bfIR40nqfGnXjyJvi25Fjdul6STQrau0B0l/LcdpFEJmrH06O?=
 =?us-ascii?Q?XwIA1imI15AdZBlSQhAHJUuVaAEf1mEZcvi7J2e9bVCMoQpUaaACSJz4NkCU?=
 =?us-ascii?Q?BWrYGBZphQ5Rp8C6AhLBlQw11zXVkxXFlMFGIhesabpIRO7pFbOOlPgHzM9h?=
 =?us-ascii?Q?tGugF4+anFsxYIwpjbUkt9xzRUFiC3da+K5rYJ8asyUsCfE66kS8I5I7kUEr?=
 =?us-ascii?Q?EKIKuDN9vP4XURPlonzkUJz+lZ3qU+zE3kaJ+wSyqSrikFFjCdFB1D4EWVDV?=
 =?us-ascii?Q?hPT40PczQUVbnWmjdHEiM4x656UUdaJ6oBaOymoQSYQy+w6mhq4JseYncvDz?=
 =?us-ascii?Q?exLAjhim38IFGnVVpjOo29FBphYNv/c8auE6hu2AxSA0PTYvRWGPkMATdnGW?=
 =?us-ascii?Q?Nb6W5sWFS9gxUl2hNY07ggT6aJtguXrg2WQH015uHr4tzCXg5EPlCc5VGd6V?=
 =?us-ascii?Q?rIsKcha8RBlbrCtAOkboD/MZkRpaevjaLJNvjTldotgKP1Bd8+IiLWX5HXsR?=
 =?us-ascii?Q?KrNsGGOYDdtb8zyIIhTw33l8y4jqFekKAYq8ADX+NxI3ldU3wgpjEgxkKpFV?=
 =?us-ascii?Q?0Op7ad+q7CjmCZyCmkQiPOB7pelcaO9LVsNBJwIX88mMBCbG3OdJ7cUC1uUp?=
 =?us-ascii?Q?5QMhIlbg8vJlBTDjalUP+HeR7jcdwtIBGuKqX8sQ73LaS3YE5vdGkEYjJsG7?=
 =?us-ascii?Q?L3pvE+IAzrZ8kzMIDzbplIeloTd9iEXfyBq2zsBIwcB3hRVeUSsyGNKZ2oYX?=
 =?us-ascii?Q?JVSoCKsv85Fx2soZfAg0ZnhXKcJZq37iJl6uHVPbYhqkumgi6YDcqtAIjnVI?=
 =?us-ascii?Q?nO4o7hVMmzL9oxP1jDFek8/wIWH209BPHNa1hEpOJ8stpDkeRUAnzH70qdF+?=
 =?us-ascii?Q?skMo5yghmidZqCADXf4G2AxuhPYGmZ5nQIoq9xriJiOebvJtszKgodAAHKNl?=
 =?us-ascii?Q?0AgABylcdrYdgKknf6JpCENWoZ6atr0APCOqW1gXRJMYz8d4UYi4sM4U0UbE?=
 =?us-ascii?Q?tPTMklCnMO4yLHpaUeGU5+acLzNspMMK9b+oi5VNmvt6QcOngyfSHas68s9/?=
 =?us-ascii?Q?xvEdP57SR5c2ndgBRXNuypo1Kp7Xhta3fqpV6sX6pNLcLtx2005pspUBHoVr?=
 =?us-ascii?Q?LvNi3g5uiOCdwhqTgGyUs2+C9SvG5LXW2cD6lhC3YLiUTqZ9Jn4cG4oUcqMy?=
 =?us-ascii?Q?mXgu/KXdzpupK8CUVMDrhW30H7IEEnGAZik9Nb+hhHN9h8R+jouSzKZFdKnR?=
 =?us-ascii?Q?i6UtRmTlp4YnENcxGWjnmMsGi2FwYJl3131QEz+kwRn4HI32pcH6ong1OWOt?=
 =?us-ascii?Q?y14NfOSR1l8sN5rsLaQLEd0jZRH4abRVmzqRXRBIPc2i30mSWIF5BD8/TJsj?=
 =?us-ascii?Q?wpD76eqUXAhVcKLbchJ+gGXGVN43WLvApPTufuAIEiHyK529KZJSuYqLPb0R?=
 =?us-ascii?Q?GfXDtgRzgSCjPNS9VenU6xn6V7y10kBHSw6VeXYwl5wNh+K76iMZREh8gf3B?=
 =?us-ascii?Q?yH5nvw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f1f7ffa-09f6-4f33-c18b-08db2193e52d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 18:18:49.6647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ax6l/8vniRAJsOuVBiOQqOZTbchpwEDYaER/FENgy9O/X+XvO8Gy1O27ng1JaCcRf2uG/vFo0dKLQPm+WfKAEjLWHW18ykiorlU/FUacXh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4483
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 06:38:55PM +0200, Andy Shevchenko wrote:
> LED core provides a helper to parse default state from firmware node.
> Use it instead of custom implementation.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
> v5: resent after v6.3-rc1 with proper net-next prefix
>  drivers/net/dsa/hirschmann/hellcreek_ptp.c | 45 ++++++++++++----------
>  1 file changed, 24 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
> index b28baab6d56a..793b2c296314 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek_ptp.c
> +++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
> @@ -297,7 +297,8 @@ static enum led_brightness hellcreek_led_is_gm_get(struct led_classdev *ldev)
>  static int hellcreek_led_setup(struct hellcreek *hellcreek)
>  {
>  	struct device_node *leds, *led = NULL;
> -	const char *label, *state;
> +	enum led_default_state state;
> +	const char *label;
>  	int ret = -EINVAL;
>  
>  	of_node_get(hellcreek->dev->of_node);
> @@ -318,16 +319,17 @@ static int hellcreek_led_setup(struct hellcreek *hellcreek)
>  	ret = of_property_read_string(led, "label", &label);
>  	hellcreek->led_sync_good.name = ret ? "sync_good" : label;
>  
> -	ret = of_property_read_string(led, "default-state", &state);
> -	if (!ret) {
> -		if (!strcmp(state, "on"))
> -			hellcreek->led_sync_good.brightness = 1;
> -		else if (!strcmp(state, "off"))
> -			hellcreek->led_sync_good.brightness = 0;
> -		else if (!strcmp(state, "keep"))
> -			hellcreek->led_sync_good.brightness =
> -				hellcreek_get_brightness(hellcreek,
> -							 STATUS_OUT_SYNC_GOOD);
> +	state = led_init_default_state_get(of_fwnode_handle(led));
> +	switch (state) {
> +	case LEDS_DEFSTATE_ON:
> +		hellcreek->led_sync_good.brightness = 1;
> +		break;
> +	case LEDS_DEFSTATE_KEEP:
> +		hellcreek->led_sync_good.brightness =
> +				hellcreek_get_brightness(hellcreek, STATUS_OUT_SYNC_GOOD);

nit: I think < 80 columns wide is still preferred for network code

> +		break;
> +	default:
> +		hellcreek->led_sync_good.brightness = 0;
>  	}
>  
>  	hellcreek->led_sync_good.max_brightness = 1;
> @@ -344,16 +346,17 @@ static int hellcreek_led_setup(struct hellcreek *hellcreek)
>  	ret = of_property_read_string(led, "label", &label);
>  	hellcreek->led_is_gm.name = ret ? "is_gm" : label;
>  
> -	ret = of_property_read_string(led, "default-state", &state);
> -	if (!ret) {
> -		if (!strcmp(state, "on"))
> -			hellcreek->led_is_gm.brightness = 1;
> -		else if (!strcmp(state, "off"))
> -			hellcreek->led_is_gm.brightness = 0;
> -		else if (!strcmp(state, "keep"))
> -			hellcreek->led_is_gm.brightness =
> -				hellcreek_get_brightness(hellcreek,
> -							 STATUS_OUT_IS_GM);
> +	state = led_init_default_state_get(of_fwnode_handle(led));
> +	switch (state) {
> +	case LEDS_DEFSTATE_ON:
> +		hellcreek->led_is_gm.brightness = 1;
> +		break;
> +	case LEDS_DEFSTATE_KEEP:
> +		hellcreek->led_is_gm.brightness =
> +				hellcreek_get_brightness(hellcreek, STATUS_OUT_IS_GM);
> +		break;
> +	default:
> +		hellcreek->led_is_gm.brightness = 0;
>  	}

This seems to duplicate the logic in the earlier hunk of this patch.
Could it be moved into a helper?

>  
>  	hellcreek->led_is_gm.max_brightness = 1;
> -- 
> 2.39.1
> 
