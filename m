Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D276277C2
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236483AbiKNIdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236510AbiKNIc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:32:58 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2062.outbound.protection.outlook.com [40.107.21.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373F217E2E;
        Mon, 14 Nov 2022 00:32:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/6tuj3gln6Tr9Mdu5QiRZ60+RMxZG7wsx2pOLFBmRe+CSZgLeBluw182eLexwYOyEYHlB2U0okaspJrvWJqcswelMQnP78MWhPfS31Qn1f9G8ujdC7bFH410wUfX/RuebV+LxD30InyQCq+cm+kLv4pW27aJxpdDwkIWpPRh9I9jZ4zm+UEJ4LcaZbtC6mjeXwrLH7NkcjBhjGOkP+Ys9ZMG9kX73uPAfW18Q9jMROnR61DsALDFo6rRj2ZilzoKn2XIjlojif6NvdlZe3qskjoKGh5y0kEZI6s4/IgowraswTn8QBjdBwvGHUep6PKrgf9TrABnjWFMwVM5gN+cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJqzAKbhLR6no+FBGgKK+TDW1LX6ciwSF26u5NmQBqc=;
 b=f1eYZ4+uU3X8zdOWEQGfbbSXy3kLx98zLmvvF+S1FZXZ6dTCv4Zmvf8khPaSe82I51VM9R61Kx0jHOeuBN8BUoxoqCw74Ul033ptVzR7aUkPH3xpkm9PHdDLghAtxL+JYojM535IfUdwVS+YYmY+c0GJr8rkGfpE8kx8KccbCqHgSQ3XHOZVVnBglBKKUVCXtN9cPLbfjLrYLm1A3P+ZzwF+juV/Gj0doM4gJkG9TnOR8aCt/8cD8CQe0Lc4Ynf1P6e2aql+sbuF32G9yDsroK5LOEhXqva7Jdqw5gPmaZW6995J4UukpgqIbp/Ib18p9bpiw3+0ELNmqqjwI0Xqrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in.bosch.com; dmarc=pass action=none header.from=in.bosch.com;
 dkim=pass header.d=in.bosch.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=in.bosch.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJqzAKbhLR6no+FBGgKK+TDW1LX6ciwSF26u5NmQBqc=;
 b=ELElOGdIstJnN7vgvlXI8lRL0S8Yluk1ywk0Zvwc7Y5qXd744hzdcOeNoVRJz8i6t0ZulyryXSmep/qDLdPveMgPbDZcqSXvJHljWURrdq6w/aA14pQx7GCVpKXTM1AqfkerzbLrMUZwF/xpGh6Kbkou6M3MtFDIY0oMnP3AUmA=
Received: from AM6PR10MB2325.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:44::33)
 by AM0PR10MB3473.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:151::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 08:32:52 +0000
Received: from AM6PR10MB2325.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::aa91:54f9:d074:b8b]) by AM6PR10MB2325.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::aa91:54f9:d074:b8b%4]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 08:32:52 +0000
From:   "Arunachalam Santhanam (MS/ETA-ETAS)" 
        <Arunachalam.Santhanam@in.bosch.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "EXTERNAL Kleine-Budde Marc (Pengutronix, XC-CT/ECP2)" 
        <mkl@pengutronix.de>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] can: etas_es58x: free netdev when register_candev()
 failed in es58x_init_netdev()
Thread-Topic: [PATCH v2] can: etas_es58x: free netdev when register_candev()
 failed in es58x_init_netdev()
