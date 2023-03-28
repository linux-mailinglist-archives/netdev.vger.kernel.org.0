Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FED6CC86F
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 18:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbjC1QtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 12:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbjC1QtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 12:49:01 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021021.outbound.protection.outlook.com [52.101.62.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A01FF3C;
        Tue, 28 Mar 2023 09:48:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RT/mPcwl7v+XyN3SXQ1muTJL4F+1fiPmWJVI3he/JYQqjkYln3Oyxfjy2RRYmrBkXgeyIAp/Htf5ChUgkYJ8LYGFsYhNV6GdWQoWlMHv8jcCaSFzb9KXEz4az5HeP6eLB20zla/RQqHs5I/1dvbo2w+uijzRWJKugodeP/xa4BG2mNam/plsqqec791/mbe5BK/+3FaFeH+ZtAbLvazyrunKTqV9FdGWzjbXJ/Dl567v2L0XD88j/G9ywdw9FRuCK3GtMOV4UhRuMBikco/OXa/nMOgjrijdpDiy17aS08TmfkZP9Tze7GLX6qR/Px5woAFNAj3yZgKdxCGDDEgvwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dPCSrMUeiJfnc9TzOQKTPsNxQtOScmzWkIb9NBeFiOs=;
 b=AiYezj9sQFJY3hW3fj8NtZ6nU5S5cV/gKyBI0jkRILcx9S6gV9H2Asj6UIgSrG++Yj8qMmRRUOUMlnVbwXXRJWY6JAEvSG8+IVwiC2w9lZdjWhBtxvRu8qb7YoYtbwSVpn9pe81L1cUseZxXolTB5Qgl50nzxcOLlTMMFx+82zUcJGM3+0pNZq7U2jigWQ9QO9DoE7OC+o93C0QU9c36cIRqF0tsdZ8BbJ2QSfUeXK4wRiWs9DOmz47Sbanh78uf8USbr0asMLDU7Tl0Mzrwe/8j/h/wx2NvRvoeG0Tj5tK4mI45pjNANHT0ih0ePIECP8F/YVq9WSAQ2K1S4C4JLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPCSrMUeiJfnc9TzOQKTPsNxQtOScmzWkIb9NBeFiOs=;
 b=SRUWzO65VnWu5E9fNOSurxYWVx2xss665VwIGvj7NfO+mkatZUHAYhH7BshNJxShDCOcK61txIeud5IKjZYMC7353BzOPnqbJ3tG+eUWfD6TP+kfAijmcAuT3ueFNTjnx4fdOHacE76jeq5+40kHyFiwn5+T8qmz6KlDgZAh7VU=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by DS7PR21MB3693.namprd21.prod.outlook.com (2603:10b6:8:91::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.6; Tue, 28 Mar
 2023 16:48:44 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::7635:2228:e2e9:f034]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::7635:2228:e2e9:f034%7]) with mapi id 15.20.6277.006; Tue, 28 Mar 2023
 16:48:44 +0000
From:   Long Li <longli@microsoft.com>
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
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/6] PCI: hv: fix a race condition bug in
 hv_pci_query_relations()
Thread-Topic: [PATCH 1/6] PCI: hv: fix a race condition bug in
 hv_pci_query_relations()
Thread-Index: AQHZYTEw5EIgYDC+IUOtVNpvTo0Kxa8QZ0BA
Date:   Tue, 28 Mar 2023 16:48:44 +0000
Message-ID: <PH7PR21MB32632E889A7F589C32FE51EDCE889@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <20230328045122.25850-1-decui@microsoft.com>
 <20230328045122.25850-2-decui@microsoft.com>
