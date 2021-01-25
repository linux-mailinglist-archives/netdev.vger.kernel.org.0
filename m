Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88403030A8
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732061AbhAYX4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:56:43 -0500
Received: from mail-mw2nam12on2110.outbound.protection.outlook.com ([40.107.244.110]:46752
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729824AbhAYToY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 14:44:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRv/3eMG5ruI8quozWsgxTKlE/VWeuYG8YraLJ/ujogwIiAwoXvJCh1ErIoGVDe9qITegUi6VFOlcANNycEE8V9Of0tJVsVOPqU65GrIPZau8fbbOA1mfPXMaI0vLuSGEpEiV5q1qG5AMoqN3SDHTr08OaJn62BfGtzoUuRldqNczud9y90ZG/Tje84dIV+FB8MihHxJW6CtIu5WiCowP10VFBVXe2E6Kcrjy5E65ynJGZYF8KVvX682xUKCUC2tU/n4MS7n4fX8kWdUUzenE7RB6yO80/JpKEcJlFmPg5fuVvepZsCKCvIcuNXM2jpiyahdybD1Fx3/usebFGEYPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5P1az5BWegqPMVtv5qVUTNAJ6pc3BJhA7JVpN8GeHug=;
 b=h7bLRyONTJnbc8EFePqDsibleqpVo059XxA43yIa7/9Oo/+zsC62+Dqk0W12p47CFojeBO9aAGZtR4F5t08UvV7Qa59bcadcGuxmAY7Qbm+ViI0a3/Ac0M8/zmY6YBtV0L91H2PQKLnQLfIlq4sBHzxL0Fmz30oaFQd0I2HBNjHEXrjY95Z9sfxEfzpOOBbIATK9H7Dc5AutNjyLqlp4KWRcxR5zfo8ZOR1kAwH3khchlF5pCQj/RraPI51ifXCbCCW+rfy4nEic6IlfwCZQj3Cb1LxNv14iruNMbCY1PRD8e8uObNeGB8f+hyFTFaBkAKyJRJBbxyLF53kla0c8yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5P1az5BWegqPMVtv5qVUTNAJ6pc3BJhA7JVpN8GeHug=;
 b=SK+2WMePyNJniGerUMNpNP6r33tC0IKxddolhV9I1vB+WfqK8iVAkHmnj4vb3dvSpPS6VdI7kSpVNh8kQNsiFcmQdiaWPDaizggTx7aNXbHhv0iq5hHcuYOI9RFkCcktjzRCgX0kkimXtJQ3LLlyP8XJMP8f84Jjsvuxs69Q9QM=
Received: from CH2PR22MB2056.namprd22.prod.outlook.com (2603:10b6:610:5d::11)
 by CH2PR22MB2039.namprd22.prod.outlook.com (2603:10b6:610:5e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Mon, 25 Jan
 2021 19:43:35 +0000
Received: from CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::4030:a132:aaff:aaa9]) by CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::4030:a132:aaff:aaa9%7]) with mapi id 15.20.3784.019; Mon, 25 Jan 2021
 19:43:35 +0000
