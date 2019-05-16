Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D57B1FE88
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 06:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfEPEeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 00:34:31 -0400
Received: from mail-eopbgr1310105.outbound.protection.outlook.com ([40.107.131.105]:33523
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726223AbfEPEea (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 00:34:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=P4PjJApANutG2feoU2XfuE62+oi9LiaMnBNhrtcvXb6yoTY/QK54o/qR1oyDh37JoSeC3/FBRffOxRrnCMBVUs1orzW55SCZgYpfcmYAMOIS2iWVI8z0nAwqxVVyCLBxuhFSySCIvyVTwNJl7oERNDca3Fqml1Qxc4Q4APxc1Dw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gekgEer85PRnACe5n2c19L+ylZ38usHU2iUz6thQoWo=;
 b=GJbPsxDnZ7aGq99I6/jYupVC2JJqB8biP7L30D1QpLNd/hUG8DJqWOSB/m8BtntzAoy+/nl0HLQvjFqGMHNoqProXyql3NvtMyQwVp8cAr+SK9OdYnRFnB/+8UhKWZzG2ODkXKm8kai6gVSF2rHkB8zO1pzK8EHpIJ2Njz3oUOQ=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gekgEer85PRnACe5n2c19L+ylZ38usHU2iUz6thQoWo=;
 b=MeZbAWvq4D5uWCE8Qt7AiqspVr2kqNdpzWYNh2qs0EHneXp/kJv0RZAA1S24TXcHeQSrsXzBcUIx7cINT+HeCkHZ0euUVvgNDNfllxPtuDooZsI0WrcVEUIDbp4txdSSsZ1b70p4jwoJthEnF02eyIhQzO9rfbwZHf0ooP5QfWQ=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0121.APCP153.PROD.OUTLOOK.COM (10.170.188.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.4; Thu, 16 May 2019 04:34:22 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564%4]) with mapi id 15.20.1922.002; Thu, 16 May 2019
 04:34:22 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Sunil Muthuswamy <sunilmut@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Kelley <mikelley@microsoft.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] hv_sock: Add support for delayed close
Thread-Topic: [PATCH v2] hv_sock: Add support for delayed close
Thread-Index: AdUKtaBXG33lHE0AQU2ynJ9GbZ74UwA3pTOg
Date:   Thu, 16 May 2019 04:34:21 +0000
Message-ID: <PU1P153MB01698261307593C5D58AAF4FBF0A0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <BN6PR21MB0465043C08E519774EE73E99C0090@BN6PR21MB0465.namprd21.prod.outlook.com>
In-Reply-To: <BN6PR21MB0465043C08E519774EE73E99C0090@BN6PR21MB0465.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-16T04:34:19.9899242Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a52563af-82a7-4a5f-aed5-227da8f0af23;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:1760:3901:5c9:f1fc:42c6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 878d9d75-e326-4f7e-110d-08d6d9b7c4bb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0121;
x-ms-traffictypediagnostic: PU1P153MB0121:
x-microsoft-antispam-prvs: <PU1P153MB012108AC43BD1EE0AA06E135BF0A0@PU1P153MB0121.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(136003)(346002)(396003)(39860400002)(189003)(199004)(54906003)(99286004)(476003)(110136005)(8676002)(7696005)(486006)(81156014)(8936002)(81166006)(76176011)(74316002)(55016002)(9686003)(10090500001)(305945005)(7736002)(14444005)(46003)(11346002)(256004)(229853002)(10290500003)(76116006)(446003)(8990500004)(5660300002)(53936002)(6246003)(25786009)(102836004)(186003)(6436002)(2906002)(52536014)(68736007)(73956011)(14454004)(66946007)(66476007)(33656002)(316002)(86612001)(6116002)(66556008)(64756008)(66446008)(71200400001)(71190400001)(4326008)(1511001)(6636002)(478600001)(6506007)(86362001)(22452003);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0121;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oqhACWNFxxZiYIW+nA8wLXX/zMq5cn/e1ZhI9G19K4BjR01siMhknvAYgxNNmI2Loc5KZpJhw0RxVNFrXrvAoTQ+k57ir3hOwTljPSD53fakYe5+MXfBt6T2e1HqVr6yI4+rlH+uUmjEc5uiZKHD4197ZY9ELMu8XJP8J1bam7OJ0d7OW94we7GQfJlcZo7PJdDesOcUi5w6ezXQeObx6TST5vFT9vIPyVxqL59E3L6QgJ9ltlum3bZTyoAVfI0Frf9PtAn0KkXJOQCAquEk3nWy6o1Kpab61lEln6jqhwLrXHLi6ZvYHibAem30+vKsamrIBH5T235IoKb4u4XzYYCpJFjwijzj6dPki5v3fzU4Rvevvo3Y6YPFiR748jwtGaBICdkNKAmcDP7/YBfyDbsrV0t9NH2NlfCKIlXw3HQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 878d9d75-e326-4f7e-110d-08d6d9b7c4bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 04:34:21.8222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0121
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Sunil Muthuswamy <sunilmut@microsoft.com>
> Sent: Tuesday, May 14, 2019 5:56 PM
> ...
> +static bool hvs_close_lock_held(struct vsock_sock *vsk)
>  {
> ...
> +	schedule_delayed_work(&vsk->close_work, HVS_CLOSE_TIMEOUT);

Reviewed-by: Dexuan Cui <decui@microsoft.com>

The patch looks good to me. Thank you, Sunil!

Next, we're going to remove the "channel->rescind" check in=20
vmbus_hvsock_device_unregister() -- when doing that, IMO we need to
fix a potential race revealed by the schedule_delayed_work() in this
patch:

When hvs_close_timeout() finishes, the "sk" struct has been freed, but
vmbus_onoffer_rescind() -> channel->chn_rescind_callback(), i.e.=20
hvs_close_connection(), may be still running and referencing the "chan"
and "sk" structs (), which should no longer be referenced when=20
hvs_close_timeout() finishes, i.e. "get_per_channel_state(chan)" is no
longer safe. The problem is: currently there is no sync mechanism
between vmbus_onoffer_rescind() and hvs_close_timeout().

The race is a real issue only after we remove the "channel->rescind"
in vmbus_hvsock_device_unregister().

I guess we need to introduce a new single-threaded workqueue in the
vmbus driver, and offload both vmbus_onoffer_rescind() and=20
hvs_close_timeout() onto the new workqueue.

Thanks,
-- Dexuan

