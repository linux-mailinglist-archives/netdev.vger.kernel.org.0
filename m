Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D64549E28
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 21:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348769AbiFMTyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 15:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345840AbiFMTy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 15:54:28 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020019.outbound.protection.outlook.com [52.101.61.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A25E9C2C1;
        Mon, 13 Jun 2022 11:25:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LdATb2WCuOUMDvKmGBwYmaCGROEe8g6jc9UaYMJRgIfsm0DAHZKS7+vecUuKZf9UN0EZOisYd1l+cX7ZTdMeIo2Um1NsOv6sr3t9JAbrYy/4LLHAc+toQ+gIFZ6gMgM097R0O1tQEQefFttrItDnDSs77sTFCarfNB29z7Xd5sPDWdYL3GvhHv+pqgW2mRZCbmY8Y6F0XrelurvBHyQyYLkXR9dXMBxshN4cHZ0ajA5jy/dt5sWndE/WF6N5FUIQGjbWJCkkmtFfmPudCP8LVXSClfvBzh2s1LN+9+Yh504pcKGmfx0y6mgxrqk832jD8dRaavJOb22kxhffrscIdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P05H3ZD3fdINjZqM0oLn97KJpARxYUTugfacX4/uEdg=;
 b=L7rmm8ud0kV4PHme/Dzc84lyFQHZR/59zw9KK0SOYtgAmhAcGuEGHeM+NHL2XPkZM9CMhYB7sx6l9fv09BH2a6k07sZdVyrc6YgjimqocUs5VzNSwD8baA2wi1gUlDXPRK4/lF5y1XgYLk8kiHkaeVDBSWESKG6X6n2b6/HR99+iKDkvnoRL4u4EylQSCAO8u7XYHpTkPHbepe7IKLhK2/RZOp54PHOxx9qyU0zRCfsZUdtkLYvmcbK17z0CYWSEldFcFA2OQ8DZCGIcO5lUNp1pR0oFzL4iQoVv0udMzoojNXJbMz7JDjOs7H5pcAeLV/I31kDZ6p/e2eWT6A7piw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P05H3ZD3fdINjZqM0oLn97KJpARxYUTugfacX4/uEdg=;
 b=KkrBEfVvSfTevZv+0E0ipHeGkCX5CY44+WcfvD0rmwqBnkDPuLD05SXty03k+D5gh8Z3edXrPKE/gZkL9Cnr0licU9DuMZxKXbKCgeRwB2J7T2MILPYuLjHoaXr3TQRKdqkIeUUnp11P2vonTjPwzCBljErxyhInteOoKhqEVn4=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by CH2PR21MB1528.namprd21.prod.outlook.com (2603:10b6:610:80::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.6; Mon, 13 Jun
 2022 18:25:44 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::9966:f7f5:fb1d:c737]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::9966:f7f5:fb1d:c737%5]) with mapi id 15.20.5353.005; Mon, 13 Jun 2022
 18:25:44 +0000
From:   Long Li <longli@microsoft.com>
To:     David Miller <davem@davemloft.net>,
        "longli@linuxonhyperv.com" <longli@linuxonhyperv.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v3 03/12] net: mana: Handle vport sharing between devices
Thread-Topic: [Patch v3 03/12] net: mana: Handle vport sharing between devices
Thread-Index: AQHYfqGCuf9deSlWrUuCitsFXyo7F61NKaoAgAB+zCA=
Date:   Mon, 13 Jun 2022 18:25:43 +0000
Message-ID: <PH7PR21MB32638B8B639FC2B9CEC99C05CEAB9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1655068494-16440-1-git-send-email-longli@linuxonhyperv.com>
        <1655068494-16440-4-git-send-email-longli@linuxonhyperv.com>
 <20220613.115058.818063822562949798.davem@davemloft.net>
