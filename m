Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E166DB0A4
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjDGQde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjDGQdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:33:33 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020020.outbound.protection.outlook.com [52.101.61.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F68346B3;
        Fri,  7 Apr 2023 09:33:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKNtV0jn0JoCYkM/NcAbMvBWzxT42/eIFWJ+OZo7vwoovkamt/0IkBzJw4SNJdC0uZ0kxqsO1ylYP5LADvmJL7Z9kv8/PXm1v6D7uSJE1kJ6Eo+qlSz5fPElofN4bOjyifH2XqJAq2Mimiu9PKo03oEchSiDDLIYuckTHMCDP9XxHkMyTdxPxWnEifwSQlw6JOWlen1GYeDfpZc58UDS9I5CF1lT+5q40FMuQo+smoQYpjGJdiHpHn6ieqgFVusr+83MMyczzNG9KsSNPH02WIgIICnxQTwuERPTYdooItd8cD08YUKLmbPUl1H2nPZEJGdT/dzAyKLdfpVe/t16Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OaxRUfVwr0B4GhbaRw2ixKbe8Ce4kFEaMx/imqMjom8=;
 b=NNO0V6fOi7da6T7upSd5Xr8YgnVPL9QBqzfdKX4YMKI3utGdz42hsMacRBslTsISQvArPr/ONUwL0Yz9SbzNVoZIGqFJJaAhNxNBMS6pHaYwaTFVjXbBjJ2ak0s1HDD6AmXQVOtQzYKe2zMPXl1Q5I5r+5n7RavoGPSzUKVAlYWQjkWJcpKqY9ChCVbPopP44VIsajuAxRUsdQu+glxJFFd5S9Kkvn3bOCntQVCXw5v+Q6Wxs+S0RadS1JunKfAF01qKZ8bD5gOTLD4UQMDML+J1q4k6bmn0w2eWiudr1G/znXmVOOaXbYojcRTD6c6ZtVXVgU1KFdv4J1xxlmanYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaxRUfVwr0B4GhbaRw2ixKbe8Ce4kFEaMx/imqMjom8=;
 b=XHIOAAhlkBvTK404uoTm+9laqWTa8h5y23o2WlnI31tO9Gj7PFOZVJiprHJBGPDhJKae65yu+mZ7k+clsxLVI5pdjaOTViyRa+k3y45WmAseKEtcWyTuo/P1FFIfqs9+IFyaEgw0UdqONOEYnW2yvzKjZq8fj4jD10QIfOSpedY=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by BL1PR21MB3138.namprd21.prod.outlook.com (2603:10b6:208:396::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.16; Fri, 7 Apr
 2023 16:33:21 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c%7]) with mapi id 15.20.6298.018; Fri, 7 Apr 2023
 16:33:21 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jake Oshins <jakeo@microsoft.com>,
        "kuba@kernel.org" <kuba@kernel.org>, "kw@linux.com" <kw@linux.com>,
        KY Srinivasan <kys@microsoft.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Long Li <longli@microsoft.com>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>,
        Saurabh Singh Sengar <ssengar@microsoft.com>,
        "helgaas@kernel.org" <helgaas@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 4/6] Revert "PCI: hv: Fix a timing issue which causes
 kdump to fail occasionally"
Thread-Topic: [PATCH v2 4/6] Revert "PCI: hv: Fix a timing issue which causes
 kdump to fail occasionally"
Thread-Index: AQHZZpopUQZ8ge3HAEe7nozotRXSl68gDtTw
Date:   Fri, 7 Apr 2023 16:33:21 +0000
Message-ID: <BYAPR21MB168827C0DBCB46B8159873CDD7969@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20230404020545.32359-1-decui@microsoft.com>
 <20230404020545.32359-5-decui@microsoft.com>
