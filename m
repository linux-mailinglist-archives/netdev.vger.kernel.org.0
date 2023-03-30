Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C72F6CF8D7
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 03:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjC3Bs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 21:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjC3Bsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 21:48:52 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2104.outbound.protection.outlook.com [40.107.223.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D254EEF
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 18:48:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qj9Z8RUdm+OZK2+C1kiVUGOX2BOprA88sFDPYGIiNGeCSwiLY6v90vjwMeh9EZ+sDTPLBXMrpa4xzXetMsKUkO2mN4q3BGJKT5GcuSR2qrOynBlaGLnGT+3PW7Zlw8A791hTCgldzQ2FydmGJT4brbgFyhmnKHN8GBNxPKzuLNpHPG2A0oltpOw6B3TCEPFeLll8R3Q0xf+UocDZasgFWgtUDxTIf+igFhgzo3+z3xZu94n23/kcJqh1quL7uvNqT7n4DC996G4UYNWH6KXN5/0VWduq6snBiUbXbHTZmUS8gRpZlzXqMjb3gE3lfGvEEFmzrWIjwQNLJYd76plUXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xv+/BLpHe/NH/jsLqD5a2cyB7USico1hXGsTb+yz9xw=;
 b=Kj9eeypcJM5ImeW6bgZD+1jr+1TqoZD8HrvVg5GY6q2y5fmm4KkuQiOIATJtao2lErojchoNF/VN94umcXMT2liyiSel9eHA6gIVgsub3P73N65/oKRrwrg3WpjserWurEFoufx0vJmv/1S7xauA95HPtgNrVInlDL8/M8CKHormjzguQYidza9/tiy+PfFmovy+fp9cLuJ+SU1sUM41+DHalzNU8xyzmCtRRAxlvsuTL5q4DA88w0xajaGCCvae8lrFUagbHeP6QPfaz1eSYgpnMJd0qGd1hg3n0Fy1RfumF9WXaQnClzWIqBe2Cos0SoIktSaoZYIsNfFyuuPdLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xv+/BLpHe/NH/jsLqD5a2cyB7USico1hXGsTb+yz9xw=;
 b=OmlcsJo/BBkzTJE3zCkeZaIhHDBn8G0HcH9K6AUlU5wgLff4m/LWYkK/tepDwkWng1QBz12nWPYKARE+/jF2lG5meaWNn4pMkpoXX0fxhgd/586R1BavQjfXdEq7mJ3q0N5Tth86Vv/EtHyz2eCFtMICIrnQ+QmzNrt4D3L5VJM=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by PH7PR13MB5456.namprd13.prod.outlook.com (2603:10b6:510:131::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 01:48:47 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::8795:a7ba:c526:3be6]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::8795:a7ba:c526:3be6%9]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 01:48:47 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Louis Peens <louis.peens@corigine.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH net-next 2/2] nfp: separate the port's upper state with
 lower phy state
Thread-Topic: [PATCH net-next 2/2] nfp: separate the port's upper state with
 lower phy state
Thread-Index: AQHZYk07XTN/U7MQDkW8TxKgBUt5LK8SGqWAgAByUjA=
Date:   Thu, 30 Mar 2023 01:48:47 +0000
Message-ID: <DM6PR13MB3705AF84B6782F064CE3D6BEFC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
 <20230329144548.66708-3-louis.peens@corigine.com>
 <20230329185235.GD831478@unreal>
