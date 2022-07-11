Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D64956D257
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 03:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiGKBIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 21:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiGKBIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 21:08:41 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastus2azon11021024.outbound.protection.outlook.com [52.101.57.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2966465;
        Sun, 10 Jul 2022 18:08:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m5jaVSw9HkRteVq5R6tlnologWPCdEnec0FnpQarKgKi1PfX2XIxGR3/J89ZsmiMtk+rJoUYPPX/aFJFOoP5do/hlg4kTiyw7mu4/5fA+E6ei6J3iFRzJxfmGzMBwBpEGgdoXkLRRTFdjVmSSckAFip/QazV577hwBFD14mZHGXIlf5LmXwbOJg32XHQaRZOaJPyEbgMSuJaeqli5dcPeBeKmNVXHOJCsd+WjXh9w1+STH59wr6eKfiWbF4yOWCUzRFJROXqQeTDwGwBB78n6496IPDIGJT/GN0vQY3PPd2oelb5Pllf2nwxDy6xi7+tUaeqU/7hOK6nFAUcdEBMRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U92vJCOOAXmMrJvka3kmTGwZ+YFzSGYUh5UrcBLm9ug=;
 b=avITHvBpwVmGOSWeQASwFkCloea8JzxWf5/k7JDJ2jyH3lcAQPuDcz/4ShtMC2DvVTE1qwJxAEyOgz8N/Mp2Z2YAE38KgF6JdTnelJcUTw2/3fDYZiNWCKFc130H/7d4qAsLlq0Il0mRWE26c15ocpANMPWRd6ILcPyQiCKsajrnCKQm9Q8FJua7CBeZqjhkCFh1j6TAduXOhWQeDIJrfA0rwhn1bKDTRHLyX1sDGeyikh6iPbrNAE1qp1vJQWfF01vEJEHlF5yRdoNjIst5OY30W+MPEfQN6kFTuVg/CMseN5BozmdiZMd8QwswMvxNOWQ49k/QGuoxQLiQvdpLGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U92vJCOOAXmMrJvka3kmTGwZ+YFzSGYUh5UrcBLm9ug=;
 b=Kc94DTE0cUrXlaDsBLfHuKj/8m7nedkTTCOY/cdna3KovDJYjogdVdwF1StmUVrF/bWjVh5UACzdrmWDL5G/3JAI1MfT2b4TlVKwrCwCFHg8cflqPhq3DIiQM4ZiVRmxpqiE3Ol6rJTNK3EcyrN6erdfixDqMuSQw3ASs9ujKuI=
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 (2603:10b6:805:107::9) by SJ1PR21MB3673.namprd21.prod.outlook.com
 (2603:10b6:a03:453::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.11; Mon, 11 Jul
 2022 01:08:37 +0000
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0]) by SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0%7]) with mapi id 15.20.5458.003; Mon, 11 Jul 2022
 01:08:37 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v4 01/12] net: mana: Add support for auxiliary device
