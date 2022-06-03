Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C438453D3B6
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 00:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244058AbiFCWxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 18:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiFCWxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 18:53:23 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2132.outbound.protection.outlook.com [40.107.236.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F31DE96
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 15:53:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKoBj0NSNuW8OCqJ7XjSOJhGm9bj75efPzdlUJu8+KDNBxGMVJAJI4bjnVFuryLPggKR0K/NMsRBRMSzsY4bVzohe/DtY351nhYXKHOsRVKRT5aw+3WIgLSc6X0950IaV60m9cjbFBC2pvol1n57Ui4J4pVgYnqn7f4H750exHWSjqSLVpkrLL1swS32Jgv726gQsF91E/gpNsTAdxW3/bhzWLldWhZCy1G1lh8UgekPK0ClJB/ot20puc7W+9W6ZpwiRMLkXZ9WS7b/WsUVuU8bFv1MICUxuY0uIVLFm0rdpW8cAzPxY9c7ladoms3ElXoLvo+omrHelJKj1xXmTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jxAj06ELHDdnVOOf9zIsJkCtTxdCoGfoF51C8drSKMI=;
 b=R1UO7HHqHkGMCjYipopzvJpnAvvxwDT67a6cTDxUT8gL0u0ZaXrGJR+5JG2tR1v1zotOnwhT7XAw7e1PvcbnHBzKn/BV4dpwCbLO3sG2emjuEiFKqmMv9gjEZ0MfAvtBK5dWvGfH5xCWr/AUdmHYHvx6mSJ1TBw8XKim3xLq3W6KmPFS6XyBUDhaIJW375DDFqBYIq/v+q/UYkF9cPLWR+PDvW3n4cyS3VliCcrWXo4M9G8+P1l9CM8fBejtXjWGfvKqF6Y8zBk1/5H3D85gUmq2P0XPau094XoExFHC+UV7xMUPo/QCMn/RPWDLyDjRZlcFmcr+0++Hrtwewr1ibg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jxAj06ELHDdnVOOf9zIsJkCtTxdCoGfoF51C8drSKMI=;
 b=KozRZI0ExwrPnOIvi/7DxgRlSbAMgCLAopFR+Zy1pNBiaALhNtK6sefIpNLLX+tw50aUrhSlquoHIr0TOjO2QyIBeHnjXBSoGAt4M+8/zR+i/f5Jn1xAqJXzMVtzGxH0qfubce+iLd2zYhcekHzSi/e+baHAicCych6ctdy8oqg=
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 (2603:10b6:301:33::18) by PH0PR22MB2566.namprd22.prod.outlook.com
 (2603:10b6:510:52::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15; Fri, 3 Jun
 2022 22:53:16 +0000
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::4db8:a6d4:a973:d2d0]) by MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::4db8:a6d4:a973:d2d0%6]) with mapi id 15.20.5314.013; Fri, 3 Jun 2022
 22:53:16 +0000
From:   "Liu, Congyu" <liu3101@purdue.edu>
To:     "edumazet@google.com" <edumazet@google.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [BUG] Potential net namespace information leakage in
 /proc/net/sockstat
Thread-Topic: [BUG] Potential net namespace information leakage in
 /proc/net/sockstat
