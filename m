Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED3836D54D
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 12:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238877AbhD1KCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 06:02:41 -0400
Received: from mail-mw2nam12on2136.outbound.protection.outlook.com ([40.107.244.136]:26145
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238304AbhD1KCi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 06:02:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bq7IcDff6HAdKbzQJ+Yh2ZLWsv/S9hygT/Mxx21XZuLGOm5XdWGDUyzh1B9SRLECDSNpNFTj2pT7uhqRniRmU03dn5EO/+oB8YhwZxVTJ0gkk+nsyKAYdw0Wc+KDoGxoeum10PIcMsShdd/H/ZekjBp1+Rl++PYZpdtu/e9Qx1LU6i4u5zt7yy4R80m7ejBM4MuXxLHI3ucesWe1HmSRGZzVPgpFGTbqzWDlHAChh1z+mj7Zdm9sWErL1ClkkS7WZn49cGWd8DO+1MqFCL7p4sKhVzpmAtOB0DMi8iJIK+4SrYbE076BZnlQnsxrTW97UZf8+eplP7cARZeA6MsrcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2os6R5SlajLlz/9DSdxumjYGbIrkYWziOKEkGxXsY1w=;
 b=U067dXRGkNsX9J1NH3MszoKoHlIrfrhvdOS5h/fwdMnM+M8UQ5XSvDy/of5xABFRJsyX6ilOXsVs0CIdrj1x60IaRfqj+/jzDxUCqqXM8KB+XmD8pP2wORkZ1JYii7/wWncnaWZtw+Wq3yHuMwV3cgZKe5J0ooaQNlAdL07xCowUbK2A+IMkg4cQS6psTnHaT+fY5wX79OvO/Stztx9/lrArI8ADcksqizPPp5uLzeMEqKgqfgAafLYM8oP/2LXO7drp+LPI2+FhPWRBUV12aRM2nKHT+8kC0pQzg8wYj8sauo/Z6WamUEKZU7bmNWDyvDFXT1Ze75la83eq/2/B8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2os6R5SlajLlz/9DSdxumjYGbIrkYWziOKEkGxXsY1w=;
 b=RdeXTRFIhDHtSHdfO/lS7rcQ9e6AKyAM0eSQ1Q4gIWRkz+drarsTrGJP2BGo58P3nkoN8zWM0BW7oZrtAAPzPkFcJihEKzT+3cJu0sW17ldOO70rwlqMtrNFcQiYbo+JZpyziVbIOenyGqa3n1oVRUXtagOzaefJ96AUyGIXq+0=
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 (2603:10b6:301:33::18) by MWHPR2201MB1456.namprd22.prod.outlook.com
 (2603:10b6:301:32::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Wed, 28 Apr
 2021 10:01:52 +0000
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::141:6464:43a7:d230]) by MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::141:6464:43a7:d230%6]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 10:01:52 +0000
From:   "Liu, Congyu" <liu3101@purdue.edu>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: PROBLEM: potential information leakage in /proc/net/ptype
Thread-Topic: PROBLEM: potential information leakage in /proc/net/ptype
Thread-Index: AQHXPBUz6QTF2lKKc024Iy1Y70EY4g==
Date:   Wed, 28 Apr 2021 10:01:52 +0000
Message-ID: <MWHPR2201MB10722358488A8DA302A988DCD0409@MWHPR2201MB1072.namprd22.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=purdue.edu;
x-originating-ip: [38.94.111.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8a02d2b-023a-45e2-2e11-08d90a2ca5eb
x-ms-traffictypediagnostic: MWHPR2201MB1456:
x-microsoft-antispam-prvs: <MWHPR2201MB145604EE74D8077D6F1690CFD0409@MWHPR2201MB1456.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YnLg98cGCPW2MPA33y9LdBHnBfCHFHf8bOjNuzMZI7PimRjRGv8rxWsH7INSdGBGWKcfQaqAMsyRMQhUtj2I4RrtCOAL66iHDBvvBI2KiUs3QqDnmnZgB4TXhZyyyuzyBC4QcCjrsXfCWG9BhWx+cuBI5e9Zmwf4iXA1u6uIxcTa9vFmWvt9JEHrTloPbMW/uN2w+KBEjhOcaRhZxxxjUdwXvpcAxmsqi2pvNpk4RIfFQLfz4DA/0CVosttSYRjeLgMjx2Pe28Km1B7xaFOeANbv5zIBS6B8lC+422jtKHoSzWqRo6F1KIZOBdXjAYrK1/6W6B9A+V+0fXdLG1/Qx5lAKB8mHHkUhgtDTHsL9WRnBNvXdJGS05hUgmlqkKp254Hh8/3uz4TgDquELagE7Nw+16YA31PebjnkHeGHAz8//bzd2XnY17ys4NAsh3pyxoj5zVJPwJQsL0n10IOcfFbAjWzuzRWZVQNR57O2mguNOQCUhOG7zbdkSyLJPFEzAlX0Ow3GH1mx6Iu5lFuVPuqTCMDb8KJJUe6yeFd7iDzl9+xyaL+PXPtts4tY/IjZRIgvH5u8XlvzQJV/cIHLQYKcdfQhl/p83doIH1U9bqQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR2201MB1072.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(39850400004)(136003)(376002)(186003)(8936002)(83380400001)(4326008)(66946007)(478600001)(6916009)(6506007)(5660300002)(52536014)(54906003)(66446008)(33656002)(9686003)(86362001)(66556008)(26005)(316002)(122000001)(8676002)(38100700002)(76116006)(2906002)(786003)(7696005)(75432002)(71200400001)(64756008)(55016002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?d/vj/KGdae2QYhwv0710aLOhDWwp1sboWO0bfoC8CMN3L9byCKU8f+QF9y?=
 =?iso-8859-1?Q?U5rLQKi2BYQ5mOZpJZ8o7E2qlKtW9wSPb9smYDyOIb/lxf9gXGtX/LNBTt?=
 =?iso-8859-1?Q?Gyg3W6RQTqsR42Ra26Kv06mtsWZldxfJMBckDJe7eqnMfOWOWqiCyiACH4?=
 =?iso-8859-1?Q?RfD6eWZfGqkrhtBJRHxm6HnQJ2R/duygku9BDWgbU/FpXT0yEe8SwbNwXk?=
 =?iso-8859-1?Q?9GoYUJfu/E0rPcu8KQTR8IwExMBTyKSBUE0XLRl5m2mdRb7u1au33G+x58?=
 =?iso-8859-1?Q?OYhetg6NEGkURMnH7I+jo/c9k1W88Nbhy2pyxdJlaM+9xo4sfGgXPR2qS5?=
 =?iso-8859-1?Q?hI5uhYHeU5hOLYMjidO3ufT08ZQdUG5dC4BtvXcYlorG1msV2N3HqmJMDN?=
 =?iso-8859-1?Q?uLtZUKE51lEK5ds5hyoE43WIvmez7VbyJJlakVWM4Snqus+K4K0ctBNEPH?=
 =?iso-8859-1?Q?7cc1YpOoRnL0aEcyTkFapYVF3nToLCV1XqJk/wNuRMHxS68S8wBwTRaOWd?=
 =?iso-8859-1?Q?flhEbJON2VJxamhKNBfQ3Dyoevj7Hju3HTgssIzUHAGUgulgVH7+6DFz77?=
 =?iso-8859-1?Q?5mg3SCwrMjqRHXfNr2RjOZiP8//CkxvhfbSzQ45k40KPvGYqqwXFzZ/6FS?=
 =?iso-8859-1?Q?Wdo2JbYJE/iyy730YZ0owZMq95abqc7udcA2abW2h1vU3grWaNdF9zcodP?=
 =?iso-8859-1?Q?I3WhEwuNW5toF6FaTLWD4q7D4AzzCcM1pkCJoCfOLtDqif5rM5+5yU+tVo?=
 =?iso-8859-1?Q?i6uR5AYqIIACVx82nS98AFdEOb4mvJw/8lztdc3tzVAY5BF9yOBKyUg7Cf?=
 =?iso-8859-1?Q?B5fcR16Upyu4jTGCXcWwMXZEc+i5B2jAZNByUR3Shkz7hYLYSuXGy4BZub?=
 =?iso-8859-1?Q?nzBooUxvtvCY35+biuLnVSiS5CrXwYA7WQranr7hf2WQw9Qonv8rj6rbBD?=
 =?iso-8859-1?Q?tAoDQLlUhMSRWxPOVjEJqYkUwF3D+y1jQ37qPQIeODL+tlVXecPB+GL+wj?=
 =?iso-8859-1?Q?CRnNEYaLvOlFJDOmalKX48bcxWqEBlvnP6lcs6F5gMTI2XaqldudTui3Z6?=
 =?iso-8859-1?Q?2+6TMyhHZqJ9/Mh1MODw4sMpN+hjdac+I1IZ0L6ONVhWwWJSGMrfbQJiKP?=
 =?iso-8859-1?Q?98ImLcE6ONlECFmva7UzQO8hcs0kfftCh/aFtCqlud1o16isnxcJXyTOdr?=
 =?iso-8859-1?Q?Z8kG/ev2PptRNoalzA9djT+bJ/omffD0sNyyCiIOC/Rnw/RnJ76P6tOp5z?=
 =?iso-8859-1?Q?joA5dE6C8z7Kw7TS08U1xo9dU09lv4YTrry7gijUfyEW/UkLH750M7UWrh?=
 =?iso-8859-1?Q?vSC9XSZtHbRVJ5nJSKdIrh/i2dughFzdvcKu1nkKfAF0Nws=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR2201MB1072.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8a02d2b-023a-45e2-2e11-08d90a2ca5eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2021 10:01:52.6488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E+fy/tBzTyGp2gU/no2maCdGQaWSElJ3KPWH7p623oo8bFWldLO0LLeA12XVkPX71EAv5VgXPnFBUzq/nmMahg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1456
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,=0A=
=0A=
When a process in network namespace A creates a packet socket without bindi=
ng to any interface, a process in network namespace B can observe the a `pa=
cket_rcv` entry being registered by reading /proc/net/ptype, thus it can in=
fer information about the processes in namespace A.=0A=
=0A=
By looking at the code, it looks like hook function `packet_rcv` is namespa=
ce aware and only works in one net namespace: it only intercepts packets fr=
om the devices inside the network namespace where the packet socket is crea=
ted. However, the `packet_recv` ptype entry can be seen in all namespaces v=
ia /proc/net/ptype. Though minor, this looks like an information leakage.=
=0A=
=0A=
/proc/net/ptype seems to be the root cause: it does not filter those ptype =
entries that do not bind to any interface. But I have also noticed that the=
re were efforts to prevent /proc/net/ptype from leaking net namespace infor=
mation, e.g. commit 2feb27d. So I am wondering if this problem is an inform=
ation leakage bug or deliberate by design? If the latter, what is the reaso=
ning for this?=0A=
=0A=
Thanks for your time and patience!=0A=
=0A=
=0A=
Thanks,=0A=
Congyu Liu=0A=
=0A=
=0A=
Code:=0A=
#define _GNU_SOURCE=0A=
#include <sched.h>=0A=
#include <sys/wait.h>=0A=
#include <stdio.h>=0A=
#include <stdlib.h>=0A=
#include <string.h>=0A=
#include <unistd.h>=0A=
#include <errno.h>=0A=
#include <sys/socket.h>=0A=
#define errExit(msg)=A0=A0=A0 do { perror(msg); exit(EXIT_FAILURE); \=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 } while (0)=0A=
int main() {=0A=
=A0=A0=A0 char x;=0A=
=A0=A0=A0 int pipe_fd[2];=0A=
=A0=A0=A0 if (pipe(pipe_fd) < 0) {=0A=
=A0=A0=A0=A0=A0=A0=A0 errExit("pipe");=0A=
=A0=A0=A0 }=0A=
=A0=A0=A0 int pid =3D fork();=0A=
=A0=A0=A0 if (pid < 0) {=0A=
=A0=A0=A0=A0=A0=A0=A0 errExit("fork");=0A=
=A0=A0=A0 }=0A=
=A0=A0=A0 if (pid =3D=3D 0) {=0A=
=A0=A0=A0=A0=A0=A0=A0 close(pipe_fd[1]);=0A=
=A0=A0=A0=A0=A0=A0=A0 unshare(CLONE_NEWNET);=0A=
=A0=A0=A0=A0=A0=A0=A0 if (read(pipe_fd[0], &x, 1) < 0) {=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 errExit("read d");=0A=
=A0=A0=A0=A0=A0=A0=A0 }=0A=
=A0=A0=A0=A0=A0=A0=A0 system("cat /proc/net/ptype");=0A=
=A0=A0=A0=A0=A0=A0=A0 return 0;=0A=
=A0=A0=A0 }=0A=
=A0=A0=A0 close(pipe_fd[0]);=0A=
=A0=A0=A0 unshare(CLONE_NEWNET);=0A=
=A0=A0=A0 socket(AF_PACKET, SOCK_RAW, 768);=0A=
=A0=A0=A0 if (write(pipe_fd[1], &x, 1) < 0) {=0A=
=A0=A0=A0=A0=A0=A0=A0 errExit("write");=0A=
=A0=A0=A0 }=0A=
=A0=A0=A0 wait(NULL);=0A=
=A0=A0=A0 return 0;=0A=
}=
