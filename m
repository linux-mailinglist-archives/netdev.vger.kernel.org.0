Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63CA74C4902
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 16:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240377AbiBYPce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 10:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242131AbiBYPcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 10:32:32 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80071.outbound.protection.outlook.com [40.107.8.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C01F218CF3
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 07:31:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QboHRAT1B07EPi+b8DShWobHtd70byQJrusA9tphFflUwCIyGheiKRUYoR8EN6/D3mq131PhJK9NlSyDvSPOYc3lHoGBBeBqshvRpOyOUyxypNOvQVTmaHJjdfFAIQlwnW/9MpUF1uVte4lmx+RAldgGZh+t+FgvWv/tCgGeCT54vhcoUILd6UC9s0njgpc35KOn4ddJa4QCu+nPSEweNSq1EuJ2HiMLkyV/MOI/vGUn/ngreFZ8r2l0AcSt6FvQLObTIqXdOC5kmLui2r5d4bDAghULohju0UoOLSCdmThA45F3atYrf1qbzLxuyt5LqY4SGXU1KiTW9uDaLk193Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/R3eZWVc/wL1NQrcDmkPepjkDPvoySRZmOw4AniE7i8=;
 b=mSgPzyc81+YvwzwHEu1E5MefWdnclw8i1AbIv7T/YTLXYlESVjVwIg5pixJKjVFwMhoIaw6XRRCT7pxoY7ytz1XugbesSfkGpMK6GOBic+blBCYVKEwdSUXJry+PzDoXf5BxJa6l7+kaSvicGtrgCFMwvvv3sINrOPw6hbjMPwaywvoAM6GVqQvnlSotN+5EC8HEZTq+im7pg0WILghoD4nHTFcjf6xYA4tqO2mMPhQDuCaFWBICcdYqeuPyL7q4rpX3h7rwk+eP8PHKAWQ3K+WltY4RqkRZZjc5stwoGM/wWgDJl9gUemP9/X2WSswNN+2rO2K9FKAocqsluEp7gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/R3eZWVc/wL1NQrcDmkPepjkDPvoySRZmOw4AniE7i8=;
 b=JRY8XtgnifXoWNmiBQJwrEQ9jJ10+D8RuNK8lxQe7/DIGkiy/oAUro++fi6cpidic80qxSFN+YxFL9DvzF7HLtA1rL4JLzsO8nrNi/2AYF97CypjxLH9A9KvSpf9we8+tQfCI0F9MG+Bh807SMuSUxXo5tGluGQqclzuJYbwfm8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7752.eurprd04.prod.outlook.com (2603:10a6:20b:288::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 15:31:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 15:31:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
CC:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?utf-8?B?TWFyZWsgQmVoxILImW4=?= <kabel@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC net-next 3/4] net: dsa: ocelot: convert to
 mac_select_pcs()
Thread-Topic: [PATCH RFC net-next 3/4] net: dsa: ocelot: convert to
 mac_select_pcs()
Thread-Index: AQHYKlT0mdIlOD9kikS2yahwTUMA7qykZPoA
Date:   Fri, 25 Feb 2022 15:31:56 +0000
Message-ID: <20220225153156.cys3fvggv7aq4s66@skbuf>
References: <Yhjo4nwmEZJ/RsJ/@shell.armlinux.org.uk>
 <E1nNbgs-00Akiq-PW@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1nNbgs-00Akiq-PW@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01ede6a8-b039-478e-9b35-08d9f873f555
x-ms-traffictypediagnostic: AS8PR04MB7752:EE_
x-microsoft-antispam-prvs: <AS8PR04MB77524F7889E4FD4BF6CC4143E03E9@AS8PR04MB7752.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fOiNE+Rx0GdYqlRksI8ikWW3HYYS/uzLNFEJTjAX578j00gdGrHRVcxFzrsfKdCutn0w4VBwST8nndXtQ1siWIiE27gLtAK+tuMfh2SyOgnCh/eBuM9rAOxAPMHc0U4gBaJEiIwolGT3VPqzJo9zEkoIix8CuIggFKXfzRFCOkd5gEoOJSFuB2qd0999uFMR+gmQ8UTSWQ5RSXtTP4C/vGuta41vsDf9TW+cfjTS9sGDGY8f9S1iTLBVGx1d8RB6s1eZ6Qj5vz9y42AM7CMLACvipOgRd6ioq7u9lH7nylctucIbO9Oeis41L5dN57eoCCD8iVYDBlTjIqgLkaUlU6KJeCn1uvhYNSfQIBYMqhq+dRWryXNAgKNzy+03DBnhOMEYSi1NFKEfEj6qJknfQxRz77jgMV9DCrCMMcNUVSD9SJEWrMfDimJrtIfVt5F1+/ohla5/HQzVZaJZqz1qf8V37cTPLQtceR82LYM15v7V66mK3z+/BdsrV1MePWGUfqYpKCeHJuCnXbAjLtPsoXfdHWbWpCzi+pNNcWdlbakCIGEU4xQg8RLrEaPa5JW46JHKWFJoP+eHzcl9TUbTkBtLCm6jqqk6a+JENwColJpDE51/EwejaxjORs0M8ml9yktjeCm7xifvReFDorZbu5LS/tZJSE1s7MknHZJ4h2Ve3TcvoB6oAHwyMLmPgPuXgF9/tHBl1qw3u2RCY26z/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(71200400001)(26005)(186003)(9686003)(1076003)(8936002)(7416002)(4744005)(44832011)(38100700002)(86362001)(316002)(91956017)(33716001)(6486002)(6512007)(66556008)(6506007)(5660300002)(54906003)(76116006)(508600001)(122000001)(64756008)(66446008)(66476007)(2906002)(66946007)(38070700005)(4326008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YWtMMG02SnNxbUFUbk9BUkwva2lXTmtPT05UMHFWTml0RCtxTDV0QmpoMVpD?=
 =?utf-8?B?UHlXOGloakMvVkRXd1NRKzI0TDV5UFUwSloxV2FGaExUOTVKRUkxVTFxZlRl?=
 =?utf-8?B?YWdyQjJNT3VGUjhEcjBiSGJVZVRtV0hEczlnMXkwWWFsQ3VUQzBiaTdYYnpU?=
 =?utf-8?B?bm94MzNQSEZxQUU1TWc5TmdBZEE1V1M0ZFMwUUd3ZU94Sld5aHQzSWwrTk1R?=
 =?utf-8?B?VTRINncvRnNyem96Ulpnb1ZBQmhkYmg3Ri9wRzJic2NOM01JWUxEeURXYmdj?=
 =?utf-8?B?ZUFsOVRnQXkzZTBYSHdGU1VOL3lqQlBmRWlmdWJPbFNOamFMenVtOTNvbHlx?=
 =?utf-8?B?Z1RZMjZFaDJyblJCZ25hNSs3UGFzdXhzSDJNZkFwd0V6b1llZFRiUER0cWJE?=
 =?utf-8?B?YW44T0dCd2J4OHRCM3JENDRjdTNncFUwcEFabW1PZFB0Tk5pdk52TDBRaGM0?=
 =?utf-8?B?eGYzYmdzbC9jY0pTZzk4Q1ZxQXo2aFR1Y0ZoaVB0RWJTeFV2NHVMT0tGRW5s?=
 =?utf-8?B?TzArUHVRMHFSYjBHZ3JlRmVnN1grS3R2RXBNcGpJeWZCekl0TERJeWRPT2JL?=
 =?utf-8?B?dmxXbStwUGVNNERxenpjaGNqZ3UrR2VWVkN2aEN5aXFLbHFRQWhOeUNCaHJK?=
 =?utf-8?B?a0VwT3ltRHVsVnpVMHZWLzlkd2IwS0p0ejlTWmlId2VvbXRqWEJWeHBZWGtH?=
 =?utf-8?B?M2gzUEFYd1lrL1gvVElnbzVqVGQ5dlE3c0c2ZTZ0eDRacHY0OXYxSUttclZp?=
 =?utf-8?B?OTlYVWp2UytFdytsS3FwQmRuc215OGZkZFJET1FiRE45Ti9JQXVrN29MV1lR?=
 =?utf-8?B?Ty90dzRGb3REc1JqSmlNS0tWdVVqd09BaXczLzJkbzdBa0JxamVoZXBoUkd2?=
 =?utf-8?B?M3JtY29ESW5NSy9JcVFwRnF3WjhFQXVzdHdhOHFOQWdOOUV2ei9PMXgyMXRX?=
 =?utf-8?B?VWt2Z3hScjFwKzNVUU5RSVNZRHVHWFhPTThIMjhsbkg1ZnQxMVM2WjhieGJW?=
 =?utf-8?B?ekk3MHhYVVk3b1R2WW1GcnNtS2xmZVNhenVtSUozQkNTcGhGdGxVbUxxMnRK?=
 =?utf-8?B?RURsS2F3V2IwYk1zNVkySEwwZmErMUc3ejBLeHZhY3k4Z1puaEx0dHJzY2dz?=
 =?utf-8?B?a2c0a0JyZTdiSzY2bVV1dXV2SUtDY2dTQkRDSkt4YzhjVVF6ZGNHYjZRUnpV?=
 =?utf-8?B?RlluMXJJL2hTYkdKbUc3VjVjREZVakltdGVoNWg5ZHlkMm5JYm80Qjk4T3Y1?=
 =?utf-8?B?b29sVzY1QnloWXpvR2NqNURsMjJrSDUvNzJCZzZQUzJSeEcrcFN5M0xoUTRM?=
 =?utf-8?B?S0sreFRjWVlGN3poMWRxakdPemEveTNVNlE0RVMvaWF0S0VXWERPdTFIa3hj?=
 =?utf-8?B?RnRxZlNseE5VR0ZTdzRUNVRhcmlOZzB0T3dERGVHVWJPN1pDbEY0M0tkWU1y?=
 =?utf-8?B?ZjZIUmRDeTBtMWVaQWx5WjJpa1RCVHoyQ2wvY211enJocTNzdEhBTUJkbFJm?=
 =?utf-8?B?b3I3OUQ4bk9IRnl5NFBMdVM1bzU0RFJ4bHVLVEdmZTR1bkhVeGs3RzVYV3ox?=
 =?utf-8?B?MzU0VGIrcllJVzlyYXgvNjVGdXZDZUhYaGJkVWJPdlpnelExeDJZK2E3SjVr?=
 =?utf-8?B?NlJidWFNeW4yb2I3SVVXYUwyd2E5RFdVQjZCNE11YjZ0ZVNJU0Fyc1hINnhl?=
 =?utf-8?B?N3prNXJRcTBONDRnRlVVR0dVTkNxY29La0NoN2YvWk1wZVBVV1J6cFR1b3RS?=
 =?utf-8?B?a1RzZVk3OUNMM0pQNGZHUEtWcEdJSDJzOGlNMS9zVCs0RE1xaTFDb0ZMb3hr?=
 =?utf-8?B?a0lsdzBNOThzdVhES0ZydWg3VE9ZM203SXNvc05oNUM0ZDBxQk9sRVhxV3Fq?=
 =?utf-8?B?STJUSFk0clRObGNLR0o3SnFaejV1SVFqbHhtaHoySE1qVm9NQ0dtaGEzblRW?=
 =?utf-8?B?eHlaSytxR0lPSDdEOWFwRWVSZjFFd3U5cmFPenVNdkZicWYvdUYzSEJjcXFQ?=
 =?utf-8?B?eEx0cWM5Q0s0d2FTeWRjVkVPYjVZSkQ3WW95dlk1QUNzbmRZbE9GTzllUmda?=
 =?utf-8?B?K2xMdVNZazFQM0JyVS95RTl1TjVSY0hOWWlaWkkzNW9wNXZNeU1lL2IraDZu?=
 =?utf-8?B?MDNDSFd3TXk5VzFrMzJxa2FWdDcwbk5tWWd0SGxKdzhiaFc3MkFQbnlkNkd6?=
 =?utf-8?Q?nBpEeKqldOOcamieoG240LDX8KHlkexN0tKfDSMrbe/U?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95F416850DE85143AA9D20D9E1C716A0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01ede6a8-b039-478e-9b35-08d9f873f555
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2022 15:31:56.9341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: We0DvAjATC5Pe91R5qBjEy8HFoEui35O5R3/CKQ7qlANcxFUtlqqp8Gf53/hWJQ4ytxniLkH3lGkaNZ5azYPRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7752
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCBGZWIgMjUsIDIwMjIgYXQgMDI6MzU6MjZQTSArMDAwMCwgUnVzc2VsbCBLaW5nIChP
cmFjbGUpIHdyb3RlOg0KPiBDb252ZXJ0IHRoZSBQQ1Mgc2VsZWN0aW9uIHRvIHVzZSBtYWNfc2Vs
ZWN0X3Bjcywgd2hpY2ggYWxsb3dzIHRoZSBQQ1MNCj4gdG8gcGVyZm9ybSBhbnkgdmFsaWRhdGlv
biBpdCBuZWVkcywgYW5kIHJlbW92ZXMgdGhlIG5lZWQgdG8gc2V0IHRoZSBQQ1MNCj4gaW4gdGhl
IG1hY19jb25maWcoKSBjYWxsYmFjaywgZGVsdmluZyBpbnRvIHRoZSBoaWdoZXIgRFNBIGxldmVs
cyB0byBkbw0KPiBzby4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFJ1c3NlbGwgS2luZyAoT3JhY2xl
KSA8cm1rK2tlcm5lbEBhcm1saW51eC5vcmcudWs+DQo+IC0tLQ0KDQpSZXZpZXdlZC1ieTogVmxh
ZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT4=
