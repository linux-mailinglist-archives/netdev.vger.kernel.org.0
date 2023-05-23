Return-Path: <netdev+bounces-4676-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C18570DD4E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:16:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A0E81C20D30
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F121D2D3;
	Tue, 23 May 2023 13:16:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4516B4A84C
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:16:15 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2077.outbound.protection.outlook.com [40.107.102.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302AAFF
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:16:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zymp2Eobzp8EGTokris8iqQw4Gz7t5Y/DqWXVjf1/I65Q5DIMpkMRAgTYWd8fWNGhcc2XdoAJJPf7lpZtKfXkEV/x+LHwlrYvC99Mp30AQPkxqdMwv+yhfBsEy60bTgY2qQIAC0MoKLrkQhYrtK+8MV1UC29lfyYWSWgrNqEHu4zEpX4KYhfvj8IU83P69fXs4WYzKvMOyUdCtRT7mJiA81sU11KQIskDBhHVUxdU6xTmTLubZBtI7ZxQPYRKLQevH0Fl2VYeWNrX4z1xfkiTJm1ESjhWqiOkCB/1n10nRCIv4Mcpe0BcStf2tOXWEE2nBsHBjPB0T5bh/82M9Gclg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQ0TgP6PGUJjub0/oMBSKzyZS/J7EEKku38/qVYY8fY=;
 b=Ko7a9oAeQHdFPfmIl2UlTcptv6uzWTsHsYb5xEsw1ak1efNWDCTMhVT6g6WdoNyTPM55A+kV7KOb5w8gxAM3/uUBn214lUy6j6Q2KOI8TbKybKF2ICfx8g8Iva1nBwjXhXBHgq9TsTzou1C5Vq1sMwY/rLY9/dQsap11kYMj2TO99T9c3qv/6DgeIiMwvS0NdF/B8YSF/I2DLY1IZP+7BeBQOH8NZZoDqBpsPwrkyT6yjVww3qKgTNmJTOjlEgbZU5jBBmiqyEi3HtG1QgID3xifnkpVX4x9wPDWujmjnMSYMUCZFkJDpYmeosbcPzzhIlSxITUOddQse08xgqOv9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQ0TgP6PGUJjub0/oMBSKzyZS/J7EEKku38/qVYY8fY=;
 b=WTHzSeOj/N8in2HuoKVgDVGK8RAipREvh/FeOeDS3u+IIeoVHZobHHwxsbMxlUS2ArljB9zevhEmu4Pb2PNTjOU6RalLDaHjhbGNy5Y3SdR8MMxqZz1OC7/e0kX4t4oNVka65DIXWZbIlT+Gjx6Tdh7sCOCEBWz24onVWDyrRtkBiJNL6NueSN2SZFxc2Qf74nowKU5AV98bitlUltHaV57o606Sk2VmJwK+11Pr+Ur9rX/oJBliyal5p21NlGJTf81tutW1+dJF4i6Nndp6XUzW2LBdZl49VT/xCtit4XImIo2ZIl1d/opr6R3rXfleK5CB+p3GEAzDr1u10LymsQ==
Received: from DS7PR03CA0180.namprd03.prod.outlook.com (2603:10b6:5:3b2::35)
 by PH7PR12MB5878.namprd12.prod.outlook.com (2603:10b6:510:1d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 13:16:10 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::c4) by DS7PR03CA0180.outlook.office365.com
 (2603:10b6:5:3b2::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28 via Frontend
 Transport; Tue, 23 May 2023 13:16:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.29 via Frontend Transport; Tue, 23 May 2023 13:16:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 23 May 2023
 06:15:54 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 23 May
 2023 06:15:53 -0700
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
 <20230510-dcb-rewr-v1-1-83adc1f93356@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: Daniel Machon <daniel.machon@microchip.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 1/9] dcb: app: expose dcb-app functions in
 new header
Date: Tue, 23 May 2023 13:18:40 +0200
In-Reply-To: <20230510-dcb-rewr-v1-1-83adc1f93356@microchip.com>
Message-ID: <87lehf5gu1.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT060:EE_|PH7PR12MB5878:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d4b3a12-4de0-4743-1905-08db5b8fe033
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mToj92YvMoWuY4ixkKFhhDJWQa3H0ISTUDQmaXCq7U6cps06/XzUOOWeGc63A650V8m507c1fVcOWRZQO6hGaCkP2+MJtsRDKyjb7WKqYZ+etkDUvxN6ERnOL4pi8WAeqJ0hSpmnLNGqZ+hWsP8jT/Wf19UgAKPo06ZoZwMLw2rCiFWvuCa15mGF4dJsDo68luLAg3evjNX4M4i8LPPddyzLFPyRBLnXYHYh1gxkyDDoCKhf4sFjXBVu130IWHp+MUNttXFCqhz2Ug1Z1s89vbEQAPZf+5kVvQTE68KdAdPjisnjynbNql4IvRb1eLdxtMhz6Z51gYZAwzBcnwAGJS7G1Hvt4Lts5qaSG16R2RRNP/pgGSkDPpgXOmZbwsUHOCc6USfy+bAEk7glCGFfONdXT2Mkvokdg0wEWfRPfFsVAiZR+bnkm6SdyyAkDN3JY6c+2/WeZ48TsGxkpG9uhtXZ52FKj+va8s7yQP+yAmpAoct0WS84M8nnR5F9CvXnJ4bw9ZlSSRgYa1yE8TRModZg242g279RQNzB6O7k3XV67atbUrJ94HpB64zK792qo8mOebwfm8es0SY1JkRgSqB0SIZCZR4qrsMNA+snPAftnFexI3CSAt/V06Oz/4ZoAx3cwjUNhcZnIWdueCitv9q/bd43ghreubOfxDT/8Ac+18VBCFa5SlHj19VltXQ36d+uswtz2tQgWfAnWCrKB4ZjCXXST7BWsW9/qJ4P+zU=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199021)(36840700001)(46966006)(40470700004)(356005)(7636003)(8676002)(8936002)(5660300002)(82740400003)(40460700003)(47076005)(16526019)(40480700001)(26005)(186003)(2906002)(2616005)(36756003)(336012)(426003)(83380400001)(82310400005)(36860700001)(86362001)(54906003)(316002)(6666004)(6916009)(4326008)(478600001)(70206006)(70586007)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 13:16:10.1547
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d4b3a12-4de0-4743-1905-08db5b8fe033
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5878
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