In-Reply-To: <20230328045122.25850-2-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=90dfa640-62da-43df-b474-aa70d6393cab;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-28T16:46:18Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|DS7PR21MB3693:EE_
x-ms-office365-filtering-correlation-id: ef1c81fc-f958-48fd-5de5-08db2fac4b55
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UnuOaTaxuyT5G/nZrcbcxGJXAPt5R6v/1/tWuqaRFwr3cRULtQF37kxIsqQXQrmawaxWHOH4aI3nru68JfHtO9VYse6IbhzigV2LLQervdFUll8XzA/qbWFY+hTlEG5K6umsFKLPH8UjMP8WYqYeamIYLHZvHxsWehE6TcmTg6+vd0TPN/pQopk4L/GAXdOkMmEcVUJp5sYyrdmxr4Ss9Iu1N84TDUspTXBmpxlpUqsLtvf9p3QFwNMtFB2FNXQBZZrHfFeML2FJcf1N8XZj8/0dg+FZ79bB521g4FB/o7mmN2JUOXIw9zZIYxKavKRPCbX2iyAnqpBqGd2kBrhrR14urrZ9yNoFCysqLUC1iPWce2Q34kopN6eDL7RzHWSzS5WTJFye2nGOWXKsqaYx4ATVqjXS2oBkMDuzGFuvSUc1/21dGStsD4YuXIIaN36ySiUeDrbUmsNzFdUPEH9CCBYrho3G1GESsYjet5HnhTmhGpz++WLCAmzxwiRS8icVENQ8yujncc0zqUKRQXhlS+bCGn8TxjYyWkQr6yTrlPr6/yF+9zBifizvKiPl5uENM1excr76CszAOu/ZboyB4pO8sSNxs3H/ABK2iZEcnfyzcnHQT404+8td8rmB/xzjTjRgdrDyH21Sj+0v2yvEu5aw76OPNamsLyKjHSr4jlPvulsekhV3IKlnxdI32Kqr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199021)(2906002)(38100700002)(4326008)(41300700001)(8936002)(122000001)(5660300002)(7416002)(921005)(52536014)(86362001)(55016003)(33656002)(8990500004)(38070700005)(82960400001)(316002)(10290500003)(54906003)(110136005)(7696005)(82950400001)(71200400001)(26005)(478600001)(6506007)(66946007)(9686003)(83380400001)(66446008)(64756008)(66556008)(66476007)(8676002)(76116006)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?svtFTJTOsEBaQNSkhGK6T7dh9V+oJitDPjXcNDDGMag43cwgD6WdmgxobKu1?=
 =?us-ascii?Q?UbnQRZ6ZVaUPST1m7M83054WTT8JTHDgKYpxSE6mp+5chB/FW2ZKFIzEz6DH?=
 =?us-ascii?Q?uKPmQQTgzaR+3IoKs99Y43O2C+ixiPzKzJ5YSjnmNgI7WV/0ovAMXBkouqOk?=
 =?us-ascii?Q?lhVlMpvrbcLBpVkLeD//df7eFUe5DDDUbJYvXyXvWOSIsAUr+fGO/1kV1USr?=
 =?us-ascii?Q?5sd7HD7pmeSIXxKGKce/+I3D2hSuM4o451p/ySIKZRsOb3Kmwvv0wAJBWBzz?=
 =?us-ascii?Q?ZwKptEYrj+DLrMmHS+K4mKkcsCEM16xE7RNDGSV1sdzfJZ0YJFbNRnxSJ98V?=
 =?us-ascii?Q?NHEX9geGm1Il00+9YakX932RC0HNkLISKodkBMGPfnsBTU3sysubNGPBIQ1K?=
 =?us-ascii?Q?WeUwy4Uf026wfD7CNU4VBnFz8b997gKmdnpTbu0xpX0kUtixfspjTmLGeRA4?=
 =?us-ascii?Q?PkOQcfF0Yr76maTumy7+X7qwopvT3X9R07bkG2euCOoad+1LCakUcOx+UcvQ?=
 =?us-ascii?Q?VM2dJD5eUf5zzi2RBv9oNhjw43AY2UxUGjLQl56IdU97MdAhWBOQw1c3vO7C?=
 =?us-ascii?Q?nJpvT3VX4zXZUOwy8r56ZUnB29Wq1UIvMg++uI3DON7Zk7PZRcB6kryhuVn8?=
 =?us-ascii?Q?RuYv4A4GJscADdqPVkHx7Um7Y2n0etQ7N/yNmbVTj5luOYHDeXTX6YOm6xM4?=
 =?us-ascii?Q?YaxOTnjv7AipfLM41YUfKo1OniEqo2ZGjoLolo4TppcwUmaIgTUmWRNLtWIa?=
 =?us-ascii?Q?WkYSza0GlIP0uNPhedGHMTCctOmcazPsZRlrI6cALeXDnGv3wVkjEwv4Qs6f?=
 =?us-ascii?Q?yfCrCb4HjVQgbMk/S9u+xKx/A7vagWjEqgt8xzJhR/O86435xtG5M5ynLCwJ?=
 =?us-ascii?Q?zScwFKrumT30WmfhdtaYkUt2p6Uj6zziv7bR9O+szlCWokied/wglJhfV7xx?=
 =?us-ascii?Q?9zdseWTIfoLftAjv4Myeg+GldWgphVOTNkmxR8PCE8rqKmyzW+vCFueToe1S?=
 =?us-ascii?Q?Nw4pYq++N4GjxqCeFTdw7MismL+afn/c481VEFyxZIvJX7w3mtrX0x8JKvpo?=
 =?us-ascii?Q?GCWdNxVUh0I9oqV0dffg4mF+u0WwiHcj22cCjYizPBcbm5u44+QqUMZPw/Oi?=
 =?us-ascii?Q?3unDYCMe2x7h+KuG9XfeThj4a06rmrF4A0zQ7xbfEzQSS+fdnWnyqXb8fTUj?=
 =?us-ascii?Q?P60sGhznBpMAXVHUWaHkXf6Vw+ZE/yBckVfNmVzNV3VrOZb+pHT5ko0M2rUD?=
 =?us-ascii?Q?QwazgPrbaPZSQ8TFrdwN100t0OoAYsvxrAv/GL8WzG6wPtAX8v1CgGpY9L8J?=
 =?us-ascii?Q?u0YB846hKZHA7z32PiEYSfzYNYdFv5MjmsCDVYygBi5xQ0+TY38PcXQDIbTH?=
 =?us-ascii?Q?Z6+rhL2cX2jBRYQjcMxe9iuyxv/twBzJFeqBltwSS/3rj2yAuc6QWkLll/HC?=
 =?us-ascii?Q?S3UUObnUkkI9noqLLI8KW7h1bmMqPmqpn3WnRIiEyRUdEDBqQYloB2C1m0v6?=
 =?us-ascii?Q?hxQMnWwxoYJ6dg4ZdRE5VyR7bxNxdUfT9EgXSNjMxLN6pwqo1yBhd1D/xCkI?=
 =?us-ascii?Q?UWxkYsrMvohdwGtfMkE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef1c81fc-f958-48fd-5de5-08db2fac4b55
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 16:48:44.7385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fDYFKwvFeewcuidzFdYP1T4JTiIhlP/GshxArSOQOTccKNk+jSZlLFZ19Ij01dqExSex0CjmLMjhoYb/Y6hdMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3693
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=20
> diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller=
/pci-
> hyperv.c
> index f33370b75628..b82c7cde19e6 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -3308,6 +3308,19 @@ static int hv_pci_query_relations(struct hv_device
> *hdev)
>  	if (!ret)
>  		ret =3D wait_for_response(hdev, &comp);
>=20
> +	/*
> +	 * In the case of fast device addition/removal, it's possible that
> +	 * vmbus_sendpacket() or wait_for_response() returns -ENODEV but
> we
> +	 * already got a PCI_BUS_RELATIONS* message from the host and the
> +	 * channel callback already scheduled a work to hbus->wq, which can
> be
> +	 * running survey_child_resources() -> complete(&hbus-
> >survey_event),
> +	 * even after hv_pci_query_relations() exits and the stack variable
> +	 * 'comp' is no longer valid. This can cause a strange hang issue
> +	 * or sometimes a page fault. Flush hbus->wq before we exit from
> +	 * hv_pci_query_relations() to avoid the issues.
> +	 */
> +	flush_workqueue(hbus->wq);

Is it possible for PCI_BUS_RELATIONS to be scheduled arrive after calling f=
lush_workqueue(hbus->wq)?

> +
>  	return ret;
>  }
>=20
> --
> 2.25.1

