Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C3D6CEFA6
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjC2QmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjC2QmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:42:09 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020027.outbound.protection.outlook.com [52.101.61.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D305B93;
        Wed, 29 Mar 2023 09:42:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9HcDjEcolXq19bVvFozy0ZnygJ43niMrsaZvSTT7dXWb5/SqlAUDLYDop11lCjCp9dRH9gOaSB3oQafstEoDtNZ3MTxV+C18shv0MvADb2FBh9lX5f+ynbES4LXfZV18MNsbqqEK1J4hqbfvXPuClWi4sK2jCRyvgqyMafKfZ/72pzGuUhcWxK5tnPHadYglBD0k35DcxvAoeY1EsG1e+Ast4eiSID5RiZFbezIhX4gd4S182auMK4PgeZJcfKXh+u53Gb0Od/Vna1Z/PgKgCbiQ9my2Kc2m5l3uqhErTMVTfRVtSxvWZqLI247d6gZ3l7Tb4xWQFxMwBA+uJBfhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7OEUPE7rJduWcLILEN1rWX8CbjNaJfNF8Pop6rR8kSI=;
 b=Hl3aDbc/F/T5g7C69x+Y3CRucP+JFJ6E2KY5FnurFtGvn0Y23uCdj4qzfMFEYJKsygCeg9VkE5WMzpg6kZlIYGSMBI7298ZITUSs/KNJ06URfvl12JAeVm8JuecTt5yQK2bokKvQ/GYJtoUGssSp1t4gRsiWgFY/8J5VDavxoBISbkEfBW17nrAtD0Kld0coi5J6ck6eeEfZMrH8l87hEhWhGGJP4rA91rJLH7V5rOrzqoTBrMaFf5psJYVd4MtWOFBHQJNV9xa1SJ9jd3AISiAYmFS9Xj4KDk6w43PItIQFDuhUWhjm8k+f/yKfx2LgbWRiEimEjYq7zEHtJuJLfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OEUPE7rJduWcLILEN1rWX8CbjNaJfNF8Pop6rR8kSI=;
 b=bACF8obJxVM8b2v7UrLBZ4lm9j74ro1ftQhQBybOVnhOvbTVwAvP+ZTylZKmIkSutoH4LAkfiVBF9m1Y5gq78jPIH8nCh9rCUZiSh5j5DX3djBoABGAYk3OsKYfaSkDRlWwnh+yTKoeSxgGy9l+HNZzI8oIla7UaV8uA8ynp74g=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by BY5PR21MB1378.namprd21.prod.outlook.com (2603:10b6:a03:239::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.12; Wed, 29 Mar
 2023 16:41:59 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c%7]) with mapi id 15.20.6277.010; Wed, 29 Mar 2023
 16:41:59 +0000
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
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 5/6] PCI: hv: Add a per-bus mutex state_lock
Thread-Topic: [PATCH 5/6] PCI: hv: Add a per-bus mutex state_lock
Thread-Index: AQHZYTE1pEQ7gkU7iEqSar775+Y63q8R92Vw
Date:   Wed, 29 Mar 2023 16:41:59 +0000
Message-ID: <BYAPR21MB1688790C39FEC18826449AFDD7899@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20230328045122.25850-1-decui@microsoft.com>
 <20230328045122.25850-6-decui@microsoft.com>
