Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31256E46DA
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 13:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjDQLxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 07:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjDQLxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 07:53:21 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2060.outbound.protection.outlook.com [40.107.104.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF73526A;
        Mon, 17 Apr 2023 04:52:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ScAp0HJM6fur7J2rcD9eVA6OjkUuIziF0HGYgGzFkOb9zucZqzt6JlLiGFk6cQ3xEnPw7pGHaCYnOVfSAYYAbxbYgSMIOXRIlSCaYLmoVq9lgJK1OVamZUBMwG9M6GUyjLTYg3hWo94Ge9OcXSI0ittOt30jAE+Qau/tA/nhYh6fxUWhAtvRThXSs8RG626bTnKR37oQIz6ylIPWD0sfpK0ISj6nrnLfbtQUgQfonDlubtoZ3KAjieAyDE0r5ANvwLY54jlBXvtMvGSKhUu425xwZH2WRxSsqCfNI6SVkHzI3YNlmsJ9ReYIR65Zij6Kd2PbjePnAhnAu8BvViddTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N+7EPBs6PFM45LKDam3m8b/fAvKaiKLqxzG0NDHAQ1E=;
 b=ZYCKshzUdvhhINFCpwigROGFl6HNJqtwV5FUjq+KccIqhBZjH7wpsPZeHQfykBqB6fj8Jmmj8hBx8taplpn9/JPjaAIvcRiwMb/o2ezWHlLT4xlcU9v3H9jv3yypCrjrLMlZorl8Ou3H/OlIVZ+pstVkYwFH6jHnHmFbMgt6LyLqpwc6JZrRH5TT8bKSK4Gu2LPDkf1a6z2OP6x82rpjbcqKmmE/ITnqz//jEJGvfmv3ZIRQCZdPcUzpdA5JhpFMKzT+cMpb+RuiX7icYlfLT3EWguaPXrfrbPSi/MYWwpq9Wyju59idNhaU/sBYGh9lMgZSkT4EAi8mriGoZfRf+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+7EPBs6PFM45LKDam3m8b/fAvKaiKLqxzG0NDHAQ1E=;
 b=jBWUNcVVtTy5siyWo3GiIQY1lUwFK0BiilU6GljI6+TMcoxzzj7aqPypA5MjtGnu84wiC233Its+WYPsyLdp4c3KeXOIdXRdIyy1TnZy0/r4KVLYOP8oN8RuHLoK+DwFusyDL9Q66yGnqHvrno6+hX+QmK79n6uZmsHPszwfcGs=
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by AS8PR04MB8037.eurprd04.prod.outlook.com (2603:10a6:20b:2ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 11:51:22 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977%5]) with mapi id 15.20.6298.030; Mon, 17 Apr 2023
 11:51:22 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Thread-Topic: [PATCH net] virtio-net: reject small vring sizes
Thread-Index: AQHZcDeGnH5xR2OGlkuo4s6jvhNMC68uIjT9gABGFgCAAG90AIAAMSwAgAABjzCAAARBAIAABATIgAAENICAAAM4M4AAIQOAgAALfyGAABuqgIAAAQKH
Date:   Mon, 17 Apr 2023 11:51:22 +0000
Message-ID: <AM0PR04MB4723FA4F0FFEBD25903E3344D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
References: <20230416164453-mutt-send-email-mst@kernel.org>
 <CACGkMEvFhVyWb5+ET_akPvnjUq04+ZbJC8o_GtNBWqSMGNum8A@mail.gmail.com>
 <20230417021725-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723B8489F8F9AE547393697D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417023911-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237BFB8BB3A3606CE6A408D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417030713-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723F3E6AE381AEC36D1AEFED49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417051816-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237705695AFD873DEE4530D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417073830-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230417073830-mutt-send-email-mst@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB4723:EE_|AS8PR04MB8037:EE_