In-Reply-To: <20220613.115058.818063822562949798.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f94dd87e-10dc-49e3-a4cf-fef9d7ad4fb1;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-06-13T18:24:47Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2366e2a-213d-4600-efe4-08da4d6a20e3
x-ms-traffictypediagnostic: CH2PR21MB1528:EE_
x-microsoft-antispam-prvs: <CH2PR21MB15282A353FBD6BBAA89B8C26CEAB9@CH2PR21MB1528.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dAwJdvk+fuK8VQcxj2PAfNnrYMbWGJlRBB8BIG7DI4qlB7Zqu5wLGN+by/dZH1VkXkQnPI3M839vCCxDnQRilPVjLIr/alMcdtnKTsG/f/hwqIOh9yIG9vOe4NnejIw2KLbj4HLw3y96E5/uVViOlQQvqfiytxXZhwbCFsapGLakc+MkzIdH+dVgQqBpMYGrp7OOkGVXtrGqK6ZjmJMokowBHWa8rXrlO9T/M6yAH+bMoqadgeK+mnMlVNoeQhSyN1LOWVP6Vm1cGeaBfUg9M+YSFED+51TW55s4Kaw+tKzJrClFfH2nORp3c2ZfK0CVJKXi4hEWRA7zG53davSCA2ZlwOWitnmSmV6VmWbupLIELjjI+7YjjN02Qvg7Kv8rmjmM6eZgLVvkvW105RWE8XX/tPH5rON7ZxSqIn86rrWd0gQulNad538gZtIIQG7lk+/l4kghRa2m3ckaLd1A1BXnmO3alC1VO+ISKiDGJFKeD+7v/CNL8bNptmlg2VsZRNIQGERjMyM7ahCifeMp5lEl+2kbcGsQzD1gjtVGYZR37eN712PLzHLi0rZ7IJtx6MO2yu/GRXnPWYYRM69rm4hbKQW07pfMUay2O7AmzCPIN30gXOl4dHqhiqhMm6RSuiMxKCVvRCzHqqp5jdMedudSORZ9CqUuRrdShRqG9sSsq1asbRHo5nsukodVkzIT/I5bo/o0UuPnBDPq0/wgkshrbk7SiVeNiUTmVwEsVArCDMD8oKgU66Z6Vk0r6eFK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(451199009)(66446008)(64756008)(8676002)(4326008)(33656002)(55016003)(316002)(8936002)(8990500004)(38070700005)(7416002)(52536014)(4744005)(2906002)(86362001)(66476007)(71200400001)(508600001)(10290500003)(5660300002)(9686003)(76116006)(26005)(38100700002)(82950400001)(82960400001)(186003)(6506007)(7696005)(122000001)(66946007)(66556008)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hQ7FEwcfPv/wKleUSEUNZWB5rNwU08RiuikN1SPyxZSdAnOAhODLJkwadFYr?=
 =?us-ascii?Q?sQkNesK2SyK+AO9Q+em/MHTPLpwxtOSVcfyyJwzdXkTIKliufbsvoEpuBQ/d?=
 =?us-ascii?Q?/FHIagYw8rs5KRH+8MhHrAPlfXpffjcM9HeqElBKblWo8+wKuXRB7gfhA4P7?=
 =?us-ascii?Q?J3Mw1yHp1yiNnpdQMNzLjtjAeqAE8lMflL3hsoCD4Q5awY3uEmFF8x/E+Q4s?=
 =?us-ascii?Q?RJ0XDMSOtjoXby0ILzaCQ5PSXe698jjyEKAwqbbhD0V95cjzaaHsWu2kvLff?=
 =?us-ascii?Q?qqZMR5P2QfTdjnAxS2NlCFinfEhhRrDe9DtWrpLhKBPr365E3UzOYADv7FyI?=
 =?us-ascii?Q?NqlK8sXqYMVy20t5HtRCGIukqut5l4WmrNUzqbPzw7kC8iHrQZC98Wj+fI1P?=
 =?us-ascii?Q?nVYumhT03UGcACRGNlJ2GLw2cJmilxLCjRxEFNJJZKR9IdSoHLbh1S9fdY0s?=
 =?us-ascii?Q?8i72PDVUrSR6NDoAO0P/dMs9EDv6K2rRPtRdXj7hXz08PX2EfwLvATlBhdlF?=
 =?us-ascii?Q?UFxZ6H+qajaisTNyMvt0bzAEjhzUU6dSZ17swSaEMbAyqHKDWnCz9/gd/vXk?=
 =?us-ascii?Q?4nIJT2keyyZeSqd2rLIw8zh1q4+Qg8PgzHqO5yBzG0SL5ZHnSBqYio9WqfSj?=
 =?us-ascii?Q?JoXmcKTdoKWbU2oyLVTRlzVBF7rUehw+KPDTTqZv4+BRVa/8pp5uW2TF+/1C?=
 =?us-ascii?Q?RJ6KnQksXeLkY5kclel9kwf77dZjIC2yoUyhWKYiXBQ6nH71wd9TrPepBbgw?=
 =?us-ascii?Q?cIi7F0YZuDEh+aGyaRFgyEg/Gp3gjzMaVidx/qIuR9F8X0lvKi2l0RmZEErY?=
 =?us-ascii?Q?DVsK2Gm5a73mdBS90M6i/UX19znOQSIbnpnjtfTbTDyH+3mMBoaIZowCasTa?=
 =?us-ascii?Q?oSIoyAgL1QThncigP7nVPgNDnmY/lirWRmV4KGGtsIJSwfqZJwflvIRzlxjU?=
 =?us-ascii?Q?08QPe5Bz4Ih5Yosu2rCN2viDkVOiknTEKXioewSWfiOy7+bddLFW+offLAjX?=
 =?us-ascii?Q?9Mh2vAEFDolw0XbmeMymV3t7paMPWxJMYl/hTJGh+nKb1PIm8pMhpFFpFJb6?=
 =?us-ascii?Q?NdsHPunGj4kYGEuTh3iLMUmu2gDuoeQaZyY3iC2cdUjfO+WWNnuS6VaECgiQ?=
 =?us-ascii?Q?iZQmeWJQ9NNvCz7MTpg0USMgBU9Sy49d31Stim8Oy9wivPmCqI9vaot7Y/DY?=
 =?us-ascii?Q?fQQ6xCg53Ytsk69aUFZzzGFeJLEUrbwXVf8Fn7JbEw41Xujq6/nAuqlVAaBB?=
 =?us-ascii?Q?+kmQQONjBdD/ou1G5GwttkNJg/BTleAX9g/am9+CQOxkpoWnzVAYkpVX23TU?=
 =?us-ascii?Q?WYJfmk288fQpdqSwvALs4JmPmcQ+Wn6+JmZyUZnwUJ7Xgjr2+G8sMU0elZ4w?=
 =?us-ascii?Q?f2gvdX0wqNMYTSN4uqJRpWKpjYPZ52yqF/4eswRvkkJvDhz5KoYgrDRVEbBa?=
 =?us-ascii?Q?ZzicQITktr7Z5bAISHKNWCLXIKhBvAdR3RrclHJpJlYT9QQxL8kJ9e7V7pJ1?=
 =?us-ascii?Q?WkiH6sO1580PNZY303M/lDoipBK2F1BHAwEasxfWSroNfkOLW2Tp2YJQL5T4?=
 =?us-ascii?Q?rFiHsI5EzTYLLZlzWojFksQuu6hga+Rh53aiV3C85GxzPFVr3p28mFG+2uZy?=
 =?us-ascii?Q?y34RoqSrpYPn71iHYxG5/eQHm18GEYsslnmJFIrpe2U2VoBT3q6OBneP1QX+?=
 =?us-ascii?Q?jswaFG9gWVHadBVZz1l5vSwk4EwvwiIC1Dd5D6wRgbJYLqK6G1Jl+T6eZMTG?=
 =?us-ascii?Q?ecmqPzfcXg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2366e2a-213d-4600-efe4-08da4d6a20e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2022 18:25:43.9871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kbDQfgJZO3QsRsqaIWtenxec30N1ch9EkbGn48zB88rIg3+hG1fRlWOh4z0rUCVAHzOTX6WKP7mzhH2Xj4pHmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1528
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [Patch v3 03/12] net: mana: Handle vport sharing between
> devices
>=20
> From: longli@linuxonhyperv.com
> Date: Sun, 12 Jun 2022 14:14:45 -0700
>=20
> > +int mana_cfg_vport(struct mana_port_context *apc, u32
> protection_dom_id,
> > +		   u32 doorbell_pg_id)
> >  {
> > +	/* Ethernet driver and IB driver can't take the port at the same time
> */
> > +	refcount_inc(&apc->port_use_count);
> > +	if (refcount_read(&apc->port_use_count) > 2) {
>=20
> This is a racy test, the count could change after the test against '2'.  =
It would
> be nice if there was a primitive to do the increment and test atomically,=
 but I
> fail to see one that matches this scenerio currently.
>=20
> Thank you.

I'm changing it to mutex.

Thank you,

Long
