Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6948B69050D
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 11:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjBIKjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 05:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjBIKiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 05:38:55 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2115.outbound.protection.outlook.com [40.107.93.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6D240F9;
        Thu,  9 Feb 2023 02:38:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Py/+QA+0GUvGY2dHz7X9mmUHx6WEolKmSiERTL22RPOaMIOQGpXDKKIqIrLYsQt0b+XZxuCfTDYteDmQ0ob2WjZmRLH1Cqpl30iJvRhYw6Xmlun+1yu9murl1UF9Rllieb8MkQo8zqn1ABhHml7+0+SwnH3PMa0+Zim9aPMdFHNiueQJIMxqlF+VitxgR4pWpcQ8071H9I9MLcsfTPSmKuKNp0DJX2gV3Uu/WPJ/7DP/jtTBuux0Rf3ySCGscH/vBikzHwd4AB+IAXbOFpGtiEuGsyJv019CXrVwi+XLUy1CUceW6nNFqyTkJ6Bfn2r+7x2PIah1gbbPIprVyGS9xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l1ZSSM+7zxIx+ZB7i2HUVqRBY0Q26Zhkc5bOcSp0/WA=;
 b=W8LS9Divi0VIQJOxQEvAEqNBjw5O6XLiUwsrsTSNGbyzUCDO1KoI+xvbnJ7lirYCft5jE5EoaxSmtkHWxGEDSDfb6lmt/vvVY+bADnYUX2PgFz6RhOciA04QCFSeuXIzoaKpKPZFD6Gpliu7ikBTsKLDpST6G3aVLm9+ZLC4Y9fB5eHeLupszvj88Nihh0cw/mLFjYknKlByzqlSChOe777ObnxOxh+0x6zVhg6BttuEW6vliGfRQhlMVpFFEzGdy5alaJOuDAuj2y3/SqC+aTJx9iTyo5Xy3qZgQAt0SzebHBKao9yP0m+XMjNf0G7/oNjYqKw3bMq/DrFc9+1LNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1ZSSM+7zxIx+ZB7i2HUVqRBY0Q26Zhkc5bOcSp0/WA=;
 b=JA73e6cDPxvAklmkoAFsGfT920a4cy1zetz46Yl2fHXKDnEceNWKFLRSN0+jUJXE4szBzi7smK2KuhfKwKxpNVHvzApLQNIGg8JWG/NHa8JwGNl6YzfvXhEeZWhhZuHU+npF05xHtzQWFtCslb0lfbVfdC11ewFjL/ISJd+LOYY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4057.namprd13.prod.outlook.com (2603:10b6:303:5a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 10:38:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 10:38:12 +0000
Date:   Thu, 9 Feb 2023 11:38:04 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] net: dsa: rzn1-a5psw: add vlan support
Message-ID: <Y+TNDFovmcjy+ctb@corigine.com>
References: <20230208160453.325783-1-clement.leger@bootlin.com>
 <20230208160453.325783-4-clement.leger@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230208160453.325783-4-clement.leger@bootlin.com>
X-ClientProxiedBy: AM4PR0202CA0019.eurprd02.prod.outlook.com
 (2603:10a6:200:89::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4057:EE_
X-MS-Office365-Filtering-Correlation-Id: 06e09885-e5e0-44c8-37d5-08db0a89bdee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O8Kf175DQIshYRgdmdhb+NjVCR0aK8BUZPW85MG8B5vpgad/UIcw7NoRLLw+i/IjTc1HeyvlGzxk40wIGu9O8QTJFtxxg4a1B6dKIaKR6vMFbZEX7WQls0fC5ygt03w1fhpRN4hmmxfT9KN3PIrbVXidzfU7Hk5G/LlaWi2lxI0jtABRXfjMHu9UvYgWKwLibvcKuPjLVWKOkR6ix0iBRJS7pCydV62GbY5jbOU5xwFSAkxIBGrKdBe3Ahw9uxtswVowFztR2QvRYzUPI52c8IAS6pW0pzgpFFhivlZBW1gafFZ7fF9rBG7ua+fEhbh5CNqXAibp2T3I8tRZe63drCbT1+INONYeOD1uZfvR7QivM63EbqxSKnUnA/UR2ltdv+xpV02B/Nu6HOOwcA9ML9im8QiKqzERl+XMn3/GwchEH0DsrF6DodYqrC4+fY14UgQ5MwH8N5LJoak9gwZdn97bf/jeCZznUvzQKAZ24Ap/S9fD41dWs+qgFoFV59lnhxc5z1lB6gqLsurukXVQpweunRAOaCttQYcsWZp7eWL2CQHhoIkUDkKKk+4HENdGSPHFyl619Q4KTif2NpDT2tUVrZNfedv0UlWA80SHzvRk8mETocEDZlKJTp0BKYWcKfsENhrAqN+FKKVcRLqUp1AhJTY5M/ahEZIYLwHQn/QA1jzwltQ8dhk2sPUFdg77
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(396003)(376002)(346002)(366004)(451199018)(66476007)(66946007)(6916009)(8676002)(4326008)(38100700002)(316002)(66574015)(66556008)(83380400001)(54906003)(86362001)(5660300002)(7416002)(6486002)(478600001)(186003)(6506007)(44832011)(6512007)(36756003)(6666004)(2906002)(41300700001)(8936002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVBEOUt0eTkwNnpBVnYwZmtxR0hQN3JCamdnZFdWY1RJemg3M3VpVWFtU0lG?=
 =?utf-8?B?emZmYnQ2NDM0djZwbSszeVJIM0hFMm52YStPUXcxbDlvRCtwNGkzSmREMkZO?=
 =?utf-8?B?TDBlWEM4QWhkeHczaWRoY2czVzVVRHJLSXVMaExIeWJib3gzNmxJUVljRFhY?=
 =?utf-8?B?UnFsdmJDUC8rSHhZeHdMdWp5bTVqZlhYei9mN1VlRlppbGwwbmtZcE10YkEz?=
 =?utf-8?B?VkFISFJmU2JzaVZTS3Y0MlVkV1JwRjg4OGdiM0trL1Z1YkZ4VXVnVHovdG5w?=
 =?utf-8?B?TnlqblNZcHJjZ2VxR3F1U0J0NTIwcldCcXRxVmc4MjBnZHV6c0VjUnh5U2JO?=
 =?utf-8?B?MnRQMlBORStRYWpLb0dKZDFMbCthRk4xYjV5SFlUaHBEUmh1NUp5OHhiYk9l?=
 =?utf-8?B?SFkrbnNnaWhpam9COXhNZDhuVnRQUmlIb1JaZUtIcGlBck5NTnhwOTdQNnFs?=
 =?utf-8?B?ZnFheDlVazVPZU5KZ0VoWm5ZQlprdE4yNS9BT200Y2VvUDA2YjhqVzhlS1F3?=
 =?utf-8?B?eWNkbWdhUWlIZmNqSkY0VytzWkc1cHYzVHovNWxCZ1VIaUpSd093WThYaUVX?=
 =?utf-8?B?dFMwT0p6RlJaYlhWbCszSER0K1BqWjRSTUdYSVJub3o2dlF1ZkkvakdyN2pv?=
 =?utf-8?B?UmxNQXFtTE53SzFCUHNucDB5eFBvL2l2eWp6cExXN09ZL3JCbGF3RVN3Rkcy?=
 =?utf-8?B?cUl2b3B4UEc1YXgzbFhpdTBTTDVWbkVVNzAwL01MZkNNeGk1ODg4ZVNTalRV?=
 =?utf-8?B?WWdhYjUwNlczMnliR0ljSUlrcmx5S2dKNFdkVnVYWitDbFZiL0s4RVFIV3Jh?=
 =?utf-8?B?akJtVmZpc3FFWHJqMzVxZ01XTXhCTmxFQXVSNGhOckxmZThHOWp6QjhsdnlG?=
 =?utf-8?B?d2N4NnhjejFIUk52Nm5zanJ6VkJEa2FHYUlxaG1nN0lZSy90RTZRYXB1SnJH?=
 =?utf-8?B?Zm1SeFc0OVhvOEV5SzhnL3hSa0M3czBPUGduN0JKZks4TGpJZmFRNHZwU0Rj?=
 =?utf-8?B?TE9UWW5OZGhhN0FlZ0NuWWl5bm0xRC90dGtnNHJJblgyOWgxbmRsbEp3ZDhs?=
 =?utf-8?B?Rytwc0xObnhzZmZDQkt2elVZYlgzdVZRVEdCVkVyWE01dEhFS1o4Tyt1czFB?=
 =?utf-8?B?SWZaQ2Fra1d0THBsYmVzaTNvbWZwckRLa2p4N2ZSWEVpMjdPdzlsZUdxNGNk?=
 =?utf-8?B?MDE2YUZOSlhVc2crR0w3RWZlRkc1Ylk2bmZ1bnlrYUdKTHBXckRKZzNnYkJz?=
 =?utf-8?B?VngvaHdXSXhycEw0L0pDZUNTdWxnaWhqS3B4aEVuMVY0VEJ6bXZ0L2ZLeDNM?=
 =?utf-8?B?d0t6SGZucnFmN2p4cDdiQVpCUDhreEFqVFpXYmtmdktNaWF6NERlbVRrakUx?=
 =?utf-8?B?RndtbHVWaTB0NzJTK0x2VmxJcU1STi9Fb0JpV0Z2MWtONzZZdTFnRStnTmVM?=
 =?utf-8?B?ODQ4enRoTDB0dVdJRnhJZVRLUkNTbzdUTjd1emU5dlhoakg2Z1FORjhVS2ZX?=
 =?utf-8?B?SGRaYnFXdFpMT1U1MllZeGJNeWZPN2pBRlF3dkNyM3E5U0tmMlRUT2hidmtp?=
 =?utf-8?B?TFRSWnZoSTNydTBvaEQwYnlGT2lIRjlqVThkM1Nxc0IzM2cxeC90c1dMeC9P?=
 =?utf-8?B?TlJUU0hMcFREeGVZZXZZSS9mWjdKNjZFUWk0Y0w5Y0cyUkJQT3B3WVFrbGZN?=
 =?utf-8?B?RHUxcm9QSURkNzRoZkZJSTFUN013MllMRXhmWnVZR04wMTJKTW82VlNPdXJi?=
 =?utf-8?B?OTNHU1NGV0JlRSsrb3pDYkhPZUFaanhZQ0pIdDhIejkvMXdaUDhXakxrbXpl?=
 =?utf-8?B?TG53MVA4Y1FJTy9EZU5QbFRCK2F2Y2lqQkJEQ3pyRVptSURUK05ZUUkzeml0?=
 =?utf-8?B?Tk5lRFRuOFYwTzFUdlpMZlhKVkNzOHo1ZmFuWWc5TzNNVktMeVRReFA0RnUz?=
 =?utf-8?B?VlY1MjlIS3MvakJmRGlxWG1EYjdmMjFtR3dqQktUb2RrNXV6RE05OWoveU9j?=
 =?utf-8?B?N0k2b2dBWFFoNzAxSFhiR2o0VUMzMzJ2RFpwNU5Mc0NaL1pXMHlFSUxLeFNT?=
 =?utf-8?B?REtSenEwT2l5WVh1UWV0RnF6OW8xRmgwc2h0TnpQSmVJblh5bE11b0ZPS3k4?=
 =?utf-8?B?Z05JeFlkNTN2M0Jjd2RPcENlVnYzYU5LMGE0L2VhcGEyZG80T3dPdkJXY09v?=
 =?utf-8?B?SmhGaktuUmNHYlp1dnE3N05EallJREU0ai9pYjkvVlJEV0llSTd5TFJwV0dB?=
 =?utf-8?B?KzF0dE4zOXQwTDl3dlU5NC9BQ3pRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06e09885-e5e0-44c8-37d5-08db0a89bdee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 10:38:11.8859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J6fT5rjeh+kqark4FemUrcCf1Paujh45Yq53O3UlI8OAgedg4L2NaXpmkvjDt+HgyYomakrYqP9EmDhDrz2gmwePxyUJPM92PkUkBmFVDRc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4057
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 05:04:53PM +0100, Clément Léger wrote:
> Add support for vlan operation (add, del, filtering) on the RZN1
> driver. The a5psw switch supports up to 32 VLAN IDs with filtering,
> tagged/untagged VLANs and PVID for each ports.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  drivers/net/dsa/rzn1_a5psw.c | 167 +++++++++++++++++++++++++++++++++++
>  drivers/net/dsa/rzn1_a5psw.h |   8 +-
>  2 files changed, 172 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> index 0ce3948952db..de6b18ec647d 100644
> --- a/drivers/net/dsa/rzn1_a5psw.c
> +++ b/drivers/net/dsa/rzn1_a5psw.c
> @@ -583,6 +583,147 @@ static int a5psw_port_fdb_dump(struct dsa_switch *ds, int port,
>  	return ret;
>  }
>  
> +static int a5psw_port_vlan_filtering(struct dsa_switch *ds, int port,
> +				     bool vlan_filtering,
> +				     struct netlink_ext_ack *extack)
> +{
> +	u32 mask = BIT(port + A5PSW_VLAN_VERI_SHIFT) |
> +		   BIT(port + A5PSW_VLAN_DISC_SHIFT);
> +	struct a5psw *a5psw = ds->priv;
> +	u32 val = 0;
> +
> +	if (vlan_filtering)
> +		val = BIT(port + A5PSW_VLAN_VERI_SHIFT) |
> +		      BIT(port + A5PSW_VLAN_DISC_SHIFT);

nit: could this be expressed as follows?

	val = vlan_filtering ? mask : 0 ?

> +
> +	a5psw_reg_rmw(a5psw, A5PSW_VLAN_VERIFY, mask, val);
> +
> +	return 0;
> +}

...
