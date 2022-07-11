Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D02A56D27C
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 03:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiGKB2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 21:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiGKB2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 21:28:36 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020018.outbound.protection.outlook.com [52.101.61.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BB3DFD;
        Sun, 10 Jul 2022 18:28:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mD4oyJ8W1INHgBH5u6ZYBaPNy2iC+8OPg8uYwBpQpjGGSuGyAXFhWRyqiqf5GryxbVfVkmlo6aXfYZp74xW9xj+2WPHFKv5Gv/fnCwRmwV6lLam062oLiALDYz3iEfbdY9ck50O3eyBbmSdOzP3/Kr9MxXmj1OvFS63rO56C5cLx4duliDPxecXhVo+yES5vDFwei7hc2w5HHKjMcR5WdLQ/F30+Loi7UiecbfOc7UAavgTCDh/Yl2ObsWYaVCfAC9fAND6FBZvwPdqyX5RyIzNEuVPpGW/SZa2uhq0yFObU/DhphBZ6m5+pUa6aE7urQLCBxB0prlQ8yIhJQ6pG5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBQPqmMQCijoeuHWinrOlEoWYbpFc/flWKs6IeHmEo4=;
 b=ZSbNi5/pvEvN5bd3RqZOAWN5UbYhVHw6QiDIKTP6jnCVBHEh4RYhp4WKu81ONfiboMoGGKUhWEIrrouJB2U8lhlJ04w2d+GzkWrM3EO0frmfIaqV+aZEUoiR0TaVhBLIUiJH+U+QZZZAqM6H8RoeJ+AphgayORNz3vAXhBJPE9WpBrjDWJToYi1iNtZHu/2LVxFvMIaaozwlXb5m+lVAZaFvbYf7Oarp85KF1vbuTHCEngHl9ebbTzFr8z7eqOtTqfpUjEK7KxEOb0T6ZAIQnpbZ0f+etDmil9H7nQZqjoXUE+ZVDMSSjtJ207M6tsTYEf9dL5ENuBpQVgrTvoo2Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBQPqmMQCijoeuHWinrOlEoWYbpFc/flWKs6IeHmEo4=;
 b=M57YCiIl4c//fNi65o8q5xVwjWEzxzAC/O5ASe8AWVpEwx8PqSg2SSu13oN891dFz74NSD3wwuXgID0KigAfRSnzAYRzwPc41/nqD6s/XnMe8AMD6OXj+2fER3uJPJlMqQVIV25onVY7UbOHmbkg74RDhC/+QCe89aO2gIIGtq0=
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 (2603:10b6:805:107::9) by SJ0PR21MB1886.namprd21.prod.outlook.com
 (2603:10b6:a03:299::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.4; Mon, 11 Jul
 2022 01:13:50 +0000
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0]) by SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0%7]) with mapi id 15.20.5458.003; Mon, 11 Jul 2022
 01:13:50 +0000
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
Subject: RE: [Patch v4 04/12] net: mana: Add functions for allocating doorbell
 page from GDMA
Thread-Topic: [Patch v4 04/12] net: mana: Add functions for allocating
 doorbell page from GDMA
