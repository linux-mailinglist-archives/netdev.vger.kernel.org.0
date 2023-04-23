Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD446EBDD4
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 10:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjDWIBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 04:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDWIBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 04:01:40 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2050.outbound.protection.outlook.com [40.107.22.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A84171F;
        Sun, 23 Apr 2023 01:01:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZw8Xh7KLSLT1R0eLYdd8raxPiElwHRK2UDXaaM/KpPkgvzbPxmZL2zT50Idih9eWnTaIkm2qkNgv4fN+GDM700Of871FzI+KBaLik93wM/J0JwV22wqn73LRys+ngRoevTQND6IPMbJHLRaOCBOMw9VsQ82gVaUxNX9pZukAJWHN8D3vP8OzGKPG07oGRAEZOXmZokb4WsP7itz8MiZTToosShaJKG3/BdKbDJw91E7VL9l/Z4gttNArwmj/rVguQGB1XBtaG//invO7hbpzTNsYsTpeMq16IVNMjn5p7xed9OzcNaHyFNCabazN2uYxvLzIbs/TmRjqpbKzQR+Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mqn31Kmo61K8Mo/1UteorTqBhy65e2zXjJ+A5oKxzsI=;
 b=M6XB8q6PoOhaWCNu7TCfTG7QHv7SNje6X6ST9HZOkSFlTto2gIaPFU/T2bgWzurqaH9l0a2VNyIN+tZQe3h+QbJtvdHv8lIwf1EseO7h9YOwyJlWbTWrys7J8pDllcLrURttDaVTV9SG8Xe2CkhqjgqDsKEzQPhGECEHIDg79X6ygb/1snN1Xp9FtpAvI3WSMYfbUqI4HvMjSxtKHklMwU/759ZeggUhslwao+VLeU3GEme7QmlMsKz79pSI2SLCRJU8TtiUziGcjs9B40j8vhQIFLEU+RXY2szNUi0h2WmcFqX/O9EMNdrLn/KEr4b5kOEgR5OSX7e1SBE173vpmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mqn31Kmo61K8Mo/1UteorTqBhy65e2zXjJ+A5oKxzsI=;
 b=TUTCrcL/D8gV9fbltJcPbZiUxznSt3gxTdykbQ5qKTJMeGJ+u0WIxk9j30fbGttvwMNPLuU/2WPJ+s7OfD/dckomCj+YB+3soMTbEnhJp8+HI/u7Wj1MWuNMjYVNt6ni3kdwP7Uz7rnXKy0jzNCBcEN92pznII7JFdiA0LERkE8=
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by DUZPR04MB9782.eurprd04.prod.outlook.com (2603:10a6:10:4b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Sun, 23 Apr
 2023 08:01:35 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::d2fd:ad65:a6e0:a30a]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::d2fd:ad65:a6e0:a30a%5]) with mapi id 15.20.6319.032; Sun, 23 Apr 2023
 08:01:35 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Thread-Topic: [PATCH net] virtio-net: reject small vring sizes