Thread-Topic: [Patch v4 01/12] net: mana: Add support for auxiliary device
Thread-Index: AQHYgSXXLrqLZHcR0EGw/cqXRM9vAa12v3XA
Date:   Mon, 11 Jul 2022 01:08:37 +0000
Message-ID: <SN6PR2101MB1327CE60943946FBF1FB7A3BBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-2-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1655345240-26411-2-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a2c465af-e807-457b-abd9-6fcc1df7f37e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-09T22:11:46Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52f3dff1-9153-4670-0b31-08da62d9e282
x-ms-traffictypediagnostic: SJ1PR21MB3673:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D8ovoh1yBkdQ2+PW9ym11/OPq7ukwgjLc9v1dgXS4t/7KzPaB9K12zDqy9FFFRxTycK6nRuid2dQzhTpskn4+l3L1g2ofWrU70tX6nzbTT7X8SV5TsxiKX2ihkWERJ2/vCUmWBpfHc2Dc9vSchbCLfOAPeUAv9RJKx9pyzKjUWT9Q6iveT1AYfeYVWn5gfQdy4uFvePUViDP5f6pI+xCDJvnRqXaKtENIaLA4hlpWUoWXkpXnOVNwRetJikBmEuFSLJWi8SCfriZmwAH9Uy5dSaSjkccqLb79JBLIJgDdyoL5dZ6Qpzg6N3HA0UvvjUWNocP8Q2/zEBD8mue9hsU9bhylQjUiZQ47ILNgExQEhDGUSOKMv5mnz6F3v1ybREi0Sul2Pn/PbRjlXrO5L+J6yjV6iwiIBbteB0rCggB3Wsu+i0Ajf7j7aeGGlITURhlZ1lhxLx6HfuxAH5K2kL13dP7IWfawmwyveNWYEbaMs4ie0/38NmGxEcv0KtQ9d1oJDLnJY3gQCfGjM2wT+rtgoF7VVcseNzlXe8TT/htQGwm7fbpPaaGKCJqYIlGgT7+RqbPHSGlI1AT2p4vYAP3D9+S9cdqm/r934/RDOl+ywz2iBudIqcF3oi1DWadBFv2djnlpjcKu2sU9jO5AWNQOPhmGCuT8g2SYQM6fbmNwpvbaIY4snNy0XD/69SUfQwMtmviaDZ0aGjrjoZVeiAc1aV05TF6sjaOYXvOwTLusCzQKaNr7mZrK8RcsUOR4gz1LnYgSqgEhrHyDzorHo5oz5xlyBzgb4pi3yP0DIwth1fKak2EqUOBkpt/zsAoVApmASPnDKYHVD9rJSRrW7bMBxAia74dykVLUtLBMLzlXbOcQ116U57jNyMXcthYvutS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1327.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(451199009)(83380400001)(4744005)(5660300002)(66476007)(82960400001)(52536014)(76116006)(110136005)(7416002)(316002)(8676002)(64756008)(4326008)(66556008)(10290500003)(6636002)(38100700002)(71200400001)(8936002)(66946007)(478600001)(66446008)(55016003)(54906003)(186003)(2906002)(86362001)(7696005)(122000001)(33656002)(38070700005)(921005)(26005)(82950400001)(6506007)(41300700001)(8990500004)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Exq4QL2OdrzqVolLRPj6zWQUNiscvI2zLLSoteG3YIBxGgFEWyOe09BAqDZ3?=
 =?us-ascii?Q?Q12qmYS8oxdZiHva5iJwD7PIvXCM4GEslbyrZOm+iwBy9cfzEETzhVowsd25?=
 =?us-ascii?Q?8QqSoUwHj9K2xrkkgFMb7B5rbUVcNqSdk1IFik0uiIyx5OZEiEl0Ku0GXPTw?=
 =?us-ascii?Q?ELaopcIW/6yl6v4EMODH2UdyoXt2dv+3lvPjk65YwfT2FIoQWS7rx1/mqxyS?=
 =?us-ascii?Q?f6/4YyNySE6mZCXFi99zQ/3AO10Cl27byS+fveKEK/STrJi9FXXaeQEB+sMM?=
 =?us-ascii?Q?k5cXYfwqXG5LSxyTZnX7eBL8/HgTHoL2d4Ktp9vmB+OxvNX2MCqFGoVTGj4e?=
 =?us-ascii?Q?n2Wex2Ji9h+NhOcOeKMkHsdWucudj+SCsn3NOUp36PsQ7Bo419kerivG3+os?=
 =?us-ascii?Q?p3IkCu+rH93afz2I80jWc9pZyO0hg/F2o68/02SGqXkPeE76tDt+cnqGlAc6?=
 =?us-ascii?Q?8hc7fmlT6oqS0l5nQcKq+uyrQPtqRaQ/du1AzIVvYBK3W72siWpmjDaMLzD3?=
 =?us-ascii?Q?7h7bMwRFB7HUM0tEkQTsoZ/X6sp9ni4KlJNXuB2LrPvUYntpUmigR3ccMNt1?=
 =?us-ascii?Q?fe34Or8YN35QxEejDWMF7Oi9vFOO+RByh2MY5yjiuV0J3wrffUe5ussbaJ0c?=
 =?us-ascii?Q?2xQZKH6PL7Ub9yuqVaz0WuaRXuJlYK1HaV0QlG0ujqjw6lJoUC71skAs+2ji?=
 =?us-ascii?Q?dVrJ+zZDlofYxddkzxch0RAUMWumm+NY/9H7zAdmN4vEXWdxd4l6Pug/BKNq?=
 =?us-ascii?Q?UJld65P6tz3EOD9wVIGQddvZVkNANelB9x3+xsrydh6wOKZa7uD95+hf7dR6?=
 =?us-ascii?Q?X9jXjpONDezCKggXMBGuBgjeQMZta5fGJdyRV2B8bBG0mVfweW8aha0x5sJN?=
 =?us-ascii?Q?em5b3YRyOKoVFzMwoF/4DA8avEBkFzYdCrw9j8ur5ObiYEbVpJH0ZVp1AD9O?=
 =?us-ascii?Q?NGKE2psFLzPFrchjqcKz0krbFHAoiGnWwlnzh2EgYCpDFVdmBvsAms9EkFwR?=
 =?us-ascii?Q?vLk3Z48yNpHqrXJkshWGfJKGfK0BamQLUHHxW3IHTIY8b8F3GQLGR/wPKYA3?=
 =?us-ascii?Q?HwtXm4DFLT2xWWLGhZQ/da7syx1DVfzmHWkIfQbTb7f4xI9cTGrAvljXzAH6?=
 =?us-ascii?Q?N3fKlcoiqqN8YjaFUFoVb4lfrciSGu/+vWNxUliGFiUaA30PkbJFS3/Gtlfu?=
 =?us-ascii?Q?KBjzzmptQt8F5GDf+KON/fpn+XtDezgwCHUBNk7gzYiZJGl+Jt2ddpUqOp7C?=
 =?us-ascii?Q?WYdJ3VwK0hHt9+x6d8GCrbnG5Uc37qpwCqsTOlY2bpGmrhVyxjs/coRA+23b?=
 =?us-ascii?Q?OBjEmdJpBq6bkI5tu7LHZgGwFpevZUJ7CIk1PKbngKfqYSM3sz5u3ZUEQ98h?=
 =?us-ascii?Q?D+k+kzmxybGceurr22ikSPQMqfNr1w8B6HrsN2RnITNNR0zeaoj+ApzHkY6N?=
 =?us-ascii?Q?VubfJRkW6K7x9cEW90nV9grCrdvZ8W/z3UIDA0lvq5rNfr/KI/cV+ZUDSw7E?=
 =?us-ascii?Q?aYDYvjs+KpqdcXdYSUaBZ37L7ZUzQDvnkullRP8DM68h4NgjrOa06+qnKZXS?=
 =?us-ascii?Q?vDPhoGbKhxvb9NfpJ/bQgCj7NCLwBGK4JK8iPVlW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1327.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52f3dff1-9153-4670-0b31-08da62d9e282
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 01:08:37.3476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GP1BI6+ql363HDULiSOQaF9iVM4gExQKP55CYmEWq8H8YgZeDWwqaOh6Q2NUILKJMPHs+9PDVZu8klu+0Js/3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3673
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Wednesday, June 15, 2022 7:07 PM
...
> +static int add_adev(struct gdma_dev *gd)
> +{
> +	int ret =3D 0;
No need to initialize it to 0.

> +	struct mana_adev *madev;
> +	struct auxiliary_device *adev;

davem would require the reverse xmas tree order :-)

Reviewed-by: Dexuan Cui <decui@microsoft.com>