> Add new headerfile dcb-app.h that exposes the functions required later
> by dcb-rewr. The new dcb-rewr implementation will reuse much of the
> existing dcb-app code.
>
> I thought this called for a separate header file, instead of polluting
> the existing dcb.h file.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> ---
>  dcb/dcb.h     |  9 ++-------
>  dcb/dcb_app.c | 54 ++++++++++++++++++------------------------------------
>  dcb/dcb_app.h | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 75 insertions(+), 43 deletions(-)
>
> diff --git a/dcb/dcb.h b/dcb/dcb.h
> index d40664f29dad..4c8a4aa25e0c 100644
> --- a/dcb/dcb.h
> +++ b/dcb/dcb.h
> @@ -6,6 +6,8 @@
>  #include <stdbool.h>
>  #include <stddef.h>
>  
> +#include "dcb_app.h"
> +
>  /* dcb.c */
>  
>  struct dcb {
> @@ -54,13 +56,6 @@ void dcb_print_array_on_off(const __u8 *array, size_t size);
>  void dcb_print_array_kw(const __u8 *array, size_t array_size,
>  			const char *const kw[], size_t kw_size);
>  
> -/* dcb_app.c */
> -
> -int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
> -enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
> -bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
> -bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
> -

Why the move to a dedicated header? dcb.h ends up being the only client
and everybody consumes the prototypes through that file anyway. I don't
fine it necessary.

>  /* dcb_apptrust.c */
>  
>  int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv);
> diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
> index eeb78e70f63f..df339babd8e6 100644
> --- a/dcb/dcb_app.c
> +++ b/dcb/dcb_app.c
> @@ -10,8 +10,6 @@
>  #include "utils.h"
>  #include "rt_names.h"
>  
> -#define DCB_APP_PCP_MAX 15
> -
>  static const char *const pcp_names[DCB_APP_PCP_MAX + 1] = {
>  	"0nd", "1nd", "2nd", "3nd", "4nd", "5nd", "6nd", "7nd",
>  	"0de", "1de", "2de", "3de", "4de", "5de", "6de", "7de"
> @@ -22,6 +20,7 @@ static const char *const ieee_attrs_app_names[__DCB_ATTR_IEEE_APP_MAX] = {
>  	[DCB_ATTR_DCB_APP] = "DCB_ATTR_DCB_APP"
>  };
>  
> +

This looks like a leftover.

>  static void dcb_app_help_add(void)
>  {
>  	fprintf(stderr,
> @@ -68,11 +67,6 @@ static void dcb_app_help(void)
>  	dcb_app_help_add();
>  }
>  
> -struct dcb_app_table {
> -	struct dcb_app *apps;
> -	size_t n_apps;
> -};
> -
>  enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector)
>  {
>  	switch (selector) {
> @@ -105,7 +99,7 @@ bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector)
>  	return dcb_app_attr_type_get(selector) == type;
>  }
>  
> -static void dcb_app_table_fini(struct dcb_app_table *tab)
> +void dcb_app_table_fini(struct dcb_app_table *tab)
>  {
>  	free(tab->apps);
>  }
> @@ -124,8 +118,8 @@ static int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app)
>  	return 0;
>  }
>  
> -static void dcb_app_table_remove_existing(struct dcb_app_table *a,
> -					  const struct dcb_app_table *b)
> +void dcb_app_table_remove_existing(struct dcb_app_table *a,
> +				   const struct dcb_app_table *b)
>  {
>  	size_t ia, ja;
>  	size_t ib;
> @@ -152,8 +146,8 @@ static void dcb_app_table_remove_existing(struct dcb_app_table *a,
>  	a->n_apps = ja;
>  }
>  
> -static void dcb_app_table_remove_replaced(struct dcb_app_table *a,
> -					  const struct dcb_app_table *b)
> +void dcb_app_table_remove_replaced(struct dcb_app_table *a,
> +				   const struct dcb_app_table *b)
>  {
>  	size_t ia, ja;
>  	size_t ib;
> @@ -189,8 +183,7 @@ static void dcb_app_table_remove_replaced(struct dcb_app_table *a,
>  	a->n_apps = ja;
>  }
>  
> -static int dcb_app_table_copy(struct dcb_app_table *a,
> -			      const struct dcb_app_table *b)
> +int dcb_app_table_copy(struct dcb_app_table *a, const struct dcb_app_table *b)
>  {
>  	size_t i;
>  	int ret;
> @@ -217,18 +210,12 @@ static int dcb_app_cmp_cb(const void *a, const void *b)
>  	return dcb_app_cmp(a, b);
>  }
>  
> -static void dcb_app_table_sort(struct dcb_app_table *tab)
> +void dcb_app_table_sort(struct dcb_app_table *tab)
>  {
>  	qsort(tab->apps, tab->n_apps, sizeof(*tab->apps), dcb_app_cmp_cb);
>  }
>  
> -struct dcb_app_parse_mapping {
> -	__u8 selector;
> -	struct dcb_app_table *tab;
> -	int err;
> -};
> -
> -static void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
> +void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
>  {
>  	struct dcb_app_parse_mapping *pm = data;
>  	struct dcb_app app = {
> @@ -260,7 +247,7 @@ static int dcb_app_parse_mapping_ethtype_prio(__u32 key, char *value, void *data
>  				 dcb_app_parse_mapping_cb, data);
>  }
>  
> -static int dcb_app_parse_pcp(__u32 *key, const char *arg)
> +int dcb_app_parse_pcp(__u32 *key, const char *arg)
>  {
>  	int i;
>  
> @@ -286,7 +273,7 @@ static int dcb_app_parse_mapping_pcp_prio(__u32 key, char *value, void *data)
>  				 dcb_app_parse_mapping_cb, data);
>  }
>  
> -static int dcb_app_parse_dscp(__u32 *key, const char *arg)
> +int dcb_app_parse_dscp(__u32 *key, const char *arg)
>  {
>  	if (parse_mapping_num_all(key, arg) == 0)
>  		return 0;
> @@ -377,12 +364,12 @@ static bool dcb_app_is_default(const struct dcb_app *app)
>  	       app->protocol == 0;
>  }
>  
> -static bool dcb_app_is_dscp(const struct dcb_app *app)
> +bool dcb_app_is_dscp(const struct dcb_app *app)
>  {
>  	return app->selector == IEEE_8021QAZ_APP_SEL_DSCP;
>  }
>  
> -static bool dcb_app_is_pcp(const struct dcb_app *app)
> +bool dcb_app_is_pcp(const struct dcb_app *app)
>  {
>  	return app->selector == DCB_APP_SEL_PCP;
>  }
> @@ -402,7 +389,7 @@ static bool dcb_app_is_port(const struct dcb_app *app)
>  	return app->selector == IEEE_8021QAZ_APP_SEL_ANY;
>  }
>  
> -static int dcb_app_print_key_dec(__u16 protocol)
> +int dcb_app_print_key_dec(__u16 protocol)
>  {
>  	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
>  }
> @@ -412,7 +399,7 @@ static int dcb_app_print_key_hex(__u16 protocol)
>  	return print_uint(PRINT_ANY, NULL, "%x:", protocol);
>  }
>  
> -static int dcb_app_print_key_dscp(__u16 protocol)
> +int dcb_app_print_key_dscp(__u16 protocol)
>  {
>  	const char *name = rtnl_dsfield_get_name(protocol << 2);
>  
> @@ -422,7 +409,7 @@ static int dcb_app_print_key_dscp(__u16 protocol)
>  	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
>  }
>  
> -static int dcb_app_print_key_pcp(__u16 protocol)
> +int dcb_app_print_key_pcp(__u16 protocol)
>  {
>  	/* Print in numerical form, if protocol value is out-of-range */
>  	if (protocol > DCB_APP_PCP_MAX)
> @@ -577,7 +564,7 @@ static int dcb_app_get_table_attr_cb(const struct nlattr *attr, void *data)
>  	return MNL_CB_OK;
>  }
>  
> -static int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *tab)
> +int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *tab)
>  {
>  	uint16_t payload_len;
>  	void *payload;
> @@ -594,11 +581,6 @@ static int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *t
>  	return 0;
>  }
>  
> -struct dcb_app_add_del {
> -	const struct dcb_app_table *tab;
> -	bool (*filter)(const struct dcb_app *app);
> -};
> -