Thread-Index: AQHYgSXXDEEQPGvZwEeo6j9y0QPeoK120v9w
Date:   Mon, 11 Jul 2022 01:13:50 +0000
Message-ID: <SN6PR2101MB13270BC0DF7A9FA17582822FBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-5-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1655345240-26411-5-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=cf1a848e-4358-483b-adef-870caa689754;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-09T23:21:41Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf5a1310-d11f-4656-0295-08da62da9d0b
x-ms-traffictypediagnostic: SJ0PR21MB1886:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AQ67ML2eLHE5I6qnj3MIB/l1x13RL1v9sK6x/2mbmA0Ccw8Dab5NnAbaxZJxqzT7rSt/lhjn2B6hzBgyKPUCKY3Z8MuyX8UmFt7IQ1TBL4Ag0Ukg5G19tWlNjWdyLkAkFFAHhAmT01n0GhOjPv839ZGBSlo+WWPLURVgqqoul+n2/Xb2NM3Cahdd0oEgEfUnlJzY1rtitXNnTJ6jvBpn5isYO5Q7NLE+A3sRM1HNbpRpRQZEeJXjafg6rZJqj4DveN3nJHf2HxR0bYPE/xfhHngPJ8+aZZDQoEfcvhYzAF0bfCX66vakiAgrxdVZMY9e7qbLJ6M6RUhSEc/o8yxFkA5rzmjqW0AF0B1Q/rTWG4b26LTjpHPJ+dbOwFX9F6xrqCPLQmWcJxBiNvgtPls3kzEtjhvJsXcqbO9879UGk1D+iwqJzd7QryPWrarUwpQPTVDJ83Wuv0syr2sGI+Qm5HuumWpfDs/ckgXgJC682kT9xD15s7jf/bZwMZy4VuRZUa27twXTRctuMcrf42TjqHjp9gHDeFKR10fMVRvhoZLQBYgPRORxOaJjztgNOLKG3AOe28hVnR2yqRmYvGQ3ntxQ3c8EmgmPDk0XFew54jtKBqH+SXX36/TEwRis87ju0+5g4Vf2IV7Y+rwLJCie1YBC+f+PvJMwP5jCW507Rgw80aQYNJrgGjOeQ6TSzSX4bnB88jndiu4bK6o2YU52UCoTvpZ3EtaYeoTJ1quNeK6RgRJI0r/DNq8KwwFH0I8vPLnR3zcHlFzqO9yi0ntNYedk68xqovEHpa6PsjK7ZyNppw++f7j6yBQqFiSfVMsysPRLQtY4nY6Wq9Zrp85wekPEt3rxAfOmCVVlDxSnkoo67QMhszMKFYnP5aVajR3c
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1327.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199009)(33656002)(186003)(26005)(7696005)(6506007)(9686003)(8990500004)(82950400001)(38100700002)(38070700005)(122000001)(86362001)(921005)(82960400001)(55016003)(558084003)(54906003)(110136005)(6636002)(478600001)(8936002)(52536014)(316002)(7416002)(66556008)(66946007)(66476007)(76116006)(66446008)(64756008)(4326008)(8676002)(2906002)(41300700001)(5660300002)(71200400001)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PcjWutv6MGVLIBN1PTFaDY0T6oBySLIuUgZMz3vy4bqpO6ESqZmaRsl8EX91?=
 =?us-ascii?Q?q4RjYjMmGQ8kPPk0gwQOX3QT+NJTOzPeeiWHRLcHvnseDV4kqfypCz2CJUKk?=
 =?us-ascii?Q?7hC7TvYDnjUstB1WTGTAmU9yznY/I0L0oT4AwSe3qzojdVQyHJ6iAt0JafEL?=
 =?us-ascii?Q?Uocfi3pLBAKTm/HLSYgxKtIMLXV/JDPx8oqnMtiTCxVQy/cu4FOKl7aq9sK2?=
 =?us-ascii?Q?kvvMIpsCLKvcQKb+BEkQY98XbLyX/q7iWfIjo9ij1jasNhSjV+J/5lVqnBs4?=
 =?us-ascii?Q?moG17ZoSsl/0dCZTfYQ1SaKdnFTaJQpaeC88H0QWYfcc46IDtuTXyrO1eRMX?=
 =?us-ascii?Q?wDKGaLQCBGzM+lMla3lKg/8WcbZcS7jkDBX/6rZ1qEBc80FPjP9Rl8AEMPuW?=
 =?us-ascii?Q?553NQUkUHYKVjvfCn0Ni4x6IEhF9fYmVzi7ZZpI2hr3a42m72ty72Qe6LHvO?=
 =?us-ascii?Q?J0QUYBoRLAbdI+PZ2sV0iSNymPHQXuTqiuPjpeXF17Ag4eg5VyfkxpD/urxm?=
 =?us-ascii?Q?f32hL6KDqs6Ay/34CiAS6CWIazW0wHEl+Gy6AU7YXNO/U3FahYI1hXVD1a+W?=
 =?us-ascii?Q?7qB6wbb7e9j2KUVdGQcP3gUjc+IazKN2yyJOYYVZqwBmTwUazEUBSznq1pyv?=
 =?us-ascii?Q?UrhRrPfG+5/S1iCJLELQ1wqMkgKTXDwG4f0nPx5DCOyRpL8poxh9N0C9jM/W?=
 =?us-ascii?Q?N3gxNeqDwRkFa22YKwcRhI+ucpkpsXD9v5oecbuehh6KY4Zqk+JmI8djIP2F?=
 =?us-ascii?Q?sHzufCsHRXkroALv50JPrXelNgXQ5KtR4kcnLXVtrf+qChADCfDSYFxlX1re?=
 =?us-ascii?Q?DAvgqX2HDJJ38UK4tXLwqZR/u1dznmKbWskWpknpit7pwM9UZbVIUCs4ZEzo?=
 =?us-ascii?Q?9Tz0irzk49HCTsm2MrpIxur/5UehzP4g++Z1WSKi6e+NgrDjQHY1OdPTNhuh?=
 =?us-ascii?Q?Yoy+Q0RZWMJBUcOtS48L7PkUtiXOkF8LL8tTKH1eJNor5VAFt+NNwxXwFgPo?=
 =?us-ascii?Q?6y/efCD3f9aPhWaKsHbGzmrSPMaMWuTjVTCSR5FJESiSqHRO8rPn2rV/isny?=
 =?us-ascii?Q?2iKdSnhC9JbPgwa5sxJ0bcoEA9py8CurtYhLsJrguEbbajMbobKi8iSrjVHT?=
 =?us-ascii?Q?uGNgaEJGr419sDZvXMGO2ha8TzohIW0PEM/BoBp4pUHfHr0W4LRcOWpwTmJc?=
 =?us-ascii?Q?E3z2pBX5jqX3AKbtjffhQAp6ki85KiYzVPPBR9+RrMDKOzIHgl602BUIC7BZ?=
 =?us-ascii?Q?5QldG4mLIyb3NkUjEHKLQy4PKSfdiy4bepTiBsd9WsxZNIBwo9nXNoTkSlZR?=
 =?us-ascii?Q?wipQONShmzOLRzgTD5EmC1oon9h3i1L5VQZSMfx8uBkbUPzzQNwzeEcEY3AR?=
 =?us-ascii?Q?q0Zh1YxvPKZu3yDVObGS+vz0AIlQltDtxHpaHbpcKX/31csawMPwteDzVZL3?=
 =?us-ascii?Q?DcQkuDUBHUeqZYMnAyO4Czj3/yKJPROBnUfdmNFq9jVqdPyLJFFpAZdekNSg?=
 =?us-ascii?Q?/nsvpOpvNNZtSM7s1l06oiJC0jB6r3TO5vif6aK9USIZQDW3cQ2whpjL8D3u?=
 =?us-ascii?Q?X+/veayHqfWu4+VgqqCfGpxjt1pcQGlIccRh/guF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1327.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf5a1310-d11f-4656-0295-08da62da9d0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 01:13:50.2858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QxnHqRhJBb84Gh2KrmlXzhyxULxJ85gs1mmUGM1ceuCxTYBa9D/lHFy7gP+/SR1WSyf25axazesXlSFDmeGkyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1886
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
> ...
> +EXPORT_SYMBOL(mana_gd_destroy_doorbell_page);
Can this be EXPORT_SYMBOL_GPL?

> +EXPORT_SYMBOL(mana_gd_allocate_doorbell_page);
EXPORT_SYMBOL_GPL?

Reviewed-by: Dexuan Cui <decui@microsoft.com>
