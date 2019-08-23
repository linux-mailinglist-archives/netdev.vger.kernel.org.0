Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0192B9AD0C
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 12:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391240AbfHWKZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 06:25:13 -0400
Received: from mail-eopbgr80072.outbound.protection.outlook.com ([40.107.8.72]:46918
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728961AbfHWKZM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 06:25:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJECFjW3MqeAOr+tDYyJT2j4SdHnUFr9F4IViQl+M4oJibFdtZCgABj3vNDAZ+YQhtOckxha9ZrkcxV0rBy/kCxdjzKMM3167AU6haovdA3uywLKkaRKvEzFaQHPGWRi9gstCw0CMv2x25B96Ld9SxEECwGijxaN5Tif9q5y1/zhBxm5ZUjjza4xIsDbikYlde0IQAQ/I9SaiuQhiWYkK5RuQB+zXyQtjHGNrI0U+/4QTNS9leTT2d3lp3JhEIr8HXq4EQC+vRjq5EtjY+rRyFJ6fVXH53n+FptHA9VjSfN9iKAMUas8EKlA2Ag8JxJUMikVtH2yI+CXqwY6Iia8Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z8R81ixE4c0mmu6vceUwiJ/yUccphP7x0OoawOdpyxc=;
 b=MqzewjqGP4dZuoS/GbigeYN2TUmuDDBVvnJQmFqzPEhbCNeIcRzCEleuPs8bn2Arf0CkG/9TVLQCXlqqbA83TK0jXySFNQHtwEtMVIspOdDyItclVo2XlHLZwGzgfqrudSfnq3mza+VTn4/lLhzaFyIQQK8KvjUp4mMk7JQh5zc8sF4NKH68xPXAoShb3f8x1N/c02DLNqrPW4lXppZEkyhLRdCLZtRE3pJWllaKQznWIsVZVfKYHX1MDEkh/TfWyWyzllxm33T8K5NdnhJOGqsJ7mfCV67qGG76ZLi9EJ2RtqCdZ0PkVfnWX8e+RTdhzSkSmIaFQ4tvHaCXs9QSUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z8R81ixE4c0mmu6vceUwiJ/yUccphP7x0OoawOdpyxc=;
 b=PbJfd+21Aq86JgnJ7LB4MB5i+/l6OS63dC2xZZgk5iAeGQIoLNFzEcL1mpI7XiCr69wgA2bhEAfuraoZ4MR6jlkv2WpEEiYhgSJVvuTE+/G7oFtPJRYxe+umMr33N21C0+w60icqSRIyudgUpLOMlJBLNhb7h4rC2j5ZPWs/+uI=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB3472.eurprd05.prod.outlook.com (10.170.239.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Fri, 23 Aug 2019 10:25:08 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae%7]) with mapi id 15.20.2178.020; Fri, 23 Aug 2019
 10:25:08 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next 01/10] net: sched: protect block offload-related
 fields with rw_semaphore
Thread-Topic: [PATCH net-next 01/10] net: sched: protect block offload-related
 fields with rw_semaphore
Thread-Index: AQHVWOdSZkurdxVtyke2BgFbRyY7Y6cHvGgAgADL1wA=
Date:   Fri, 23 Aug 2019 10:25:08 +0000
Message-ID: <vbfh86818n3.fsf@mellanox.com>
References: <20190822124353.16902-1-vladbu@mellanox.com>
 <20190822124353.16902-2-vladbu@mellanox.com>
 <20190822151530.09f7ca04@cakuba.netronome.com>
In-Reply-To: <20190822151530.09f7ca04@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0277.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::25) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42732393-2c57-4639-c456-08d727b42bfa
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB3472;
x-ms-traffictypediagnostic: VI1PR05MB3472:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3472827EB8D5A5946B94CCF2ADA40@VI1PR05MB3472.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0138CD935C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(346002)(39860400002)(136003)(189003)(199004)(102836004)(52116002)(71190400001)(71200400001)(36756003)(14454004)(53936002)(486006)(305945005)(99286004)(86362001)(5660300002)(107886003)(446003)(11346002)(6246003)(76176011)(3846002)(7736002)(6506007)(25786009)(26005)(229853002)(4326008)(4744005)(478600001)(316002)(8936002)(256004)(2906002)(186003)(54906003)(6486002)(386003)(6512007)(81156014)(81166006)(8676002)(14444005)(66066001)(66476007)(476003)(2616005)(6916009)(6436002)(64756008)(66946007)(66556008)(66446008)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3472;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DVZQoJtcrCxjTGNaY2Kqyjn1gelsDc02mgFhib2ofQf+F4h3FHCqRkP5Ztlmiv8k88jjtTRQ+k/wgeEbsEjVs/hK4AaH1OItqQXFMfvi838dDkAmJup9KQtgTseav3EuUlWmjaxw1dJdhB2l3Qw7mz8HMRWxqKbEe8FZtxz4J5wKhTIf1uaZUGaBJJ3IPDk9sjH8cF9DJJzp/PxVqnlM91PvM8oyRqXge9Wqriv5WLRKB5MOVMQl0KBoQxDPaH3ZKPVqFq3SozDpvsZI8LZHL1Sbffh+X7qLsika/BAabmWuQSm2AvAaxL3arwdXSGr4Q45IMRRuHCtLaQs3LvLcYKjKBVLj5kvsldcuQ5Ka5g11X8HtkuzvA+QRuVvK9tHEwWGefMXlbSeKiAtcmi7sAx4A0uoy4/sVZVggbLMF8/Q=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42732393-2c57-4639-c456-08d727b42bfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2019 10:25:08.3644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6XdexCqNei9mrBXiMcbf8GahfzfSHFzOrsiaQmCubRW+PxpGHFMYOZ3I7ttRpu05dxOzuvR+5tB5QHyDBl2UfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3472
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 23 Aug 2019 at 01:15, Jakub Kicinski <jakub.kicinski@netronome.com> =
wrote:
> On Thu, 22 Aug 2019 15:43:44 +0300, Vlad Buslov wrote:
>> @@ -2987,19 +3007,26 @@ int tc_setup_cb_call(struct tcf_block *block, en=
um tc_setup_type type,
>>  	int ok_count =3D 0;
>>  	int err;
>> =20
>> +	down_read(&block->cb_lock);
>>  	/* Make sure all netdevs sharing this block are offload-capable. */
>> -	if (block->nooffloaddevcnt && err_stop)
>> -		return -EOPNOTSUPP;
>> +	if (block->nooffloaddevcnt && err_stop) {
>> +		ok_count =3D -EOPNOTSUPP;
>> +		goto errout;
>> +	}
>> =20
>>  	list_for_each_entry(block_cb, &block->flow_block.cb_list, list) {
>>  		err =3D block_cb->cb(type, type_data, block_cb->cb_priv);
>>  		if (err) {
>> -			if (err_stop)
>> -				return err;
>> +			if (err_stop) {
>> +				ok_count =3D err;
>> +				goto errout;
>> +			}
>>  		} else {
>>  			ok_count++;
>>  		}
>>  	}
>> +errout:
>
> Please name the labels with the first action they perform. Here:
>
> err_unlock:

Thanks for reviewing. Will fix in V2.

>
>> +	up_read(&block->cb_lock);
>>  	return ok_count;

