Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B49463432
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241558AbhK3M3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:29:42 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39180 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241551AbhK3M3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:29:40 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AUAjHD2004969;
        Tue, 30 Nov 2021 04:26:11 -0800
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cnf5x15sd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 04:26:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPAbztH3/PI7aDne8rbp1doFJ6m8qhQXxuWbHlVsH5mtqP0EwjPnZHC9bZ3IpeW9kkOY6wkMrAzc2xh0WOnX9TtykoN37/i2v+s0KPn6p5eq3ufEu6+PoRGZ4QvBuEf93LSlGbk0piuOJLdx/Pc2daZZPjyxpDWaI27fhfx2kOPv1W077f8fgBgyn7WN0FFZbfvLL6rl8sNuoa9TVX4cgKF3N0RLk4oeFZaiRAnAxVh9BqGtlL0AFh/BB2buSpwpYY0l9q6hPGuseKGobNIQIPDKToJREulmu+1GzwLaT89VLo83ltFJG0Q8QymqbHswrGhaE0J3heStYRpPruEErw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jRkS/Wdv0s62wX8rTplTKsZ/J+F55kWMaHVsda+tirU=;
 b=BW5IUn10vJDMN1rc+TsaWfsXnZhOr8KyRv3nfGjwrSKLiE2GQ9/i2ZRTqJ2f9/+1UUjpDSw6RR7ECZ/hcb0ccFx6hPJybpZhJwiuPfSeIAuD1SUkuwx/1kB0HwjP64vzYrq/HDKXh2swXTWuurGqz1Q8UP03+giKGM5eUiNGZ1ECfKfaBwzCVvt8t2QimceK1BEYNcYUHIkcReMvbVZx9LF9DKsragbu8/xoQOKxSYcePwU8CLzwu6cKnZpk8uEcYT8xjcFZsBY1WHbxXN6FFBJfDFVXceLfW7fc06pEsWnT0dfJ7mbRYzGnE40eFB5ptIaWOSzPUK7/e5aoJAypAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRkS/Wdv0s62wX8rTplTKsZ/J+F55kWMaHVsda+tirU=;
 b=Q9qc5lIlvR7eHrs1eFeHKcPc+MkCAO7dSu8jKivE1DjwptWbYbw0lgQxvOlWZTKEY/lzZFObF7J/Gn2Otm87qpi/r8gEJisiY/CyHWWerjr65CEC41z1fe5loT1uCop/34qUiKwnq6WdgA3WBaXmkl3walGsnc4W5K5Coa20W7M=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by BY5PR18MB3331.namprd18.prod.outlook.com (2603:10b6:a03:195::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Tue, 30 Nov
 2021 12:26:08 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::f5d7:4f64:40f1:2c31]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::f5d7:4f64:40f1:2c31%6]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 12:26:08 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: Re: [PATCH net-next 1/3] net: prestera: acl: migrate to new vTCAM api
Thread-Topic: [PATCH net-next 1/3] net: prestera: acl: migrate to new vTCAM
 api
Thread-Index: AQHX5eVzz11GMIPyqUGhFs9DcIi0FQ==
Date:   Tue, 30 Nov 2021 12:26:07 +0000
Message-ID: <SJ0PR18MB4009C9E969043566ECEEFBA8B2679@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <1637686684-2492-1-git-send-email-volodymyr.mytnyk@plvision.eu>
        <1637686684-2492-2-git-send-email-volodymyr.mytnyk@plvision.eu>
 <20211124191502.5b497e84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124191502.5b497e84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: c861dc43-6a55-6f5d-4c95-09a27d31b2f1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81b45475-19ab-4dce-9d7f-08d9b3fc960d