Thread-Index: AQHZcDeGnH5xR2OGlkuo4s6jvhNMC68uIjT9gABGFgCAAG90AIAAMSwAgAABjzCAAARBAIAABATIgAAENICAAAM4M4AAIQOAgAALfyGAABuqgIAAAQKHgAADxACACRVQMYAACvaAgAAKrv4=
Date:   Sun, 23 Apr 2023 08:01:35 +0000
Message-ID: <AM0PR04MB472392318BC9A36CBA7AF19AD4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
References: <20230417023911-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237BFB8BB3A3606CE6A408D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417030713-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723F3E6AE381AEC36D1AEFED49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417051816-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237705695AFD873DEE4530D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417073830-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA4F0FFEBD25903E3344D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417075645-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA90465186B5A8A5C001D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230423031308-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230423031308-mutt-send-email-mst@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB4723:EE_|DUZPR04MB9782:EE_
x-ms-office365-filtering-correlation-id: 1e095f86-e0fd-4a59-0745-08db43d0f587
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D0jwktXPyLujNwL/r3x3n4ODuH+2RhnLEoRIS+dJB6KuQmRtXzjUm0nmgi6w1HvmNz+mi2SC8c5/0ZMWlfO8LpKd7IIMCWGoNXIVXx9JdT8BAf9qGVagwP4qTgKJunW3UdN1ItAqbBhRZW9HP9rP/MJ3PKV1ivyHiP2MsYydfU65YbcIBAKFfJgSHlREMjKFbUKzSoAVqBWyG4jwBlFQF+8M2TjJUjRTaAK9hT1X9hHC8jkqKOdi3oAARPwCi4/Kg/hdkb8J1xiUp/UYhhw0W/p4f5ZLNSPeQbfEPgoXFmuMaukp94FZL8klInebYeKTebVFCITl7bMNXejcvxGeVLOGNpIzJ3jISKY73cGvFrjf/KeR8ZZWyUdzPMJ5VBtzt1UcW5Xa3QbTsCZ8VabV6/wQ4/5NYEeT7hNRrIs/u/p0ZjantRLEDdkRaMnC4uxmVuDb/IOwi0x2/Wj6xg3S0vhZLIZWdVusvcEoaXX/hkxsNJME6PekP5J2ObC+k/LidmJj97w6SsdgkMmFConeU0LX8iuvtqXCvvZxkQMcJSn+SoBZnaUVha7sGDmGDDAwjUKSkb2lVr2MnQM4b/AImkCzzjrO2NU3yuQ3rHgv9noz20ToU9muEtp5Ylj6a0dM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(39830400003)(136003)(396003)(451199021)(478600001)(54906003)(86362001)(186003)(7696005)(26005)(9686003)(6506007)(558084003)(55016003)(33656002)(71200400001)(4326008)(6916009)(64756008)(66446008)(66476007)(66556008)(316002)(44832011)(83380400001)(91956017)(66946007)(76116006)(2906002)(38100700002)(122000001)(41300700001)(8676002)(8936002)(38070700005)(5660300002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?LDSG5v9epEfLg2cUG5iMOPoRirIC+Z9rsuaukRe6+GZuqeVAZgLz3soYfR?=
 =?iso-8859-1?Q?mMUkiKSS0Rq7tSPYIB8UYmcgmnj7QWYvceykv4ZZ4AtNHSqFIbSHzQlrHV?=
 =?iso-8859-1?Q?LwZpz5awnFIrvona9qD9XcWvH6nLPvzABz819FDVaCOgUIS3MU0w/6XSJ3?=
 =?iso-8859-1?Q?zQLp+wB0cK0UPIIwf0j1LpK7RdYXgE/JfvNF6mZutiy7eMGgSD7sArHco6?=
 =?iso-8859-1?Q?2ubZCL/IvQy3JFAkf37gpm6NGNjDYX9n2V+c5oY7pq1hyzEbrm+Q6cdFNO?=
 =?iso-8859-1?Q?7M2PedHaLPKxYMHwjLJTBc/Kp/RYLFNveSuZHOHFmhNe3fa9OSHkWbz0kG?=
 =?iso-8859-1?Q?/SipfbdCn2FMEiwJ24Pu1o6Ec+Z3S0jqUYoz5GNVtSLdM1rTb1Yv+scNY4?=
 =?iso-8859-1?Q?TZkkeXlfQsN8fVcpuxZL5lsTfcIxH5P21WxC1joabCS6dc5eZdv4aiwGp+?=
 =?iso-8859-1?Q?3Ez21zcNJ1N69fEta9I6YSP5KTpTzr00JLm4PpujhZeKqyHfLMbS3A76jd?=
 =?iso-8859-1?Q?RbnqHKMvG/j4o2P1lQ3VH/9OYjCuOZDriYm6k40cJnu7EFt08QryUSuqfk?=
 =?iso-8859-1?Q?qnBVwfa9LNOoEzByYwOVOArK58AxIypdEyW1NQgO41SxtidHzwtp8fnS81?=
 =?iso-8859-1?Q?3nensVI0QRQCtcc0xpNRu8O8fVHY4fISykQNs904MivStL4CfGjN8MRZkN?=
 =?iso-8859-1?Q?6bid9GmEh4QMzs+OaMDtpnlNHwDWkPj/D39/+mRWlhpS4XlqCa/HrF8NOI?=
 =?iso-8859-1?Q?+wrR6ha7P6ac7VMe945/tucawl5YccnM2y2hkp4wT1W4qIotzQWpSwDmNP?=
 =?iso-8859-1?Q?4HU3RrWnU1RnblCzDy1yFpFeRdUXKszvvGB/X3CRWorIQUeLbFQvenX5cF?=
 =?iso-8859-1?Q?MyDoMKVypwxoMJbqN9JnvC8I+PLGlWfyKeYCDv/hy07cSiQfWUTq/b3M3b?=
 =?iso-8859-1?Q?6RfHysomRk2dbn7SeK83kb1LE+eMpGJQ+BTq/I2qckvPCc+PIqkuu9TjVZ?=
 =?iso-8859-1?Q?yvOaaiiB4rI7vrNN0wTc1Rbviv4N44ZRdqT9EPeyQSDUwV3Ez+FqAhxrSI?=
 =?iso-8859-1?Q?7eoe/2kIrAcnQVKRaUzZNOcbatbOGaOTJAQJ1BEUny0q/jWvPVwVDF4IZI?=
 =?iso-8859-1?Q?dRX46Wsz01C62h82AYAegzjz9cRyLimdEphhXMcgE0xHDazYpZzpGwIxM5?=
 =?iso-8859-1?Q?v/PbDaBLIUGJXTngnD/nfXKbCJ6qWUGQjFzmz28yCqeOmUqEdQhk+AThDY?=
 =?iso-8859-1?Q?caqbC0OnWJVjvw0FwwWJYHMkHOgdu2RQkLXZuK9WRsaZyGsz6S85lCkYm8?=
 =?iso-8859-1?Q?vppXA1nDq1mzrn0XOC8Nqrk44EntLlZTRM1CRDWJGYhoYSsJ41K7ck1EG7?=
 =?iso-8859-1?Q?NHKCx3Ck1E8Le/GK8GCc4Pbf+kMp8ljA5LaJXF0jcGW3GLEe92THD8K6Y2?=
 =?iso-8859-1?Q?1eq+g9J5TEDsqqt+VGswj0FCe3DRNr36/+QZ4K8l0F9rZ52adspw1MVz94?=
 =?iso-8859-1?Q?dHhsr3qy1RuBJ01vp/yFZXbcoB+xwoa5CGMmrwc45zgQ3TGzQewgHP9KUI?=
 =?iso-8859-1?Q?rx0FcjbFSyAUGRGJnWPgvA7jgZpmEfajHBG5Rznjo8KSAAdau947Krf+2C?=
 =?iso-8859-1?Q?7HSQMVBcm+jlqjtTzq82I2OdOUCakVuUQT?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e095f86-e0fd-4a59-0745-08db43d0f587
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2023 08:01:35.4227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eBTGo7dsKI8OnvGyx3cyzTOXjscoTmj902pILYpqJrTSv1DkSI72R1vtVEfvq60UTTVINPzH8inQmGu3HAqgdYHZFmqp9KJh04LF5OuwbRQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9782
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We could add a new virtio_config_ops: peek_vqs.=0A=
We can call it during virtnet_validate, and then fixup the features in case=
 of small vrings.=0A=
=0A=
If peek_vqs is not implemented by the transport, we can just fail probe lat=
er in case of small vrings.=0A=
=0A=
