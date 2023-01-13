Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D4C669368
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 10:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241220AbjAMJ4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 04:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236486AbjAMJzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 04:55:38 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2119.outbound.protection.outlook.com [40.107.220.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2D0559F9;
        Fri, 13 Jan 2023 01:52:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eGd+pVspX2j0h/KCaMpa0H6YbDaG4j8R9UahzyOefhxUL59XqUOjBGOJ2kNik5ZVMmhmo0yUl4m4AumnpO1CerG8QyRog6emGzSUHNe5tF5zeswanowVs+2bPGge/Xvg+BEC2jh7bWynG654Hn5NVw+wXfTGoo2sJ2O6ZOk2dPXfjcyLHK4/GppOjmbf2wR40JlUp/vLEQE+Qo8wBdhfFlCFOAwxYTI9spNbmWJXWV1bygBUgnz9tP/Bh58Pvou60/blHjNCpTSW5DJEnIYFY3qzJqsiJP3UB1L0VCtCEbWN18WSHuhdimh0iSpTjq4r+4S/tioG+aAV2Bk+btn/Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZqCgVqj5kRUE7OItWxPHQuAO2KhGJMNW39QxPcQxq9A=;
 b=hh0ZAQ8hJcf/THLYLbJLBpzOGfBAsPGBfunmLiNpkllQfHzG0LCDXKhXn74KSydppeUWhQwjKuTgZ3ku/+q7Dm16Y3FGUw0fX5vAjoz+KWQ9r6BFqUdF7kUEAfG/zok8IaS3UnEmF4qBmVwiKyv4e41VxQw1bQLy7Wqgrf81cUU+OlM9LKSfGCZqGfYdEE9KqAQ/LyEqzlrO40zyWIHBfMAJ4NUtPrRKIBIavI1cBzFwnBValHnTgsgMi0ytf74QpdAvy/2wDKGUp+n4mGvwrA+IBq7lbUj9knaAudYyT2aSnPFrI9cXtlcbkXiOt4C8YbCWNTVYkFw+UR2TMNgZTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZqCgVqj5kRUE7OItWxPHQuAO2KhGJMNW39QxPcQxq9A=;
 b=gAy+kAOV3VycdZyP+GHkDePE9wp+BWoapbNXm+poOsk5MMJKs7jrgcfTd8dO3HAmPuKGIHqmsdisjanCA26HMgKLvVCspkHhKlx/pske7sV9mlRVlN8AgCBBZuTDE53LSNLuIvRq36R/tpJez2Xwxv2Eq9QcnHDZYPDno/O9wWI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5466.namprd13.prod.outlook.com (2603:10b6:806:231::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 13 Jan
 2023 09:52:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.5986.019; Fri, 13 Jan 2023
 09:52:38 +0000
Date:   Fri, 13 Jan 2023 10:52:31 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Doug Brown <doug@schmorgal.com>
Cc:     Dan Williams <dcbw@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/4] wifi: libertas: only add RSN/WPA IE in
 lbs_add_wpa_tlv
Message-ID: <Y8Ep3yTp61h0GD2A@corigine.com>
References: <20230108013016.222494-1-doug@schmorgal.com>
 <20230108013016.222494-3-doug@schmorgal.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230108013016.222494-3-doug@schmorgal.com>
X-ClientProxiedBy: AS4P250CA0029.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5466:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b68e1d6-2155-4de7-144e-08daf54be742
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ig/bhYHoJobdKHLLVef6rv9VSRgvfA+M8YZXunNLi6DEGsoFR095sY8hNScATn4nEdBucHzHCYtI8xeUlmeeEUkHWgJeafat9mvh3cTZbdaxQmYbEwrOcj+arA5yI0u6ah9pwuysMtJ0sdvHkCb37nrW5HyCGnzoXeM3iAq/pVAMsIS6xd4vuMIXsGkwjZcvEiPpkVnBtCJmoG0qnCJqkcKkPlunyKlfdYO0xbcp3/RFN8wzH9Gz+XXV8t9y1e8hTB4R0lMHGbCI8/VRseGhomR/RKOU7FiuJup3lz5nFD8u+hapRZt/AytOgixEUa4saO6qasynOWtuaTgsdN9Hy07i/Sn+DdfgwvYspmfMbiQ4nWP8tAp0qdwKL0PnZANyk4rBrcQTlPGB3XLKp7hNM+vRBkvte0JKDjIZDDnL4XPg76nsUiBHqHVx7QLey+TbIkafGxmOv9hPSFvKP8rEiywg8Gj1vPPHjsS/XdIj/bSRxNANFy4jCuyzuY+Z58TQ+KJhCkQJmv6BzoKzse4X57jj1JTX7DVy6nIFCZkuQq37SxogBfLkkzHJLFQyjEp2U0lJ/N+W+WPYkGGE3IAraYN9Pb7tpULT+NkUSbRXEnP2lOxQS7JIZxSr0Tqo3x+krVqlyAOncfrwqaLu4+2KVonJ/8TXmuh84pPTHh39QNmzbrR8K8PfaVInl7ysK093
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39830400003)(376002)(366004)(346002)(451199015)(66556008)(316002)(2906002)(8676002)(66476007)(4326008)(186003)(6512007)(36756003)(66946007)(478600001)(6486002)(38100700002)(8936002)(45080400002)(86362001)(6506007)(83380400001)(7416002)(54906003)(6916009)(44832011)(6666004)(41300700001)(5660300002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?THB59dHUpgVa8kvvJ6FJs8O/a8B1ZAnjJAyrf/wg1wT6Y6bnuw/ogRtn94Dc?=
 =?us-ascii?Q?+I+pwaIiw5PbH1ipbbqB3JXQc1Ro+3UjIRUIBlhV2LjJf4jlSATXMzcR/haf?=
 =?us-ascii?Q?dHMzO4RZ24CqXBhZcIHLCKwQK6Qxp19t/gWkPicWG04fFF/0aFT1cc8VzAWS?=
 =?us-ascii?Q?rd7j/n9wCGDwgPza5eGr5L4moWC0Qg/+TznId4r2IGkUatad2YV/7b1/T5Nk?=
 =?us-ascii?Q?Jbdq0JKgCAsSFhKz8hlymjyIQLwyrpCJvusYDEXh1pPLq+NMxfzK+2S1ZCq5?=
 =?us-ascii?Q?74acZuv3S1yM23/scKGdoeVsMSh43nZ+YcEwYkzVdHHFnZfLCYrqOYP3aS5i?=
 =?us-ascii?Q?xP9l97MCc2HvO0qzo/ZrMYD/MIMx+gohLAI7x3qFGPG5s5tyHvW22XlNA3fj?=
 =?us-ascii?Q?QRWboRr6U6m1jtANPYrtl4ewor6I2L13KOx4IP7As8MplmRuC3JtBhJYHVQX?=
 =?us-ascii?Q?BE4g1ds6A9aub2NGz6dIJUYwAmtR1DEATKFfepl20QphU1R8TaNnXPCQUeJZ?=
 =?us-ascii?Q?ArgOp770Z7JVSt8FgVVKlT/7mAyWx7vtg8wm9dqSgKTlxL9CzuWtZpSrs7/Z?=
 =?us-ascii?Q?OYxKQEbOLK9CZzlDm1QgY7v22Sfzl2MJZ5Umb+nhgLWotmWyrHrG9iOxIhdX?=
 =?us-ascii?Q?gcv4BtaVajOChQ+mEvFOrCb1R8GfpSWsGaJn9/BsisJDXNBtiBoN+u88grNX?=
 =?us-ascii?Q?1NqjJO/FwKa4DWyvzObNxtDT9GC+oQD2Rvl3jYVRhd7jVxCGeRdTCA1lIGW5?=
 =?us-ascii?Q?6KiZ3xv0GWVp1QRltQeYo70JpkNJCFdc29mhEC44VCOWIhxxZkPNyfzAC2v+?=
 =?us-ascii?Q?xzBzajjIiMh1Na499Ajc6pbOnzSz6dC1L2xhHfl71xPKr5RQjRe0jUv/x2hj?=
 =?us-ascii?Q?shCNjWdmjjt/TtgYH/FZOjSzWibdwUenzwtUnrhHt1g7jSSFIsaRdySjN9dv?=
 =?us-ascii?Q?ojcjZYdS5mBMKRfOlBLkK+kWBp33g4ZkLDwtg1KMVbIsDhoGRfrFmCOCy406?=
 =?us-ascii?Q?fkfAgrQLmv68ftPZtDSEhlhYtyUuZn/Nl/W+wDWhtyXI49XvRRjJPl/J5/MS?=
 =?us-ascii?Q?o48+DDDHEQnTEiTMdkK50ov5NtdjeB45IlnZZYlTZE7zQqv3Vi5qAx3T6qU/?=
 =?us-ascii?Q?ZFBLKe40Trv7Cas0Utd+TczTlSfDz2bjieyh8nfmAaS02EqQk24VaYbuEkun?=
 =?us-ascii?Q?k3MmFubCqcE+Q/Tw12vjJjO3x6TBfJyvEcdFJwi2Y5zaagWfDNejOe2yLQPv?=
 =?us-ascii?Q?HRKyptmsFrMRapOcfDKiJAHTXdd+ZzbkzWw92jVZjAu7ka+dBrDXj3syXDjl?=
 =?us-ascii?Q?cCIgGrhlg/Xrc4STnLaIw8sF8EH5Vlcgcsz+7EBzdgULzgFIs6XFRsOA/rbd?=
 =?us-ascii?Q?OVIgE7KZBQSwbsFu+1DDBsgwDvRkM+9NctxT30SwfeN10T4P7vg1mmm7U9YZ?=
 =?us-ascii?Q?yow8AW02uIh9LrQhJeuAIW6V1irlvyoy03YJFlNo+Lhm0zc3vWbO524ro4aF?=
 =?us-ascii?Q?2xzfwyojN2uguxjEjywC22D1uCgJ5haFEcW/+n+b0lMD4kPKDBoTvK7AwIhv?=
 =?us-ascii?Q?KWtlMZnkdIv8VRVQri97vUqEcquYpaGOezSj3NMjRhYJ/y/qxPVz4xqtXcoX?=
 =?us-ascii?Q?h1o+WmuvhRfZKHO2M1FeO6x1PxWb8nWzv3KgwNuurCs1LmYcgraNrzscZHw2?=
 =?us-ascii?Q?rosRYA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b68e1d6-2155-4de7-144e-08daf54be742
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 09:52:37.9753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MmBuoyAFdZD5VgzBhBO5oHpTVH13FgyISbFiB0vgj4R9jy/x8zcf0j0rHqbfPUc/voIXdLEsp15/6uJbh9jfe7hJ6QtdukWC0KAlqemOJcE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5466
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 05:30:14PM -0800, Doug Brown wrote:
> The existing code only converts the first IE to a TLV, but it returns a
> value that takes the length of all IEs into account. When there is more
> than one IE (which happens with modern wpa_supplicant versions for
> example), the returned length is too long and extra junk TLVs get sent
> to the firmware, resulting in an association failure.
> 
> Fix this by finding the first RSN or WPA IE and only adding that. This
> has the extra benefit of working properly if the RSN/WPA IE isn't the
> first one in the IE buffer.
> 
> While we're at it, clean up the code to use the available structs like
> the other lbs_add_* functions instead of directly manipulating the TLV
> buffer.
> 
> Signed-off-by: Doug Brown <doug@schmorgal.com>
> ---
>  drivers/net/wireless/marvell/libertas/cfg.c | 28 +++++++++++++--------
>  1 file changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
> index 3e065cbb0af9..5cd78fefbe4c 100644
> --- a/drivers/net/wireless/marvell/libertas/cfg.c
> +++ b/drivers/net/wireless/marvell/libertas/cfg.c
> @@ -416,10 +416,20 @@ static int lbs_add_cf_param_tlv(u8 *tlv)
>  
>  static int lbs_add_wpa_tlv(u8 *tlv, const u8 *ie, u8 ie_len)
>  {
> -	size_t tlv_len;
> +	struct mrvl_ie_data *wpatlv = (struct mrvl_ie_data *)tlv;
> +	const struct element *wpaie;
> +
> +	/* Find the first RSN or WPA IE to use */
> +	wpaie = cfg80211_find_elem(WLAN_EID_RSN, ie, ie_len);
> +	if (!wpaie)
> +		wpaie = cfg80211_find_vendor_elem(WLAN_OUI_MICROSOFT,
> +						  WLAN_OUI_TYPE_MICROSOFT_WPA,
> +						  ie, ie_len);
> +	if (!wpaie || wpaie->datalen > 128)
> +		return 0;
>  
>  	/*
> -	 * We need just convert an IE to an TLV. IEs use u8 for the header,
> +	 * Convert the found IE to a TLV. IEs use u8 for the header,
>  	 *   u8      type
>  	 *   u8      len
>  	 *   u8[]    data
> @@ -428,14 +438,12 @@ static int lbs_add_wpa_tlv(u8 *tlv, const u8 *ie, u8 ie_len)
>  	 *   __le16  len
>  	 *   u8[]    data
>  	 */
> -	*tlv++ = *ie++;
> -	*tlv++ = 0;
> -	tlv_len = *tlv++ = *ie++;
> -	*tlv++ = 0;
> -	while (tlv_len--)
> -		*tlv++ = *ie++;
> -	/* the TLV is two bytes larger than the IE */
> -	return ie_len + 2;
> +	wpatlv->header.type = wpaie->id;
> +	wpatlv->header.len = wpaie->datalen;

Hi Doug,

For correctness should type and len be converted to little endian,
f.e. using cpu_to_le16() ?

Likewise in patch 4/4.

> +	memcpy(wpatlv->data, wpaie->data, wpaie->datalen);
> +
> +	/* Return the total number of bytes added to the TLV buffer */
> +	return sizeof(struct mrvl_ie_header) + wpaie->datalen;
>  }
>  
>  /*
> -- 
> 2.34.1
> 