Thread-Index: AQHYd5uDf4/r9sonG0OZyim8lgogUw==
Date:   Fri, 3 Jun 2022 22:53:16 +0000
Message-ID: <MWHPR2201MB10728AE0EB8C691B5CDA6D7DD0A19@MWHPR2201MB1072.namprd22.prod.outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: e7b86775-baba-3058-0f7e-b5cdbc36727f
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=purdue.edu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06d70b64-4377-41e4-8211-08da45b3d8d2
x-ms-traffictypediagnostic: PH0PR22MB2566:EE_
x-microsoft-antispam-prvs: <PH0PR22MB2566B025DAD882FE7C62D41DD0A19@PH0PR22MB2566.namprd22.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rl5V/KqoRejFAT5KPEDvxdGw4SHj3nnun3VjRbs6C0E18cDuizLhqGRKULOS719fJIODOsjp1ri8Z8LXIXdX5idXD9URwnn/qUwFgrOW+hT88xhMJuVmSEsnj+HDSB9/YISngPDW5z3XmmiZ4BA9rBFnMuxmDc1xedmF/5+cFF4u85QtasDrhPAM99Ofg4kfqw/9BGfM1ebdeIPE1GJZoPOlI87uxjkOYTVeMqNaDSBkO5hNb8CGudF587V9si7OWGwvU5XZj/spD2OIQHptFTdNsKrRI06P1mT/TWfzNnrJhZMBJoQSacLCUX4jRRRCA2NkZfACs3K1TmezLnrm2xfRAGMR+7lAuDV+QAuFyybqH0p2Ae2V1kHUW4s5veFfnhFnmxNlMUVNBZty3sgxZD9tZqRERZ/I5rDLL/pFf4eeUYDNZiJ79EZejrJ/owB8G/SnMwtb2UUXqsnSJE7nb3nGZvcnSzCvvR7TsNfG2Xv9tguehzJxvhKDEqYYSdm+PlRLw1JGK0balNA/KdCfN97hNhH6UiwzZaycFKpZ5jRBuG9ZAabX2Vt6OlW/Ge+ipJCSzpLb54UG+VBDrJIm2fPB6UJ9TrzsP0Z9fhZ1jLYwPMJhY6z4z5WYlyqlkpLlAuT6iitfidGmqJIBczZ1pgn8/Ws0SCPzW9tWNHAPRbHZSPzgqrOFjQ+zfOd/hZfGKt2khcaxUuUHKEFZyfjkTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR2201MB1072.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(9686003)(86362001)(5660300002)(186003)(786003)(75432002)(508600001)(558084003)(71200400001)(66556008)(66446008)(64756008)(8676002)(122000001)(52536014)(55016003)(38100700002)(6506007)(8936002)(7696005)(66476007)(4326008)(66946007)(76116006)(91956017)(38070700005)(316002)(33656002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?WTMNQwzSTkvVdepe6mNIHWsSTVe9TEEJ6R6CTZ94dqC18lPQ4s5eoAqLoL?=
 =?iso-8859-1?Q?4BSCxsIAoDOwg9C3UFDxvvDPP6UR4J8Kj3aNg0yOpm7VEUJGgEjFgyov5E?=
 =?iso-8859-1?Q?YlBKTRPt+1F4SOxR5JTFjS+qhT91wvuNmhWxiI4G+8mI8z/xJnz6lOkV49?=
 =?iso-8859-1?Q?ePMSlkN9SeW7hygwggG6qcEzg4OTMEFtiR5DWB0tizWMbJ/ROr6GVHYrQN?=
 =?iso-8859-1?Q?KSyQj3yeQXbHnGvplSlJISfiB1kh7U3/mm9af6mZ2w1tk6JmNMuV1jrJQY?=
 =?iso-8859-1?Q?Y4aO4maDM7d3mMqSm5B4GNvsPtgOWRQQfvC3ki4EGeA/j3aaBQzjzVlPcx?=
 =?iso-8859-1?Q?zQvhlhYT4jqAMyCP4Ycf5J3Xn4jNDleCC1rS/6yH6qbqF3+brY3Gd2V8o5?=
 =?iso-8859-1?Q?d26+fSmTlCikbYc9mbxMT7BslD5fNkGYxI1VE1EAz78skeh4pmvVah1Pz3?=
 =?iso-8859-1?Q?vidnFYwK0bIWJnZDkqesgmc59TQ0F/EZ4ELxKMOy52vf8RuD9IORpgPUG0?=
 =?iso-8859-1?Q?5Xkhei/72E4X7dYRDeDvgQRVNYaCtJrTEGUQSDNGSTL3MRI0UIcz+QgKh4?=
 =?iso-8859-1?Q?KOHspxfJvsyS8Ir025EGFRcAapBctbFqaa687jbxOXZugxZj3cGAIuBp+y?=
 =?iso-8859-1?Q?Rb3dh3frmqgPGxFj3n+is5gehmw9EDmwbLgXk0YNaKDJyqRtX6b5VpJfPA?=
 =?iso-8859-1?Q?tsjxf3l6EMO4LtVtZkAqW1wO7ATrigKgEanA+h+u7R4isJw3W7kDzJM9G6?=
 =?iso-8859-1?Q?Eppg/EU1Qd9KHO5B3D0DJuDdYFb3uY4tGcjQ2jZbykJcw6gLTCB6toVAbi?=
 =?iso-8859-1?Q?pbiPNTYHe/MlGnwSywnZS5T9Kf2hEqDdVVriukasjoS17zWB9fkLPpo+ti?=
 =?iso-8859-1?Q?L9HRBxnkqRdJr/xCX05xCR3U44qALlQa/uGirhT/EJM5GkDTquuyjnBMAD?=
 =?iso-8859-1?Q?rGFwGJbiusJpHlj7oA17IhAocb7kXGvmBFobJbkdO2Bhyk+C9qpi5bUmp2?=
 =?iso-8859-1?Q?Wgkh5ENpQbyDUpR2ZAxP93CRU46erLWoXKgp5s0y2SSm3atMqQ+5XlOdah?=
 =?iso-8859-1?Q?zCxswK72kaLImPUVm/I7m7cPq0D7JNxWQKo+Rvgwe7Znkb/6w5Kwn3+mEw?=
 =?iso-8859-1?Q?bCvV4wf0axQPahKlP7G0VbeF9K8/tcPPs7Y7A+CeIsTvHew2g5FlMP5UvG?=
 =?iso-8859-1?Q?TnT7vPBK1u4zcsjY8DhCEPrENo6BLdZecBxZrWW2L4zcr+uBAlesHwLBeI?=
 =?iso-8859-1?Q?ZRyd2kUvjZfrUn1WRmm5OxorQd5b5lwWknPWzerpPN/Wewj7m/gLCwfFgc?=
 =?iso-8859-1?Q?1LN1IBhow7d6p/Y2kvcMxHaQDEPEaIKJMOJL875Neiwnq01p03f6FVaUYV?=
 =?iso-8859-1?Q?W4uETvOZ95WuBelpRy5P9zcHHpuq8r5qtckgUSuUt2UOvtGo3eD1SpPvnu?=
 =?iso-8859-1?Q?Av4M+vaLcIqc5zyG0N+PPSnTSDP+iWEDOrfc86iyE43ZtUqtu+zpnjfHfD?=
 =?iso-8859-1?Q?u7yMb5XFrex1QZgxOaSxgz/Ba+C26p6OSUDNffsOhDpsv4494jR+Egfp15?=
 =?iso-8859-1?Q?d2qjESU5gfpn3WFDIaGPUOYNCVHkahUGbkVztjXRDQpJLE0+ZZhXmdDnVA?=
 =?iso-8859-1?Q?LWFobcppesSLJ6lUROa02D+NoaFHPUleHO+YUEGlU9VEamN4n3EnTUWp3P?=
 =?iso-8859-1?Q?pM1YpYLGaq+pGCedxscSXfMKVDWnwQ4lkZc6JQ6ZPSlZI6YUmFjZ7J+LcK?=
 =?iso-8859-1?Q?zHQEyc7jnUlZtGXyv5CmXLXatg0qn3G7jKdULbnUNcBwcYp2NS8F/cyasM?=
 =?iso-8859-1?Q?hwAwS6ShqWdoI9eawfuNU9uUdP5dJO6YmhJg6w2lFFg2oamem1s6?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR2201MB1072.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06d70b64-4377-41e4-8211-08da45b3d8d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2022 22:53:16.5171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iM3WLNboZMO9OxIXwQ0YVDShM9qAdgpUFpMiK66x4xPJERxp7aP7I88DdVLIw5GXLTqgrENdlBhdSYvGrztYCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR22MB2566
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, =0A=
=0A=
In our test conducted on namespace, we found net information leakage in /pr=
oc/net/sockstat. For instance, the TCP "alloc" field exposes a TCP socket r=
elated counter that is shared across all net namespaces on the same host. I=
s this an intentional design for specific purposes? =0A=
=0A=
Thanks,=0A=
Congyu=