x-ms-traffictypediagnostic: BY5PR18MB3331:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <BY5PR18MB3331FB9A07FF21E8BF8E0624B2679@BY5PR18MB3331.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j5pX5F3pq52t5hDK81C8486t5B4t23+xMEBESkUmLh2sbHDGOnKwngQmClgS/KSQaUWTXCbU6+6xbIDouuW86S1CMgEQsupObtiu78WhMOP8zRXs28vinaxt0wyt0cU98HEIfzFZnxY7w2ouqK9pInX7o6P3hHIwqImbUXP1tj9efH1ifFN3EwUUn6We2ZI+S8bjPqmB2ji255AoHyFmk385z/t/BCVjwMr4QkHepqHilETOicIVd49JuS+c/K0BZ8NfnvTZAWclKg/uniwBRZxynk8e2Paqyl9oAJhTrpuU+L1o2z5jMrrrusK+7fH5B9LbFV8+GslUnR3C2YseX1Yuj3y5WasK1KOymcWyLuNUvFjIh+wUg66shdjxN9HOknCGuM+zI1UVmCHIPzCvUqmtPbYSUFM+uIX8WG9lOZeYKwMWtcdBYDYgrxC2s8we2jEz2MiXfZV3NMHEmd/rBHH0lGp8LFVycWRnebXyWm5cCvCTVDbGNRoIKVJzZoR4CO8gTFq8fwuNcmT0pdFrYmacLOUxRti1HrtUeD44dDHTveChVE7z+aEBdBY9tqqUZJ+OHIO50y1EhE9FSzHdeiX3onQpQ37xLv3KKtA1vpuwpVoiAqMXqDKNUQ60p6Fu256uj+iTxobDTwLpZ74gp8fsOurDrZ1RtQL3Dsb6Yq3icIrcDwpGoH+mgDKXzhojaHLFqtP075Xn180KaOBwfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(52536014)(122000001)(38100700002)(316002)(54906003)(7696005)(26005)(186003)(33656002)(2906002)(6506007)(55016003)(38070700005)(508600001)(86362001)(9686003)(8936002)(66946007)(76116006)(66476007)(8676002)(66556008)(66446008)(64756008)(4326008)(71200400001)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?1jkNf6SK3TjodtWWVJJqCiC05iSKk3n0Q59aKjbAmvCbhDtPcDwK6SkwkW?=
 =?iso-8859-1?Q?cQDj3gA46HJVjjL+n53h0qWnb551QgdP32FPix/vzLJL+a+UGwd4VFJ1di?=
 =?iso-8859-1?Q?nWpQudtxNfWql4IqJLiqgRMGYQq+fGlDuGTie90Ur+D+z7xqCUqOPfvAW0?=
 =?iso-8859-1?Q?BZmm99mrjHu0wprlvCQGl5qAktAmgTHxNOb+3b///GPXBEpvvf1K/CEU1H?=
 =?iso-8859-1?Q?HrkzpO3HF0VMddrdalaTuvLg0K02zwBR/mLAHWO4Z2St1+rzi6I5eNlzG5?=
 =?iso-8859-1?Q?Crd+KVihSnnmwoadwX5R18swbK9FOyOLz9bX0ON3KlNCaxit9VYaAFhU4v?=
 =?iso-8859-1?Q?Cu86CFGN9X6II4HphPBl8WbEBttjXCIX6SJqvTPqOX7DJlSpzIpf9cJgXS?=
 =?iso-8859-1?Q?qCHLvw9T1+mJx1C2jZn1Gpp96uQM1a+UjczaS7fP0yPHOh+OV+0DF1wogX?=
 =?iso-8859-1?Q?W/nZ6z/ZtId8rlZvEV+fV9HVKRmFmu/9lj7WFtGtZ2DbsFcmi+jpE4cBtv?=
 =?iso-8859-1?Q?YLoZJOhuCIat3kA32AFBuo7ve/OiYia0NeAJ+ntN3LBcH88uoLZXiNVOr5?=
 =?iso-8859-1?Q?JiNiw0Xlc+M4Hd6zyXKPkig4+79CWy0+JYQh0RzBj1AjdR4av4TMpxaxEs?=
 =?iso-8859-1?Q?Sj4/PV7RLtFk4fZprKgr2SsPKyUsdVgvmp3/xpMmk9f6OPYhTlQI2OF9Zg?=
 =?iso-8859-1?Q?3AlPV1WfTgcWiw61WEHMRRunOeyid5ZVLOD0Fmza/aURo2Ni+JhXWCi4G8?=
 =?iso-8859-1?Q?l4kLWfDSDbaOfSEa3TBFl3r587+UiIKZCB6F+cajUQF9nu3mQsajdGitL2?=
 =?iso-8859-1?Q?/f6xYNr2w0WSiYEYqAm0CWERZd+bXdx+vbHIwir0pohoyOX3Htv2nbhkn5?=
 =?iso-8859-1?Q?huGg43m0qqGhwUWbV0eeMRKhwPxY00IaF6Xal6yTdh98yU4fw9HxxzmchI?=
 =?iso-8859-1?Q?L9GuNKan3y8em6wzEL4+rhq07Vlni/5UnX2DR0UzlPcN9rWMxOuf+XKIMu?=
 =?iso-8859-1?Q?NtBA/H5GDevoAcDbV3mgbKiBoktnstv6lCgPW9lbey1VbOzRHe1ZVM4GTC?=
 =?iso-8859-1?Q?JmkfIvYMO3kaF22OF9Qjp03E9z3Q6tFrR8A0z15BX6P5J43gqZxuLlp0RY?=
 =?iso-8859-1?Q?ql6OE5W2tJ4hJBE7ZHEO3ek9KfHLhH5QvDh+YEI5sa/4qB0VovPOCDnojK?=
 =?iso-8859-1?Q?FXagjl9ye34rTFV99zET85LA+KG+3z9x99BTP5/eUKa0CxhiTvvLkcbKof?=
 =?iso-8859-1?Q?JS/rKz4XItr3y9o4Et77BWbhdX7DWfM51sZ3GMfwlqOqwmABh3Uy4dnu4s?=
 =?iso-8859-1?Q?wS8bp8CIhiM3TfwIxlgULYS+7i5dsyeQyD9coCug5bbp1Sm5oE13/drgTG?=
 =?iso-8859-1?Q?pQPMYJk7wU9XvhOAK6P77avPOtPzkOcrXCr6Ugb7fS/LE2TByjf3qJqkI0?=
 =?iso-8859-1?Q?1RGey3UImTH8kqHg1e+CiLl5gp200Bqj0zk0gU5n3i5JrXwzVneFZJsHXR?=
 =?iso-8859-1?Q?TVZb3/S+PEJ13ccmWhv7G2zdPqy3AAU+byrGrM0udpn0s2HMTOrLD1kCbM?=
 =?iso-8859-1?Q?PDi+jP2iVovZP2Vbt4wqhMqR9BSHmVtVq/+5ad7gQxjy+LWTMT1iJL1yuw?=
 =?iso-8859-1?Q?Edn7bBxrV512yr4tYdDdrY3Su1oi5+EejKQFXDOhMKRK2Yq9GuDasaDQ?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b45475-19ab-4dce-9d7f-08d9b3fc960d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2021 12:26:07.7154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EU+Dd1tYOsH1dKIkSdSDmlDzi/Y0Z29xKEaXgmajohXMqGCx380CD3248DcxLmSZRdf3Q9UXot29JapIx5N9Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3331