In-Reply-To: <20230329185235.GD831478@unreal>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|PH7PR13MB5456:EE_
x-ms-office365-filtering-correlation-id: 16832b36-162a-4533-b48b-08db30c0e73b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kMMthG6CsNrnIDSTqwKpuULOpGV9GoC3Jbfnt7aUITVGDsderwjpFQBs9Nw2+ckPOkabnAWDjCPJGxQUDK+LSU0uO2USlKCzs75rDfq/ahc5EF8S4WDCRaixfScYpngKHrWStN4Xq3LfjrYLNnGvsszwg39cZDEwJMQdOwQVgAGZPNbmxjlbiLJRgNO+XJY1E7i2mDp+ILn0UFiPlCmxbUhATkAbxBsozvZWoL6ND8sWzbD6kKLPdJrK4PsGxlKOxCH19AFzIhJ+wPyZOKf/j+LokLg7BiP+p4ZKCxrAk7poH4QRxqcnSV+o9GZ91VR/mPtgumF5cItczL47I+bUjfI/JhDTlP8uqgd0rofReSMA7ciOeD1gI8a+e1SOiPzxy6f85VZGj4U6cAV1o69Zyx5WkiBd/lnCfcAXYfomjYICHUwrf0zwIgiYRTrFyALadl1MYHl2toBmJLfBLiDfXnnbdYn499eYJUd7GPyzo2JRlNxX15KLRuJNxKfKdJi7Vg8NUgkPkeF1GlOfJOCgoW8PIdoul/rgN89jzM0v4HH80kln4Gi2vrNGl03BEHkZlTzzbCjtbXRWIjd6haSGxZUi/tOMED0sDB/9q3PCZDs4plK8Ax9+XTpAWHwyy6yVEEmLRIR3JPIIjIFljFsX8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(346002)(366004)(396003)(376002)(451199021)(52536014)(5660300002)(186003)(55016003)(8676002)(41300700001)(8936002)(66476007)(66556008)(66446008)(64756008)(66946007)(76116006)(4326008)(33656002)(71200400001)(7696005)(122000001)(38070700005)(86362001)(38100700002)(44832011)(9686003)(83380400001)(316002)(26005)(6506007)(2906002)(4744005)(478600001)(107886003)(54906003)(110136005)(6636002)(20673002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iKVit51oCi8vegUwkzMwXrorvK+QXzqVZZl6iMEMAbgH8ohQ1hui3dtUJIqD?=
 =?us-ascii?Q?ZdCvN020iTxOP7QE4+/80OgNAifVCZrmqxav5bfR1szOE4lq/ACpPIWCAxgz?=
 =?us-ascii?Q?riZXEhiyO6vZEJTDvfYsug6yz/Jyg35D0bhr2U5EQjURkdJNTdQd63BQuvhq?=
 =?us-ascii?Q?5GmCa8+XM70hVajlf6Vd/kVXGJ0cgGz4tU1LNf9dXLVY200bKUxQxQr0K+3K?=
 =?us-ascii?Q?OPwj43bVhUf19pNLB24NDq/65PBngvHafqtNkYhAICXw6I9vbI5NmEZgZ5H0?=
 =?us-ascii?Q?BhphSBoZs9pSKNUioMf4x5lbAREEajl8WemAI0nqFZK4hA4fFo4V31wkzoPs?=
 =?us-ascii?Q?IHtZM9QMlW6gs0Rnj6JN8+FpkQcjZmd4jzq3elojj9q67/Qv7sAJlj+H3R5Z?=
 =?us-ascii?Q?FOGm5sKcFPWRpmZRexrLK5siQm4Epa8w4n62QrDVik/KjJxTfsUlEfZ9e7OS?=
 =?us-ascii?Q?SIH2GQgNi9iOXsB4gcluGRZFwZ17hQWn9T1mrUxive8TaDtmKuAklr9vf2JI?=
 =?us-ascii?Q?RbgnHmZaPA2y/Zoy0yrdE9nxLFx8y4YTHpkmzOhVMtUEenh3RvXVFbyVlGqr?=
 =?us-ascii?Q?v0LlJPukcsz+wT5eKmZ5zSTz+ZLWomUi0UJpdssUHvloYvFJ2yO2mqQfZyZF?=
 =?us-ascii?Q?v/bUKcIZeztWglMHsWfvLn6+dHWhiTdNqW9Ti7V2XovA13uyq+ZcZEaVqH2t?=
 =?us-ascii?Q?tbrCbqQHwXbmV8ajQ8tmTBBgZKWDgxoKesRUDwiC+/i+F0OhUDv+9EqC22E4?=
 =?us-ascii?Q?GTIYa+8QMB4lsuhPTV1u0FZVycdCCVgNk7yPdRU+wjcsSXg0zXFxsoiWDIUo?=
 =?us-ascii?Q?aiBJAkzmcpTsdFHq5OqMLHBnP25c0x6vWXFcFuaeKgVA1+YhATM83+cHbE5F?=
 =?us-ascii?Q?uS5hMJkKPVFxY+S3dK+QbjQP83ilkLW82OHUarcAOqAcRzPZvVixeyxGe2HR?=
 =?us-ascii?Q?mBz5AHdm7aDQglteSMUDVRxHUthqhfkf7CTV1UR3mWokbw8JRytGAjliBDe0?=
 =?us-ascii?Q?kUspPDsBDNLvHTJ/60mkfTtzQcqxtZ05kJHWrihgiLrSn+ejuyuoAI3k1BHa?=
 =?us-ascii?Q?ESzRryofJwjR7x8XxeRNuSdEypqz4y/E84U7JfSm+yiVI9r3362LMcAwD/v5?=
 =?us-ascii?Q?qV2GnlBNvhP8/4Z/hWQ31V6uEQ+xmaFNZENYz5wpy51z6YJuTjH9UMYeHVBT?=
 =?us-ascii?Q?ZFHrur+6EzBXBCAssxPuUEsx9LTFQurOSddjP/hP5qsSj1I93MY6MMhxyGiK?=
 =?us-ascii?Q?32VWlh/6y+b/2CtRzt3XrqtUzGEIY0XqlkkQPPjMihourLDf9J21l5hv+3lw?=
 =?us-ascii?Q?WcWPxgi2n2Uqo9AAU1mi7eVHDC/YKzzvel31FSRPtIAgMsMx2db0FTGH+MOh?=
 =?us-ascii?Q?i2Ct1aoyq4KEUpGd0drc8lk/xkMEPQl4xTIOUqUKWbEDvzqEIFv+FprjZr6H?=
 =?us-ascii?Q?9PEzq1lujDcPyoPIktk7/xvQQxRSZ4TmdHKaGJyUv4puRzWF/fr4Rd+tgljX?=
 =?us-ascii?Q?yYaiYUJOirk5bPr3f7p0jSum36onVq2sqKlvIOaFnTGNp6jzoFirwwcDO76D?=
 =?us-ascii?Q?6+ipxbW1uaNTs8lIIjb52iFRpj7it3xjkyo1NVZO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16832b36-162a-4533-b48b-08db30c0e73b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 01:48:47.3825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NTEQq8VtKqpIiS+KSOMbUFb4jd5h+MaTlyIjhcxkUI+e8+tF+w9a7B9Y+JUZVN8MKlX11BNfcs/zbDTbqV93LKaySg4v2n2IR5hGI4VuzhI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5456
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 21:52:35 +0300, Leon Romanovsky wrote:
> On Wed, Mar 29, 2023 at 04:45:48PM +0200, Louis Peens wrote:
> > From: Yinjun Zhang <yinjun.zhang@corigine.com>
> >
> > For nic application firmware, enable the ports' phy state at the
> > beginning. And by default its state doesn't change in pace with
> > the upper state, unless the ethtool private flag "link_state_detach"
> > is turned off by:
> >
> >  ethtool --set-private-flags <netdev> link_state_detach off
> >
> > With this separation, we're able to keep the VF state up while
> > bringing down the PF.
>=20
> What does it mean "bringing down the PF"?

Sorry for confusing, it means if-down/admin-down the uplink port.=20
I'll rewrite the commit message as Jakub suggested.

>=20
> Thanks
>=20