From:   "Gong, Sishuai" <sishuai@purdue.edu>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [Patch net] net: fix dev_ifsioc_locked() race condition
Thread-Topic: [Patch net] net: fix dev_ifsioc_locked() race condition
Thread-Index: AQHW8fCRMayXT0fa9U23ivcoEX9YDao4wNuA
Date:   Mon, 25 Jan 2021 19:43:35 +0000
Message-ID: <261CE3E8-20D1-47E8-98B9-AC685A32C3E1@purdue.edu>
References: <20210124013049.132571-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210124013049.132571-1-xiyou.wangcong@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=purdue.edu;
x-originating-ip: [66.253.158.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26dd1237-1d76-4b58-f724-08d8c169812a
x-ms-traffictypediagnostic: CH2PR22MB2039:
x-microsoft-antispam-prvs: <CH2PR22MB2039F6332A33FD0724465778DFBD9@CH2PR22MB2039.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7S2XZDnfJP0EoVz5dMbgVLj7MWkgfV9DvHRzadXah/S/J/qKTDwcTrIUxT2wAXv5wVyoFfhippl0jskaOKuC5RTiNtJR7cANcXai66nZu/CUso96vsGU24RdBfPB1nlpt1FRBybYBrldB3c9sor15swpz2uSIpxZ6+HVhztkgzPJ1R1mTb2LI+YJhla+Y076JqgOKBF6UCR02ucAe8HhzBNFV56f+zTO6+aiYpuMyIBTbe3gpv/TSci7cUI4UMtwAdGqVk4lwm5of3wk5vQG6/yY/2RmXLN4VOoucy2MxsIknGIAa4qHE1aZ8xipHVW7/MbdX03EHuq6Hl9ruEK+xyxEm+73kpLR0PW601gHAFbNtRZt/NyjGx3QXo00RX/1hSgPu2XY4PywhnpG880ZJnjlIkSS81xGpJEnVgWp/V4wgisTjEEMLLmQJwzkf87mXhTINjPoh22lO0AxilnMJ8v/aRaQeZ6du4yroXdXsxObPl/1MX9Wuj3+gVz9nhZgtbzJPsOvJmAouatcPXWkCSE8v+WXBc29n6fmG/+JOyKxhU8Ft3YMrVtsi+IJRiF7k45YPc2QY2lN92/m344XWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR22MB2056.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(376002)(366004)(346002)(66946007)(64756008)(66556008)(66476007)(76116006)(66446008)(478600001)(36756003)(8676002)(54906003)(8936002)(26005)(2906002)(83380400001)(6486002)(4326008)(5660300002)(316002)(786003)(6512007)(2616005)(86362001)(71200400001)(75432002)(53546011)(6506007)(33656002)(6916009)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ngYhQLsA1gTXKs5Si+YHGTdI4NyuqxuwJHAzHvgg9RFqmMMrnRqOULYye4Sl?=
 =?us-ascii?Q?qDrFKjf6Uo0WQs+ZtrlqWdVbv02fPyKENf1D5Fa7qTqv/swackTSe48lz29J?=
 =?us-ascii?Q?skHF0DrZQXBw7jP5SAFbU2uf9oCo3EfvKDOsi3WjwXqlI8iLLUnFQSZwf5BD?=
 =?us-ascii?Q?tyhY3G87IRVxXSkTCAuy6stqeM8YbBl1/2SC761CknIUVauYvm/2IYLn9mg5?=
 =?us-ascii?Q?EfRCvDE1EIP8DgEkMPNm1jpukDecHrArzn3KwUlbat20P3/uTMAHkWieVbRk?=
 =?us-ascii?Q?hqmNaH/AUIqqkVUOAjBbJNQom4P7oxYjtcLrMKyCZCh5hFxg/MYSQQEHV4Fy?=
 =?us-ascii?Q?hahKoonBjUfpFPUh6dgHYvuOnKpz6bAF/3KoUmAVxPkeUh7PI/JIUdj+bFfo?=
 =?us-ascii?Q?VKNNElWaFJ50g+k8TOFsuse5Ui+bAsNFh0pXQMXPorsU5EaRMxApxRzcoH1u?=
 =?us-ascii?Q?FU4OzxW8ekCTvcklacv3bfH2Nc6305S4E6U12jdmSRmiuJHTnLGgAzAWFgwL?=
 =?us-ascii?Q?LzA5PvuP5L2ddAu3fK+D28sM0SgOScYVaUI5Z55lcz8t5u98jNUJOf3rgXBs?=
 =?us-ascii?Q?xumQ7jHFfQssBr099rbdsmG7pM946L1eQmsvF6x68tnYH0y5zDP1UQOpbkdF?=
 =?us-ascii?Q?r8C+h0/CUdH/5FirCTglYOQGI84ko2SF2gKZC/hJfpITh6lewVpvO57s5EbU?=
 =?us-ascii?Q?7CgaxTMMgVhZPrbM5krbqA9djP5w/Z+llonk/QSPZbbczVZkKMvkVX5iiOLU?=
 =?us-ascii?Q?5Gyg7J6uMHMJ6DPyl6ikPx4iY0TGRBnlaiKtsO5ZjSnWlR70iIvAD1UZrnB9?=
 =?us-ascii?Q?tU9eBzSSpeh7IvpUyA2CNJ5c6BFYUpumw423YVtZPenKw3zwa3Fq3l4BR93Y?=
 =?us-ascii?Q?xGGs82F4NSxFSmNnDhX8ADFxri928lU2HIk22kaSIUl7+VyQXAVyrqT7o9fA?=
 =?us-ascii?Q?mdP4wVFTMslVTpbfoa6pQyOeSJhRlklclW3npKrMUQ6ObQZoR4RYNcnFTgar?=
 =?us-ascii?Q?+nVgy4Bg5BL9G6C15YqoOx0tRoXdRmIgEUKCZ/22hYRxIvVSBOjAue6ZdbdH?=
 =?us-ascii?Q?GqsCCKGNZkLAPYL9gAx89vZY0eaJng=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1A90CE5E1E8E1843BB4F14D9A1E34DE0@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR22MB2056.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26dd1237-1d76-4b58-f724-08d8c169812a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 19:43:35.3956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: elfiISBiuSk9D9aBVY0pqm8U3IsZ1LcTY4t66RmwIFOgJiOwebOXbA2azkoe90m9mQXR08DSrGWqvnZRNj+qgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR22MB2039
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We also found another pair of writer and reader that may suffer the same pr=
oblem.

A data race may also happen on the variable netdev->dev_addr when functions=
 e1000_set_mac() and packet_getname() run in parallel, eventually it could =
return a partially updated MAC address to the user, as shown below:

Thread 1								Thread 2
									// packet_getname()
									memcpy(sll->sll_addr, dev->dev_addr, dev->addr_len);
//e1000_set_mac()
memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);

