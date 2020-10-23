Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62AC6296FE3
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 15:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S464251AbgJWNIh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Oct 2020 09:08:37 -0400
Received: from mail-eopbgr1320119.outbound.protection.outlook.com ([40.107.132.119]:10738
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S464224AbgJWNIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 09:08:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1RzJxw4qAFW9CMuMzXdHR5+sROhSLcxOdo2w1LnVV0BwkZS8VAleVBOdLFag8osBsaxb72x5ej8SBBhkq3bEhSgO60FOP0yuYkZFoCrZzmP3TGA2VZj7oYknXG8MTSLQIDB918AXxFOvlcZIIQaGyKrjYY0dyvpz3LWhrfo3kw0MpBfdxuMDBXv15MwSCtdGY/FGuL8GfgxMgjnw4S+5sumL1IOfGvc0cWU+GKMwvUnRCUVB+RX6JW3fpnFm6sshsL6+DXbZjwCZ/Y1xsh7IckbvBCzzfWlg5ha+h+yhH0S4CXHzVDIQ5djkSFBw+vp8DHgBWyy5cHvyyqzr0zHLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tQVct3ha1NTNnrUrjRfTF0aXxq5Kkpy6owhkOj7Sbw=;
 b=W3MRZDAtLrJYxuNOVE+6D4oIt3AJbmsgCVQRoksazslv2XlemA7qa9NV/VVS4eKplWusvyL/LL6Te66r/F6mgndDyW/LafxBoDff7mApWsQEDiJG/NKguQR909pkyQJzOnJxKt7lF4bBY9FvkMBVLWWGW3lKMDGlusnnMelKkdOHCOAPzVPq1jFmNIPJ9VAh+ywufPwze6JvNAnWYwER5Ak4v8BQyxBWxdibZ7j6VCAICU+j5edHmD3UAmcBjL9CfPPOhvREeVKmOiPu1WYBa8cD7W/mtLxmTpq1AMKp3Ae4WYTPhUsPa1qw+G0IvlOOz7reqDa8z5DgL4J4rza5iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
Received: from PS1PR0601MB1849.apcprd06.prod.outlook.com (2603:1096:803:6::17)
 by PU1PR06MB2183.apcprd06.prod.outlook.com (2603:1096:803:2c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Fri, 23 Oct
 2020 13:08:30 +0000
Received: from PS1PR0601MB1849.apcprd06.prod.outlook.com
 ([fe80::31d5:24c7:7ac6:a5cc]) by PS1PR0601MB1849.apcprd06.prod.outlook.com
 ([fe80::31d5:24c7:7ac6:a5cc%7]) with mapi id 15.20.3477.029; Fri, 23 Oct 2020
 13:08:30 +0000
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     Andrew Jeffery <andrew@aj.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC:     BMC-SW <BMC-SW@aspeedtech.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        netdev <netdev@vger.kernel.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: RE: [PATCH] net: ftgmac100: Fix missing TX-poll issue
Thread-Topic: [PATCH] net: ftgmac100: Fix missing TX-poll issue
Thread-Index: AQHWper5b6m5IMpmJk2Uyk3yAiWzCqmen8qAgACopgCAALYZ4IAA6dGAgAAnUwCAAAR0AIAD3tsw
Date:   Fri, 23 Oct 2020 13:08:30 +0000
Message-ID: <PS1PR0601MB18498469F0263306A6E5183F9C1A0@PS1PR0601MB1849.apcprd06.prod.outlook.com>
References: <20201019073908.32262-1-dylan_hung@aspeedtech.com>
 <CACPK8Xfn+Gn0PHCfhX-vgLTA6e2=RT+D+fnLF67_1j1iwqh7yg@mail.gmail.com>
 <20201019120040.3152ea0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PS1PR0601MB1849166CBF6D1678E6E1210C9C1F0@PS1PR0601MB1849.apcprd06.prod.outlook.com>
 <CAK8P3a2pEfbLDWTppVHmGxXduOWPCwBw-8bMY9h3EbEecsVfTA@mail.gmail.com>
 <32bfb619bbb3cd6f52f9e5da205673702fed228f.camel@kernel.crashing.org>
 <529612e1-c6c4-4d33-91df-2a30bf2e1675@www.fastmail.com>
In-Reply-To: <529612e1-c6c4-4d33-91df-2a30bf2e1675@www.fastmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: aj.id.au; dkim=none (message not signed)
 header.d=none;aj.id.au; dmarc=none action=none header.from=aspeedtech.com;
x-originating-ip: [211.20.114.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b32be31d-3683-4467-4cae-08d87754bd46
x-ms-traffictypediagnostic: PU1PR06MB2183:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PU1PR06MB2183C7B7914F11DD577B20629C1A0@PU1PR06MB2183.apcprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1udGjDiGm7sX6YKMBTNCt7JBbSYpEoxIEx2vwpBxVb0DXFbv9zS/TR7QEzX0qVywzL8wyjvY5sgvG0UEcS4a7aE7nRPyaieUpRkdsGF6/YEVBInQlll2i0ZDz99JHKJlcly91U3QK0y0Tu5GTtuUBYnXgqAsCYZ+AUdrn4N18rKfxf/qPfOmeHo47JKAiD0zySkWThM49S1Xuo7e60/A/xHTVnDgy03Gmyl2Uaar0ACFAtzDHOYmwec1fHvebraMMauzQqhTqGUbD4OcTQVZPRB9WMQwVTJewaf2rmocRpAlPJZSxlzrncKxXrBSA46KBUhJq1RRnBSK2W32jYdV/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS1PR0601MB1849.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(396003)(366004)(39830400003)(54906003)(66446008)(76116006)(66476007)(478600001)(52536014)(71200400001)(5660300002)(66556008)(66946007)(83380400001)(64756008)(2906002)(8676002)(9686003)(86362001)(4001150100001)(26005)(316002)(55236004)(33656002)(110136005)(6506007)(4326008)(7696005)(186003)(53546011)(55016002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: MDrRVD9aKN9xDv43RfZttNht+k3LtzXjMIGlAomC5KlryPd6z7YwGPx51buF5oI6T6PmGVLa6a0Ti2+hOTuuuXTY3ssb0iMyWrZI834bP3g8mbpmAv7tsYgXZJYEYdkTAU1eSfSoUE90bY8Kwh912wtSI2fbJbgAe098KfuAukPylinU/LDdv9h9oPhnWGRTJiD99MGvQXwleJXQ116Lzg782OelakTeKVF/cETdbuTArx9SGhcCnCBYUrKQCiReZxlpZWEJ4De5tdrCumKQuUYFE54OuC61pytAM6dU7NSIQOeTeP7jqRQ5JezwgT9Iy4RktYyyhPPg03uiP0x5suuNGvYa4O9rNkzedsNgTLaR70fwC09nxtGYgMSi6guwUkfqc8DhPvyr6QKaMTxH2m2YbLXB5mmQ+YWjxjfRJew5nxFWby/DSwpZsvCor/0WAaNEpL6GvmPOAK09oXCqdmrdH39jIVKQa+aahPIhRIn05kgXoZcqrgLyqbubnuCju7VcaHJ/moT6hIzPTZy3sI23Vs2u7khotxqiIoOdv2c+86jXo1FD4jx552EAwpUBrdc455JdcErL/yP/yCDDivMQYkui89U2M8qV2TlcnPAMzlmkH4Qs85aeP1RmXlndQYeUOtC6G+LbB5Q5DzJTyw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PS1PR0601MB1849.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b32be31d-3683-4467-4cae-08d87754bd46
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2020 13:08:30.8094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kuj5SeOHChTJMBnQjONABSUxatwgJhq514g4K69arsPEDUN06/ATaMT3o1Vi8xBDalOOFBwowKAS3DFO9H/05GLEa+pGH2CPQAywrQrU/d4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1PR06MB2183
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Jeffery [mailto:andrew@aj.id.au]
> Sent: Wednesday, October 21, 2020 6:26 AM
> To: Benjamin Herrenschmidt <benh@kernel.crashing.org>; Arnd Bergmann
> <arnd@arndb.de>; Dylan Hung <dylan_hung@aspeedtech.com>
> Cc: BMC-SW <BMC-SW@aspeedtech.com>; linux-aspeed
> <linux-aspeed@lists.ozlabs.org>; Po-Yu Chuang <ratbert@faraday-tech.com>;
> netdev <netdev@vger.kernel.org>; OpenBMC Maillist
> <openbmc@lists.ozlabs.org>; Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org>; Jakub Kicinski <kuba@kernel.org>; David
> Miller <davem@davemloft.net>
> Subject: Re: [PATCH] net: ftgmac100: Fix missing TX-poll issue
> 
> 
> 
> On Wed, 21 Oct 2020, at 08:40, Benjamin Herrenschmidt wrote:
> > On Tue, 2020-10-20 at 21:49 +0200, Arnd Bergmann wrote:
> > > On Tue, Oct 20, 2020 at 11:37 AM Dylan Hung
> <dylan_hung@aspeedtech.com> wrote:
> > > > > +1 @first is system memory from dma_alloc_coherent(), right?
> > > > >
> > > > > You shouldn't have to do this. Is coherent DMA memory broken on
> > > > > your platform?
> > > >
> > > > It is about the arbitration on the DRAM controller.  There are two
> queues in the dram controller, one is for the CPU access and the other is for
> the HW engines.
> > > > When CPU issues a store command, the dram controller just
> acknowledges cpu's request and pushes the request into the queue.  Then
> CPU triggers the HW MAC engine, the HW engine starts to fetch the DMA
> memory.
> > > > But since the cpu's request may still stay in the queue, the HW engine
> may fetch the wrong data.
> >
> > Actually, I take back what I said earlier, the above seems to imply
> > this is more generic.
> >
> > Dylan, please confirm, does this affect *all* DMA capable devices ? If
> > yes, then it's a really really bad design bug in your chips
> > unfortunately and the proper fix is indeed to make dma_wmb() do a
> > dummy read of some sort (what address though ? would any dummy
> > non-cachable page do ?) to force the data out as *all* drivers will
> > potentially be affected.
> >

The issue was found on our test chip (ast2600 version A0) which is just for testing and won't be mass-produced.  This HW bug has been fixed on ast2600 A1 and later versions.

To verify the HW fix, I run overnight iperf and kvm tests on ast2600A1 without this patch, and get stable result without hanging.
So I think we can discard this patch.

> > I was under the impression that it was a specific timing issue in the
> > vhub and ethernet parts, but if it's more generic then it needs to be
> > fixed globally.
> >
> 
> We see a similar issue in the XDMA engine where it can transfer stale data to
> the host. I think the driver ended up using memcpy_toio() to work around that
> despite using a DMA reserved memory region.
