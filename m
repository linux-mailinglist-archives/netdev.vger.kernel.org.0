Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C27D6BA72F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 06:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjCOFf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 01:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjCOFfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 01:35:55 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2107.outbound.protection.outlook.com [40.107.212.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C2512F32
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 22:35:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LunCZJvIG0cvinWkc58gSDmZ94OqyuNhbdqnGKrnZ8MQq1ZfBYKfGeI4qu1XT/cANdhbt/5dK/C3ipntE0PATnS0QnxGmPo5IH1VfFHfErz7azREXMW8V93Mar+g3bINIodFCDVzOhx3cWxiPIfwUO0j4ZeMW4AnEXRZa/4ocSl2q14q6YgxNv/ImJb7y6S6zi6W7hjETzdCBFbC08k/U+7kxk6wnJAXBFEjpUkYHdZwZ63P7eem8EWvqn1QWHQFsCnP72tm0gB2iRkj44fLtbkbMAfSs1E9yXRh3KTs0manEl60O0KULqHZ+oUHoJiETBNHcjHZZLazIBdaTV1T1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=56Ai/pHb7GXS/BwJP9aJNbJ3BXx4/1jlI10YBtDYcTg=;
 b=Nu7OvrcbxbUfkQF5C1X88/1g1WopdcXBJ59Ug1crDItZQEhVkLXBKd+OgNzsquC3V4UJpynXTORiZlkzL+Mnubl1qtG8OHyQ0Qn/+lu4jW768aLdL8izsvNvOBmEHLy1iq1wo06X6sYKCyVVEACvh6tVR6PAu5clgNxah++FpHqZdvR/JUUAEcZGOzMojT1erdNo5BaHMvSnFv5NN9PJv1sAFGQq7I2uCY0R8IMSpGDRLZX2B34FzgRco322Ycfg8j0qNSB5YXx9jy06Aw5qao+5Xzmb7h0Nhhh+QRhxbE/OuM2D//1MPNN3LQOEkTpBgCx4ljCqC1F5w7Uguzni5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=viavisolutions.com; dmarc=pass action=none
 header.from=viavisolutions.com; dkim=pass header.d=viavisolutions.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=viavisolutions.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56Ai/pHb7GXS/BwJP9aJNbJ3BXx4/1jlI10YBtDYcTg=;
 b=TdBhm8HG+YdhDOS1Vbo2B2Tkwy496rt3GyMWChvlHuwbmr2ONj/mVxJkLK8Y8rtC/lLiK4+2H4U7NTnB87M6Ey96OtjhtF05qdROLv4LCNZiRBT0u4P1IdGWHOocrQW6zRP5p7Djau9Nw3u144UOl0dVTjw1DcHbiZVSahDv/80=
Received: from BYAPR18MB2408.namprd18.prod.outlook.com (2603:10b6:a03:12f::25)
 by SA1PR18MB4550.namprd18.prod.outlook.com (2603:10b6:806:1e1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 05:35:41 +0000
Received: from BYAPR18MB2408.namprd18.prod.outlook.com
 ([fe80::3fa3:cae6:9902:f3fd]) by BYAPR18MB2408.namprd18.prod.outlook.com
 ([fe80::3fa3:cae6:9902:f3fd%7]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 05:35:40 +0000
From:   Yan Jiang <Yan.Jiang@viavisolutions.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: ioctl SIOCSHWTSTAMP failed on a vlan interface within non-default
 network namespace
Thread-Topic: ioctl SIOCSHWTSTAMP failed on a vlan interface within
 non-default network namespace
Thread-Index: AdlW7/xY1BZDY46HTaO/4dIhxdKfxA==
Date:   Wed, 15 Mar 2023 05:35:40 +0000
Message-ID: <BYAPR18MB240835B708FA3A5B489656738DBF9@BYAPR18MB2408.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=viavisolutions.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR18MB2408:EE_|SA1PR18MB4550:EE_
x-ms-office365-filtering-correlation-id: a5c4a9cf-acf4-4a8c-03bd-08db25171cef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6zi5wNXFJ5gawUI+wLggsXzxw/Z0H3uMPKl+BlA9oEXqFUSkf2++eGLs6Sk1/u/qHG5lPYys74Iok0XVSj81bRKbiOKgtkq2pLRsERBEeBh9PvcfDIw7g82V/ueQZ6Yi+xeHJgDykE1WAUuDBfvev8TngCWdd3yPX4mZ+MwyY4sYvoWAwr+gO8F+ygJ1T8OH64MM3BgHc2PdDczOjECrbO33Uo8w+FGdfJZ4BYxcRWSrXnQAk+hQLJRQf229aPg0jYsfmJti7uUTYWXXkyPmTDX17aR4gIn6+UNJYyEnmBgeCh8QP3QimQs50ccIWkHsmW72os78P8lIYMEI02bZw8JtnaSan7ioSotSSD5Juv3NsnuiGX3ycsct8s7PjdVsgrN7bR456IGAyH9yRVawXF+GA4toRVsWUJ1/TI3GInqsUDJep6vQ9NG99j/K1INhfAG4/t3Chc6nSaKQuuaQgWv0/oH/b7G4K/4HUuvIorm9zTlmvW6uzQcUb9q6Pk2keQpUIgliMaxzjnOuTF5R2VEgTSDaxjcEWEWFaSHAA4EdAZUe5O11vUanKnIu3JKvYnGHacGDmCSm5IvJENE3VOj6+a+oDXtIl3Tf2Wuc36OvkIRs3lLKYrZZsJxDZbyriSUih47MkBR/8JPnJgZ2BlOGmMKmbhdjVXDHOHjgm8ZMAfqicTNKzd2fc3HQN5fevuWS/zdBrGnw9tTdlAQifg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2408.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199018)(122000001)(38100700002)(66446008)(64756008)(76116006)(4326008)(41300700001)(38070700005)(316002)(66476007)(83380400001)(19627235002)(110136005)(66946007)(66556008)(8676002)(52536014)(8936002)(5660300002)(71200400001)(7696005)(478600001)(86362001)(6506007)(9686003)(26005)(55016003)(2906002)(186003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GY54D4ZqVBzLoSPG9GVPvnMB7r/9NoSeflISlGoGivh4J5Im/2QZt8cBlAnM?=
 =?us-ascii?Q?uJiB9Ti0O4QCVfNdSCQQEkUTJaWSkLsgY4ZMBeQS9uG8Osj4SDmHH7iELWMR?=
 =?us-ascii?Q?jYpOmgCEoUCXqksAdhIb0qLw32hKRewP8NQCYVFVtWL2bA3xxyUHLMfnhX2s?=
 =?us-ascii?Q?pvAx9uX8TQYIx0z9iKa+gJhrKq9OBbvNgSLdDf9/IiGQ6Gne8DvcUYwyngnB?=
 =?us-ascii?Q?ocpYY47MjCrWqyqLB7zeIUwq/Xr2QaPj4HHGTc79aLwWSzQgc4xmNLvAQlBu?=
 =?us-ascii?Q?fv2k7S7pUDOxA+GfdZD84tskPPDNROKVeknQ0/ve1B95BHCIm41iVKTcnLfW?=
 =?us-ascii?Q?JOwZ9MxPhZPA2kPQ5Jr7U46jHL8y82kjr214qYIhQ1d6uNNh3stDk0Jua70q?=
 =?us-ascii?Q?k+Kr+R3hmPMc6SZe5KtxB/l7xjevNpoQyEGFrS3ZbVScEc/0ZTOaSGsOrgZe?=
 =?us-ascii?Q?+M5h/I87sU72rVtRKVU6a9VutRzMdwigckL1O3unkOGNGBlODQBoZ5QMHp+G?=
 =?us-ascii?Q?kxes7KYNT1V1EEo9Ikg2GAakoJQNB2+OF3/2BISAxax8uIaZEYXjtGrUNt82?=
 =?us-ascii?Q?E9fsARLeNXYgMorNZGq/RDDroH1yVc9BEWor2NpEWKs/5AEsxkmwbFINY+3N?=
 =?us-ascii?Q?7ezp217k1V6X9IIEIYXLvRs/d8LSS+AP/dW1oixhbGVDiXDuMGlHoyeU7834?=
 =?us-ascii?Q?Nbw0VtJNo6FvnE6L5e41fKehQRKEf02UX5WKbctq9x4JOGk1U99XSAm7eO22?=
 =?us-ascii?Q?xeJEEzqoEO7GbpHSUnb8NbnuR+3/WQaAeh1ScKGZWcuZUWgvABWlCUt7AR8v?=
 =?us-ascii?Q?muGpfKUuywrZFV0VLk1/or1fYS3dQo7e34K34EpQzbEjlDT1+arci6r8IHTr?=
 =?us-ascii?Q?9NnUpWmv/OajSI3PH/NtmqQwpqxhfSjlW9I/Ic9gmYcTibpsvtPVQHpvpRIo?=
 =?us-ascii?Q?sfkhnrRCfszqbT0gpZh9sn/GCSow9JvtcfCQOyi9HiWmMXOrAsLDm49CMAvP?=
 =?us-ascii?Q?bAdNagQTlbdXNJGNK7LsXgLodUJsQ2sR+N55A9JJYnAv53SD8Zuj5RyIfNtf?=
 =?us-ascii?Q?Oepgx5kINSHzu46pbQ3xzXas6Q4x3DxLXce/GMyHwiZeifSoG12w+jAb7Wc3?=
 =?us-ascii?Q?oGd+tFqgRkj0ftLb/axUhjVrmFoAeUVFlA0lhWfg7WZC+s/vs/FHgY8MI9T/?=
 =?us-ascii?Q?nsBQNQSWHW1LfGXlH3/tkWbBPo26v4Me8BjNrTzX8+kffumMWJDXwoDZu6X/?=
 =?us-ascii?Q?T498wUO49VzrNmB28gmdAI6DJ7JEJgVEATHJzZiW+WzAfzUKDh++eIdeWteh?=
 =?us-ascii?Q?YCmdOiJ3syhnAm+x0Ea2+HA/hWwlfpYHqpM6lXunxRiYit6oOAIOqoYrOFYb?=
 =?us-ascii?Q?ekKv3TnsJ+5kaPRO9R+fZCOhh8STVP/giaUPOkXO1bbFaLJTjJ30iODUFAv/?=
 =?us-ascii?Q?K7nVzaJASQKjMbqdmKELvFkV3nySVd0tL0h0TiJ8ihHFpdB2Oy1GD2tgXcf9?=
 =?us-ascii?Q?CbjNYwef41ruoioheCQ2ysJGJTex5NfY5EQ0A3KpTEnv2g0pGB3+b26/mstk?=
 =?us-ascii?Q?yNfA/uHdyGzVz+VaSghfIRWQYuvtJ1HWOnxkaxsZcErDKudYhqsJYpyzRkcI?=
 =?us-ascii?Q?gA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: viavisolutions.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2408.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5c4a9cf-acf4-4a8c-03bd-08db25171cef
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 05:35:40.2333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c44ec86f-d007-4b6c-8795-8ea75e4a6f9b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QYtEoY8rZBQ5S85HcTbogBPGmOQRnB8JpegRK7o+c9nP/yxFGDdjJxv0fkuKVEnAuLJVMWGZubSFjE6Q2gaMWPf6MVkyE0PVzdGLDVuJnBE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR18MB4550
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I'd like to report an issue, which I suspect it's related to kernel network=
 namespace handling.=20
It's my first report so please bear with me if I missed something. Feel fre=
e to ask for more information please.

What's the issue:
Ptp4l works perfectly on a VLAN interface in default network namespace. But=
 it doesn't work if the VLAN interface is in non-default network namespace:=
 ioctl(fd, SIOCSHWTSTAMP, &ifreq) failed due to error "Operation not suppor=
ted".
"ethtool -T" shows that the VLAN interface has all required capabilities. A=
nd ptp4l works fine on the base interface in that network namespace.=20

How to reproduce this issue:
# create a new network namespace for test purpose
root@viavi-PowerEdge-R740:~# ip netns add mytest

# move eno4 into the namespace
root@viavi-PowerEdge-R740:~# ip link set eno4 netns mytest

# add vlan interface and turn interfaces up
root@viavi-PowerEdge-R740:~# ip netns exec mytest ifconfig eno4 up
root@viavi-PowerEdge-R740:~# ip netns exec mytest ip link add link eno4 nam=
e eno4.4000 type vlan id 4000
root@viavi-PowerEdge-R740:~# ip netns exec mytest ifconfig eno4.4000 up

# ptp4l runs ok on eno4
root@viavi-PowerEdge-R740:~# ip netns exec mytest ptp4l -2 -m -i eno4
ptp4l[1670814.457]: selected /dev/ptp1 as PTP clock
ptp4l[1670814.491]: port 1: INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l[1670814.492]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE

#ptp4l cannot run on eno4.4000
root@viavi-PowerEdge-R740:~# ip netns exec mytest ptp4l -2 -m -i eno4.4000
ptp4l[1670819.969]: selected /dev/ptp1 as PTP clock
ptp4l[1670820.003]: driver rejected most general HWTSTAMP filter
ptp4l[1670820.003]: ioctl SIOCSHWTSTAMP failed: Operation not supported
ptp4l[1670820.039]: port 1: INITIALIZING to FAULTY on FAULT_DETECTED (FT_UN=
SPECIFIED)
ptp4l[1670820.039]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE

#ethtool -T shows that eno4.4000 has same capability as eno4:
root@viavi-PowerEdge-R740:~# ip netns exec mytest ethtool -T eno4.4000
Time stamping parameters for eno4.4000:
Capabilities:
        hardware-transmit     (SOF_TIMESTAMPING_TX_HARDWARE)
        software-transmit     (SOF_TIMESTAMPING_TX_SOFTWARE)
        hardware-receive      (SOF_TIMESTAMPING_RX_HARDWARE)
        software-receive      (SOF_TIMESTAMPING_RX_SOFTWARE)
        software-system-clock (SOF_TIMESTAMPING_SOFTWARE)
        hardware-raw-clock    (SOF_TIMESTAMPING_RAW_HARDWARE)
PTP Hardware Clock: 1
Hardware Transmit Timestamp Modes:
        off                   (HWTSTAMP_TX_OFF)
        on                    (HWTSTAMP_TX_ON)
Hardware Receive Filter Modes:
        none                  (HWTSTAMP_FILTER_NONE)
        ptpv1-l4-event        (HWTSTAMP_FILTER_PTP_V1_L4_EVENT)
        ptpv2-l4-event        (HWTSTAMP_FILTER_PTP_V2_L4_EVENT)
        ptpv2-l2-event        (HWTSTAMP_FILTER_PTP_V2_L2_EVENT)

#OS/kernel version
root@viavi-PowerEdge-R740:~# uname -a
Linux viavi-PowerEdge-R740 5.15.0-60-generic #66~20.04.1-Ubuntu SMP Wed Jan=
 25 09:41:30 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux

#driver info:=20
root@viavi-PowerEdge-R740:~# ip netns exec mytest ethtool -i eno4
driver: tg3
version: 5.15.0-60-generic
firmware-version: FFV21.40.21 bc 5720-v1.39
expansion-rom-version:
bus-info: 0000:01:00.1
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: no
root@viavi-PowerEdge-R740:~# ip netns exec mytest ethtool -i eno4.4000
driver: 802.1Q VLAN Support
version: 1.8
firmware-version: N/A
expansion-rom-version:
bus-info:
supports-statistics: no
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no

#(PS: can reproduce same issue with a Mellanox NIC, so I guess it's not cau=
sed by a specific NIC model)

Could you kindly take a look at this and see if this is a kernel issue? Thi=
s blocks linuxptp running in cloud environment, if VLAN is required.=20
Hope to get feedback from you soon, thanks!

/Yan
