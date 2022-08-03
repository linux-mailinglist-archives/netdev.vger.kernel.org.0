Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80FA5885A1
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 04:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbiHCCIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 22:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbiHCCIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 22:08:44 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastus2azon11021025.outbound.protection.outlook.com [52.101.57.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F61E4BD3C;
        Tue,  2 Aug 2022 19:08:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YjxIIb3UBk6CIHNSKAxWuNKN4bkLOZSe1MYI95KVrR93a1CSVYU0GLoewSCOId1yA3Beyi9YKuWKdLjnAvy/C80wMHKSwg3m7gP8f2sas+JGejpXAJKwq9ZybWAtzJnaUPX/CSqntor7Tcq2KAuh6paBdjNdqyy8Oyhfy1mLDB0CBTMvj4n1fo16A5Ncejs+jafLTahtRGOO/ZVxEDyHZCTaIm3S/ZnVJZOEthg1raatfjxBnw7OmAVt656+zvyiGrTVbtQB7KDWLLxs3hkVQJarky7PH3rvGUcb2sEWjDma35c0teRnEgKHJA0HThrMan8HxuamVT/fCzRjsQie9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1ej4eQAE+vC0HLzxklx4N5wCPLrEJkmQ3Vh2xBDiMs=;
 b=Q53BT7TzuNPJWLqUmWlQoMmJcgo1EHrvmPOyuzdFaAaClf239HgUNefoZgCIjvHFWa5fd/wWB1kS7OlKjG9o+ZbDoesgqTdzaypkFH93D03bH7VeXMur/cCol8IUY4cccHkuM+9iEA3CObAOBJ+NDYOizAr4C6dYDsFk4L7871DMa+Z435OGmXwbC2jT9D3SvGOljT72/fH9W8+n+Pnat9LqwqY1Xie+zsGBc5OoBBwsRmo0Ncm/3tEC2k75p1ctGYsA8Yg8Jo+n3LRCySvgKo7asMvspWs0KfhN0I8zPnzcCbeQ0peg9xJB5v1bp0WUZM/FjDrTHlGkgJlXK3CxXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1ej4eQAE+vC0HLzxklx4N5wCPLrEJkmQ3Vh2xBDiMs=;
 b=jEQYjgBT3KQrWFgd3Up4KCjlkkxHU7PRHEl87zc4TEfOZ4gKRAsLRezaF9W4NMGITfkDaotwfN5W+OwuLDkd6+5nzl9nQ9Xpkbwtc50LyCDMP3NfBupW7SvAYeeJSxKgMpFQrvHaBFffkRAAiPHROILMz8hTeZB1FwLG56s/HYU=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by DS7PR21MB3501.namprd21.prod.outlook.com (2603:10b6:8:92::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.12; Wed, 3 Aug 2022 02:08:41 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::69ca:919f:a635:db5a]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::69ca:919f:a635:db5a%5]) with mapi id 15.20.5504.014; Wed, 3 Aug 2022
 02:08:39 +0000
From:   Long Li <longli@microsoft.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v4 03/12] net: mana: Handle vport sharing between devices
Thread-Topic: [Patch v4 03/12] net: mana: Handle vport sharing between devices
Thread-Index: AQHYgSXY1SrlgLfyyEyOddi806gORa14hJeAgAK137CADOflgIAABSdwgAD1agCAADIx8IAADwKAgAcIraCABZU2AIAAHszQgAYYkYCAAIXJ0A==
Date:   Wed, 3 Aug 2022 02:08:39 +0000
Message-ID: <PH7PR21MB3263815FA70417F6BF11AF43CE9C9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <SN6PR2101MB13272044B91D6E37F7F5124FBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
 <PH7PR21MB3263F08C111C5D06C99CC32ACE869@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220720234209.GP5049@ziepe.ca>
 <PH7PR21MB3263F5FD2FA4BA6669C21509CE919@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220721143858.GV5049@ziepe.ca>
 <PH7PR21MB326339501D9CA5ABE69F8AE9CE919@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220721183219.GA6833@ziepe.ca>
 <PH7PR21MB326304834D36451E7609D102CE999@PH7PR21MB3263.namprd21.prod.outlook.com>
 <YuQxIKxGAvUIwVmj@ziepe.ca>
 <PH7PR21MB3263E741EA5AA017A2AB5602CE999@PH7PR21MB3263.namprd21.prod.outlook.com>
 <YuloD7WkRMs7ZIXk@ziepe.ca>