In-Reply-To: <20230328045122.25850-6-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d326267c-94e2-4182-a6ec-05deec9dfec8;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-29T16:38:28Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|BY5PR21MB1378:EE_
x-ms-office365-filtering-correlation-id: 98f2b520-1822-49c3-c558-08db307483f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6uznTUJ3q+uS+gNLFJfFe7utwNkrUKu9czazbK8cfhNOpy1wfSDlGDUkvPWCXv05BYgfieOHHOVpoU6GRYJ145rcvzUZDON7AYANnCzTUwcIVf7yEffqaSw8Qu3kyk0tO+104zSab9QdU0jiT6suLmdqV7n+v5weH/B+dlqSMmTJu6QwRX0nwyyjb/xAUIFrBpO2jltzNQajeV2VE+ATl9HOlPQmER9eMmrvo94YypWz2EBgR6EORfmAOIBQ7KjUITDi97bfHh4XpQs6tvG9MCjiJZMHfBABbYaRM9krZ2ggWGHIXE5F9IQpbcJvJheH9nG9BdOT8++oRPbeCyGT9q0Z1H/VoWSnqu/Ntf/odOrrJchr1telFASS6yUB0ee223rle8FE4AJdjAvjXzA+bueT7ON0VVjGyjaIS1KFOTQ1Q1TMkuFj+07bI4T7Ij9EKsYqmQouwSyPv4cGKkyHhbNgghsvAGmhL7O34yeB95SB9HGmAfZweUr7ZX9rThrteCw598h8bdxfQEhi88gxeioanTqV5J57lAXOts3q96dyX96sb01pRlwQrWI7yvshjc7/HkJ922RqCCfe8dYM/5HLg+EWx55e6vRCHibvfo/trV9w9Kek6cnlS3agF7IJtr0yjGk0B0xGU2ynoOlsSnZbllQcuLNp08yF9s5nXznoG989NxEfgtbRQulImIs/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199021)(83380400001)(76116006)(86362001)(33656002)(4326008)(122000001)(921005)(4744005)(7416002)(5660300002)(8936002)(38100700002)(38070700005)(64756008)(66446008)(66476007)(66556008)(82960400001)(82950400001)(41300700001)(52536014)(8676002)(66946007)(55016003)(26005)(9686003)(6506007)(54906003)(8990500004)(2906002)(7696005)(71200400001)(478600001)(10290500003)(316002)(110136005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZXra0IxbiskzTF3o8OrnWF0YVamVE2yrbmp72nNYPqrhHFRUaVecoHb6iWvz?=
 =?us-ascii?Q?XiR63nCtzkC0Lw6+fceS0/0DUQbUT6QodcMpsDOfkr6KNPDA6wXx4uj2CRaZ?=
 =?us-ascii?Q?Q3yObLl3o8sp1L9f784BGcuN1Ddyu+hmB3iiiyrumxa6uNrjMGZp3OqhR7oD?=
 =?us-ascii?Q?2edAImaWbegH9oNHGglgfoX0KhVDvFP/8lcazN5gHEpOf+PZxclQ49G1h7s0?=
 =?us-ascii?Q?vu/B9gNd48IIrcp5Q7lsU4Q4ccyaH4akXm0x8EMpCfc5NCUG4hgj3xnqBJuh?=
 =?us-ascii?Q?Ijw1Vcen4bALJG+F5gBScLZQ5KmYslZp2CHXqEQthESrr54estSZHn1lPq+a?=
 =?us-ascii?Q?bru9BG+Rd5wESlnxWZoe2Kgef1ZZ9iSW5+PjgJhcq37aZUbEnhs8M8P+aCfJ?=
 =?us-ascii?Q?WAIvyj1R3a1eETS5Ezq7pAwT5G04lCuT3LPv/Uh/+iS49W57HPv95qIfRrpA?=
 =?us-ascii?Q?xv5LKNeBIWzE0KFJbX8B0pcUKC+MgCAnBEOCh6hw0SghboK0oGoTj4BqvcPa?=
 =?us-ascii?Q?+N7Fa/w8UItvRRWJcMAWvdE+g6pYGrl6qPhe1I8ciRqYi2Wnd/iYCMigOwiO?=
 =?us-ascii?Q?VIbHNcHcFsok6Mba18UBC1MKEMPqOz7el0TeHUtUDpC/VFf3uGqMt9sXHh9u?=
 =?us-ascii?Q?T6Uw2PKvlwk5wAy0fOs9ZTqmRLZ9FCTPqg+vTznGx852HkiuMz+fcuRxjA+9?=
 =?us-ascii?Q?kQ6Vnf4nymZvWy+h1xSn+gHWQ+M7jdPoIEaCyPwImSBeM0/230zF2JId72Q+?=
 =?us-ascii?Q?mY1Q2SDOAOsJ3fSSolFNpkMlfHS/6L4iyE2vzWglkQTPCsCpF7pzG2iokAZG?=
 =?us-ascii?Q?U/V2Bl/ya+DzYK819gZHFcjB5F838Ikeu/XfVPnVhxcH6Tdd35+MKdErvFRC?=
 =?us-ascii?Q?g9fwbTU7iXG2TreBHP9hmTUP1B+sHjuSflz4UL3QuNXvBQcxtGTYlm0kNM1e?=
 =?us-ascii?Q?2i25dFDvAdREmQmRg+oz95DAb2p7n87DZhJyDq86FVavewB0TRLmleyqRfRB?=
 =?us-ascii?Q?bJIjwcQGi1jQRiUnUNTkDrSTJXo2yjsroNAA98xan3cCNS8RJFxpppYIGvny?=
 =?us-ascii?Q?O5vhBles/5fw82cpsNxLgb/MIbjTbzXkA2ux+PVQYmhVnantI6geS1sICnwG?=
 =?us-ascii?Q?pyNg56ZwVkVONwgB0DXaFUgjYLtGoih3D6u3xXSVEvC2pQIEa7CHAZdltsIt?=
 =?us-ascii?Q?qc4NOhurp/hoWy7Xp/0DIU6w8K8SV+fTOqkvDPTvnCNbmwZvuMdOz5Q6Ebhr?=
 =?us-ascii?Q?mpseQLSLnzTWU22Bw9wW/+8IWF0T/eegE3tVWn4wyzukZOBMj/MhPKIUaWZm?=
 =?us-ascii?Q?dRX3T7jkj+u7p673nejqxYbakcwBB5gZa/eG1f4qYE3JaZVJ2NSpdL8fodVg?=
 =?us-ascii?Q?Hf3uCFCnuuReUGsZ1DcH4sCi//oFl2FwNB4N98484GO17SbJg1z1F+K/cpHd?=
 =?us-ascii?Q?qx/g4jzWeWAYchtdYVZq/ZFkNne/C6VUKo2tAwhEGixrTwLWKHnJJrQSC6Ty?=
 =?us-ascii?Q?NM12fwPnrSiPpXXIGEOHXmjNaGo7jQlJFJwLONU6LcUxskxNu9O0yXuZJyYY?=
 =?us-ascii?Q?KGolwF7hZo4zRZW7fM3i3w1fvf+0hS0FtmlJ9/+uMHfNF5Ou2zM75cFLz3GB?=
 =?us-ascii?Q?oA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98f2b520-1822-49c3-c558-08db307483f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 16:41:59.1360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nLSP43VeZptUTJnMJNGhegptjpCNrZDNjgd8lDZCgQT8SbkZJlxiOFjCCyxwqP3ascrqyPE9VMfsErPULgxYtZCZ2nXvlB8oBObqHG+I0ek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1378
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com> Sent: Monday, March 27, 2023 9:51 PM
>=20

[snip]

> @@ -3945,20 +3962,26 @@ static int hv_pci_resume(struct hv_device *hdev)
>  	if (ret)
>  		goto out;
>=20
> +	mutex_lock(&hbus->state_lock);
> +
>  	ret =3D hv_pci_enter_d0(hdev);
>  	if (ret)
>  		goto out;

Shouldn't this be goto release_state_lock?

>=20
>  	ret =3D hv_send_resources_allocated(hdev);
>  	if (ret)
> -		goto out;
> +		goto release_state_lock;
>=20
>  	prepopulate_bars(hbus);
>=20
>  	hv_pci_restore_msi_state(hbus);
>=20
>  	hbus->state =3D hv_pcibus_installed;
> +	mutex_unlock(&hbus->state_lock);
>  	return 0;
> +
> +release_state_lock:
> +	mutex_unlock(&hbus->state_lock);
>  out:
>  	vmbus_close(hdev->channel);
>  	return ret;
> --
> 2.25.1

