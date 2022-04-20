Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CD1509365
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 01:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356406AbiDTXNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 19:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbiDTXNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 19:13:08 -0400
Received: from na01-obe.outbound.protection.outlook.com (unknown [52.101.57.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EC5B1DF;
        Wed, 20 Apr 2022 16:10:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qc4QUhwqOaYtg4FkKG1SRBSPjqVldxDu2t6QgYqL9uX06p4ir/ZRZjluPYotwooLdG2bKRYVqewWY2B8DUOisMrj4gOkXCNLMg/2fbbaVf/ciWfLlO6LUcsoQOto0ew0W9a9Lig65aVMDdf57eHxYTzZFJD1NYT6kuA0gNFevXu76FZJIKe1oZHwcdcUkmZp5E4TkoQtC4bolABgWcoJ26lBgpUVmbZHAs3sDCC4V0L9a2aCxe7HrlVyrBUb6zqCqWMXOGUoMz6cAyZnCbNC4XxHdT2Sp+RGhl3aiuGMJ/GYX+6YQgBvkm5MY7tVhx9t0uJTq4D9VHtyVkk+TSpiVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9eW7Nz6DmMLuzeODOtwgjOdCXkph4drHRjYVmByjeQ=;
 b=aZb1oregDKoGtLzPr6rD1xlhF3q7JqHKgSntskXeP8IWlxOxqBpKjYknBej6TGyY4HOaVktIC8TGfQBTJ6Wk6wVdzs0V8oZkLmsQ5uKp0Rg0e6gL/+0UtQJtAVCRz7B+GKifdxdMKFzUktDzaBxhPhbGnssB0LiOUGPpnJIEEExvhHy2F5ot0RIMRmZoe3jaBk0dWM+yY+U0AWzttBuLJCCXMHISY09WUmyM60AIrvzCBygkWp6IPeuBfn/zgdrBhcF9UGAmP0lwZCJhg3ZGA1A3iyryIb2EOqYOsJJEGndZKdTabG1anPY8OXr2Eugtrz2vj+sFxH8VdYwTnxdM8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9eW7Nz6DmMLuzeODOtwgjOdCXkph4drHRjYVmByjeQ=;
 b=eY6ntLcDV6oEVJ2qS3tdVTP19Y0nqElS9XoWVa9mqR223K87CmbleKGYqFIsJsFoSoLnaMmzqHly5mxEDC0Ho0GUhUHvpVm2UA/In3BAOKScg+sm729LTGxDTaWE9dw2UPTdfybqNDPjqbU+Tf493m+DGaePRhek54GjvBqOljY=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by DM5PR21MB0634.namprd21.prod.outlook.com (2603:10b6:3:127::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.6; Wed, 20 Apr
 2022 23:10:12 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df%5]) with mapi id 15.20.5206.006; Wed, 20 Apr 2022
 23:10:12 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/5] Drivers: hv: vmbus: Accept hv_sock offers in isolated
 guests
Thread-Topic: [PATCH 4/5] Drivers: hv: vmbus: Accept hv_sock offers in
 isolated guests
Thread-Index: AQHYVPJRIBYs/G2350qJG/ucPvMJ8qz5bYNw
Date:   Wed, 20 Apr 2022 23:10:12 +0000
Message-ID: <PH0PR21MB3025133451E4004BD816E668D7F59@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220420200720.434717-1-parri.andrea@gmail.com>
 <20220420200720.434717-5-parri.andrea@gmail.com>