In-Reply-To: <YuloD7WkRMs7ZIXk@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=92294547-8676-4640-aa38-2402c026a815;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-08-03T02:07:04Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 473a2304-f51d-427b-2108-08da74f51537
x-ms-traffictypediagnostic: DS7PR21MB3501:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /IxHw2N6Hxyus+HF/KOmb+AsDamDz6XZUn+dTpScK888gHMp2kKu5bIiguZChzcLvCXa5NMJYiZJJhQWB+TIVn+jADw6RP0duCNIRqgd/nNDeouKK1ZmrdJ6cMsdFqjCXRiEItOhBq2HOK3zlJ2Dqt79Ac6DnhFXUabZXaFtR/AxY3vQrDsFAhAb5zQIQDamindatwcbDN5YWsO5F4mnjqPzVPR5NL21+Kl+bWMaO4cbmTd1qcofnfaJnjQEiyORH0ZWJ6/nopVZLw2HF5AJopMPe8BmIKY3vjQvENmN3sEg6YadXDoBaxjnO36knATdE45Rj98uLlxHniTKsYyb1thYwmZplefNg7NOr00MeGTHqGRB7GvYDBA2ROFiLIa9SMfLMNWJl3ouyFugSsmxvREMatrP9xvdQgEUAkEhGzfygWma/BQBkLnUXV5/rIcKUls1hN2cokpqAKLd0Cr8LV9Y+X6siGW7us0ygYzwYaGYSQO+aEvjfr7y9Rx2aPcot1nHMBCtXOkEaa56ut4VCtmGCyFVyafuXlO6Z4uG47q6iKAVuZ62b4va5FZML2boFJ/ypOJmYklXG52eRWsvxcCYMhi15rG/zXWmWuP63HT6S8UI9MgJexC6PP9aZAzILT7PUShUwbRUbMqY1VjtyaZl7LT4ZCh23S3PQamG+BOIjltxlCcY2Cuzcqm/2eL4W8BvR6kvNqrKmKAwWSTt0Ibc6KdtA741A6kE3kyqXurn3621ndZLAV8wiq0mIm3pgzOe750SNshz/mSv0Ev8a2+erhHJchG0YVNuvWdMN5fAjCUwI5QXfAuZEd1hZgPPrblKHO/P1Bg+SbUnV+uBb4lTPcJ8VQxZ+ht/47DQPTI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(451199009)(316002)(8676002)(4326008)(33656002)(54906003)(6916009)(122000001)(8936002)(10290500003)(7416002)(4744005)(2906002)(5660300002)(52536014)(38070700005)(71200400001)(76116006)(26005)(6506007)(7696005)(9686003)(38100700002)(55016003)(82960400001)(86362001)(478600001)(64756008)(66476007)(66946007)(66446008)(41300700001)(186003)(8990500004)(66556008)(82950400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ApF4rtOOM1w/l4JGvHGCkxIcBfabR0ryrJaMb4SVz4HhX48j+o+NnYpuv39q?=
 =?us-ascii?Q?Nx71R5/Vx4HM/FBHmnrhFnkvIPUKyWeHrOvsD941cITmoix+pkQQba5jdZfM?=
 =?us-ascii?Q?1QGvepfpj6JKabQIUhcJEZeAl/akqngoShFnT6IdfiZ8ulD+Tk20/5stMyGg?=
 =?us-ascii?Q?vfkgfsJgnBNnpJpE7AExOpsmfyMUrUjDl5NDdBxiqTyoYX7yudSPn8WECSPu?=
 =?us-ascii?Q?dqVnkHH3kmbkJVroP/cne8NIL1HvsX9gahhN19wmmiGNuROFJUQVCPefKbDc?=
 =?us-ascii?Q?I4cSFNM63jwxZ9g88enk2YDA8DQik2ITX9/UmNODfQ37QLF2s5fwD/KTCjZW?=
 =?us-ascii?Q?4mPgqwZZzIvg14eIl9Kr23C2Gvq3DbWF8cyHMacOKa8NZz0HYt2b0Dq6QlrL?=
 =?us-ascii?Q?ltKIecT/K0eS946BDMEquRvhW4hVQefHIGz597N0OcUrK/OXomglZrpUepyA?=
 =?us-ascii?Q?4wAuKu/+YoD8FwBUjftr4wwCNumgNlD9HKRki3XnUJOTZYqBjeDLvvNdNk8d?=
 =?us-ascii?Q?Tf1oD3YUjATyaU01ww4d26F7IkRmkCK0I36hRGnLeXSzXBYOGW5smq6pHJLQ?=
 =?us-ascii?Q?U7dNP9zBl6BbwlZsW6jLz2C96vYQiXLz0b6TsQWu5tkolpxbpOWCq2tOroXp?=
 =?us-ascii?Q?q+SRt1ClTn1VywxLaDRktvS0GaRNDfOdZTDmnU+u7h4+Sfw/KbI7sIH7h7q+?=
 =?us-ascii?Q?HuyLCWUgLA08fMRMGPeDZGXB41c4ykhO8AkI6xt2X3xHJvrs7uqIZuNXJrJe?=
 =?us-ascii?Q?aKL4YHqR1g8yM+StZ6zWEmU+eKHV8b/0kcA2S98BbpaQQd6RwPOGXqirn9lV?=
 =?us-ascii?Q?Kua2IHrOxN3c/TFGE10Nf3WcfN6MthF9zU1U9DKyigzGgmBuP0Ay2sCUdjwl?=
 =?us-ascii?Q?1Xy9hsXCdroKLeSyfVunprauHdwh73GXYNLWbWEYXQWiEmmo5KG/3D+6I/GP?=
 =?us-ascii?Q?+A60CnvswXnGvsB6Mq9pISHa7rtxPmBMpMdDB1njZ6uIP/Z8hWzuphWJkcNI?=
 =?us-ascii?Q?uMDhWnhQSINWR6n2wCZcaLkpC2216/jtnccr2MW2XEnZbflk0outbCplRv7u?=
 =?us-ascii?Q?fax+i8UzfKSphjHCSknQVn/pBmVNxif/CzmEIbbbawLqUEZ16KPdAC7NBMh3?=
 =?us-ascii?Q?AxGNlDw6kQPOOHZW7pxC74EcCtWmzeB3YczEipf2opyK1kONhYWLmaH0d4KR?=
 =?us-ascii?Q?9E3ao/Sd6dh5iJ0IfoIF3S5P0cmJKfWBJIyD1Ccm1BQ/x2TqDbir4iNwFVOy?=
 =?us-ascii?Q?R6lsLhbgwWQC3sSSCHhO1d8vEj+ZjCEIv9tnpLc2IZFa0AFVokGGZvlSMzip?=
 =?us-ascii?Q?uRj1cmesxWXe6NcVY6Wpd/HYPf14uFUNdxbluDg5iHSWISIlOcR8xKDyhd3W?=
 =?us-ascii?Q?Q3217lIlmbntxWUARZPNOey123RA+4DeprhA48uUTIcpVuRHobtdtFXO/qrh?=
 =?us-ascii?Q?D9QM3VWBaInZ2i4o4OMYeiyh193IDT+YtTC4Sl/764CfYSjWU30I61nGGce9?=
 =?us-ascii?Q?gMBS6VXu0UwQkitwg4aZ8CkDT72ZhzpUJLI+qLAGtdGs8sVTbiPbsudp7Z6y?=
 =?us-ascii?Q?NVl44RnRcbg3rsGpcl2lQzhluV1p66VdlReyB1Id?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3501
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [Patch v4 03/12] net: mana: Handle vport sharing between dev=
ices
>=20
> On Fri, Jul 29, 2022 at 09:20:05PM +0000, Long Li wrote:
> > > > the Mellanox NICs implement the RAW_QP. IMHO, it's better to have
> > > > the user explicitly decide whether to use Ethernet or RDMA RAW_QP
> > > > on a specific port.
> > >
> > > It should all be carefully documented someplace.
> >
> > The use case for RAW_QP is from user-mode. Is it acceptable that we
> > document the detailed usage in rdma-core?
>=20
> Yes, but add a suitable comment someplace in the kernel too

Thanks. I will add detailed comments.

Long