x-ms-office365-filtering-correlation-id: 6c7eeabb-3ae8-49c0-58a0-08db3f3a10f3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hMc1SBHOvrcNVINToq1aLBJkZbmOmHvwufHDQ8lFFJQp1CjcPJLWkO+RnqresRXDKaBAb3ENMVHytE7imEuvsHjcToUtDwns34moesdlv1VDW2vZuNo7W4618reUyksJunWnuFeZGyZ3LyjlVlKf+g01QCFATHNQfItECofWLP6c0JJlcG4vVInmGvKo6jpQW2R63oq/QwzFjbNESXJzPITE1GoAktm56/JNWV8O1tyohInUlr7TxuZuMsG1vHvItX3R8TYG4UxtSssCokT58TIRijmNaEVtIBxv+5rR3HNwOepf0psoqOEjZv8U3zp3/A9DZb+3t8yWruE224k0HWWxn55A0HK9bZHTqh5ZsHiDLaIhgOgbFRQ3KXQohS8yDPel+ZqV6Nv0l4rFTC8jgKMXm5y5Lq7hYHdcIOCRO6Ix8Z8bpZugYg9Ds3KsR5YMPjDHZn6H4jL9dEI9GTb2E9vV4Z1RgQIQH2cx+cVRc3UFLlTaJOljIzWIstx+sNQDikLfahZ4ze9HlFxzV48jz7Cs7cWnYPhiUXH0QdMyfnfSlz0e1uEUPvguQdnZzhxBk1pdMTZujdbS2F7dcDp4kjUtuD41a+QF+FgOSffa03U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(366004)(39840400004)(136003)(346002)(451199021)(54906003)(55016003)(7696005)(71200400001)(478600001)(41300700001)(316002)(91956017)(6916009)(4326008)(64756008)(66556008)(186003)(66446008)(9686003)(26005)(6506007)(66946007)(76116006)(66476007)(52536014)(5660300002)(44832011)(4744005)(2906002)(8936002)(8676002)(38100700002)(38070700005)(122000001)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?OrIlot2aMSkxr9ayCZbydcf07c2018LBSOBnsVvodyiTvU3MM8BO73WO5E?=
 =?iso-8859-1?Q?2kvn3V2vmFtGcxpxybKmItoCET3bfoQwpfGVX/fRpqVBHTWA7qcWtYTrKs?=
 =?iso-8859-1?Q?ZIMVY8jXDRJXwoCEohkEUJRD/kUUSfYgTXfL2nuTOvl0mqXB4AjZhElQOZ?=
 =?iso-8859-1?Q?fsVlqRNPcyk74pVrla72PC0r3ZztPcaHLzPyG5aJX9fzzqcCFfVhJ2WIZy?=
 =?iso-8859-1?Q?s438EgcHCSnCzQldhSiSnmqNmfoLiDVC8qWkT1tFWfIfVs5tmmWsC6zCnd?=
 =?iso-8859-1?Q?4Rrop3LTyVbEMHNxCRpwBRUlgj+SaaSn54L9OukQTGMVPVhgkeRRY58qOf?=
 =?iso-8859-1?Q?3slL4tfC5U7BPOFb766YgXZko1qcnCz9gvRCU+oPieXculiX6SsS3njwSH?=
 =?iso-8859-1?Q?l8MtO1fODUN0hASMn2uxCb+Yw2Yj5DG+VngXLHkjEa+zt7aCHsJ0rbNNFZ?=
 =?iso-8859-1?Q?3MLiO4gQgCEfYYqIFJb/wxElYhXoOPbGdOBU43ANdw0WtLJM+1kLQRf12u?=
 =?iso-8859-1?Q?Io43Z/od6yqVMzu/c84XOFBXateuc9nCyYWgtUmI7XZB2M8SHDRFgihbdz?=
 =?iso-8859-1?Q?z8Dt+zlZaMfz6k1/hcsfvvSObOqyXsAkB8OQ5Q2eVoIQtm8lOxt21UYr8E?=
 =?iso-8859-1?Q?uDsBDMYr2EiS1C1EuIk67dbfi18YQ0QBZ48b7ANKT4Z4118uO3FCLsf9Xb?=
 =?iso-8859-1?Q?0OvH4HBYAB9um498CIUgMhIlcaKSGmVhN9jwTFQHna/6O/rlOY2FqTKbLb?=
 =?iso-8859-1?Q?pA300qgxcSuaH1RWZ0OGGUjTg3yyEU/qJyGr3wSOcpN6NRy4z83LAIvg/Y?=
 =?iso-8859-1?Q?frJx+WaCwVNUehfR3hcOFbq6f2UaOfCStKrxDvNGMA60cgTynrH5ONILgP?=
 =?iso-8859-1?Q?syVr+0GDvsK2o7Sdym9Tc/m4ExtV5ZoDqr4UfQtHvMMcd0jCa5/+L+INv/?=
 =?iso-8859-1?Q?/JN4yZBz52YqZ1+puZVqm8qBkd1LVfn1feK7wwEdH8LcyZCkDOyE75JHsm?=
 =?iso-8859-1?Q?hXAZBHdfOKuhYxoJu+5xzI0XtnY1jZwN0S8edpuX8VgQ5Usq32W+wu9aw+?=
 =?iso-8859-1?Q?3QNh5IZyBSuZfThtogzJN8QSx7IpOlZjstte1henfco03bepIHxm1dp1Ot?=
 =?iso-8859-1?Q?jGv0yK+lKl6igKB4iDMOdhOk1+bPY14+x/7dbKaSo1TTZU2c5sp64nxt5R?=
 =?iso-8859-1?Q?5TJPZdArSxDOfCD97Ndw6c8lI+UaQryOsZf/onZTeA0IR9qMcDV7dnIbqd?=
 =?iso-8859-1?Q?iwrBnOkcWvdQyfrDLJkJa4GcRO6G/uIWrTq62tAa6uHHewEh8o67oGM5tw?=
 =?iso-8859-1?Q?3J29vK49TcTZmi1uXT1QvB7VPOpIqtzFy15Af1X32tPz/CrBxUyhMxekOC?=
 =?iso-8859-1?Q?dD4PjENTFPyOVJt3JBmRHe31kWt0k5HGrt5ktQVGfnTdAEh9anhQjPcZk7?=
 =?iso-8859-1?Q?P9sGeN5Ztm762Quyl+cQWr1jI+AstpxzHwyiMLfR2AAdduAWgdzaer4Xj0?=
 =?iso-8859-1?Q?ioNRrj8VG3wJRDII5Y8KKN6+5cOCPpjndW16HCtrWM7X3QvVFgQ/svKXwH?=
 =?iso-8859-1?Q?u/l8gvHqkNEdBwJP8GYauJi52FL0t5bgg0xLnATKr6lVROQ4WL9V3mnZ+p?=
 =?iso-8859-1?Q?yLSEhbbJ8vvmjI1oIa69zvl5JZDUIbkuAq?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c7eeabb-3ae8-49c0-58a0-08db3f3a10f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2023 11:51:22.7999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0oV3FazxrFm83Bp4JPwDrKUZ4KpPaxqSFPr1+sfccSkDgeKEfHTrQhE3PUBjVQzNgYGxMfY1w7bptnFEKgtiayJl4bpZiqJAvZDk5Xgj3Uw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8037
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I see your point.=0A=
> > Regardless, we'll need to fail probe in some cases.=0A=
> > ring size of 1 for example (if I'm not mistaken)=0A=
> =0A=
> Hmm. We can make it work if we increase hard header size, then=0A=
> there will always be room for vnet header.=0A=
> =0A=
> > control vq even needs a bigger ring.=0A=
> =0A=
> Why does it?=0A=
=0A=
At the moment, most of the commands chain 3 descriptors:=0A=
1 - class + command=0A=
2 - command specific=0A=
3 - ack=0A=
=0A=
We could merge 1 and 2 into a single one, both are read only for the device=
, so I take it back, it won't need a bigger ring.=0A=
But it will need 2 descriptors at least(1 read only for the device and 1 wr=
ite only for the device), so we still need to fail probe sometimes.=0A=