In-Reply-To: <20220420200720.434717-5-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=cd468dba-37c5-4cec-b845-28b96798a233;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-20T23:09:36Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 341bbe8a-6a23-4cca-6cfc-08da2322ebf7
x-ms-traffictypediagnostic: DM5PR21MB0634:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <DM5PR21MB063474CDD223D8EB609BE3C8D7F59@DM5PR21MB0634.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uzuVv7YXetMRc8alus2KVqzx0hova25ntxQf0bThqHRos4L8onGa5T1UweBbUKpIG5tHug/T0LC+0UTE0xeHZ6diU9A83Bn6ILU2E9OxMSKHB1MWTDRU2oP4ZEs6VXJctWPrqGM2jFl6kne5UYAxb/7LSSNMciF0W6ODSjqNl/sy+Nvh1Xsx95+c5YQDZxUgCwVk0WUxhWuqd6iY0anw9riKlcB5uPwAHR4H7yCxbt6584zDKxgfanS85N3u5sug+D17iRySYuFiW9L5QqM5AHIsjSaGzjRcMQ2xUk+DXeD7cXR2xZootx+poszQnKCnawNaDqN5oKnYuFvjmQwmnKnT8Vv2PP0bq9PFsMqKAkfyhWPY9lavraJCBxMQSPowdApPOHHTKVL2pGZ60fxIfK2kaZB6ik8bnHWi6JIBsDM11bs6LeP0VZPknLeZJS+q9FX8vUQ2YQAui/DfIbPPWOxM030Ysid+yfPj9lZjovEqWk9h4ZAS4KR+DYeDEDDDQBhRol4jpB3nqbYBIVTlt8zmcXGmSeGYO6t6yTZDJuq0NpP1G7iflVEU24Z6worfyksD9giB11KwGDS8yqYYr3wcPihcL3pIqgjiqEFKSPJTcVdCs3ODrp5PYmOpDczmIgnVYeb8lfzv/Tl5G3exsCYQbGFLHYwzlpOQPMS63QuaMEyeBcocWyDtvntIcpOTN1jaExpzW74KEbaVvr36NpEAJ9QXoraQDPBKchLLBTlnr0mj3vbloXOkOUNV+JWZnSbWA6n/Mlpf1jp+U8GYCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(26005)(8990500004)(6506007)(86362001)(2906002)(9686003)(186003)(110136005)(66946007)(7696005)(4326008)(54906003)(316002)(8676002)(64756008)(66446008)(76116006)(10290500003)(66476007)(66556008)(38100700002)(83380400001)(38070700005)(122000001)(55016003)(508600001)(5660300002)(7416002)(71200400001)(82950400001)(8936002)(52536014)(33656002)(82960400001)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vB5YhlGGr7qIDBSwDFPjThUvzM8d3+/Gr9O8fNJWUK4oR3OPqJZ0mVSbeAi0?=
 =?us-ascii?Q?mqpaNH8HNQF8+IqXWxmKcnco4bjx4c3K6yuxYumOuGtTvQCgz6oM1lNuvHN+?=
 =?us-ascii?Q?Ck3Z6CPph5fgQ5Y9PnzMd2wPtsDw0nYvISDoAfrcnrp7S6U0L/66jXapcoIi?=
 =?us-ascii?Q?uNOumAtnEQFK4tarR93c/oTKY5Oq7t5r0vNc37cAq7F38J9ciAIoilGTfyPC?=
 =?us-ascii?Q?Mn3dsD5BiYTdb8vRccUrnLEq1bCJGwlBN7X/qN24t/R7FW/yonAO5GsByYof?=
 =?us-ascii?Q?wi7IDL84kp+wkFAH0ODZkbAnPVYul6GdPs7fSPzUzXSF9kWsMDhqXzpvs9wC?=
 =?us-ascii?Q?J/FQY54EdCapiC6El3LN6A3rwaUeFOQ3PKIeWynywtR71U2Ywer7roLjIgrB?=
 =?us-ascii?Q?Yckh+lvJm+OF62/58b0dee/xuEQHwE2Xdm8ensGpOnQOcMc6tLwS4ZPSrdxE?=
 =?us-ascii?Q?YJScgHhQ3+U4ZN1wh7P6cp0mxhcXZj7Ey5tCJktvzCgPSt/B355Xep414bNW?=
 =?us-ascii?Q?kYJRegNRX/95HTZSMZpHAsMRZWIFfStWSGF6BaN0sDKpeigDts0R8CTRtzAP?=
 =?us-ascii?Q?xIumtrHeKpqu1YPI+4ts2L5kq1ezE6sNp757Zls3iARLG9K/4uko8YUwkqHt?=
 =?us-ascii?Q?Yx4f3p4qVaneyAmoymwkM4ftZwY5K6pvNF9t+ktt/TOzqPAQgpqugTJ90rw5?=
 =?us-ascii?Q?IvkCWBCi4cO+6DzY/R6E3Nqa3szHr+MKeTv2K3nTXpLF+amalCk6zX6I80pw?=
 =?us-ascii?Q?mi8INyDGrsjRAEnxmVlL2XOAlaQEYHjAw+4J29Gzm9oRWcVqR1QgGWc/RRey?=
 =?us-ascii?Q?pgAg7lnZOQnW21xXtL7WF1UWoA8Wset7JLhncsluoNG6G44YFBR5pkXGzTUY?=
 =?us-ascii?Q?CGMJeECiNu3QmXjndC6H0VHlDuIF8st1/mNNcZU24JSBNadugKpEgm8BkVEK?=
 =?us-ascii?Q?uoRiYfLeDK30Th0hHYV7rZ7gnBtWSSWmofjnH7qEvI7z/rNymZzjW0tIo+Ks?=
 =?us-ascii?Q?F1TevYgjp0ZqZYnCwY/Bu00wfWKG/9vXiz5T8MCb97SEFjASBcYErWWRTJrb?=
 =?us-ascii?Q?2YGWzpIFeBCPBvKPdrWgXJhytBuSholEg4OAaBjDFj4VUALKaACF1/qU490i?=
 =?us-ascii?Q?wPwJR7ZJPkZUjKAipkXr5IRhfAarDz1bHFKkhGwU/g8cRwuXmmqrtHcZQAuO?=
 =?us-ascii?Q?BB7gxH5JTp6uFP95tCyITgJyqqk1Xgmz/wz6HXZn0rJoD9QelTVNs8FLDCPM?=
 =?us-ascii?Q?R9mQ746HVex+AZiIC/BbcGxaTjdh2VCo+Ga2tiUWmhdJqMew5WmM2rEzxR7c?=
 =?us-ascii?Q?svK+FirO3eN1zO/UurWySZ3k+f0Jp/ehiSJwBwlNCbJ4TFy3XwX3BnnWOiZH?=
 =?us-ascii?Q?ljaLAeVulb6AsG7gLIF+JJezwogVQmnnbroLAxk2ScBcyhBYFMLkU0dvpiTD?=
 =?us-ascii?Q?PZBaI20+1QIJCs0Vuwp/4Bm7qYodpcaUanl4DtEydXQLB83OjgZyItfVe98s?=
 =?us-ascii?Q?40GNahKEB1eadIENmnFvkckJX6eIsIdFQHegp8KIuoD2e/6bWWep1MYSjQVB?=
 =?us-ascii?Q?DcLv6jBpKCBlvuJhjHTW9AdvRTP/HcIiN9QAdLQgy5AOX6cL3UinJHp3KTAn?=
 =?us-ascii?Q?CpQjJLRlrR5NfBoWlT0DtQMOPLNyjCp9gReh8n04LOKRg4CNMe9ZocYaygCU?=
 =?us-ascii?Q?eqv/BIW1SqN+Mgkm6IxBoo/7+14yqJ1+ewVQrgB6CLNgkZ3HYdOunBgqKuW5?=
 =?us-ascii?Q?HKmt2KxR8wxs45TlQ856jnBa/cE5K10=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 341bbe8a-6a23-4cca-6cfc-08da2322ebf7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2022 23:10:12.0667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c+HrN2zFvjkqUPi150NRkM1qIrh64LllWo/xo3omOjO+a350tp95Hq+FJxVHWVEiNAhegPauP79PQlgNkA2NQXDbc9xyS3410cVVCFVcXXY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0634
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Wednesday, Ap=
ril 20, 2022 1:07 PM
>=20
> So that isolated guests can communicate with the host via hv_sock
> channels.
>=20
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> ---
>  drivers/hv/channel_mgmt.c | 8 ++++++--
>  include/linux/hyperv.h    | 8 ++++++--
>  2 files changed, 12 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
> index 67be81208a2d9..d800220ee54f4 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -976,13 +976,17 @@ find_primary_channel_by_offer(const struct
> vmbus_channel_offer_channel *offer)
>  	return channel;
>  }
>=20
> -static bool vmbus_is_valid_device(const guid_t *guid)
> +static bool vmbus_is_valid_offer(const struct vmbus_channel_offer_channe=
l *offer)
>  {
> +	const guid_t *guid =3D &offer->offer.if_type;
>  	u16 i;
>=20
>  	if (!hv_is_isolation_supported())
>  		return true;
>=20
> +	if (is_hvsock_offer(offer))
> +		return true;
> +
>  	for (i =3D 0; i < ARRAY_SIZE(vmbus_devs); i++) {
>  		if (guid_equal(guid, &vmbus_devs[i].guid))
>  			return vmbus_devs[i].allowed_in_isolated;
> @@ -1004,7 +1008,7 @@ static void vmbus_onoffer(struct
> vmbus_channel_message_header *hdr)
>=20
>  	trace_vmbus_onoffer(offer);
>=20
> -	if (!vmbus_is_valid_device(&offer->offer.if_type)) {
> +	if (!vmbus_is_valid_offer(offer)) {
>  		pr_err_ratelimited("Invalid offer %d from the host supporting
> isolation\n",
>  				   offer->child_relid);
>  		atomic_dec(&vmbus_connection.offer_in_progress);
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 55478a6810b60..1112c5cf894e6 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1044,10 +1044,14 @@ struct vmbus_channel {
>  u64 vmbus_next_request_id(struct vmbus_channel *channel, u64 rqst_addr);
>  u64 vmbus_request_addr(struct vmbus_channel *channel, u64 trans_id);
>=20
> +static inline bool is_hvsock_offer(const struct vmbus_channel_offer_chan=
nel *o)
> +{
> +	return !!(o->offer.chn_flags & VMBUS_CHANNEL_TLNPI_PROVIDER_OFFER);
> +}
> +
>  static inline bool is_hvsock_channel(const struct vmbus_channel *c)
>  {
> -	return !!(c->offermsg.offer.chn_flags &
> -		  VMBUS_CHANNEL_TLNPI_PROVIDER_OFFER);
> +	return is_hvsock_offer(&c->offermsg);
>  }
>=20
>  static inline bool is_sub_channel(const struct vmbus_channel *c)
> --
> 2.25.1

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