X-Proofpoint-GUID: f7CJ5UQCU3pUfST0s8tXMVI_GZyAC14H
X-Proofpoint-ORIG-GUID: f7CJ5UQCU3pUfST0s8tXMVI_GZyAC14H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_07,2021-11-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,=0A=
=0A=
	Thanks for reviewing the changes.=0A=
=0A=
> On Tue, 23 Nov 2021 18:58:00 +0200 Volodymyr Mytnyk wrote:=0A=
> > From: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> > =0A=
> > - Add new vTCAM HW API to configure HW ACLs.=0A=
> > - Migrate acl to use new vTCAM HW API.=0A=
> > - No counter support in this patch-set.=0A=
> > =0A=
> > Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>=0A=
> > Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>=0A=
> > Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> =0A=
> >  struct prestera_acl_ruleset {=0A=
> > +     struct rhash_head ht_node; /* Member of acl HT */=0A=
> > +     struct prestera_acl_ruleset_ht_key ht_key;=0A=
> >        struct rhashtable rule_ht;=0A=
> > -     struct prestera_switch *sw;=0A=
> > -     u16 id;=0A=
> > +     struct prestera_acl *acl;=0A=
> > +     unsigned long rule_count;=0A=
> > +     refcount_t refcount;=0A=
> > +     void *keymask;=0A=
> > +     bool offload;=0A=
> > +     u32 vtcam_id;=0A=
> > +     u16 pcl_id;=0A=
> =0A=
> put the pcl_id earlier for better packing?=0A=
=0A=
Fixed in v2, checked in all places, uploaded the changes today.=0A=
=0A=
> =0A=
> >  };=0A=
> =0A=
> > +struct prestera_acl_vtcam {=0A=
> > +     struct list_head list;=0A=
> > +     __be32 keymask[__PRESTERA_ACL_RULE_MATCH_TYPE_MAX];=0A=
> > +     bool is_keymask_set;=0A=
> > +     refcount_t refcount;=0A=
> > +     u8 lookup;=0A=
> =0A=
> same here, 1B types together=0A=
=0A=
Fixed=0A=
=0A=
> =0A=
> >        u32 id;=0A=
> >  };=0A=
> =0A=
> > +int prestera_acl_ruleset_keymask_set(struct prestera_acl_ruleset *rule=
set,=0A=
> > +                                  void *keymask)=0A=
> >  {=0A=
> > -     prestera_hw_acl_ruleset_del(ruleset->sw, ruleset->id);=0A=
> > -     rhashtable_destroy(&ruleset->rule_ht);=0A=
> > -     kfree(ruleset);=0A=
> > +     void *__keymask;=0A=
> > +=0A=
> > +     if (!keymask || !ruleset)=0A=
> =0A=
> Can this legitimately happen? No defensive programming, please.=0A=
=0A=
This function is unused here, so just removed from this patch.=0A=
=0A=
> =0A=
> > +             return -EINVAL;=0A=
> > +=0A=
> > +     __keymask =3D kmalloc(ACL_KEYMASK_SIZE, GFP_KERNEL);=0A=
> > +     if (!__keymask)=0A=
> > +             return -ENOMEM;=0A=
> > +=0A=
> > +     memcpy(__keymask, keymask, ACL_KEYMASK_SIZE);=0A=
> =0A=
> kmemdup()=0A=
> =0A=
> > +     ruleset->keymask =3D __keymask;=0A=
> > +=0A=
> > +     return 0;=0A=
> >  }=0A=
=0A=
Regards,=0A=
	Volodymyr=