Thread-Index: AQHY9/5Vp33phWcsf02Yanf1AaJBUa4+FjJw
Date:   Mon, 14 Nov 2022 08:32:52 +0000
Message-ID: <AM6PR10MB232575E04F886D1B9341DD21C7059@AM6PR10MB2325.EURPRD10.PROD.OUTLOOK.COM>
References: <1668413685-23354-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1668413685-23354-1-git-send-email-zhangchangzhong@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in.bosch.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR10MB2325:EE_|AM0PR10MB3473:EE_
x-ms-office365-filtering-correlation-id: 22f2b716-35a7-44c3-93ef-08dac61ad256
x-ld-processed: 0ae51e19-07c8-4e4b-bb6d-648ee58410f4,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LsU0wqaWleX94xHWzM4TgQfMUI3AQPJ2zkWx+B+JaU7uI7md9Yw2oUub3AG9OKJ8TtmsymWro57VB2IQCHfBUzU3p6LjkcgXJ3huQ1fQiJqxwkXiPL2ymZBrGJ1q2IVss+yle8IYVK9Pp/ZWkwJOw7BOjrgj/nk8QfKY8h4gVAFKyQVw27AMz2DSp0+obvIwbSZ6UR+3qF7fJk4uPZRgstCbh/erc1TwaQEIBF6PHBvLl6hAeM6rliID40P3mdtBPLjA2fF4PuRRIMQTL/EJaaRr+j93WNv0CUXy5DOdIXbbxNziHc6Wtcsx/Gqb1WNtyq0aB1uKxff63QC3uC6II7syBO2tlQBqMNiGTv+41/Y4TRBu9iiQhM4crpws2nPQv1sN1PRH+JUo0ddkNDpoAfvPQT14hPfd2faSEZ8FKztda7iFxNQ8tC7pUguxspUMelBw5Zj0gu3CEJ382JwN3M9EpqhDif0bzoqhEYIu++GOXPqTSbLuQuYm/pkJcDru4AWLZiPolZ596hgjWWvY+3J4L39J5mBBeFQNHZlhmKcJoNJSUpEbldMqJj65Yxb09w4BO2vcImn/16XhCgoINac4T/sRz6/3J4jJGfhsRGREY1Ms9uZkYDxFOnL9inHAHih7xYR3zmRr0Ssvc1WtCi/1JXS1A6w19Sw1rX0MzLZOwQDOWfLy6DxxJLLDnDEgrQxV6x9FQlr9BnytPWfsFaQSI/VzpAbbQ+b9x0BGb2/bgHS2SokQDIWMCCjfTkPVtZxUUu2tJnH8MKqJIO6Z8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR10MB2325.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(366004)(376002)(136003)(396003)(451199015)(83380400001)(55016003)(7696005)(53546011)(6506007)(9686003)(26005)(38100700002)(186003)(122000001)(82960400001)(2906002)(5660300002)(7416002)(8936002)(71200400001)(110136005)(478600001)(8676002)(66446008)(66556008)(4326008)(66946007)(76116006)(64756008)(66476007)(52536014)(41300700001)(316002)(54906003)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uIK4YFWfqoEFD3JOV4Jcfn6y2DhfefgAv8YKwZ6UEYRic4j8A/w1ciqGy2++?=
 =?us-ascii?Q?vXprgBzwkFEVxM5E6l3aybZnvaX2Xna0gtMP7YllxsBtPlmPr9rZ+e03FmUA?=
 =?us-ascii?Q?5B/Y2ih9UqwODzv3LV461MlixpRcMRNrA5v0J7mF2bh1pylRppwxm3k0HPjl?=
 =?us-ascii?Q?1jJCL7xJH4E8+9xP+bIHrdJXVvCJmODo8HI1uoSvAAPNKmkCz9aD2WnExHVd?=
 =?us-ascii?Q?FQVd74fN9D2s55w5pwncaGG59lF8k03BKvgDzOZNagZ450jz3mxcAUn8cEZ2?=
 =?us-ascii?Q?DI4pv2wZ9LL8fkgQ0OHFvMMBeZfH074VHEm4KGDi7tHyLVf+SSoZrVvxOopo?=
 =?us-ascii?Q?uijVTNCNQVfoxNAZYPqfic1SCop6krMentpI4YLLuGcmjHvf3H29G7TwtFA3?=
 =?us-ascii?Q?H9CzlE1H5ydPT2BWFFkKv7RGQS3imbqZHcgtIsaV6lSCjnrZwlOnZ2tSsNnt?=
 =?us-ascii?Q?5tyHsgnMcqK8B5EO6i7zNSF+y1g2VeCHnvW+UHGxTKEO3N/rQVGFRUkSAD0h?=
 =?us-ascii?Q?69XjoF+jIL4PTfaTxAF+aW+4chSQ7NX1/EsKh0nFdsMeI8eMIcPnn8rWu4PN?=
 =?us-ascii?Q?AEhvOQ0ZKkArQvCO5vQ3x55cmfJljjx+dO/8YygxkOy85/p4brxyc3OahQ3u?=
 =?us-ascii?Q?mQ0cQ0l4/PoMUPfDWEbByhW/v/2qwyZs68cqfHhagEBYzBtsEztgJaclFQgK?=
 =?us-ascii?Q?nEAaD/eRa17M4zAI+NmXXUbjlKWmVOKvvBcsoK5hGPlEoZkASg+LOp9R7e1/?=
 =?us-ascii?Q?BkSJQGBjOrOVTNlvYmBuZjarkfJhoefNhieUE+WWssYJmTKvtJI078Z0vd19?=
 =?us-ascii?Q?UWhWt3wekVGHf7iVBJW/aHbKFPOk1NNqR42XBXFBW5qRXYr+Bt45fDcGyr5m?=
 =?us-ascii?Q?N1Hf3yVQGyvVG3NRJAF/xo22oYL0WDWSDBgazRFrezn6uC+WxIA7Zl9iRZ8D?=
 =?us-ascii?Q?/7XCw54RNpeBLCjpSqTl6xuzkYWOJ8mepmYXNrFczPzIvBHpwI/vsEBFTznF?=
 =?us-ascii?Q?t7Atie6Rv2VPl/kETNrQQhpM56LGXWQGk8CmtPfyNRKvuUP4WSUaEH/Uj0+u?=
 =?us-ascii?Q?NOLLg6UxV6OAwM4/3rsbUtE+6jhQ+l3+W+hV0HACzB9myUFaM+jXFsOZGG+j?=
 =?us-ascii?Q?Qhjnd2tElIdNGliPSXIc2rfQz9mioKUL5gA4pWDc4h84gJGubx2wfVikO6db?=
 =?us-ascii?Q?Q2Q+oU/IEJM3Be9xShRUmHcj6nw8wWq9Hl/9w+zOaI3ulTbrIAjjfs4+yPvR?=
 =?us-ascii?Q?oC6DmSdJ+pNf3u3vynq9OtfGzGjeOgIpP2WNBM9W35qpeQb+lij/5tUWyZok?=
 =?us-ascii?Q?oBCSFjk5c+TA1brk1BC1nWVSc8L9WXbnBgHT4+Y9xxDwrmbOc8ipZ/ltNXIR?=
 =?us-ascii?Q?L7KGYRtbMWVTRNW9tEmA0ccc+3WAiRuzgEBpehsMZ09XAOEdTWmUheh9Zwck?=
 =?us-ascii?Q?nhrfBJ2SVNrJCg2DuSngqxQA5xJRp1ejEsUEXLuDRhHtKXwpV8CrGzHfqkAv?=
 =?us-ascii?Q?iUuI6x0NbYXfb6V8gHtXSxSEp+x1GkQSl2WNHIgPPWkEBL9XyIMnNK5lP8R+?=
 =?us-ascii?Q?B0PWBRQeKYzUAPV8OBs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: in.bosch.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR10MB2325.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 22f2b716-35a7-44c3-93ef-08dac61ad256
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 08:32:52.6216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0ae51e19-07c8-4e4b-bb6d-648ee58410f4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RCnGI6dUo2cKKmrG/QwVoSgehpieztgrQopn4buhDod/HgGYcO3oFKhIOtjaB4eJZOKxfPJAVGV1KNjG4RtYUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3473
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zhang,

