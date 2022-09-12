Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C455B6333
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 23:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiILV7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 17:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiILV7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 17:59:32 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021026.outbound.protection.outlook.com [52.101.62.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52536C26;
        Mon, 12 Sep 2022 14:59:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bBlHY7lVASZGORVlIPjjtY9Rm80syAtgsuEG43YKEUclnlEiRez2Uwlnk/1jBIJ0XUqL7YOzbPRRQeevz5gFbxG/RbdPtZeuIArxlY/Zp4M8Lwl5ob47dxviGTLGvLgrCTZQ3gCusVIH+8XpGr1fp9ZPtxGYcULsgFRSz6gKQLU4VxB1eE3ZyZPm6G8wXu7byCfnoW5crL56v7L/zx8JeC9KPmtoehD4mzWiMhYQA7L6plGxMqYNcJLfbFQXW96Eg6U/edrrUwK1ENcVjCyqAUkoqqZFhOhna37WaWAeMxIp5JEiGFjogoVs2+pSyyl3cGQhFDr4SoiYNyP1PEo5Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P0V/S5XJqHJtNDRClOGA6eG0P8KW7OvDWt0hFYEZ4AU=;
 b=VoeIp2zC1MzqUd360P0V9tyYQVTdfOUaELPe8nCERK623Ri/HXahE4aF2PkOoPPQxXEaU45CUngtK/Ir9/1p3Wx5f0H76a4gLWVTWKjr1awukwujDJHUPvqlqj5iQuJdy5WETnEvvlBCzk9IeROX5/OHDXRm/rWXkm7ZRR8p0nZJZBDMN3oDbXibMbQFz4Uz6zgn1/KYRQTXamaHYPJsuSsesVMBTnPozEOmhdnLEbLOiECWtZwDX9eylGR7K3b+zhnnn8FRsV1pht+VIq5fui8Nt2pi8ufCgeXHFB721poO8WttVjXojQc9Nb/2mZ5fWD6t6NRX8yioyqk/t52xJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P0V/S5XJqHJtNDRClOGA6eG0P8KW7OvDWt0hFYEZ4AU=;
 b=CuwjGFdjLYhNHwPSqdpDeJZw7ogsbAJGpNmMme9QKALHBfyI2auT/najE/L2EtDhsVLOh7YQFZxeQliDCVVAXV9JWEM4zrz2r9DIMqz4TsQHuX8nfVd0Rvrcm8Un9Pv0O3j9s5+fNq79gS5XBoiHuPvldmoGvqryoLmo4Z7dENk=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by CH2PR21MB1510.namprd21.prod.outlook.com (2603:10b6:610:8e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.7; Mon, 12 Sep
 2022 21:59:26 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::b113:4857:420a:80e]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::b113:4857:420a:80e%4]) with mapi id 15.20.5654.003; Mon, 12 Sep 2022
 21:59:26 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        Shachar Raindel <shacharr@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net] net: mana: Add rmb after checking owner bits
