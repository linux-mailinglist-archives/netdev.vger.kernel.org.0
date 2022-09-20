Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BF75BEFC8
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiITWH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiITWH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:07:27 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020014.outbound.protection.outlook.com [52.101.61.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB477823F;
        Tue, 20 Sep 2022 15:07:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXXFnIShZCpWjyGDOCau85oMax9QzM/l6co3XyFAjksPcukCxaVQgMo32AW9OvRcSb9IOOnk9o8NOleH4CLiCnB4oslS711zRZr/muKWaAmxa6PW6Sta4LAOrPqENbbAbIjlMKLVWbiPzpUhJH+2c+XrmC+jlMwkRIxU72/4WoiYDj83Cs5WBFPDXT2uObCqZZ9FdDr/Ud+LARl/dGhDy6NUEfxciWuQl77UGBZ1weThgaWtoEgGZ1JQbGcQsrfIwUwVX/qLIHrHczRA1FG7YdesbAk3Xe0UwdFa/vt80zK+1MZP0SLvFhzz2YTlA/+OVyTmNp5Bwbt1pgSBxJC66w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ziOb/WmDfrp5UUhJIgnt4VhNwHoK1t/YM8ck67Krpc=;
 b=admvvdI92U0ulzyOjG++qnDdaqvC1b2+YgGLhbnsjj6HoIB5MhYBLlZiNkATW2gxHRVoQFdZg4e7mhqs6MUpKRNQ/N08dVYxiARt4o1ESzraU1hzxCaUFjbSjagVTZv+y6DLNp34jqtw1bs3yxSynMS9QOsF2V3OAo/R5jfTIl8Hx834dlHXYavkTEieY35yEmwrj8bRcswBXZHoYYg00qWx8biTaRVhds0FhRZarzVYxhfwCEjlR3PnPs4dDtVhjWVNxtErH3lEHpdrU3VrxQfx5te4QiumedMgcNnOPoXKkptpseMiX7nGNjmSxc+HzQj7v3elXdvTRteWDnfOhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ziOb/WmDfrp5UUhJIgnt4VhNwHoK1t/YM8ck67Krpc=;
 b=JwYDa7CLORgcoNSGfmKihdLX+tT6UGYYz//LB5Rzko2b/rGvd7TSrt2NeXlosryMSBwdq9zs0fRxY4KhS8WZPBzGXH4vbdKFCT8qgQCHD8JBDV9+CpTvZbWgrcl2B2jBI+ARPY2tgLIsidIV+otuLcuj6Zzf/FLuR2Du77ScrQQ=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by DM4PR21MB3683.namprd21.prod.outlook.com (2603:10b6:8:b0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.6; Tue, 20 Sep
 2022 22:07:23 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b%9]) with mapi id 15.20.5676.004; Tue, 20 Sep 2022
 22:07:23 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
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
Subject: RE: [Patch v5 09/12] net: mana: Define max values for SGL entries
Thread-Topic: [Patch v5 09/12] net: mana: Define max values for SGL entries
Thread-Index: AQHYvNF68u0sVoi5XkSjgg0YQp/js63pAQMA
Date:   Tue, 20 Sep 2022 22:07:23 +0000
Message-ID: <PH7PR21MB31169EF022D00CF146E06D98CA4C9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <1661906071-29508-10-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1661906071-29508-10-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8b3e7b48-2cdf-41e7-b493-96fa5b19e7d5;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-20T22:07:08Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|DM4PR21MB3683:EE_
x-ms-office365-filtering-correlation-id: b3349deb-944d-4030-7c12-08da9b547ec2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p86DjEuDCZwaHoBemOdlkER2HlWcN9/z+BoKt6YDnmM/QC18BIIMIrpFa2IxktoGHc2O8KB+fbUjwcLEIH+kFUB6BFkL+2g7eEi5Alu5xO2WFUzuPdVW/QqIfgbIxzuWhShE9W7bpyaMfxZqWdrQ+X6T2+R9eYFPmqi4ee9k1kgvysTB1bJBXqlbsjC26nvnOTpB1q3aLJOnJ2O1W9kMMoiv1BjvQ3Brw6RBnX3stuUxYRKeZCUhCd44L/G5QiozA4vWXzwJ2oDu5Aw3pkFQGYMgFRKfjIhcH3FxT7qc9uFj/WD0zD2iurs8LwMJVUpNdEC3V4NAaV+j8umr2Tsjm4hhPADjrGx6jgHKybrivC2zKlBPAlonYfPdF+6YN2NfyCSdFfpFQREV+beYLFG/rZG1c4G8InsFbT56bGzxwYR2t8Ye8vCRlJeTFxxVjAMH9nKOSSNpeYPS3lJPy3IQXl+XWyN5SaVIvzS8wRhKf1Fzkc2FeN+fDy8M4t6xmvfA8Lu47NycY+84ClQ59JJlhxsUyjbRa5gi71KCZDXmHD/L0AzGjHmWakTd7tG+uWagyjiwr1XZWQCO2qF2KlZUtFCN6q0CZksqcT/cCd5sPlvia22JexjHDQ0+IXVdWVR8CmgkZuXUsYHITtxwEscApliI0ivqKKsk7IhleP9Holt+lpFcfVLv2OzxX4ElCysn0SRpZINbPQ6Gys7VGWSHSAtfa15iQSomK1mROimwpt9Q18+mhpoRtH+gfWHf7nVXteziZJE8wFCamjAg3yAfpeVZWswU9V4DgELx77xI5MtzmlYizADA6KxihqidDrYuhro4uXFEP6erjfrvQ8dg1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(451199015)(8990500004)(921005)(38070700005)(86362001)(122000001)(186003)(83380400001)(38100700002)(76116006)(82950400001)(82960400001)(6506007)(2906002)(7696005)(53546011)(9686003)(26005)(71200400001)(478600001)(54906003)(10290500003)(66946007)(6636002)(316002)(110136005)(66556008)(41300700001)(4326008)(66476007)(66446008)(64756008)(8676002)(5660300002)(52536014)(7416002)(4744005)(8936002)(33656002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vJ4nwG0d3xvpumxM3liiv0I7UkTvaqyZtR0oahrZyhiSfkwOcFWzmKO0nGbY?=
 =?us-ascii?Q?5eZ0+JL/EAwAn+uq+fT5kp2w1mJWHLVZWR0aGrwBEbPDpzRjtgNhmg8ZBkGI?=
 =?us-ascii?Q?7ClTqnjzXTQfoGnAKvbnftYqcgfsgkhYELuxLlIanm7nRU/h6TFz6FamCNw6?=
 =?us-ascii?Q?Nd1eZqXD1A5uCvvdL6ORwj2DBX7ES6SL9Zk5opqFWrSF5+ZkW/xtVFCC/ihu?=
 =?us-ascii?Q?sn7gSOanXY5g9JWqxsJu/iY4IriSinI4dFGcIotTxeU2uz4J6mOdjFayW1po?=
 =?us-ascii?Q?09PQObPae5Wofy80lxzUhkYneDSnV/hXLa+tLv33z4sDezAy3EKdH2rLmJwV?=
 =?us-ascii?Q?T9NZIKcviiVpqJUvDD27cENQ06bdsM26qwcIEqeVZuZWpwpHtg9My/PNlejN?=
 =?us-ascii?Q?i8JR1U8doz4PiphrxaNOpbWfALuv2LQkYexlvCEVSfR7C3tKqIFpUn5n7aqx?=
 =?us-ascii?Q?KGQWh712HzjSUw0QkI7ej5j9bQhDa7qWGuN46Ykma3ZTrHqorwWlCZkf174w?=
 =?us-ascii?Q?R5MVXaw519QBDA0t8E+HroHZ4OLKOdSCGZegBXufYHLpw1MW9nfORKuzFuQO?=
 =?us-ascii?Q?/wi5PGXZaQHOVeb4cLfRMuLseB1jDJ9C+2mQ2PRjuTgJM0Eqt7ZJHvBaenHZ?=
 =?us-ascii?Q?oNPhvQiY6TiM+NqOHncIWLP+lsZM3PCJXZVhhUGa0ZIJ630Pv29zHVzZX33Z?=
 =?us-ascii?Q?gh/egK9LsapKGxyvNALOeRgT60EosQNMa4X+qzwUq131QXs+vrC1f9AHJgEX?=
 =?us-ascii?Q?GYzWKJ5oslzVdf1mYCX58ZJGogUEhJlXVvL2BHVHOZOEkFMRxOZgasCFu/5m?=
 =?us-ascii?Q?pS/Aya/Nu01RIoXeRu7BPfyxB0e2xoPWlLIwrWPdMKBoimP2HfJVZiR94HU0?=
 =?us-ascii?Q?JhKLuxQlRb8KdzOuWJfktZ783H3avO5S0ONVwt2hCdg6KEOsGKnO2ybG+TI2?=
 =?us-ascii?Q?wRodJAOMCLTgFuX20Phe3qcpFBKakOL0oLe2pyMsHgycC5AK4l7PG3C5VXI5?=
 =?us-ascii?Q?m6gApKOsDVLowG7t78s3S0qguBvBw4wik7Kd+A4xjkqWNRyZQIQbJ17lhN55?=
 =?us-ascii?Q?gg71xKppTLNFAkRtsnywNriW1J1f32JM+g6Wq6QpCoO64GYbfjZPGeKeXW1J?=
 =?us-ascii?Q?692sB5m77AQS1cObbJTU2O2dGZU53CWXvaLimZe+QHmX85iYgtUFYPpQFtw8?=
 =?us-ascii?Q?StzTPkoZAlYRrHt97MXpC0/6rhXzh0Ctpwc9YYZ4LAcXfCEzeAkx0msinYlt?=
 =?us-ascii?Q?qgo1tcLcWJKrq6XWXFQFX7CEq1F+GNUvVXrf8N/j5s/I0hJO2AktGDd7JEV4?=
 =?us-ascii?Q?BHLN7QImddUpvLV2rUJ7RTF6VXtOtjYqVXWlnu5K4gSr8B2VwViotfY+uTDu?=
 =?us-ascii?Q?5TqIqLCzj6AKJ2R7HYJjGpsYGaCmH1vBssq5rJrSp5sfGjB+42UTB6Xh/DCC?=
 =?us-ascii?Q?+pZowFiRXls3aPgN5O7q2Jn8iWeiPfxBzkjoxWml/RFo5G5hwsDe2T/oXOVO?=
 =?us-ascii?Q?o8NTXUq3iJ9adorrpappkz/cP7Eux1TvdjcHPksMJPqjdrxFVr3SdwxoXV15?=
 =?us-ascii?Q?QzMk320pqA/u6KnMEjG1lOVfBwP6BiKP7Iy0+sEm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3349deb-944d-4030-7c12-08da9b547ec2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 22:07:23.2111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +A3JzDDDPLAAUgUWfvv0CvXzTPjUtMUhdk811l9Uu7wCHHrsaTKkIt1X5FvrhMUvwWa+hpHgKZQ8LQKXSI17rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3683
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Tuesday, August 30, 2022 8:34 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Dexuan Cui
> <decui@microsoft.com>; David S. Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Jason
> Gunthorpe <jgg@ziepe.ca>; Leon Romanovsky <leon@kernel.org>;
> edumazet@google.com; shiraz.saleem@intel.com; Ajay Sharma
> <sharmaajay@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org; Long Li
> <longli@microsoft.com>
> Subject: [Patch v5 09/12] net: mana: Define max values for SGL entries
>=20
> From: Long Li <longli@microsoft.com>
>=20
> The number of maximum SGl entries should be computed from the maximum
> WQE size for the intended queue type and the corresponding OOB data
> size. This guarantees the hardware queue can successfully queue requests
> up to the queue depth exposed to the upper layer.
>=20
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>

Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