And the calling stacks are:

Writer calling trace
- __sys_sendmsg
-- ___sys_sendmsg
--- sock_sendmsg
---- netlink_unicast
----- netlink_rcv_skb=20
------ __rtnl_newlink
------- do_setlink
-------- dev_set_mac_address

Reader calling trace
- __sys_getsockname

Since e1000_set_mac() is also called by dev_set_mac_address(), the writer c=
an be protected already with this patch. The reader, however, needs to grab=
 the same semaphore to close the race condition.


Thanks,
Sishuai

> On Jan 23, 2021, at 8:30 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>=20
> From: Cong Wang <cong.wang@bytedance.com>
>=20
> dev_ifsioc_locked() is called with only RCU read lock, so when
> there is a parallel writer changing the mac address, it could
> get a partially updated mac address, as shown below:
>=20
> Thread 1			Thread 2
> // eth_commit_mac_addr_change()
> memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
> 				// dev_ifsioc_locked()
> 				memcpy(ifr->ifr_hwaddr.sa_data,
> 					dev->dev_addr,...);
>=20
> Close this race condition by guarding them with a RW semaphore,
> like netdev_get_name(). The writers take RTNL anyway, so this
> will not affect the slow path.
>=20
> Fixes: 3710becf8a58 ("net: RCU locking for simple ioctl()")
> Reported-by: "Gong, Sishuai" <sishuai@purdue.edu>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
> include/linux/netdevice.h |  1 +
> net/core/dev.c            | 39 ++++++++++++++++++++++++++++++++++++---
> net/core/dev_ioctl.c      | 18 ++++++------------
> 3 files changed, 43 insertions(+), 15 deletions(-)
>=20
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 259be67644e3..7a871f2dcc03 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3918,6 +3918,7 @@ int dev_pre_changeaddr_notify(struct net_device *de=
v, const char *addr,
> 			      struct netlink_ext_ack *extack);
> int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa,
> 			struct netlink_ext_ack *extack);
> +int dev_get_mac_address(struct sockaddr *sa, struct net *net, char *dev_=
name);
> int dev_change_carrier(struct net_device *, bool new_carrier);
> int dev_get_phys_port_id(struct net_device *dev,
> 			 struct netdev_phys_item_id *ppid);
> diff --git a/net/core/dev.c b/net/core/dev.c
> index a979b86dbacd..55c0db7704c7 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8709,6 +8709,8 @@ int dev_pre_changeaddr_notify(struct net_device *de=
v, const char *addr,
> }
> EXPORT_SYMBOL(dev_pre_changeaddr_notify);
>=20
> +static DECLARE_RWSEM(dev_addr_sem);
> +
> /**
>  *	dev_set_mac_address - Change Media Access Control Address
>  *	@dev: device
> @@ -8729,19 +8731,50 @@ int dev_set_mac_address(struct net_device *dev, s=
truct sockaddr *sa,
> 		return -EINVAL;
> 	if (!netif_device_present(dev))
> 		return -ENODEV;
> +
> +	down_write(&dev_addr_sem);
> 	err =3D dev_pre_changeaddr_notify(dev, sa->sa_data, extack);
> 	if (err)
> -		return err;
> +		goto out;
> 	err =3D ops->ndo_set_mac_address(dev, sa);
> 	if (err)
> -		return err;
> +		goto out;
> 	dev->addr_assign_type =3D NET_ADDR_SET;
> 	call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
> 	add_device_randomness(dev->dev_addr, dev->addr_len);
> -	return 0;
> +out:
> +	up_write(&dev_addr_sem);
> +	return err;
> }
> EXPORT_SYMBOL(dev_set_mac_address);
>=20
> +int dev_get_mac_address(struct sockaddr *sa, struct net *net, char *dev_=
name)
> +{
> +	size_t size =3D sizeof(sa->sa_data);
> +	struct net_device *dev;
> +	int ret =3D 0;
> +
> +	down_read(&dev_addr_sem);
> +	rcu_read_lock();
> +
> +	dev =3D dev_get_by_name_rcu(net, dev_name);
> +	if (!dev) {
> +		ret =3D -ENODEV;
> +		goto unlock;
> +	}
> +	if (!dev->addr_len)
> +		memset(sa->sa_data, 0, size);
> +	else
> +		memcpy(sa->sa_data, dev->dev_addr,
> +		       min_t(size_t, size, dev->addr_len));
> +	sa->sa_family =3D dev->type;
> +
> +unlock:
> +	rcu_read_unlock();
> +	up_read(&dev_addr_sem);
> +	return ret;
> +}
> +
> /**
>  *	dev_change_carrier - Change device carrier
>  *	@dev: device
> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> index db8a0ff86f36..bfa0dbd3d36f 100644
> --- a/net/core/dev_ioctl.c
> +++ b/net/core/dev_ioctl.c
> @@ -123,17 +123,6 @@ static int dev_ifsioc_locked(struct net *net, struct=
 ifreq *ifr, unsigned int cm
> 		ifr->ifr_mtu =3D dev->mtu;
> 		return 0;
>=20
> -	case SIOCGIFHWADDR:
> -		if (!dev->addr_len)
> -			memset(ifr->ifr_hwaddr.sa_data, 0,
> -			       sizeof(ifr->ifr_hwaddr.sa_data));
> -		else
> -			memcpy(ifr->ifr_hwaddr.sa_data, dev->dev_addr,
> -			       min(sizeof(ifr->ifr_hwaddr.sa_data),
> -				   (size_t)dev->addr_len));
> -		ifr->ifr_hwaddr.sa_family =3D dev->type;
> -		return 0;
> -
> 	case SIOCGIFSLAVE:
> 		err =3D -EINVAL;
> 		break;
> @@ -418,6 +407,12 @@ int dev_ioctl(struct net *net, unsigned int cmd, str=
uct ifreq *ifr, bool *need_c
> 	 */
>=20
> 	switch (cmd) {
> +	case SIOCGIFHWADDR:
> +		dev_load(net, ifr->ifr_name);
> +		ret =3D dev_get_mac_address(&ifr->ifr_hwaddr, net, ifr->ifr_name);
> +		if (colon)
> +			*colon =3D ':';
> +		return ret;
> 	/*
> 	 *	These ioctl calls:
> 	 *	- can be done by all.
> @@ -427,7 +422,6 @@ int dev_ioctl(struct net *net, unsigned int cmd, stru=
ct ifreq *ifr, bool *need_c
> 	case SIOCGIFFLAGS:
> 	case SIOCGIFMETRIC:
> 	case SIOCGIFMTU:
> -	case SIOCGIFHWADDR:
> 	case SIOCGIFSLAVE:
> 	case SIOCGIFMAP:
> 	case SIOCGIFINDEX:
> --=20
> 2.25.1
>=20