Thread-Topic: [PATCH net] net: mana: Add rmb after checking owner bits
Thread-Index: AQHYxh69MF7VmF17GEK8iBkr2VCPmK3cWNpA
Date:   Mon, 12 Sep 2022 21:59:26 +0000
Message-ID: <SA1PR21MB133595AAADB432ED8699D1DBBF449@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <1662928805-15861-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1662928805-15861-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a3a1abeb-2790-43bb-8e2a-e8f9d2bd9daf;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-12T21:56:43Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|CH2PR21MB1510:EE_
x-ms-office365-filtering-correlation-id: ab3ce960-80f7-41e3-d89e-08da950a0f03
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2DNUwRyijtfm3AsmUDLobbZpPm+tyJe6VhZucQYWQBpMRbTHohFF1KBVLD1aVgHmHHRN0Bhpj1+PtdoPfV6oE3ielLhsAuYaYB4Aj7yHdwBOzelysYBHpnctZZo9R8v0BoYfmV5jvQAEx3RETTm1kW4T4IC6AbxsXEjwpz5ZZ17uyeAhbu8JXZtsO+4mBd4gPVA8YOSybNHLvTOeO7hYFdmr3GOAceKVsHd2y1t/pHGdbqqhNrpHuQPzOYGH+GZfc2paKoJBHmqg9NzWPhUO0MnvF99EmSGbqDkMcP9wxvICVljhlZRkCpA0rOh+F+iuv3oIJOqR4o/+4T0HJWfJHQUEOjubCfeRMmTN0KLd8zlWLM9/VNNbJFnwvRlB/LeyjV47sR/JecqG8li2psbYAUoz72JmCI7ccfctS7u+GPN7q1tFXpzlxY+6dHIu2whOj+ZoaZ6szbMKmBum64MM+ulKH2HiPdZbQhw+cmn9uDi/AVMVvPnkno7RbBZSVbjT8NaUBVHYgrIczfjf9IYAm4OQywut7xii95G4at5nonlA74cVZdIBrYnwN8PaYysE/Hxa4EsUgjAsqng27d3jdLs7+8xgDdnBJlFG0B+WcXf1PpSLNINny/jUA2V0VIzyPqvywzinZEG7QI2+YR0amqZv91Jl3ZRod+IqSes6hi50OliE2gd+lvjkX+hwa5yfgVMh8LMV2VOcCnC4KMobcFvum9hh/cb0aJb73wV4XfiRasoXUEupqq9MUw7D7AITtufeezZ/sel8vBrgnhVk/boHZug58w/wwt9yTwrCI2n45jNfGLJ7tWfD/Al+4/Kq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199015)(64756008)(76116006)(26005)(66946007)(38070700005)(2906002)(66556008)(82950400001)(122000001)(86362001)(55016003)(316002)(8676002)(66446008)(82960400001)(110136005)(52536014)(41300700001)(71200400001)(5660300002)(10290500003)(54906003)(66476007)(4326008)(38100700002)(478600001)(4744005)(186003)(8936002)(33656002)(9686003)(6506007)(8990500004)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3kn2w45jk5cvzjMr6tP2//v7zACDzihan++X0NXXxcr5lS3qN0362iPQnH3v?=
 =?us-ascii?Q?fmWXRDdwHHhDQ+vFcY+cdRFGRJHLdouJ5fQ1NJZR4GTzykJb31/Xz1HLf+4/?=
 =?us-ascii?Q?P4Wu5UW4Axm7HuFHpJs07lYTWByIBJI2nhP/os07PajaO/rpKmnVZv4w6iN5?=
 =?us-ascii?Q?JppGaeLmErGO0hnD/KfstYzwuziveKRQ4xvLVkAG0FquXIwbr//OxcypIdUF?=
 =?us-ascii?Q?ebvAHaT/9XDkn2rUn5fy70S9dHLo1/g6eAUk7664SWK+si7iu18GZkqvDBE6?=
 =?us-ascii?Q?iQa83JBEuYHOLrjqH3JtXeEhH4KlRqVlR3vlHqeUGDYiFb14+HQEdtnvuoLR?=
 =?us-ascii?Q?lRt0OlEBfQqAw5mfkw2V7jSSkXwL6tr05Rn2a5gxBciKzBr7Ir93DR7+D3J4?=
 =?us-ascii?Q?c36nJh4qPzuAb5NWqrY+y27LPtlZNNfxvK4IqaFLVt3rpPmxqxXQHukR1BU9?=
 =?us-ascii?Q?8Ovfd5h1OOTDeo7FYU7s9aPQ80ydRimE2KOs/5QARdmGqIfW6LQ5FABNshkm?=
 =?us-ascii?Q?L62i5Dml3aDUClpw2cMdH/4C660lZhQhKhtw4k5Ux1sfKVE9X+j/+YG+9m45?=
 =?us-ascii?Q?Ei7JSEgz4FX8ehCSnoSlIbkMFYOniuyO6N6zQDulRRz+Y5V0ludXeQvRBsQe?=
 =?us-ascii?Q?62OoAmMhOEfuiRCkfOl47NwUbRCQ0Tcl4yzYhyy8oMSsWb3Gk8RWId7JhC4d?=
 =?us-ascii?Q?ZPkFZENmoGRE3R4M+qQr9tDGMM+0/wP4gdwLHzauuLB7mce2DRct+NCXaPyR?=
 =?us-ascii?Q?SM/xJqf44QnJwKrTTLP7GzqRPOT9rMYVU7hoUU59GOzbkiJ3utgXX+Lyoy0b?=
 =?us-ascii?Q?kjaZojQddthR4/nxnDm4xR/lzYGZ8NN51TYPDhfXfkPEMwecKdf8NUzBgA+Y?=
 =?us-ascii?Q?vQ4rGU9W+XudkZTpgfRrMzd0ZiU5ddnDA/TaQUvC/5ePvI0v+M7ztTLCKJJg?=
 =?us-ascii?Q?2H3/4rY/Ep/tbx0przZFm0cqEssZSMP/8QCq9/wf8G69zwSLMoIrnd/DhpxA?=
 =?us-ascii?Q?51vJBMVPDnN4iWmlkZN+2Eur9OKeWXCx//QcE8qLPeuhM9uD5qunjI6ueerj?=
 =?us-ascii?Q?j+2SP8I9e9HF+zk5pmre59h6uq4XtAvydVkwUsX4vBVr5LQ3g/HoBSSTqwYH?=
 =?us-ascii?Q?S5EC531XsxpANVk/2ltmfDIHczMTaW/WfcUjDRIF1+gFH4MZB4WtQyUbK0un?=
 =?us-ascii?Q?H4b05eF3IQjh1C/rZQ06njrbuTqTqJsJN8pKG+HZ2Ul8ObMrt2ACykihAige?=
 =?us-ascii?Q?kU4AeCQhDflMrmsmckk1qmN/KcFwdoQhzcALpKUhM6L92zfX0PHlNj1lnhJd?=
 =?us-ascii?Q?w+VvPahoRnKA3hSyyLHDu0yaHBlgawaDziGrHmEWJRlLWRAywiQA5fXQ6hBh?=
 =?us-ascii?Q?CThpvqboKLcXwWCplQM/KQ3o9pMEEV/SgZ/qVd6Rn7QZcsPyyAvwh6y32d6J?=
 =?us-ascii?Q?rBde7OxCaD5I89afMLrm+Ft8U8+L1OWx7M5ralCLoUyY0w8/ZOrDcNqtPo+t?=
 =?us-ascii?Q?UsTrStwu+yz4SOE1OjzErvNagN3F1CxBujqvBR+4fKkKr8AWvZBT8m4Cj2I6?=
 =?us-ascii?Q?PhNSthTKLcwiwcTKAOORJleIqS7/RbkIfIuqam6C?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1510
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: LKML haiyangz <lkmlhyz@microsoft.com> On Behalf Of Haiyang Zhang
> Sent: Sunday, September 11, 2022 1:40 PM
> ...
> Per GDMA spec, rmb is necessary after checking owner_bits, before
> reading EQ or CQ entries.
>=20
> Add rmb in these two places to comply with the specs.
>=20
> Cc: stable@vger.kernel.org
> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network
> Adapter (MANA)")
> Reported-by: Sinan Kaya <Sinan.Kaya@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Reviewed-by: Dexuan Cui <decui@microsoft.com>