Thank you for the update and patch.

-----Original Message-----
From: Zhang Changzhong <zhangchangzhong@huawei.com>=20
Sent: 14 November 2022 13:45
To: Vincent Mailhol <mailhol.vincent@wanadoo.fr>; Wolfgang Grandegger <wg@g=
randegger.com>; EXTERNAL Kleine-Budde Marc (Pengutronix, XC-CT/ECP2) <mkl@p=
engutronix.de>; David S. Miller <davem@davemloft.net>; Eric Dumazet <edumaz=
et@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redha=
t.com>; Arunachalam Santhanam (MS/ETA-ETAS) <arunachalam.santhanam@in.bosch=
.com>
Cc: Zhang Changzhong <zhangchangzhong@huawei.com>; linux-can@vger.kernel.or=
g; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH v2] can: etas_es58x: free netdev when register_candev() fai=
led in es58x_init_netdev()

In case of register_candev() fails, clear es58x_dev->netdev[channel_idx] an=
d add free_candev(). Otherwise es58x_free_netdevs() will unregister the net=
dev that has never been registered.

Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN =
USB interfaces")
Signed-off-by: Zhang Changzhong <mailto:zhangchangzhong@huawei.com>
---
v1 -> v2: change to the correct 'Fixes' tag according to Vincent Mailhol

Acked-by: <arunachalam.santhanam@in.bosch.com>

 drivers/net/can/usb/etas_es58x/es58x_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/=
usb/etas_es58x/es58x_core.c
index 25f863b..ddb7c57 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2091,8 +2091,11 @@ static int es58x_init_netdev(struct es58x_device *es=
58x_dev, int channel_idx)
 	netdev->dev_port =3D channel_idx;
=20
 	ret =3D register_candev(netdev);
-	if (ret)
+	if (ret) {
+		es58x_dev->netdev[channel_idx] =3D NULL;
+		free_candev(netdev);
 		return ret;
+	}
=20
 	netdev_queue_set_dql_min_limit(netdev_get_tx_queue(netdev, 0),
 				       es58x_dev->param->dql_min_limit);
--
2.9.5

