Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4665417DCED
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 11:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgCIKHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 06:07:45 -0400
Received: from mail-eopbgr150079.outbound.protection.outlook.com ([40.107.15.79]:58177
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725942AbgCIKHp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 06:07:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJGvNS6zo4JoMcJP/j+OzX3v+7eSC3Iw88mU2MRIlNImY3VTTh+k4EmzcjxhgUJddzKk0yJyYGin+YYZ37VuOjnn8YT51KOaHD6CEy4HrTqdw8nYN5UrVO8okmmQR1GTbNvxPVeFtrGwXkmXOdZ9Kl9cKF8iMWLNLFwDMyoq6ZJw9AgJDIHxL3dBAGnMMWhgWBwjkk5PPCfdjdnzD0pzU1y8gb4M9cDuOpjMgs1MO2/FXhfYf1GmYjOdxd2k+ofd5/iTNRo7kjNaZVSvFWKN6MME2RXdJ7zIpuqJ4C8NByP57LI8OFBQMhawxVn9AbHdUhT5pYrYLCo91viADawOUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OcXC5cgXjvLLNwOOzxleK0u891jeMd4yOGLaNfkdVac=;
 b=fuiBoLz6A1b+VxmrvYrUkooiSvEeBhu9eJKW1DX5+iHucnEfaqFxsaI4m9eGCbWV/AOjUDwTRmQC/6U6/X9rd2p8f+RUi8OAr9sOhPUhEqLN07D2aonLzV22Rpr2ZAaF/3mERQVhMdHG0VeU0freRERs91XfBTHfpZYHYBZJjp8nJi0E1+5HlHcOcEVkfwZ+gQjR51FUYFgNuQpwr1ykQcYaoCjGpm5GhRImFNp/a3xID7vRLuePJZh/LJeH7AbJH5fNfCU+UuTVHudp+0JYL/LUlxyVZrDbigG+mBVUMhaduzHv1JuqSblGgq11OTECin5zDlbUtt4VD3aCt4wqoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nextfour.com; dmarc=pass action=none header.from=nextfour.com;
 dkim=pass header.d=nextfour.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NextfourGroupOy.onmicrosoft.com;
 s=selector2-NextfourGroupOy-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OcXC5cgXjvLLNwOOzxleK0u891jeMd4yOGLaNfkdVac=;
 b=fBJiegtSm14jDhYSOh3AWTcZq+uwvaMLZnJp4dfpYeJhaJFHVeQhoXMm0jd7KJX2vJeWZOEizdK7v4Ixgvb54fEsshzfbB4G9fsaA0SRBnegXzV+1LxylmX8eBFmgJNs5HwkkQ7gPPaxq5dQc/ZUYpvWp+ytiRfIoHa7E9Nm84Y=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=mika.penttila@nextfour.com; 
Received: from VI1PR03MB3775.eurprd03.prod.outlook.com (52.134.21.155) by
 VI1PR03MB4205.eurprd03.prod.outlook.com (20.177.49.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11; Mon, 9 Mar 2020 10:07:30 +0000
Received: from VI1PR03MB3775.eurprd03.prod.outlook.com
 ([fe80::ed88:2188:604c:bfcc]) by VI1PR03MB3775.eurprd03.prod.outlook.com
 ([fe80::ed88:2188:604c:bfcc%7]) with mapi id 15.20.2793.013; Mon, 9 Mar 2020
 10:07:30 +0000
Subject: Re: [PATCH ipsec] esp: remove the skb from the chain when it's
 enqueued in cryptd_wq
To:     Xin Long <lucien.xin@gmail.com>, netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
References: <2f86c9d7c39cfad21fdb353a183b12651fc5efe9.1583311902.git.lucien.xin@gmail.com>
From:   =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
X-Pep-Version: 2.0
Message-ID: <37097209-97cd-f275-cbe2-6c83f5580b80@nextfour.com>
Date:   Mon, 9 Mar 2020 12:07:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <2f86c9d7c39cfad21fdb353a183b12651fc5efe9.1583311902.git.lucien.xin@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------1492D3D5E4B3DFA7B1B682AA"
Content-Language: en-US
X-ClientProxiedBy: HE1P195CA0018.EURP195.PROD.OUTLOOK.COM (2603:10a6:3:fd::28)
 To VI1PR03MB3775.eurprd03.prod.outlook.com (2603:10a6:803:2b::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.10.10.144] (194.157.170.35) by HE1P195CA0018.EURP195.PROD.OUTLOOK.COM (2603:10a6:3:fd::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Mon, 9 Mar 2020 10:07:29 +0000
X-Pep-Version: 2.0
X-Originating-IP: [194.157.170.35]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4175fe16-c093-45c7-386e-08d7c411ad4c
X-MS-TrafficTypeDiagnostic: VI1PR03MB4205:
X-Microsoft-Antispam-PRVS: <VI1PR03MB420547875CCFB06E6D722C8F83FE0@VI1PR03MB4205.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0337AFFE9A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(366004)(396003)(39830400003)(199004)(189003)(8936002)(6486002)(2616005)(956004)(235185007)(4326008)(2906002)(86362001)(21480400003)(52116002)(66946007)(31696002)(81166006)(81156014)(5660300002)(33964004)(16576012)(316002)(31686004)(36756003)(66476007)(186003)(8676002)(26005)(66556008)(66616009)(16526019)(54906003)(508600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR03MB4205;H:VI1PR03MB3775.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: nextfour.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UI4emvtt3kIYL0yb7XKzrQO+trl2ZX8jwXFY7y16koqaYooJSisyGGVD8Nut+jVUyHf142SQ8/rUil6aTbtTBfs9BBBloV6XmFQcOH6Hs8c2x4vrkifDx3B/lbk3WwvAMrr++zR6CPNqG0YMcoq9GiLBInJYbjcCNeDMchworUH8vhIykmclerl85kBfjThOfxl8DESDxwcPDFmWMdiUjt1N/+jU6uiwX9NobRgf/8phMvTobAF8grUuG0pbcnPHTqSHXnU8HYCi7/9fCx9dtOiBh2c95fM9odKgLcjq1NbQ2S/aaDtN1srbCqOmHQRtwDGQuexiEaobai2SAGwz7ay4oEBchr1pGgokqive6xmBVPMTIggpVqBo0SikQlXHKwycnErxmMscEeHWsDAs/aIScj93S9dE62PsHIShwHr/WbF0gNDtjaNwC8qhOV+N
X-MS-Exchange-AntiSpam-MessageData: bxFa+XVvFxlviKgEnfCGfJY+fEAAsKEyCvYibPzJgE2S/n+NP7xJfDs8G6Y7Xe8hLSGTz0mm78fcgk5YEsMbZo+zyfuJwE/EDAiwz/zRNXgzvi7NJdeaA1vzdPTlx/MUgBeKir8HEXVqMJfCAIAKpw==
X-OriginatorOrg: nextfour.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4175fe16-c093-45c7-386e-08d7c411ad4c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2020 10:07:30.2812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 972e95c2-9290-4a02-8705-4014700ea294
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U+Rik+KWVaewhJAPhMvXvi5Q1XvxREE3goyqogHVmbrq8Tn+hWxUz+aTeljqyigPt6RtFPGExFFjNgdHWzsv7HrQviua1mn9fZutWEuZun0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB4205
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------1492D3D5E4B3DFA7B1B682AA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi!

On 4.3.2020 10.51, Xin Long wrote:
> Xiumei found a panic in esp offload:
>
>   BUG: unable to handle kernel NULL pointer dereference at 00000000000000=
20
>   RIP: 0010:esp_output_done+0x101/0x160 [esp4]
>   Call Trace:
>    ? esp_output+0x180/0x180 [esp4]
>    cryptd_aead_crypt+0x4c/0x90
>    cryptd_queue_worker+0x6e/0xa0
>    process_one_work+0x1a7/0x3b0
>    worker_thread+0x30/0x390
>    ? create_worker+0x1a0/0x1a0
>    kthread+0x112/0x130
>    ? kthread_flush_work_fn+0x10/0x10
>    ret_from_fork+0x35/0x40
>
> It was caused by that skb secpath is used in esp_output_done() after it's
> been released elsewhere.
>
> The tx path for esp offload is:
>
>   __dev_queue_xmit()->
>     validate_xmit_skb_list()->
>       validate_xmit_xfrm()->
>         esp_xmit()->
>           esp_output_tail()->
>             aead_request_set_callback(esp_output_done) <--[1]
>             crypto_aead_encrypt()  <--[2]
>
> In [1], .callback is set, and in [2] it will trigger the worker schedule,
> later on a kernel thread will call .callback(esp_output_done), as the cal=
l
> trace shows.
>
> But in validate_xmit_xfrm():
>
>   skb_list_walk_safe(skb, skb2, nskb) {
>     ...
>     err =3D x->type_offload->xmit(x, skb2, esp_features);  [esp_xmit]
>     ...
>   }
>
> When the err is -EINPROGRESS, which means this skb2 will be enqueued and
> later gets encrypted and sent out by .callback later in a kernel thread,
> skb2 should be removed fromt skb chain. Otherwise, it will get processed
> again outside validate_xmit_xfrm(), which could release skb secpath, and
> cause the panic above.
>
> This patch is to remove the skb from the chain when it's enqueued in
> cryptd_wq. While at it, remove the unnecessary 'if (!skb)' check.
>
> Fixes: 3dca3f38cfb8 ("xfrm: Separate ESP handling from segmentation for G=
RO packets.")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/xfrm/xfrm_device.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
> index 3231ec6..e2db468 100644
> --- a/net/xfrm/xfrm_device.c
> +++ b/net/xfrm/xfrm_device.c
> @@ -78,8 +78,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb,=
 netdev_features_t featur
>  	int err;
>  	unsigned long flags;
>  	struct xfrm_state *x;
> -	struct sk_buff *skb2, *nskb;
>  	struct softnet_data *sd;
> +	struct sk_buff *skb2, *nskb, *pskb =3D NULL;
>  	netdev_features_t esp_features =3D features;
>  	struct xfrm_offload *xo =3D xfrm_offload(skb);
>  	struct sec_path *sp;
> @@ -168,14 +168,14 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *=
skb, netdev_features_t featur
>  		} else {
>  			if (skb =3D=3D skb2)
>  				skb =3D nskb;
> -
> -			if (!skb)
> -				return NULL;
> +			else
> +				pskb->next =3D nskb;

pskb can be NULL on the first round?



>  			continue;
>  		}
> =20
>  		skb_push(skb2, skb2->data - skb_mac_header(skb2));
> +		pskb =3D skb2;
>  	}
> =20
>  	return skb;


--------------1492D3D5E4B3DFA7B1B682AA
Content-Type: application/pgp-keys;
 name="pEpkey.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="pEpkey.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
Fq/REmUeraUWcYydE+B+4Xt5yIF/V/Zwm0o=3D
=3DZ2VJ
-----END PGP PUBLIC KEY BLOCK-----

--------------1492D3D5E4B3DFA7B1B682AA--