In-Reply-To: <20230404020545.32359-5-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0646763c-c920-4a7d-929b-d542dcfd3725;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-07T16:28:42Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|BL1PR21MB3138:EE_
x-ms-office365-filtering-correlation-id: 8e2888a6-f3b4-40a3-f0f7-08db3785ccf2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KX7KniZCgV+vD49iSTmmlWgJ1dw1jCpj0qQqZsUIxqYv9nHTec63O8WaWbOQQ9jwyLek6VNvvOvE8uKUaOYTjd6QdiNIqpgH1kRVcIXQjFtQwq8nnY+oNKfOrYLK0umSccnl9p5kPTLI9JwgGU2rf6k7fx2S63OTuwhoLg0HAIBStPKtns3RG+FsayQ+yekYIbsJVkOW0ZpvEkZdO8eKNsA8Ke0scIoUoSZE4bpIWUuGkVmTpLOZlhdZUETPBRk5TgTQvktth57Ez6MozcWfs72nP5selSmy4hF9wIunafcIRUGEP4vFyFyMEk4CP+1uwpmamm+k1nF9OctK8lz7mue1WuVimakWm1aEI+OFA+fWdZBzyZD84HTL/iChw3dUJ08GkXfsEmZrME5ATO/KrTOQMS4TcjLWQix6Vl+uWvAaFZmhad6RmjwoWlVjdjBYeaVjwQD5zAIn4renEllLfQXIIdo8S1GMo1pxwcZdmy6ugsOqPJ52gmXK3q2bl18FjSqz+XVd55C+qHuS5z1Nl8ABvruFfcVNmbCav+UDel9BrQjj10XwFpZ0GMskCfRNcjGHhTpbJ1XqLfYIJ7stw7G9LnHuA0J0kCpmlru279MmBCwKtQ/QAaqUoQgz0lmGK6bQ4GBZdB/J8Mre1B+A7KOQ1zXsPTZqaN1D8rXvpGExftw5gMNTHtsMZ3H3ASS0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(39860400002)(376002)(366004)(451199021)(55016003)(122000001)(66446008)(38100700002)(33656002)(38070700005)(2906002)(7416002)(5660300002)(52536014)(786003)(66946007)(8936002)(86362001)(8676002)(66556008)(41300700001)(921005)(82950400001)(64756008)(76116006)(66476007)(82960400001)(4326008)(83380400001)(110136005)(54906003)(26005)(9686003)(8990500004)(6506007)(316002)(71200400001)(10290500003)(7696005)(478600001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9nj8Xji5801wmyc6GnsHHM7/k5tn/Y9PO9VvmMEP/emshvglZLWafuroLoa7?=
 =?us-ascii?Q?/dCAtmEX5fGgLp1ikiHBS9yyQS3h6Kyf9lrGvRw2OIGXFm5FsKkB2ck7g0Fd?=
 =?us-ascii?Q?YpYqymlRvytayx/FuqRmapdkrmHFeChN1jqs4rcs9ZgeduhkRxGyyJKjEKex?=
 =?us-ascii?Q?/2oEoeArLIhMN9EyellpfczYs5kGyhfEOibOgd2R2p8AAyrh6vIjSdoS+e0c?=
 =?us-ascii?Q?7IFt5x6R+bK6In7L+YLJuTJpXS0onOogsoJFjMeCm3oJOhCWh9XCC+KRD42v?=
 =?us-ascii?Q?z6Lp9BsUrQuATMosiuxxXeXCdDbnR33WAcOJoNYCVpMmQNVa2C7cKHGyDgJD?=
 =?us-ascii?Q?HQKlYPbE19jnXczX0qDKWB+NHd+kNc0H1VKPbTQ/VnBntVhcy29JpxdzG92o?=
 =?us-ascii?Q?FTNll+xF9NEQS1J1vkWLP403OAQLEIUemDHyaOxSV9f8jBeZo97hgKbo06b2?=
 =?us-ascii?Q?2UKEoS+7kb4VaCzGJE0EEPeFbVLsRUM7BPNaLPG/L/UyiDXVOf9Gxs0eQRwI?=
 =?us-ascii?Q?qZEkr8LvxaNjuFBSeGbzkZ28yX5HLGb832c7bSvAghoQ7oqywyZlFVVIwClm?=
 =?us-ascii?Q?1OGhlVv9AAcKnkB2rJwtVmoqkVm08/0AG9AA5UrGOZJE37ouuBYFyJWkBy4Z?=
 =?us-ascii?Q?thSGhgbQFbjAjhB0Z6O96Wbwh0ZptSMpTqE+TZsJ82OrGyoxgMUcFVxUea4g?=
 =?us-ascii?Q?YqvfWrIDOtwwn5+Up0YaW4tTvwzerZrn6hPn6rmiLqEZWCynzrwbmLMrOh2u?=
 =?us-ascii?Q?ad5Q2Pm/cKauZRLVngc0oizhdxDtlNYaaQYGhiCaREnJ+NJKcM7LZrf6vGDr?=
 =?us-ascii?Q?iXL9QBaJLR5CPm4FKWeKx6RMUF35h9Nd9Exa4G8pMtHyhRciQg5kriTOcmeL?=
 =?us-ascii?Q?x8FtlSmokSEynCCAnIWxSuzQDFAu8wOmTCjoBi8Pmv+HVgZ7DJUBgjfmcfg2?=
 =?us-ascii?Q?XnDOUzuhesF6l7s6QCtKCYgJZcLUuo/IrPf0DaiqOsGo2Nc3z2a6CwzHlUdS?=
 =?us-ascii?Q?WMMf0RJ40OL205USdDdM1oEllk2FQ1S18BpwtyHYN0ReF0jAyhRcFdJBKf5u?=
 =?us-ascii?Q?N88qAYyuKbOpYmqVTq4FZ6zyg7MmjrWmC6ZfxgCPDw4pmGzXvgXeF+Kh0Q/X?=
 =?us-ascii?Q?+WMqmBQh+VuCpRvnYWt+Uk6zUX+dyH2KM52xjfhyWWo5N8FZDJGVmGTmeogC?=
 =?us-ascii?Q?soYfZ4eeRHMc/TqfKTZsk05aaJf8VJNov695OBnWaDbxChxJ3vLUmjZK9N3R?=
 =?us-ascii?Q?Nn0UAhJkIMunaYeqfy5MEt42TmRStZBvkLBXfaCPeDhj94j3uusqIoKFXqFe?=
 =?us-ascii?Q?/PaTCypX8gfj4FnoXRdhgWgIM0j62WlYIs+M1pmsvTXuBIIEtymyCD/r8lmZ?=
 =?us-ascii?Q?HNlzSmC+u4y3lzaD5Qthyp5HstNNYRM69fgfZtv+4q4C+G+1czJIVDUrf77T?=
 =?us-ascii?Q?XDYFQmGObqaBxAiBIuyLPeHD3PDmFFMFJ6hwvKTKWDrkO6W0MBGUZkrJeUcS?=
 =?us-ascii?Q?UyCMn2ldBxFEc9x5ceTKZ6vrZUBiufATNLnRn1f4dHFpYONfH+rG4XwjCTk/?=
 =?us-ascii?Q?7pHCnBNs2QinM508rHad2qXQIEgBiPu7Tqpl7RoYiUfkur9hKlJUEB404TzY?=
 =?us-ascii?Q?dA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e2888a6-f3b4-40a3-f0f7-08db3785ccf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 16:33:21.1462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cCNJRowe1oPyNpxH0ECvF7YexIf/OgNseZjW7Y6WYw4eNGFwMnU82Ef1lromVJZbnb9ZSkL/VEtqLPP3wDp8QcI3Xwcr5uNudIWQmwE6Fg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR21MB3138
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com> Sent: Monday, April 3, 2023 7:06 PM
>=20
> This reverts commit d6af2ed29c7c1c311b96dac989dcb991e90ee195.
>=20
> The statement "the hv_pci_bus_exit() call releases structures of all its
> child devices" in commit d6af2ed29c7c is not true: in the path
> hv_pci_probe() -> hv_pci_enter_d0() -> hv_pci_bus_exit(hdev, true): the
> parameter "keep_devs" is true, so hv_pci_bus_exit() does *not* release th=
e
> child "struct hv_pci_dev *hpdev" that is created earlier in
> pci_devices_present_work() -> new_pcichild_device().
>=20
> The commit d6af2ed29c7c was originally made in July 2020 for RHEL 7.7,
> where the old version of hv_pci_bus_exit() was used; when the commit was
> rebased and merged into the upstream, people didn't notice that it's
> not really necessary. The commit itself doesn't cause any issue, but it
> makes hv_pci_probe() more complicated. Revert it to facilitate some
> upcoming changes to hv_pci_probe().
>=20
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Acked-by: Wei Hu <weh@microsoft.com>
> Cc: stable@vger.kernel.org
> ---
>=20
> v2:
>   No change to the patch body.
>   Added Wei Hu's Acked-by.
>   Added Cc:stable
>=20
>  drivers/pci/controller/pci-hyperv.c | 71 ++++++++++++++---------------
>  1 file changed, 34 insertions(+), 37 deletions(-)
>=20

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
