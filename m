Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA8168DD36
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 16:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbjBGPjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 10:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbjBGPjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 10:39:45 -0500
Received: from DM6FTOPR00CU001-vft-obe.outbound.protection.outlook.com (mail-cusazon11020024.outbound.protection.outlook.com [52.101.61.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D898A5FEF;
        Tue,  7 Feb 2023 07:39:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkGY4l9CpUby3WT1ujrQSyhpJ1AK/VP34LTRFwVOprxoW2aVzEE97DsaDML8Kiv38WFt2GzKOfVtWDVNKofNA4uoMz79Bjh3KSj6SIERC4HnKD5ObABo77kslwihxFyhTpF6nv6nKiKYqLxsEb6v0Krl2aN05h1yPd0rMxh2tgFZRcJwa88losZqeDzTRxyi/BC3Ahw0OOcD20GPsP6olO+g6A+c7v6rmVBoewHHlGZIRR5OG3gLQ28jJw3+dk+/y79bNqfIfXIVriFNSSLimbm1CAw3ZqlsxVb9T+GO/wuCGJaihqex7MTXnYFKN9zhETftodaFxqZYmUo/MUKpMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BKcxJcCpttd4igumoF95leWbotx3QjxgLct17CSXNE8=;
 b=I8uwH1Dp0nE7Qdr/Y1vBGH87a7OwyulGIB8Q7cOSvLmDldBw4TmbeRbWMiRt69K1MkcAY6bF9rx2jJBWuBcm1Sir8/JShuclcOuFoQCT8mZEcEs1KHFu+TLfiH/+ey1ad5P4Ug4Hq3TLhQHdzIaNEyPDHNVS1BcpiZNEf1aB/mhIWupX3PXt9KwIsuAlSa6SmUf1r+enoqIlfKulzlPIcpGMiDPMwixPSe6wQ8J8TxB2lsIc0JYUjpy0/czwYgKj/GAS0EZdi+PLl6KAX3EWhZys9F7jr7prNsZQJBACZsiu9dALO6kzJz7JRDTow5GtNrjBJE/A9+nOZrqZxEmXlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BKcxJcCpttd4igumoF95leWbotx3QjxgLct17CSXNE8=;
 b=Ot4qYfnanvsEilS9Gp8SBwGlRMJeEnId82AbNadIDHrfVHk+oZaPID4zowKdEGtVQ0rWZ4aTVjqNabpVm3jhhrrnN0b7xyriki9OXcabGJTbGRWTvZOUYhwWcFCEZsYiIn3zJsGSiSSOj9vqq2Z9cJrGmzHbzLwyT4Gqj7IXNUk=
Received: from BL1PR21MB3113.namprd21.prod.outlook.com (2603:10b6:208:391::14)
 by MN0PR21MB3072.namprd21.prod.outlook.com (2603:10b6:208:370::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.0; Tue, 7 Feb
 2023 15:39:31 +0000
Received: from BL1PR21MB3113.namprd21.prod.outlook.com
 ([fe80::b3f2:81c2:3ef7:dfcc]) by BL1PR21MB3113.namprd21.prod.outlook.com
 ([fe80::b3f2:81c2:3ef7:dfcc%6]) with mapi id 15.20.6111.002; Tue, 7 Feb 2023
 15:39:31 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Long Li <longli@microsoft.com>,
        "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net,v3] net: mana: Fix accessing freed irq affinity_hint
Thread-Topic: [PATCH net,v3] net: mana: Fix accessing freed irq affinity_hint
Thread-Index: AQHZOnIMkiERug8EHkmEMtI2zrdO667CxByAgADa8kA=
Date:   Tue, 7 Feb 2023 15:39:31 +0000
Message-ID: <BL1PR21MB3113E4B08250BCCB49F5804BCADB9@BL1PR21MB3113.namprd21.prod.outlook.com>
References: <1675718929-19565-1-git-send-email-haiyangz@microsoft.com>
 <20230206183303.35fd1cf7@kernel.org>
In-Reply-To: <20230206183303.35fd1cf7@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=846230b4-c34f-4808-a15d-087fa33a0f01;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-07T15:36:40Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR21MB3113:EE_|MN0PR21MB3072:EE_
x-ms-office365-filtering-correlation-id: a8f9a59e-54ea-49b4-7048-08db092181b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S8OZC8l46/mFuNkYczDl37LyLMSbfBhQQGkO6XjmEBLZxNHLFbWIIVDPWNy5zarURRiBxouIqYvobE9Xmwp2YOraPKiwvyVISEsZ+h6RaTCzp3QWDMOQFu/TMYgUhSdC/WPyQ5lTn65fQd+Ll9GKmsRsQi/NhFbH1shXnulz8E4CGRuuruQ8uCLL8RNQe8GtfDys+cEX+JHfS4rArSiTHJ6e6lF6S5QN00/1Y1L/WyrNPdEeEgcjfOZI7jadwGaJTV+8X3Qy4lU+yUVYd4KZytSL26KFVIji7RY3X0Ce7X69uhwbc3hZp1QfvErU76Yo9+GdoEHrIAv+5UdypXNbqjmr7M8fxpcNkEMEVe85HsS9wBhhZaYdFZwPl69uNZTJ2EOc2l/G4qn5M3pMfV0hN0L2mtg1h2do6l0SV3bOAtChN2S1DR8QlSGd4V9xFLJFrQBoUjzWLZryMkm1Vw6qOvWVbyRwvm2tfPmdn+rvA9PCmELD7GP7PdiveKzL0AdSRl3+KxNHpgpiLRo7WkLTooRmcdH2kdHApGXQa8I5cAN+nUDZsvRuO5YA9Ypv49g4Bjcj+sgTmvkpDyTGfBYTLWd1G0nAi6UP9KadSrw0fcJJmfH4hfcFrbthmnJIeH4o0ZRtLl8PEflheooYwsATei3mqlJVUun02hDfxvGmbekpOgSAnPIZU09ok2vOyuiVLepeemshtQkifhYkgFaRf65d9j+pF4+EPLA3F34mAEdOrb/zkpso3SgexMLWKdwc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR21MB3113.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199018)(478600001)(9686003)(8990500004)(26005)(53546011)(186003)(6506007)(71200400001)(83380400001)(4326008)(8676002)(6916009)(64756008)(7696005)(76116006)(2906002)(66476007)(122000001)(38100700002)(66556008)(66446008)(66946007)(82960400001)(10290500003)(316002)(86362001)(55016003)(8936002)(52536014)(54906003)(7416002)(38070700005)(33656002)(41300700001)(5660300002)(82950400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NYxCV4fiDHIrs1wxcC/pkcMYPrc1z4QVBYCgQpZTeJ0VhZsJwiVIYK5YaXMY?=
 =?us-ascii?Q?JmwUMJckX30BuSvknVE4iCxCUJxXQxj4V7zlIEbjxOxLz3LY3vQ+14JXmG7Z?=
 =?us-ascii?Q?AA2GCAvqJGCTnoaHUPXdDM3b0jB7X5z2SUBhVJr4K/JgLjiXpjBytp14ctJZ?=
 =?us-ascii?Q?kvmYgzB9IJx+0Z8AOXbaciCEAw/ZpjCnnbozxxacLoHaOBG9r0EiTo9toV4l?=
 =?us-ascii?Q?SEbBYj0C+mz7WWrwZykcGCXMIN3exb6ZBy4hwj4erh6sMYvRioKWZWtMs6dW?=
 =?us-ascii?Q?QGTyCqsNwlwP77PBJ5DN5QnbclsjkHFqyvcCUqd38L8hInTlBQOmF75OILYQ?=
 =?us-ascii?Q?cZo8q/TXf1DflfzUqFc3OqTuNoNHa/3CFJAr4ymCw/lc9Ar237DXgbi4McnP?=
 =?us-ascii?Q?BL24BmoHoAFSRQhWNDMOy+9o8QZekcg3mNRS/WWA4XVfOg2IaH8gKcbshELu?=
 =?us-ascii?Q?+87+IfpYxuZzBHbXytqZ8C0S5P+8PaqT+CaB7fc2iJpukivYcQCljuzY9hkp?=
 =?us-ascii?Q?jso0sBE71mTSXJ6tNF0tKAV982/pu2KRUU5yT6FG7N4Ma+UQsuDKggp1j4mq?=
 =?us-ascii?Q?kNg48moWD5qakQhuDvAchjlwfc5TXTjothMB+qSpb64Au9myjA7IsBHIgTot?=
 =?us-ascii?Q?Yk/Nvx49O4CWQfqH0HFGdp4i3LzZ8T+lIu0DQP6rWcazovJPRfuqowGPUx13?=
 =?us-ascii?Q?naOUGB7J3Eq7PqpI7R95MotcH2ensZaro3DrWcldeo0HXKK3aCBrG5FI8FOA?=
 =?us-ascii?Q?/Iynmp3PcwkEPQZx7gVX49NBn8f9xHE8kDAhi1/YQJzj+TMim90CmTBLIn2f?=
 =?us-ascii?Q?b9gMsIKHoaDSLxAUmQwYnzgnR+cuMqcTaUZhPQDemAkrM6W0Ih9ar1BWZ2Sz?=
 =?us-ascii?Q?9j/5LSUWcYhi2VnTxn6GFBCUgqeAtOy8HdJwgtT3xFwBEis7atGz9AzJTHf7?=
 =?us-ascii?Q?RA51bzDiVhVTAY2QQNdri2yJVRIY+RntyeIE/Wyn+Ia7/7aQL8A09w9Divyv?=
 =?us-ascii?Q?6XgeIU3/pTcCqzEB1LG2bxjsILUQpKk7/A/Z9UafRdwR/cCcXAD1jCYarzEX?=
 =?us-ascii?Q?WUVcuKr4Yux7QTttiHFy5md5Hn5RYStPGl3phdh7WjAeMolpMhawtRJ54aor?=
 =?us-ascii?Q?BRZp5Y0DDDLAbO5QAK53hK0TZjIo1KmW3wcXCHVEckiD9KVo7tED8xdkBKfK?=
 =?us-ascii?Q?+Bo5+3wEAWy2IMk7dHT5dWqncZ8VIAP5NdWz42090UZNyPkfKa+VdGdaeFb+?=
 =?us-ascii?Q?hDsfYIi3ZnV1gIlkM8yBlnrClaJoVzVE+p+oH7+7enBz02JI/1zIHOqAywW8?=
 =?us-ascii?Q?Z4llLqOcoyzhom6vrJ5byKQqHN68emCcXXsLXvca2Um/+JgJSXZipce7b5+b?=
 =?us-ascii?Q?VX7xpjCXKzd7JD8Ceoxs95mC5XPBZK+LDrNaw4pHTwwmWZXd4AvQGY8/SB8q?=
 =?us-ascii?Q?7Us/4yNqkUDMGZ58ZW/hr9RCqaeEl6usyurw6ev1ovSUNYC/WhSNmh7o8IXy?=
 =?us-ascii?Q?lb6ANiXj+p2KorEWrciKjqQhwsjGulJLqHWSlrxAKdMOzwfUvFM9WpRSEDG+?=
 =?us-ascii?Q?n8IF26YQDuLOBlXpcF41dCuHPFu7vFz1p4STJ74x?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR21MB3113.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8f9a59e-54ea-49b4-7048-08db092181b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 15:39:31.7113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qRpVAv0gHQ6Bb4two0g2FoeUniuKJV2mt+03u3C9Vn+mlFmLNUjcCTasiN+BCMvG7gtd9RlTZ5N60PKWAoDH2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3072
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, February 6, 2023 9:33 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; Dexuan Cui
> <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul Rosswurm
> <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> davem@davemloft.net; wei.liu@kernel.org; edumazet@google.com;
> pabeni@redhat.com; leon@kernel.org; Long Li <longli@microsoft.com>;
> ssengar@linux.microsoft.com; linux-kernel@vger.kernel.org;
> stable@vger.kernel.org
> Subject: Re: [PATCH net,v3] net: mana: Fix accessing freed irq affinity_h=
int
>=20
> On Mon,  6 Feb 2023 13:28:49 -0800 Haiyang Zhang wrote:
> > After calling irq_set_affinity_and_hint(), the cpumask pointer is
> > saved in desc->affinity_hint, and will be used later when reading
> > /proc/irq/<num>/affinity_hint. So the cpumask variable needs to be
> > persistent. Otherwise, we are accessing freed memory when reading
> > the affinity_hint file.
> >
> > Also, need to clear affinity_hint before free_irq(), otherwise there
> > is a one-time warning and stack trace during module unloading:
>=20
> What's the difference from the previous posting? Did you just resend it?

Previously, it failed the auto-check due to some people were not CC-ed.
I resent it with more CCs.

Thanks,
- Haiyang