This structure is a protocol between dcb_app_add_del() and
dcb_app_add_del_cb(). I don't think your patchset uses it elsewhere, so
it can be kept private.

>  static int dcb_app_add_del_cb(struct dcb *dcb, struct nlmsghdr *nlh, void *data)
>  {
>  	struct dcb_app_add_del *add_del = data;
> @@ -620,7 +602,7 @@ static int dcb_app_add_del_cb(struct dcb *dcb, struct nlmsghdr *nlh, void *data)
>  	return 0;
>  }
>  
> -static int dcb_app_add_del(struct dcb *dcb, const char *dev, int command,
> +int dcb_app_add_del(struct dcb *dcb, const char *dev, int command,
>  			   const struct dcb_app_table *tab,
>  			   bool (*filter)(const struct dcb_app *))

This has wrong indentation.

>  {
> diff --git a/dcb/dcb_app.h b/dcb/dcb_app.h
> new file mode 100644
> index 000000000000..8e7b010dcf75
> --- /dev/null
> +++ b/dcb/dcb_app.h
> @@ -0,0 +1,55 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __DCB_APP_H_
> +#define __DCB_APP_H_
> +
> +struct dcb;
> +
> +struct dcb_app_table {
> +	struct dcb_app *apps;
> +	size_t n_apps;
> +};
> +
> +struct dcb_app_add_del {
> +	const struct dcb_app_table *tab;
> +	bool (*filter)(const struct dcb_app *app);
> +};
> +
> +struct dcb_app_parse_mapping {
> +	__u8 selector;
> +	struct dcb_app_table *tab;
> +	int err;
> +};
> +
> +#define DCB_APP_PCP_MAX 15
> +
> +int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
> +
> +int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *tab);
> +int dcb_app_add_del(struct dcb *dcb, const char *dev, int command,
> +		    const struct dcb_app_table *tab,
> +		    bool (*filter)(const struct dcb_app *));
> +
> +void dcb_app_table_sort(struct dcb_app_table *tab);
> +void dcb_app_table_fini(struct dcb_app_table *tab);
> +int dcb_app_table_copy(struct dcb_app_table *a, const struct dcb_app_table *b);
> +void dcb_app_table_remove_replaced(struct dcb_app_table *a,
> +				   const struct dcb_app_table *b);
> +void dcb_app_table_remove_existing(struct dcb_app_table *a,
> +				   const struct dcb_app_table *b);
> +
> +bool dcb_app_is_pcp(const struct dcb_app *app);
> +bool dcb_app_is_dscp(const struct dcb_app *app);
> +
> +int dcb_app_print_key_dec(__u16 protocol);
> +int dcb_app_print_key_dscp(__u16 protocol);
> +int dcb_app_print_key_pcp(__u16 protocol);
> +
> +int dcb_app_parse_pcp(__u32 *key, const char *arg);
> +int dcb_app_parse_dscp(__u32 *key, const char *arg);
> +void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data);
> +
> +bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
> +bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
> +enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
> +
> +#endif


